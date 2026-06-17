#!/usr/bin/env python3
import csv
import json
import re
import statistics
from collections import defaultdict
from pathlib import Path

ROOT = Path("/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline")
RESULTS = ROOT / "results"
PREFIX = "rq1-concept5-clean-no256k-20260615"

PAT = re.compile(
    rf"{PREFIX}-synthetic-clean-(?P<short>[^-]+)-p(?P<payload>\d+)-c(?P<conc>\d+)-rep(?P<rep>\d+)-producer-result\.json$"
)

SHORT_TO_LABEL = {
    "stream": "client-streaming",
    "unary": "unary",
    "bunary": "batched-unary",
    "rmqs": "rabbitmq-streams",
    "nats": "nats-jetstream",
    "kafka": "kafka",
}

def get_num(d, *names):
    for name in names:
        if name in d and d[name] is not None:
            return d[name]
    return None

rows = []
for producer_file in RESULTS.glob(f"{PREFIX}-synthetic-clean-*-producer-result.json"):
    m = PAT.match(producer_file.name)
    if not m:
        continue
    rep = int(m.group("rep"))
    if rep not in (1, 2, 3):
        continue
    short = m.group("short")
    payload = int(m.group("payload"))
    conc = int(m.group("conc"))
    sink_file = producer_file.with_name(producer_file.name.replace("-producer-result.json", "-sink-summary.json"))
    if not sink_file.exists():
        continue
    prod = json.loads(producer_file.read_text())
    sink = json.loads(sink_file.read_text())

    sent = get_num(prod, "messages_sent", "MessagesSent", "sent")
    prod_duration = get_num(prod, "duration_seconds", "durationSeconds", "duration")
    sink_duration = get_num(sink, "duration_seconds", "durationSeconds", "duration")
    received = get_num(sink, "messages_received", "messagesReceived", "received")
    duplicates = get_num(sink, "duplicates", "duplicate_messages", "duplicateMessages") or 0
    throughput = get_num(sink, "messages_per_second", "messagesPerSecond", "throughput_messages_per_second")
    if throughput is None and received is not None and sink_duration:
        throughput = float(received) / float(sink_duration)
    mibps = None
    if throughput is not None:
        mibps = float(throughput) * payload / (1024 * 1024)

    rows.append({
        "transport": SHORT_TO_LABEL.get(short, short),
        "short": short,
        "payload_bytes": payload,
        "concurrency": conc,
        "rep": rep,
        "sent": sent,
        "received": received,
        "duplicates": duplicates,
        "producer_duration_s": prod_duration,
        "sink_duration_s": sink_duration,
        "msg_per_s": throughput,
        "mib_per_s": mibps,
    })

out = RESULTS / f"{PREFIX}-synthetic-clean-reps1-3-derived.csv"
with out.open("w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    writer.writeheader()
    writer.writerows(rows)

def med(xs):
    vals = [float(x) for x in xs if x is not None]
    return statistics.median(vals) if vals else None

def mean(xs):
    vals = [float(x) for x in xs if x is not None]
    return statistics.mean(vals) if vals else None

by_ref = defaultdict(list)
by_payload = defaultdict(list)
by_transport = defaultdict(list)
for r in rows:
    by_ref[(r["transport"], r["payload_bytes"], r["concurrency"])].append(r)
    by_payload[(r["transport"], r["payload_bytes"])].append(r)
    by_transport[r["transport"]].append(r)

summary = []
for key, vals in sorted(by_ref.items()):
    t, p, c = key
    summary.append({
        "transport": t,
        "payload_bytes": p,
        "concurrency": c,
        "reps": len(vals),
        "median_msg_per_s": med([v["msg_per_s"] for v in vals]),
        "mean_msg_per_s": mean([v["msg_per_s"] for v in vals]),
        "median_mib_per_s": med([v["mib_per_s"] for v in vals]),
        "median_duplicates": med([v["duplicates"] for v in vals]),
    })

summary_file = RESULTS / f"{PREFIX}-synthetic-clean-reps1-3-summary.csv"
with summary_file.open("w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=list(summary[0].keys()))
    writer.writeheader()
    writer.writerows(summary)

print(f"raw_rows={len(rows)}")
print(f"derived_csv={out}")
print(f"summary_csv={summary_file}")
print()
print("Reference cell p1024 c8, median over reps 1-3:")
for r in sorted(summary, key=lambda x: x["transport"]):
    if r["payload_bytes"] == 1024 and r["concurrency"] == 8:
        print(f"{r['transport']}: {r['median_msg_per_s']:.1f} msg/s, {r['median_mib_per_s']:.2f} MiB/s, reps={r['reps']}")
print()
print("Per payload median msg/s across all concurrencies and reps:")
for t in ["client-streaming", "batched-unary", "unary", "rabbitmq-streams", "nats-jetstream", "kafka"]:
    vals = by_transport[t]
    print(f"{t}: overall median={med([v['msg_per_s'] for v in vals]):.1f} msg/s, cells={len(vals)}")
    for payload in [256, 1024, 4096, 16384]:
        pv = by_payload[(t, payload)]
        print(f"  p{payload}: median={med([v['msg_per_s'] for v in pv]):.1f} msg/s, median MiB/s={med([v['mib_per_s'] for v in pv]):.2f}")
print()
print("Duplicate totals reps1-3:")
for t in ["client-streaming", "batched-unary", "unary", "rabbitmq-streams", "nats-jetstream", "kafka"]:
    vals = by_transport[t]
    print(f"{t}: duplicates={sum(int(v['duplicates'] or 0) for v in vals)}")
