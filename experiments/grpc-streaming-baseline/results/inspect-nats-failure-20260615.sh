#!/usr/bin/env bash
set -u

echo "--- producer log ---"
kubectl -n streaming-experiments logs job/grpc-stream-producer --tail=60 2>&1 || true

echo "--- nats pod state ---"
kubectl -n streaming-experiments describe pod -l app=grpc-stream-nats 2>&1 \
  | grep -E 'State:|Last State:|Reason:|Exit Code:|Started:|Finished:|Restart Count|OOM|Killing|Back-off' \
  -A2 -B1 || true

echo "--- nats current log ---"
kubectl -n streaming-experiments logs deploy/grpc-stream-nats --tail=120 2>&1 || true

echo "--- nats previous log ---"
kubectl -n streaming-experiments logs deploy/grpc-stream-nats --previous --tail=120 2>&1 || true
