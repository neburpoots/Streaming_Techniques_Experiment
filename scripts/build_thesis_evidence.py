#!/usr/bin/env python3
"""Build the checked-in RQ1 and RQ3 evidence bundles used by the thesis.

The script deliberately uses an explicit source inventory. This prevents smoke
runs, failed attempts, or duplicated reruns from silently entering a thesis
average when benchmark result directories contain several experiments.
"""

from __future__ import annotations

import csv
import hashlib
import json
import shutil
from collections import defaultdict
from pathlib import Path


THESIS_REPO = Path("/home/nebur/Streaming_Techniques_Experiment")
DYNAMOS_REPO = Path("/home/nebur/src/DYNAMOS-streaming-concept-20260524")
DYNAMOS_RESULTS = Path("/home/nebur/src/DYNAMOS-clean-20260511/benchmark-results")

RQ1_RESULTS = THESIS_REPO / "experiments/grpc-streaming-baseline/results"
RQ1_OUT = THESIS_REPO / "thesis-evidence/rq1-10-repetitions"
RQ3_OUT = DYNAMOS_REPO / "thesis-evidence/rq3-combined-repetitions"

RQ1_SOURCES = [
    "rq1-concept5-clean-no256k-20260615-synthetic-clean-summary.csv",
    "rq1-concept5-scenarios-no256k-20260616-synthetic-continuous-summary-aggregated.csv",
    "rq1-concept5-scenarios-no256k-20260616-synthetic-backpressure-summary-aggregated.csv",
    "rq1-concept5-scenarios-no256k-20260616-synthetic-recovery-summary-aggregated.csv",
    "rq1-nats-fetchwait-20260621-synthetic-clean-summary-aggregated.csv",
    "rq1-nats-fetchwait-20260621-synthetic-continuous-summary-aggregated.csv",
    "rq1-nats-fetchwait-20260621-synthetic-backpressure-summary-aggregated.csv",
    "rq1-nats-fetchwait-20260621-synthetic-recovery-summary-aggregated.csv",
    "rq1-extra5-no256k-20260709-synthetic-clean-summary-aggregated.csv",
    "rq1-extra5-no256k-20260709-synthetic-continuous-summary-aggregated.csv",
    "rq1-extra5-no256k-20260709-synthetic-backpressure-summary-aggregated.csv",
    "rq1-extra5-no256k-20260709-synthetic-recovery-summary-aggregated.csv",
]

RQ3_OLD_PRIMARY = [
    DYNAMOS_RESULTS / "main-baseline-20260608/classic-dtt-uva-clean10-20260608/main-classic-dtt-uva-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/streaming-50000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/streaming-100000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/streaming-250000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/unary-50000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/unary-100k-10rep-rerun/unary-100000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/unary-250000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/rabbitmq-transports-50k-100k-250k-10rep/rabbitmq-streams-50000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/rabbitmq-100k-10rep-rerun-after-smoke/rabbitmq-streams-100000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/rabbitmq-250k-10rep-rerun-after-100k/rabbitmq-streams-250000-clean10.json",
]

RQ3_OLD_COMPAT_CLASSIC = [
    DYNAMOS_RESULTS / "main-baseline-20260609/classic-computeToData-multiprovider-clean10-20260609/main-classic-computeToData-multiprovider-clean10.json",
    DYNAMOS_RESULTS / "main-baseline-20260609/classic-dtt-multiprovider-clean10-20260609/main-classic-dtt-multiprovider-clean10.json",
]
RQ3_COMPAT_CHUNKED_EXTRA10_ROOT = (
    DYNAMOS_RESULTS / "rq3-compat-chunked-extra10-20260711/streaming/compatibility"
)

