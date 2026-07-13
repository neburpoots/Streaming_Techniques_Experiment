# Kafka tuning study

Date: 2026-07-13

This study tests whether the Kafka mapping in the RQ1 benchmark is unfairly
configured and which changes improve its single-node behavior. It does not
replace the thesis benchmark and no thesis text was changed.

## Baseline under test

The thesis configuration is one Kafka 3.9.1 broker with replication factor 1,
16 topic partitions, one transformer pod, one sink pod, and 16 logical workers.
The Go client uses worker-key hashing, leader acknowledgements, no compression,
256-record or 1 MiB batches, a 5 ms flush interval, a 64 KiB minimum fetch, a
250 ms maximum fetch wait, and a 250 ms commit interval. Broker and workload
resources are kept equal to the other single-node transport mappings.

This is a fair configuration for the thesis question: comparing transport
mappings under equal local resources. It is not a Kafka scale-out benchmark.
A one-broker, replication-factor-one deployment cannot demonstrate the
multi-broker partition and replication scaling for which Kafka is designed.

## Method

The discovery matrix ran 114 successful Kafka cells, using three repetitions
per cell, 20,000 messages, 1 KiB and 16 KiB payloads, and concurrency 16. It
tested producer batching, consumer fetch timing, LZ4, 1/4/8/16 partitions,
message keys, 1/2/4 transformer replicas, and none/leader/all acknowledgements.

The discovery sweep reused the broker to keep the matrix tractable. Because
topics are scoped per run, that accumulated logs and metadata. Eight unrelated
kind clusters were also active on the host. Its keying, acknowledgement, and
topology results are therefore directional evidence only.

The confirmation corpus stopped the unrelated kind clusters, restarted Kafka
for every repetition, retained the thesis resource limits, and used the same
20,000-message workload. It contains 30 client-tuning runs, five per cell, and
24 partition runs, three per cell. All 54 runs completed the expected 20,000
unique messages, reported no loss or ordering violation, and produced valid
resource samples. They recorded 18 duplicate deliveries in total; duplicates
are counted separately and do not inflate throughput.

## Confirmed client results

| Configuration | Payload | Runs | Mean msg/s | Mean MiB/s | Mean p95 |
| --- | ---: | ---: | ---: | ---: | ---: |
| thesis baseline | 1 KiB | 5 | 49,603.9 | 48.4 | 720.8 ms |
| fetch-fast | 1 KiB | 5 | 15,336.1 | 15.0 | 1,535.1 ms |
| fetch-fast + LZ4 | 1 KiB | 5 | 11,343.2 | 11.1 | 1,539.8 ms |
| thesis baseline | 16 KiB | 5 | 3,918.7 | 61.2 | 2,581.6 ms |
| fetch-fast | 16 KiB | 5 | 4,412.5 | 68.9 | 3,574.7 ms |
| fetch-fast + LZ4 | 16 KiB | 5 | 4,057.1 | 63.4 | 3,420.1 ms |

`fetch-fast` changes the minimum fetch from 64 KiB to 1 KiB and maximum fetch
wait from 250 ms to 20 ms. At 16 KiB it improves throughput by 12.6%, but raises
mean p95 latency by 38.5%. It is a throughput/latency tradeoff, not a free gain.
The 1 KiB runs are very short and burst-sensitive, so their exact ordering is
not stable enough to support a tuning recommendation.

LZ4 does not improve this synthetic workload consistently. With otherwise
identical fast-fetch settings it is 8.1% slower than uncompressed fast-fetch at
16 KiB. Compression should not be enabled only to improve the thesis score. A
fair compression comparison would enable equivalent compression for all
brokered transports and use representative, compressible DYNAMOS payloads.

Increasing producer batches to 512 or 1,024 records and increasing linger to
10 or 20 ms did not improve the discovery result. A 4 MiB client batch also
requires raising Kafka's broker message limit above its approximately 1 MiB
default, so it changes both sides of the comparison. The existing 256-record,
1 MiB, 5 ms setup remains the best balanced producer setting tested.

## Confirmed partition scaling

