#!/usr/bin/env bash
set -euo pipefail
cd /home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
kubectl kustomize k8s/overlays/resource-medium-single-2g >/tmp/rq1-kustomize.yaml
grep -nE 'grpc-stream-nats-config|max_pending|max_mem_store|max_file_store' /tmp/rq1-kustomize.yaml | head -n 30
