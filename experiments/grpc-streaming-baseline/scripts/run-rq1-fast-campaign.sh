#!/usr/bin/env bash
# Gap-fill campaign (~1.5-2 h) completing the rq1-rerun-20260610-fixed dataset.
#
# The original campaign (ended 19:46) already produced:
#   clean rep1:  stream/unary/bunary/rmqs complete, nats 16/20, kafka 0/20
#   continuous:  rep1 for stream/unary/bunary/rmqs(c4) only
#   backpressure: almost nothing
#   recovery:    reps 1+2 all six transports, rep3 missing nats+kafka
#
# This script fills the gaps under the SAME run tag so exports merge:
#   1. continuous, all transports, 2 repetitions (fresh, consistent)
#   2. backpressure, all transports, 2 repetitions
#   3. recovery rep3 fill: nats + kafka (longer timeouts)
#   4. clean rep1 fill: all kafka cells
#   5. clean rep1 fill: nats 256 KiB cells (longer timeouts; known-risky,
#      runs last so a failure costs nothing else)
#
# Launch (from experiments/grpc-streaming-baseline):
#   nohup bash scripts/run-rq1-fast-campaign.sh \
#       > results/rq1-gapfill-20260610-campaign.log 2>&1 &

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MATRIX="${ROOT}/scripts/run-k8s-matrix.sh"
TAG="rq1-rerun-20260610-fixed-"
OVERLAY="resource-medium-single-2g"
KIND_CONTEXT="kind-grpc-stream-single"
NAMESPACE="streaming-experiments"
START_TS=$(date +%s)

export PATH="/tmp/agent-bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

elapsed_min() { echo $(( ( $(date +%s) - START_TS ) / 60 )); }

echo "RQ1 gap-fill campaign start $(date -Is)"

if command -v kubectl >/dev/null 2>&1 && kubectl version --client >/dev/null 2>&1; then
    KUBECTL=(kubectl)
elif [[ -x "/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe" ]]; then
    KUBECTL=("/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe")
else
    echo "kubectl not found" >&2
    exit 1
fi

# Dedicated benchmark cluster only - never the DYNAMOS one.
if ! "${KUBECTL[@]}" config use-context "${KIND_CONTEXT}"; then
    echo "Could not switch to context ${KIND_CONTEXT}; aborting." >&2
    exit 1
fi

# Defensive cleanup of any stale runner/job (the old campaign already exited).
pkill -f "run-k8s-matrix.sh" 2>/dev/null || true
sleep 3
"${KUBECTL[@]}" delete job grpc-stream-producer -n "${NAMESPACE}" \
    --ignore-not-found=true --wait=true --timeout=90s || true

run_phase() {
    local name="$1"; shift
    echo ""
    echo "════ Phase ${name} starting (elapsed: $(elapsed_min) min) ════"
    if bash "${MATRIX}" "$@" \
        --overlay "${OVERLAY}" \
        --run-id-prefix "${TAG}" \
        --namespace "${NAMESPACE}" \
        --skip-build --skip-load; then
        echo "════ Phase ${name} done (elapsed: $(elapsed_min) min) ════"
    else
        echo "!!!! Phase ${name} FAILED (elapsed: $(elapsed_min) min); continuing with next phase" >&2
    fi
}

# ── 1. Continuous: full rerun, 2 reps (overwrites the partial rep1) ──
run_phase continuous synthetic-continuous --repeat 2

# ── 2. Backpressure: full rerun, 2 reps ──
run_phase backpressure synthetic-backpressure --repeat 2

# ── 3. Recovery rep3 fill: the two transports the abort skipped ──
FORCED_REP_SUFFIX="-rep3" PRODUCER_TIMEOUT_SECONDS="900s" MAX_SUMMARY_WAIT_OVERRIDE="600" \
    run_phase recovery-nats-rep3 synthetic-recovery --repeat 1 --transport nats-jetstream
FORCED_REP_SUFFIX="-rep3" PRODUCER_TIMEOUT_SECONDS="900s" MAX_SUMMARY_WAIT_OVERRIDE="600" \
    run_phase recovery-kafka-rep3 synthetic-recovery --repeat 1 --transport kafka

# ── 4. Clean rep1 fill: all 20 kafka cells ──
FORCED_REP_SUFFIX="-rep1" \
    run_phase clean-kafka synthetic-clean --repeat 1 --transport kafka

# ── 5. Clean rep1 fill: nats 256 KiB (known-risky; longer timeouts; last) ──
FORCED_REP_SUFFIX="-rep1" PRODUCER_TIMEOUT_SECONDS="900s" MAX_SUMMARY_WAIT_OVERRIDE="600" \
    run_phase clean-nats-256k synthetic-clean --repeat 1 --transport nats-jetstream --payload 262144

echo ""
echo "RQ1 gap-fill campaign finished $(date -Is) (total: $(elapsed_min) min)"
