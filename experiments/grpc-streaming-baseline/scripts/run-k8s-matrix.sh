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
#   synthetic-backpressure, synthetic-recovery
#
# Options:
#   --overlay <name>    Kustomize overlay to use (default: resource-medium)
#   --repeat <n>        Number of repetitions per case (default: 1)
#   --skip-build        Skip container image build
#   --skip-load         Skip image load into cluster (kind)
#   --namespace <ns>    Kubernetes namespace (default: streaming-experiments)
#   --help              Show usage

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RESULTS_DIR="${ROOT}/results"
STATS_SCRIPT="${ROOT}/scripts/collect-k8s-stats.sh"
EXPORT_SCRIPT="${ROOT}/scripts/export-results.ps1"
AGGREGATE_SCRIPT="${ROOT}/scripts/aggregate-repeat-results.ps1"

# ── Defaults ──
PRESET=""
OVERLAY="resource-medium"
REPEAT=1
SKIP_BUILD=false
SKIP_LOAD=false
NAMESPACE="streaming-experiments"
REPEAT_SUFFIX=""

# ── Parse arguments ──
while [[ $# -gt 0 ]]; do
    case "$1" in
        --overlay)    OVERLAY="$2"; shift 2 ;;
        --repeat)     REPEAT="$2"; shift 2 ;;
        --skip-build) SKIP_BUILD=true; shift ;;
        --skip-load)  SKIP_LOAD=true; shift ;;
        --namespace)  NAMESPACE="$2"; shift 2 ;;
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
    echo "Presets: synthetic-clean, csv-replay-check, synthetic-continuous, synthetic-backpressure, synthetic-recovery" >&2
    exit 1
fi

mkdir -p "${RESULTS_DIR}"

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
    echo "Loading images into kind cluster..."
    for svc in producer transformer sink; do
        kind load docker-image "grpc-streaming-baseline-${svc}:latest" 2>/dev/null || true
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

# ── Ensure namespace and base resources exist ──
ensure_base_resources() {
    # Apply namespace and PVC (idempotent)
    kubectl apply -f "${ROOT}/k8s/base/namespace.yaml"
    kubectl apply -f "${ROOT}/k8s/base/results-pvc.yaml"
}

# ── ConfigMap patching ──
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

    kubectl create configmap grpc-streaming-baseline-config \
        -n "${NAMESPACE}" \
        --from-literal=RUN_ID="${run_id}" \
        --from-literal=TRANSPORT_MODE="${transport_mode}" \
        --from-literal=WORKLOAD_SOURCE="${workload_source}" \
        --from-literal=PROFILE="${profile}" \
        --from-literal=TOTAL_MESSAGES="${total_messages}" \
        --from-literal=PAYLOAD_BYTES="${payload_bytes}" \
        --from-literal=DATASET_DIR="/datasets" \
        --from-literal=DATASET_FILES="${dataset_files}" \
        --from-literal=DATASET_ROWS_PER_MESSAGE="${dataset_rows_per_msg}" \
        --from-literal=DATASET_REPEAT_COUNT="${dataset_repeat}" \
        --from-literal=CONCURRENCY="${concurrency}" \
        --from-literal=TARGET_MESSAGES_PER_SECOND="${target_mps}" \
        --from-literal=TRANSFORMER_WORK_ITERATIONS="${transformer_work}" \
        --from-literal=SINK_PROCESS_DELAY_MS="${sink_delay}" \
        --from-literal=SUMMARY_POLL_MILLISECONDS="${summary_poll}" \
        --from-literal=MAX_SUMMARY_WAIT_SECONDS="${max_summary_wait}" \
        --from-literal=MAX_RETRY_ATTEMPTS="${max_retry}" \
        --from-literal=RETRY_BACKOFF_MS="${retry_backoff}" \
        --from-literal=FAILURE_ACTION="${failure_action}" \
        --from-literal=FAILURE_TARGET="${failure_target}" \
        --from-literal=FAILURE_AFTER_SECONDS="${failure_after}" \
        --dry-run=client -o yaml | kubectl apply -f -
}

# ── Wait for deployments to be ready ──
wait_for_ready() {
    echo "  Waiting for sink and transformer to be ready..."
    kubectl rollout status deployment/grpc-stream-sink -n "${NAMESPACE}" --timeout=120s
    kubectl rollout status deployment/grpc-stream-transformer -n "${NAMESPACE}" --timeout=120s
    # Additional health check via port-forward is not needed; rollout status confirms readiness
    sleep 2
}

