#!/usr/bin/env bash
set -u

cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline

LOG_FILE="results/rq1-nats-ackfix-20260621-campaign.log"
ERR_FILE="results/rq1-nats-ackfix-20260621-campaign.err.log"
EXIT_FILE="results/rq1-nats-ackfix-20260621-campaign-exit.txt"

rm -f "${LOG_FILE}" "${ERR_FILE}" "${EXIT_FILE}"
trap 'code=$?; echo "${code}" > "${EXIT_FILE}"' EXIT

exec > >(tee -a "${LOG_FILE}") 2> >(tee -a "${ERR_FILE}" >&2)

export KUBECONFIG=/mnt/c/Users/nebur/.kube/config
export STRICT_RESOURCE_VALIDATION=false
export CONTINUE_ON_CASE_FAILURE=true
export PRODUCER_TIMEOUT_SECONDS=900s
export EXPORT_TIMEOUT_SECONDS=1200s
export MAX_SUMMARY_WAIT_OVERRIDE=420
export NATS_ACK_WAIT_MS=120000
export NATS_MAX_ACK_PENDING=4096
export NATS_FETCH_BATCH_SIZE=64
export NATS_FETCH_MAX_WAIT_MS=25
export SYNTHETIC_CLEAN_TOTAL_MESSAGES=20000

overall=0

run_preset() {
    local preset="$1"
    echo "===== START ${preset} $(date -Is) ====="
    bash ./scripts/run-k8s-matrix.sh "${preset}" \
        --overlay resource-medium-single-2g \
        --transport nats-jetstream \
        --repeat 5 \
        --run-id-prefix rq1-nats-ackfix-20260621- \
        --namespace streaming-experiments \
        --skip-build \
        --skip-load
    local code=$?
    echo "===== END ${preset} exit=${code} $(date -Is) ====="
    if [[ "${code}" -ne 0 ]]; then
        overall="${code}"
    fi
}

run_preset synthetic-clean
run_preset synthetic-continuous
run_preset synthetic-backpressure
run_preset synthetic-recovery

exit "${overall}"
