# RQ1 Benchmark Design

This benchmark design is kept as the thesis RQ1 baseline and extended to six transport modes: per-message unary gRPC, batched unary gRPC, client-streaming gRPC, RabbitMQ Streams, NATS JetStream, and Kafka.

## Methodological Position

The scenario set is literature-guided rather than copied from one existing benchmark. It combines recurring evaluation dimensions from stream-processing and microservice communication studies:

- Karimov et al. separate benchmark driver and system under test, and emphasize throughput and latency for stream-processing systems.
- Henning and Hasselbring frame scalability measurement as a first-class distributed-stream-processing concern.
- Ris et al. identify processing time, startup time, resource consumption, scalability, bandwidth, fault tolerance, loss, duplication, transfer rate, packet loss, and delays as recurring metrics in containerized microservice streaming studies.
- Coviello et al. use a multi-stage microservice pipeline and report processing rate, latency, jitter, and network/resource effects, which maps well to DYNAMOS-style chains.
- Vogel et al. motivate explicit recovery metrics rather than treating failure handling as a binary pass/fail result.

The thesis contribution is the DYNAMOS-specific operationalization: the same three-stage Producer -> Transformer -> Sink chain is evaluated under clean transfer, paced flow, slow-consumer pressure, and forced restart. This is not fully novel as a performance methodology, but it is novel enough in context because it applies the dimensions to dynamically composed, policy-driven data-exchange middleware.

## Fixed Fairness Rules

- Keep one payload schema for every transport.
- Keep the same three service roles and deterministic transformer work.
- Partition by worker/flow so per-flow ordering is meaningful.
- Use run-scoped broker streams/topics to avoid cross-run offset contamination.
- Use explicit consumer acknowledgements where the broker supports them, while keeping producer publishing asynchronous or batched where that is the intended fast path.
- Collect the same sink-side correctness and timing metrics for every mode.
- Count logical messages at the sink for every transport, including batched unary, so throughput is not inflated by changing the number of RPC calls.

## Final Scenario Set

| Scenario | Primary story | Main metrics |
| --- | --- | --- |
| Synthetic clean bulk | Raw transfer efficiency and protocol/broker overhead | msg/s, MiB/s, p50/p95/p99 latency, max latency, duplicates, ordering violations, CPU, memory |
| Synthetic continuous | Delivery rhythm under a stable target rate | achieved msg/s, p95 latency, mean/p95 inter-arrival, jitter, CPU, memory |
| Synthetic slow consumer | Backpressure and overload handling | throughput loss, p95/p99 latency growth, jitter, backlog-like delay, duplicates, ordering violations |
| Synthetic forced recovery | Failure visibility and restart behaviour | completion ratio, loss, duplicates, ordering violations, time to first post-failure message, end-to-end recovery time, backlog drain time, recovery-window p95 latency, throughput debt |

The harness still contains a CSV replay mode for local sanity checks with copied DYNAMOS rows. It is not part of the current thesis evidence unless a comparable result set is generated and reported.

## Interpretation Rules

Do not rank transports by a single metric. The useful answer to RQ1 is a trade-off map:

- direct gRPC modes should be judged on low overhead, latency, coupling, and application-managed recovery;
- batched unary should be interpreted as the realistic request-response control for DYNAMOS-sized chunks, not as the same thing as one unary RPC per message;
- brokered modes should be judged on decoupling, replay/ack semantics, backlog handling, duplicate behaviour, and broker resource cost;
- scenario-specific metrics should explain why a mechanism differs, not only that it differs.

The main thesis body should show the compact matrix and the most explanatory figures. Full per-run outputs, repeated-run aggregates, and secondary plots belong in the appendix or results folder.
