#!/usr/bin/env python3
import csv
import statistics
from collections import defaultdict
from pathlib import Path

path = Path("/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline/results/rq1-concept5-clean-no256k-20260615-synthetic-clean-reps1-3-derived.csv")
rows = list(csv.DictReader(path.open()))

def f(x):
    return float(x) if x not in ("", None) else None

by_payload = defaultdict(list)
by_transport = defaultdict(list)
by_ref = defaultdict(list)
for r in rows:
    r["msg_per_s"] = f(r["msg_per_s"])
    r["mib_per_s"] = f(r["mib_per_s"])
    r["duplicates"] = int(float(r["duplicates"] or 0))
    key = (r["transport"], int(r["payload_bytes"]))
    by_payload[key].append(r)
    by_transport[r["transport"]].append(r)
    by_ref[(r["transport"], int(r["payload_bytes"]), int(r["concurrency"]))].append(r)

transports = ["client-streaming", "batched-unary", "unary", "rabbitmq-streams", "nats-jetstream", "kafka"]
payloads = [256, 1024, 4096, 16384]

print("Mean msg/s by payload across concurrency 1,4,8,16 and reps 1-3:")
print("payload," + ",".join(transports))
for p in payloads:
    vals = []
    for t in transports:
        xs = [r["msg_per_s"] for r in by_payload[(t,p)] if r["msg_per_s"] is not None]
        vals.append(f"{statistics.mean(xs):.0f}")
    print(f"{p}," + ",".join(vals))

print()
print("Overall mean msg/s across all payload/concurrency cells and reps:")
for t in transports:
    xs = [r["msg_per_s"] for r in by_transport[t] if r["msg_per_s"] is not None]
    sd = statistics.stdev(xs) if len(xs) > 1 else 0
    print(f"{t}: mean={statistics.mean(xs):.1f}, sd={sd:.1f}, median={statistics.median(xs):.1f}, n={len(xs)}")

print()
print("Reference p1024 c8 mean over reps 1-3:")
for t in transports:
    xs = [r["msg_per_s"] for r in by_ref[(t,1024,8)] if r["msg_per_s"] is not None]
    print(f"{t}: mean={statistics.mean(xs):.1f}, median={statistics.median(xs):.1f}, vals={[round(x,1) for x in xs]}")
