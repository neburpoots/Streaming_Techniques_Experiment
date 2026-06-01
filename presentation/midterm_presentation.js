// Midterm thesis presentation generator
// Run with:  node midterm_presentation.js
// Requires:  npm install pptxgenjs

const pptxgen = require("pptxgenjs");
const pres = new pptxgen();
pres.layout = "LAYOUT_16x9"; // 10" x 5.625"
pres.author = "Ruben Stoop";
pres.title = "Streaming Communication for Scalable Data Exchange in DYNAMOS — Midterm";

// Palette (Ocean Gradient, drawn from the pptx skill recommendations)
const COLOR_DARK    = "065A82"; // deep blue — title & closing background
const COLOR_TEAL    = "1C7293"; // teal — accent
const COLOR_NAVY    = "21295C"; // midnight — header text
const COLOR_TEXT    = "1F2937"; // body text on white
const COLOR_MUTED   = "64748B"; // muted captions
const COLOR_LIGHT   = "EAF4F7"; // pale teal — callout box
const COLOR_BORDER  = "D6E2E8"; // soft border
const COLOR_ACCENT  = "FFB400"; // gold accent for callouts on dark slides
const COLOR_WHITE   = "FFFFFF";

const FONT_HEADER = "Calibri";
const FONT_BODY   = "Calibri";

// Slide dimensions
const W = 10.0;
const H = 5.625;

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------
function addSlideHeader(slide, title, subtitle) {
  slide.addText(title, {
    x: 0.55, y: 0.30, w: W - 1.1, h: 0.55,
    fontSize: 26, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
  });
  if (subtitle) {
    slide.addText(subtitle, {
      x: 0.55, y: 0.80, w: W - 1.1, h: 0.30,
      fontSize: 13, color: COLOR_MUTED, fontFace: FONT_BODY, italic: true, margin: 0,
    });
  }
}

function addNumberCircle(slide, x, y, num, color) {
  slide.addShape(pres.shapes.OVAL, {
    x, y, w: 0.45, h: 0.45,
    fill: { color: color || COLOR_TEAL }, line: { color: color || COLOR_TEAL, width: 0 },
  });
  slide.addText(String(num), {
    x, y, w: 0.45, h: 0.45,
    fontSize: 18, bold: true, color: COLOR_WHITE,
    align: "center", valign: "middle", fontFace: FONT_HEADER, margin: 0,
  });
}

function addPageNumber(slide, num, total) {
  slide.addText(`${num} / ${total}`, {
    x: W - 1.0, y: H - 0.35, w: 0.8, h: 0.25,
    fontSize: 9, color: COLOR_MUTED, align: "right", fontFace: FONT_BODY, margin: 0,
  });
}

const TOTAL_SLIDES = 12;

// =============================================================================
// SLIDE 1 — Title
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_DARK };

  // Decorative offset rectangle
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.0, y: 0.0, w: 0.30, h: H, fill: { color: COLOR_TEAL }, line: { color: COLOR_TEAL, width: 0 },
  });

  s.addText("Streaming Communication for Scalable", {
    x: 0.7, y: 1.40, w: 9.0, h: 0.55,
    fontSize: 32, bold: true, color: COLOR_WHITE, fontFace: FONT_HEADER, margin: 0,
  });
  s.addText("Data Exchange in DYNAMOS", {
    x: 0.7, y: 1.95, w: 9.0, h: 0.55,
    fontSize: 32, bold: true, color: COLOR_WHITE, fontFace: FONT_HEADER, margin: 0,
  });

  s.addShape(pres.shapes.LINE, {
    x: 0.7, y: 2.75, w: 1.2, h: 0,
    line: { color: COLOR_ACCENT, width: 2 },
  });

  s.addText("Midterm Progress Presentation", {
    x: 0.7, y: 2.85, w: 9.0, h: 0.35,
    fontSize: 18, color: COLOR_WHITE, fontFace: FONT_BODY, italic: true, margin: 0,
  });

  s.addText("Ruben Stoop", {
    x: 0.7, y: 4.10, w: 6.0, h: 0.35,
    fontSize: 16, bold: true, color: COLOR_WHITE, fontFace: FONT_BODY, margin: 0,
  });
  s.addText("Complex Cyber-Infrastructure (CCI)  ·  University of Amsterdam", {
    x: 0.7, y: 4.45, w: 8.0, h: 0.30,
    fontSize: 12, color: "B8D4DE", fontFace: FONT_BODY, margin: 0,
  });
}