| Partitions | 1 KiB msg/s | 1 KiB p95 | 16 KiB msg/s | 16 KiB MiB/s | 16 KiB p95 |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 13,457.7 | 891.6 ms | 4,185.5 | 65.4 | 3,241.2 ms |
| 4 | 29,626.7 | 638.3 ms | 4,294.4 | 67.1 | 2,468.0 ms |
| 8 | 15,810.3 | 869.7 ms | 4,358.0 | 68.1 | 2,960.6 ms |
| 16 | 13,815.7 | 1,245.7 ms | 4,133.7 | 64.6 | 3,808.0 ms |

Partition scaling is not linear on one broker. Four partitions is the best
1 KiB point and eight is the best 16 KiB point. At 16 KiB, however, the spread
between one and eight partitions is only 4.1%. Sixteen partitions provides one
partition per logical worker, but it is not the fastest local setting. Eight is
a reasonable throughput-oriented local choice; keeping 16 is still defensible
when the mapping and future concurrency headroom matter more than a small local
mean difference.

## Directional architecture findings

These cells are from the three-repetition discovery sweep and should be read as
directional because the broker was reused and run variability was high.

| Change | 16 KiB mean msg/s | Correctness | Interpretation |
| --- | ---: | --- | --- |
| one run-wide key | 2,417.8 | ordered | Serializes a run onto one partition |
| worker key | 2,984.3 | ordered | 23.4% faster; preserves per-worker order |
| no key | 2,383.1 | 26,798 order violations | Invalid for the benchmark semantics |
| 1 transformer replica | 3,092.8 | complete | Best tested one-node topology |
| 2 transformer replicas | 3,009.9 | complete | No useful gain |
| 4 transformer replicas | 2,139.4 | complete | More coordination and contention |
| acknowledgements disabled | 3,779.9 | duplicates and 484 order violations | Not acceptable |
| leader acknowledgement | 3,503.3 | ordered | Current balanced choice |
| all ISR acknowledgements | 2,564.4 | ordered | RF=1 gives no extra replica durability |

Worker-key partitioning is the correct current choice. Removing keys harms both
ordering and throughput. Additional transformer replicas do not help when one
broker, one sink, and 16 partitions already bound useful parallelism. A real
scale-out test must add brokers, nodes, partitions, and downstream capacity
together rather than only adding consumer pods.

With replication factor 1, leader and all-ISR acknowledgement policies both
wait on the only replica. Their measured difference is therefore not a general
Kafka durability conclusion. Disabling acknowledgements is faster in some
cells but caused ordering violations and is not a fair DYNAMOS option.

## Reliability findings

Two operational issues materially affected Kafka before tuning could be judged:

1. Consumers could join a stable group before newly created topic partitions
   were visible, leaving all members assigned zero partitions. The transport
   now waits for the expected topic metadata before returning from topic setup.
2. Reusing Kafka across run-scoped topics accumulated broker state. The tuning
   runner now restarts the broker per case by default, matching the isolation
   expected by the thesis runner.

A separate 100,000-message stress attempt was not included. Its 16 KiB cell
exceeded the unchanged 512 MiB transformer limit and was OOM-killed. Raising
that limit would test a different resource regime.

## Conclusion

The thesis Kafka setup is fair for an equal-resource, single-node comparison
and is not intentionally crippled. It already uses 16 partitions, asynchronous
batched publishing, worker keys, and one broker-facing transformer. Kafka's
lower thesis result should be described as performance in this local pipeline,
not as a claim that Kafka has lower maximum throughput in a distributed system.

The best supported changes are operational isolation and topic-readiness, not
aggressive batching. For the current thesis setup, retain worker keys, one
transformer replica, leader acknowledgements, and the existing producer batch.
Use the existing fetch settings for lower tail latency, or the fast-fetch
settings only when roughly 13% more large-payload throughput is worth roughly
39% higher p95 latency. Do not replace the thesis comparison with compressed
Kafka-only numbers.

## References

- Apache Kafka 3.9 producer configuration:
  https://kafka.apache.org/39/configuration/producer-configs/
- Apache Kafka 3.9 broker configuration:
  https://kafka.apache.org/39/configuration/broker-configs/
- Apache Kafka design documentation:
  https://kafka.apache.org/39/design/design/
- kafka-go client documentation and source:
  https://github.com/segmentio/kafka-go
