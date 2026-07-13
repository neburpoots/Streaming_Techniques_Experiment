#!/usr/bin/env bash
set -euo pipefail

# ── Kubernetes test runner for gRPC streaming baseline ──
#
# Equivalent of run-matrix.ps1 but targeting a Kubernetes cluster.
# Runs the full benchmark matrix for a given preset, collecting
# application results and resource metrics via kubectl top.
#
# Usage:
#   ./run-k8s-matrix.sh <preset> [options]
#
# Presets:
#   synthetic-clean, csv-replay-check, synthetic-continuous,
#   synthetic-backpressure, synthetic-recovery, rabbitmq-smoke
#
# Options:
#   --overlay <name>    Kustomize overlay to use (default: resource-medium)
#   --repeat <n>        Number of repetitions per case (default: 1)
#   --transport <mode>  Transport filter: all, client-streaming, unary, batched-unary, rabbitmq-streams, nats-jetstream, kafka
#   --payload <bytes>   Payload-size filter for synthetic-clean
#   --concurrency <n>   Concurrency filter for presets with concurrency sweeps
#   --kind-cluster-name <name>
#                       Explicit kind cluster name for image loading
#   --skip-build        Skip container image build
#   --skip-load         Skip image load into cluster (kind)
#   --namespace <ns>    Kubernetes namespace (default: streaming-experiments)
#   --run-id-prefix <p> Prefix added to every run id and summary file
#   --help              Show usage

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="${RESULTS_DIR:-${ROOT}/results}"
STATS_SCRIPT="${ROOT}/scripts/collect-k8s-stats.sh"
EXPORT_SCRIPT="${ROOT}/scripts/export-results.ps1"
AGGREGATE_SCRIPT="${ROOT}/scripts/aggregate-repeat-results.ps1"

export PATH="/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

if ! command -v kubectl >/dev/null 2>&1 || ! kubectl version --client >/dev/null 2>&1; then
    if [[ -x "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" ]]; then
        kubectl() {
            "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" "$@"
        }
    fi
fi

# ── Defaults ──
PRESET=""
OVERLAY="resource-medium"
REPEAT=1
TRANSPORT_FILTER="all"
PAYLOAD_FILTER=""
CONCURRENCY_FILTER=""
SKIP_BUILD=false
SKIP_LOAD=false
NAMESPACE="streaming-experiments"
REPEAT_SUFFIX=""
RUN_ID_PREFIX=""
KIND_CLUSTER_NAME=""
STRICT_RESOURCE_VALIDATION="${STRICT_RESOURCE_VALIDATION:-false}"
# When true, a case that fails to produce artifacts is logged and skipped
# instead of aborting the whole preset (one flaky cell must not kill a campaign).
CONTINUE_ON_CASE_FAILURE="${CONTINUE_ON_CASE_FAILURE:-false}"
PRODUCER_TIMEOUT_SECONDS="${PRODUCER_TIMEOUT_SECONDS:-420s}"
EXPORT_TIMEOUT_SECONDS="${EXPORT_TIMEOUT_SECONDS:-900s}"
BATCHED_UNARY_BATCH_SIZE="${BATCHED_UNARY_BATCH_SIZE:-100}"
GRPC_MAX_MESSAGE_BYTES="${GRPC_MAX_MESSAGE_BYTES:-134217728}"
SYNTHETIC_CLEAN_TOTAL_MESSAGES="${SYNTHETIC_CLEAN_TOTAL_MESSAGES:-20000}"
NATS_STREAM_MIN_BYTES="${NATS_STREAM_MIN_BYTES:-536870912}"
KAFKA_RESTART_BROKER_PER_CASE="${KAFKA_RESTART_BROKER_PER_CASE:-true}"
SKIP_COMPLETED_CASES="${SKIP_COMPLETED_CASES:-false}"
ACTIVE_STATS_PID=""
ACTIVE_STATS_STOP_FILE=""
FAILURE_PID=""

# ── Parse arguments ──
while [[ $# -gt 0 ]]; do
    case "$1" in
        --overlay)    OVERLAY="$2"; shift 2 ;;
        --repeat)     REPEAT="$2"; shift 2 ;;
        --transport)  TRANSPORT_FILTER="$2"; shift 2 ;;
        --payload)    PAYLOAD_FILTER="$2"; shift 2 ;;
        --concurrency) CONCURRENCY_FILTER="$2"; shift 2 ;;
        --kind-cluster-name) KIND_CLUSTER_NAME="$2"; shift 2 ;;
        --skip-build) SKIP_BUILD=true; shift ;;
        --skip-load)  SKIP_LOAD=true; shift ;;
        --namespace)  NAMESPACE="$2"; shift 2 ;;
        --run-id-prefix) RUN_ID_PREFIX="$2"; shift 2 ;;
        --help)
            head -20 "$0" | tail -15
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            if [[ -z "${PRESET}" ]]; then
                PRESET="$1"
            else
                echo "Unexpected argument: $1" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ -z "${PRESET}" ]]; then
    echo "Usage: $0 <preset> [options]" >&2
    echo "Presets: synthetic-clean, csv-replay-check, synthetic-continuous, synthetic-backpressure, synthetic-recovery, rabbitmq-smoke" >&2
    exit 1
fi

mkdir -p "${RESULTS_DIR}"

validate_transport_filter() {
    case "${TRANSPORT_FILTER}" in
        all|client-streaming|unary|batched-unary|rabbitmq-streams|nats-jetstream|kafka) ;;
        *)
            echo "Invalid --transport value: ${TRANSPORT_FILTER}" >&2
            echo "Expected one of: all, client-streaming, unary, batched-unary, rabbitmq-streams, nats-jetstream, kafka" >&2
            exit 1
            ;;
    esac
}

selected_transport_modes() {
    case "${TRANSPORT_FILTER}" in
        all) echo "client-streaming unary batched-unary rabbitmq-streams nats-jetstream kafka" ;;
        *) echo "${TRANSPORT_FILTER}" ;;
    esac
}

matches_filter() {
    local value="$1"
    local filter="$2"
    [[ -z "${filter}" || "${value}" == "${filter}" ]]
}

validate_transport_filter

POWERSHELL_EXE="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

run_with_timeout() {
    local timeout_duration="$1"
    shift

    if command -v timeout >/dev/null 2>&1; then
        timeout "${timeout_duration}" "$@"
        return
    fi

    "$@"
}

