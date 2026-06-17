#!/usr/bin/env bash
# Quick inspection: elapsed seconds per completed cell for the fixed campaign.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../results"
for f in rq1-rerun-20260610-fixed-synthetic-clean-*-p262144-c1-rep1-producer-result.json \
         rq1-rerun-20260610-fixed-synthetic-clean-*-p262144-c16-rep1-producer-result.json \
         rq1-rerun-20260610-fixed-synthetic-clean-*-p1024-c8-rep1-producer-result.json; do
  [[ -f "$f" ]] || continue
  python3 - "$f" <<'EOF'
import json, sys
f = sys.argv[1]
d = json.load(open(f))
name = f.replace('rq1-rerun-20260610-fixed-synthetic-clean-', '').replace('-rep1-producer-result.json', '')
keys = {k.lower(): k for k in d}
def get(*cands):
    for c in cands:
        if c in keys:
            return d[keys[c]]
    return None
elapsed = get('elapsedseconds', 'durationseconds', 'elapsed_seconds', 'duration')
mps = get('messagespersecond', 'throughputmsgpersec', 'messages_per_second')
print(f"{name:24s} elapsed={elapsed} msg/s={mps}")
EOF
done
