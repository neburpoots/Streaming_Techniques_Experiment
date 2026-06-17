#!/usr/bin/env python3
"""Print tonight's batched-unary RQ1 results next to the other transports."""
import csv
import os
import sys

results = os.path.join(os.path.dirname(__file__), "..", "results")

def load(preset):
    path = os.path.join(results, f"rq1-rerun-20260610-fixed-{preset}-summary.csv")
    with open(path, encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))

dup_keys = ("sink_duplicates", "duplicates", "sink_duplicate_messages")

def dup(r):
    for k in dup_keys:
        if k in r and r[k] != "":
            return r[k]
    return "?"

print("=== batched-unary, synthetic-clean (rep1) ===")
print(f"{'payload':>8} {'conc':>4} {'msg/s':>9} {'MB/s':>7} {'dur s':>7} {'dups':>6}")
rows = [r for r in load("synthetic-clean") if r["transport_mode"] == "batched-unary"]
rows.sort(key=lambda r: (int(r["payload_bytes"]), int(r["concurrency"])))
for r in rows:
    print(f"{r['payload_bytes']:>8} {r['concurrency']:>4} "
          f"{float(r['throughput_messages_per_second']):>9.0f} "
          f"{float(r['throughput_megabytes_per_second']):>7.1f} "
          f"{float(r['duration_seconds']):>7.1f} {dup(r):>6}")

print()
print("=== per-transport clean mean msg/s (rep1 cells available tonight) ===")
agg = {}
for r in load("synthetic-clean"):
    agg.setdefault(r["transport_mode"], []).append(float(r["throughput_messages_per_second"]))
for t, v in sorted(agg.items(), key=lambda kv: -sum(kv[1]) / len(kv[1])):
    print(f"{t:>18}: mean {sum(v)/len(v):>9.0f} msg/s over {len(v):>2} cells")

print()
print("=== batched-unary vs others at p1024 c8 (the headline comparison cell) ===")
for r in load("synthetic-clean"):
    if r["payload_bytes"] == "1024" and r["concurrency"] == "8":
        print(f"{r['transport_mode']:>18}: {float(r['throughput_messages_per_second']):>9.0f} msg/s  "
              f"({r['run_id'].rsplit('-', 1)[-1]})")

print()
print("=== batched-unary scenario results ===")
for preset in ("synthetic-continuous", "synthetic-backpressure", "synthetic-recovery"):
    try:
        rows = [r for r in load(preset) if r["transport_mode"] == "batched-unary"]
    except FileNotFoundError:
        print(f"{preset}: no summary csv")
        continue
    for r in rows:
        print(f"{preset}: {r['run_id'].replace('rq1-rerun-20260610-fixed-', '')} "
              f"-> {float(r['throughput_messages_per_second']):.0f} msg/s, "
              f"dur {float(r['duration_seconds']):.1f}s, dups {dup(r)}")