RQ3_OLD_PRIMARY_RESOURCES = [
    DYNAMOS_RESULTS / "concept-20260524-main-classic-10rep-cleaned/resources-main-classic-50000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-main-classic-10rep-cleaned/resources-main-classic-100000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-main-classic-10rep-cleaned/resources-main-classic-250000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/resources-streaming-50000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/resources-streaming-100000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/resources-streaming-250000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/resources-unary-50000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/unary-100k-10rep-rerun/resources-unary-100000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/direct-transports-50k-100k-250k-10rep/resources-unary-250000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/rabbitmq-transports-50k-100k-250k-10rep/resources-rabbitmq-streams-50000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/rabbitmq-100k-10rep-rerun-after-smoke/resources-rabbitmq-streams-100000-clean10.json",
    DYNAMOS_RESULTS / "concept-20260524-streaming-clean-focused/rabbitmq-250k-10rep-rerun-after-100k/resources-rabbitmq-streams-250000-clean10.json",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def reset_output(path: Path) -> Path:
    if path.exists():
        shutil.rmtree(path)
    source_dir = path / "source-results"
    source_dir.mkdir(parents=True)
    return source_dir


def copy_sources(paths: list[Path], source_dir: Path) -> list[dict[str, str]]:
    manifest = []
    for index, path in enumerate(paths, start=1):
        if not path.exists():
            raise FileNotFoundError(path)
        target = source_dir / f"{index:02d}-{path.name}"
        shutil.copy2(path, target)
        manifest.append({
            "copied_file": str(target.relative_to(source_dir.parent)),
            "original_path": str(path),
            "sha256": sha256(target),
        })
    return manifest


def number(value):
    if value in (None, "", "--"):
        return None
    return float(str(value).strip().strip('"'))


def build_rq1() -> None:
    source_dir = reset_output(RQ1_OUT)
    paths = [RQ1_RESULTS / name for name in RQ1_SOURCES]
    manifest = copy_sources(paths, source_dir)
    cells: dict[tuple, list[tuple[dict, float, str]]] = defaultdict(list)

    for path in paths:
        with path.open(newline="", encoding="utf-8-sig") as handle:
            for row in csv.DictReader(handle):
                transport = row["transport_mode"].strip('"')
                # The June 15/16 NATS rows predate the corrected pull-consumer
                # configuration. The dedicated June 21 five-run replacement is
                # combined with the July five-run campaign instead.
                if "rq1-concept5-" in path.name and transport == "nats-jetstream":
                    continue
                scenario = next(s for s in ("clean", "continuous", "backpressure", "recovery")
                                if f"synthetic-{s}" in path.name)
                key = (scenario, transport, int(number(row["payload_bytes"]) or 0),
                       int(number(row["concurrency"]) or 0))
                cells[key].append((row, number(row.get("repeat_count")) or 1.0, path.name))

    metrics = [
        "throughput_messages_per_second", "throughput_megabytes_per_second",
        "p50_latency_ms", "p95_latency_ms", "p99_latency_ms",
        "p95_inter_arrival_ms", "inter_arrival_jitter_ms", "duplicates",
        "ordering_violations", "pre_failure_throughput_msg_s",
        "recovery_window_throughput_msg_s", "post_recovery_throughput_msg_s",
        "time_to_first_post_failure_message_ms", "time_to_sustained_target_ms",
        "throughput_debt_recovery_window_msg", "recovery_window_p95_latency_ms",
        "post_failure_duplicates", "post_failure_ordering_violations", "backlog_drain_ms",
    ]
    summary_rows = []
    for key, entries in sorted(cells.items()):
        total = sum(weight for _, weight, _ in entries)
        out = {
            "scenario": key[0], "transport": key[1], "payload_bytes": key[2],
            "concurrency": key[3], "repetitions": int(total),
            "source_files": ";".join(sorted({source for _, _, source in entries})),
        }
        for metric in metrics:
            weighted = [(number(row.get(metric)), weight) for row, weight, _ in entries]
            weighted = [(value, weight) for value, weight in weighted if value is not None]
            out[metric] = (sum(value * weight for value, weight in weighted) /
                           sum(weight for _, weight in weighted)) if weighted else ""
        summary_rows.append(out)

    if any(row["repetitions"] != 10 for row in summary_rows):
        raise RuntimeError("RQ1 evidence does not contain exactly 10 repetitions per cell")
    write_csv(RQ1_OUT / "combined-cell-summary.csv", summary_rows)
    clean_by_transport = defaultdict(list)
    for row in summary_rows:
        if row["scenario"] == "clean":
            clean_by_transport[row["transport"]].append(row)
    summary_md = [
        "# RQ1 combined summary", "",
        "Every benchmark cell contains 10 repetitions.", "",
        "| Transport | Mean msg/s | Mean MiB/s | Mean p95 (ms) | Mean p99 (ms) |",
        "|---|---:|---:|---:|---:|",
    ]
    for transport, group in sorted(clean_by_transport.items()):
        averages = []
        for metric in ("throughput_messages_per_second", "throughput_megabytes_per_second",
                       "p95_latency_ms", "p99_latency_ms"):
            values = [float(row[metric]) for row in group]
            averages.append(sum(values) / len(values))
        summary_md.append(
            f"| {transport} | {averages[0]:,.2f} | {averages[1]:,.2f} | "
            f"{averages[2]:,.2f} | {averages[3]:,.2f} |")
    (RQ1_OUT / "SUMMARY.md").write_text("\n".join(summary_md) + "\n", encoding="utf-8")
    write_json(RQ1_OUT / "source-manifest.json", manifest)
    (RQ1_OUT / "README.md").write_text(
        "# RQ1 thesis evidence: 10 repetitions\n\n"
        "This directory contains the source summary exports and the combined cell-level "
        "arithmetic means used by the thesis. Every clean, continuous, backpressure, and "
        "recovery cell contains 10 repetitions. The corrected June 21 NATS pull-consumer "
        "campaign replaces the earlier June 15/16 NATS rows; it is combined with the July "
        "five-run campaign. `source-manifest.json` records original paths and SHA-256 hashes.\n\n"
        "The aggregation can be reproduced with `scripts/build_thesis_evidence.py` from the "
        "repository root.\n", encoding="utf-8")


def providers_label(run: dict) -> str:
    return run.get("providersLabel") or ",".join(run.get("providers") or [])


def accepted(run: dict) -> bool:
    return bool(run.get("ok") and run.get("observedRows") == run.get("expectedRows"))


def new_rq3_files(scope: str) -> list[Path]:
    root = DYNAMOS_RESULTS / "rq3-extra10-20260710"
    paths = []
    for path in root.glob(f"*/{scope}/**/*.json"):
        text = str(path)
        if path.name.startswith("resources-") or "previous-attempt-" in text:
            continue
        paths.append(path)
    return sorted(paths)


def compatibility_chunked_extra10_files() -> list[Path]:
    paths = []
    for path in RQ3_COMPAT_CHUNKED_EXTRA10_ROOT.glob("**/*.json"):
        text = str(path)
        if path.name.startswith("resources-") or "previous-attempt-" in text:
            continue
        paths.append(path)
    return sorted(paths)


def build_rq3() -> None:
    source_dir = reset_output(RQ3_OUT)
    primary_new = new_rq3_files("primary")
    compat_new = new_rq3_files("compatibility")
    compat_chunked_extra10 = compatibility_chunked_extra10_files()
    primary_new_resources = sorted(
        path for path in (DYNAMOS_RESULTS / "rq3-extra10-20260710").glob("*/primary/**/resources-*.json")
        if "previous-attempt-" not in str(path)
    )
    paths = RQ3_OLD_PRIMARY + RQ3_OLD_COMPAT_CLASSIC + primary_new + compat_new + compat_chunked_extra10
    resource_paths = RQ3_OLD_PRIMARY_RESOURCES + primary_new_resources
    manifest = copy_sources(paths + resource_paths, source_dir)
    rows = []

    source_sets = []
    source_sets += [("primary-original10", path) for path in RQ3_OLD_PRIMARY]
    source_sets += [("compatibility-classic-original10", path) for path in RQ3_OLD_COMPAT_CLASSIC]
    source_sets += [("primary-extra10", path) for path in primary_new]
    source_sets += [("compatibility-extra10", path) for path in compat_new]
    source_sets += [("compatibility-chunked-extra10-20260711", path)
                    for path in compat_chunked_extra10]

    for source_set, path in source_sets:
        data = json.loads(path.read_text(encoding="utf-8"))
        for run in data.get("runs", []):
            if not accepted(run):
                continue
            providers = providers_label(run)
            archetype = run.get("archetype")
            limit = run.get("limit")
            response_mode = run.get("responseMode")
            if source_set.startswith("primary"):
                if not (archetype == "dataThroughTtp" and providers == "UVA" and
                        limit in (50000, 100000, 250000)):
                    continue
            else:
                if not (archetype in ("computeToData", "dataThroughTtp") and
                        providers == "UVA,VU" and limit in (50000, 250000)):
                    continue
                if "classic-original10" in source_set and response_mode != "classic-unary":
                    continue
                if "chunked-extra10-20260711" in source_set and response_mode == "classic-unary":
                    continue
            done = run.get("doneSeconds", run.get("elapsedSeconds"))
            first = run.get("firstResultSeconds")
            rows.append({
                "scope": "primary" if source_set.startswith("primary") else "compatibility",
                "source_set": source_set,
                "source_file": path.name,
                "archetype": archetype,
                "providers": providers,
                "limit_per_provider": limit,
                "expected_rows": run.get("expectedRows"),
                "implementation": "classic-unary" if response_mode == "classic-unary" else run.get("transport"),
                "repetition": run.get("repetition"),
                "done_seconds": done,
                "first_result_seconds": first,
                "post_first_seconds": (done - first) if done is not None and first is not None else "",
                "partial_result_count": run.get("partialResultCount", 0),
                "observed_rows": run.get("observedRows"),
                "content_result_hash": run.get("contentResultHash", ""),
            })

    groups = defaultdict(list)
    for row in rows:
        key = (row["scope"], row["archetype"], row["providers"],
               row["limit_per_provider"], row["implementation"])
        groups[key].append(row)
    summary_rows = []
    for key, group in sorted(groups.items()):
        done = [float(row["done_seconds"]) for row in group]
        first = [float(row["first_result_seconds"]) for row in group if row["first_result_seconds"] != ""]
        post = [float(row["post_first_seconds"]) for row in group if row["post_first_seconds"] != ""]
        partial = [float(row["partial_result_count"]) for row in group]
        summary_rows.append({
            "scope": key[0], "archetype": key[1], "providers": key[2],
            "limit_per_provider": key[3], "implementation": key[4],
            "valid_repetitions": len(group), "mean_done_seconds": sum(done) / len(done),
            "min_done_seconds": min(done), "max_done_seconds": max(done),
            "mean_first_result_seconds": sum(first) / len(first),
            "mean_post_first_seconds": sum(post) / len(post),
            "mean_partial_result_count": sum(partial) / len(partial),
        })

    repetition_counts = {row["valid_repetitions"] for row in summary_rows}
    if repetition_counts != {20}:
        raise RuntimeError(f"RQ3 repetition counts are {repetition_counts}, expected 20")
    write_csv(RQ3_OUT / "accepted-runs.csv", rows)
    write_csv(RQ3_OUT / "combined-cell-summary.csv", summary_rows)
    summary_md = [
        "# RQ3 combined summary", "",
        "Every primary and compatibility cell contains 20 accepted repetitions.", "",
        "| Scope | Archetype | Providers | Limit/provider | Implementation | Reps | Mean done (s) | Min | Max |",
        "|---|---|---|---:|---|---:|---:|---:|---:|",
    ]
    for row in summary_rows:
        summary_md.append(
            f"| {row['scope']} | {row['archetype']} | {row['providers']} | "
            f"{row['limit_per_provider']} | {row['implementation']} | "
            f"{row['valid_repetitions']} | {row['mean_done_seconds']:.3f} | "
            f"{row['min_done_seconds']:.3f} | {row['max_done_seconds']:.3f} |")
    (RQ3_OUT / "SUMMARY.md").write_text("\n".join(summary_md) + "\n", encoding="utf-8")
    resource_rows = []
    for source_set, resource_paths_for_set in (
            ("primary-original10", RQ3_OLD_PRIMARY_RESOURCES),
            ("primary-extra10", primary_new_resources)):
        for path in resource_paths_for_set:
            data = json.loads(path.read_text(encoding="utf-8"))
            summary = data["resourceSummary"]
            name = path.name
            implementation = "classic-unary" if "classic" in name else (
                "rabbitmq-streams" if "rabbitmq-streams" in name else
                "streaming" if "streaming" in name else "unary")
            limit = next(value for value in (250000, 100000, 50000) if str(value) in name)
            resource_rows.append({
                "source_set": source_set,
                "source_file": name,
                "implementation": implementation,
                "limit_per_provider": limit,
                "peak_total_cpu_millicores": summary["maxTotalCpuMillicores"],
                "peak_total_memory_mib": summary["maxTotalMemoryBytes"] / 1048576,
                "sampling_interval_seconds": data.get("samplingIntervalSeconds", ""),
                "sample_count": summary.get("sampleCount", ""),
            })
    write_csv(RQ3_OUT / "resource-campaign-peaks.csv", resource_rows)
    resource_groups = defaultdict(list)
    for row in resource_rows:
        resource_groups[(row["implementation"], row["limit_per_provider"])].append(row)
    combined_resources = []
    for (implementation, limit), group in sorted(resource_groups.items()):
        combined_resources.append({
            "implementation": implementation,
            "limit_per_provider": limit,
            "campaigns": len(group),
            "repetitions_covered": 10 * len(group),
            "peak_total_cpu_millicores": max(float(row["peak_total_cpu_millicores"]) for row in group),
            "peak_total_memory_mib": max(float(row["peak_total_memory_mib"]) for row in group),
        })
    write_csv(RQ3_OUT / "combined-resource-peaks.csv", combined_resources)
    write_json(RQ3_OUT / "source-manifest.json", manifest)
    (RQ3_OUT / "README.md").write_text(
        "# RQ3 thesis evidence: combined repetitions\n\n"
        "The primary single-provider `dataThroughTtp` matrix combines the original 10-run "
        "campaign with the July 2026 extra-10 campaign. Every primary cell therefore has "
        "20 accepted repetitions. `accepted-runs.csv` contains one row per accepted run.\n\n"
        "The compatibility checks also combine two 10-run campaigns for every implementation. "
        "The earlier three-run chunked matrix is intentionally excluded from the thesis evidence "
        "so every compatibility cell has the same 20-repetition sample size.\n\n"
        "`source-results/` contains the exact result and resource-sampling JSON inputs. "
        "`combined-resource-peaks.csv` takes the maximum sampled peak across the two 10-run "
        "campaigns for each primary cell. `source-manifest.json` records original paths and "
        "SHA-256 hashes. Rebuild with "
        "`/home/nebur/Streaming_Techniques_Experiment/scripts/build_thesis_evidence.py`.\n",
        encoding="utf-8")


def write_csv(path: Path, rows: list[dict]) -> None:
    if not rows:
        raise RuntimeError(f"No rows for {path}")
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, value) -> None:
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


if __name__ == "__main__":
    build_rq1()
    build_rq3()
    print(f"Wrote {RQ1_OUT}")
    print(f"Wrote {RQ3_OUT}")
