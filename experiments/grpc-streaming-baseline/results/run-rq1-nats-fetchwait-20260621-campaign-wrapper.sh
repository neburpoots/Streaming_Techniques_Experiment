#!/usr/bin/env bash
set +e

RESULTS="/home/nebur/Streaming_Techniques_Experiment/experiments/grpc-streaming-baseline/results"
SCRIPT="${RESULTS}/run-rq1-nats-fetchwait-20260621.sh"
LOG="${RESULTS}/rq1-nats-fetchwait-20260621-campaign.log"
ERR="${RESULTS}/rq1-nats-fetchwait-20260621-campaign.err.log"
EXIT_FILE="${RESULTS}/rq1-nats-fetchwait-20260621-campaign-exit.txt"

rm -f "${EXIT_FILE}"
bash "${SCRIPT}" > "${LOG}" 2> "${ERR}"
code=$?
printf '%s\n' "${code}" > "${EXIT_FILE}"
exit "${code}"
