param(
    [string]$ResultsDir = (Join-Path $PSScriptRoot '..\results'),
    [string]$RunIdPrefix = '',
    [string]$OutputPath = ''
)

$ErrorActionPreference = 'Stop'
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
[System.Threading.Thread]::CurrentThread.CurrentUICulture = [System.Globalization.CultureInfo]::InvariantCulture

function Get-OptionalValue {
    param(
        [object]$Object,
        [string]$PropertyName,
        $DefaultValue = $null
    )

    if ($null -eq $Object) {
        return $DefaultValue
    }

    $property = $Object.PSObject.Properties[$PropertyName]
    if ($null -eq $property) {
        return $DefaultValue
    }

    return $property.Value
}

function ConvertTo-PercentNumber {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    return [double]($Value.Trim().TrimEnd('%'))
}

function ConvertTo-Mebibytes {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $trimmed = $Value.Trim()
    $match = [regex]::Match($trimmed, '^([0-9]+(?:\.[0-9]+)?)\s*([A-Za-z]+)$')
    if (-not $match.Success) {
        return $null
    }

    $numeric = [double]$match.Groups[1].Value
    $unit = $match.Groups[2].Value
    switch ($unit) {
        'B' { return $numeric / 1MB }
        'KiB' { return $numeric / 1024 }
        'MiB' { return $numeric }
        'GiB' { return $numeric * 1024 }
        'TiB' { return $numeric * 1024 * 1024 }
        default { return $null }
    }
}

function Get-ContainerRole {
    param([string]$ContainerName)

    if ([string]::IsNullOrWhiteSpace($ContainerName)) {
        return $null
    }

    if ($ContainerName -like 'grpc-streaming-baseline-producer-run-*' -or $ContainerName -like 'grpc-streaming-baseline-producer-*') {
        return 'producer'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-transformer-*') {
        return 'transformer'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-sink-*') {
        return 'sink'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-rabbitmq-*') {
        return 'rabbitmq'
    }

    return $null
}

function New-ResourceStatSummary {
    return [PSCustomObject]@{
        cpu_values = New-Object System.Collections.Generic.List[double]
        memory_values_mib = New-Object System.Collections.Generic.List[double]
    }
}

function Get-StatsAggregate {
    param([System.Collections.Generic.List[double]]$Values)

    if ($null -eq $Values -or $Values.Count -eq 0) {
        return [PSCustomObject]@{ average = $null; peak = $null; samples = 0 }
    }

    $sum = 0.0
    $peak = $Values[0]
    foreach ($value in $Values) {
        $sum += $value
        if ($value -gt $peak) {
            $peak = $value
        }
    }

    return [PSCustomObject]@{
        average = $sum / $Values.Count
        peak = $peak
        samples = $Values.Count
    }
}

