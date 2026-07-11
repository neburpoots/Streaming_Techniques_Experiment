# Thesis Review — Feedback Round 2 (2026-07-06)

Scope: `master-thesis-template/` (new UvA template version), checked against the supervisor feedback, the rubric/assessment guidelines, and my own read.

---

## 1. Did the rewrite apply the feedback correctly?

Verdict per feedback point:

| Feedback | Status | Remaining gap |
|---|---|---|
| Decouple from DYNAMOS in abstract/intro/conclusion | Mostly applied | DYNAMOS is *asserted* as case study, not *derived* from criteria (see 1.1) |
| Explain streaming + policy implications more | Applied | Can be deepened with usage-control (UCON) framing (see 5) |
| Conventional structure instead of per-RQ | Applied | Structure is now Intro/Background/Related/Methods/Results/Discussion/Conclusion; Discussion maps findings to RQs — exactly what was asked |
| Justify specific parameter values | Applied | Table "parameter rationale" is good; 2–3 values still only asserted (see 1.2) |
| Required LaTeX template | Applied | `mscthesis` class matches the uploaded template PDF |
| Citations right after names | Applied | Consistent in all chapters I checked |
| Comparison table / concept matrix | Applied | Concept matrix in Background is good; overlaps with Related Work §5.1 (see 2.2) |
| "Are findings comparable with literature?" | Applied | §5.9 + Discussion §8.4 — but they are near-duplicates (see 2.1) |

### 1.1 The one real decoupling gap
The abstract, title, and intro context are properly generalized now. But the supervisor's exact point — "the choice of DYNAMOS should arise after you search the literature for systems that satisfy your criteria" — is not yet done. §1.2 jumps straight to "This thesis uses DYNAMOS." 

**Fix (half a page):** add a short case-study *selection* passage, either at the end of Related Work or in Methods:
1. State selection criteria: policy-driven orchestration before execution, dynamic/ephemeral service composition, sidecar-mediated cross-domain communication, open source and modifiable, Kubernetes-native.
2. Name 2–4 candidate system classes and why they fall short: IDS / Eclipse Dataspace Connector (usage-control policies but static connector topology, data plane not dynamically composed), Gaia-X style federation services, Dapr-class sidecar runtimes (protocol-agnostic but no policy-driven chain generation), generic data-mesh platforms.
3. Conclude: DYNAMOS is the system that satisfies all criteria and is accessible for modification.

This is cheap, directly answers the email, and strengthens the "Embedding in existing research" rubric row.

### 1.2 Parameter justification leftovers
The rationale table covers most values. Still weakly justified: the 2 ms sink delay, the 4,000 msg/s backpressure target, and the 80%/5s recovery threshold. One sentence each ("chosen to produce sustained overload of roughly 2× sink capacity", "threshold choice does not change the transport ranking") closes this. If you can cheaply verify that the recovery ranking is insensitive to 70%/90% thresholds, say so — that's the classic defense question.

---

## 2. Independent findings (not in the supervisor feedback)

### 2.1 Duplicated literature-comparison sections
§5.9 "Comparison with existing literature" (Transport Benchmark) and Discussion §8.4 repeat the same Coviello / Roohitavaf / Dobbelaere / Ibrahim / Marcu content in nearly the same sentences. Keep the full version in the Discussion; reduce §5.9 to 3–4 sentences or delete it and forward-reference. The rubric explicitly flags length-vs-content.

