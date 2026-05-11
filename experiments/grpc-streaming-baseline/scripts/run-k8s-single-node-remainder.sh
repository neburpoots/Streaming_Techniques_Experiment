#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-k8s-matrix.sh"

export PATH="/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

CLUSTER_NAME="${CLUSTER_NAME:-grpc-stream-single}"
NAMESPACE="${NAMESPACE:-streaming-experiments}"
OVERLAY="${OVERLAY:-resource-medium-single-2g}"
RUN_TAG="${RUN_TAG:-single3-final-20260504}"

run_segment() {
    local log_name="$1"
    local preset="$2"
    shift 2

    local log_path="${ROOT}/results/${log_name}.log"
    mkdir -p "$(dirname "${log_path}")"
    printf 'Command:' > "${log_path}"
    printf ' %q' env STRICT_RESOURCE_VALIDATION=true PRODUCER_TIMEOUT_SECONDS=420s EXPORT_TIMEOUT_SECONDS=900s \
        "${RUNNER}" "${preset}" \
        --overlay "${OVERLAY}" \
        --kind-cluster-name "${CLUSTER_NAME}" \
        --namespace "${NAMESPACE}" \
        --repeat 1 \
        --run-id-prefix "${RUN_TAG}-" \
        --skip-build \
        --skip-load \
        "$@" >> "${log_path}"
    printf '\n\n' >> "${log_path}"

    echo "Logging to ${log_path}"
    env STRICT_RESOURCE_VALIDATION=true PRODUCER_TIMEOUT_SECONDS=420s EXPORT_TIMEOUT_SECONDS=900s \
        "${RUNNER}" "${preset}" \
        --overlay "${OVERLAY}" \
        --kind-cluster-name "${CLUSTER_NAME}" \
        --namespace "${NAMESPACE}" \
        --repeat 1 \
        --run-id-prefix "${RUN_TAG}-" \
        --skip-build \
        --skip-load \
        "$@" 2>&1 | tee -a "${log_path}"
}

kubectl config use-context "kind-${CLUSTER_NAME}" >/dev/null

run_segment "${RUN_TAG}-remainder-clean-nats" synthetic-clean --transport nats-jetstream
run_segment "${RUN_TAG}-remainder-clean-kafka" synthetic-clean --transport kafka

run_segment "${RUN_TAG}-remainder-continuous" synthetic-continuous --transport all
run_segment "${RUN_TAG}-remainder-backpressure" synthetic-backpressure --transport all
run_segment "${RUN_TAG}-remainder-recovery" synthetic-recovery --transport all

python3 - "${ROOT}" "${RUN_TAG}" <<'PY'
import csv
import os
import sys

root, run_tag = sys.argv[1:3]
results = os.path.join(root, "results")
expected_min_rows = {
    "synthetic-clean": 80,
    "synthetic-continuous": 10,
    "synthetic-backpressure": 5,
    "synthetic-recovery": 5,
}

errors = []
for preset, expected in expected_min_rows.items():
    path = os.path.join(results, f"{run_tag}-{preset}-summary.csv")
    if not os.path.exists(path):
        errors.append(f"missing {os.path.basename(path)}")
        continue
    with open(path, newline="", encoding="utf-8-sig") as handle:
        rows = list(csv.DictReader(handle))
    if len(rows) < expected:
        errors.append(f"{os.path.basename(path)} has {len(rows)} rows, expected at least {expected}")
    invalid = [
        row.get("run_id", "")
        for row in rows
        if str(row.get("resource_stats_valid", "")).lower() != "true"
    ]
    if invalid:
        errors.append(f"{os.path.basename(path)} has invalid resource rows: {', '.join(invalid[:5])}")

if errors:
    for error in errors:
        print(f"VALIDATION ERROR: {error}", file=sys.stderr)
    sys.exit(1)

print("One-repetition remainder validation passed.")
PY

