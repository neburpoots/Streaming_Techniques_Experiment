#!/usr/bin/env python3
import csv
import sys
from pathlib import Path


def main():
    output_dir = Path(sys.argv[1])
    runs = {}
    for path in output_dir.glob("*-synthetic-clean-summary.csv"):
        with path.open(encoding="utf-8-sig", newline="") as handle:
            for row in csv.DictReader(handle):
                if row.get("transport_mode") == "kafka":
                    runs[row["run_id"]] = row

    failures = []
    for run_id, row in sorted(runs.items()):
        checks = {
            "message count": int(float(row["messages_received"])) == int(float(row["expected_messages"])),
            "completion ratio": float(row["completion_ratio"]) == 1.0,
            "lost messages": int(float(row["lost_messages"])) == 0,
            "deadline": row["run_completed_within_deadline"].lower() == "true",
            "resource samples": row["resource_stats_valid"].lower() == "true",
        }
        for label, valid in checks.items():
            if not valid:
                failures.append(f"{run_id}: {label}")

    duplicates = sum(int(float(row["duplicates"] or 0)) for row in runs.values())
    ordering = sum(int(float(row["ordering_violations"] or 0)) for row in runs.values())
    print(f"runs={len(runs)} failures={len(failures)} duplicates={duplicates} ordering_violations={ordering}")
    for failure in failures:
        print(failure)
    raise SystemExit(1 if failures else 0)


if __name__ == "__main__":
    main()
