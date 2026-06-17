# Thesis Revision Spec — Benchmark Reruns + Text Edits

Purpose: single coordinated change list for the final thesis revision. Part A is the technical/benchmark work (hand to the coding agent). Part B is the verification work that must happen before or during Part A. Part C is the text-edit list for the final writing pass (do not start until Part A results are in). Finding IDs (F1–F12) refer to the review.

Decision already taken: **"robustness" stays in RQ3.** Part A.6 and C.9 define what must be added so that the claim survives a defense.

---

## Part A — Benchmark and implementation work

### A.1 RQ1 rerun campaign — run ONCE, with everything below included (F2, F3, F7, F8)

Do not start any reruns until all four changes are implemented, so the matrix is rerun a single time.

1. **Add a sixth transport mapping: batched unary gRPC (F7).**
   - Same pipeline (Producer → Transformer → Sink), unary RPCs carrying N records per call instead of one record per call.
   - Batch size: match what one RQ3 SQL chunk represents (see A.2); also acceptable: fixed N=100 plus the chunk-equivalent size as two sub-variants if cheap.
   - Purpose: RQ1 must contain the design that RQ3 later crowns (chunked unary), so the RQ1→RQ3 narrative predicts instead of contradicts.

2. **Add a large payload tier (F8).**
   - Current tiers: 256 B, 1 KiB, 4 KiB, 16 KiB. Add at least **256 KiB**; add 1 MiB if broker configs allow without special tuning.
   - First compute the actual serialized size of one RQ3 chunk (5,000 rows of the PersonenLarge/AanstellingenLarge join, protobuf-encoded) and record that number — it goes in the thesis text and justifies the chosen tier.

3. **Repetitions (F2).**
   - Clean matrix: minimum 3 repetitions per cell. Report median; keep per-rep values in the export.
   - Continuous, backpressure, recovery scenarios: minimum 3 repetitions per transport (currently 1).

4. **Anomaly cells (F3).**
   - The following clean-matrix cells from the current single-rep run are implausible and must be specifically checked against the new 3-rep medians:
     - RabbitMQ Streams: 1 KiB conc 8 (1,045 msg/s vs 23,577 at conc 4 and 15,091 at conc 16); 256 B conc 16 (1,553); 16 KiB conc 4/8/16 (769/466/899).
     - Client-streaming: 256 B conc 4 (118,209) vs conc 8 (66,768).
     - NATS: 256 B conc 8 (5,757) vs conc 16 (28,496).
   - If an anomaly persists across 3 reps, it is a finding — investigate the cause (likely broker flow-control or harness queueing) and note it. If it disappears, the old value was noise; the new medians replace it.

### A.2 NATS duplicate investigation (F4) — blocking for the throughput ranking

1. Determine whether sink msg/s counts **unique logical messages or total deliveries**. This decides whether NATS's clean-matrix throughput (13,116 avg) is inflated by redelivery.
   - If total: recompute all throughput numbers on unique-message basis and regenerate the summary/per-size tables.
   - If unique: no number changes; document it in the harness description.
2. Identify the redelivery cause for the ~5,086 clean-run duplicates. Hypothesis: `AckWait` too short under load → redelivery before ack. Confirm from consumer config + NATS server logs, fix or document the configured value.
3. After the fix/explanation, the duplicates in the new 3-rep clean runs should be ~0 or explained by a named mechanism with a config value. "At-least-once artefact" without specifics is not acceptable in the final text.

### A.3 Recovery preset changes

1. **Extend run length** so sustained recovery (80%/5s) is observable for transports that recover late. Current 20,000-message budget ends before five stable buckets exist. Increase the message budget / run duration so that every transport either reaches sustained recovery or demonstrably fails to within the window. Do **not** lower the 80% threshold — the metric definition stays as-is.
2. Keep the existing recovery metrics otherwise. A "--" cell that remains after the longer window is a result (transport did not reach sustained recovery), and will be stated as such in the text.

