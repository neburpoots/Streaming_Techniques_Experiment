# Midterm presentation generator

## How to build the .pptx

From this folder:

```bash
npm install pptxgenjs
node midterm_presentation.js
```

That produces `midterm_presentation.pptx` in the current directory.

## Slide map (12 slides)

1. Title — Streaming Communication for Scalable Data Exchange in DYNAMOS
2. DYNAMOS in context — what it is, what the gap is, the goal
3. Research questions — main RQ + RQ1/RQ2/RQ3 with phase status
4. RQ1 — five candidate transports compared (1 baseline + 4 streaming)
5. Benchmark design — Producer → Transformer → Sink topology + four scenario families
6. RQ1 results — clean-matrix throughput bar chart + qualitative findings
7. From RQ1 → DYNAMOS — hybrid-by-boundary decision (gRPC streaming intra-pod, RabbitMQ Streams inter-agent, NDJSON to user)
8. RQ2 — integration into DYNAMOS (design choices + preserved properties)
9. Preliminary RQ3 — MVP vs baseline DYNAMOS bar chart + early observations
10. Open issues — 250k crash, column-order bug, what they reveal about RQ3
11. Next month — fix pipelining, expand RQ3, optional scattered-directive angle, writing
12. Summary / closing — questions

## Tweaking before the talk

- Change colours: `COLOR_DARK`, `COLOR_TEAL`, `COLOR_NAVY`, `COLOR_ACCENT` at the top of the JS.
- Change fonts: `FONT_HEADER`, `FONT_BODY`.
- Update results numbers: search for `values: [` to find both bar charts (slide 6, slide 9).
- Update bullet text: each slide block has a clearly-named section header comment.

## Notes on the structure choice

- Slide 9 is labelled "Preliminary RQ3" rather than "RQ2 results" — the empirical impact measurements belong under RQ3. The current thesis chapter mixes them; I'd recommend moving them.
- Slide 11 explicitly mentions the RQ2/RQ3 split as a thesis-writing task for next month.
