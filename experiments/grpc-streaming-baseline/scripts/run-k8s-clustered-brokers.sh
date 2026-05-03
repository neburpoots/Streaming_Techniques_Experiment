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
RUN_TAG="clustered-3broker"
REPEAT=3
NAMESPACE="streaming-experiments"
SKIP_CLUSTER_SETUP=false
SKIP_BUILD=false
SKIP_LOAD=false
TRANSPORTS=(rabbitmq-streams nats-jetstream kafka)

usage() {
    cat <<'EOF'
Usage: run-k8s-clustered-brokers.sh [options]

Options:
  --cluster-name <name>      Kind cluster name (default: grpc-stream-topology)
  --run-tag <tag>            Prefix for run ids and summaries (default: clustered-3broker)
  --repeat <n>               Repetitions per case (default: 3)
  --namespace <ns>           Kubernetes namespace (default: streaming-experiments)
  --skip-cluster-setup       Do not create/label the kind cluster
  --skip-build               Pass through to run-k8s-matrix.sh
  --skip-load                Pass through to run-k8s-matrix.sh
  --transports <csv>         Broker transports to run (default: rabbitmq-streams,nats-jetstream,kafka)
  --help                     Show help

Runs one clustered broker family at a time on the 3-worker kind topology.
Each overlay uses a 3-pod broker StatefulSet with 2Gi memory limits and scales
the two unused broker deployments to zero.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --cluster-name)
            CLUSTER_NAME="$2"
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

first_invocation=true

overlay_for_transport() {
    case "$1" in
        rabbitmq-streams) echo "resource-medium-topology-3worker-rabbitmq-cluster" ;;
        nats-jetstream) echo "resource-medium-topology-3worker-nats-cluster" ;;
        kafka) echo "resource-medium-topology-3worker-kafka-cluster" ;;
        *)
            echo "Unsupported clustered transport: $1" >&2
            return 1
            ;;
    esac
}

invoke_runner() {
    local preset="$1"
    shift
    local transport="$1"
    shift
    local overlay="$1"
    shift

    local args=(
        --overlay "${overlay}"
        --kind-cluster-name "${CLUSTER_NAME}"
        --namespace "${NAMESPACE}"
        --repeat "${REPEAT}"
        --run-id-prefix "${RUN_TAG}-"
        --transport "${transport}"
        "$@"
    )
    if [[ "${SKIP_BUILD}" == "true" || "${first_invocation}" != "true" ]]; then
        args+=(--skip-build)
    fi
    if [[ "${SKIP_LOAD}" == "true" || "${first_invocation}" != "true" ]]; then
        args+=(--skip-load)
    fi

    "${RUNNER}" "${preset}" "${args[@]}"
    first_invocation=false
}

for transport in "${TRANSPORTS[@]}"; do
    overlay="$(overlay_for_transport "${transport}")"
    echo "=== Clustered broker test: ${transport} (${overlay}) ==="
    invoke_runner synthetic-clean "${transport}" "${overlay}" --payload 4096 --concurrency 8
    invoke_runner synthetic-continuous "${transport}" "${overlay}" --concurrency 8
    invoke_runner synthetic-backpressure "${transport}" "${overlay}"
    invoke_runner synthetic-recovery "${transport}" "${overlay}"
done

echo "Clustered broker summaries written under ${ROOT}/results with prefix ${RUN_TAG}-*."
