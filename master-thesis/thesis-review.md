# Review: *Streaming Communication for Scalable Data Exchange in DYNAMOS*

A close, human read of the full thesis (introduction → conclusion, appendices, and bibliography). I read it the way a committee member would: does the story hold together, does the evidence support the claims, and does the work add something. Below is an overall verdict, then the issues that actually matter (ordered by importance), then a section-by-section pass, then a concrete fix list.

---

## 1. Overall verdict

This is a solid, honest, engineering-substantial master's thesis with a genuinely good central insight. The three-RQ arc is coherent and the writing is clear and self-aware — it repeatedly resists overclaiming, which is rare and valuable. The strongest intellectual move is empirical and well-earned: **the bulk-transfer win comes from amortising per-message overhead (chunking/batching), not from "streaming" as a category.** That conclusion falls out of the data (batched unary ≈ client-streaming; unary is slow *only* because it sends one record per request) and is threaded cleanly through all three chapters.

The main weakness is not the work — it's the **gap between what the framing promises and what the evaluation delivers.** The title, abstract, and introduction foreground *streaming*, *policy compliance*, and *scalable distributed exchange*. The delivered, validated result is *chunked unary lowers completion time and peak memory for local bulk retrieval*. Both are true; they are just not the same claim. Closing that gap — mostly by softening claims to match evidence — would make the thesis stronger, not weaker.

Headline judgment: the research adds something real (see §3). The framing currently writes a cheque the evaluation doesn't fully cash, and there are two or three data points that need explanation before a committee will trust the resource numbers.

---

## 2. Does the story make sense and work?

Mostly yes. The spine is good:

- **RQ1** narrows the design space with a fair, multi-dimensional transport benchmark and concludes that direct gRPC mappings win locally, with batched unary surprisingly close to client-streaming.
- **RQ2** implements chunk preservation through the real DYNAMOS path (SQL → aggregate → algorithm → agent → gateway) without touching the policy/orchestration control path.
- **RQ3** validates that the chunk-aware paths beat the classic unary baseline on completion time and peak memory, and adds time-to-first-result as a qualitative benefit.

The connective tissue is strong: RQ1's "chunking, not streaming" insight is explicitly what motivates RQ2's design choices, and RQ3 honestly revises RQ1 ("integration fit matters as much as raw transport speed"). That is exactly how a thesis narrative should evolve.

Where the story strains:

**(a) The policy/compliance thread is set up and then dropped.** The Main RQ promises integration "while preserving compliance guarantees," Related Work spends a full subsection on policy enforcement under continuous exchange, and it raises the genuinely interesting open problem — how to detect/handle policy revocation *mid-stream*. But RQ2/RQ3 explicitly sidestep it ("Policy enforcement is not moved into the stream... does not claim per-chunk policy revocation"). The delivered compliance story reduces to "we didn't break the existing decision point because we only changed the data path after approval." That is compliance *preservation by avoidance*, not a streaming-compliance contribution. A reader primed by the intro will feel shortchanged. This is the single biggest narrative mismatch.

**(b) "Streaming" in the title vs. "chunked unary" as the winner.** The honest finding is that the best local default is *not streaming at all* — it's repeated request-response with batched payloads. The thesis defends this well ("a verdict against one-request-per-message, not against request-response"), but the title still says *Streaming Communication*. This is defensible, but it should be a deliberate, stated decision rather than a tension the reader notices on their own.

**(c) RQ1's richness collapses into RQ3's narrowness.** RQ1 carefully measures recovery, backpressure, ordering, and duplicates across six transports. RQ3 carries forward only three variants and only on clean completion-time + peak memory. The most striking RQ1 finding — client-streaming's nasty 10,505-duplicate replay-on-reconnect — is never revisited when intra-job gRPC streaming is recommended for in-pod use in RQ3. Why benchmark recovery so carefully in RQ1 if it doesn't inform the DYNAMOS recommendation? At minimum, connect them explicitly.

---

## 3. Does the research add something? Yes — be precise about what.

Genuine contributions, in descending order of strength:

1. **A working chunk-preserving data path through the entire DYNAMOS chain.** The original DYNAMOS thesis explicitly named streaming/large-result transfer as the *unfinished* problem. This thesis actually builds it and shows it works across `dataThroughTtp`, `computeToData`, and multi-provider cases. That is concrete engineering that closes a stated gap.
2. **The "amortise per-message overhead" insight, empirically grounded.** Showing that batched unary captures most of streaming's bulk-transfer benefit is a useful, transferable result that reframes a common assumption.
3. **A careful benchmark harness and scenario design.** The recovery decomposition (pre / recovery-window / post, plus debt, sustained-80%/5s, first-post-failure, backlog drain) is more disciplined than many *published* broker comparisons. This is a real methodological asset.
4. **Honest, well-bounded quantitative results:** ~2.0–2.4× faster completion and ~2.5× lower peak memory at 250k rows, with earlier partial progress.

