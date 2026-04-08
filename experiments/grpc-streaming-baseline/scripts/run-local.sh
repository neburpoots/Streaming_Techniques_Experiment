#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_ID="${RUN_ID:-grpc-stream-$(date +%s)}"

cleanup() {
  if [[ -n "${STATS_PID:-}" ]]; then
    kill "${STATS_PID}" >/dev/null 2>&1 || true
  fi
  docker compose -f "${ROOT}/docker-compose.yml" down >/dev/null 2>&1 || true
}
trap cleanup EXIT

pushd "${ROOT}" >/dev/null
docker compose up -d sink transformer

until curl -fsS http://localhost:9101/healthz >/dev/null && curl -fsS http://localhost:9102/healthz >/dev/null; do
  printf 'waiting for transformer and sink to become ready\n'
  sleep 1
done

INTERVAL_SECONDS=1 "${ROOT}/scripts/collect-docker-stats.sh" "${ROOT}/results/${RUN_ID}-docker-stats.ndjson" &
STATS_PID=$!

RUN_ID="${RUN_ID}" docker compose run --rm producer
popd >/dev/null
