#!/usr/bin/env bash
set -uo pipefail

ROOT=/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
RESULTS="${ROOT}/results"
RUN_TAG="${RUN_TAG:-rq1-concept5-scenarios-no256k-20260616}"
PREFIX="${RUN_TAG}-"
LOG="${RESULTS}/${RUN_TAG}.log"
STATUS_FILE="${RESULTS}/${RUN_TAG}.status"

cd "${ROOT}" || exit 1
mkdir -p "${RESULTS}"
: > "${STATUS_FILE}"

run_preset() {
  local preset="$1"
  local started
  started="$(date --iso-8601=seconds)"
  echo "[${started}] START ${preset}" | tee -a "${LOG}" "${STATUS_FILE}"

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
      --namespace streaming-experiments \
      --kind-cluster-name grpc-stream-single \
      --skip-build \
      --skip-load \
    >> "${LOG}" 2>&1

  local rc=$?
  local finished
  finished="$(date --iso-8601=seconds)"
  if [[ "${rc}" -eq 0 ]]; then
    echo "[${finished}] DONE ${preset}" | tee -a "${LOG}" "${STATUS_FILE}"
  else
    echo "[${finished}] FAILED ${preset} rc=${rc}" | tee -a "${LOG}" "${STATUS_FILE}"
  fi
}

run_preset synthetic-continuous
run_preset synthetic-backpressure
run_preset synthetic-recovery

echo "[$(date --iso-8601=seconds)] DONE scenario campaign" | tee -a "${LOG}" "${STATUS_FILE}"