What it does **not** add (and correctly should not claim): a streaming-compliance mechanism, any distributed/cross-site validation, an in-DYNAMOS fault/recovery story, or an optimal chunk-size study. The honesty about these is a strength.

So: appropriate and sufficient contribution for a master's. The risk is framing over-reach, not insufficient substance.

---

## 4. Issues that matter (ordered)

### Major

**M1 — The non-monotonic peak-memory numbers undercut the flagship claim.**
In Table (RQ3 resources), chunked unary peak memory is 50k=1,151 MiB, **100k=1,723 MiB, 250k=1,378 MiB**. Its 100k peak is *higher* than its 250k peak, and the 250k value (1,378) — the lowest of all 250k cells and the basis for "lowest 250k memory peak" — is lower than its own 100k run. The text says chunking reduces memory "consistently," but the recommended variant's own column is non-monotone. Classic unary rises cleanly (1,571 → 2,046 → 3,695); intra-job and RabbitMQ rise monotonically too — only the headline variant doesn't. A committee will absolutely ask: *why does your 100k run peak higher than your 250k run, and is the 1,378 number trustworthy?* Likely cause is 1 Hz sampling missing the true peak plus GC timing — but then the same caveat threatens the whole memory ranking. **This must be explained**, ideally with more frequent sampling or at least min/max/std across the 10 reps for the memory column. Also drop or qualify the word "consistently."