### A.4 Scope removals/additions (F10)

1. **Remove `csv-replay-check`** from the preset table and run-matrix table in the appendices (no results are reported anywhere; either it produces a reported result or it goes).
2. **Clustered 3-broker runs:** extract one small summary (per scenario: median + min–max across the 3 reps for each broker) so the body can cite them as variability evidence in one paragraph. They stay secondary evidence; no new clustered runs needed.

### A.5 RQ3 additions

1. **Transfer-time decomposition (F5).** No new instrumentation: derive `transfer ≈ completion − first-result` from existing per-rep data for every variant/size cell. Produce a derived table: control-path time vs data-path time, and data-path-only speedup ratios vs classic.
2. **Optional but recommended: one larger row count** (500k or 1M rows, single provider dataThroughTtp, all four variants, ≥3 reps) so fixed overhead falls below ~20% of total and end-to-end ratios stand on their own.
3. **Dispersion:** for every existing 10-rep cell, export min–max or IQR alongside the median (data already exists; this is post-processing).
4. **Resource sampling:** record and report the sampling interval used for the kubectl-based CPU/memory peaks. No methodology change needed, just the number.

### A.6 Robustness evidence for RQ3 (F1 — robustness stays, so it must be backed)

Keeping "robustness" in RQ3 requires all three of the following; the first two are documentation, the third is the only new experiment:

1. **Failure-mode inventory (qualitative table).** Document every concrete failure mode encountered during benchmarking, per variant: gRPC max-message-size failures, full-result buffering OOM/memory pressure, stale-job 502s / empty-provider responses, the multi-provider aggregate double-append bug, anything else observed. Columns: failure mode → affected variant(s) → trigger → whether chunking removes it by construction / by fix / not at all.
2. **By-construction argument.** Explicitly separate (a) bugs fixed in the classic baseline (engineering contribution, both paths now fixed — NOT evidence of streaming robustness) from (b) failure classes that scale with single-message size and are eliminated by chunking by design (size ceilings, peak-buffer OOM). Only (b) supports a robustness claim. The 4 MB ceiling discussion in the Stutterheim thesis is the anchor citation for (b).
3. **Minimal failure-injection check inside DYNAMOS.** One scenario: kill the data-provider job (or sidecar) mid-transfer at a fixed point (e.g., after ~40% of chunks), 3 repetitions per variant, 250k rows. Record per variant: what the client observes (hang / error / partial results retained), whether partial progress survives, recovery/abort time. Classic unary is expected to lose everything (first result = final result); chunked variants retain partials by construction — this measured contrast is what makes the robustness claim citable. Pass criterion for the experiment: a clean qualitative table, not performance numbers.

### A.7 Output format (so the writing pass can consume results directly)

For every rerun table deliver: median per cell + min–max (or all rep values), same units as current thesis tables (msg/s, MiB/s, ms), plus raw JSON/CSV exports in the results directory. Flag any cell where the new median moves a previously-stated ranking.

---

## Part B — Verification checklist (no code changes; must be answered in writing)

1. **F6 — measurement-window fairness.** For one repetition of each of the four RQ3 variants, confirm from timestamps/logs:
   - (a) Is job creation/pod startup inside the measured completion window? (Expected: yes for all, given ~6–7 s first-result times.)
   - (b) Does classic's between-rep cleanup run inside or between measured windows?
   - (c) Do chunked variants get warm-state advantages classic lacks (reused jobs, cached connections, warm pods)?
   Outcome: a short factual paragraph for the methods section. If any asymmetry is found, quantify it or equalize and rerun the affected baseline.
2. **A.2 prerequisite:** unique-vs-total message counting in the sink (see above).
3. **Chunk size:** serialized bytes of one 5,000-row chunk (feeds A.1.2 and the F8 text).

---

## Part C — Text edits (final writing pass; keyed to current main.tex sections)

