#!/usr/bin/env bash
set -euo pipefail
cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
grep -R -nE 'nats|max_mem|max_file|max_pending|memory|cpu' k8s/base k8s/overlays | head -n 220 || true