**M2 — Framing vs. delivery on policy/compliance (narrative §2a).** Either (a) soften the abstract/intro so compliance is a constraint *not violated* rather than a contribution advanced, or (b) explicitly elevate "mid-stream policy enforcement" to *the* central limitation/open problem (it's buried in one future-work line despite a whole Related Work subsection building it up). Right now the promise and the payoff are misaligned.

**M3 — Missing environment/reproducibility specs.** There is no statement anywhere of node hardware (CPU model, cores, RAM), Kubernetes distribution/version, Go version, or broker versions (Kafka/RabbitMQ/NATS). The commits are pinned (good) and presets are documented, but a single-node benchmark whose results hinge on CPU/memory contention is not reproducible without machine specs. Add a short "Experimental environment" paragraph. This is a routine examiner question.

**M4 — NATS's 66,863 clean-run duplicates are under-diagnosed.** In a run with *no injected failure*, ~66k redeliveries almost certainly indicates a configuration artifact (AckWait too short / ack pipeline not keeping up), not an inherent NATS property. As written, a casual reader concludes "NATS = 66k duplicates." Either confirm and label it as a tuning/fairness artifact, or re-run with corrected ack settings. The thesis is otherwise careful about fairness, so this stands out.

**M5 — Report dispersion on the headline tables.** Means only, with spread relegated to prose. The non-monotone cells (chunked unary 100k latency *and* memory) are exactly where a std dev / IQR / CI would reassure the reader that they're noise rather than a real effect. For the RQ3 completion-time and memory tables especially, add spread. The "2.43× faster" claims become much more defensible with it.

### Moderate

**M6 — RQ1 recovery findings don't inform the RQ2/RQ3 variant recommendation.** Connect them: if client-streaming's reconnect replays the whole worker stream (10,505 dup), say whether intra-job gRPC streaming inherits that risk inside DYNAMOS, since you recommend it for in-pod use.

**M7 — No explicit "Contributions" paragraph.** The introduction never lists what the thesis delivers. Add a short contributions list at the end of §1 — it also helps you keep claims honest.

**M8 — No dedicated DYNAMOS background section.** A reader who hasn't read Stutterheim must assemble the architecture (sidecars, agents, generated jobs, archetypes) from scattered mentions; the actual mechanics only appear in RQ2. A short Background section would help, especially given the IEEEtran conference format compresses everything.

**M9 — Scenario-check sample size unstated.** The `computeToData` / two-provider table gives single numbers with no rep count, while the primary benchmark uses 10. State n for the scenario checks (and whether they're averaged).

**M10 — 12 uncited bibliography entries.** Confirmed not cited anywhere in `sections/` or `appendix/`: `tambi2018eventdriven`, `Beck2000a`, `Beck2000b`, `ISO25010`, `Watson2002`, `johansson2020rpc5g`, `arafat2025eda`, `liu2025pipelines`, `fragkoulis2024survey`, `pour2025performance`, `lote2022realtime`, `ververica2023scalability`. The Beck/Watson/ISO25010 entries are clearly proposal-template leftovers. Prune them (or cite the few worth keeping — e.g. the Fragkoulis survey is a strong reference that could anchor the stream-processing background).

**M11 — Citation venue quality is uneven.** The core cites are strong (DYNAMOS, gRPC/Kafka/RabbitMQ/NATS docs, Karimov, Henning & Hasselbring, Gan & Delimitrou, Vogel fault-recovery, Dobbelaere). But several supporting cites sit in weak/predatory-adjacent venues (IJAIBDCMS, IJRECE, *World Journal of Advanced Research and Reviews*, *Int. J. Computer Applications*). Where these back load-bearing claims, find a stronger source; where they're decorative, drop them.

### Minor / line-level

- **gRPC "4 MB" precision:** it's the default max *receive* message size; default *send* is unlimited. Phrase as "default maximum receive message size (~4 MB)."
- **RQ1 phrasing of RQ1 itself** ("which technologies are *suitable*") sounds like a literature survey, but the chapter is empirical. Sharpen to reflect that you *measure* suitability.
- **Recovery table is overloaded** (12 columns at scriptsize). Consider splitting into "recovery progress" and "recovery correctness" sub-tables, or pushing correctness columns to the appendix — it's hard to read as a human.
- **Chunked unary 50k (8.568s) > 100k (7.869s):** explained by fixed control-path cost, which is fine for latency, but note that the *same* explanation doesn't cover the 100k memory spike (M1) — unify the discussion so the two non-monotonicities in the 100k chunked cell are addressed together rather than separately.
- **Abstract** could state up front that the winning design is chunked unary (it already says "chunk-aware" — good — but the reader still expects "streaming" to win given the title).
- **Future Work** is thin (≈8 lines). It's well-aimed at FABRIC/Scattered Directive, but it should explicitly inherit the RQ1 dimensions that went untested in DYNAMOS (recovery, backpressure, ordering under cross-site conditions) — that's the natural bridge.
- **Consistency:** decide on "streaming" vs "chunked/incremental transfer" terminology and use it deliberately; right now "streaming" sometimes means the category and sometimes the specific gRPC-stream variant.

---

## 5. Section-by-section notes

**Abstract.** Accurate and admirably non-overclaiming. Mention the chunked-unary headline result and consider trimming "improving scalability and performance while preserving policy compliance" to match what's actually shown (local performance/memory; compliance preserved, not advanced).

**Introduction.** Clean motivation, well-posed Main RQ and sub-RQs. Two gaps: no explicit contributions list (M7), and the compliance promise (M2). The cross-org motivation is good but generic in the first two paragraphs — a sentence of concrete DYNAMOS context would ground it earlier.

**Related Work.** One of the strongest parts. Thematic structure, a stated gap per subsection, and a consistent "but not in policy-driven, dynamically composed middleware" close. Watch venue quality (M11) and note that the policy subsection raises an expectation the thesis then declines to meet (M2).

**RQ1 (Transport Benchmark).** Well-designed, fair testbed, sensible dimensions, and a genuinely good scenario set. The "chunking not streaming" reading is the thesis's best idea. Fix: diagnose NATS duplicates (M4), add dispersion (M5), tidy the recovery table (minor), and carry recovery findings forward (M6). The threats-to-validity subsection here is honest and good.

**RQ2 (Integration).** The clearest engineering chapter. The chunk-preservation requirement (don't rebuild the full table at any hop) is well-argued, and the variant table is excellent. The figure is helpful. This chapter is where the real implementation contribution lives — lean into it. Be explicit that RabbitMQ Streams' local benefit comes from the shared chunk path, not the broker (you already say this — good).

**RQ3 (Evaluation).** Good metrics, especially time-to-first-result. Main risks: the memory non-monotonicity (M1), means-only reporting (M5), and scenario-check n (M9). The repeated, careful acknowledgement that control-path cost dominates small requests is honest and correct. The threats-to-validity list is strong.

**Future Work / Conclusion.** Conclusion is honest and mirrors the RQ answers well; the "compliance preserved by construction" line is the one to scrutinise against M2. Future work is correctly aimed but thin (minor).

**Appendices.** Preset and clean-matrix appendices are good and support reproducibility. Failure-mode notes table is a nice touch and reinforces the honest tone. Add environment specs somewhere (M3).

---

## 6. Concrete fix checklist

1. Explain the chunked-unary 100k>250k peak-memory inversion; add memory dispersion; soften "consistently." **(M1)**
2. Realign the compliance framing — either soften the promise or elevate mid-stream enforcement as the central open problem. **(M2)**
3. Add an "Experimental environment" paragraph (hardware, K8s/Go/broker versions). **(M3)**
4. Diagnose/relabel the NATS 66k clean-run duplicates as a tuning/fairness artifact (or re-run). **(M4)**
5. Add std dev / IQR to the headline RQ1 and RQ3 tables. **(M5)**
6. Bridge RQ1 recovery findings to the RQ2/RQ3 variant recommendation. **(M6)**
7. Add an explicit contributions list to the introduction. **(M7)**
8. Add a short DYNAMOS background/architecture section. **(M8)**
9. State the sample size for the scenario checks. **(M9)**
10. Prune the 12 uncited bib entries; upgrade weak-venue cites on load-bearing claims. **(M10, M11)**
11. Fix the gRPC "4 MB" → "max receive message size"; tidy the recovery table; make a deliberate call on "streaming" vs "chunking" terminology and the title.

---

*Bottom line: the work is sound and the central finding is genuinely worth stating. The edits above are mostly about making the claims match the (good, honest) evidence and shoring up two or three numbers a committee will probe. None of this requires new experiments except — ideally — a finer-grained memory sample and a corrected NATS run.*
