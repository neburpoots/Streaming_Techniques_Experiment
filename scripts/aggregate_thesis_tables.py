#!/usr/bin/env python3
"""Aggregate RQ1 transport-benchmark CSVs and RQ3 DYNAMOS run JSONs into the
numbers used by the thesis tables.

RQ1: reads <prefix>-synthetic-{clean,continuous,backpressure,recovery}-summary.csv
files from the results directory. Rows are weighted by their repeat_count column
(1 if absent), so plain per-rep files and 5-rep aggregated files combine correctly.

RQ3: reads every *.json file containing a top-level "runs" list from the given
directories, filters to valid runs (ok == true, observedRows == expectedRows),
and groups by (implementation, archetype, providersLabel, limit). The
implementation is classic-unary for the baseline and the transport name for
batched runs, which keeps unary, streaming, and RabbitMQ Streams separate.

Usage (from repo root, inside WSL):

  python3 scripts/aggregate_thesis_tables.py \
      --rq1-dir experiments/grpc-streaming-baseline/results \
      --rq1-prefix rq1-concept5-clean-no256k-20260615 \
      --rq1-prefix rq1-concept5-scenarios-no256k-20260616 \
      --rq1-prefix rq1-nats-fetchwait-20260621 \
      --rq1-prefix rq1-extra5-no256k-20260709 \
      --exclude rq1-concept5-clean-no256k-20260615::nats-jetstream \
      --rq3 ~/src/DYNAMOS-clean-20260511/benchmark-results/<dir1> \
      --rq3 ~/src/DYNAMOS-clean-20260511/benchmark-results/<dir2> \
      --out thesis-data/aggregated-report.md

Adjust --rq1-prefix/--exclude so every cell ends up with exactly the intended
repetition count; the report prints per-cell counts so mistakes are visible.
"""

import argparse
import csv
import glob
import json
import os
import sys
from collections import defaultdict

SCENARIOS = ["clean", "continuous", "backpressure", "recovery"]

NUM_FIELDS = [
    "throughput_messages_per_second",
    "throughput_megabytes_per_second",
    "p50_latency_ms",
    "p95_latency_ms",
    "p99_latency_ms",
    "p95_inter_arrival_ms",
    "inter_arrival_jitter_ms",
    "duplicates",
    "ordering_violations",
    "pre_failure_throughput_msg_s",
    "recovery_window_throughput_msg_s",
    "post_recovery_throughput_msg_s",
    "time_to_first_post_failure_message_ms",
    "time_to_sustained_target_ms",
    "throughput_debt_recovery_window_msg",
    "recovery_window_p95_latency_ms",
    "post_failure_duplicates",
    "post_failure_ordering_violations",
    "backlog_drain_ms",
]
BOOL_FIELDS = ["sustained_target_within_run", "run_completed_within_deadline"]


def fnum(v):
    if v is None:
        return None
    v = str(v).strip().strip('"')
    if v in ("", "--", "n/a", "None"):
        return None
    try:
        return float(v)
    except ValueError:
        return None


class Cell:
    def __init__(self):
        self.weight = 0.0
        self.sums = defaultdict(float)
        self.wts = defaultdict(float)
        self.mins = {}
        self.maxs = {}
        self.bool_true = defaultdict(float)
        self.bool_n = defaultdict(float)

    def add(self, row, w):
        self.weight += w
        for f in NUM_FIELDS:
            x = fnum(row.get(f))
            if x is None:
                continue
            self.sums[f] += x * w
            self.wts[f] += w
            self.mins[f] = x if f not in self.mins else min(self.mins[f], x)
            self.maxs[f] = x if f not in self.maxs else max(self.maxs[f], x)
            # honour aggregated min/max columns when present
            lo, hi = fnum(row.get(f + "_min")), fnum(row.get(f + "_max"))
            if lo is not None:
                self.mins[f] = min(self.mins[f], lo)
            if hi is not None:
                self.maxs[f] = max(self.maxs[f], hi)
        for f in BOOL_FIELDS:
            v = str(row.get(f, "")).strip().strip('"').lower()
            if v in ("true", "1", "yes"):
                self.bool_true[f] += w
                self.bool_n[f] += w
            elif v in ("false", "0", "no"):
                self.bool_n[f] += w

    def mean(self, f):
        return self.sums[f] / self.wts[f] if self.wts.get(f) else None


