# RQ1 combined summary

Every benchmark cell contains 10 repetitions.

| Transport | Mean msg/s | Mean MiB/s | Mean p95 (ms) | Mean p99 (ms) |
|---|---:|---:|---:|---:|
| batched-unary | 49,096.11 | 101.44 | 51.92 | 69.27 |
| client-streaming | 53,164.34 | 102.49 | 107.55 | 133.12 |
| kafka | 11,293.92 | 27.79 | 1,186.93 | 1,323.08 |
| nats-jetstream | 13,336.05 | 38.20 | 1,115.43 | 1,185.77 |
| rabbitmq-streams | 13,648.01 | 31.58 | 873.08 | 912.17 |
| unary | 3,066.43 | 13.09 | 1.60 | 23.64 |
