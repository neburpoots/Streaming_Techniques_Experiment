#!/usr/bin/env python3
import csv
import json
import statistics
import sys
from collections import defaultdict
from pathlib import Path


def as_float(row, key):
    value = row.get(key, "")
    return float(value) if value not in ("", None) else None


def mean(values):
    values = [value for value in values if value is not None]
    return statistics.fmean(values) if values else None


def median(values):
    values = [value for value in values if value is not None]
    return statistics.median(values) if values else None


def minimum(values):
    values = [value for value in values if value is not None]
    return min(values) if values else None


def maximum(values):
    values = [value for value in values if value is not None]
    return max(values) if values else None


def sample_stdev(values):
    values = [value for value in values if value is not None]
    return statistics.stdev(values) if len(values) > 1 else 0.0 if values else None


def config_from_run_id(run_id):
    parts = run_id.split("-")
    if len(parts) < 5 or parts[0] != "kt":
        return None, None
    suite = parts[1]
    marker = parts.index("synthetic") if "synthetic" in parts else -1
    if marker < 3:
        return None, None
    return suite, "-".join(parts[2:marker])


def main():
    output_dir = Path(sys.argv[1])
    rows = []
    for path in sorted(output_dir.glob("*-synthetic-clean-summary.csv")):
        with path.open(encoding="utf-8-sig", newline="") as handle:
            rows.extend(csv.DictReader(handle))

    unique_rows = {row["run_id"]: row for row in rows if row.get("transport_mode") == "kafka"}
    grouped = defaultdict(list)
    for row in unique_rows.values():
        suite, config = config_from_run_id(row["run_id"])
        if suite and config:
            grouped[(suite, config, int(float(row["payload_bytes"])))].append(row)

    summary_rows = []
    for (suite, config, payload), group in sorted(grouped.items()):
        throughputs = [as_float(row, "throughput_messages_per_second") for row in group]
        p95_latencies = [as_float(row, "p95_latency_ms") for row in group]
        summary_rows.append({
            "suite": suite,
            "config": config,
            "payload_bytes": payload,
            "runs": len(group),
            "throughput_msg_s_mean": mean(throughputs),
            "throughput_msg_s_median": median(throughputs),
            "throughput_msg_s_stdev": sample_stdev(throughputs),
            "throughput_msg_s_min": minimum(throughputs),
            "throughput_msg_s_max": maximum(throughputs),
            "throughput_mib_s_mean": mean(as_float(row, "throughput_megabytes_per_second") for row in group),
            "p95_latency_ms_mean": mean(p95_latencies),
            "p95_latency_ms_median": median(p95_latencies),
            "p95_latency_ms_min": minimum(p95_latencies),
            "p95_latency_ms_max": maximum(p95_latencies),
            "p99_latency_ms_mean": mean(as_float(row, "p99_latency_ms") for row in group),
            "duration_s_mean": mean(as_float(row, "duration_seconds") for row in group),
            "duplicates_total": sum(int(float(row.get("duplicates", 0) or 0)) for row in group),
            "ordering_violations_total": sum(int(float(row.get("ordering_violations", 0) or 0)) for row in group),
            "completion_ratio_min": min(as_float(row, "completion_ratio") or 0 for row in group),
            "resource_invalid_runs": sum(
                str(row.get("resource_stats_valid", "")).lower() != "true" for row in group
            ),
            "kafka_cpu_peak_pct_mean": mean(as_float(row, "kafka_cpu_peak_pct") for row in group),
            "kafka_memory_peak_mib_mean": mean(as_float(row, "kafka_memory_peak_mib") for row in group),
            "transformer_cpu_peak_pct_mean": mean(as_float(row, "transformer_cpu_peak_pct") for row in group),
            "sink_cpu_peak_pct_mean": mean(as_float(row, "sink_cpu_peak_pct") for row in group),
        })

    csv_path = output_dir / "kafka-tuning-summary.csv"
    if summary_rows:
        with csv_path.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=list(summary_rows[0]))
            writer.writeheader()
            writer.writerows(summary_rows)

    json_path = output_dir / "kafka-tuning-summary.json"
    json_path.write_text(json.dumps(summary_rows, indent=2), encoding="utf-8")

    print(f"Analyzed {len(unique_rows)} Kafka runs into {len(summary_rows)} cells")
    for row in summary_rows:
        print(
            f"{row['suite']:10} {row['config']:18} p={row['payload_bytes']:5} "
            f"n={row['runs']} msg/s={row['throughput_msg_s_mean'] or 0:10.1f} "
            f"MiB/s={row['throughput_mib_s_mean'] or 0:8.1f} "
            f"p95={row['p95_latency_ms_mean'] or 0:8.1f}ms "
            f"order={row['ordering_violations_total']}"
        )


if __name__ == "__main__":
    main()
