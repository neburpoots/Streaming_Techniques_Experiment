#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-k8s-matrix.sh"
CLUSTER_SETUP_SCRIPT="${ROOT}/scripts/setup-kind-single-cluster.sh"

export PATH="/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

CLUSTER_NAME="grpc-stream-single"
OVERLAY="resource-medium-single-2g"
RUN_TAG="single3-final-20260504"
PROBE_TAG="probe-final-20260504"
REPEAT=3
NAMESPACE="streaming-experiments"
SKIP_CLUSTER_SETUP=false
SKIP_BUILD=false
SKIP_LOAD=false
CLEAN_TIMEOUT="3h"
PRESET_TIMEOUT="90m"
PROBE_TIMEOUT="25m"

usage() {
    cat <<'EOF'
Usage: run-k8s-single-node-final.sh [options]

Options:
  --cluster-name <name>    Kind cluster name (default: grpc-stream-single)
  --overlay <name>         Kustomize overlay (default: resource-medium-single-2g)
  --run-tag <tag>          Prefix for final run ids (default: single3-final-20260504)
  --probe-tag <tag>        Prefix for probe run ids (default: probe-final-20260504)
  --repeat <n>             Repetitions per final case (default: 3)
  --namespace <ns>         Kubernetes namespace (default: streaming-experiments)
  --skip-cluster-setup     Do not recreate/setup the kind cluster
  --skip-build             Pass through to run-k8s-matrix.sh
  --skip-load              Pass through to run-k8s-matrix.sh
  --help                   Show help
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --cluster-name)
            CLUSTER_NAME="$2"
            shift 2
            ;;
        --overlay)
            OVERLAY="$2"
            shift 2
            ;;
        --run-tag)
            RUN_TAG="$2"
            shift 2
            ;;
        --probe-tag)
            PROBE_TAG="$2"
            shift 2
            ;;
        --repeat)
            REPEAT="$2"
            shift 2
            ;;
        --namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        --skip-cluster-setup)
            SKIP_CLUSTER_SETUP=true
            shift
            ;;
        --skip-build)
            SKIP_BUILD=true
            shift
            ;;
        --skip-load)
            SKIP_LOAD=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

run_with_timeout() {
    local timeout_duration="$1"
    shift
    if command -v timeout >/dev/null 2>&1; then
        timeout "${timeout_duration}" "$@"
        return
    fi
    "$@"
}

run_logged() {
    local timeout_duration="$1"
    local log_path="$2"
    shift 2

    mkdir -p "$(dirname "${log_path}")"
    printf 'Command:' > "${log_path}"
    printf ' %q' "$@" >> "${log_path}"
    printf '\n\n' >> "${log_path}"

    echo "Logging to ${log_path}"
    run_with_timeout "${timeout_duration}" "$@" 2>&1 | tee -a "${log_path}"
}

runner_args() {
    local repeat="$1"
    local prefix="$2"
    shift 2

    local args=(
        --overlay "${OVERLAY}"
        --kind-cluster-name "${CLUSTER_NAME}"
        --namespace "${NAMESPACE}"
        --repeat "${repeat}"
        --run-id-prefix "${prefix}-"
        "$@"
    )

    if [[ "${SKIP_BUILD}" == "true" || "${FIRST_RUNNER_INVOCATION}" != "true" ]]; then
        args+=(--skip-build)
    fi
    if [[ "${SKIP_LOAD}" == "true" || "${FIRST_RUNNER_INVOCATION}" != "true" ]]; then
        args+=(--skip-load)
    fi

    printf '%s\n' "${args[@]}"
}

invoke_runner() {
    local timeout_duration="$1"
    local log_name="$2"
    local preset="$3"
    local repeat="$4"
    local prefix="$5"
    shift 5

    mapfile -t args < <(runner_args "${repeat}" "${prefix}" "$@")
    run_logged "${timeout_duration}" "${ROOT}/results/${log_name}.log" \
        env STRICT_RESOURCE_VALIDATION=true PRODUCER_TIMEOUT_SECONDS=420s EXPORT_TIMEOUT_SECONDS=900s \
        "${RUNNER}" "${preset}" "${args[@]}"
    FIRST_RUNNER_INVOCATION=false
}