function Get-RunResourceSummary {
    param(
        [string]$ResultsDirectory,
        [string]$RunId
    )

    $statsPath = Join-Path $ResultsDirectory ("$RunId-docker-stats.ndjson")
    if (-not (Test-Path $statsPath)) {
        $statsPath = Join-Path $ResultsDirectory ("$RunId-k8s-stats.ndjson")
    }
    $emptyRoleSummary = [PSCustomObject]@{ cpu_avg_pct = $null; cpu_peak_pct = $null; memory_avg_mib = $null; memory_peak_mib = $null; samples = 0 }
    if (-not (Test-Path $statsPath)) {
        return [PSCustomObject]@{
            producer = $emptyRoleSummary
            transformer = $emptyRoleSummary
            sink = $emptyRoleSummary
            rabbitmq = $emptyRoleSummary
        }
    }

    $byRole = @{
        producer = (New-ResourceStatSummary)
        transformer = (New-ResourceStatSummary)
        sink = (New-ResourceStatSummary)
        rabbitmq = (New-ResourceStatSummary)
    }

    Get-Content $statsPath | ForEach-Object {
        if ([string]::IsNullOrWhiteSpace($_)) {
            return
        }

        $entry = $_ | ConvertFrom-Json
        $role = Get-ContainerRole -ContainerName $entry.Name
        if ($null -eq $role) {
            return
        }

        $cpu = ConvertTo-PercentNumber -Value $entry.CPUPerc
        if ($null -ne $cpu) {
            $byRole[$role].cpu_values.Add($cpu)
        }

        $memoryUsage = [string](($entry.MemUsage -split '/')[0]).Trim()
        $memoryMib = ConvertTo-Mebibytes -Value $memoryUsage
        if ($null -ne $memoryMib) {
            $byRole[$role].memory_values_mib.Add($memoryMib)
        }
    }

    $summary = @{}
    foreach ($role in @('producer', 'transformer', 'sink', 'rabbitmq')) {
        $cpuStats = Get-StatsAggregate -Values $byRole[$role].cpu_values
        $memoryStats = Get-StatsAggregate -Values $byRole[$role].memory_values_mib
        $summary[$role] = [PSCustomObject]@{
            cpu_avg_pct = $cpuStats.average
            cpu_peak_pct = $cpuStats.peak
            memory_avg_mib = $memoryStats.average
            memory_peak_mib = $memoryStats.peak
            samples = [Math]::Max($cpuStats.samples, $memoryStats.samples)
        }
    }

    return [PSCustomObject]@{
        producer = $summary.producer
        transformer = $summary.transformer
        sink = $summary.sink
        rabbitmq = $summary.rabbitmq
    }
}

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

        $resourceSummary = Get-RunResourceSummary -ResultsDirectory $resolvedResultsDir -RunId $data.run_id

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
            transformer_work_iterations = Get-OptionalValue -Object $data -PropertyName 'transformer_work_iterations'
            sink_process_delay_ms = Get-OptionalValue -Object $data -PropertyName 'sink_process_delay_ms'
            max_retry_attempts = Get-OptionalValue -Object $data -PropertyName 'max_retry_attempts' -DefaultValue 0
            retry_backoff_ms = Get-OptionalValue -Object $data -PropertyName 'retry_backoff_ms' -DefaultValue 0
            failure_action = Get-OptionalValue -Object $data -PropertyName 'failure_action' -DefaultValue ''
            failure_target = Get-OptionalValue -Object $data -PropertyName 'failure_target' -DefaultValue ''
            failure_after_seconds = Get-OptionalValue -Object $data -PropertyName 'failure_after_seconds' -DefaultValue 0
            retry_attempts = Get-OptionalValue -Object $data -PropertyName 'retry_attempts' -DefaultValue 0
            stream_reconnects = Get-OptionalValue -Object $data -PropertyName 'stream_reconnects' -DefaultValue 0
            recovery_events = Get-OptionalValue -Object $data -PropertyName 'recovery_events' -DefaultValue 0
            avg_recovery_ms = Get-OptionalValue -Object $data -PropertyName 'avg_recovery_ms' -DefaultValue 0
            max_recovery_ms = Get-OptionalValue -Object $data -PropertyName 'max_recovery_ms' -DefaultValue 0
            unary_acknowledged_requests = $data.unary_acknowledged_requests
            throughput_messages_per_second = $data.sink_summary.throughput_messages_per_second
            throughput_megabytes_per_second = $data.sink_summary.throughput_megabytes_per_second
            duration_seconds = $data.sink_summary.duration_seconds
            p50_latency_ms = $data.sink_summary.p50_latency_ms
            p95_latency_ms = $data.sink_summary.p95_latency_ms
            p99_latency_ms = $data.sink_summary.p99_latency_ms
            max_latency_ms = $data.sink_summary.max_latency_ms
            mean_inter_arrival_ms = Get-OptionalValue -Object $data.sink_summary -PropertyName 'mean_inter_arrival_ms'
            p95_inter_arrival_ms = Get-OptionalValue -Object $data.sink_summary -PropertyName 'p95_inter_arrival_ms'
            inter_arrival_jitter_ms = Get-OptionalValue -Object $data.sink_summary -PropertyName 'inter_arrival_jitter_ms'
            messages_received = $data.sink_summary.messages_received
            bytes_received = $data.sink_summary.bytes_received
            duplicates = Get-OptionalValue -Object $data.sink_summary -PropertyName 'duplicates' -DefaultValue 0
            ordering_violations = Get-OptionalValue -Object $data.sink_summary -PropertyName 'ordering_violations' -DefaultValue 0
            producer_cpu_avg_pct = $resourceSummary.producer.cpu_avg_pct
            producer_cpu_peak_pct = $resourceSummary.producer.cpu_peak_pct
            producer_memory_avg_mib = $resourceSummary.producer.memory_avg_mib
            producer_memory_peak_mib = $resourceSummary.producer.memory_peak_mib
            producer_samples = $resourceSummary.producer.samples
            transformer_cpu_avg_pct = $resourceSummary.transformer.cpu_avg_pct
            transformer_cpu_peak_pct = $resourceSummary.transformer.cpu_peak_pct
            transformer_memory_avg_mib = $resourceSummary.transformer.memory_avg_mib
            transformer_memory_peak_mib = $resourceSummary.transformer.memory_peak_mib
            transformer_samples = $resourceSummary.transformer.samples
            sink_cpu_avg_pct = $resourceSummary.sink.cpu_avg_pct
            sink_cpu_peak_pct = $resourceSummary.sink.cpu_peak_pct
            sink_memory_avg_mib = $resourceSummary.sink.memory_avg_mib
            sink_memory_peak_mib = $resourceSummary.sink.memory_peak_mib
            sink_samples = $resourceSummary.sink.samples
            rabbitmq_cpu_avg_pct = $resourceSummary.rabbitmq.cpu_avg_pct
            rabbitmq_cpu_peak_pct = $resourceSummary.rabbitmq.cpu_peak_pct
            rabbitmq_memory_avg_mib = $resourceSummary.rabbitmq.memory_avg_mib
            rabbitmq_memory_peak_mib = $resourceSummary.rabbitmq.memory_peak_mib
            rabbitmq_samples = $resourceSummary.rabbitmq.samples
        }
    } |
    Where-Object { $_ -ne $null } |
    Sort-Object transport_mode, workload_source, payload_bytes, concurrency, run_id

if (-not $rows) {
    throw 'No matching producer result files were found to export.'
}

$rows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding utf8
Write-Host "Wrote result summary to $OutputPath"
