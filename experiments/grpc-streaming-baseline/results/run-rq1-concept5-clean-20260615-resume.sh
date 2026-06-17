#!/usr/bin/env bash
set -euo pipefail

ROOT=/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
RESULTS="${ROOT}/results"
PREFIX=rq1-concept5-clean-20260615-
LOG="${RESULTS}/rq1-concept5-clean-20260615-resume.log"

cd "${ROOT}"
mkdir -p "${RESULTS}"

count_artifacts() {
  local short="$1"
  local rep="$2"
  find "${RESULTS}" -maxdepth 1 -type f \
    -name "${PREFIX}synthetic-clean-${short}-p*-c*-rep${rep}-producer-result.json" \
    | wc -l
}

run_transport_rep() {
  local transport="$1"
  local short="$2"
  local rep="$3"
  local existing
  existing=$(count_artifacts "${short}" "${rep}")
  if [[ "${existing}" -ge 20 ]]; then
    echo "[$(date --iso-8601=seconds)] SKIP ${transport} rep${rep}: ${existing}/20 producer artifacts already present" | tee -a "${LOG}"
    return 0
  fi

  echo "[$(date --iso-8601=seconds)] RUN ${transport} rep${rep}: ${existing}/20 producer artifacts present" | tee -a "${LOG}"
  env \
    STRICT_RESOURCE_VALIDATION=false \
    CONTINUE_ON_CASE_FAILURE=true \
    PRODUCER_TIMEOUT_SECONDS=900s \
    MAX_SUMMARY_WAIT_OVERRIDE=420 \
    EXPORT_TIMEOUT_SECONDS=1200 \
    FORCED_REP_SUFFIX="-rep${rep}" \
    ./scripts/run-k8s-matrix.sh synthetic-clean \
      --overlay resource-medium-single-2g \
      --repeat 1 \
      --run-id-prefix "${PREFIX}" \
      --transport "${transport}" \
      --namespace streaming-experiments \
      --kind-cluster-name grpc-stream-single \
      --skip-build \
      --skip-load \
    >> "${LOG}" 2>&1
}

run_nats_rep() {
  local rep="$1"
  local existing
  existing=$(count_artifacts nats "${rep}")
  if [[ "${existing}" -ge 17 ]]; then
    echo "[$(date --iso-8601=seconds)] SKIP nats-jetstream rep${rep}: ${existing}/17 stable producer artifacts already present; p262144 c4/c8/c16 are treated as failed under the current resource envelope" | tee -a "${LOG}"
    return 0
  fi

  echo "[$(date --iso-8601=seconds)] RUN nats-jetstream rep${rep} stable subset: ${existing}/17 producer artifacts present" | tee -a "${LOG}"
  for payload in 256 1024 4096 16384; do
    env \
      STRICT_RESOURCE_VALIDATION=false \
      CONTINUE_ON_CASE_FAILURE=true \
      PRODUCER_TIMEOUT_SECONDS=900s \
      MAX_SUMMARY_WAIT_OVERRIDE=420 \
      EXPORT_TIMEOUT_SECONDS=1200 \
      FORCED_REP_SUFFIX="-rep${rep}" \
      ./scripts/run-k8s-matrix.sh synthetic-clean \
        --overlay resource-medium-single-2g \
        --repeat 1 \
        --run-id-prefix "${PREFIX}" \
        --transport nats-jetstream \
        --payload "${payload}" \
        --namespace streaming-experiments \
        --kind-cluster-name grpc-stream-single \
        --skip-build \
        --skip-load \
      >> "${LOG}" 2>&1
  done

  env \
    STRICT_RESOURCE_VALIDATION=false \
    CONTINUE_ON_CASE_FAILURE=true \
    PRODUCER_TIMEOUT_SECONDS=900s \
    MAX_SUMMARY_WAIT_OVERRIDE=420 \
    EXPORT_TIMEOUT_SECONDS=1200 \
    FORCED_REP_SUFFIX="-rep${rep}" \
    ./scripts/run-k8s-matrix.sh synthetic-clean \
      --overlay resource-medium-single-2g \
      --repeat 1 \
      --run-id-prefix "${PREFIX}" \
      --transport nats-jetstream \
      --payload 262144 \
      --concurrency 1 \
      --namespace streaming-experiments \
      --kind-cluster-name grpc-stream-single \
      --skip-build \
      --skip-load \
    >> "${LOG}" 2>&1
}

# Finish repetition 1 first. The interrupted run already completed the first
# four transports and NATS p256/c1; this reruns the incomplete NATS slice rather
# than trying to splice individual cells.
run_nats_rep 1
run_transport_rep kafka kafka 1

# Fill repetitions 2-5 transport by transport.
for rep in 2 3 4 5; do
  run_transport_rep client-streaming stream "${rep}"
  run_transport_rep unary unary "${rep}"
  run_transport_rep batched-unary bunary "${rep}"
  run_transport_rep rabbitmq-streams rmqs "${rep}"
  run_nats_rep "${rep}"
  run_transport_rep kafka kafka "${rep}"
done

echo "[$(date --iso-8601=seconds)] DONE resume campaign" | tee -a "${LOG}"