def fmt(x, nd=2):
    return "--" if x is None else f"{x:,.{nd}f}"


def aggregate_rq1(results_dir, prefixes, excludes):
    cells = {s: defaultdict(Cell) for s in SCENARIOS}
    files_used = []
    for prefix in prefixes:
        for scen in SCENARIOS:
            for path in sorted(glob.glob(os.path.join(
                    results_dir, f"{prefix}-synthetic-{scen}-summary*.csv"))):
                # prefer the aggregated file when both exist for a prefix+scenario
                if path.endswith("-summary.csv") and os.path.exists(
                        path.replace("-summary.csv", "-summary-aggregated.csv")):
                    continue
                files_used.append(path)
                with open(path, newline="", encoding="utf-8") as fh:
                    for row in csv.DictReader(fh):
                        transport = row.get("transport_mode", "").strip('"')
                        if (prefix + "::" + transport) in excludes:
                            continue
                        w = fnum(row.get("repeat_count")) or 1.0
                        key = (transport,
                               int(fnum(row.get("payload_bytes")) or 0),
                               int(fnum(row.get("concurrency")) or 0))
                        cells[scen][key].add(row, w)
    return cells, files_used


def rq1_report(cells, out):
    out.append("# RQ1 aggregated results\n")
    # rep-count sanity table
    out.append("## Repetition counts per cell (check these first!)\n")
    for scen in SCENARIOS:
        counts = defaultdict(set)
        for (t, p, c), cell in sorted(cells[scen].items()):
            counts[t].add(int(cell.weight))
        line = ", ".join(f"{t}: {sorted(v)}" for t, v in sorted(counts.items()))
        out.append(f"- **{scen}**: {line}")
    out.append("")

    # clean summary per transport (avg over payloads x concurrency)
    out.append("## Clean summary (thesis Table: single-node synthetic-clean)\n")
    out.append("| Transport | Avg msg/s | Avg MiB/s | Avg p95 ms | Avg p99 ms | Duplicates (mean/run) | Ordering viol. |")
    out.append("|---|---|---|---|---|---|---|")
    per_t = defaultdict(list)
    for (t, p, c), cell in cells["clean"].items():
        per_t[t].append(cell)
    for t, cs in sorted(per_t.items()):
        def avg(f):
            vals = [c.mean(f) for c in cs if c.mean(f) is not None]
            return sum(vals) / len(vals) if vals else None
        out.append(f"| {t} | {fmt(avg('throughput_messages_per_second'))} | "
                   f"{fmt(avg('throughput_megabytes_per_second'))} | "
                   f"{fmt(avg('p95_latency_ms'))} | {fmt(avg('p99_latency_ms'))} | "
                   f"{fmt(avg('duplicates'))} | {fmt(avg('ordering_violations'))} |")
    out.append("")

    # per payload-size msg/s (appendix per-size table)
    out.append("## Clean msg/s by payload size (appendix per-size table)\n")
    sizes = sorted({p for (t, p, c) in cells["clean"]})
    transports = sorted({t for (t, p, c) in cells["clean"]})
    out.append("| Msg size | " + " | ".join(transports) + " |")
    out.append("|---" * (len(transports) + 1) + "|")
    for p in sizes:
        row = [f"| {p} B "]
        for t in transports:
            cs = [cell for (tt, pp, c), cell in cells["clean"].items()
                  if tt == t and pp == p]
            vals = [c.mean("throughput_messages_per_second") for c in cs
                    if c.mean("throughput_messages_per_second") is not None]
            row.append(f"| {fmt(sum(vals)/len(vals) if vals else None, 0)} ")
        out.append("".join(row) + "|")
    out.append("")

    # detailed per size x concurrency (msg/s, MiB/s, p95)
    for metric, nd, title in [("throughput_messages_per_second", 0, "msg/s"),
                              ("throughput_megabytes_per_second", 2, "MiB/s"),
                              ("p95_latency_ms", 1, "p95 latency ms")]:
        out.append(f"## Clean detailed {title} by size x concurrency (appendix)\n")
        out.append("| Size | Conc | " + " | ".join(transports) + " |")
        out.append("|---" * (len(transports) + 2) + "|")
        concs = sorted({c for (t, p, c) in cells["clean"]})
        for p in sizes:
            for c in concs:
                row = [f"| {p} | {c} "]
                for t in transports:
                    cell = cells["clean"].get((t, p, c))
                    row.append(f"| {fmt(cell.mean(metric) if cell else None, nd)} ")
                out.append("".join(row) + "|")
        out.append("")

    # continuous
    out.append("## Continuous scenario (thesis continuous table)\n")
    out.append("| Transport | Conc | Throughput | p95 ms | p95 inter-arrival | Jitter |")
    out.append("|---|---|---|---|---|---|")
    for (t, p, c), cell in sorted(cells["continuous"].items()):
        out.append(f"| {t} | {c} | {fmt(cell.mean('throughput_messages_per_second'))} | "
                   f"{fmt(cell.mean('p95_latency_ms'))} | "
                   f"{fmt(cell.mean('p95_inter_arrival_ms'))} | "
                   f"{fmt(cell.mean('inter_arrival_jitter_ms'))} |")
    out.append("")

    # backpressure
    out.append("## Backpressure scenario (thesis backpressure table)\n")
    out.append("| Transport | Throughput | Median ms | p95 ms | p95 inter-arrival | Jitter | Duplicates |")
    out.append("|---|---|---|---|---|---|---|")
    for (t, p, c), cell in sorted(cells["backpressure"].items()):
        out.append(f"| {t} | {fmt(cell.mean('throughput_messages_per_second'))} | "
                   f"{fmt(cell.mean('p50_latency_ms'))} | {fmt(cell.mean('p95_latency_ms'))} | "
                   f"{fmt(cell.mean('p95_inter_arrival_ms'))} | "
                   f"{fmt(cell.mean('inter_arrival_jitter_ms'))} | "
                   f"{fmt(cell.mean('duplicates'))} |")
    out.append("")

    # recovery
    out.append("## Recovery scenario (thesis recovery table)\n")
    out.append("| Transport | Pre msg/s | Recovery msg/s | Post msg/s | First post-fail ms | "
               "Sustained 80%/5s ms | Debt | Recovery p95 ms | Post-fail dup | Post-fail order | "
               "Backlog drain ms | Done fraction |")
    out.append("|---|---|---|---|---|---|---|---|---|---|---|---|")
    for (t, p, c), cell in sorted(cells["recovery"].items()):
        done = (cell.bool_true["run_completed_within_deadline"] /
                cell.bool_n["run_completed_within_deadline"]
                if cell.bool_n.get("run_completed_within_deadline") else None)
        out.append(f"| {t} | {fmt(cell.mean('pre_failure_throughput_msg_s'), 0)} | "
                   f"{fmt(cell.mean('recovery_window_throughput_msg_s'), 0)} | "
                   f"{fmt(cell.mean('post_recovery_throughput_msg_s'), 0)} | "
                   f"{fmt(cell.mean('time_to_first_post_failure_message_ms'))} | "
                   f"{fmt(cell.mean('time_to_sustained_target_ms'), 0)} | "
                   f"{fmt(cell.mean('throughput_debt_recovery_window_msg'), 0)} | "
                   f"{fmt(cell.mean('recovery_window_p95_latency_ms'))} | "
                   f"{fmt(cell.mean('post_failure_duplicates'), 0)} | "
                   f"{fmt(cell.mean('post_failure_ordering_violations'), 1)} | "
                   f"{fmt(cell.mean('backlog_drain_ms'))} | {fmt(done)} |")
    out.append("")


