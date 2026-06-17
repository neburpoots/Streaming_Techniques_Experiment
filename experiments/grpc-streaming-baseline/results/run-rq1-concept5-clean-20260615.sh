#!/usr/bin/env bash
set -euo pipefail

cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline

LOG=/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline/results/rq1-concept5-clean-20260615.log
rm -f "${LOG}"

env \
  STRICT_RESOURCE_VALIDATION=false \
  CONTINUE_ON_CASE_FAILURE=true \
  PRODUCER_TIMEOUT_SECONDS=900s \
  MAX_SUMMARY_WAIT_OVERRIDE=420 \
  EXPORT_TIMEOUT_SECONDS=1200 \
  ./scripts/run-k8s-matrix.sh synthetic-clean \
    --overlay resource-medium-single-2g \
    --repeat 5 \
    --run-id-prefix rq1-concept5-clean-20260615- \
    --transport all \
    --namespace streaming-experiments \
    --kind-cluster-name grpc-stream-single \
    --skip-build \
    --skip-load \
  > "${LOG}" 2>&1
