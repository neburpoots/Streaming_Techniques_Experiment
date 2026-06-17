#!/usr/bin/env bash
set -u

ROOT=/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline
RESULTS="${ROOT}/results"
LOG="${RESULTS}/rq1-concept5-clean-20260615.log"

echo "--- running processes ---"
ps -ef | grep -E 'run-rq1-concept5|run-k8s-matrix|grpc-stream-producer' | grep -v grep || true

echo "--- log stat ---"
stat "${LOG}" 2>&1 || true

echo "--- k8s all ---"
kubectl -n streaming-experiments get all -o wide 2>&1 | head -n 160 || true

echo "--- nats p256 c1 files ---"
find "${RESULTS}" -maxdepth 1 -type f -name 'rq1-concept5-clean-20260615-synthetic-clean-nats-p256-c1-rep1*' -printf '%TY-%Tm-%Td %TH:%TM:%TS %s %f\n' | sort || true

echo "--- all artifact counts by transport and rep ---"
python3 - <<'PY'
from pathlib import Path
import re
root = Path("/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline/results")
pat = re.compile(r"rq1-concept5-clean-20260615-synthetic-clean-(?P<t>[^-]+)-p(?P<p>\d+)-c(?P<c>\d+)-rep(?P<r>\d+)-producer-result\.json$")
counts = {}
for p in root.glob("rq1-concept5-clean-20260615-*-producer-result.json"):
    m = pat.match(p.name)
    if not m:
        continue
    key = (m.group("r"), m.group("t"))
    counts[key] = counts.get(key, 0) + 1
for key in sorted(counts):
    print(f"rep={key[0]} transport={key[1]} producer_results={counts[key]}")
print("total", sum(counts.values()))
PY

echo "--- log tail ---"
tail -n 120 "${LOG}" 2>&1 || true
