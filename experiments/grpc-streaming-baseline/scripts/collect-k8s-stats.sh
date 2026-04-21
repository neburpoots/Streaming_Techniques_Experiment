#!/usr/bin/env bash
set -euo pipefail

# Collects CPU and memory metrics from Kubernetes pods using kubectl top.
# Outputs NDJSON lines compatible with the export-results.ps1 parser.
#
# Usage:
#   ./collect-k8s-stats.sh [output-file]
#
# Environment:
#   NAMESPACE           Kubernetes namespace (default: streaming-experiments)
#   INTERVAL_SECONDS    Polling interval (default: 2)
#   STOP_FILE           Path to a file whose existence signals the collector to stop

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_FILE="${1:-${ROOT}/results/k8s-stats.ndjson}"
NAMESPACE="${NAMESPACE:-streaming-experiments}"
INTERVAL_SECONDS="${INTERVAL_SECONDS:-2}"
STOP_FILE="${STOP_FILE:-}"

mkdir -p "$(dirname "${OUTPUT_FILE}")"
: > "${OUTPUT_FILE}"

# Map pod labels to role names matching the Docker stats naming convention
resolve_role() {
    local pod_name="$1"
    case "${pod_name}" in
        grpc-stream-producer*) echo "producer" ;;
        grpc-stream-transformer*) echo "transformer" ;;
        grpc-stream-sink*) echo "sink" ;;
        grpc-stream-rabbitmq*) echo "rabbitmq" ;;
        *) echo "" ;;
    esac
}

# Convert kubectl top memory values (e.g., "123Mi", "1Gi") to a display string
# matching Docker stats format so export-results.ps1 can parse it.
normalize_memory() {
    local raw="$1"
    # kubectl top reports memory in Ki (kibibytes) or Mi (mebibytes)
    if [[ "${raw}" =~ ^([0-9]+)Ki$ ]]; then
        local kib="${BASH_REMATCH[1]}"
        awk "BEGIN { printf \"%.2fMiB\", ${kib}/1024 }"
    elif [[ "${raw}" =~ ^([0-9]+)Mi$ ]]; then
        echo "${BASH_REMATCH[1]}MiB"
    elif [[ "${raw}" =~ ^([0-9]+)Gi$ ]]; then
        echo "${BASH_REMATCH[1]}GiB"
    else
        echo "${raw}"
    fi
}

# Convert kubectl top CPU values (e.g., "250m", "1") to a percentage string
# matching Docker stats format (e.g., "25.00%").
normalize_cpu() {
    local raw="$1"
    if [[ "${raw}" =~ ^([0-9]+)m$ ]]; then
        local millicores="${BASH_REMATCH[1]}"
        awk "BEGIN { printf \"%.2f%%\", ${millicores}/10 }"
    elif [[ "${raw}" =~ ^([0-9]+)$ ]]; then
        local cores="${BASH_REMATCH[1]}"
        awk "BEGIN { printf \"%.2f%%\", ${cores}*100 }"
    else
        echo "0.00%"
    fi
}

while true; do
    if [[ -n "${STOP_FILE}" && -f "${STOP_FILE}" ]]; then
        break
    fi

    top_output="$(kubectl top pods -n "${NAMESPACE}" --no-headers 2>/dev/null || true)"

    # kubectl top pods outputs lines like:
    #   grpc-stream-sink-abc12   3m   45Mi
    while IFS= read -r line; do
        # Skip empty lines
        [[ -z "${line}" ]] && continue

        # Parse columns: NAME CPU MEMORY
        pod_name=$(echo "${line}" | awk '{print $1}')
        cpu_raw=$(echo "${line}" | awk '{print $2}')
        mem_raw=$(echo "${line}" | awk '{print $3}')

        role=$(resolve_role "${pod_name}")
        [[ -z "${role}" ]] && continue

        cpu_pct=$(normalize_cpu "${cpu_raw}")
        mem_display=$(normalize_memory "${mem_raw}")

        # Emit JSON matching the docker stats format that export-results.ps1 expects:
        # { "Name": "<role-matching-name>", "CPUPerc": "X.XX%", "MemUsage": "XXMiB / ..." }
        container_name="grpc-streaming-baseline-${role}-1"
        printf '{"Name":"%s","CPUPerc":"%s","MemUsage":"%s / 0B"}\n' \
            "${container_name}" "${cpu_pct}" "${mem_display}" >> "${OUTPUT_FILE}"
    done <<< "${top_output}"

    sleep "${INTERVAL_SECONDS}"
done
