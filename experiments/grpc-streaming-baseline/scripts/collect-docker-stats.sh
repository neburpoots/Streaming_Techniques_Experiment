#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_FILE="${1:-${ROOT}/results/docker-stats.ndjson}"
INTERVAL_SECONDS="${INTERVAL_SECONDS:-1}"

mkdir -p "$(dirname "${OUTPUT_FILE}")"

while true; do
  docker stats --no-stream --format '{{json .}}' >> "${OUTPUT_FILE}"
  sleep "${INTERVAL_SECONDS}"
done
