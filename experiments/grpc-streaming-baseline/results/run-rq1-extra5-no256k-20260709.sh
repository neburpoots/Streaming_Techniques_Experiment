#!/usr/bin/env bash
set -u

ROOT=/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
RESULTS="${ROOT}/results"
TAG=rq1-extra5-no256k-20260709
PREFIX="${TAG}-"
LOG="${RESULTS}/${TAG}-campaign.log"
ERR="${RESULTS}/${TAG}-campaign.err.log"
EXIT_FILE="${RESULTS}/${TAG}-campaign-exit.txt"

export PATH=/home/nebur/.cache/dynamos/kind/v0.29.0:/home/nebur/.cache/dynamos/kubectl/v1.30.7:/home/nebur/.local/dynamos-toolbin:/home/nebur/.local/dynamos-winbin:/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}

cd "${ROOT}" || exit 1
mkdir -p "${RESULTS}"
: > "${LOG}"
: > "${ERR}"

run_preset() {
  local preset="$1"
  shift

  echo "===== START ${preset} $(date --iso-8601=seconds) ====="
  env \
    STRICT_RESOURCE_VALIDATION=false \
    CONTINUE_ON_CASE_FAILURE=true \
    PRODUCER_TIMEOUT_SECONDS=600s \
    MAX_SUMMARY_WAIT_OVERRIDE=420 \
    EXPORT_TIMEOUT_SECONDS=1200 \
    ./scripts/run-k8s-matrix.sh "${preset}" \
      --overlay resource-medium-single-2g \
      --repeat 5 \
      --run-id-prefix "${PREFIX}" \
      --transport all \
      --namespace streaming-experiments \
      --kind-cluster-name grpc-stream-single \
      "$@"
  echo "===== END ${preset} $(date --iso-8601=seconds) ====="
}

(
  set -euo pipefail

  echo "RQ1 extra-five campaign start $(date --iso-8601=seconds)"
  echo "Refreshing dedicated kind cluster grpc-stream-single"
  ./scripts/setup-kind-single-cluster.sh --cluster-name grpc-stream-single
  echo "context: $(kubectl config current-context 2>/dev/null || true)"
  kubectl get nodes -o wide

  # The cluster was recreated above, so the clean preset builds and loads images.
  run_preset synthetic-clean

  # Images are already present in this fresh cluster after the clean preset.
  run_preset synthetic-continuous --skip-build --skip-load
  run_preset synthetic-backpressure --skip-build --skip-load
  run_preset synthetic-recovery --skip-build --skip-load

  echo "RQ1 extra-five campaign finished $(date --iso-8601=seconds)"
) >>"${LOG}" 2>>"${ERR}"
rc=$?
echo "${rc}" > "${EXIT_FILE}"
exit "${rc}"