def aggregate_rq3(dirs):
    groups = defaultdict(list)
    skipped = []
    for d in dirs:
        for path in sorted(glob.glob(os.path.join(os.path.expanduser(d), "**", "*.json"),
                                     recursive=True)):
            try:
                with open(path, encoding="utf-8") as fh:
                    data = json.load(fh)
            except Exception:
                continue
            runs = data.get("runs") if isinstance(data, dict) else None
            if not runs:
                continue
            for r in runs:
                ok = r.get("ok") and r.get("observedRows") == r.get("expectedRows")
                response_mode = r.get("responseMode", "?")
                implementation = ("classic-unary" if response_mode == "classic-unary"
                                  else r.get("transport", response_mode))
                providers = r.get("providersLabel") or ",".join(r.get("providers") or []) or "?"
                limit = r.get("limit") or r.get("expectedRows")
                # The thesis reports 50k/100k/250k for the single-provider
                # primary matrix and 50k/250k for the two-provider compatibility
                # checks. Dedicated 100k compatibility runs remain archived but
                # are intentionally outside the reported corpus.
                if providers == "UVA,VU" and limit not in (50000, 250000):
                    continue
                key = (implementation, r.get("archetype", "?"), providers, limit)
                if ok:
                    groups[key].append(r)
                else:
                    skipped.append((path, r.get("repetition"), key))
    return groups, skipped


