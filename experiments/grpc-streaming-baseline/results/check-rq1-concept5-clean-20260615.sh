#!/usr/bin/env bash
set -euo pipefail

ROOT=/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
RESULTS="${ROOT}/results"
LOG="${RESULTS}/rq1-concept5-clean-20260615.log"

echo "--- progress ---"
if [[ -f "${LOG}" ]]; then
  grep -E '^━━━ Running:|^═══ Repetition|  Done:|Case failed|Skipping|Exporting|Preset' "${LOG}" | tail -n 60 || true
else
  echo "missing log: ${LOG}"
fi

echo "--- counts ---"
producer_count=$(find "${RESULTS}" -maxdepth 1 -type f -name 'rq1-concept5-clean-20260615-*-producer-result.json' | wc -l)
sink_count=$(find "${RESULTS}" -maxdepth 1 -type f -name 'rq1-concept5-clean-20260615-*-sink-summary.json' | wc -l)
echo "producer_results=${producer_count}"
echo "sink_summaries=${sink_count}"

echo "--- latest producer ---"
latest=$(find "${RESULTS}" -maxdepth 1 -type f -name 'rq1-concept5-clean-20260615-*-producer-result.json' -printf '%T@ %p\n' | sort -nr | head -n 1 | cut -d' ' -f2- || true)
if [[ -n "${latest}" ]]; then
  python3 - "${latest}" <<'PY'
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
data = json.loads(p.read_text())
print(p.name)
for key in ("transport", "payload_bytes", "concurrency", "messages_sent", "duration_seconds", "target_rate", "scenario"):
    if key in data:
        print(f"{key}={data[key]}")
PY
fi

echo "--- current k8s ---"
kubectl -n streaming-experiments get jobs,pods --no-headers 2>/dev/null | tail -n 40 || true
