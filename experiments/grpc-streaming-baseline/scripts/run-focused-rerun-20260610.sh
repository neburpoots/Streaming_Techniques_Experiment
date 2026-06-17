#!/usr/bin/env bash
# Focused gap-fill campaign for run tag rq1-rerun-20260610-fixed.
#
# Tonight's full campaign aborted three times (NATS 256 KiB stream-cap hang,
# strict resource validation, NATS recovery rep3 timeout). This script fills
# the holes in priority order under a hard time budget instead of rerunning
# everything:
#   P1  clean nats p262144 rep1            (new payload tier, was hanging)
#   P2  clean kafka rep1 (all 20 cells)    (whole transport missing)
#   P3  continuous nats+kafka rep1         (table holes)
#   P4  backpressure rep1 all transports   (only stream existed)
#   P5  anomaly cells rep2                 (F3: rmqs/stream instability)
#   P6  clean bunary rep2 (all 20 cells)   (second rep for the new transport)
#   P7+ second reps for p262144 row, continuous, backpressure (time permitting)
#
# Every step runs with CONTINUE_ON_CASE_FAILURE=true so a single flaky cell
# is logged and skipped rather than killing the campaign, and every case
# checks CASE_DEADLINE_EPOCH so the campaign cannot run far past its budget.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-k8s-matrix.sh"
RESULTS="${ROOT}/results"
TAG="rq1-rerun-20260610-fixed-"
OVERLAY="resource-medium-single-2g"
KIND_NAME="grpc-stream-single"
START=$(date +%s)
# No new case may START after this many minutes; in-flight cases finish.
DEADLINE_MIN=78
export CASE_DEADLINE_EPOCH=$(( START + DEADLINE_MIN * 60 ))

elapsed_min() { echo $(( ( $(date +%s) - START ) / 60 )); }

# run_step <cutoff-min> <rep-suffix> <producer-timeout> <desc> -- <runner args...>
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
                 --repeat 1; then
        echo "@@@ STEP FAILED (continuing): ${desc}" >&2
    fi
}

echo "@@@ Focused rerun started $(date -Is)"

# ── P1: smoke + NATS 256 KiB fix validation (includes image build + load) ──
run_step 999 "-rep1" "900s" "P1a clean nats p262144 c1 (smoke, build+load)" -- \
    synthetic-clean --transport nats-jetstream --payload 262144 --concurrency 1

if [[ -f "${RESULTS}/${TAG}synthetic-clean-nats-p262144-c1-rep1-producer-result.json" ]]; then
    echo "@@@ SMOKE PASSED: NATS 256 KiB fix works"
    for c in 4 8 16; do
        run_step 40 "-rep1" "900s" "P1b clean nats p262144 c${c}" -- \
            synthetic-clean --transport nats-jetstream --payload 262144 --concurrency "${c}" \
            --skip-build --skip-load
    done
else
    echo "@@@ SMOKE FAILED: NATS p262144 c1 produced no artifact; skipping remaining nats p262144 cells" >&2
fi

# ── P2: kafka clean rep1, completes the six-transport matrix ──
run_step 50 "-rep1" "600s" "P2 clean kafka all payloads/concurrency" -- \
    synthetic-clean --transport kafka --skip-build --skip-load

# ── P3: continuous rep1 holes ──
run_step 62 "-rep1" "420s" "P3a continuous nats rep1" -- \
    synthetic-continuous --transport nats-jetstream --skip-build --skip-load
run_step 64 "-rep1" "420s" "P3b continuous kafka rep1" -- \
    synthetic-continuous --transport kafka --skip-build --skip-load

# ── P4: backpressure rep1, all six transports in one invocation
#        (redoes the one existing stream cell; cheaper than 5 invocations) ──
run_step 70 "-rep1" "420s" "P4 backpressure all transports rep1" -- \
    synthetic-backpressure --skip-build --skip-load

# ── P5: rep2 for the anomalous clean cells (F3) ──
run_step 74 "-rep2" "420s" "P5a clean rmqs p1024 c8 rep2" -- \
    synthetic-clean --transport rabbitmq-streams --payload 1024 --concurrency 8 --skip-build --skip-load
run_step 75 "-rep2" "420s" "P5b clean rmqs p256 c16 rep2" -- \
    synthetic-clean --transport rabbitmq-streams --payload 256 --concurrency 16 --skip-build --skip-load
run_step 76 "-rep2" "420s" "P5c clean stream p256 c8 rep2" -- \
    synthetic-clean --transport client-streaming --payload 256 --concurrency 8 --skip-build --skip-load

# ── P6: second rep for the new transport (batched unary), full clean row ──
run_step 78 "-rep2" "600s" "P6 clean bunary rep2 all cells" -- \
    synthetic-clean --transport batched-unary --skip-build --skip-load

# ── P7: bonus second reps, time permitting ──
for t in client-streaming unary rabbitmq-streams; do
    run_step 76 "-rep2" "600s" "P7 clean ${t} p262144 rep2" -- \
        synthetic-clean --transport "${t}" --payload 262144 --skip-build --skip-load
done
run_step 77 "-rep2" "420s" "P8 continuous all rep2" -- \
    synthetic-continuous --skip-build --skip-load
run_step 78 "-rep2" "420s" "P9 backpressure all rep2" -- \
    synthetic-backpressure --skip-build --skip-load

# ── Final: regenerate summary + aggregated CSVs for every preset ──
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

for preset in synthetic-clean synthetic-continuous synthetic-backpressure synthetic-recovery; do
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

echo "@@@ Focused rerun finished $(date -Is) (elapsed $(elapsed_min)m)"