// =============================================================================
// SLIDE 2 — DYNAMOS in context
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "What is DYNAMOS — and what is the gap?",
    "Policy-driven data exchange middleware developed at UvA's CCI group");

  // Two-column layout
  const leftX = 0.55, rightX = 5.20, colW = 4.30, colY = 1.35, colH = 3.30;

  // Left card
  s.addShape(pres.shapes.RECTANGLE, {
    x: leftX, y: colY, w: colW, h: colH,
    fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
  });
  s.addText("DYNAMOS today", {
    x: leftX + 0.20, y: colY + 0.15, w: colW - 0.4, h: 0.40,
    fontSize: 17, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
  });
  s.addText([
    { text: "Inter-organisation data exchange under policy constraints (healthcare, research, public sector)", options: { bullet: true, breakLine: true } },
    { text: "Dynamic microservice composition: ephemeral Kubernetes jobs spun up per request", options: { bullet: true, breakLine: true } },
    { text: "Two archetypes today: ", options: { bullet: true, bold: false } },
    { text: "computeToData", options: { italic: true } },
    { text: " (chain runs at provider) and ", options: {} },
    { text: "dataThroughTtp", options: { italic: true } },
    { text: " (data moves to a trusted third party)", options: { breakLine: true } },
    { text: "Sidecar pattern abstracts communication; RabbitMQ for control plane, gRPC unary for data", options: { bullet: true } },
  ], {
    x: leftX + 0.20, y: colY + 0.60, w: colW - 0.4, h: colH - 0.75,
    fontSize: 11.5, color: COLOR_TEXT, fontFace: FONT_BODY, paraSpaceAfter: 4, margin: 0,
  });

  // Right card
  s.addShape(pres.shapes.RECTANGLE, {
    x: rightX, y: colY, w: colW, h: colH,
    fill: { color: COLOR_WHITE }, line: { color: COLOR_BORDER, width: 1 },
  });
  s.addText("The gap I'm addressing", {
    x: rightX + 0.20, y: colY + 0.15, w: colW - 0.4, h: 0.40,
    fontSize: 17, bold: true, color: COLOR_TEAL, fontFace: FONT_HEADER, margin: 0,
  });
  s.addText([
    { text: "Every inter-service hop is atomic request–response", options: { bullet: true, breakLine: true } },
    { text: "Whole datasets buffered before being sent — memory pressure, idle time, cold-start dominates", options: { bullet: true, breakLine: true } },
    { text: "No incremental processing or pipelining between stages", options: { bullet: true, breakLine: true } },
    { text: "Stutterheim's original thesis explicitly flags streaming as future work", options: { bullet: true } },
  ], {
    x: rightX + 0.20, y: colY + 0.60, w: colW - 0.4, h: colH - 0.75,
    fontSize: 11.5, color: COLOR_TEXT, fontFace: FONT_BODY, paraSpaceAfter: 4, margin: 0,
  });

  // Bottom callout
  s.addText([
    { text: "Goal:  ", options: { bold: true, color: COLOR_NAVY } },
    { text: "introduce streaming communication into DYNAMOS while preserving policy compliance, dynamic composition, and isolation guarantees.", options: { color: COLOR_TEXT } },
  ], {
    x: 0.55, y: 4.85, w: W - 1.1, h: 0.5,
    fontSize: 13, fontFace: FONT_BODY, italic: true, margin: 0,
  });

  addPageNumber(s, 2, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 3 — Research questions
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "Research questions", null);

  // Main RQ box
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.55, y: 1.05, w: W - 1.1, h: 0.85,
    fill: { color: COLOR_NAVY }, line: { color: COLOR_NAVY, width: 0 },
  });
  s.addText([
    { text: "Main RQ — ", options: { bold: true, color: COLOR_ACCENT } },
    { text: "How can streaming communication be integrated into a dynamically adaptive, policy-driven microservice-based data exchange middleware such as DYNAMOS, while preserving compliance guarantees and improving scalability and performance?", options: { color: COLOR_WHITE } },
  ], {
    x: 0.75, y: 1.10, w: W - 1.5, h: 0.75,
    fontSize: 12.5, fontFace: FONT_BODY, valign: "middle", margin: 0,
  });

  // 3 sub-RQs in cards
  const subs = [
    {
      n: 1,
      title: "Candidate techniques",
      text: "Which streaming technologies, frameworks, and interaction patterns are suitable for large-scale and continuous data exchange in microservice-based systems such as DYNAMOS?",
      phase: "Phase done",
    },
    {
      n: 2,
      title: "Architectural integration",
      text: "How can streaming be integrated in a way that preserves dynamic service composition, policy-driven orchestration, and isolation guarantees?",
      phase: "MVP implemented",
    },
    {
      n: 3,
      title: "Impact evaluation",
      text: "What is the impact on scalability, performance, and robustness compared to a traditional request–response approach under realistic workloads?",
      phase: "In progress",
    },
  ];

  const cardY = 2.20, cardH = 2.85, cardW = 3.0, gap = 0.15;
  let cx = 0.55;
  for (const r of subs) {
    s.addShape(pres.shapes.RECTANGLE, {
      x: cx, y: cardY, w: cardW, h: cardH,
      fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
    });
    s.addShape(pres.shapes.OVAL, {
      x: cx + 0.20, y: cardY + 0.20, w: 0.65, h: 0.45,
      fill: { color: COLOR_TEAL }, line: { color: COLOR_TEAL, width: 0 },
    });
    s.addText("RQ" + r.n, {
      x: cx + 0.20, y: cardY + 0.20, w: 0.65, h: 0.45,
      fontSize: 13, bold: true, color: COLOR_WHITE,
      align: "center", valign: "middle", fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(r.title, {
      x: cx + 0.20, y: cardY + 0.78, w: cardW - 0.4, h: 0.40,
      fontSize: 14, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(r.text, {
      x: cx + 0.20, y: cardY + 1.20, w: cardW - 0.4, h: cardH - 1.75,
      fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, valign: "top", margin: 0,
    });
    s.addText(r.phase, {
      x: cx + 0.20, y: cardY + cardH - 0.45, w: cardW - 0.4, h: 0.30,
      fontSize: 10, italic: true, color: COLOR_TEAL, bold: true, fontFace: FONT_BODY, margin: 0,
    });
    cx += cardW + gap;
  }

  addPageNumber(s, 3, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 4 — RQ1 candidate streaming techniques
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "RQ1 — Candidate streaming techniques",
    "Five transports compared in a controlled benchmark (one baseline, four streaming candidates)");

  const techs = [
    { name: "Unary gRPC",            label: "Baseline",          desc: "Atomic request–response; the current DYNAMOS communication model.", color: COLOR_MUTED },
    { name: "Client-streaming gRPC", label: "Direct streaming",  desc: "Long-lived RPC; sender pushes chunks. Lowest protocol overhead.",      color: COLOR_TEAL },
    { name: "RabbitMQ Streams",      label: "Brokered streaming", desc: "Append-only log on top of RabbitMQ. Durable, replayable, decoupled.", color: COLOR_TEAL },
    { name: "NATS JetStream",        label: "Brokered streaming", desc: "Lightweight broker with persistence, replay, pull consumers.",        color: COLOR_TEAL },
    { name: "Apache Kafka",          label: "Brokered streaming", desc: "Durable partitioned log; mature ecosystem; strong correctness.",      color: COLOR_TEAL },
  ];

  const rowY = 1.25, rowH = 0.70, rowGap = 0.10;
  for (let i = 0; i < techs.length; i++) {
    const t = techs[i];
    const y = rowY + i * (rowH + rowGap);
    // Left accent block
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.55, y: y, w: 0.10, h: rowH, fill: { color: t.color }, line: { color: t.color, width: 0 },
    });
    // Card body
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.65, y: y, w: W - 1.2, h: rowH,
      fill: { color: i === 0 ? "F3F4F6" : COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
    });
    s.addText(t.name, {
      x: 0.85, y: y + 0.08, w: 2.8, h: 0.30,
      fontSize: 14, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(t.label, {
      x: 0.85, y: y + 0.36, w: 2.8, h: 0.28,
      fontSize: 10.5, color: t.color, italic: true, fontFace: FONT_BODY, margin: 0,
    });
    s.addText(t.desc, {
      x: 3.75, y: y + 0.10, w: W - 4.35, h: rowH - 0.20,
      fontSize: 11.5, color: COLOR_TEXT, fontFace: FONT_BODY, valign: "middle", margin: 0,
    });
  }

  addPageNumber(s, 4, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 5 — Benchmark design (topology + scenarios)
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "Benchmark design",
    "Same Go pipeline, same payloads, swap the transport — single-node Kubernetes (primary), 3-broker clustered (exploratory)");

  // Topology diagram — Producer → Transformer → Sink
  const diagY = 1.30;
  const boxW = 1.8, boxH = 0.85;
  const labels = ["Producer", "Transformer", "Sink"];
  const startX = 1.0;
  const gapX = 1.05;

  for (let i = 0; i < 3; i++) {
    const x = startX + i * (boxW + gapX);
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, {
      x, y: diagY, w: boxW, h: boxH,
      fill: { color: i === 1 ? COLOR_NAVY : COLOR_TEAL }, line: { color: COLOR_NAVY, width: 0 },
      rectRadius: 0.08,
    });
    s.addText(labels[i], {
      x, y: diagY, w: boxW, h: boxH,
      fontSize: 16, bold: true, color: COLOR_WHITE, align: "center", valign: "middle",
      fontFace: FONT_HEADER, margin: 0,
    });
  }

  // Arrows between boxes
  for (let i = 0; i < 2; i++) {
    const ax = startX + boxW + i * (boxW + gapX);
    s.addShape(pres.shapes.LINE, {
      x: ax + 0.08, y: diagY + boxH / 2, w: gapX - 0.16, h: 0,
      line: { color: COLOR_NAVY, width: 2, endArrowType: "triangle" },
    });
  }

  // Transport label below pipeline
  s.addText("Transport under test (one of: client-streaming gRPC · unary gRPC · RabbitMQ Streams · NATS JetStream · Kafka)", {
    x: 0.5, y: diagY + boxH + 0.15, w: W - 1.0, h: 0.30,
    fontSize: 11, italic: true, color: COLOR_MUTED, align: "center", fontFace: FONT_BODY, margin: 0,
  });

  // Four scenarios
  const sy = diagY + boxH + 0.75;
  const scenarios = [
    { name: "Clean bulk-transfer matrix", body: "Payload 256 B – 16 KiB × concurrency 1–16. Sustained throughput baseline." },
    { name: "Continuous steady-rate",      body: "1 KiB at 1 000 msg/s. Pacing stability, jitter, inter-arrival regularity." },
    { name: "Slow-consumer backpressure",  body: "4 000 msg/s target with 2 ms sink delay. Queueing behaviour, overload handling." },
    { name: "Forced-restart recovery",     body: "Kill transformer at t = 3 s. Duplicates, ordering, time to first message." },
  ];

  const cellW = 2.30, cellH = 1.20, cellGap = 0.10;
  let cx = 0.55;
  for (const sc of scenarios) {
    s.addShape(pres.shapes.RECTANGLE, {
      x: cx, y: sy, w: cellW, h: cellH,
      fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
    });
    s.addText(sc.name, {
      x: cx + 0.12, y: sy + 0.10, w: cellW - 0.24, h: 0.35,
      fontSize: 12, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(sc.body, {
      x: cx + 0.12, y: sy + 0.50, w: cellW - 0.24, h: cellH - 0.60,
      fontSize: 10, color: COLOR_TEXT, fontFace: FONT_BODY, margin: 0,
    });
    cx += cellW + cellGap;
  }

  addPageNumber(s, 5, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 6 — RQ1 results
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "RQ1 — Key findings",
    "Single-node results, averaged across the clean-matrix configurations (selected highlights)");

  // Mini comparison chart: clean-matrix average throughput (msg/s)
  s.addChart(pres.charts.BAR, [{
    name: "Avg msg/s",
    labels: ["Client-streaming", "NATS JetStream", "RabbitMQ Streams", "Kafka", "Unary gRPC"],
    values: [31260, 13116, 9111, 7354, 2291],
  }], {
    x: 0.55, y: 1.30, w: 4.85, h: 3.65,
    barDir: "bar",
    chartColors: [COLOR_TEAL],
    chartArea: { fill: { color: COLOR_WHITE }, roundedCorners: true },
    catAxisLabelColor: COLOR_TEXT, valAxisLabelColor: COLOR_MUTED,
    catAxisLabelFontSize: 10, valAxisLabelFontSize: 9,
    valGridLine: { color: "E2E8F0", size: 0.5 },
    catGridLine: { style: "none" },
    showValue: true, dataLabelPosition: "outEnd",
    dataLabelColor: COLOR_TEXT, dataLabelFontSize: 9,
    showLegend: false,
    showTitle: true, title: "Clean-matrix avg throughput (msg/s)",
    titleFontSize: 12, titleColor: COLOR_NAVY,
  });

  // Right column — qualitative findings
  const cx = 5.65, cy = 1.30, cw = 3.95, ch = 3.65;
  s.addShape(pres.shapes.RECTANGLE, {
    x: cx, y: cy, w: cw, h: ch,
    fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
  });
  s.addText("What we learned", {
    x: cx + 0.20, y: cy + 0.15, w: cw - 0.4, h: 0.35,
    fontSize: 15, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
  });
  s.addText([
    { text: "Client-streaming gRPC", options: { bold: true } },
    { text: " — highest sustained throughput, most stable pacing, but no built-in durable replay.", options: { breakLine: true } },
    { text: "NATS JetStream", options: { bold: true } },
    { text: " — strongest brokered throughput once tuned; occasional ordering violations on recovery.", options: { breakLine: true } },
    { text: "RabbitMQ Streams", options: { bold: true } },
    { text: " — stable under clean load; tail latency grows sharply under backpressure.", options: { breakLine: true } },
    { text: "Kafka", options: { bold: true } },
    { text: " — strongest recovery correctness (duplicate-free, ordering-violation-free) at the cost of heavy tail latency.", options: { breakLine: true } },
    { text: "Unary gRPC", options: { bold: true } },
    { text: " — predictable, low latency for small payloads; collapses on bulk transfer.", options: {} },
  ], {
    x: cx + 0.20, y: cy + 0.55, w: cw - 0.4, h: ch - 0.70,
    fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, paraSpaceAfter: 4, margin: 0,
  });

  // Footer hint
  s.addText("No single winner across all dimensions — choice is a trade-off, not a ranking.", {
    x: 0.55, y: H - 0.55, w: W - 1.1, h: 0.25,
    fontSize: 10.5, italic: true, color: COLOR_MUTED, align: "center", fontFace: FONT_BODY, margin: 0,
  });

  addPageNumber(s, 6, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 7 — Decision for DYNAMOS
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "From RQ1 → DYNAMOS — a hybrid by boundary",
    "Each communication boundary in DYNAMOS has its own right answer; no single transport wins everywhere");

  // Diagram: stacked horizontal bands showing boundaries
  const bands = [
    { label: "Intra-pod (microservice → microservice)",         chosen: "gRPC streaming",      rationale: "Already gRPC; lowest overhead; pipelining inside the chain." },
    { label: "Inter-agent (data provider → TTP / requester)",    chosen: "RabbitMQ Streams",    rationale: "Preserves brokered, decoupled model; durability, replay, no new infra." },
    { label: "Agent → API gateway → user (HTTP)",                chosen: "NDJSON chunked",      rationale: "Streams partial results to the user without changing the transport layer." },
  ];

  const by = 1.25, bh = 0.95, bgap = 0.18;
  for (let i = 0; i < bands.length; i++) {
    const b = bands[i];
    const y = by + i * (bh + bgap);
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.55, y: y, w: 0.10, h: bh, fill: { color: COLOR_TEAL }, line: { color: COLOR_TEAL, width: 0 },
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.65, y: y, w: W - 1.2, h: bh,
      fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
    });
    s.addText(b.label, {
      x: 0.85, y: y + 0.10, w: 4.30, h: 0.35,
      fontSize: 12.5, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(b.rationale, {
      x: 0.85, y: y + 0.43, w: 4.30, h: bh - 0.50,
      fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, margin: 0,
    });
    // Chosen-transport badge on the right
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, {
      x: W - 3.45, y: y + 0.20, w: 2.70, h: 0.55,
      fill: { color: COLOR_NAVY }, line: { color: COLOR_NAVY, width: 0 }, rectRadius: 0.08,
    });
    s.addText(b.chosen, {
      x: W - 3.45, y: y + 0.20, w: 2.70, h: 0.55,
      fontSize: 13, bold: true, color: COLOR_WHITE,
      align: "center", valign: "middle", fontFace: FONT_HEADER, margin: 0,
    });
  }

  // Footer rationale
  s.addText([
    { text: "Why not Kafka or NATS as primary inter-agent transport?  ", options: { bold: true, color: COLOR_NAVY } },
    { text: "Extra operational footprint, mismatch with DYNAMOS's ephemeral single-use jobs, no fit with the existing brokered architecture.", options: { color: COLOR_TEXT } },
  ], {
    x: 0.55, y: H - 0.65, w: W - 1.1, h: 0.40,
    fontSize: 11, italic: true, fontFace: FONT_BODY, margin: 0,
  });

  addPageNumber(s, 7, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 8 — RQ2 integration into DYNAMOS
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "RQ2 — Integration into DYNAMOS (MVP)",
    "feature/streaming branch; per-request transport flag drives the whole pipeline");

  // Two-column architectural summary
  const leftX = 0.55, rightX = 5.20, colW = 4.30, colY = 1.25, colH = 3.85;

  s.addShape(pres.shapes.RECTANGLE, {
    x: leftX, y: colY, w: colW, h: colH,
    fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
  });
  s.addText("Design choices", {
    x: leftX + 0.20, y: colY + 0.15, w: colW - 0.4, h: 0.40,
    fontSize: 15, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
  });
  s.addText([
    { text: "Transport flag propagated end-to-end: API gateway → policy enforcer → orchestrator → agent → sidecar", options: { bullet: true, breakLine: true } },
    { text: "Sidecar dispatches at the message level: unary AMQP, gRPC client-streaming, or RabbitMQ Streams (with publish-confirmation tracking and message-id disambiguation)", options: { bullet: true, breakLine: true } },
    { text: "Chain pipelining inside the pod: sql-query emits row batches; anonymize / aggregate / algorithm process incrementally for the average algorithm", options: { bullet: true, breakLine: true } },
    { text: "NDJSON end-to-end at the HTTP layer when the client opts in (early partial results visible to the user)", options: { bullet: true } },
  ], {
    x: leftX + 0.20, y: colY + 0.60, w: colW - 0.4, h: colH - 0.75,
    fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, paraSpaceAfter: 5, margin: 0,
  });

  s.addShape(pres.shapes.RECTANGLE, {
    x: rightX, y: colY, w: colW, h: colH,
    fill: { color: COLOR_WHITE }, line: { color: COLOR_BORDER, width: 1 },
  });
  s.addText("Preserved DYNAMOS properties", {
    x: rightX + 0.20, y: colY + 0.15, w: colW - 0.4, h: 0.40,
    fontSize: 15, bold: true, color: COLOR_TEAL, fontFace: FONT_HEADER, margin: 0,
  });
  s.addText([
    { text: "Dynamic microservice composition is unchanged — chains are still generated per request from the orchestrator", options: { bullet: true, breakLine: true } },
    { text: "Ephemeral, single-use Kubernetes jobs continue to work — broker-buffered transport tolerates cold-start gaps", options: { bullet: true, breakLine: true } },
    { text: "Policy enforcement scope unchanged — transport is a request option; doesn't widen the trust boundary", options: { bullet: true, breakLine: true } },
    { text: "Sidecar pattern preserved — communication concerns stay separate from business microservices", options: { bullet: true } },
  ], {
    x: rightX + 0.20, y: colY + 0.60, w: colW - 0.4, h: colH - 0.75,
    fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, paraSpaceAfter: 5, margin: 0,
  });

  addPageNumber(s, 8, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 9 — Preliminary RQ3 measurements
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "Preliminary RQ3 — MVP vs baseline DYNAMOS",
    "Bulk dataThroughTtp retrieval at 50 000 rows, single provider (UVA), warm steady-state");

  // Bar chart of done times
  s.addChart(pres.charts.BAR, [{
    name: "Done (s)",
    labels: ["Classic-unary\n(baseline)", "Unary batched", "Streaming gRPC", "RabbitMQ Streams"],
    values: [6.79, 4.20, 4.26, 6.00],
  }], {
    x: 0.55, y: 1.30, w: 5.30, h: 3.55,
    barDir: "col",
    chartColors: ["8B8B8B", COLOR_TEAL, COLOR_TEAL, COLOR_TEAL],
    chartArea: { fill: { color: COLOR_WHITE }, roundedCorners: true },
    catAxisLabelColor: COLOR_TEXT, valAxisLabelColor: COLOR_MUTED,
    catAxisLabelFontSize: 10, valAxisLabelFontSize: 9,
    valGridLine: { color: "E2E8F0", size: 0.5 }, catGridLine: { style: "none" },
    showValue: true, dataLabelPosition: "outEnd",
    dataLabelColor: COLOR_TEXT, dataLabelFontSize: 10,
    valAxisTitle: "seconds", showValAxisTitle: true, valAxisTitleFontSize: 10, valAxisTitleColor: COLOR_MUTED,
    showLegend: false,
    showTitle: true, title: "End-to-end completion time (lower is better)",
    titleFontSize: 12, titleColor: COLOR_NAVY,
  });

  // Findings panel
  const px = 6.10, py = 1.30, pw = 3.50, ph = 3.55;
  s.addShape(pres.shapes.RECTANGLE, {
    x: px, y: py, w: pw, h: ph,
    fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
  });
  s.addText("First observations", {
    x: px + 0.20, y: py + 0.15, w: pw - 0.4, h: 0.35,
    fontSize: 14, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
  });
  s.addText([
    { text: "Batching is the dominant win", options: { bullet: true, bold: true, breakLine: true } },
    { text: "  ~38% faster than the unmodified baseline", options: { breakLine: true } },
    { text: "Transport difference is small", options: { bullet: true, bold: true, breakLine: true } },
    { text: "  unary-batched ≈ streaming-batched", options: { breakLine: true } },
    { text: "RabbitMQ Streams pays a predictable", options: { bullet: true, bold: true, breakLine: true } },
    { text: "  overhead — durability & decoupling have a cost", options: { breakLine: true } },
    { text: "Time-to-first-result halved", options: { bullet: true, bold: true, breakLine: true } },
    { text: "  ~3.2s vs single 6.8s response for the baseline", options: {} },
  ], {
    x: px + 0.20, y: py + 0.55, w: pw - 0.4, h: ph - 0.70,
    fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, paraSpaceAfter: 3, margin: 0,
  });

  addPageNumber(s, 9, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 10 — Open issues / what I learned
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "Open issues and what they reveal",
    "Findings that are themselves part of the RQ3 story");

  const items = [
    {
      title: "250 000-row bulk crash",
      body: "Non-average bulk still buffers in the aggregate stage and is rebuilt as one full JSON table in the algorithm stage. Hits the hard NDJSON 20-min and classic-unary 30-s deadlines.",
      tag: "Bottleneck",
    },
    {
      title: "Column-order nondeterminism",
      body: "convertAllData iterates a Go map, so column order in the final result drifts per transport. Same rows, different schema order — correctness issue, not transport issue.",
      tag: "Bug",
    },
    {
      title: "Streaming wins ≈ batching wins, for now",
      body: "Until the chain is fully pipelined for all algorithms, the inter-agent transport choice is dominated by whether anything streams at all — not by which transport does the streaming.",
      tag: "Insight",
    },
  ];

  const iy = 1.25, ih = 1.15, igap = 0.15;
  for (let i = 0; i < items.length; i++) {
    const it = items[i];
    const y = iy + i * (ih + igap);
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.55, y: y, w: W - 1.1, h: ih,
      fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
    });
    s.addShape(pres.shapes.RECTANGLE, {
      x: 0.55, y: y, w: 0.10, h: ih, fill: { color: COLOR_TEAL }, line: { color: COLOR_TEAL, width: 0 },
    });
    s.addText(it.title, {
      x: 0.85, y: y + 0.12, w: 6.0, h: 0.35,
      fontSize: 13.5, bold: true, color: COLOR_NAVY, fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(it.body, {
      x: 0.85, y: y + 0.46, w: 6.0, h: ih - 0.55,
      fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, valign: "top", margin: 0,
    });
    // Tag pill
    s.addShape(pres.shapes.ROUNDED_RECTANGLE, {
      x: W - 2.20, y: y + 0.35, w: 1.50, h: 0.45,
      fill: { color: COLOR_NAVY }, line: { color: COLOR_NAVY, width: 0 }, rectRadius: 0.06,
    });
    s.addText(it.tag, {
      x: W - 2.20, y: y + 0.35, w: 1.50, h: 0.45,
      fontSize: 11, bold: true, color: COLOR_WHITE, align: "center", valign: "middle",
      fontFace: FONT_HEADER, margin: 0,
    });
  }

  addPageNumber(s, 10, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 11 — Next month
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_WHITE };
  addSlideHeader(s, "Next month — RQ3 build-out + thesis writing",
    "Four concrete deliverables before submission");

  const tasks = [
    { n: 1, title: "Fix end-to-end pipelining",     body: "Make non-average bulk truly streaming through the whole chain. Remove the aggregate-stage buffer. Reproduce 250k cleanly." },
    { n: 2, title: "Expand RQ3 evaluation",         body: "Both archetypes × multiple payload sizes × cold/warm. Add concurrent-request scalability. Failure-injection for the durability story." },
    { n: 3, title: "Optional scalability angle",    body: "Investigate DYNAMOS's scattered directive as a local scalability lens (Fabric is out of scope per supervisor)." },
    { n: 4, title: "Thesis writing & RQ2/RQ3 split", body: "Move the DYNAMOS measurements from RQ2 into RQ3. RQ2 stays the architectural integration; RQ3 owns the empirical impact." },
  ];

  const gridX = 0.55, gridY = 1.25;
  const cardW = 4.50, cardH = 1.75, gapX = 0.15, gapY = 0.15;
  for (let i = 0; i < tasks.length; i++) {
    const col = i % 2, row = Math.floor(i / 2);
    const x = gridX + col * (cardW + gapX);
    const y = gridY + row * (cardH + gapY);
    s.addShape(pres.shapes.RECTANGLE, {
      x, y, w: cardW, h: cardH,
      fill: { color: COLOR_LIGHT }, line: { color: COLOR_BORDER, width: 1 },
    });
    s.addShape(pres.shapes.OVAL, {
      x: x + 0.20, y: y + 0.20, w: 0.50, h: 0.50,
      fill: { color: COLOR_TEAL }, line: { color: COLOR_TEAL, width: 0 },
    });
    s.addText(String(tasks[i].n), {
      x: x + 0.20, y: y + 0.20, w: 0.50, h: 0.50,
      fontSize: 18, bold: true, color: COLOR_WHITE,
      align: "center", valign: "middle", fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(tasks[i].title, {
      x: x + 0.85, y: y + 0.20, w: cardW - 1.00, h: 0.50,
      fontSize: 14, bold: true, color: COLOR_NAVY, valign: "middle", fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(tasks[i].body, {
      x: x + 0.20, y: y + 0.80, w: cardW - 0.40, h: cardH - 0.95,
      fontSize: 10.5, color: COLOR_TEXT, fontFace: FONT_BODY, margin: 0,
    });
  }

  addPageNumber(s, 11, TOTAL_SLIDES);
}

// =============================================================================
// SLIDE 12 — Summary / closing
// =============================================================================
{
  const s = pres.addSlide();
  s.background = { color: COLOR_DARK };
  s.addShape(pres.shapes.RECTANGLE, {
    x: 0.0, y: 0.0, w: 0.30, h: H, fill: { color: COLOR_TEAL }, line: { color: COLOR_TEAL, width: 0 },
  });

  s.addText("Where I am at the midpoint", {
    x: 0.7, y: 0.50, w: W - 1.0, h: 0.55,
    fontSize: 28, bold: true, color: COLOR_WHITE, fontFace: FONT_HEADER, margin: 0,
  });

  s.addShape(pres.shapes.LINE, {
    x: 0.7, y: 1.10, w: 1.2, h: 0,
    line: { color: COLOR_ACCENT, width: 2 },
  });

  const lines = [
    { label: "RQ1 — Candidate evaluation",   body: "Done. Five transports benchmarked across four scenario families." },
    { label: "RQ2 — Integration into DYNAMOS", body: "MVP implemented. Transport flag, intra-pod gRPC streaming, inter-agent RabbitMQ Streams, NDJSON end-to-end." },
    { label: "RQ3 — Impact evaluation",       body: "First measurements show batching is the headline win; transport choice is a secondary trade-off. Full evaluation in progress." },
  ];
  let ly = 1.55;
  for (const l of lines) {
    s.addText(l.label, {
      x: 0.7, y: ly, w: W - 1.0, h: 0.32,
      fontSize: 16, bold: true, color: COLOR_ACCENT, fontFace: FONT_HEADER, margin: 0,
    });
    s.addText(l.body, {
      x: 0.7, y: ly + 0.32, w: W - 1.0, h: 0.50,
      fontSize: 13, color: COLOR_WHITE, fontFace: FONT_BODY, margin: 0,
    });
    ly += 0.95;
  }

  s.addText("Questions?", {
    x: 0.7, y: H - 0.80, w: W - 1.0, h: 0.40,
    fontSize: 20, bold: true, color: COLOR_WHITE, fontFace: FONT_HEADER, italic: true, margin: 0,
  });
}

// =============================================================================
// Write file
// =============================================================================
pres.writeFile({ fileName: "midterm_presentation.pptx" })
  .then((fileName) => console.log("Wrote", fileName));
