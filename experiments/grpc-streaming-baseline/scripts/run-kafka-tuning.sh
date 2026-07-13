#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-k8s-matrix.sh"
SUITE="${1:-client}"
OUTPUT_DIR="${KAFKA_TUNING_OUTPUT_DIR:-${ROOT}/results/kafka-tuning-20260713}"
CLUSTER_NAME="${KAFKA_TUNING_CLUSTER:-grpc-stream-single}"
REPETITIONS="${KAFKA_TUNING_REPETITIONS:-3}"
SKIP_IMAGES="${KAFKA_TUNING_SKIP_IMAGES:-false}"
TOTAL_MESSAGES="${KAFKA_TUNING_TOTAL_MESSAGES:-20000}"
RESTART_BROKER_PER_CASE="${KAFKA_TUNING_RESTART_BROKER_PER_CASE:-true}"
PLAN="${OUTPUT_DIR}/experiment-plan.csv"
FIRST_RUN=true

mkdir -p "${OUTPUT_DIR}"
if [[ ! -f "${PLAN}" ]]; then
    printf '%s\n' 'suite,config,payload_bytes,concurrency,repetitions,partitions,transformer_replicas,batch_size,batch_bytes,batch_timeout_ms,fetch_min_bytes,fetch_max_wait_ms,commit_interval_ms,required_acks,compression,key_mode,broker_message_max_bytes' > "${PLAN}"
fi

run_config() {
    local suite="$1"
    local config="$2"
    local payload="$3"
    local partitions="$4"
    local transformer_replicas="$5"
    local batch_size="$6"
    local batch_bytes="$7"
    local batch_timeout_ms="$8"
    local fetch_min_bytes="$9"
    local fetch_max_wait_ms="${10}"
    local commit_interval_ms="${11}"
    local required_acks="${12}"
    local compression="${13}"
    local key_mode="${14}"
    local broker_message_max_bytes="${15:-}"
    local run_prefix="kt-${suite}-${config}-"
    local image_args=()

    if [[ "${SKIP_IMAGES}" == "true" || "${FIRST_RUN}" != "true" ]]; then
        image_args=(--skip-build --skip-load)
    fi

    printf '%s\n' "${suite},${config},${payload},16,${REPETITIONS},${partitions},${transformer_replicas},${batch_size},${batch_bytes},${batch_timeout_ms},${fetch_min_bytes},${fetch_max_wait_ms},${commit_interval_ms},${required_acks},${compression},${key_mode},${broker_message_max_bytes}" >> "${PLAN}"

    RESULTS_DIR="${OUTPUT_DIR}" \
    CONTINUE_ON_CASE_FAILURE=true \
    SKIP_COMPLETED_CASES=true \
    SYNTHETIC_CLEAN_TOTAL_MESSAGES="${TOTAL_MESSAGES}" \
    KAFKA_RESTART_BROKER_PER_CASE="${RESTART_BROKER_PER_CASE}" \
    KAFKA_TOPIC_PARTITIONS="${partitions}" \
    KAFKA_TRANSFORMER_REPLICAS="${transformer_replicas}" \
    KAFKA_BATCH_SIZE="${batch_size}" \
    KAFKA_BATCH_BYTES="${batch_bytes}" \
    KAFKA_BATCH_TIMEOUT_MS="${batch_timeout_ms}" \
    KAFKA_COMMIT_INTERVAL_MS="${commit_interval_ms}" \
    KAFKA_QUEUE_CAPACITY=2048 \
    KAFKA_FETCH_MIN_BYTES="${fetch_min_bytes}" \
    KAFKA_FETCH_MAX_BYTES=67108864 \
    KAFKA_FETCH_MAX_WAIT_MS="${fetch_max_wait_ms}" \
    KAFKA_REQUIRED_ACKS="${required_acks}" \
    KAFKA_COMPRESSION="${compression}" \
    KAFKA_KEY_MODE="${key_mode}" \
    KAFKA_BROKER_MESSAGE_MAX_BYTES="${broker_message_max_bytes}" \
    bash "${RUNNER}" synthetic-clean \
        --repeat "${REPETITIONS}" \
        --transport kafka \
        --payload "${payload}" \
        --concurrency 16 \
        --kind-cluster-name "${CLUSTER_NAME}" \
        --run-id-prefix "${run_prefix}" \
        "${image_args[@]}"

    FIRST_RUN=false
}

run_payload_pair() {
    local suite="$1"
    local config="$2"
    shift 2
    for payload in 1024 16384; do
        run_config "${suite}" "${config}" "${payload}" "$@"
    done
}

run_client_suite() {
    run_payload_pair client baseline       16 1 256 1048576 5 65536 250 250 one none worker
    run_payload_pair client fetch-fast     16 1 256 1048576 5 1024  20  250 one none worker
    run_payload_pair client batch-balanced 16 1 512 1048576 10 65536 250 250 one none worker
    run_payload_pair client batch-large    16 1 1024 4194304 20 65536 250 250 one none worker 8388608
    run_payload_pair client combined       16 1 512 1048576 10 1024  20  250 one none worker
    run_payload_pair client combined-lz4   16 1 512 1048576 10 1024  20  250 one lz4 worker
}

run_partition_suite() {
    for partitions in 1 4 8 16; do
        run_payload_pair partitions "p${partitions}" "${partitions}" 1 256 1048576 5 1024 20 250 one none worker
    done
}

run_keying_suite() {
    for key_mode in run worker none; do
        run_payload_pair keying "${key_mode}" 16 1 256 1048576 5 1024 20 250 one none "${key_mode}"
    done
}

run_topology_suite() {
    for replicas in 1 2 4; do
        run_payload_pair topology "transformer-r${replicas}" 16 "${replicas}" 256 1048576 5 1024 20 250 one none worker
    done
}

run_ack_suite() {
    for required_acks in none one all; do
        run_payload_pair acks "${required_acks}" 16 1 256 1048576 5 1024 20 250 "${required_acks}" none worker
    done
}

run_confirmation_suite() {
    run_payload_pair confirmation baseline       16 1 256 1048576 5 65536 250 250 one none worker
    run_payload_pair confirmation fetch-fast     16 1 256 1048576 5 1024  20  250 one none worker
    run_payload_pair confirmation fetch-fast-lz4 16 1 256 1048576 5 1024  20  250 one lz4 worker
}

case "${SUITE}" in
    client) run_client_suite ;;
    partitions) run_partition_suite ;;
    keying) run_keying_suite ;;
    topology) run_topology_suite ;;
    acks) run_ack_suite ;;
    confirmation) run_confirmation_suite ;;
    all)
        run_client_suite
        run_partition_suite
        run_keying_suite
        run_topology_suite
        run_ack_suite
        ;;
    *)
        echo "Unknown suite: ${SUITE}. Expected client, partitions, keying, topology, acks, confirmation, or all." >&2
        exit 1
        ;;
esac

python3 "${ROOT}/scripts/analyze-kafka-tuning.py" "${OUTPUT_DIR}"
