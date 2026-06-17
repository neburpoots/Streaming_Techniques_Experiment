#!/usr/bin/env bash
set -euo pipefail
cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
bash -n scripts/run-k8s-matrix.sh
echo "--- shell matrix payload loop ---"
grep -n "for payload" -A2 scripts/run-k8s-matrix.sh
echo "--- powershell matrix payload loop ---"
grep -n "payloadBytes" scripts/run-matrix.ps1 | head
echo "--- remaining primary 262144 refs ---"
grep -R -n "262144" scripts/run-k8s-matrix.sh scripts/run-matrix.ps1 README.md || true
