#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODULE="github.com/nebur/streaming-techniques-experiment/grpc-streaming-baseline"

docker run --rm \
  -v "${ROOT}:/workspace" \
  -w /workspace \
  -e MODULE="${MODULE}" \
  golang:1.24-bookworm \
  bash -lc '
    set -euo pipefail
    apt-get update >/dev/null
    apt-get install -y protobuf-compiler >/dev/null
    export PATH="/usr/local/go/bin:/go/bin:${PATH}"
    go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.6
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1
    protoc \
      --proto_path=proto \
      --go_out=. \
      --go_opt=module="${MODULE}" \
      --go-grpc_out=. \
      --go-grpc_opt=module="${MODULE}" \
      proto/experiment.proto
  '
