#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_ID="${RUN_ID:-grpc-stream-$(date +%s)}"
export RUN_ID

cleanup() {
  if [[ -n "${FAILURE_PID:-}" ]]; then
    kill "${FAILURE_PID}" >/dev/null 2>&1 || true
  fi
  if [[ -n "${STATS_PID:-}" ]]; then
    kill "${STATS_PID}" >/dev/null 2>&1 || true
  fi
  docker compose -f "${ROOT}/docker-compose.yml" down -v >/dev/null 2>&1 || true
}
trap cleanup EXIT

pushd "${ROOT}" >/dev/null
docker compose up -d sink transformer rabbitmq

until curl -fsS http://localhost:9101/healthz >/dev/null && curl -fsS http://localhost:9102/healthz >/dev/null; do
  printf 'waiting for transformer and sink to become ready\n'
  sleep 1
done

if [[ "${TRANSPORT_MODE:-client-streaming}" == "rabbitmq-streams" ]]; then
  until docker compose exec -T rabbitmq rabbitmq-diagnostics -q ping >/dev/null 2>&1; do
    printf 'waiting for rabbitmq to become ready\n'
    sleep 1
  done
elif [[ "${TRANSPORT_MODE:-client-streaming}" == "nats-jetstream" ]]; then
  until docker compose exec -T nats sh -c 'nc -z 127.0.0.1 4222' >/dev/null 2>&1; do
    printf 'waiting for nats to become ready\n'
    sleep 1
  done
elif [[ "${TRANSPORT_MODE:-client-streaming}" == "kafka" ]]; then
  until docker compose exec -T kafka bash -ec 'unset JMX_PORT; /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list >/dev/null' >/dev/null 2>&1; do
    printf 'waiting for kafka to become ready\n'
    sleep 2
  done
fi

INTERVAL_SECONDS=1 "${ROOT}/scripts/collect-docker-stats.sh" "${ROOT}/results/${RUN_ID}-docker-stats.ndjson" &
STATS_PID=$!

FAILURE_ACTION="${FAILURE_ACTION:-}"
FAILURE_TARGET="${FAILURE_TARGET:-}"
FAILURE_AFTER_SECONDS="${FAILURE_AFTER_SECONDS:-0}"

if [[ -n "${FAILURE_ACTION}" && -n "${FAILURE_TARGET}" && "${FAILURE_AFTER_SECONDS}" -gt 0 ]]; then
  (
    sleep "${FAILURE_AFTER_SECONDS}"
    case "${FAILURE_ACTION}" in
      restart)
        docker compose -f "${ROOT}/docker-compose.yml" restart "${FAILURE_TARGET}" >/dev/null
        ;;
      *)
        printf 'unsupported FAILURE_ACTION=%s\n' "${FAILURE_ACTION}" >&2
        ;;
    esac
  ) &
  FAILURE_PID=$!
fi

RUN_ID="${RUN_ID}" docker compose run --rm producer
popd >/dev/null
