Files used:
- thesis-evidence/rq1-10-repetitions/source-results/01-rq1-concept5-clean-no256k-20260615-synthetic-clean-summary.csv
- thesis-evidence/rq1-10-repetitions/source-results/02-rq1-concept5-scenarios-no256k-20260616-synthetic-continuous-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/03-rq1-concept5-scenarios-no256k-20260616-synthetic-backpressure-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/04-rq1-concept5-scenarios-no256k-20260616-synthetic-recovery-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/05-rq1-nats-fetchwait-20260621-synthetic-clean-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/06-rq1-nats-fetchwait-20260621-synthetic-continuous-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/07-rq1-nats-fetchwait-20260621-synthetic-backpressure-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/08-rq1-nats-fetchwait-20260621-synthetic-recovery-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/09-rq1-extra5-no256k-20260709-synthetic-clean-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/10-rq1-extra5-no256k-20260709-synthetic-continuous-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/11-rq1-extra5-no256k-20260709-synthetic-backpressure-summary-aggregated.csv
- thesis-evidence/rq1-10-repetitions/source-results/12-rq1-extra5-no256k-20260709-synthetic-recovery-summary-aggregated.csv

# RQ1 aggregated results

## Repetition counts per cell (check these first!)

- **clean**: batched-unary: [10], client-streaming: [10], kafka: [10], nats-jetstream: [10], rabbitmq-streams: [10], unary: [10]
- **continuous**: batched-unary: [10], client-streaming: [10], kafka: [10], nats-jetstream: [10], rabbitmq-streams: [10], unary: [10]
- **backpressure**: batched-unary: [10], client-streaming: [10], kafka: [10], nats-jetstream: [10], rabbitmq-streams: [10], unary: [10]
- **recovery**: batched-unary: [10], client-streaming: [10], kafka: [10], nats-jetstream: [10], rabbitmq-streams: [10], unary: [10]

## Clean summary (thesis Table: single-node synthetic-clean)

| Transport | Avg msg/s | Avg MiB/s | Avg p95 ms | Avg p99 ms | Duplicates (mean/run) | Ordering viol. |
|---|---|---|---|---|---|---|
| batched-unary | 49,096.11 | 101.44 | 51.92 | 69.27 | 0.00 | 0.00 |
| client-streaming | 53,164.34 | 102.49 | 107.55 | 133.12 | 0.00 | 0.00 |
| kafka | 11,293.92 | 27.79 | 1,186.93 | 1,323.08 | 0.66 | 0.00 |
| nats-jetstream | 13,336.05 | 38.20 | 1,115.43 | 1,185.77 | 0.00 | 0.00 |
| rabbitmq-streams | 13,648.01 | 31.58 | 873.08 | 912.17 | 0.00 | 0.00 |
| unary | 3,066.43 | 13.09 | 1.60 | 23.64 | 0.00 | 0.00 |

## Clean msg/s by payload size (appendix per-size table)

| Msg size | batched-unary | client-streaming | kafka | nats-jetstream | rabbitmq-streams | unary |
|---|---|---|---|---|---|---|
| 256 B | 87,393 | 101,778 | 17,486 | 19,105 | 22,553 | 3,555 |
| 1024 B | 61,882 | 68,038 | 14,485 | 16,667 | 17,867 | 3,323 |
| 4096 B | 35,167 | 29,928 | 9,691 | 12,178 | 10,077 | 3,066 |
| 16384 B | 11,943 | 12,913 | 3,513 | 5,394 | 4,095 | 2,322 |

## Clean detailed msg/s by size x concurrency (appendix)

| Size | Conc | batched-unary | client-streaming | kafka | nats-jetstream | rabbitmq-streams | unary |
|---|---|---|---|---|---|---|---|
| 256 | 1 | 50,874 | 102,181 | 20,146 | 16,617 | 19,183 | 933 |
| 256 | 4 | 86,526 | 100,739 | 16,876 | 20,470 | 25,848 | 2,844 |
| 256 | 8 | 101,825 | 114,765 | 17,270 | 18,884 | 24,362 | 4,191 |
| 256 | 16 | 110,346 | 89,428 | 15,651 | 20,449 | 20,818 | 6,252 |
| 1024 | 1 | 34,060 | 70,938 | 16,882 | 14,211 | 16,008 | 966 |
| 1024 | 4 | 70,253 | 73,665 | 13,889 | 16,787 | 18,030 | 2,542 |
| 1024 | 8 | 73,116 | 65,887 | 15,332 | 17,689 | 19,021 | 4,150 |
| 1024 | 16 | 70,098 | 61,663 | 11,837 | 17,979 | 18,410 | 5,632 |
| 4096 | 1 | 22,985 | 29,454 | 9,760 | 10,003 | 8,737 | 988 |
| 4096 | 4 | 36,309 | 31,524 | 10,416 | 12,561 | 10,663 | 2,507 |
| 4096 | 8 | 41,008 | 30,307 | 10,031 | 13,286 | 10,285 | 3,773 |
| 4096 | 16 | 40,364 | 28,426 | 8,558 | 12,863 | 10,622 | 4,995 |
| 16384 | 1 | 9,335 | 10,287 | 3,331 | 4,819 | 3,027 | 854 |
| 16384 | 4 | 12,631 | 14,022 | 3,527 | 5,525 | 4,691 | 2,097 |
| 16384 | 8 | 13,371 | 13,836 | 3,746 | 5,997 | 4,530 | 2,580 |
| 16384 | 16 | 12,435 | 13,507 | 3,450 | 5,236 | 4,132 | 3,759 |