# ── Restart deployments to pick up new ConfigMap values ──
restart_deployments() {
    kubectl rollout restart deployment/grpc-stream-sink -n "${NAMESPACE}"
    kubectl rollout restart deployment/grpc-stream-transformer -n "${NAMESPACE}"
    wait_for_ready
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

apply_producer_job() {
    kubectl kustomize "${OVERLAY_DIR}" |
        awk 'BEGIN { RS="---"; ORS="---\n" } /kind:[[:space:]]*Job/ { print $0 }' |
        kubectl apply -f -
}

# ── Collect results from PVC via a temporary pod ──
copy_results_from_pvc() {
    local run_id="$1"

    # Create a temporary pod to access the PVC
    local helper_pod="results-helper-${run_id//[^a-zA-Z0-9-]/-}"
    kubectl run "${helper_pod}" -n "${NAMESPACE}" \
        --image=busybox:latest \
        --restart=Never \
        --overrides='{
            "spec": {
                "containers": [{
                    "name": "helper",
                    "image": "busybox:latest",
                    "command": ["sleep", "3600"],
                    "volumeMounts": [{
                        "name": "results",
                        "mountPath": "/results"
                    }]
                }],
                "volumes": [{
                    "name": "results",
                    "persistentVolumeClaim": {
                        "claimName": "experiment-results"
                    }
                }]
            }
        }' \
        2>/dev/null

    kubectl wait --for=condition=Ready pod/"${helper_pod}" -n "${NAMESPACE}" --timeout=60s

    # Copy result files matching this run
    for suffix in producer-result.json sink-summary.json; do
        local remote_path="/results/${run_id}-${suffix}"
        local local_path="${RESULTS_DIR}/${run_id}-${suffix}"
        local copied=false
        for attempt in 1 2 3 4 5; do
            if kubectl exec -n "${NAMESPACE}" "${helper_pod}" -- test -f "${remote_path}" 2>/dev/null; then
                kubectl cp "${NAMESPACE}/${helper_pod}:${remote_path}" "${local_path}" 2>/dev/null || true
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

    # Clean up helper pod
    kubectl delete pod "${helper_pod}" -n "${NAMESPACE}" --grace-period=0 --force 2>/dev/null || true
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
    local effective_run_id="${run_id}${REPEAT_SUFFIX}"

    echo "━━━ Running: ${effective_run_id} ━━━"

    # 1. Patch ConfigMap with this run's parameters
    patch_configmap "${effective_run_id}" "${transport_mode}" "${workload_source}" "${profile}" \
        "${total_messages}" "${payload_bytes}" "${concurrency}" "${target_mps}" \
        "${transformer_work}" "${sink_delay}" "${max_retry}" "${retry_backoff}" \
        "${failure_action}" "${failure_target}" "${failure_after}" \
        "${dataset_files}" "${dataset_rows_per_msg}" "${dataset_repeat}"

    # 2. Restart deployments to pick up new ConfigMap
    restart_deployments
    wait_for_metrics_ready

    # 3. Delete any previous producer job
    kubectl delete job grpc-stream-producer -n "${NAMESPACE}" --ignore-not-found=true 2>/dev/null

    # 4. Start resource stats collection
    local stats_file="${RESULTS_DIR}/${effective_run_id}-k8s-stats.ndjson"
    local stop_file="${RESULTS_DIR}/${effective_run_id}-stop.txt"
    rm -f "${stats_file}" "${stop_file}"

    NAMESPACE="${NAMESPACE}" STOP_FILE="${stop_file}" \
        bash "${STATS_SCRIPT}" "${stats_file}" &
    local stats_pid=$!

    # 5. Start failure injection if configured
    FAILURE_PID=""
    inject_failure "${failure_action}" "${failure_target}" "${failure_after}"

    # 6. Create and run the producer job
    apply_producer_job
    echo "  Waiting for producer job to complete..."
    if ! kubectl wait --for=condition=Complete job/grpc-stream-producer \
            -n "${NAMESPACE}" --timeout=300s 2>/dev/null; then
        echo "  Warning: Producer job did not complete within timeout" >&2
        kubectl logs job/grpc-stream-producer -n "${NAMESPACE}" --tail=20 2>/dev/null || true
    fi

    # 7. Stop stats collection
    touch "${stop_file}"
    wait "${stats_pid}" 2>/dev/null || true
    rm -f "${stop_file}"

    # Wait for failure injection to finish
    if [[ -n "${FAILURE_PID}" ]]; then
        wait "${FAILURE_PID}" 2>/dev/null || true
    fi

    # 8. Copy results from PVC
    copy_results_from_pvc "${effective_run_id}"

    # 9. Clean up producer job (keep deployments for next run)
    kubectl delete job grpc-stream-producer -n "${NAMESPACE}" --ignore-not-found=true 2>/dev/null

    echo "  Done: ${effective_run_id}"
}

# ── Matrix definitions (matching run-matrix.ps1) ──

run_synthetic_clean() {
    for transport_mode in client-streaming unary; do
        local ts; ts=$(transport_short "${transport_mode}")
        for payload in 256 1024 4096 16384; do
            for conc in 1 4 8 16; do
                run_case "synthetic-clean-${ts}-p${payload}-c${conc}" \
                    "${transport_mode}" "synthetic" "bulk" "20000" "${payload}" "${conc}" "0"
            done
        done
    done
}

