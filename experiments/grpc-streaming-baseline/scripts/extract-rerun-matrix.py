#!/usr/bin/env python3
"""Per-size x transport msg/s matrix (rep1, averaged over concurrency) for the
rq1-rerun-20260610-fixed clean preset, in thesis column order."""
import csv
import os
from collections import defaultdict

results = os.path.join(os.path.dirname(__file__), "..", "results")
path = os.path.join(results, "rq1-rerun-20260610-fixed-synthetic-clean-summary.csv")
with open(path, encoding="utf-8-sig") as f:
    rows = [r for r in csv.DictReader(f) if r["run_id"].endswith("-rep1")]

order = ["client-streaming", "unary", "batched-unary", "rabbitmq-streams",
         "nats-jetstream", "kafka"]
agg = defaultdict(list)
for r in rows:
    agg[(r["transport_mode"], int(r["payload_bytes"]))].append(
        (float(r["throughput_messages_per_second"]),
         float(r["throughput_megabytes_per_second"]),
         int(r["concurrency"])))

hdr = "size    " + "".join(f"{t[:12]:>14}" for t in order)
print(hdr)
for size in (256, 1024, 4096, 16384, 262144):
    line = f"{size:<8}"
    for t in order:
        cells = agg.get((t, size), [])
        if not cells:
            line += f"{'--':>14}"
        else:
            ms = sum(c[0] for c in cells) / len(cells)
            n = len(cells)
            line += f"{ms:>10.0f} ({n})"
    print(line)

print()
print("MiB/s at 262144:")
for t in order:
    cells = agg.get((t, 262144), [])
    if cells:
        mib = sum(c[1] for c in cells) / len(cells)
        print(f"  {t:>18}: {mib:.1f} MiB/s over {len(cells)} cells")

print()
print("duplicates/ordering in rerun rep1 by transport:")
dups = defaultdict(int)
ovs = defaultdict(int)
for r in rows:
    dups[r["transport_mode"]] += int(float(r.get("duplicates", 0) or 0))
    ovs[r["transport_mode"]] += int(float(r.get("ordering_violations", 0) or 0))
for t in order:
    print(f"  {t:>18}: dups {dups.get(t,0)}, ordering {ovs.get(t,0)}")
