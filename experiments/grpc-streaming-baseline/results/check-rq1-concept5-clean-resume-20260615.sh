#!/usr/bin/env bash
set -u

RESULTS=/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline/results
LOG="${RESULTS}/rq1-concept5-clean-20260615-resume.log"

echo "--- resume log ---"
tail -n 80 "${LOG}" 2>/dev/null || true

echo "--- slice counts ---"
python3 - <<'PY'
from pathlib import Path
import re
root = Path("/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline/results")
pat = re.compile(r"rq1-concept5-clean-20260615-synthetic-clean-(?P<t>[^-]+)-p(?P<p>\d+)-c(?P<c>\d+)-rep(?P<r>\d+)-producer-result\.json$")
counts = {}
for p in root.glob("rq1-concept5-clean-20260615-*-producer-result.json"):
    m = pat.match(p.name)
    if m:
        counts[(int(m.group("r")), m.group("t"))] = counts.get((int(m.group("r")), m.group("t")), 0) + 1
for rep in range(1, 6):
    row = []
    for t in ["stream", "unary", "bunary", "rmqs", "nats", "kafka"]:
        row.append(f"{t}={counts.get((rep, t), 0):02d}")
    print(f"rep{rep}: " + " ".join(row))
PY

echo "--- k8s ---"
kubectl -n streaming-experiments get jobs,pods --no-headers 2>/dev/null | tail -n 60 || true
