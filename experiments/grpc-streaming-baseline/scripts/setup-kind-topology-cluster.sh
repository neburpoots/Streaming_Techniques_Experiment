#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLUSTER_NAME="grpc-stream-topology"
CONFIG_PATH="${ROOT}/k8s/kind/topology-sensitivity-3worker.yaml"

export PATH="/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

if ! command -v kubectl >/dev/null 2>&1 || ! kubectl version --client >/dev/null 2>&1; then
    if [[ -x "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" ]]; then
        kubectl() {
            "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" "$@"
        }
    fi
fi

usage() {
    cat <<'EOF'
Usage: setup-kind-topology-cluster.sh [options]

Options:
  --cluster-name <name>  Kind cluster name (default: grpc-stream-topology)
  --help                 Show help

Creates a local kind cluster with 1 control-plane and 3 workers, then labels
the workers so the topology-sensitivity overlay can pin the broker,
transformer, and sink onto distinct worker nodes.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --cluster-name)
            CLUSTER_NAME="$2"
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

if ! command -v kind >/dev/null 2>&1; then
    echo "kind is required but not installed. Install kind first, then rerun this script." >&2
    exit 1
fi

cluster_exists=false
context_exists=false

if kind get clusters 2>/dev/null | grep -Fxq "${CLUSTER_NAME}"; then
    cluster_exists=true
fi

if kubectl config get-contexts -o name 2>/dev/null | grep -Fxq "kind-${CLUSTER_NAME}"; then
    context_exists=true
fi

if [[ "${cluster_exists}" == "true" && "${context_exists}" != "true" ]]; then
    echo "Removing incomplete kind cluster ${CLUSTER_NAME}..."
    kind delete cluster --name "${CLUSTER_NAME}" >/dev/null 2>&1 || true
    cluster_exists=false
fi

if [[ "${cluster_exists}" != "true" ]]; then
    echo "Creating kind cluster ${CLUSTER_NAME}..."
    kind create cluster --name "${CLUSTER_NAME}" --config "${CONFIG_PATH}"
fi

kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null
kubectl wait --for=condition=Ready nodes --all --timeout=180s >/dev/null

mapfile -t workers < <(kubectl get nodes --no-headers | awk '$3 != "control-plane" { print $1 }')

if [[ "${#workers[@]}" -lt 3 ]]; then
    echo "Expected at least 3 worker nodes, found ${#workers[@]}." >&2
    kubectl get nodes >&2
    exit 1
fi

for node in "${workers[@]}"; do
    kubectl label node "${node}" benchmark.dynamos/topology-sensitivity=true --overwrite >/dev/null
done

kubectl label node "${workers[0]}" benchmark.dynamos/placement=broker --overwrite >/dev/null
kubectl label node "${workers[1]}" benchmark.dynamos/placement=transformer --overwrite >/dev/null
kubectl label node "${workers[2]}" benchmark.dynamos/placement=sink --overwrite >/dev/null

echo "kind context: kind-${CLUSTER_NAME}"
echo "worker placement labels:"
kubectl get nodes -L benchmark.dynamos/placement,benchmark.dynamos/topology-sensitivity
