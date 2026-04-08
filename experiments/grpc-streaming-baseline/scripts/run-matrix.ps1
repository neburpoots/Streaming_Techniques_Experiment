param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('synthetic-clean', 'csv-replay-check')]
    [string]$Preset,

    [string]$RootPath = (Join-Path $PSScriptRoot '..'),
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'

$resolvedRoot = [System.IO.Path]::GetFullPath($RootPath)
$resultsDir = Join-Path $resolvedRoot 'results'
$exportScript = Join-Path $PSScriptRoot 'export-results.ps1'

function Get-MatrixCases {
    param([string]$PresetName)

    switch ($PresetName) {
        'synthetic-clean' {
            $cases = @()
            foreach ($transportMode in @('client-streaming', 'unary')) {
                foreach ($payloadBytes in @(256, 1024, 4096, 16384)) {
                    foreach ($concurrency in @(1, 4, 8, 16)) {
                        $transportShort = if ($transportMode -eq 'client-streaming') { 'stream' } else { 'unary' }
                        $cases += [PSCustomObject]@{
                            run_id = "synthetic-clean-$transportShort-p$payloadBytes-c$concurrency"
                            transport_mode = $transportMode
                            workload_source = 'synthetic'
                            profile = 'bulk'
                            total_messages = '20000'
                            payload_bytes = [string]$payloadBytes
                            concurrency = [string]$concurrency
                            target_messages_per_second = '0'
                            transformer_work_iterations = '0'
                            sink_process_delay_ms = '0'
                            summary_poll_milliseconds = '250'
                            max_summary_wait_seconds = '120'
                            dataset_files = ''
                            dataset_rows_per_message = '1'
                            dataset_repeat_count = '1'
                        }
                    }
                }
            }
            return $cases
        }
        'csv-replay-check' {
            $cases = @()
            foreach ($transportMode in @('client-streaming', 'unary')) {
                foreach ($rowsPerMessage in @(25, 100)) {
                    foreach ($concurrency in @(1, 8)) {
                        $transportShort = if ($transportMode -eq 'client-streaming') { 'stream' } else { 'unary' }
                        $cases += [PSCustomObject]@{
                            run_id = "csv-replay-check-$transportShort-r$rowsPerMessage-c$concurrency"
                            transport_mode = $transportMode
                            workload_source = 'csv-replay'
                            profile = 'bulk'
                            total_messages = '10000'
                            payload_bytes = '1024'
                            concurrency = [string]$concurrency
                            target_messages_per_second = '0'
                            transformer_work_iterations = '0'
                            sink_process_delay_ms = '0'
                            summary_poll_milliseconds = '250'
                            max_summary_wait_seconds = '120'
                            dataset_files = 'Personen.csv,Aanstellingen.csv'
                            dataset_rows_per_message = [string]$rowsPerMessage
                            dataset_repeat_count = '10'
                        }
                    }
                }
            }
            return $cases
        }
    }
}

function Wait-ForHealth {
    for ($i = 0; $i -lt 60; $i++) {
        try {
            Invoke-WebRequest -UseBasicParsing http://localhost:9101/healthz | Out-Null
            Invoke-WebRequest -UseBasicParsing http://localhost:9102/healthz | Out-Null
            return
        } catch {
            Start-Sleep -Seconds 1
        }
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

function Invoke-RunCase {
    param([pscustomobject]$Case)

    docker compose up -d sink transformer | Out-Null
    Wait-ForHealth

    $statsPath = Join-Path $resultsDir "$($Case.run_id)-docker-stats.ndjson"
    $stopFile = Join-Path $resultsDir "$($Case.run_id)-stop.txt"
    if (Test-Path $statsPath) { Remove-Item $statsPath -Force }
    if (Test-Path $stopFile) { Remove-Item $stopFile -Force }

    $job = Start-DockerStatsSampling -OutputPath $statsPath -StopFile $stopFile
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

        Write-Host "Running $($Case.run_id)"
        docker compose run --rm producer
    } finally {
        'stop' | Out-File -FilePath $stopFile -Encoding ascii
        Wait-Job $job | Out-Null
        Remove-Job $job -Force | Out-Null
        Remove-Item $stopFile -Force -ErrorAction SilentlyContinue
        docker compose down | Out-Null
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
& $exportScript -ResultsDir $resultsDir -RunIdPrefix $Preset -OutputPath $outputPath
Write-Host "Finished preset $Preset"
