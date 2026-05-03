#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-k8s-matrix.sh"
CLUSTER_SETUP_SCRIPT="${ROOT}/scripts/setup-kind-topology-cluster.sh"

export PATH="/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

if ! command -v kubectl >/dev/null 2>&1 || ! kubectl version --client >/dev/null 2>&1; then
    if [[ -x "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" ]]; then
        kubectl() {
            "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" "$@"
        }
    fi
fi

CLUSTER_NAME="grpc-stream-topology"
OVERLAY="resource-medium-topology-3worker"
RUN_TAG="topology-3worker"
REPEAT=3
NAMESPACE="streaming-experiments"
SKIP_CLUSTER_SETUP=false
SKIP_BUILD=false
SKIP_LOAD=false
MODERATE_PAYLOAD=4096
MODERATE_CONCURRENCY=8
HEAVY_PAYLOAD=16384
HEAVY_CONCURRENCY=16
TRANSPORTS=(rabbitmq-streams nats-jetstream kafka)

usage() {
    cat <<'EOF'
Usage: run-k8s-topology-sensitivity.sh [options]

Options:
  --cluster-name <name>      Kind cluster name (default: grpc-stream-topology)
  --overlay <name>           Kustomize overlay (default: resource-medium-topology-3worker)
  --run-tag <tag>            Prefix for run ids and summaries (default: topology-3worker)
  --repeat <n>               Repetitions per case (default: 3)
  --namespace <ns>           Kubernetes namespace (default: streaming-experiments)
  --skip-cluster-setup       Do not create/label the kind cluster
  --skip-build               Pass through to run-k8s-matrix.sh
  --skip-load                Pass through to run-k8s-matrix.sh
  --moderate-payload <bytes> Moderate clean-row payload (default: 4096)
  --moderate-concurrency <n> Moderate clean-row concurrency (default: 8)
  --heavy-payload <bytes>    Heavy clean-row payload (default: 16384)
  --heavy-concurrency <n>    Heavy clean-row concurrency (default: 16)
  --transports <csv>         Broker transports to run (default: rabbitmq-streams,nats-jetstream,kafka)
  --help                     Show help

Creates or reuses a 3-worker local kind cluster, applies a scheduling overlay
that pins broker, transformer, and sink to distinct workers, and runs a narrow
broker-only topology-sensitivity matrix.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --cluster-name)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        --overlay)
            OVERLAY="$2"
            shift 2
            ;;
        --run-tag)
            RUN_TAG="$2"
            shift 2
            ;;
        --repeat)
            REPEAT="$2"
            shift 2
            ;;
        --namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        --skip-cluster-setup)
            SKIP_CLUSTER_SETUP=true
            shift
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --skip-load)
            SKIP_LOAD=true
            shift
            ;;
        --moderate-payload)
            MODERATE_PAYLOAD="$2"
            shift 2
            ;;
        --moderate-concurrency)
            MODERATE_CONCURRENCY="$2"
            shift 2
            ;;
        --heavy-payload)
            HEAVY_PAYLOAD="$2"
            shift 2
            ;;
        --heavy-concurrency)
            HEAVY_CONCURRENCY="$2"
            shift 2
            ;;
        --transports)
            IFS=',' read -r -a TRANSPORTS <<< "$2"
            shift 2
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ "${SKIP_CLUSTER_SETUP}" != "true" ]]; then
    "${CLUSTER_SETUP_SCRIPT}" --cluster-name "${CLUSTER_NAME}"
fi

kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null

runner_common=(
    --overlay "${OVERLAY}"
    --kind-cluster-name "${CLUSTER_NAME}"
    --namespace "${NAMESPACE}"
    --repeat "${REPEAT}"
    --run-id-prefix "${RUN_TAG}-"
)

if [[ "${SKIP_BUILD}" == "true" ]]; then
    runner_common+=(--skip-build)
fi
if [[ "${SKIP_LOAD}" == "true" ]]; then
    runner_common+=(--skip-load)
fi

first_invocation=true

invoke_runner() {
    local preset="$1"
    shift
    local transport="$1"
    shift

    local args=("${runner_common[@]}" --transport "${transport}" "$@")
    if [[ "${first_invocation}" != "true" ]]; then
        args+=(--skip-build --skip-load)
    fi

    "${RUNNER}" "${preset}" "${args[@]}"
    first_invocation=false
}

for transport in "${TRANSPORTS[@]}"; do
    echo "=== Topology sensitivity: ${transport} ==="
    invoke_runner synthetic-clean "${transport}" --payload "${MODERATE_PAYLOAD}" --concurrency "${MODERATE_CONCURRENCY}"
    invoke_runner synthetic-clean "${transport}" --payload "${HEAVY_PAYLOAD}" --concurrency "${HEAVY_CONCURRENCY}"
    invoke_runner synthetic-continuous "${transport}" --concurrency 8
    invoke_runner synthetic-backpressure "${transport}"
    invoke_runner synthetic-recovery "${transport}"
done

echo "Topology sensitivity summaries written under ${ROOT}/results with prefix ${RUN_TAG}-*."
