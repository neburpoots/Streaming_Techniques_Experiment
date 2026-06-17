#!/usr/bin/env bash
set -euo pipefail
cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
grep -nE 'FORCED_REP_SUFFIX|PAYLOAD_FILTER|CONCURRENCY_FILTER|TRANSPORT_FILTER|SKIP_EXISTING|repeat|case_id|run_case' scripts/run-k8s-matrix.sh || true