cleanup_active_backgrounds() {
    if [[ -n "${ACTIVE_STATS_STOP_FILE}" ]]; then
        touch "${ACTIVE_STATS_STOP_FILE}" 2>/dev/null || true
    fi
    if [[ -n "${ACTIVE_STATS_PID}" ]] && kill -0 "${ACTIVE_STATS_PID}" 2>/dev/null; then
        kill "${ACTIVE_STATS_PID}" 2>/dev/null || true
        wait "${ACTIVE_STATS_PID}" 2>/dev/null || true
    fi
    if [[ -n "${FAILURE_PID}" ]] && kill -0 "${FAILURE_PID}" 2>/dev/null; then
        kill "${FAILURE_PID}" 2>/dev/null || true
        wait "${FAILURE_PID}" 2>/dev/null || true
    fi
}

trap cleanup_active_backgrounds EXIT INT TERM

kill_stale_stats_collectors() {
    local stale_pids=""
    stale_pids="$(pgrep -f "${STATS_SCRIPT}" 2>/dev/null || true)"
    if [[ -n "${stale_pids}" ]]; then
        echo "Stopping stale Kubernetes stats collector process(es): ${stale_pids}"
        pkill -f "${STATS_SCRIPT}" 2>/dev/null || true
    fi
}

run_export_powershell() {
    local script_path="$1"
    shift

    if command -v pwsh &>/dev/null; then
        run_with_timeout "${EXPORT_TIMEOUT_SECONDS}" pwsh -File "${script_path}" "$@"
        return
    fi

    if [[ -x "${POWERSHELL_EXE}" ]] && command -v wslpath &>/dev/null; then
        local windows_script
        windows_script="$(wslpath -w "${script_path}")"

        local translated_args=()
        local arg=""
        for arg in "$@"; do
            case "${arg}" in
                /*)
                    translated_args+=("$(wslpath -w "${arg}")")
                    ;;
                *)
                    translated_args+=("${arg}")
                    ;;
            esac
        done

        run_with_timeout "${EXPORT_TIMEOUT_SECONDS}" "${POWERSHELL_EXE}" -NoProfile -ExecutionPolicy Bypass -File "${windows_script}" "${translated_args[@]}"
        return
    fi

    return 1
}

# ── Image build and load ──

build_images() {
    echo "Building container images..."
    for svc in producer transformer sink; do
        docker build -t "grpc-streaming-baseline-${svc}:latest" \
            --build-arg SERVICE="${svc}" \
            -f "${ROOT}/Dockerfile" "${ROOT}"
    done
}

load_images_kind() {
    local kind_cluster_name="${KIND_CLUSTER_NAME}"

    if [[ -z "${kind_cluster_name}" ]]; then
        local current_context=""
        current_context="$(kubectl config current-context 2>/dev/null || true)"
        if [[ "${current_context}" == kind-* ]]; then
            kind_cluster_name="${current_context#kind-}"
        fi
    fi

    if [[ -z "${kind_cluster_name}" ]]; then
        echo "Skipping kind image load because the current context is not a kind cluster."
        return
    fi

    echo "Loading images into kind cluster ${kind_cluster_name}..."
    for svc in producer transformer sink; do
        kind load docker-image --name "${kind_cluster_name}" "grpc-streaming-baseline-${svc}:latest"
    done
}

if [[ "${SKIP_BUILD}" != "true" ]]; then
    build_images
fi

if [[ "${SKIP_LOAD}" != "true" ]]; then
    load_images_kind
fi

# ── Kustomize overlay path ──
OVERLAY_DIR="${ROOT}/k8s/overlays/${OVERLAY}"
if [[ ! -d "${OVERLAY_DIR}" ]]; then
    echo "Overlay directory not found: ${OVERLAY_DIR}" >&2
    echo "Available overlays:" >&2
    ls "${ROOT}/k8s/overlays/" >&2
    exit 1
fi

configure_overlay_runtime_defaults() {
    case "${OVERLAY}" in
        *kafka-cluster)
            export KAFKA_BROKERS="${KAFKA_BROKERS:-grpc-stream-kafka-0.grpc-stream-kafka-headless:9092,grpc-stream-kafka-1.grpc-stream-kafka-headless:9092,grpc-stream-kafka-2.grpc-stream-kafka-headless:9092}"
            export KAFKA_TOPIC_REPLICATION_FACTOR="${KAFKA_TOPIC_REPLICATION_FACTOR:-3}"
            ;;
        *nats-cluster)
            export NATS_URL="${NATS_URL:-nats://grpc-stream-nats-0.grpc-stream-nats-headless:4222,nats://grpc-stream-nats-1.grpc-stream-nats-headless:4222,nats://grpc-stream-nats-2.grpc-stream-nats-headless:4222}"
            export NATS_STREAM_REPLICAS="${NATS_STREAM_REPLICAS:-3}"
            ;;
    esac
}

configure_overlay_runtime_defaults

# ── Ensure namespace and base resources exist ──
ensure_base_resources() {
    # Apply namespace and PVC (idempotent)
    kubectl apply -f "${ROOT}/k8s/base/namespace.yaml"
    kubectl apply -f "${ROOT}/k8s/base/results-pvc.yaml"
}

cleanup_broker_overlay_conflicts() {
    local stale_resources=(
        deployment/grpc-stream-rabbitmq
        statefulset/grpc-stream-rabbitmq
        service/grpc-stream-rabbitmq-headless
        deployment/grpc-stream-nats
        statefulset/grpc-stream-nats
        service/grpc-stream-nats-headless
        deployment/grpc-stream-kafka
        statefulset/grpc-stream-kafka
        service/grpc-stream-kafka-headless
    )

    echo "Cleaning up broker workloads before applying overlay..."
    kubectl delete "${stale_resources[@]}" -n "${NAMESPACE}" --ignore-not-found=true >/dev/null 2>&1 || true
}

configure_kafka_broker() {
    if [[ -z "${KAFKA_BROKER_MESSAGE_MAX_BYTES:-}" ]]; then
        return 0
    fi

    kubectl set env deployment/grpc-stream-kafka -n "${NAMESPACE}" \
        KAFKA_MESSAGE_MAX_BYTES="${KAFKA_BROKER_MESSAGE_MAX_BYTES}" \
        KAFKA_REPLICA_FETCH_MAX_BYTES="${KAFKA_BROKER_MESSAGE_MAX_BYTES}" \
        >/dev/null
}

scale_workload_if_present() {
    local name="$1"
    local replicas="$2"

    if kubectl get deployment "${name}" -n "${NAMESPACE}" >/dev/null 2>&1; then
        kubectl scale deployment "${name}" -n "${NAMESPACE}" --replicas="${replicas}" >/dev/null
        return 0
    fi
    if kubectl get statefulset "${name}" -n "${NAMESPACE}" >/dev/null 2>&1; then
        kubectl scale statefulset "${name}" -n "${NAMESPACE}" --replicas="${replicas}" >/dev/null
        return 0
    fi

    return 0
}

scale_brokers_for_transport() {
    local transport_mode="$1"
    local rabbitmq_replicas=0
    local nats_replicas=0
    local kafka_replicas=0

    case "${transport_mode}" in
        rabbitmq-streams)
            rabbitmq_replicas=1
            ;;
        nats-jetstream)
            nats_replicas=1
            ;;
        kafka)
            kafka_replicas=1
            ;;
    esac

    scale_workload_if_present grpc-stream-rabbitmq "${rabbitmq_replicas}"
    scale_workload_if_present grpc-stream-nats "${nats_replicas}"
    scale_workload_if_present grpc-stream-kafka "${kafka_replicas}"
    if [[ "${transport_mode}" == "kafka" ]]; then
        scale_workload_if_present grpc-stream-transformer "${KAFKA_TRANSFORMER_REPLICAS:-1}"
    else
        scale_workload_if_present grpc-stream-transformer 1
    fi
}

# ── ConfigMap patching ──
nats_stream_max_bytes_for_case() {
    local total_messages="$1"
    local payload_bytes="$2"
    local concurrency="$3"

    if [[ -n "${NATS_STREAM_MAX_BYTES:-}" ]]; then
        echo "${NATS_STREAM_MAX_BYTES}"
        return
    fi

    local messages_per_worker=$(( (total_messages + concurrency - 1) / concurrency ))
    local estimated_bytes=$(( messages_per_worker * payload_bytes ))
    local cap_bytes=$(( estimated_bytes + (estimated_bytes / 2) ))

    if (( cap_bytes < NATS_STREAM_MIN_BYTES )); then
        cap_bytes="${NATS_STREAM_MIN_BYTES}"
    fi

    echo "${cap_bytes}"
}

patch_configmap() {
    local run_id="$1"
    local transport_mode="$2"
    local workload_source="$3"
    local profile="$4"
    local total_messages="$5"
    local payload_bytes="$6"
    local concurrency="$7"
    local target_mps="$8"
    local transformer_work="${9:-0}"
    local sink_delay="${10:-0}"
    local max_retry="${11:-0}"
    local retry_backoff="${12:-500}"
    local failure_action="${13:-}"
    local failure_target="${14:-}"
    local failure_after="${15:-0}"
    local dataset_files="${16:-}"
    local dataset_rows_per_msg="${17:-1}"
    local dataset_repeat="${18:-1}"
    local summary_poll="${19:-250}"
    local max_summary_wait="${20:-120}"
    local nats_stream_max_bytes
    nats_stream_max_bytes="$(nats_stream_max_bytes_for_case "${total_messages}" "${payload_bytes}" "${concurrency}")"

    kubectl create configmap grpc-streaming-baseline-config \
        -n "${NAMESPACE}" \
        --from-literal=RUN_ID="${run_id}" \
        --from-literal=TRANSPORT_MODE="${transport_mode}" \
        --from-literal=WORKLOAD_SOURCE="${workload_source}" \
        --from-literal=PROFILE="${profile}" \
        --from-literal=TOTAL_MESSAGES="${total_messages}" \
        --from-literal=PAYLOAD_BYTES="${payload_bytes}" \
        --from-literal=BATCHED_UNARY_BATCH_SIZE="${BATCHED_UNARY_BATCH_SIZE}" \
        --from-literal=GRPC_MAX_MESSAGE_BYTES="${GRPC_MAX_MESSAGE_BYTES}" \
        --from-literal=DATASET_DIR="/datasets" \
        --from-literal=DATASET_FILES="${dataset_files}" \
        --from-literal=DATASET_ROWS_PER_MESSAGE="${dataset_rows_per_msg}" \
        --from-literal=DATASET_REPEAT_COUNT="${dataset_repeat}" \
        --from-literal=CONCURRENCY="${concurrency}" \
        --from-literal=TARGET_MESSAGES_PER_SECOND="${target_mps}" \
        --from-literal=TRANSFORMER_WORK_ITERATIONS="${transformer_work}" \
        --from-literal=SINK_PROCESS_DELAY_MS="${sink_delay}" \
        --from-literal=SUMMARY_POLL_MILLISECONDS="${summary_poll}" \
        --from-literal=MAX_SUMMARY_WAIT_SECONDS="${MAX_SUMMARY_WAIT_OVERRIDE:-${max_summary_wait}}" \
        --from-literal=MAX_RETRY_ATTEMPTS="${max_retry}" \
        --from-literal=RETRY_BACKOFF_MS="${retry_backoff}" \
        --from-literal=FAILURE_ACTION="${failure_action}" \
        --from-literal=FAILURE_TARGET="${failure_target}" \
        --from-literal=FAILURE_AFTER_SECONDS="${failure_after}" \
        --from-literal=RABBITMQ_HOST="${RABBITMQ_HOST:-grpc-stream-rabbitmq}" \
        --from-literal=RABBITMQ_AMQP_PORT="${RABBITMQ_AMQP_PORT:-5672}" \
        --from-literal=RABBITMQ_STREAM_PORT="${RABBITMQ_STREAM_PORT:-5552}" \
        --from-literal=RABBITMQ_MANAGEMENT_PORT="${RABBITMQ_MANAGEMENT_PORT:-15672}" \
        --from-literal=RABBITMQ_USER="${RABBITMQ_USER:-guest}" \
        --from-literal=RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-guest}" \
        --from-literal=RABBITMQ_VHOST="${RABBITMQ_VHOST:-/}" \
        --from-literal=RABBITMQ_PRODUCER_TO_TRANSFORMER_STREAM="${RABBITMQ_PRODUCER_TO_TRANSFORMER_STREAM:-producer-to-transformer}" \
        --from-literal=RABBITMQ_TRANSFORMER_TO_SINK_STREAM="${RABBITMQ_TRANSFORMER_TO_SINK_STREAM:-transformer-to-sink}" \
        --from-literal=NATS_URL="${NATS_URL:-nats://grpc-stream-nats:4222}" \
        --from-literal=NATS_PRODUCER_TO_TRANSFORMER_SUBJECT="${NATS_PRODUCER_TO_TRANSFORMER_SUBJECT:-producer.to.transformer}" \
        --from-literal=NATS_TRANSFORMER_TO_SINK_SUBJECT="${NATS_TRANSFORMER_TO_SINK_SUBJECT:-transformer.to.sink}" \
        --from-literal=NATS_STREAM_REPLICAS="${NATS_STREAM_REPLICAS:-1}" \
        --from-literal=NATS_STREAM_MAX_BYTES="${nats_stream_max_bytes}" \
        --from-literal=NATS_ACK_WAIT_MS="${NATS_ACK_WAIT_MS:-120000}" \
        --from-literal=NATS_MAX_ACK_PENDING="${NATS_MAX_ACK_PENDING:-4096}" \
        --from-literal=NATS_FETCH_BATCH_SIZE="${NATS_FETCH_BATCH_SIZE:-64}" \
        --from-literal=NATS_FETCH_MAX_WAIT_MS="${NATS_FETCH_MAX_WAIT_MS:-500}" \
        --from-literal=KAFKA_BROKERS="${KAFKA_BROKERS:-grpc-stream-kafka:9092}" \
        --from-literal=KAFKA_PRODUCER_TO_TRANSFORMER_TOPIC="${KAFKA_PRODUCER_TO_TRANSFORMER_TOPIC:-producer-to-transformer}" \
        --from-literal=KAFKA_TRANSFORMER_TO_SINK_TOPIC="${KAFKA_TRANSFORMER_TO_SINK_TOPIC:-transformer-to-sink}" \
        --from-literal=KAFKA_TOPIC_PARTITIONS="${KAFKA_TOPIC_PARTITIONS:-16}" \
        --from-literal=KAFKA_TOPIC_REPLICATION_FACTOR="${KAFKA_TOPIC_REPLICATION_FACTOR:-1}" \
        --from-literal=KAFKA_BATCH_SIZE="${KAFKA_BATCH_SIZE:-256}" \
        --from-literal=KAFKA_BATCH_BYTES="${KAFKA_BATCH_BYTES:-1048576}" \
        --from-literal=KAFKA_BATCH_TIMEOUT_MS="${KAFKA_BATCH_TIMEOUT_MS:-5}" \
        --from-literal=KAFKA_COMMIT_INTERVAL_MS="${KAFKA_COMMIT_INTERVAL_MS:-250}" \
        --from-literal=KAFKA_QUEUE_CAPACITY="${KAFKA_QUEUE_CAPACITY:-512}" \
        --from-literal=KAFKA_FETCH_MIN_BYTES="${KAFKA_FETCH_MIN_BYTES:-65536}" \
        --from-literal=KAFKA_FETCH_MAX_BYTES="${KAFKA_FETCH_MAX_BYTES:-67108864}" \
        --from-literal=KAFKA_FETCH_MAX_WAIT_MS="${KAFKA_FETCH_MAX_WAIT_MS:-250}" \
        --from-literal=KAFKA_REQUIRED_ACKS="${KAFKA_REQUIRED_ACKS:-one}" \
        --from-literal=KAFKA_COMPRESSION="${KAFKA_COMPRESSION:-none}" \
        --from-literal=KAFKA_KEY_MODE="${KAFKA_KEY_MODE:-worker}" \
        --dry-run=client -o yaml | kubectl apply -f -
}

# ── Wait for deployments to be ready ──
workload_ref() {
    local name="$1"
    if kubectl get deployment "${name}" -n "${NAMESPACE}" >/dev/null 2>&1; then
        echo "deployment/${name}"
        return 0
    fi
    if kubectl get statefulset "${name}" -n "${NAMESPACE}" >/dev/null 2>&1; then
        echo "statefulset/${name}"
        return 0
    fi
    echo "Could not find deployment or statefulset ${name} in namespace ${NAMESPACE}." >&2
    return 1
}

rollout_status() {
    local name="$1"
    local timeout="$2"
    local ref
    ref="$(workload_ref "${name}")"
    kubectl rollout status "${ref}" -n "${NAMESPACE}" --timeout="${timeout}"
}

rollout_restart() {
    local name="$1"
    local ref
    ref="$(workload_ref "${name}")"
    kubectl rollout restart "${ref}" -n "${NAMESPACE}"
}

wait_for_rabbitmq_ready() {
    echo "  Waiting for RabbitMQ to be ready..."
    rollout_status grpc-stream-rabbitmq 600s

    local rabbitmq_pod=""
    for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
        rabbitmq_pod="$(kubectl get pods -n "${NAMESPACE}" -l app=grpc-stream-rabbitmq -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
        if [[ -n "${rabbitmq_pod}" ]] \
            && kubectl exec -n "${NAMESPACE}" "${rabbitmq_pod}" -- rabbitmq-diagnostics -q ping >/dev/null 2>&1 \
            && kubectl exec -n "${NAMESPACE}" "${rabbitmq_pod}" -- bash -ec '
                for _ in 1 2 3; do
                    rabbitmq-diagnostics -q listeners | grep -Eiq "port:[[:space:]]*5552" || exit 1
                    : > /dev/tcp/grpc-stream-rabbitmq/5552 || exit 1
                    sleep 1
                done
            ' >/dev/null 2>&1; then
            # The rollout becomes available before the stream listener is reliably
            # accepting connections from other pods, so give it a short settle window.
            sleep 8
            return 0
        fi
        sleep 2
    done

    echo "  Warning: RabbitMQ did not report ready state before the producer job started" >&2
}

assert_required_result_artifacts() {
    local run_id="$1"
    local missing=0
    local required_files=(
        "${RESULTS_DIR}/${run_id}-producer-result.json"
        "${RESULTS_DIR}/${run_id}-sink-summary.json"
    )
    local path=""

    for path in "${required_files[@]}"; do
        if [[ ! -f "${path}" ]]; then
            echo "  Warning: missing result artifact ${path}" >&2
            missing=1
        fi
    done

    if [[ "${missing}" -ne 0 ]]; then
        return 1
    fi

    return 0
}

wait_for_nats_ready() {
    echo "  Waiting for NATS to be ready..."
    rollout_status grpc-stream-nats 300s

    local nats_pod=""
    for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
        nats_pod="$(kubectl get pods -n "${NAMESPACE}" -l app=grpc-stream-nats -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
        if [[ -n "${nats_pod}" ]] \
            && kubectl exec -n "${NAMESPACE}" "${nats_pod}" -- sh -ec 'printf "INFO\r\n" | nc -w 2 127.0.0.1 4222 | grep -q "\"jetstream\":true"' >/dev/null 2>&1; then
            return 0
        fi
        sleep 2
    done

    echo "  Warning: NATS did not report JetStream ready state before the producer job started" >&2
}

wait_for_kafka_ready() {
    echo "  Waiting for Kafka to be ready..."
    rollout_status grpc-stream-kafka 600s
    local kafka_pod=""
    for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
        kafka_pod="$(kubectl get pods -n "${NAMESPACE}" -l app=grpc-stream-kafka -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
        if [[ -n "${kafka_pod}" ]] && kubectl exec -n "${NAMESPACE}" "${kafka_pod}" -- bash -ec 'unset JMX_PORT; /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list >/dev/null' >/dev/null 2>&1; then
            return 0
        fi
        sleep 3
    done
    echo "  Warning: Kafka did not report ready state before the producer job started" >&2
}

wait_for_ready() {
    local transport_mode="${1:-client-streaming}"
    echo "  Waiting for sink and transformer to be ready..."
    rollout_status grpc-stream-sink 120s
    rollout_status grpc-stream-transformer 120s
    if [[ "${transport_mode}" == "rabbitmq-streams" ]]; then
        wait_for_rabbitmq_ready
    elif [[ "${transport_mode}" == "nats-jetstream" ]]; then
        wait_for_nats_ready
    elif [[ "${transport_mode}" == "kafka" ]]; then
        wait_for_kafka_ready
    fi
    sleep 2
}

wait_for_broker_ready() {
    local transport_mode="${1:-client-streaming}"
    case "${transport_mode}" in
        rabbitmq-streams)
            wait_for_rabbitmq_ready
            ;;
        nats-jetstream)
            wait_for_nats_ready
            ;;
        kafka)
            wait_for_kafka_ready
            ;;
    esac
}

# ── Restart deployments to pick up new ConfigMap values ──
restart_deployments() {
    local transport_mode="${1:-client-streaming}"
    case "${transport_mode}" in
        rabbitmq-streams)
            rollout_restart grpc-stream-rabbitmq
            wait_for_rabbitmq_ready
            ;;
        nats-jetstream)
            kubectl delete pod -n "${NAMESPACE}" -l app=grpc-stream-nats \
                --wait=true \
                --timeout=120s \
                >/dev/null 2>&1 || true
            rollout_status grpc-stream-nats 120s
            wait_for_nats_ready
            ;;
        kafka)
            if [[ "${KAFKA_RESTART_BROKER_PER_CASE}" == "true" ]]; then
                rollout_restart grpc-stream-kafka
            fi
            wait_for_kafka_ready
            ;;
    esac
    rollout_restart grpc-stream-sink
    rollout_restart grpc-stream-transformer
    echo "  Waiting for sink and transformer to be ready..."
    rollout_status grpc-stream-sink 120s
    rollout_status grpc-stream-transformer 120s
    wait_for_broker_ready "${transport_mode}"
    sleep 2
}

wait_for_metrics_ready() {
    local top_output=""
    for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
        top_output="$(kubectl top pods -n "${NAMESPACE}" --no-headers 2>/dev/null || true)"
        if grep -q 'grpc-stream-sink' <<< "${top_output}" && grep -q 'grpc-stream-transformer' <<< "${top_output}"; then
            return 0
        fi
        sleep 2
    done

    echo "  Warning: metrics-server did not report sink/transformer pod metrics before the run started" >&2
}

wait_for_producer_metrics() {
    local top_output=""
    local producer_pod=""

    for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
        producer_pod="$(kubectl get pods -n "${NAMESPACE}" -l job-name=grpc-stream-producer -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
        if [[ -n "${producer_pod}" ]]; then
            top_output="$(kubectl top pods -n "${NAMESPACE}" --no-headers 2>/dev/null || true)"
            if grep -q "^${producer_pod}[[:space:]]" <<< "${top_output}"; then
                return 0
            fi
        fi
        sleep 1
    done

    echo "  Warning: metrics-server did not report producer pod metrics during the run startup window" >&2
}

wait_for_stats_samples() {
    local stats_file="$1"
    shift
    local required_roles=("$@")
    local role=""

    for attempt in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
        local all_present=true
        for role in "${required_roles[@]}"; do
            if ! stats_file_has_role_samples "${stats_file}" "${role}"; then
                all_present=false
                break
            fi
        done

        if [[ "${all_present}" == "true" ]]; then
            return 0
        fi

        sleep 1
    done

    echo "  Warning: stats collector did not capture required pre-run samples (${required_roles[*]}) before producer launch" >&2
    return 1
}

required_resource_roles() {
    local transport_mode="$1"
    local target_mps="$2"
    local failure_after="$3"
    local roles=(transformer sink)

    case "${transport_mode}" in
        rabbitmq-streams)
            roles+=(rabbitmq)
            ;;
        nats-jetstream)
            roles+=(nats)
            ;;
        kafka)
            roles+=(kafka)
            ;;
    esac

    if [[ "${target_mps}" != "0" || "${failure_after}" != "0" ]]; then
        roles+=(producer)
    fi

    printf '%s\n' "${roles[@]}"
}

stats_file_has_role_samples() {
    local stats_file="$1"
    local role="$2"

    if [[ ! -f "${stats_file}" ]]; then
        return 1
    fi

    case "${role}" in
        producer)
            grep -Eq '"Role":"producer"|"Name":"grpc-stream-producer|"Name":"grpc-streaming-baseline-producer-' "${stats_file}"
            ;;
        transformer)
            grep -Eq '"Role":"transformer"|"Name":"grpc-stream-transformer|"Name":"grpc-streaming-baseline-transformer-' "${stats_file}"
            ;;
        sink)
            grep -Eq '"Role":"sink"|"Name":"grpc-stream-sink|"Name":"grpc-streaming-baseline-sink-' "${stats_file}"
            ;;
        rabbitmq)
            grep -Eq '"Role":"rabbitmq"|"Name":"grpc-stream-rabbitmq|"Name":"grpc-streaming-baseline-rabbitmq-' "${stats_file}"
            ;;
        nats)
            grep -Eq '"Role":"nats"|"Name":"grpc-stream-nats|"Name":"grpc-streaming-baseline-nats-' "${stats_file}"
            ;;
        kafka)
            grep -Eq '"Role":"kafka"|"Name":"grpc-stream-kafka|"Name":"grpc-streaming-baseline-kafka-' "${stats_file}"
            ;;
        *)
            return 1
            ;;
    esac
}

validate_stats_artifact() {
    local run_id="$1"
    local transport_mode="$2"
    local target_mps="$3"
    local failure_after="$4"
    local stats_file="$5"
    local validation_file="${stats_file%.ndjson}-validation.txt"
    mapfile -t required_roles < <(required_resource_roles "${transport_mode}" "${target_mps}" "${failure_after}")
    local missing_roles=()
    local role=""

    rm -f "${validation_file}"

    for role in "${required_roles[@]}"; do
        if ! stats_file_has_role_samples "${stats_file}" "${role}"; then
            missing_roles+=("${role}")
        fi
    done

    if [[ "${#missing_roles[@]}" -eq 0 ]]; then
        printf 'resource_stats_valid=true\n' > "${validation_file}"
        return 0
    fi

    printf 'resource_stats_valid=false\nmissing_roles=%s\n' "$(IFS=,; echo "${missing_roles[*]}")" > "${validation_file}"
    echo "  Warning: incomplete resource samples for ${run_id} (missing: $(IFS=,; echo "${missing_roles[*]}") )" >&2
    return 1
}

delete_producer_job() {
    kubectl delete job grpc-stream-producer \
        -n "${NAMESPACE}" \
        --ignore-not-found=true \
        --wait=true \
        --timeout=120s \
        >/dev/null 2>&1 || true

    for _ in 1 2 3 4 5 6 7 8 9 10; do
        if ! kubectl get job grpc-stream-producer -n "${NAMESPACE}" >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done

    echo "Producer job still exists after delete wait in namespace ${NAMESPACE}." >&2
    return 1
}

apply_producer_job() {
    kubectl kustomize "${OVERLAY_DIR}" |
        awk 'BEGIN { RS="---"; ORS="---\n" } /kind:[[:space:]]*Job/ { print $0 }' |
        kubectl apply -f -
}

# ── Collect results from PVC via a temporary pod ──
copy_results_from_pvc() {
    local run_id="$1"

    local sink_pod=""
    for _ in 1 2 3 4 5 6 7 8 9 10; do
        sink_pod="$(kubectl get pods -n "${NAMESPACE}" -l app=grpc-stream-sink -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
        if [[ -n "${sink_pod}" ]]; then
            break
        fi
        sleep 1
    done

    if [[ -z "${sink_pod}" ]]; then
        echo "Could not find sink pod to collect results for ${run_id}." >&2
        return 1
    fi

    # Copy result files matching this run
    for suffix in producer-result.json sink-summary.json sink-analysis.json nats-delivery-diagnostics.json transformer-nats-delivery-diagnostics.json; do
        local remote_path="/results/${run_id}-${suffix}"
        local local_path="${RESULTS_DIR}/${run_id}-${suffix}"
        local copied=false
        for attempt in 1 2 3 4 5; do
            if kubectl exec -n "${NAMESPACE}" "${sink_pod}" -c sink -- test -f "${remote_path}" 2>/dev/null; then
                kubectl cp -c sink "${NAMESPACE}/${sink_pod}:${remote_path}" "${local_path}" 2>/dev/null || true
                if [[ -f "${local_path}" ]]; then
                    copied=true
                    break
                fi
            fi
            sleep 1
        done
        if [[ "${copied}" != "true" ]]; then
            echo "  Warning: missing result artifact ${remote_path}" >&2
        fi
    done
}

# ── Failure injection ──
inject_failure() {
    local action="$1"
    local target="$2"
    local delay_seconds="$3"

    if [[ -z "${action}" || -z "${target}" || "${delay_seconds}" -le 0 ]]; then
        return
    fi

    (
        sleep "${delay_seconds}"
        case "${action}" in
            restart)
                echo "  Injecting failure: restarting ${target}..."
                kubectl delete pod -l "app=grpc-stream-${target}" -n "${NAMESPACE}" --grace-period=1
                ;;
            *)
                echo "  Unknown failure action: ${action}" >&2
                ;;
        esac
    ) &
    FAILURE_PID=$!
}

# ── Run a single test case ──
run_case() {
    local run_id="$1"
    local transport_mode="$2"
    local workload_source="$3"
    local profile="$4"
    local total_messages="$5"
    local payload_bytes="$6"
    local concurrency="$7"
    local target_mps="$8"
    local transformer_work="${9:-0}"
    local sink_delay="${10:-0}"
    local max_retry="${11:-0}"
    local retry_backoff="${12:-500}"
    local failure_action="${13:-}"
    local failure_target="${14:-}"
    local failure_after="${15:-0}"
    local dataset_files="${16:-}"
    local dataset_rows_per_msg="${17:-1}"
    local dataset_repeat="${18:-1}"
    local effective_run_id="${RUN_ID_PREFIX}${run_id}${REPEAT_SUFFIX}"

    if [[ "${SKIP_COMPLETED_CASES}" == "true" ]] \
        && [[ -f "${RESULTS_DIR}/${effective_run_id}-producer-result.json" ]] \
        && [[ -f "${RESULTS_DIR}/${effective_run_id}-sink-summary.json" ]]; then
        echo "  Skipping completed case: ${effective_run_id}"
        return 0
    fi

    # Time-boxed campaigns: once the deadline passes, skip remaining cases
    # instead of starting new multi-minute runs.
    if [[ -n "${CASE_DEADLINE_EPOCH:-}" ]] && (( $(date +%s) > CASE_DEADLINE_EPOCH )); then
        echo "  Skipping case (campaign deadline passed): ${effective_run_id}"
        return 0
    fi

    echo "━━━ Running: ${effective_run_id} ━━━"

    # 1. Patch ConfigMap with this run's parameters
    patch_configmap "${effective_run_id}" "${transport_mode}" "${workload_source}" "${profile}" \
        "${total_messages}" "${payload_bytes}" "${concurrency}" "${target_mps}" \
        "${transformer_work}" "${sink_delay}" "${max_retry}" "${retry_backoff}" \
        "${failure_action}" "${failure_target}" "${failure_after}" \
        "${dataset_files}" "${dataset_rows_per_msg}" "${dataset_repeat}"

    # 2. Keep only the active broker family running, then restart workloads.
    scale_brokers_for_transport "${transport_mode}"
    restart_deployments "${transport_mode}"
    wait_for_metrics_ready

    # 3. Delete any previous producer job
    delete_producer_job

    # 4. Start resource stats collection
    local stats_file="${RESULTS_DIR}/${effective_run_id}-k8s-stats.ndjson"
    local stop_file="${RESULTS_DIR}/${effective_run_id}-stop.txt"
    rm -f "${stats_file}" "${stop_file}"

    NAMESPACE="${NAMESPACE}" INTERVAL_SECONDS=1 ACTIVE_TRANSPORT_MODE="${transport_mode}" STOP_FILE="${stop_file}" \
        bash "${STATS_SCRIPT}" "${stats_file}" &
    local stats_pid=$!
    ACTIVE_STATS_PID="${stats_pid}"
    ACTIVE_STATS_STOP_FILE="${stop_file}"

    mapfile -t required_roles < <(required_resource_roles "${transport_mode}" "${target_mps}" "${failure_after}")
    local prerun_roles=()
    local role=""
    for role in "${required_roles[@]}"; do
        if [[ "${role}" != "producer" ]]; then
            prerun_roles+=("${role}")
        fi
    done

    if [[ "${#prerun_roles[@]}" -gt 0 ]]; then
        wait_for_stats_samples "${stats_file}" "${prerun_roles[@]}" || true
    fi

    # 5. Start failure injection if configured
    FAILURE_PID=""
    inject_failure "${failure_action}" "${failure_target}" "${failure_after}"

    # 6. Create and run the producer job
    apply_producer_job
    if [[ "${target_mps}" != "0" || "${failure_after}" != "0" ]]; then
        wait_for_producer_metrics
    fi
    echo "  Waiting for producer job to complete..."
    if ! run_with_timeout "${PRODUCER_TIMEOUT_SECONDS}" kubectl wait --for=condition=Complete job/grpc-stream-producer \
            -n "${NAMESPACE}" --timeout="${PRODUCER_TIMEOUT_SECONDS}" 2>/dev/null; then
        echo "  Warning: Producer job did not complete within timeout" >&2
        kubectl logs job/grpc-stream-producer -n "${NAMESPACE}" --tail=20 2>/dev/null || true
    fi

    # 7. Stop stats collection
    touch "${stop_file}"
    wait "${stats_pid}" 2>/dev/null || true
    rm -f "${stop_file}"
    ACTIVE_STATS_PID=""
    ACTIVE_STATS_STOP_FILE=""

    # Wait for failure injection to finish
    if [[ -n "${FAILURE_PID}" ]]; then
        wait "${FAILURE_PID}" 2>/dev/null || true
        FAILURE_PID=""
    fi

    # 8. Copy results from PVC
    copy_results_from_pvc "${effective_run_id}"

    if ! assert_required_result_artifacts "${effective_run_id}"; then
        if [[ "${CONTINUE_ON_CASE_FAILURE}" == "true" ]]; then
            echo "  CASE FAILED (missing artifacts), continuing: ${effective_run_id}" >&2
            delete_producer_job
            return 0
        fi
        echo "  Aborting because required result artifacts are missing" >&2
        return 1
    fi

    if ! validate_stats_artifact "${effective_run_id}" "${transport_mode}" "${target_mps}" "${failure_after}" "${stats_file}"; then
        if [[ "${STRICT_RESOURCE_VALIDATION}" == "true" ]]; then
            echo "  Aborting because STRICT_RESOURCE_VALIDATION=true" >&2
            return 1
        fi
    fi

    # 9. Clean up producer job (keep deployments for next run)
    delete_producer_job

    echo "  Done: ${effective_run_id}"
}

# ── Matrix definitions (matching run-matrix.ps1) ──

run_synthetic_clean() {
    for transport_mode in $(selected_transport_modes); do
        local ts; ts=$(transport_short "${transport_mode}")
        for payload in 256 1024 4096 16384; do
            matches_filter "${payload}" "${PAYLOAD_FILTER}" || continue
            for conc in 1 4 8 16; do
                matches_filter "${conc}" "${CONCURRENCY_FILTER}" || continue
                run_case "synthetic-clean-${ts}-p${payload}-c${conc}" \
                    "${transport_mode}" "synthetic" "bulk" "${SYNTHETIC_CLEAN_TOTAL_MESSAGES}" "${payload}" "${conc}" "0"
            done
        done
    done
}

run_csv_replay_check() {
    for transport_mode in $(selected_transport_modes); do
        local ts; ts=$(transport_short "${transport_mode}")
        for rows in 25 100; do
            for conc in 1 8; do
                run_case "csv-replay-check-${ts}-r${rows}-c${conc}" \
                    "${transport_mode}" "csv-replay" "bulk" "10000" "1024" "${conc}" "0" \
                    "0" "0" "0" "500" "" "" "0" \
                    "Personen_test.csv,Aanstellingen_test.csv" "${rows}" "10"
            done
        done
    done
}

run_synthetic_continuous() {
    for transport_mode in $(selected_transport_modes); do
        local ts; ts=$(transport_short "${transport_mode}")
        for conc in 4 8; do
            matches_filter "${conc}" "${CONCURRENCY_FILTER}" || continue
            run_case "synthetic-continuous-${ts}-p1024-c${conc}" \
                "${transport_mode}" "synthetic" "continuous" "20000" "1024" "${conc}" "1000"
        done
    done
}

run_synthetic_backpressure() {
    for transport_mode in $(selected_transport_modes); do
        local ts; ts=$(transport_short "${transport_mode}")
        run_case "synthetic-backpressure-${ts}-p1024-c8" \
            "${transport_mode}" "synthetic" "continuous" "20000" "1024" "8" "4000" \
            "0" "2"
    done
}

run_synthetic_recovery() {
    for transport_mode in $(selected_transport_modes); do
        local ts; ts=$(transport_short "${transport_mode}")
        run_case "synthetic-recovery-${ts}-p4096-c8" \
            "${transport_mode}" "synthetic" "continuous" "50000" "4096" "8" "2000" \
            "0" "0" "120" "250" "restart" "transformer" "3"
    done
}

run_rabbitmq_smoke() {
    run_case "rabbitmq-smoke-rmqs-p1024-c4" \
        "rabbitmq-streams" "synthetic" "continuous" "4000" "1024" "4" "500" \
        "0" "0" "5" "500" "" "" "0"
}

transport_short() {
    case "$1" in
        client-streaming) echo "stream" ;;
        unary) echo "unary" ;;
        batched-unary) echo "bunary" ;;
        rabbitmq-streams) echo "rmqs" ;;
        nats-jetstream) echo "nats" ;;
        kafka) echo "kafka" ;;
        *) echo "$1" ;;
    esac
}

# ── Main ──

kill_stale_stats_collectors
ensure_base_resources

# Upload CSV datasets as a ConfigMap if needed for csv-replay presets
if [[ "${PRESET}" == "csv-replay-check" ]]; then
    DATASETS_DIR="${ROOT}/../../datasets"
    if [[ -d "${DATASETS_DIR}" ]]; then
        echo "Creating datasets ConfigMap..."
        DATASET_PERSONEN_SOURCE="${DATASETS_DIR}/Personen_test.csv"
        DATASET_AANSTELLINGEN_SOURCE="${DATASETS_DIR}/Aanstellingen_test.csv"
        if [[ ! -f "${DATASET_PERSONEN_SOURCE}" || ! -f "${DATASET_AANSTELLINGEN_SOURCE}" ]]; then
            echo "Warning: test CSV datasets not found; falling back to full datasets" >&2
            DATASET_PERSONEN_SOURCE="${DATASETS_DIR}/Personen.csv"
            DATASET_AANSTELLINGEN_SOURCE="${DATASETS_DIR}/Aanstellingen.csv"
        fi

        DATASET_TMP_DIR="$(mktemp -d)"
        DATASET_PERSONEN="${DATASET_TMP_DIR}/Personen_test.csv"
        DATASET_AANSTELLINGEN="${DATASET_TMP_DIR}/Aanstellingen_test.csv"
        set +o pipefail
        tr '\r' '\n' < "${DATASET_PERSONEN_SOURCE}" | head -n 2501 > "${DATASET_PERSONEN}"
        tr '\r' '\n' < "${DATASET_AANSTELLINGEN_SOURCE}" | head -n 2501 > "${DATASET_AANSTELLINGEN}"
        set -o pipefail

        kubectl delete configmap experiment-datasets -n "${NAMESPACE}" --ignore-not-found=true >/dev/null 2>&1 || true
        kubectl create configmap experiment-datasets \
            -n "${NAMESPACE}" \
            --from-file="${DATASET_PERSONEN}" \
            --from-file="${DATASET_AANSTELLINGEN}"

        rm -rf "${DATASET_TMP_DIR}"
    else
        echo "Warning: datasets directory not found at ${DATASETS_DIR}" >&2
    fi
fi

# Apply the overlay to create/update deployments and services
cleanup_broker_overlay_conflicts
kubectl apply -k "${OVERLAY_DIR}"
configure_kafka_broker

# Delete producer job so it does not block the first run
delete_producer_job

wait_for_ready

echo "Starting preset: ${PRESET} (overlay: ${OVERLAY}, repeat: ${REPEAT}, transport: ${TRANSPORT_FILTER})"

for ((r = 1; r <= REPEAT; r++)); do
    if [[ "${REPEAT}" -gt 1 ]]; then
        echo "═══ Repetition ${r}/${REPEAT} ═══"
        REPEAT_SUFFIX="-rep${r}"
    else
        # FORCED_REP_SUFFIX lets gap-fill runs reuse an existing rep label
        # (e.g. "-rep1") so filled cells merge into a previous campaign.
        REPEAT_SUFFIX="${FORCED_REP_SUFFIX:-}"
    fi

    case "${PRESET}" in
        synthetic-clean)       run_synthetic_clean ;;
        csv-replay-check)      run_csv_replay_check ;;
        synthetic-continuous)  run_synthetic_continuous ;;
        synthetic-backpressure) run_synthetic_backpressure ;;
        synthetic-recovery)    run_synthetic_recovery ;;
        rabbitmq-smoke)        run_rabbitmq_smoke ;;
        *)
            echo "Unknown preset: ${PRESET}" >&2
            exit 1
            ;;
    esac
done

# Export summary CSV
summary_prefix="${RUN_ID_PREFIX}${PRESET}"

echo "Exporting summary CSV..."
if run_export_powershell "${EXPORT_SCRIPT}" \
    -ResultsDir "${RESULTS_DIR}" \
    -RunIdPrefix "${summary_prefix}" \
    -OutputPath "${RESULTS_DIR}/${summary_prefix}-summary.csv"; then
    if [[ -f "${RESULTS_DIR}/${summary_prefix}-summary.csv" ]]; then
        invalid_resource_rows="$(tail -n +2 "${RESULTS_DIR}/${summary_prefix}-summary.csv" | grep -c '"False"' || true)"
        if [[ "${invalid_resource_rows}" -gt 0 ]]; then
            echo "Warning: ${invalid_resource_rows} row(s) in ${summary_prefix}-summary.csv have incomplete resource samples." >&2
        fi
    fi
    if [[ "${REPEAT}" -gt 1 && -f "${AGGREGATE_SCRIPT}" ]]; then
        run_export_powershell "${AGGREGATE_SCRIPT}" \
            -SummaryPath "${RESULTS_DIR}/${summary_prefix}-summary.csv" \
            -OutputPath "${RESULTS_DIR}/${summary_prefix}-summary-aggregated.csv"
    fi
else
    echo "PowerShell not found; skipping CSV export."
    echo "Run manually with pwsh or powershell.exe for ${EXPORT_SCRIPT}"
fi

echo "Finished preset: ${PRESET}"