## Clean detailed MiB/s by size x concurrency (appendix)

| Size | Conc | batched-unary | client-streaming | kafka | nats-jetstream | rabbitmq-streams | unary |
|---|---|---|---|---|---|---|---|
| 256 | 1 | 12.42 | 24.95 | 4.92 | 4.06 | 4.68 | 0.23 |
| 256 | 4 | 21.12 | 24.59 | 4.12 | 5.00 | 6.31 | 0.69 |
| 256 | 8 | 24.86 | 28.02 | 4.22 | 4.61 | 5.95 | 1.02 |
| 256 | 16 | 26.94 | 21.83 | 3.82 | 4.99 | 5.08 | 1.53 |
| 1024 | 1 | 33.26 | 69.28 | 16.49 | 13.88 | 15.63 | 0.94 |
| 1024 | 4 | 68.61 | 71.94 | 13.56 | 16.39 | 17.61 | 2.48 |
| 1024 | 8 | 71.40 | 64.34 | 14.97 | 17.27 | 18.58 | 4.05 |
| 1024 | 16 | 68.46 | 60.22 | 11.56 | 17.56 | 17.98 | 5.50 |
| 4096 | 1 | 89.79 | 115.05 | 38.12 | 39.07 | 34.13 | 3.86 |
| 4096 | 4 | 141.83 | 123.14 | 40.69 | 49.07 | 41.65 | 9.79 |
| 4096 | 8 | 160.19 | 118.39 | 39.19 | 51.90 | 40.18 | 14.74 |
| 4096 | 16 | 157.67 | 111.04 | 33.43 | 50.25 | 41.49 | 19.51 |
| 16384 | 1 | 145.86 | 160.74 | 52.05 | 75.30 | 47.30 | 13.34 |
| 16384 | 4 | 197.37 | 219.09 | 55.11 | 86.33 | 73.30 | 32.76 |
| 16384 | 8 | 208.92 | 216.18 | 58.53 | 93.70 | 70.78 | 40.32 |
| 16384 | 16 | 194.30 | 211.05 | 53.90 | 81.82 | 64.56 | 58.73 |

## Clean detailed p95 latency ms by size x concurrency (appendix)

| Size | Conc | batched-unary | client-streaming | kafka | nats-jetstream | rabbitmq-streams | unary |
|---|---|---|---|---|---|---|---|
| 256 | 1 | 1.3 | 17.3 | 176.7 | 648.2 | 249.2 | 0.7 |
| 256 | 4 | 6.9 | 61.7 | 543.0 | 561.2 | 320.1 | 1.0 |
| 256 | 8 | 29.1 | 81.1 | 562.6 | 674.5 | 336.1 | 1.5 |
| 256 | 16 | 40.4 | 87.6 | 934.3 | 664.0 | 404.6 | 2.1 |
| 1024 | 1 | 3.0 | 37.8 | 191.4 | 740.4 | 393.7 | 0.5 |
| 1024 | 4 | 12.5 | 92.7 | 642.8 | 719.6 | 444.4 | 1.2 |
| 1024 | 8 | 43.0 | 94.1 | 714.4 | 710.3 | 455.4 | 1.5 |
| 1024 | 16 | 59.3 | 110.5 | 1,364.3 | 680.9 | 453.4 | 1.9 |
| 4096 | 1 | 7.2 | 40.1 | 140.2 | 997.5 | 580.8 | 0.7 |
| 4096 | 4 | 41.5 | 107.1 | 867.9 | 897.3 | 696.4 | 0.9 |
| 4096 | 8 | 60.3 | 140.9 | 1,099.4 | 848.8 | 965.2 | 1.2 |
| 4096 | 16 | 79.8 | 193.1 | 1,681.5 | 985.5 | 795.3 | 2.4 |
| 16384 | 1 | 35.8 | 36.8 | 95.5 | 2,015.6 | 1,977.9 | 0.6 |
| 16384 | 4 | 68.3 | 106.5 | 1,984.0 | 2,076.9 | 1,540.8 | 1.6 |
| 16384 | 8 | 93.7 | 259.0 | 2,015.2 | 2,048.9 | 1,958.8 | 3.0 |
| 16384 | 16 | 248.5 | 254.6 | 5,977.7 | 2,577.1 | 2,396.9 | 4.7 |