### 2.2 The thesis's key insight is repeated too often
"Chunk preservation, not streaming as a label, is the real improvement" appears in the abstract, intro, background (concept-matrix paragraph), ch. 5 results, ch. 6, ch. 7, Discussion, and Conclusion — 7–8 times in nearly identical phrasing. It's a great insight; repeating it this much dilutes it. Keep it in: results (where it's discovered), Discussion (where it's interpreted), Conclusion. Cut or vary the others.

Related: Background §2.3 (mechanism descriptions) and Related Work §3.1 partially describe the same technologies. Rule: Background *describes* mechanisms, Related Work *positions studies*. A few Related Work sentences re-explain gRPC streaming modes — move/merge into Background.

### 2.3 Small items
- Title page: reviewer is "To be confirmed" — fill before submission.
- Grammar: "Performance testing **were** conducted" (Ethics); mixed -ise/-ize spelling (document is set to British English; "summarizes", "utilisation" both appear — pick one, `polyglossia` is set to british so prefer -ise).
- Methods: "the thesis reports arithmetic means because that is the preferred reporting style for the current document" — this reads like an internal note, not a justification. Replace with the real argument (you already have it in ch. 7: means are conservative because they include long-tail runs) and add min–max or std-dev columns in the appendix. A committee will ask about variance.
- Abstract has no numbers. The rubric wants main conclusions in the abstract; "2.4× faster completion and 2.7× lower peak memory at 250k rows" makes it concrete.
- Terminology bridge: RQ1 says "batched unary", RQ3 says "chunked unary". §6 explains the relation once, but add one explicit sentence at first use in ch. 5 ("batched unary is the transport-level analogue of the chunked-unary DYNAMOS implementation in ch. 6/7").
- The old `master-thesis/` folder still sits next to `master-thesis-template/` — make sure Overleaf/git only builds the new one, and consider renaming to avoid confusing your supervisors with two versions.

---

## 3. Your question: is the Related Work section too distant?

You're right, and §3.2 (adaptive middleware / sidecars / Dapr) is the weakest part. Symptoms:
- Figueira & Coutinho is cited twice for two different claims and its connection to the thesis is "illustrates that communication behaviour can be adapted" — but the thesis never adapts communication at runtime.
- The section concludes with a gap ("long-lived streams + ephemeral chains") that the thesis then doesn't directly study either — RQ2 sidesteps it by chunking instead of long-lived streams. So the section sets up a problem the thesis answers only obliquely.

**What to do:** restructure Related Work so each section mirrors something the thesis actually does, and each section ends with "what we take from this / what's missing":

1. **Transport & broker comparison studies** (exists, strongest section — keep).
2. **Fault-recovery and resilience benchmarking** (currently the resilience section is generic reactive-microservices material). Rebuild it around benchmark studies: Vogel et al., "A Comprehensive Benchmarking Analysis of Fault Recovery in Stream Processing Frameworks" (DEBS '24) — you already cite it as `vogel2024faultRecovery` but barely use it. This is *the* anchor for your recovery scenario (see §4). Add Henning & Hasselbring's Theodolite/scalability benchmarking line (you cite the metrics paper already), and ShuffleBench if useful.
3. **Policy/usage control under continuous exchange** (exists) — strengthen with UCON (Park & Sandhu, UCON_ABC; UCON+ for continuous authorization) and IDS/Eclipse Dataspace Connector usage-control enforcement. These are much closer to your RQ2 than the gRPC-security-proxy paper.
4. **DYNAMOS line of work** (Stutterheim thesis/ICSA, Jongejans' Scattered Directive) — currently scattered across chapters; a short subsection here also serves the case-study-selection fix from 1.1.
5. Shrink or drop the Dapr/sidecar subsection to one paragraph inside (3) or (4): "sidecar runtimes show heterogeneous transports can hide behind one interface, but assume static topologies" — one point, one citation, done.

**Search keywords for closer-aligned work:**
- "fault recovery benchmark stream processing" / "recovery time throughput restoration"
- "message broker benchmark Kubernetes microservices"
- "gRPC streaming performance evaluation microservices"
- "usage control continuous enforcement" / "UCON ongoing authorization revocation"
- "dataspace connector data plane performance" / "Eclipse EDC benchmark"
- "large result set transfer chunking microservices" / "incremental result delivery RPC"
- For theses: TU Delft / Aalto / KTH repositories with "streaming microservices benchmark thesis" — the Lähtevänoja thesis you already have is the right genre; a companion would be theses evaluating Kafka vs direct RPC in a specific host system (that's exactly your shape: mechanism benchmark → integration → in-system evaluation).

Sources found now: [Vogel et al. DEBS '24](https://dl.acm.org/doi/10.1145/3629104.3666040) ([arXiv](https://arxiv.org/abs/2404.06203)), [UCON_ABC](https://profsandhu.com/journals/tissec/ucon-abc.pdf), [IDS Dataspace Connector usage control](https://international-data-spaces-association.github.io/DataspaceConnector/Documentation/v6/UsageControl), [Stream processing benchmark survey (TPCTC '24)](https://hpi.de/fileadmin/user_upload/fachgebiete/rabl/publications/2024/streamsurvey_tpctc_2024.pdf).

---

## 4. Your question: is the recovery scenario indefensibly novel?

Less novel than you fear. The scenario itself (kill one pipeline component mid-run, observe a fixed post-failure window) is the standard design in fault-recovery benchmarking — Vogel et al. (DEBS '24) inject worker failures in Flink/Kafka Streams/Spark and measure recovery exactly this way, and explicitly argue the field needs *better* recovery metrics. Your metrics map almost one-to-one onto established concepts:

| Your metric | Established counterpart |
|---|---|
| First post-failure message | Recovery/restart latency ("time to first output after failure") |
| Sustained 80%/5s recovery | Throughput-restoration time (time until throughput returns to a fraction of pre-failure rate — used in Flink/SPE recovery studies) |
| Recovery debt | Backlog / consumer lag accumulated during outage |
| Post-failure duplicates & ordering | Delivery-guarantee validation under at-least-once semantics |
| Backlog drain | Catch-up time |

**Fix:** don't replace the scenario. Add 3–4 sentences in Methods §4.2.4: "the recovery scenario adapts the fault-injection design of Vogel et al. [X]; the metrics operationalize recovery latency, throughput restoration, and catch-up as used in stream-processing fault-recovery studies, applied at the transport level rather than the framework level." Then each metric definition in ch. 5 already stands on prior art, and the only genuinely new choice (exact 80%/5s threshold) is a parameterization, which you defend via the rationale table (see 1.2). This converts "novel metrics" from a weakness into "adapted established methodology to a new layer" — which is precisely what your Related Work already claims the thesis does ("not a new benchmarking methodology").

---

## 5. Your question: is the benchmark fair, and should it be dropped?

**Fairness.** The comparison is fair *for the claim it makes*, and the thesis already frames it correctly (band-level ordering, not broker ranking). The structural asymmetry — brokers pay an extra network hop plus persistence that direct gRPC doesn't — is not an artifact, it's the phenomenon being measured: the cost of durability and decoupling. What matters is that you *say this*. Concretely:

- Add a short "Fairness considerations" subsection in Methods §4.2.2 that names the asymmetries explicitly: (a) brokered paths include persistence and an extra hop by design; (b) all brokers single-node, replication factor 1, so none pays replication cost; (c) async/batched publishing chosen for all brokers to avoid strawman configurations; (d) same resource overlays, same payloads, same measurement points. You already do (c) and (d) — just make it a checklist the committee can tick off instead of a question they ask.
- Document broker persistence settings (fsync behaviour, retention) in the appendix if not there yet; that's the first thing a skeptical reader checks.
- Never claim "RabbitMQ Streams beats NATS" as a general result — the text already avoids this; keep it that way.

**Dropping the benchmark: no.** Three reasons. (1) Research is 40–50% of the grade and the benchmark corpus + in-system validation *is* the research; a theory-only thesis would be re-scoped, not improved. (2) Your supervisors' comments engage with the benchmark tables — they're steering it, not questioning its existence. (3) The thesis's whole argument chain (RQ1 narrows design space → RQ2 implements → RQ3 validates) collapses without it. The fairness concern is handled with one subsection, not amputation.

---

## 6. Your question: RQ2, agreements changing mid-stream

Current design (policy checked at request start, stream is a post-approval data path) is defensible — but defend it as a *chosen point in a design space*, not an omission. The literature gives you the exact vocabulary: access control makes a one-time decision; **usage control (UCON)** adds *ongoing authorization* — continuous re-evaluation and revocation during use. IDS/EDC dataspace connectors implement precisely this for data exchange. Framed that way:

1. **Implemented: pre-decision enforcement.** Matches DYNAMOS's existing semantics (the generated job is the unit of approval and execution). Important: this is *not weaker* than classic unary — the agreement was also only checked at request start there. Equivalence argument: your design changes the data path, not the enforcement model.
2. **Available today at job granularity:** revocation can already interrupt a transfer, because deleting the generated job kills the stream. Classic unary can't be interrupted meaningfully — the client either gets the full result or nothing. Worth one sentence; it's a real (small) win.
3. **Feasible extension: chunk-boundary re-validation.** Here is the argument you should make prominently, because it flips your worry into a contribution: *chunking creates mid-stream enforcement points that neither classic unary nor an opaque long-lived stream has.* With a full-buffered response there is nothing to interrupt; with chunks, a policy change takes effect at the next chunk boundary (bounded staleness of one chunk), and already-delivered chunks are auditable via sequence/provider metadata. You built the mechanism; you just didn't wire a policy check to it. That's a legitimately nice future-work section with a concrete design, not hand-waving.
4. **Full continuous enforcement (lease/token-based):** policy issues a time- or chunk-bounded lease; sidecar stops forwarding on expiry. Correctly out of scope — say why (requires re-architecting the policy evaluator into the data plane).

Also address the semantics question once, explicitly: "a result delivered under chunking reflects the agreement at request time, exactly as in the original system; the difference is that revocation mid-transfer leaves an auditable, well-defined prefix rather than an all-or-nothing outcome." One paragraph in §6.4 + moving the current future-work text there makes RQ2 much more convincing.

---

## 7. Your question: writing feels distant from the concrete work

Agreed — this is the main *writing* risk now. The chapters are architecturally tidy but under-anchored. Patterns and fixes:

1. **Meta-justification prose.** Many paragraphs open with "The purpose is not only to X but to Y" / "This distinction matters because…" — justifying before showing. Often the justification can be cut and the fact shown first. Example (§6.1): instead of "This makes large-result transfer an appropriate point at which to evaluate streaming techniques…" → show the failure: "On `main`, a 250k-row result exceeds the 4 MB gRPC limit and the request fails; raising the limit makes the same request buffer 3.7 GB across the namespace (Table 7.4)."
2. **Missing artifacts.** The integration chapter describes the chunk model in prose only. Add: a 10-line listing of the actual chunk metadata (proto fields: correlation id, sequence, partial/final flag, ordered columns), and the `SendDataStream` signature. One listing per implemented variant maximum — this is the single highest-leverage fix for "distant" feeling, and the rubric's Contents row asks whether *your contribution* is explicit.
3. **One worked example.** A half-page trace of one real 100k-row request through Fig. 6.1 with actual timestamps from a run (request at t=0, policy approved t=0.9s, job pod ready t=5.8s, first chunk t=6.1s, chunk 20 t=7.9s) would tie Methods, ch. 6, and ch. 7 together. You have this data in the NDJSON events already.
4. **Name the code.** You have two implementation branches; the thesis cites commits but never describes what changed where (which services touched, roughly how many lines, which proto files). A small table "services modified per variant" makes the engineering contribution visible — that feeds the Research rubric rows (technical skills, original contribution).
5. **Vary the insight sentence** (see 2.2) — repetition is part of what makes it feel abstract.

---

## 8. Your question: blank-slate redesign — how would I approach this thesis?

Ideas ranked by how they'd fit DYNAMOS, if the current work didn't exist:

1. **Post-policy data-path change with chunk-level enforcement points** — essentially what you built. The chunk model with sequence metadata is the minimal correct design; the benchmark-first funnel (generic transport study → in-system validation) is also how I'd structure it. So: the thesis's core instinct is right; that's worth saying confidently at the defense.
2. **Policy leases / capability tokens.** Policy evaluation issues a signed, time- or volume-bounded transfer capability; sidecars enforce it per chunk without calling the policy engine. Revocation = non-renewal. This is the "proper" UCON-style answer to mid-stream changes and a natural PhD-flavoured follow-up.
3. **Sidecar-as-streaming-proxy.** Keep generated services unary and dumb; sidecars translate unary↔stream (Dapr-style). Services stay simple, streaming becomes an infrastructure concern, policy stays in the sidecar path. You partially have this via the agent/sidecar boundary; a full version is a strong alternative design worth one Discussion paragraph ("alternatives considered").
4. **Claim-check pattern.** For very large results: write chunks to a policy-scoped object store, stream only chunk references + hashes through the approved path. Standard enterprise-integration answer; interesting to mention *why it's rejected* here (data would leave the policy-mediated path; the trust boundary moves to storage ACLs).
5. **Stream-as-audit-log.** RabbitMQ Streams retention turns the transfer itself into a replayable compliance record — the broker isn't just slower-but-decoupled, it's an *audit artifact*. This is the best architectural argument for the brokered variant and currently absent from the thesis. One paragraph in the Discussion would strengthen the RabbitMQ Streams motivation beyond "may matter when distributed".
6. **Backpressure-aware orchestration.** Orchestrator reads stream lag/backlog to make placement or admission decisions — connects streaming back to the *adaptive* part of DYNAMOS. Future work material.

Items 5 and (briefly) 3–4 are worth adding as text; 2 and 6 belong in Future Work.

---

## 9. Priority list

1. Case-study selection criteria passage (closes the last explicit supervisor point) — §1.1.
2. Recovery-metric mapping to Vogel et al. + threshold sentence — §4.
3. Rewrite Related Work §3.2 and the resilience section around recovery benchmarking + UCON; add keywords/papers — §3.
4. Fairness-considerations subsection in Methods — §5.
5. RQ2 mid-stream paragraph (enforcement-point argument) — §6.
6. De-duplicate the two literature-comparison sections; prune the repeated insight — §2.1/2.2.
7. Concreteness pass: chunk-metadata listing, worked trace, services-modified table — §7.
8. Cosmetics: reviewer name, means-justification sentence, -ise/-ize, abstract numbers, variance columns — §2.3.

Nothing here requires new experiments except (optionally) the recovery-threshold sensitivity check.
