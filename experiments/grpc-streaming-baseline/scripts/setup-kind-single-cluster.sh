#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLUSTER_NAME="grpc-stream-single"
CONFIG_PATH="${ROOT}/k8s/kind/single-node.yaml"
RECREATE=true

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
Usage: setup-kind-single-cluster.sh [options]

Options:
  --cluster-name <name>  Kind cluster name (default: grpc-stream-single)
  --keep-existing        Reuse an existing cluster instead of recreating it
  --help                 Show help

Creates a local single-node kind cluster and installs metrics-server with
kind-compatible kubelet TLS settings.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --cluster-name)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        --keep-existing)
            RECREATE=false
            shift
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

if kind get clusters 2>/dev/null | grep -Fxq "${CLUSTER_NAME}"; then
    if [[ "${RECREATE}" == "true" ]]; then
        echo "Deleting existing kind cluster ${CLUSTER_NAME}..."
        kind delete cluster --name "${CLUSTER_NAME}"
    fi
fi

if ! kind get clusters 2>/dev/null | grep -Fxq "${CLUSTER_NAME}"; then
    echo "Creating kind cluster ${CLUSTER_NAME}..."
    kind create cluster --name "${CLUSTER_NAME}" --config "${CONFIG_PATH}"
fi

kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null
kubectl wait --for=condition=Ready nodes --all --timeout=180s >/dev/null

echo "Installing metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml >/dev/null
kubectl -n kube-system patch deployment metrics-server --type=json -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"},
  {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-preferred-address-types=InternalIP,Hostname,ExternalIP"}
]' >/dev/null || true
kubectl -n kube-system rollout status deployment/metrics-server --timeout=180s

echo "Waiting for metrics API..."
for _ in $(seq 1 60); do
    if kubectl top nodes >/dev/null 2>&1; then
        echo "kind context: kind-${CLUSTER_NAME}"
        kubectl get nodes
        exit 0
    fi
    sleep 3
done

echo "metrics-server did not become ready for kubectl top nodes." >&2
kubectl -n kube-system get pods -l k8s-app=metrics-server >&2 || true
exit 1
