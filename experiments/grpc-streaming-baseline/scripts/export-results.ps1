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

function Get-SinkAnalysis {
    param(
        [string]$ResultsDirectory,
        [string]$RunId
    )

    $analysisPath = Join-Path $ResultsDirectory ("$RunId-sink-analysis.json")
    if (-not (Test-Path $analysisPath)) {
        return $null
    }

    return Get-Content -Raw $analysisPath | ConvertFrom-Json
}

function Get-PercentileValue {
    param(
        [double[]]$Values,
        [double]$Percentile
    )

    if ($null -eq $Values -or $Values.Count -eq 0) {
        return $null
    }

    $sorted = @($Values | Sort-Object)
    $index = [int][Math]::Ceiling($Percentile * $sorted.Count) - 1
    if ($index -lt 0) {
        $index = 0
    }
    if ($index -ge $sorted.Count) {
        $index = $sorted.Count - 1
    }

    return [double]$sorted[$index]
}

function Get-RecoveryMetrics {
    param(
        [object]$ProducerResult,
        [object]$SinkSummary,
        [object]$SinkAnalysis
    )

    $expectedMessages = [double](Get-OptionalValue -Object $ProducerResult -PropertyName 'expected_messages' -DefaultValue 0)
    $messagesReceived = [double](Get-OptionalValue -Object $SinkSummary -PropertyName 'messages_received' -DefaultValue 0)
    $duplicates = [double](Get-OptionalValue -Object $SinkSummary -PropertyName 'duplicates' -DefaultValue 0)
    $targetMessagesPerSecond = [double](Get-OptionalValue -Object $ProducerResult -PropertyName 'target_messages_per_second' -DefaultValue 0)
    $failureAfterSeconds = [double](Get-OptionalValue -Object $ProducerResult -PropertyName 'failure_after_seconds' -DefaultValue 0)

    $completionRatio = $null
    $duplicateRatio = $null
    if ($expectedMessages -gt 0) {
        $completionRatio = $messagesReceived / $expectedMessages
        $duplicateRatio = $duplicates / $expectedMessages
    }

    $lostMessages = 0
    if ($expectedMessages -gt $messagesReceived) {
        $lostMessages = [uint64]($expectedMessages - $messagesReceived)
    }

    $defaults = [ordered]@{
        completion_ratio = $completionRatio
        lost_messages = $lostMessages
        duplicate_ratio = $duplicateRatio
        estimated_failure_at_unix_nano = $null
        time_to_first_post_failure_message_ms = $null
        e2e_recovery_ms = $null
        sustained_target_recovered = $null
        backlog_drain_ms = $null
        recovery_window_p95_latency_ms = $null
        throughput_debt_messages = $null
        post_failure_duplicates = 0
        post_failure_duplicate_ratio = $null
    }

    if ($null -eq $SinkAnalysis) {
        return [PSCustomObject]$defaults
    }

    $registeredAtUnixNano = [Int64](Get-OptionalValue -Object $SinkAnalysis -PropertyName 'registered_at_unix_nano' -DefaultValue 0)
    $finishedAtUnixNano = [Int64](Get-OptionalValue -Object $SinkAnalysis -PropertyName 'finished_at_unix_nano' -DefaultValue 0)

    if ($registeredAtUnixNano -le 0 -or $failureAfterSeconds -le 0) {
        return [PSCustomObject]$defaults
    }

    $estimatedFailureAtUnixNano = $registeredAtUnixNano + [Int64]($failureAfterSeconds * 1000000000)
    $defaults['estimated_failure_at_unix_nano'] = $estimatedFailureAtUnixNano

    $uniqueEvents = @($SinkAnalysis.unique_events)
    $duplicateArrivalUnixNanos = @($SinkAnalysis.duplicate_arrival_unix_nanos)

    $postFailureDuplicateCount = 0
    foreach ($arrivalUnixNano in $duplicateArrivalUnixNanos) {
        if ([Int64]$arrivalUnixNano -ge $estimatedFailureAtUnixNano) {
            $postFailureDuplicateCount++
        }
    }
    $defaults['post_failure_duplicates'] = $postFailureDuplicateCount
    if ($expectedMessages -gt 0) {
        $defaults['post_failure_duplicate_ratio'] = $postFailureDuplicateCount / $expectedMessages
    }

    $postFailureEvents = @()
    $firstPostFailureMessageAtUnixNano = $null
    foreach ($event in $uniqueEvents) {
        $arrivalAtUnixNano = [Int64](Get-OptionalValue -Object $event -PropertyName 'arrival_at_unix_nano' -DefaultValue 0)
        if ($arrivalAtUnixNano -lt $estimatedFailureAtUnixNano) {
            continue
        }
        if ($null -eq $firstPostFailureMessageAtUnixNano) {
            $firstPostFailureMessageAtUnixNano = $arrivalAtUnixNano
        }
        $postFailureEvents += $event
    }

    if ($null -ne $firstPostFailureMessageAtUnixNano) {
        $defaults['time_to_first_post_failure_message_ms'] = ($firstPostFailureMessageAtUnixNano - $estimatedFailureAtUnixNano) / 1e6
    }

    if ($finishedAtUnixNano -ge $estimatedFailureAtUnixNano) {
        $defaults['backlog_drain_ms'] = ($finishedAtUnixNano - $estimatedFailureAtUnixNano) / 1e6
    }

    if ($targetMessagesPerSecond -le 0 -or $postFailureEvents.Count -eq 0) {
        return [PSCustomObject]$defaults
    }

    $thresholdMessagesPerSecond = 0.9 * $targetMessagesPerSecond
    $defaults['sustained_target_recovered'] = $false
    $windowCounts = @{}
    foreach ($event in $postFailureEvents) {
        $arrivalAtUnixNano = [Int64](Get-OptionalValue -Object $event -PropertyName 'arrival_at_unix_nano' -DefaultValue 0)
        $windowIndex = [int][Math]::Floor(($arrivalAtUnixNano - $estimatedFailureAtUnixNano) / 1e9)
        if ($windowIndex -lt 0) {
            $windowIndex = 0
        }
        if ($windowCounts.ContainsKey($windowIndex)) {
            $windowCounts[$windowIndex] += 1
        }
        else {
            $windowCounts[$windowIndex] = 1
        }
    }

    $maxWindowIndex = [int][Math]::Floor(($finishedAtUnixNano - $estimatedFailureAtUnixNano) / 1e9)
    $recoveryWindowIndex = $null
    for ($windowIndex = 0; $windowIndex -le ($maxWindowIndex - 2); $windowIndex++) {
        $count0 = if ($windowCounts.ContainsKey($windowIndex)) { [double]$windowCounts[$windowIndex] } else { 0.0 }
        $count1 = if ($windowCounts.ContainsKey($windowIndex + 1)) { [double]$windowCounts[$windowIndex + 1] } else { 0.0 }
        $count2 = if ($windowCounts.ContainsKey($windowIndex + 2)) { [double]$windowCounts[$windowIndex + 2] } else { 0.0 }
        if ($count0 -ge $thresholdMessagesPerSecond -and $count1 -ge $thresholdMessagesPerSecond -and $count2 -ge $thresholdMessagesPerSecond) {
            $recoveryWindowIndex = $windowIndex
            break
        }
    }

    $recoveryWindowEndUnixNano = $finishedAtUnixNano
    if ($null -ne $recoveryWindowIndex) {
        $defaults['e2e_recovery_ms'] = 1000.0 * $recoveryWindowIndex
        $defaults['sustained_target_recovered'] = $true
        $recoveryWindowEndUnixNano = $estimatedFailureAtUnixNano + [Int64]($recoveryWindowIndex * 1000000000)
    }
    elseif ($null -ne $defaults['backlog_drain_ms']) {
        $defaults['e2e_recovery_ms'] = $defaults['backlog_drain_ms']
    }

    if ($recoveryWindowEndUnixNano -eq $estimatedFailureAtUnixNano) {
        $defaults['throughput_debt_messages'] = 0.0
    }

    if ($recoveryWindowEndUnixNano -gt $estimatedFailureAtUnixNano) {
        $throughputDebtMessages = 0.0
        $windowCount = [int][Math]::Ceiling(($recoveryWindowEndUnixNano - $estimatedFailureAtUnixNano) / 1e9)
        for ($windowIndex = 0; $windowIndex -lt $windowCount; $windowIndex++) {
            $windowStartUnixNano = $estimatedFailureAtUnixNano + [Int64]($windowIndex * 1000000000)
            $windowEndUnixNano = $windowStartUnixNano + 1000000000
            if ($windowEndUnixNano -gt $recoveryWindowEndUnixNano) {
                $windowEndUnixNano = $recoveryWindowEndUnixNano
            }

            $actualMessages = 0.0
            foreach ($event in $postFailureEvents) {
                $arrivalAtUnixNano = [Int64](Get-OptionalValue -Object $event -PropertyName 'arrival_at_unix_nano' -DefaultValue 0)
                if ($arrivalAtUnixNano -lt $windowStartUnixNano -or $arrivalAtUnixNano -ge $windowEndUnixNano) {
                    continue
                }
                $actualMessages += 1.0
            }

            $windowSeconds = ($windowEndUnixNano - $windowStartUnixNano) / 1e9
            $expectedWindowMessages = $targetMessagesPerSecond * $windowSeconds
            if ($expectedWindowMessages -gt $actualMessages) {
                $throughputDebtMessages += ($expectedWindowMessages - $actualMessages)
            }
        }
        $defaults['throughput_debt_messages'] = $throughputDebtMessages
    }

    $recoveryWindowLatencies = @()
    foreach ($event in $postFailureEvents) {
        $arrivalAtUnixNano = [Int64](Get-OptionalValue -Object $event -PropertyName 'arrival_at_unix_nano' -DefaultValue 0)
        if ($arrivalAtUnixNano -ge $recoveryWindowEndUnixNano) {
            continue
        }
        $recoveryWindowLatencies += [double](Get-OptionalValue -Object $event -PropertyName 'latency_ms' -DefaultValue 0)
    }
    if ($recoveryWindowLatencies.Count -gt 0) {
        $defaults['recovery_window_p95_latency_ms'] = Get-PercentileValue -Values ([double[]]$recoveryWindowLatencies) -Percentile 0.95
    }

    return [PSCustomObject]$defaults
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
    if ($ContainerName -like 'grpc-streaming-baseline-nats-*') {
        return 'nats'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-kafka-*') {
        return 'kafka'
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
            nats = $emptyRoleSummary
            kafka = $emptyRoleSummary
        }
    }

    $byRole = @{
        producer = (New-ResourceStatSummary)
        transformer = (New-ResourceStatSummary)
        sink = (New-ResourceStatSummary)
        rabbitmq = (New-ResourceStatSummary)
        nats = (New-ResourceStatSummary)
        kafka = (New-ResourceStatSummary)
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
    foreach ($role in @('producer', 'transformer', 'sink', 'rabbitmq', 'nats', 'kafka')) {
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
        nats = $summary.nats
        kafka = $summary.kafka
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
        $sinkAnalysis = Get-SinkAnalysis -ResultsDirectory $resolvedResultsDir -RunId $data.run_id
        $recoveryMetrics = Get-RecoveryMetrics -ProducerResult $data -SinkSummary $data.sink_summary -SinkAnalysis $sinkAnalysis

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
            producer_retry_attempts = Get-OptionalValue -Object $data -PropertyName 'retry_attempts' -DefaultValue 0
            producer_stream_reconnects = Get-OptionalValue -Object $data -PropertyName 'stream_reconnects' -DefaultValue 0
            producer_recovery_events = Get-OptionalValue -Object $data -PropertyName 'recovery_events' -DefaultValue 0
            producer_avg_recovery_ms = Get-OptionalValue -Object $data -PropertyName 'avg_recovery_ms' -DefaultValue 0
            producer_max_recovery_ms = Get-OptionalValue -Object $data -PropertyName 'max_recovery_ms' -DefaultValue 0
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
            completion_ratio = $recoveryMetrics.completion_ratio
            lost_messages = $recoveryMetrics.lost_messages
            duplicate_ratio = $recoveryMetrics.duplicate_ratio
            estimated_failure_at_unix_nano = $recoveryMetrics.estimated_failure_at_unix_nano
            time_to_first_post_failure_message_ms = $recoveryMetrics.time_to_first_post_failure_message_ms
            e2e_recovery_ms = $recoveryMetrics.e2e_recovery_ms
            sustained_target_recovered = $recoveryMetrics.sustained_target_recovered
            backlog_drain_ms = $recoveryMetrics.backlog_drain_ms
            recovery_window_p95_latency_ms = $recoveryMetrics.recovery_window_p95_latency_ms
            throughput_debt_messages = $recoveryMetrics.throughput_debt_messages
            post_failure_duplicates = $recoveryMetrics.post_failure_duplicates
            post_failure_duplicate_ratio = $recoveryMetrics.post_failure_duplicate_ratio
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
            nats_cpu_avg_pct = $resourceSummary.nats.cpu_avg_pct
            nats_cpu_peak_pct = $resourceSummary.nats.cpu_peak_pct
            nats_memory_avg_mib = $resourceSummary.nats.memory_avg_mib
            nats_memory_peak_mib = $resourceSummary.nats.memory_peak_mib
            nats_samples = $resourceSummary.nats.samples
            kafka_cpu_avg_pct = $resourceSummary.kafka.cpu_avg_pct
            kafka_cpu_peak_pct = $resourceSummary.kafka.cpu_peak_pct
            kafka_memory_avg_mib = $resourceSummary.kafka.memory_avg_mib
            kafka_memory_peak_mib = $resourceSummary.kafka.memory_peak_mib
            kafka_samples = $resourceSummary.kafka.samples
        }
    } |
    Where-Object { $_ -ne $null } |
    Sort-Object transport_mode, workload_source, payload_bytes, concurrency, run_id

if (-not $rows) {
    throw 'No matching producer result files were found to export.'
}

$rows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding utf8
Write-Host "Wrote result summary to $OutputPath"
