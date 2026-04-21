# gRPC Streaming Baseline

This folder is an isolated first experiment for research question one. It is intentionally separate from DYNAMOS so the transport benchmark can be developed and tested without coupling the implementation to the main platform codebase.

## Why this first slice

This setup is a good starting point if the goal is to answer the first phase of the research in a defensible way:

- it keeps the first comparison narrow: gRPC client streaming versus unary gRPC;
- it uses a small but meaningful three-stage topology: Producer -> Transformer -> Sink;
- it keeps application logic intentionally lightweight so the measured differences are primarily communication effects;
- it already supports the experimental factors that matter most for the first baseline: message size, total volume, concurrency, synthetic CPU work in the middle stage, artificial sink slowdowns, and a broker-based comparison through RabbitMQ Streams.

## Metrics used consistently

The metrics are chosen to line up with the papers already discussed in the thesis draft:

- throughput in messages per second and MiB per second;
- end-to-end latency at the sink, reported as p50, p95, p99, and max;
- inter-arrival regularity for continuous runs, reported as mean, p95, and jitter proxy at the sink;
- total stream completion time for the run;
- duplicate detection and per-flow ordering violations;
- retry attempts, stream reconnects, and recovery timing during restart-oriented runs;
- per-service message and byte counters through Prometheus-style `/metrics` endpoints;
- container CPU and memory snapshots through `docker stats` sampling.

These are grounded in the literature already cited in the thesis: latency, throughput, scalability/resource metrics, and jitter-like delivery regularity are emphasized in reviews and comparative experiments such as `ciftci2025ipcmechanisms`, `Henning2021ScalabilityMetrics`, `sodankoor2026grpcbench`, and `coviello2022dataxc`.

## Workload types

The experiment now supports two workload sources:

- `synthetic`: deterministic generated payloads with exact size control;
- `csv-replay`: repeated batches of rows from the copied DYNAMOS CSV datasets.

Scenario behavior is controlled separately through the run profile and stress settings:

- `bulk`: clean transfer baseline with no target send rate;
- `continuous`: rate-limited flow where inter-arrival stability becomes meaningful;
- slow-consumer runs via `SINK_PROCESS_DELAY_MS`;
- recovery runs via `FAILURE_ACTION`, `FAILURE_TARGET`, `FAILURE_AFTER_SECONDS`, and producer retry settings.

## Why synthetic data first

For the first benchmark, synthetic payloads are better than reusing the CSV files from DYNAMOS.

- Synthetic payloads let you control message size exactly.
- They make runs reproducible across mechanisms.
- They avoid mixing transport effects with dataset-specific parsing effects.

The DYNAMOS CSVs are still useful later as a replay-style workload once the baseline transport benchmark is stable, and that replay mode is now included in the producer.

## Current topology

- `producer`: generates deterministic payloads and opens one or more client streams to the transformer.
- `transformer`: optional lightweight CPU work, then forwards chunks to the sink via client streaming.
- `sink`: computes canonical run-level metrics and writes a JSON summary.

The same three-stage topology can now be run in three transport modes:

- `client-streaming`: one client stream per producer worker;
- `unary`: one request per message across the same topology.
- `rabbitmq-streams`: producer -> RabbitMQ Streams -> transformer -> RabbitMQ Streams -> sink.

## First experiment matrix to use

Do not start with every possible factor crossed at once. Start with a narrow baseline matrix:

1. Fix topology to the three-service chain.
2. Run `client-streaming`, `unary`, and `rabbitmq-streams` over the exact same workload.
3. Sweep `PAYLOAD_BYTES`: for example `256`, `1024`, `4096`, `16384`.
4. Sweep `CONCURRENCY`: for example `1`, `4`, `8`, `16`.
5. Keep `TOTAL_MESSAGES` fixed per run, for example `50000`.
6. Keep `TRANSFORMER_WORK_ITERATIONS=0` and `SINK_PROCESS_DELAY_MS=0` for the first clean transport baseline.
7. After that, introduce one stressor at a time: transformer work, sink slowdown, then resource-budget sweeps in Kubernetes.

## CSV replay mode

CSV replay treats each non-header dataset row as content and groups rows into messages.

- `DATASET_FILES` selects one or more CSV files separated by commas.
- `DATASET_ROWS_PER_MESSAGE` controls how many rows are packed into one message.
- `DATASET_REPEAT_COUNT` duplicates the prepared replay batches before cycling through them.

This gives you a realistic workload shape without tying the benchmark to a single tiny file. If one row is roughly `40` to `60` bytes, then `DATASET_ROWS_PER_MESSAGE=25` gives messages of roughly `1 KB`.

## Running locally

Generate protobuf stubs:

```bash
./scripts/gen-proto.sh
```

Start the local baseline run:

```bash
RUN_ID=bulk-baseline ./scripts/run-local.sh
```

Override parameters with environment variables, for example:

```bash
RUN_ID=bulk-4k-c8 \
TRANSPORT_MODE=client-streaming \
TOTAL_MESSAGES=50000 \
PAYLOAD_BYTES=4096 \
CONCURRENCY=8 \
TARGET_MESSAGES_PER_SECOND=0 \
./scripts/run-local.sh
```