## Continuous scenario (thesis continuous table)

| Transport | Conc | Throughput | p95 ms | p95 inter-arrival | Jitter |
|---|---|---|---|---|---|
| batched-unary | 4 | 1,050.76 | 376.15 | 0.00 | 13.30 |
| batched-unary | 8 | 976.29 | 759.42 | 0.00 | 19.42 |
| client-streaming | 4 | 975.41 | 7.80 | 1.60 | 0.68 |
| client-streaming | 8 | 977.28 | 5.95 | 1.67 | 0.71 |
| kafka | 4 | 972.13 | 355.37 | 0.01 | 8.18 |
| kafka | 8 | 975.11 | 377.50 | 0.02 | 8.17 |
| nats-jetstream | 4 | 994.95 | 30.77 | 2.13 | 1.00 |
| nats-jetstream | 8 | 984.83 | 39.57 | 2.17 | 1.06 |
| rabbitmq-streams | 4 | 999.97 | 31.43 | 2.85 | 1.27 |
| rabbitmq-streams | 8 | 1,054.28 | 44.94 | 2.77 | 1.73 |
| unary | 4 | 975.72 | 0.79 | 2.07 | 1.15 |
| unary | 8 | 974.03 | 1.00 | 2.10 | 1.01 |

## Backpressure scenario (thesis backpressure table)

| Transport | Throughput | Median ms | p95 ms | p95 inter-arrival | Jitter | Duplicates |
|---|---|---|---|---|---|---|
| batched-unary | 3,444.25 | 115.80 | 217.62 | 1.59 | 0.57 | 0.00 |
| client-streaming | 3,363.09 | 1,476.52 | 1,933.46 | 2.16 | 0.71 | 0.00 |
| kafka | 1,347.23 | 3,453.50 | 10,472.11 | 2.30 | 0.96 | 84.50 |
| nats-jetstream | 3,039.57 | 1,796.86 | 3,142.22 | 2.16 | 0.66 | 0.00 |
| rabbitmq-streams | 3,004.51 | 1,864.02 | 2,572.95 | 2.17 | 0.71 | 0.00 |
| unary | 2,270.75 | 0.47 | 1.06 | 3.18 | 1.07 | 0.00 |

## Recovery scenario (thesis recovery table)

| Transport | Pre msg/s | Recovery msg/s | Post msg/s | First post-fail ms | Sustained 80%/5s ms | Debt | Recovery p95 ms | Post-fail dup | Post-fail order | Backlog drain ms | Done fraction |
|---|---|---|---|---|---|---|---|---|---|---|---|
| batched-unary | 2,054 | 1,840 | 1,831 | 2,040.29 | 1,500 | 3,550 | 396.51 | 0 | 0.0 | 24,115.67 | 1.00 |
| client-streaming | 2,687 | 653 | 2,009 | 0.88 | 8,500 | 13,474 | 1.28 | 10,462 | 0.0 | 27,769.05 | 1.00 |
| kafka | 2,359 | 0 | 1,965 | 30,840.90 | -- | 20,000 | -- | 98 | 0.0 | 32,377.34 | 1.00 |
| nats-jetstream | 2,154 | 1,918 | 216 | 186.78 | 5,000 | 2,753 | 701.81 | 0 | 8.0 | 123,704.74 | 1.00 |
| rabbitmq-streams | 1,988 | 1,610 | 2,057 | 324.40 | 5,500 | 4,186 | 2,943.19 | 910 | 0.0 | 24,242.62 | 1.00 |
| unary | 2,190 | 1,641 | 1,901 | 2,013.24 | 7,000 | 5,634 | 4.69 | 0 | 0.0 | 24,558.62 | 1.00 |

# RQ3 aggregated results

