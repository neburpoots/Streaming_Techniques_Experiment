#!/usr/bin/env bash
# Part 2 of the focused gap-fill campaign (tag rq1-rerun-20260610-fixed).
#
# Part 1 lost its budget to NATS concurrency>1 timeouts (each burned 15 min),
# so the deadline guard skipped kafka entirely. This part grabs the remaining
# high-value cells in ~40 minutes:
#   S1  nats clean p1024 c8 rep2  — diagnostic probe: passed rep1 on the old
#       image; tells us whether the rebuilt image broke nats at conc>1
#   S2+ kafka clean rep1, split per payload tier (bounded blast radius)
#   S7  continuous kafka rep1
#   S8  anomaly cells rep2 (F3)
# Images were already built+loaded in part 1: every step skips build/load.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-k8s-matrix.sh"
RESULTS="${ROOT}/results"
TAG="rq1-rerun-20260610-fixed-"
OVERLAY="resource-medium-single-2g"
KIND_NAME="grpc-stream-single"
START=$(date +%s)
DEADLINE_MIN=38
export CASE_DEADLINE_EPOCH=$(( START + DEADLINE_MIN * 60 ))

elapsed_min() { echo $(( ( $(date +%s) - START ) / 60 )); }

run_step() {
    local cutoff="$1" suffix="$2" ptimeout="$3" desc="$4"
    shift 4
    [[ "$1" == "--" ]] && shift
    local e; e=$(elapsed_min)
    if (( e >= cutoff )); then
        echo "@@@ SKIP [${e}m >= ${cutoff}m] ${desc}"
        return 0
    fi
    echo "@@@ STEP [${e}m] ${desc}"
    if ! env CONTINUE_ON_CASE_FAILURE=true \
             STRICT_RESOURCE_VALIDATION=false \
             FORCED_REP_SUFFIX="${suffix}" \
             PRODUCER_TIMEOUT_SECONDS="${ptimeout}" \
             bash "${RUNNER}" "$@" \
                 --overlay "${OVERLAY}" \
                 --run-id-prefix "${TAG}" \
                 --kind-cluster-name "${KIND_NAME}" \
                 --repeat 1 --skip-build --skip-load; then
        echo "@@@ STEP FAILED (continuing): ${desc}" >&2
    fi
}

echo "@@@ Part 2 started $(date -Is)"

# S1: diagnostic probe — did the new image break nats at conc>1?
run_step 999 "-rep2" "300s" "S1 nats clean p1024 c8 rep2 (probe)" -- \
    synthetic-clean --transport nats-jetstream --payload 1024 --concurrency 8

# S2-S6: kafka clean rep1, one payload tier per invocation
run_step 12 "-rep1" "420s" "S2 kafka clean p256" -- \
    synthetic-clean --transport kafka --payload 256
run_step 17 "-rep1" "420s" "S3 kafka clean p1024" -- \
    synthetic-clean --transport kafka --payload 1024
run_step 22 "-rep1" "420s" "S4 kafka clean p4096" -- \
    synthetic-clean --transport kafka --payload 4096
run_step 27 "-rep1" "420s" "S5 kafka clean p16384" -- \
    synthetic-clean --transport kafka --payload 16384
run_step 31 "-rep1" "600s" "S6 kafka clean p262144" -- \
    synthetic-clean --transport kafka --payload 262144

# S7: continuous kafka rep1
run_step 34 "-rep1" "420s" "S7 continuous kafka rep1" -- \
    synthetic-continuous --transport kafka

# S8: anomaly cells rep2 (F3)
run_step 36 "-rep2" "300s" "S8a clean rmqs p1024 c8 rep2" -- \
    synthetic-clean --transport rabbitmq-streams --payload 1024 --concurrency 8
run_step 37 "-rep2" "300s" "S8b clean rmqs p256 c16 rep2" -- \
    synthetic-clean --transport rabbitmq-streams --payload 256 --concurrency 16
run_step 38 "-rep2" "300s" "S8c clean stream p256 c8 rep2" -- \
    synthetic-clean --transport client-streaming --payload 256 --concurrency 8

# Final: regenerate summaries (clean + continuous changed)
POWERSHELL_EXE="${POWERSHELL_EXE:-/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe}"
run_ps() {
    local script="$1"; shift
    if command -v pwsh &>/dev/null; then
        pwsh -File "${script}" "$@"; return
    fi
    local wscript; wscript="$(wslpath -w "${script}")"
    local args=() a
    for a in "$@"; do
        case "${a}" in
            /*) args+=("$(wslpath -w "${a}")") ;;
            *)  args+=("${a}") ;;
        esac
    done
    "${POWERSHELL_EXE}" -NoProfile -ExecutionPolicy Bypass -File "${wscript}" "${args[@]}"
}

for preset in synthetic-clean synthetic-continuous; do
    prefix="${TAG}${preset}"
    echo "@@@ Exporting ${prefix} summary"
    run_ps "${ROOT}/scripts/export-results.ps1" \
        -ResultsDir "${RESULTS}" \
        -RunIdPrefix "${prefix}" \
        -OutputPath "${RESULTS}/${prefix}-summary.csv" || echo "@@@ export failed for ${preset}" >&2
    run_ps "${ROOT}/scripts/aggregate-repeat-results.ps1" \
        -SummaryPath "${RESULTS}/${prefix}-summary.csv" \
        -OutputPath "${RESULTS}/${prefix}-summary-aggregated.csv" || echo "@@@ aggregate failed for ${preset}" >&2
done

echo "@@@ Part 2 finished $(date -Is) (elapsed $(elapsed_min)m)"
