"""Re-derive recovery metrics from existing sink-analysis JSON files.

Usage:
    python recovery_metrics.py <results-dir> [--run-id-prefix PREFIX] [--out PATH]

This script implements the same recovery metric definitions as the PowerShell
post-processor in export-results.ps1. It exists as a portable alternative for
re-deriving the new metric set against existing run artefacts without
re-running the experiments and without depending on PowerShell.

Definitions
-----------
The recovery scenario injects a transformer restart at failure_after_seconds
into the run. Define t_f := registered_at + failure_after_seconds and split the
run into three phases:

    pre_failure     : [t_start, t_f)
    recovery_window : [t_f, t_f + 10 s)
    post_recovery   : [t_f + 10 s, t_end]

Reported metrics
----------------
    pre_failure_throughput_msg_s          messages/sec in the pre-failure phase
    recovery_window_throughput_msg_s      messages/sec in the fixed 10 s window
    post_recovery_throughput_msg_s        messages/sec after the recovery window
    time_to_first_post_failure_message_ms first arrival after t_f
    time_to_sustained_target_ms           smallest 1 s bucket index B such that
                                          buckets B..B+4 each stay within the
                                          configured target band; null if never
                                          observed
    sustained_target_within_run           bool from the same detector
    throughput_debt_recovery_window_msg   sum over the 10 s window of
                                          max(0, target - actual) per 1 s bucket
    recovery_window_p95_latency_ms        p95 latency of arrivals in the window
    post_failure_duplicates               duplicates with arrival >= t_f
    post_failure_ordering_violations      ordering violations with arrival >= t_f
                                          (uses the new ordering_violation_arrival
                                          field where present; falls back to the
                                          run-total when older runs lack it)
    backlog_drain_ms                      finished_at - t_f
    run_completed_within_deadline         expected_messages were all received

This script intentionally does NOT emit e2e_recovery_ms or
sustained_target_recovered. The replacement metric is time_to_sustained_target_ms
with explicit null when the threshold is never reached, and a separate boolean.
For candidates that start inside the fixed recovery window, the detector also
requires the remaining complete one-second buckets in that window to stay above
the lower bound; this avoids treating an early broker replay plateau as stable
recovery when delivery falls off before the recovery window closes.
"""
from __future__ import annotations

import argparse
import csv
import json
import math
from pathlib import Path
from typing import Iterable

RECOVERY_WINDOW_SECONDS = 10
SUSTAINED_TARGET_FRACTION = 0.8
SUSTAINED_TARGET_BURST_CAP = 2.0
SUSTAINED_TARGET_BUCKETS = 5


def percentile(sorted_values: list[float], p: float) -> float | None:
    if not sorted_values:
        return None
    index = max(0, math.ceil(p * len(sorted_values)) - 1)
    index = min(index, len(sorted_values) - 1)
    return sorted_values[index]


def phase_throughput(
    events: Iterable[dict], start_ns: int, end_ns: int
) -> float | None:
    if end_ns <= start_ns:
        return None
    count = 0
    for event in events:
        arrival = int(event.get("arrival_at_unix_nano", 0))
        if start_ns <= arrival < end_ns:
            count += 1
    seconds = (end_ns - start_ns) / 1e9
    if seconds <= 0:
        return None
    return count / seconds