Hold until Part A data is in. Listed here so nothing is lost.

1. **Section III title + structure.** Rename to reflect that it contains the full RQ1 study (e.g., "RQ1: Transport Benchmark — Design, Results, and Interpretation"). Consider promoting Results from a subsection.
2. **RQ1 unary framing (F7).** Add paragraph: per-message unary is a lower bound; the new batched-unary mapping shows how much of the gap is per-request overhead; connects directly to the RQ3 chunked-unary result.
3. **RQ1 Discussion rewrite.** Remove "RabbitMQ Streams is the strongest first implementation candidate" as a validated recommendation. New framing: batched/chunked transfer at existing boundaries = primary implementation hypothesis; RabbitMQ Streams = secondary hypothesis for the distributed inter-agent boundary. Keep the integration-fit reasoning itself (it is strong); state the two answers (benchmark winner vs architecture fit) in the first two sentences instead of teasing them.
4. **RQ3 discussion.** Add one sentence noting the RQ1 hypothesis only partially survived validation (chunking dominated; the broker added local cost; the decoupling argument remains untested locally).
5. **Clean-matrix anomalies (F3).** If anomalies persist at 3 reps: name them in the body and weaken within-broker ordering claims. If gone: nothing beyond updated numbers.
6. **NATS duplicates (F4).** Replace "at-least-once artefact" sentence with the named mechanism + config value; state unique-vs-total counting in metric definitions.
7. **Transfer decomposition (F5).** Add derived table + 2–3 sentences: control path ≈ constant ~X s across variants; data-path speedup is Y× at 250k. Keep end-to-end as the headline metric.
8. **F6 paragraph.** Insert the measurement-window fairness statement from Part B.1 into RQ3 benchmark method.
9. **Robustness (F1, kept).** In RQ3 method/results: add the failure-mode inventory table and the by-construction vs by-fix distinction (A.6.1/A.6.2); add the failure-injection results (A.6.3) as a short subsection. In the RQ3 answer: the robustness claim is worded as "chunked paths eliminate size-dependent failure classes by construction and retain partial progress under mid-transfer failure, whereas classic unary loses all progress" — no broader claim than the table supports.
10. **Main RQ closing paragraph (F9).** Add to Conclusion: streaming integrates by confining change to the post-approval bulk data path; compliance preservation is by construction (unchanged decision point, unchanged isolation) and was not separately tested; mid-stream policy revocation remains open.
11. **RQ3 threats-to-validity subsection (F12).** Collect: single local cluster; warm repetitions only; sampling-based peaks (state interval); 3-rep scenario checks; fixed 5,000-row chunk size (no sensitivity sweep); single workload shape; plus the F6 verification outcome.
12. **Appendix/body consistency (F10).** Remove csv-replay rows; add the clustered-run variability paragraph in Section III and align the appendix "Role in thesis" column with what the body actually shows.
13. **Recovery text fixes.** Rewrite the broken "NATS JetStream: the first post-failure message…" sentence; with the longer recovery window (A.3), update the table and explain any remaining "--" cells in prose; fix/explain the "Post msg/s 0.10" NATS cell.
14. **Structure.** Swap Future Work and Conclusion (or fold future work into the conclusion).
15. **Compression.** Keep the full "chunking, not the broker, causes the speedup" explanation once in the RQ3 discussion; compress the RQ2 and Conclusion repetitions to one sentence each.
16. **Metric definitions list.** (Deferred by author — leave as is for now.)

---

## Order of operations

1. Part B verifications (cheap, and B.2/B.3 are prerequisites for Part A).
2. Implement A.1 changes + A.2 fix + A.3 preset change → run the single RQ1 campaign.
3. A.5 post-processing + A.6.3 failure-injection runs (independent of RQ1 campaign; can run in parallel).
4. A.4 + A.7 exports.
5. Part C writing pass against the new numbers.
