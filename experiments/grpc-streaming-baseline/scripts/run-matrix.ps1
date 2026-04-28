param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('synthetic-clean', 'csv-replay-check', 'synthetic-continuous', 'synthetic-backpressure', 'synthetic-recovery')]
    [string]$Preset,

    [string]$RootPath = (Join-Path $PSScriptRoot '..'),
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'

$resolvedRoot = [System.IO.Path]::GetFullPath($RootPath)
$resultsDir = Join-Path $resolvedRoot 'results'
$exportScript = Join-Path $PSScriptRoot 'export-results.ps1'

function New-RunCase {
    param(
        [string]$RunId,
        [string]$TransportMode,
        [string]$WorkloadSource,
        [string]$Profile,
        [string]$TotalMessages,
        [string]$PayloadBytes,
        [string]$Concurrency,
        [string]$TargetMessagesPerSecond,
        [string]$TransformerWorkIterations = '0',
        [string]$SinkProcessDelayMs = '0',
        [string]$SummaryPollMilliseconds = '250',
        [string]$MaxSummaryWaitSeconds = '120',
        [string]$DatasetFiles = '',
        [string]$DatasetRowsPerMessage = '1',
        [string]$DatasetRepeatCount = '1',
        [string]$MaxRetryAttempts = '0',
        [string]$RetryBackoffMs = '500',
        [string]$FailureAction = '',
        [string]$FailureTarget = '',
        [string]$FailureAfterSeconds = '0'
    )

    [PSCustomObject]@{
        run_id = $RunId
        transport_mode = $TransportMode
        workload_source = $WorkloadSource
        profile = $Profile
        total_messages = $TotalMessages
        payload_bytes = $PayloadBytes
        concurrency = $Concurrency
        target_messages_per_second = $TargetMessagesPerSecond
        transformer_work_iterations = $TransformerWorkIterations
        sink_process_delay_ms = $SinkProcessDelayMs
        summary_poll_milliseconds = $SummaryPollMilliseconds
        max_summary_wait_seconds = $MaxSummaryWaitSeconds
        dataset_files = $DatasetFiles
        dataset_rows_per_message = $DatasetRowsPerMessage
        dataset_repeat_count = $DatasetRepeatCount
        max_retry_attempts = $MaxRetryAttempts
        retry_backoff_ms = $RetryBackoffMs
        failure_action = $FailureAction
        failure_target = $FailureTarget
        failure_after_seconds = $FailureAfterSeconds
    }
}