def compute_metrics(
    producer_result: dict, sink_summary: dict, sink_analysis: dict | None
) -> dict:
    expected = float(producer_result.get("expected_messages", 0) or 0)
    received = float(sink_summary.get("messages_received", 0) or 0)
    duplicates = float(sink_summary.get("duplicates", 0) or 0)
    ordering_violations = int(sink_summary.get("ordering_violations", 0) or 0)
    target = float(producer_result.get("target_messages_per_second", 0) or 0)
    failure_after_seconds = float(
        producer_result.get("failure_after_seconds", 0) or 0
    )

    completion_ratio = received / expected if expected > 0 else None
    duplicate_ratio = duplicates / expected if expected > 0 else None
    lost_messages = (
        int(expected - received) if expected > received else 0
    )

    out: dict = {
        "completion_ratio": completion_ratio,
        "lost_messages": lost_messages,
        "duplicate_ratio": duplicate_ratio,
        "estimated_failure_at_unix_nano": None,
        "pre_failure_throughput_msg_s": None,
        "recovery_window_throughput_msg_s": None,
        "post_recovery_throughput_msg_s": None,
        "time_to_first_post_failure_message_ms": None,
        "time_to_sustained_target_ms": None,
        "sustained_target_within_run": None,
        "throughput_debt_recovery_window_msg": None,
        "recovery_window_p95_latency_ms": None,
        "post_failure_duplicates": 0,
        "post_failure_duplicate_ratio": None,
        "post_failure_ordering_violations": 0,
        "backlog_drain_ms": None,
        "run_completed_within_deadline": (
            received >= expected if expected > 0 else None
        ),
    }

    if sink_analysis is None:
        return out

    registered_at = int(sink_analysis.get("registered_at_unix_nano", 0) or 0)
    started_at = int(sink_analysis.get("started_at_unix_nano", 0) or 0)
    finished_at = int(sink_analysis.get("finished_at_unix_nano", 0) or 0)

    if registered_at <= 0 or failure_after_seconds <= 0:
        return out

    failure_at = registered_at + int(failure_after_seconds * 1e9)
    out["estimated_failure_at_unix_nano"] = failure_at
    recovery_window_end = failure_at + RECOVERY_WINDOW_SECONDS * 1_000_000_000
    effective_start = started_at if started_at > 0 else registered_at

    events = list(sink_analysis.get("unique_events", []) or [])
    duplicate_arrivals = list(
        sink_analysis.get("duplicate_arrival_unix_nanos", []) or []
    )
    ordering_violation_arrivals = list(
        sink_analysis.get("ordering_violation_arrival_unix_nanos", []) or []
    )

    out["pre_failure_throughput_msg_s"] = phase_throughput(
        events, effective_start, failure_at
    )
    clamped_recovery_end = min(finished_at, recovery_window_end)
    out["recovery_window_throughput_msg_s"] = phase_throughput(
        events, failure_at, clamped_recovery_end
    )
    if finished_at > recovery_window_end:
        out["post_recovery_throughput_msg_s"] = phase_throughput(
            events, recovery_window_end, finished_at
        )

    post_failure_duplicates = sum(
        1 for ts in duplicate_arrivals if int(ts) >= failure_at
    )
    out["post_failure_duplicates"] = post_failure_duplicates
    if expected > 0:
        out["post_failure_duplicate_ratio"] = post_failure_duplicates / expected

    if ordering_violation_arrivals:
        out["post_failure_ordering_violations"] = sum(
            1 for ts in ordering_violation_arrivals if int(ts) >= failure_at
        )
    else:
        out["post_failure_ordering_violations"] = ordering_violations

    post_failure_events = [
        event
        for event in events
        if int(event.get("arrival_at_unix_nano", 0)) >= failure_at
    ]

    if post_failure_events:
        first_arrival = int(post_failure_events[0]["arrival_at_unix_nano"])
        out["time_to_first_post_failure_message_ms"] = (
            first_arrival - failure_at
        ) / 1e6

    if finished_at >= failure_at:
        out["backlog_drain_ms"] = (finished_at - failure_at) / 1e6

    out["sustained_target_within_run"] = False
    if target > 0 and post_failure_events:
        lower = SUSTAINED_TARGET_FRACTION * target
        upper = SUSTAINED_TARGET_BURST_CAP * target
        bucket_counts: dict[int, int] = {}
        for event in post_failure_events:
            offset = int(event["arrival_at_unix_nano"]) - failure_at
            bucket = max(0, offset // 1_000_000_000)
            bucket_counts[bucket] = bucket_counts.get(bucket, 0) + 1

        complete_bucket_count = (
            finished_at - failure_at
        ) // 1_000_000_000
        for start in range(
            0, int(complete_bucket_count) - SUSTAINED_TARGET_BUCKETS + 1
        ):
            sustained = True
            for k in range(SUSTAINED_TARGET_BUCKETS):
                count = bucket_counts.get(start + k, 0)
                if count < lower or count > upper:
                    sustained = False
                    break
            if not sustained:
                continue

            tail_end = max(
                RECOVERY_WINDOW_SECONDS, start + SUSTAINED_TARGET_BUCKETS
            )
            tail_end = min(tail_end, int(complete_bucket_count))
            for bucket in range(start + SUSTAINED_TARGET_BUCKETS, tail_end):
                if bucket_counts.get(bucket, 0) < lower:
                    sustained = False
                    break

            if sustained:
                out["time_to_sustained_target_ms"] = 1000.0 * start
                out["sustained_target_within_run"] = True
                break

    if target > 0:
        max_available = (finished_at - failure_at) // 1_000_000_000
        buckets_to_check = min(RECOVERY_WINDOW_SECONDS, int(max_available))
        if buckets_to_check > 0:
            debt = 0.0
            for window_index in range(buckets_to_check):
                window_start = failure_at + window_index * 1_000_000_000
                window_end = window_start + 1_000_000_000
                actual = sum(
                    1
                    for event in post_failure_events
                    if window_start
                    <= int(event["arrival_at_unix_nano"])
                    < window_end
                )
                if target > actual:
                    debt += target - actual
            out["throughput_debt_recovery_window_msg"] = debt

    recovery_latencies = sorted(
        float(event.get("latency_ms", 0))
        for event in post_failure_events
        if int(event["arrival_at_unix_nano"]) < recovery_window_end
    )
    out["recovery_window_p95_latency_ms"] = percentile(recovery_latencies, 0.95)

    return out


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("results_dir", type=Path)
    parser.add_argument("--run-id-prefix", default="")
    parser.add_argument(
        "--out",
        type=Path,
        default=None,
        help="output CSV path (default: <results-dir>/recovery-metrics.csv)",
    )
    args = parser.parse_args()

    if not args.results_dir.is_dir():
        raise SystemExit(f"Results directory not found: {args.results_dir}")

    out_path = (
        args.out
        if args.out is not None
        else args.results_dir / "recovery-metrics.csv"
    )

    rows: list[dict] = []
    for producer_path in sorted(args.results_dir.glob("*-producer-result.json")):
        producer = json.loads(producer_path.read_text())
        run_id = producer.get("run_id", "")
        if args.run_id_prefix and not run_id.startswith(args.run_id_prefix):
            continue

        sink_summary = producer.get("sink_summary", {}) or {}
        analysis_path = args.results_dir / f"{run_id}-sink-analysis.json"
        sink_analysis = (
            json.loads(analysis_path.read_text())
            if analysis_path.exists()
            else None
        )

        metrics = compute_metrics(producer, sink_summary, sink_analysis)
        row = {
            "run_id": run_id,
            "transport_mode": producer.get("transport_mode"),
            "payload_bytes": producer.get("payload_bytes"),
            "concurrency": producer.get("concurrency"),
            "target_messages_per_second": producer.get(
                "target_messages_per_second"
            ),
            "failure_after_seconds": producer.get("failure_after_seconds"),
            **metrics,
        }
        rows.append(row)

    if not rows:
        raise SystemExit("No matching producer result files were found.")

    fieldnames = list(rows[0].keys())
    with out_path.open("w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)

    print(f"Wrote recovery metric summary to {out_path}")


if __name__ == "__main__":
    main()