Unary comparison run:

```bash
RUN_ID=bulk-unary-4k-c8 \
TRANSPORT_MODE=unary \
TOTAL_MESSAGES=50000 \
PAYLOAD_BYTES=4096 \
CONCURRENCY=8 \
TARGET_MESSAGES_PER_SECOND=0 \
./scripts/run-local.sh
```

RabbitMQ Streams comparison run:

```bash
RUN_ID=bulk-rmqs-4k-c8 \
TRANSPORT_MODE=rabbitmq-streams \
TOTAL_MESSAGES=50000 \
PAYLOAD_BYTES=4096 \
CONCURRENCY=8 \
TARGET_MESSAGES_PER_SECOND=0 \
./scripts/run-local.sh
```

CSV replay run using the copied datasets:

```bash
RUN_ID=csv-streaming \
TRANSPORT_MODE=client-streaming \
WORKLOAD_SOURCE=csv-replay \
DATASET_FILES=Personen.csv,Aanstellingen.csv \
DATASET_ROWS_PER_MESSAGE=25 \
DATASET_REPEAT_COUNT=20 \
TOTAL_MESSAGES=5000 \
CONCURRENCY=8 \
./scripts/run-local.sh
```

Results are written to `results/`.

- `*-sink-summary.json`: canonical end-to-end run summary.
- `*-producer-result.json`: producer view plus workload metadata, retry counts, reconnect counts, and recovery timing.
- `*-docker-stats.ndjson`: container CPU and memory snapshots taken during the run.
- `*-summary.csv`: exported comparison table with sink metrics and per-role CPU/memory aggregates.

## Matrix runs and CSV export

The local PowerShell matrix runner now executes all three transport modes per preset: `client-streaming`, `unary`, and `rabbitmq-streams`.

For the thesis-style comparable benchmark set, prefer the Kubernetes runner because it applies the same scenario presets across all three transports while also collecting pod-level resource measurements.

Run the preset synthetic matrix:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
	\\wsl.localhost\Ubuntu\home\nebur\Streaming_Techniques_Experiment\experiments\grpc-streaming-baseline\scripts\run-matrix.ps1 \
	-Preset synthetic-clean
```

Run the continuous synthetic matrix that exposes inter-arrival regularity:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
	\\wsl.localhost\Ubuntu\home\nebur\Streaming_Techniques_Experiment\experiments\grpc-streaming-baseline\scripts\run-matrix.ps1 \
	-Preset synthetic-continuous
```

Run the slow-consumer matrix:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
	\\wsl.localhost\Ubuntu\home\nebur\Streaming_Techniques_Experiment\experiments\grpc-streaming-baseline\scripts\run-matrix.ps1 \
	-Preset synthetic-backpressure
```

Run the restart-and-recovery matrix:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
	\\wsl.localhost\Ubuntu\home\nebur\Streaming_Techniques_Experiment\experiments\grpc-streaming-baseline\scripts\run-matrix.ps1 \
	-Preset synthetic-recovery
```

Run the smaller CSV replay matrix:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
	\\wsl.localhost\Ubuntu\home\nebur\Streaming_Techniques_Experiment\experiments\grpc-streaming-baseline\scripts\run-matrix.ps1 \
	-Preset csv-replay-check
```

Run the comparable three-transport Kubernetes presets:

```bash
./scripts/run-k8s-matrix.sh synthetic-clean --overlay resource-medium --repeat 3 --skip-load
./scripts/run-k8s-matrix.sh synthetic-continuous --overlay resource-medium --repeat 3 --skip-load
./scripts/run-k8s-matrix.sh synthetic-backpressure --overlay resource-medium --repeat 3 --skip-load
./scripts/run-k8s-matrix.sh synthetic-recovery --overlay resource-medium --repeat 3 --skip-load
./scripts/run-k8s-matrix.sh csv-replay-check --overlay resource-medium --repeat 3 --skip-load
```

If you are running on `kind` instead of the `docker-desktop` cluster, omit `--skip-load` so the freshly built images are loaded into the cluster.

Export a comparison CSV from the JSON results:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
	\\wsl.localhost\Ubuntu\home\nebur\Streaming_Techniques_Experiment\experiments\grpc-streaming-baseline\scripts\export-results.ps1
```

## Kubernetes resource sweeps

The `k8s/` folder is structured so you can repeat the same experiment under explicit pod limits. That is the right way to study whether CPU and memory constraints change the relative behavior of the mechanism.

The recommended sequence is:

1. validate the baseline locally with Docker Compose;
2. deploy the same experiment to Kubernetes with the `resource-small`, `resource-medium`, and `resource-large` overlays;
3. keep the workload fixed while only changing resource budgets;
4. record the same metrics in each run.

## What is intentionally not included yet

- Prometheus/Grafana stack for historical dashboards.

CSV replay is primarily wired for local Docker runs. For Kubernetes, the same envs are exposed in the manifests, but you still need to mount the datasets into the producer pod before enabling `WORKLOAD_SOURCE=csv-replay` there.