function Get-MatrixCases {
    param([string]$PresetName)

    switch ($PresetName) {
        'synthetic-clean' {
            $cases = @()
            foreach ($transportMode in @('client-streaming', 'unary', 'rabbitmq-streams', 'nats-jetstream', 'kafka')) {
                foreach ($payloadBytes in @(256, 1024, 4096, 16384)) {
                    foreach ($concurrency in @(1, 4, 8, 16)) {
                        $transportShort = switch ($transportMode) {
                            'client-streaming' { 'stream' }
                            'unary' { 'unary' }
                            'rabbitmq-streams' { 'rmqs' }
                            'nats-jetstream' { 'nats' }
                            'kafka' { 'kafka' }
                        }
                        $cases += New-RunCase `
                            -RunId "synthetic-clean-$transportShort-p$payloadBytes-c$concurrency" `
                            -TransportMode $transportMode `
                            -WorkloadSource 'synthetic' `
                            -Profile 'bulk' `
                            -TotalMessages '20000' `
                            -PayloadBytes ([string]$payloadBytes) `
                            -Concurrency ([string]$concurrency) `
                            -TargetMessagesPerSecond '0'
                    }
                }
            }
            return $cases
        }
        'csv-replay-check' {
            $cases = @()
            foreach ($transportMode in @('client-streaming', 'unary', 'rabbitmq-streams', 'nats-jetstream', 'kafka')) {
                foreach ($rowsPerMessage in @(25, 100)) {
                    foreach ($concurrency in @(1, 8)) {
                        $transportShort = switch ($transportMode) {
                            'client-streaming' { 'stream' }
                            'unary' { 'unary' }
                            'rabbitmq-streams' { 'rmqs' }
                            'nats-jetstream' { 'nats' }
                            'kafka' { 'kafka' }
                        }
                        $cases += New-RunCase `
                            -RunId "csv-replay-check-$transportShort-r$rowsPerMessage-c$concurrency" `
                            -TransportMode $transportMode `
                            -WorkloadSource 'csv-replay' `
                            -Profile 'bulk' `
                            -TotalMessages '10000' `
                            -PayloadBytes '1024' `
                            -Concurrency ([string]$concurrency) `
                            -TargetMessagesPerSecond '0' `
                            -DatasetFiles 'Personen.csv,Aanstellingen.csv' `
                            -DatasetRowsPerMessage ([string]$rowsPerMessage) `
                            -DatasetRepeatCount '10'
                    }
                }
            }
            return $cases
        }
        'synthetic-continuous' {
            $cases = @()
            foreach ($transportMode in @('client-streaming', 'unary', 'rabbitmq-streams', 'nats-jetstream', 'kafka')) {
                foreach ($concurrency in @(4, 8)) {
                    $transportShort = switch ($transportMode) {
                        'client-streaming' { 'stream' }
                        'unary' { 'unary' }
                        'rabbitmq-streams' { 'rmqs' }
                        'nats-jetstream' { 'nats' }
                        'kafka' { 'kafka' }
                    }
                    $cases += New-RunCase `
                        -RunId "synthetic-continuous-$transportShort-p1024-c$concurrency" `
                        -TransportMode $transportMode `
                        -WorkloadSource 'synthetic' `
                        -Profile 'continuous' `
                        -TotalMessages '20000' `
                        -PayloadBytes '1024' `
                        -Concurrency ([string]$concurrency) `
                        -TargetMessagesPerSecond '1000'
                }
            }
            return $cases
        }
        'synthetic-backpressure' {
            $cases = @()
            foreach ($transportMode in @('client-streaming', 'unary', 'rabbitmq-streams', 'nats-jetstream', 'kafka')) {
                $transportShort = switch ($transportMode) {
                    'client-streaming' { 'stream' }
                    'unary' { 'unary' }
                    'rabbitmq-streams' { 'rmqs' }
                    'nats-jetstream' { 'nats' }
                    'kafka' { 'kafka' }
                }
                $cases += New-RunCase `
                    -RunId "synthetic-backpressure-$transportShort-p1024-c8" `
                    -TransportMode $transportMode `
                    -WorkloadSource 'synthetic' `
                    -Profile 'continuous' `
                    -TotalMessages '20000' `
                    -PayloadBytes '1024' `
                    -Concurrency '8' `
                    -TargetMessagesPerSecond '4000' `
                    -SinkProcessDelayMs '2'
            }
            return $cases
        }
        'synthetic-recovery' {
            $cases = @()
            foreach ($transportMode in @('client-streaming', 'unary', 'rabbitmq-streams', 'nats-jetstream', 'kafka')) {
                $transportShort = switch ($transportMode) {
                    'client-streaming' { 'stream' }
                    'unary' { 'unary' }
                    'rabbitmq-streams' { 'rmqs' }
                    'nats-jetstream' { 'nats' }
                    'kafka' { 'kafka' }
                }
                $cases += New-RunCase `
                    -RunId "synthetic-recovery-$transportShort-p4096-c8" `
                    -TransportMode $transportMode `
                    -WorkloadSource 'synthetic' `
                    -Profile 'continuous' `
                    -TotalMessages '20000' `
                    -PayloadBytes '4096' `
                    -Concurrency '8' `
                    -TargetMessagesPerSecond '2000' `
                    -MaxRetryAttempts '40' `
                    -RetryBackoffMs '250' `
                    -FailureAction 'restart' `
                    -FailureTarget 'transformer' `
                    -FailureAfterSeconds '3'
            }
            return $cases
        }
    }
}

function Wait-ForHealth {
    param([string]$TransportMode = 'client-streaming')

    for ($i = 0; $i -lt 60; $i++) {
        try {
            Invoke-WebRequest -UseBasicParsing http://localhost:9101/healthz | Out-Null
            Invoke-WebRequest -UseBasicParsing http://localhost:9102/healthz | Out-Null
            if ($TransportMode -ne 'rabbitmq-streams') {
                if ($TransportMode -eq 'nats-jetstream') {
                    if (-not (Test-NetConnection -ComputerName localhost -Port 4222 -InformationLevel Quiet)) {
                        throw 'NATS is not accepting connections yet.'
                    }
                }
                elseif ($TransportMode -eq 'kafka') {
                    if (-not (Test-NetConnection -ComputerName localhost -Port 9092 -InformationLevel Quiet)) {
                        throw 'Kafka is not accepting connections yet.'
                    }
                }
                return
            }
            docker compose exec -T rabbitmq rabbitmq-diagnostics -q ping | Out-Null
            return
        } catch {
            Start-Sleep -Seconds 1
        }
    }
    if ($TransportMode -eq 'rabbitmq-streams') {
        throw 'Timed out waiting for transformer, sink, and RabbitMQ health endpoints.'
    }
    throw 'Timed out waiting for transformer and sink health endpoints.'
}

function Start-DockerStatsSampling {
    param(
        [string]$OutputPath,
        [string]$StopFile
    )

    Start-Job -ScriptBlock {
        param($StatsOutputPath, $StatsStopFile)
        while (-not (Test-Path $StatsStopFile)) {
            docker stats --no-stream --format '{{json .}}' | Out-File -FilePath $StatsOutputPath -Append -Encoding ascii
            Start-Sleep -Seconds 1
        }
    } -ArgumentList $OutputPath, $StopFile
}

function Start-FailureInjection {
    param(
        [pscustomobject]$Case,
        [string]$ComposeRoot
    )

    if ([string]::IsNullOrWhiteSpace($Case.failure_action) -or [string]::IsNullOrWhiteSpace($Case.failure_target)) {
        return $null
    }

    $delaySeconds = [int]$Case.failure_after_seconds
    if ($delaySeconds -le 0) {
        return $null
    }

    Start-Job -ScriptBlock {
        param($Action, $Target, $DelaySeconds, $ProjectRoot)
        Start-Sleep -Seconds $DelaySeconds
        switch ($Action) {
            'restart' {
                docker compose -f (Join-Path $ProjectRoot 'docker-compose.yml') restart $Target | Out-Null
            }
            default {
                throw "Unsupported failure action: $Action"
            }
        }
    } -ArgumentList $Case.failure_action, $Case.failure_target, $delaySeconds, $ComposeRoot
}

function Invoke-RunCase {
    param([pscustomobject]$Case)

    $statsPath = Join-Path $resultsDir "$($Case.run_id)-docker-stats.ndjson"
    $stopFile = Join-Path $resultsDir "$($Case.run_id)-stop.txt"
    if (Test-Path $statsPath) { Remove-Item $statsPath -Force }
    if (Test-Path $stopFile) { Remove-Item $stopFile -Force }

    try {
        $env:RUN_ID = $Case.run_id
        $env:TRANSPORT_MODE = $Case.transport_mode
        $env:WORKLOAD_SOURCE = $Case.workload_source
        $env:PROFILE = $Case.profile
        $env:TOTAL_MESSAGES = $Case.total_messages
        $env:PAYLOAD_BYTES = $Case.payload_bytes
        $env:CONCURRENCY = $Case.concurrency
        $env:TARGET_MESSAGES_PER_SECOND = $Case.target_messages_per_second
        $env:TRANSFORMER_WORK_ITERATIONS = $Case.transformer_work_iterations
        $env:SINK_PROCESS_DELAY_MS = $Case.sink_process_delay_ms
        $env:SUMMARY_POLL_MILLISECONDS = $Case.summary_poll_milliseconds
        $env:MAX_SUMMARY_WAIT_SECONDS = $Case.max_summary_wait_seconds
        $env:DATASET_FILES = $Case.dataset_files
        $env:DATASET_ROWS_PER_MESSAGE = $Case.dataset_rows_per_message
        $env:DATASET_REPEAT_COUNT = $Case.dataset_repeat_count
        $env:MAX_RETRY_ATTEMPTS = $Case.max_retry_attempts
        $env:RETRY_BACKOFF_MS = $Case.retry_backoff_ms
        $env:FAILURE_ACTION = $Case.failure_action
        $env:FAILURE_TARGET = $Case.failure_target
        $env:FAILURE_AFTER_SECONDS = $Case.failure_after_seconds

        docker compose up -d sink transformer rabbitmq | Out-Null
        Wait-ForHealth -TransportMode $Case.transport_mode

        $statsJob = Start-DockerStatsSampling -OutputPath $statsPath -StopFile $stopFile
        $failureJob = Start-FailureInjection -Case $Case -ComposeRoot $resolvedRoot

        Write-Host "Running $($Case.run_id)"
        docker compose run --rm producer
    } finally {
        'stop' | Out-File -FilePath $stopFile -Encoding ascii
        if ($statsJob) {
            Wait-Job $statsJob | Out-Null
            Remove-Job $statsJob -Force | Out-Null
        }
        Remove-Item $stopFile -Force -ErrorAction SilentlyContinue
        if ($failureJob) {
            Wait-Job $failureJob | Out-Null
            Remove-Job $failureJob -Force | Out-Null
        }
        docker compose down -v | Out-Null
    }
}

Set-Location $resolvedRoot
if (-not $SkipBuild) {
    docker compose build sink transformer producer
}

$matrixCases = Get-MatrixCases -PresetName $Preset
foreach ($case in $matrixCases) {
    Invoke-RunCase -Case $case
}

$outputPath = Join-Path $resultsDir "$Preset-summary.csv"
& $exportScript -ResultsDir $resultsDir -RunIdPrefix $Preset -OutputPath $OutputPath
Write-Host "Finished preset $Preset"
