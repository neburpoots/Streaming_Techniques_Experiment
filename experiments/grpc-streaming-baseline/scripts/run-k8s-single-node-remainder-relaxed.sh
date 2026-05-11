#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-k8s-matrix.sh"

export PATH="/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}"
export PRODUCER_TIMEOUT_SECONDS="${PRODUCER_TIMEOUT_SECONDS:-420s}"
export EXPORT_TIMEOUT_SECONDS="${EXPORT_TIMEOUT_SECONDS:-900s}"

CLUSTER_NAME="${CLUSTER_NAME:-grpc-stream-single}"
NAMESPACE="${NAMESPACE:-streaming-experiments}"
OVERLAY="${OVERLAY:-resource-medium-single-2g}"
RUN_TAG="${RUN_TAG:-single3-final-20260504}"

run_segment() {
    local preset="$1"
    shift

    "${RUNNER}" "${preset}" \
        --overlay "${OVERLAY}" \
        --kind-cluster-name "${CLUSTER_NAME}" \
        --namespace "${NAMESPACE}" \
        --repeat 1 \
        --run-id-prefix "${RUN_TAG}-" \
        --skip-build \
        --skip-load \
        "$@"
}

kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null

run_segment synthetic-continuous --transport rabbitmq-streams --concurrency 8
run_segment synthetic-continuous --transport nats-jetstream
run_segment synthetic-continuous --transport kafka
run_segment synthetic-backpressure --transport all
run_segment synthetic-recovery --transport all

