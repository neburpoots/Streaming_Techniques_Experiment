#!/usr/bin/env bash
set -euo pipefail
cd /home/nebur/Streaming_Techniques_Experiment/master-thesis
echo "--- section headings ---"
grep -nE '\\(section|subsection|subsubsection)\\{' main.tex | sed -n '1,260p' || true
echo "--- rq1/batched references ---"
grep -nEi 'RQ1|research question 1|batched|chunked unary|unary|discussion|conclusion' main.tex | sed -n '1,260p' || true
