#!/usr/bin/env bash
set -euo pipefail
cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
for f in \
  results/rq1-rerun-20260610-fixed-synthetic-continuous-summary.csv \
  results/rq1-rerun-20260610-fixed-synthetic-backpressure-summary.csv \
  results/rq1-rerun-20260610-fixed-synthetic-recovery-summary.csv \
  results/rq1-rerun-20260610-fixed-synthetic-recovery-summary-aggregated.csv
do
  echo "--- ${f} ---"
  head -n 1 "${f}" || true
  grep -Ei 'bunary|batched' "${f}" || true
done
