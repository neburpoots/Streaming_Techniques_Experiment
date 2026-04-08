param(
    [string]$ResultsDir = (Join-Path $PSScriptRoot '..\results'),
    [string]$RunIdPrefix = '',
    [string]$OutputPath = ''
)

$ErrorActionPreference = 'Stop'
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
[System.Threading.Thread]::CurrentThread.CurrentUICulture = [System.Globalization.CultureInfo]::InvariantCulture

$resolvedResultsDir = [System.IO.Path]::GetFullPath($ResultsDir)
if (-not (Test-Path $resolvedResultsDir)) {
    throw "Results directory not found: $resolvedResultsDir"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $fileName = if ([string]::IsNullOrWhiteSpace($RunIdPrefix)) { 'summary.csv' } else { "$RunIdPrefix-summary.csv" }
    $OutputPath = Join-Path $resolvedResultsDir $fileName
}

$rows = Get-ChildItem -Path $resolvedResultsDir -Filter '*-producer-result.json' |
    ForEach-Object {
        $data = Get-Content -Raw $_.FullName | ConvertFrom-Json
        if (-not [string]::IsNullOrWhiteSpace($RunIdPrefix) -and -not $data.run_id.StartsWith($RunIdPrefix)) {
            return
        }

        [PSCustomObject]@{
            run_id = $data.run_id
            transport_mode = $data.transport_mode
            workload_source = $data.workload_source
            workload_descriptor = $data.workload_descriptor
            profile = $data.profile
            expected_messages = $data.expected_messages
            payload_bytes = $data.payload_bytes
            concurrency = $data.concurrency
            target_messages_per_second = $data.target_messages_per_second
            unary_acknowledged_requests = $data.unary_acknowledged_requests
            throughput_messages_per_second = $data.sink_summary.throughput_messages_per_second
            throughput_megabytes_per_second = $data.sink_summary.throughput_megabytes_per_second
            duration_seconds = $data.sink_summary.duration_seconds
            p50_latency_ms = $data.sink_summary.p50_latency_ms
            p95_latency_ms = $data.sink_summary.p95_latency_ms
            p99_latency_ms = $data.sink_summary.p99_latency_ms
            max_latency_ms = $data.sink_summary.max_latency_ms
            messages_received = $data.sink_summary.messages_received
            bytes_received = $data.sink_summary.bytes_received
            duplicates = $data.sink_summary.duplicates
            ordering_violations = $data.sink_summary.ordering_violations
        }
    } |
    Where-Object { $_ -ne $null } |
    Sort-Object transport_mode, workload_source, payload_bytes, concurrency, run_id

if (-not $rows) {
    throw 'No matching producer result files were found to export.'
}

$rows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding utf8
Write-Host "Wrote result summary to $OutputPath"