| Implementation | Archetype | Providers | Rows/provider | Valid reps | Mean done s | Min | Max | Mean first-result s | Mean post-first s | Mean partial chunks |
|---|---|---|---|---|---|---|---|---|---|---|
| classic-unary | computeToData | UVA,VU | 50000 | 20 | 9.622 | 7.722 | 12.331 | 9.622 | 0.000 | 0.0 |
| classic-unary | computeToData | UVA,VU | 250000 | 20 | 16.620 | 14.234 | 18.854 | 16.620 | 0.000 | 0.0 |
| classic-unary | dataThroughTtp | UVA | 50000 | 20 | 13.988 | 11.264 | 24.259 | 13.988 | 0.000 | 0.0 |
| classic-unary | dataThroughTtp | UVA | 100000 | 20 | 19.343 | 13.363 | 40.944 | 19.343 | 0.000 | 0.0 |
| classic-unary | dataThroughTtp | UVA | 250000 | 20 | 29.078 | 21.901 | 50.854 | 29.078 | 0.000 | 0.0 |
| classic-unary | dataThroughTtp | UVA,VU | 50000 | 20 | 13.750 | 10.912 | 25.307 | 13.750 | 0.000 | 0.0 |
| classic-unary | dataThroughTtp | UVA,VU | 250000 | 20 | 35.396 | 29.568 | 44.657 | 35.396 | 0.000 | 0.0 |
| rabbitmq-streams | computeToData | UVA,VU | 50000 | 20 | 4.586 | 4.190 | 5.298 | 3.044 | 1.542 | 18.0 |
| rabbitmq-streams | computeToData | UVA,VU | 250000 | 20 | 10.289 | 9.127 | 14.626 | 3.255 | 7.034 | 98.0 |
| rabbitmq-streams | dataThroughTtp | UVA | 50000 | 20 | 5.948 | 3.610 | 8.826 | 5.184 | 0.763 | 9.0 |
| rabbitmq-streams | dataThroughTtp | UVA | 100000 | 20 | 7.727 | 4.993 | 12.176 | 5.416 | 2.311 | 19.0 |
| rabbitmq-streams | dataThroughTtp | UVA | 250000 | 20 | 14.066 | 9.968 | 26.520 | 5.613 | 8.453 | 49.0 |
| rabbitmq-streams | dataThroughTtp | UVA,VU | 50000 | 20 | 6.492 | 4.668 | 9.402 | 4.628 | 1.864 | 19.0 |
| rabbitmq-streams | dataThroughTtp | UVA,VU | 250000 | 20 | 15.618 | 11.288 | 29.524 | 4.254 | 11.364 | 99.0 |
| streaming | computeToData | UVA,VU | 50000 | 20 | 4.528 | 3.146 | 19.306 | 3.406 | 1.123 | 18.0 |
| streaming | computeToData | UVA,VU | 250000 | 20 | 7.989 | 6.374 | 10.609 | 3.089 | 4.900 | 98.0 |
| streaming | dataThroughTtp | UVA | 50000 | 20 | 6.346 | 3.176 | 14.492 | 5.574 | 0.772 | 9.0 |
| streaming | dataThroughTtp | UVA | 100000 | 20 | 8.255 | 3.911 | 17.985 | 6.250 | 2.005 | 19.0 |
| streaming | dataThroughTtp | UVA | 250000 | 20 | 12.319 | 7.490 | 23.311 | 6.017 | 6.302 | 49.0 |
| streaming | dataThroughTtp | UVA,VU | 50000 | 20 | 4.474 | 3.512 | 6.109 | 3.861 | 0.613 | 19.0 |
| streaming | dataThroughTtp | UVA,VU | 250000 | 20 | 11.165 | 8.373 | 25.003 | 3.777 | 7.388 | 99.0 |
| unary | computeToData | UVA,VU | 50000 | 20 | 5.178 | 4.000 | 7.525 | 3.352 | 1.826 | 18.0 |
| unary | computeToData | UVA,VU | 250000 | 20 | 9.182 | 8.063 | 10.597 | 3.110 | 6.071 | 98.0 |
| unary | dataThroughTtp | UVA | 50000 | 20 | 6.536 | 3.531 | 12.017 | 5.778 | 0.758 | 9.0 |
| unary | dataThroughTtp | UVA | 100000 | 20 | 6.754 | 4.488 | 8.895 | 4.977 | 1.777 | 19.0 |
| unary | dataThroughTtp | UVA | 250000 | 20 | 11.684 | 7.544 | 23.233 | 5.145 | 6.539 | 49.0 |
| unary | dataThroughTtp | UVA,VU | 50000 | 20 | 5.196 | 4.117 | 8.228 | 3.971 | 1.224 | 19.0 |
| unary | dataThroughTtp | UVA,VU | 250000 | 20 | 12.032 | 9.723 | 14.842 | 3.812 | 8.221 | 99.0 |