run_csv_replay_check() {
    for transport_mode in client-streaming unary; do
        local ts; ts=$(transport_short "${transport_mode}")
        for rows in 25 100; do
            for conc in 1 8; do
                run_case "csv-replay-check-${ts}-r${rows}-c${conc}" \
                    "${transport_mode}" "csv-replay" "bulk" "10000" "1024" "${conc}" "0" \
                    "0" "0" "0" "500" "" "" "0" \
                    "Personen.csv,Aanstellingen.csv" "${rows}" "10"
            done
        done
    done
}

run_synthetic_continuous() {
    for transport_mode in client-streaming unary; do
        local ts; ts=$(transport_short "${transport_mode}")
        for conc in 4 8; do
            run_case "synthetic-continuous-${ts}-p1024-c${conc}" \
                "${transport_mode}" "synthetic" "continuous" "20000" "1024" "${conc}" "1000"
        done
    done
}

run_synthetic_backpressure() {
    for transport_mode in client-streaming unary; do
        local ts; ts=$(transport_short "${transport_mode}")
        run_case "synthetic-backpressure-${ts}-p1024-c8" \
            "${transport_mode}" "synthetic" "continuous" "20000" "1024" "8" "4000" \
            "0" "2"
    done
}

run_synthetic_recovery() {
    for transport_mode in client-streaming unary; do
        local ts; ts=$(transport_short "${transport_mode}")
        run_case "synthetic-recovery-${ts}-p4096-c8" \
            "${transport_mode}" "synthetic" "continuous" "20000" "4096" "8" "2000" \
            "0" "0" "120" "250" "restart" "transformer" "3"
    done
}

transport_short() {
    if [[ "$1" == "client-streaming" ]]; then
        echo "stream"
    else
        echo "unary"
    fi
}

# ── Main ──

ensure_base_resources

# Upload CSV datasets as a ConfigMap if needed for csv-replay presets
if [[ "${PRESET}" == "csv-replay-check" ]]; then
    DATASETS_DIR="${ROOT}/../../datasets"
    if [[ -d "${DATASETS_DIR}" ]]; then
        echo "Creating datasets ConfigMap..."
        kubectl create configmap experiment-datasets \
            -n "${NAMESPACE}" \
            --from-file="${DATASETS_DIR}/Personen.csv" \
            --from-file="${DATASETS_DIR}/Aanstellingen.csv" \
            --dry-run=client -o yaml | kubectl apply -f -
    else
        echo "Warning: datasets directory not found at ${DATASETS_DIR}" >&2
    fi
fi

# Apply the overlay to create/update deployments and services
kubectl apply -k "${OVERLAY_DIR}"

# Delete producer job so it does not block the first run
kubectl delete job grpc-stream-producer -n "${NAMESPACE}" --ignore-not-found=true 2>/dev/null

wait_for_ready

echo "Starting preset: ${PRESET} (overlay: ${OVERLAY}, repeat: ${REPEAT})"

for ((r = 1; r <= REPEAT; r++)); do
    if [[ "${REPEAT}" -gt 1 ]]; then
        echo "═══ Repetition ${r}/${REPEAT} ═══"
        REPEAT_SUFFIX="-rep${r}"
    else
        REPEAT_SUFFIX=""
    fi

    case "${PRESET}" in
        synthetic-clean)       run_synthetic_clean ;;
        csv-replay-check)      run_csv_replay_check ;;
        synthetic-continuous)  run_synthetic_continuous ;;
        synthetic-backpressure) run_synthetic_backpressure ;;
        synthetic-recovery)    run_synthetic_recovery ;;
        *)
            echo "Unknown preset: ${PRESET}" >&2
            exit 1
            ;;
    esac
done

# Export summary CSV
echo "Exporting summary CSV..."
if command -v pwsh &>/dev/null; then
    pwsh -File "${EXPORT_SCRIPT}" -ResultsDir "${RESULTS_DIR}" -RunIdPrefix "${PRESET}" \
        -OutputPath "${RESULTS_DIR}/${PRESET}-summary.csv"
    if [[ "${REPEAT}" -gt 1 && -f "${AGGREGATE_SCRIPT}" ]]; then
        pwsh -File "${AGGREGATE_SCRIPT}" \
            -SummaryPath "${RESULTS_DIR}/${PRESET}-summary.csv" \
            -OutputPath "${RESULTS_DIR}/${PRESET}-summary-aggregated.csv"
    fi
else
    echo "PowerShell (pwsh) not found; skipping CSV export."
    echo "Run manually: pwsh ${EXPORT_SCRIPT} -ResultsDir ${RESULTS_DIR} -RunIdPrefix ${PRESET}"
fi

echo "Finished preset: ${PRESET}"