validate_final_results() {
    python3 - "$ROOT" "$RUN_TAG" <<'PY'
import csv
import glob
import os
import sys

root, run_tag = sys.argv[1:3]
results = os.path.join(root, "results")
expected_rows = {
    "synthetic-clean": 240,
    "synthetic-continuous": 30,
    "synthetic-backpressure": 15,
    "synthetic-recovery": 15,
}

errors = []
for preset, expected in expected_rows.items():
    path = os.path.join(results, f"{run_tag}-{preset}-summary.csv")
    aggregated = os.path.join(results, f"{run_tag}-{preset}-summary-aggregated.csv")
    if not os.path.exists(path):
        errors.append(f"missing {os.path.basename(path)}")
        continue
    with open(path, newline="", encoding="utf-8-sig") as handle:
        rows = list(csv.DictReader(handle))
    if len(rows) != expected:
        errors.append(f"{os.path.basename(path)} has {len(rows)} rows, expected {expected}")
    invalid = [row["run_id"] for row in rows if str(row.get("resource_stats_valid", "")).lower() != "true"]
    if invalid:
        errors.append(f"{os.path.basename(path)} has invalid resource rows: {', '.join(invalid[:5])}")
    if not os.path.exists(aggregated):
        errors.append(f"missing {os.path.basename(aggregated)}")

producer_files = glob.glob(os.path.join(results, f"{run_tag}-synthetic-*-rep*-producer-result.json"))
sink_files = glob.glob(os.path.join(results, f"{run_tag}-synthetic-*-rep*-sink-summary.json"))
if len(producer_files) != 300:
    errors.append(f"producer result file count is {len(producer_files)}, expected 300")
if len(sink_files) != 300:
    errors.append(f"sink summary file count is {len(sink_files)}, expected 300")

if errors:
    for error in errors:
        print(f"VALIDATION ERROR: {error}", file=sys.stderr)
    sys.exit(1)

print("Final result validation passed.")
PY
}

if [[ "${SKIP_CLUSTER_SETUP}" != "true" ]]; then
    "${CLUSTER_SETUP_SCRIPT}" --cluster-name "${CLUSTER_NAME}"
fi

kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null

echo "Cleaning prior artifacts for ${RUN_TAG}-* and ${PROBE_TAG}-*"
find "${ROOT}/results" -maxdepth 1 -type f \( \
    -name "${RUN_TAG}-synthetic-*" \
    -o -name "${PROBE_TAG}-synthetic-*" \
    -o -name "${PROBE_TAG}-stream-*.log" \
    -o -name "${PROBE_TAG}-rmqs-*.log" \
    -o -name "${PROBE_TAG}-nats-*.log" \
    -o -name "${PROBE_TAG}-kafka-*.log" \
    \) -delete

FIRST_RUNNER_INVOCATION=true

echo "Running strict probe set..."
invoke_runner "${PROBE_TIMEOUT}" "${PROBE_TAG}-stream-p256-c1" synthetic-clean 1 "${PROBE_TAG}" --transport client-streaming --payload 256 --concurrency 1
invoke_runner "${PROBE_TIMEOUT}" "${PROBE_TAG}-rmqs-p4096-c16" synthetic-clean 1 "${PROBE_TAG}" --transport rabbitmq-streams --payload 4096 --concurrency 16
invoke_runner "${PROBE_TIMEOUT}" "${PROBE_TAG}-rmqs-p16384-c8" synthetic-clean 1 "${PROBE_TAG}" --transport rabbitmq-streams --payload 16384 --concurrency 8
invoke_runner "${PROBE_TIMEOUT}" "${PROBE_TAG}-rmqs-p16384-c16" synthetic-clean 1 "${PROBE_TAG}" --transport rabbitmq-streams --payload 16384 --concurrency 16
invoke_runner "${PROBE_TIMEOUT}" "${PROBE_TAG}-nats-p16384-c4" synthetic-clean 1 "${PROBE_TAG}" --transport nats-jetstream --payload 16384 --concurrency 4
invoke_runner "${PROBE_TIMEOUT}" "${PROBE_TAG}-nats-p16384-c16" synthetic-clean 1 "${PROBE_TAG}" --transport nats-jetstream --payload 16384 --concurrency 16
invoke_runner "${PROBE_TIMEOUT}" "${PROBE_TAG}-kafka-p4096-c8" synthetic-clean 1 "${PROBE_TAG}" --transport kafka --payload 4096 --concurrency 8

echo "Probe set passed. Running final single-node matrix..."
for transport in client-streaming unary rabbitmq-streams nats-jetstream kafka; do
    invoke_runner "${CLEAN_TIMEOUT}" "${RUN_TAG}-synthetic-clean-${transport}" synthetic-clean "${REPEAT}" "${RUN_TAG}" --transport "${transport}"
done

for preset in synthetic-continuous synthetic-backpressure synthetic-recovery; do
    for transport in client-streaming unary rabbitmq-streams nats-jetstream kafka; do
        invoke_runner "${PRESET_TIMEOUT}" "${RUN_TAG}-${preset}-${transport}" "${preset}" "${REPEAT}" "${RUN_TAG}" --transport "${transport}"
    done
done

validate_final_results

echo "Single-node final summaries written under ${ROOT}/results with prefix ${RUN_TAG}-*."