def rq3_report(groups, skipped, out):
    out.append("# RQ3 aggregated results\n")
    out.append("| Implementation | Archetype | Providers | Rows/provider | Valid reps | Mean done s | "
               "Min | Max | Mean first-result s | Mean post-first s | Mean partial chunks |")
    out.append("|---|---|---|---|---|---|---|---|---|---|---|")
    for key, runs in sorted(groups.items()):
        el = [r.get("doneSeconds", r.get("elapsedSeconds")) for r in runs
              if r.get("doneSeconds", r.get("elapsedSeconds")) is not None]
        fr = [r["firstResultSeconds"] for r in runs if r.get("firstResultSeconds") is not None]
        pf = [r.get("doneSeconds", r.get("elapsedSeconds")) - r["firstResultSeconds"]
              for r in runs if r.get("doneSeconds", r.get("elapsedSeconds")) is not None
              and r.get("firstResultSeconds") is not None]
        pc = [r.get("partialResultCount", 0) for r in runs]
        out.append(f"| {key[0]} | {key[1]} | {key[2]} | {key[3]} | {len(runs)} | "
                   f"{fmt(sum(el)/len(el), 3) if el else '--'} | "
                   f"{fmt(min(el), 3) if el else '--'} | {fmt(max(el), 3) if el else '--'} | "
                   f"{fmt(sum(fr)/len(fr), 3) if fr else '--'} | "
                   f"{fmt(sum(pf)/len(pf), 3) if pf else '--'} | "
                   f"{fmt(sum(pc)/len(pc), 1) if pc else '--'} |")
    out.append("")
    if skipped:
        out.append(f"**Skipped {len(skipped)} invalid runs** (not ok / row mismatch):")
        for path, rep, key in skipped[:20]:
            out.append(f"- rep {rep} of {key} in {os.path.basename(path)}")
        out.append("")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rq1-dir", default="experiments/grpc-streaming-baseline/results")
    ap.add_argument("--rq1-prefix", action="append", default=[])
    ap.add_argument("--exclude", action="append", default=[],
                    help="prefix::transport_mode pairs to skip")
    ap.add_argument("--rq3", action="append", default=[],
                    help="directory containing DYNAMOS run JSONs (repeatable)")
    ap.add_argument("--out", default="thesis-data/aggregated-report.md")
    args = ap.parse_args()

    out = []
    if args.rq1_prefix:
        cells, files_used = aggregate_rq1(args.rq1_dir, args.rq1_prefix, set(args.exclude))
        out.append("Files used:\n" + "\n".join(f"- {f}" for f in files_used) + "\n")
        rq1_report(cells, out)
    if args.rq3:
        groups, skipped = aggregate_rq3(args.rq3)
        rq3_report(groups, skipped, out)
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")
    print(f"Wrote {args.out}")
    print("Check the 'Repetition counts per cell' section: every cell should show the")
    print("intended total (e.g. [10]). Fix with --rq1-prefix/--exclude and rerun.")


if __name__ == "__main__":
    main()
