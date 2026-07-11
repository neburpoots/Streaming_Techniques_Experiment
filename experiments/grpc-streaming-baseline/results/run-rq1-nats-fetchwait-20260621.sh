#!/usr/bin/env bash
set -euo pipefail

ROOT="/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline"
cd "${ROOT}"

export KUBECONFIG="/mnt/c/Users/nebur/.kube/config"
export NATS_ACK_WAIT_MS="120000"
export NATS_MAX_ACK_PENDING="4096"
export NATS_FETCH_BATCH_SIZE="64"
export NATS_FETCH_MAX_WAIT_MS="500"

COMMON_ARGS=(
  --overlay resource-medium-single-2g
  --transport nats-jetstream
  --repeat 5
  --run-id-prefix rq1-nats-fetchwait-20260621-
  --namespace streaming-experiments
  --skip-build
  --skip-load
)

for preset in synthetic-clean synthetic-continuous synthetic-backpressure synthetic-recovery; do
  echo "===== START ${preset} $(date --iso-8601=seconds) ====="
  ./scripts/run-k8s-matrix.sh "${preset}" "${COMMON_ARGS[@]}"
  echo "===== END ${preset} $(date --iso-8601=seconds) ====="
done
