#!/usr/bin/env bash
set -euo pipefail
cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
grep -R -nE '262144|256 1024' scripts k8s BENCHMARK_DESIGN.md README.md 2>/dev/null || true
