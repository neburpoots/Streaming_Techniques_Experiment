#!/usr/bin/env python3
"""Numbers needed for the thesis rerun tables: bunary per-size averages and the
256 KiB tier across transports, from the rq1-rerun-20260610-fixed clean summary."""
import csv
import os
from collections import defaultdict

results = os.path.join(os.path.dirname(__file__), "..", "results")
path = os.path.join(results, "rq1-rerun-20260610-fixed-synthetic-clean-summary.csv")
with open(path, encoding="utf-8-sig") as f:
    rows = list(csv.DictReader(f))

print(f"total clean rows: {len(rows)}")
by_transport = defaultdict(list)
for r in rows:
    by_transport[r["transport_mode"]].append(r)
for t, v in sorted(by_transport.items()):
    sizes = sorted({int(r["payload_bytes"]) for r in v})
    print(f"{t}: {len(v)} cells, sizes {sizes}")

print()
print("=== batched-unary per size (avg over available concurrency) ===")
b = defaultdict(list)
for r in by_transport.get("batched-unary", []):
    b[int(r["payload_bytes"])].append(r)
for size, cells in sorted(b.items()):
    ms = sum(float(c["throughput_messages_per_second"]) for c in cells) / len(cells)
    mib = sum(float(c["throughput_megabytes_per_second"]) for c in cells) / len(cells)
    p95 = sum(float(c["latency_p95_ms"]) for c in cells) / len(cells) if "latency_p95_ms" in cells[0] else None
    print(f"{size:>7}: msg/s {ms:>9.0f}  MiB/s {mib:>7.2f}  n={len(cells)} p95 {p95}")

print()
print("=== overall batched-unary stats (all cells) ===")
cells = by_transport.get("batched-unary", [])
keys = [k for k in cells[0].keys()]
print("columns:", [k for k in keys if "p95" in k.lower() or "p99" in k.lower() or "dup" in k.lower() or "order" in k.lower()])

print()
print("=== p262144 tier, all transports, per concurrency ===")
for r in sorted(rows, key=lambda r: (r["transport_mode"], int(r["concurrency"]))):
    if r["payload_bytes"] == "262144":
        print(f"{r['transport_mode']:>18} c{r['concurrency']:>2}: "
              f"{float(r['throughput_messages_per_second']):>7.0f} msg/s "
              f"{float(r['throughput_megabytes_per_second']):>7.1f} MiB/s "
              f"({r['run_id'].rsplit('-',1)[-1]})")
