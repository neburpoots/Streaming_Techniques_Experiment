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

function Get-JsonArrayValue {
    param(
        [object]$Object,
        [string]$PropertyName
    )

    $value = Get-OptionalValue -Object $Object -PropertyName $PropertyName
    if ($null -eq $value) {
        return @()
    }

    return @($value | Where-Object { $null -ne $_ })
}

# Recovery metric definitions
# ----------------------------
# The recovery scenario injects a transformer restart at $failureAfterSeconds.
# We split the run into three phases against that failure timestamp t_f:
#   pre_failure          : [t_start, t_f)
#   recovery_window      : [t_f, t_f + RECOVERY_WINDOW_SECONDS)
#   post_recovery        : [t_f + RECOVERY_WINDOW_SECONDS, t_end]
#
# RECOVERY_WINDOW_SECONDS is fixed at 10 s so that recovery-window throughput,
# debt, and p95 latency are comparable across transports regardless of when
# (or whether) any individual transport reaches the sustained-target threshold.
#
# time_to_sustained_target_ms uses complete 1 s buckets and reports the
# smallest start offset where five consecutive buckets each have a count in
# [SUSTAINED_TARGET_FRACTION * target, SUSTAINED_TARGET_BURST_CAP * target].
# Candidate windows that begin inside the fixed recovery window must also stay
# above the lower bound through the end of that recovery window. This prevents
# an early broker replay plateau from being classified as steady recovery when
# it falls off before the recovery window is over. If the condition is never
# met within the run, the field is null and sustained_target_within_run is
# $false. Critically, this does *not* fall back to backlog_drain_ms; "not
# reached" is reported as such so the reader can distinguish a transport that
# recovered slowly from one that never recovered.
$Script:RECOVERY_WINDOW_SECONDS = 10
$Script:SUSTAINED_TARGET_FRACTION = 0.8
$Script:SUSTAINED_TARGET_BURST_CAP = 2.0
$Script:SUSTAINED_TARGET_BUCKETS = 5

function Get-PhaseThroughput {
    param(
        [object[]]$UniqueEvents,
        [Int64]$PhaseStartUnixNano,
        [Int64]$PhaseEndUnixNano
    )

    if ($PhaseEndUnixNano -le $PhaseStartUnixNano -or $null -eq $UniqueEvents) {
        return $null
    }

    $count = 0
    foreach ($event in $UniqueEvents) {
        $arrival = [Int64](Get-OptionalValue -Object $event -PropertyName 'arrival_at_unix_nano' -DefaultValue 0)
        if ($arrival -ge $PhaseStartUnixNano -and $arrival -lt $PhaseEndUnixNano) {
            $count++
        }
    }

    $seconds = ($PhaseEndUnixNano - $PhaseStartUnixNano) / 1e9
    if ($seconds -le 0) {
        return $null
    }
    return [double]$count / $seconds
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
    $orderingViolations = [double](Get-OptionalValue -Object $SinkSummary -PropertyName 'ordering_violations' -DefaultValue 0)
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
        pre_failure_throughput_msg_s = $null
        recovery_window_throughput_msg_s = $null
        post_recovery_throughput_msg_s = $null
        time_to_first_post_failure_message_ms = $null
        time_to_sustained_target_ms = $null
        sustained_target_within_run = $null
        throughput_debt_recovery_window_msg = $null
        recovery_window_p95_latency_ms = $null
        post_failure_duplicates = 0
        post_failure_duplicate_ratio = $null
        post_failure_ordering_violations = 0
        backlog_drain_ms = $null
        run_completed_within_deadline = $null
    }

    if ($null -ne $expectedMessages -and $expectedMessages -gt 0) {
        $defaults['run_completed_within_deadline'] = ($messagesReceived -ge $expectedMessages)
    }

    if ($null -eq $SinkAnalysis) {
        return [PSCustomObject]$defaults
    }

    $registeredAtUnixNano = [Int64](Get-OptionalValue -Object $SinkAnalysis -PropertyName 'registered_at_unix_nano' -DefaultValue 0)
    $startedAtUnixNano = [Int64](Get-OptionalValue -Object $SinkAnalysis -PropertyName 'started_at_unix_nano' -DefaultValue 0)
    $finishedAtUnixNano = [Int64](Get-OptionalValue -Object $SinkAnalysis -PropertyName 'finished_at_unix_nano' -DefaultValue 0)

    if ($registeredAtUnixNano -le 0 -or $failureAfterSeconds -le 0) {
        return [PSCustomObject]$defaults
    }

    $estimatedFailureAtUnixNano = $registeredAtUnixNano + [Int64]($failureAfterSeconds * 1000000000)
    $defaults['estimated_failure_at_unix_nano'] = $estimatedFailureAtUnixNano

    $recoveryWindowEndUnixNano = $estimatedFailureAtUnixNano + [Int64]($Script:RECOVERY_WINDOW_SECONDS * 1000000000)
    $effectiveStartUnixNano = if ($startedAtUnixNano -gt 0) { $startedAtUnixNano } else { $registeredAtUnixNano }

    $uniqueEvents = @(Get-JsonArrayValue -Object $SinkAnalysis -PropertyName 'unique_events')
    $duplicateArrivalUnixNanos = @(Get-JsonArrayValue -Object $SinkAnalysis -PropertyName 'duplicate_arrival_unix_nanos')
    $orderingViolationArrivalUnixNanos = @(Get-JsonArrayValue -Object $SinkAnalysis -PropertyName 'ordering_violation_arrival_unix_nanos')

    # Phase-segmented throughput
    $defaults['pre_failure_throughput_msg_s'] = Get-PhaseThroughput -UniqueEvents $uniqueEvents -PhaseStartUnixNano $effectiveStartUnixNano -PhaseEndUnixNano $estimatedFailureAtUnixNano
    $clampedRecoveryEnd = if ($finishedAtUnixNano -lt $recoveryWindowEndUnixNano) { $finishedAtUnixNano } else { $recoveryWindowEndUnixNano }
    $defaults['recovery_window_throughput_msg_s'] = Get-PhaseThroughput -UniqueEvents $uniqueEvents -PhaseStartUnixNano $estimatedFailureAtUnixNano -PhaseEndUnixNano $clampedRecoveryEnd
    if ($finishedAtUnixNano -gt $recoveryWindowEndUnixNano) {
        $defaults['post_recovery_throughput_msg_s'] = Get-PhaseThroughput -UniqueEvents $uniqueEvents -PhaseStartUnixNano $recoveryWindowEndUnixNano -PhaseEndUnixNano $finishedAtUnixNano
    }

    # Post-failure correctness counts (split by phase)
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

    $postFailureOrderingViolationCount = 0
    if ($orderingViolationArrivalUnixNanos.Count -gt 0) {
        foreach ($arrivalUnixNano in $orderingViolationArrivalUnixNanos) {
            if ([Int64]$arrivalUnixNano -ge $estimatedFailureAtUnixNano) {
                $postFailureOrderingViolationCount++
            }
        }
        $defaults['post_failure_ordering_violations'] = $postFailureOrderingViolationCount
    }
    else {
        # Older runs do not record per-violation timestamps. Fall back to the run total
        # so the column is at least populated with an upper bound; it equals the true
        # post-failure count whenever pre-failure violations are zero (the typical case
        # in the recovery scenario).
        $defaults['post_failure_ordering_violations'] = [int]$orderingViolations
    }

    # Time to first post-failure message and backlog drain (per-event metrics)
    $postFailureEvents = New-Object System.Collections.Generic.List[object]
    $firstPostFailureMessageAtUnixNano = $null
    foreach ($event in $uniqueEvents) {
        $arrivalAtUnixNano = [Int64](Get-OptionalValue -Object $event -PropertyName 'arrival_at_unix_nano' -DefaultValue 0)
        if ($arrivalAtUnixNano -lt $estimatedFailureAtUnixNano) {
            continue
        }
        if ($null -eq $firstPostFailureMessageAtUnixNano) {
            $firstPostFailureMessageAtUnixNano = $arrivalAtUnixNano
        }
        $postFailureEvents.Add($event)
    }

    if ($null -ne $firstPostFailureMessageAtUnixNano) {
        $defaults['time_to_first_post_failure_message_ms'] = ($firstPostFailureMessageAtUnixNano - $estimatedFailureAtUnixNano) / 1e6
    }

    if ($finishedAtUnixNano -ge $estimatedFailureAtUnixNano) {
        $defaults['backlog_drain_ms'] = ($finishedAtUnixNano - $estimatedFailureAtUnixNano) / 1e6
    }

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

    # Time to sustained target: smallest 1 s bucket index B such that buckets B..B+(K-1)
    # all stay within the configured target band. Candidate windows that start before
    # the fixed recovery window ends must also keep delivering at least the lower bound
    # until that recovery window closes; this filters out replay plateaus that stop
    # before recovery is actually stable. We only evaluate complete 1 s buckets.
    $defaults['sustained_target_within_run'] = $false
    if ($targetMessagesPerSecond -gt 0 -and $postFailureEvents.Count -gt 0) {
        $lowerBound = $Script:SUSTAINED_TARGET_FRACTION * $targetMessagesPerSecond
        $upperBound = $Script:SUSTAINED_TARGET_BURST_CAP * $targetMessagesPerSecond

        $completeBucketCount = [int][Math]::Floor(($finishedAtUnixNano - $estimatedFailureAtUnixNano) / 1e9)
        $recoveryWindowIndex = $null
        for ($windowIndex = 0; $windowIndex -le ($completeBucketCount - $Script:SUSTAINED_TARGET_BUCKETS); $windowIndex++) {
            $sustained = $true
            for ($k = 0; $k -lt $Script:SUSTAINED_TARGET_BUCKETS; $k++) {
                $count = if ($windowCounts.ContainsKey($windowIndex + $k)) { [double]$windowCounts[$windowIndex + $k] } else { 0.0 }
                if ($count -lt $lowerBound -or $count -gt $upperBound) {
                    $sustained = $false
                    break
                }
            }
            if (-not $sustained) {
                continue
            }

            $tailEndExclusive = [Math]::Max($Script:RECOVERY_WINDOW_SECONDS, $windowIndex + $Script:SUSTAINED_TARGET_BUCKETS)
            if ($tailEndExclusive -gt $completeBucketCount) {
                $tailEndExclusive = $completeBucketCount
            }
            for ($k = $windowIndex + $Script:SUSTAINED_TARGET_BUCKETS; $k -lt $tailEndExclusive; $k++) {
                $count = if ($windowCounts.ContainsKey($k)) { [double]$windowCounts[$k] } else { 0.0 }
                if ($count -lt $lowerBound) {
                    $sustained = $false
                    break
                }
            }

            if ($sustained) {
                $recoveryWindowIndex = $windowIndex
                break
            }
        }

        if ($null -ne $recoveryWindowIndex) {
            $defaults['time_to_sustained_target_ms'] = 1000.0 * $recoveryWindowIndex
            $defaults['sustained_target_within_run'] = $true
        }
    }

    # Throughput debt over the FIXED 10 s recovery window. Uses 1 s buckets capped at
    # the target rate (so a replay burst that exceeds target in one bucket does not
    # negatively offset under-delivery in another bucket).
    if ($targetMessagesPerSecond -gt 0) {
        $debt = 0.0
        $bucketsToCheck = $Script:RECOVERY_WINDOW_SECONDS
        $maxAvailableBuckets = [int][Math]::Floor(($finishedAtUnixNano - $estimatedFailureAtUnixNano) / 1e9)
        if ($maxAvailableBuckets -lt $bucketsToCheck) {
            $bucketsToCheck = $maxAvailableBuckets
        }
        if ($bucketsToCheck -gt 0) {
            for ($windowIndex = 0; $windowIndex -lt $bucketsToCheck; $windowIndex++) {
                $actualMessages = if ($windowCounts.ContainsKey($windowIndex)) { [double]$windowCounts[$windowIndex] } else { 0.0 }
                if ($targetMessagesPerSecond -gt $actualMessages) {
                    $debt += ($targetMessagesPerSecond - $actualMessages)
                }
            }
            $defaults['throughput_debt_recovery_window_msg'] = $debt
        }
    }

    # Recovery-window p95 latency over the FIXED 10 s window
    $recoveryWindowLatencies = New-Object System.Collections.Generic.List[double]
    foreach ($event in $postFailureEvents) {
        $arrivalAtUnixNano = [Int64](Get-OptionalValue -Object $event -PropertyName 'arrival_at_unix_nano' -DefaultValue 0)
        if ($arrivalAtUnixNano -ge $recoveryWindowEndUnixNano) {
            continue
        }
        $recoveryWindowLatencies.Add([double](Get-OptionalValue -Object $event -PropertyName 'latency_ms' -DefaultValue 0))
    }
    if ($recoveryWindowLatencies.Count -gt 0) {
        $defaults['recovery_window_p95_latency_ms'] = Get-PercentileValue -Values ([double[]]$recoveryWindowLatencies.ToArray()) -Percentile 0.95
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
    if ($ContainerName -like 'grpc-stream-producer*') {
        return 'producer'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-transformer-*') {
        return 'transformer'
    }
    if ($ContainerName -like 'grpc-stream-transformer*') {
        return 'transformer'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-sink-*') {
        return 'sink'
    }
    if ($ContainerName -like 'grpc-stream-sink*') {
        return 'sink'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-rabbitmq-*') {
        return 'rabbitmq'
    }
    if ($ContainerName -like 'grpc-stream-rabbitmq*') {
        return 'rabbitmq'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-nats-*') {
        return 'nats'
    }
    if ($ContainerName -like 'grpc-stream-nats*') {
        return 'nats'
    }
    if ($ContainerName -like 'grpc-streaming-baseline-kafka-*') {
        return 'kafka'
    }
    if ($ContainerName -like 'grpc-stream-kafka*') {
        return 'kafka'
    }

    return $null
}

function Get-ResourceEntryRole {
    param([object]$Entry)

    $role = [string](Get-OptionalValue -Object $Entry -PropertyName 'Role')
    if (-not [string]::IsNullOrWhiteSpace($role)) {
        return $role
    }

    $name = [string](Get-OptionalValue -Object $Entry -PropertyName 'Name')
    $role = Get-ContainerRole -ContainerName $name
    if ($null -ne $role) {
        return $role
    }

    $podName = [string](Get-OptionalValue -Object $Entry -PropertyName 'PodName')
    return Get-ContainerRole -ContainerName $podName
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

    $statsPath = Join-Path $ResultsDirectory ("$RunId-k8s-stats.ndjson")
    if (-not (Test-Path $statsPath)) {
        $statsPath = Join-Path $ResultsDirectory ("$RunId-docker-stats.ndjson")
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
        $role = Get-ResourceEntryRole -Entry $entry
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

function Get-ResourceValidation {
    param(
        [object]$ProducerResult,
        [object]$ResourceSummary
    )

    $transportMode = [string](Get-OptionalValue -Object $ProducerResult -PropertyName 'transport_mode' -DefaultValue '')
    $targetMessagesPerSecond = [double](Get-OptionalValue -Object $ProducerResult -PropertyName 'target_messages_per_second' -DefaultValue 0)
    $failureAfterSeconds = [double](Get-OptionalValue -Object $ProducerResult -PropertyName 'failure_after_seconds' -DefaultValue 0)

    $requiredRoles = New-Object System.Collections.Generic.List[string]
    $requiredRoles.Add('transformer')
    $requiredRoles.Add('sink')

    if ($targetMessagesPerSecond -gt 0 -or $failureAfterSeconds -gt 0) {
        $requiredRoles.Add('producer')
    }

    switch ($transportMode) {
        'rabbitmq-streams' { $requiredRoles.Add('rabbitmq') }
        'nats-jetstream' { $requiredRoles.Add('nats') }
        'kafka' { $requiredRoles.Add('kafka') }
    }

    $missingRoles = New-Object System.Collections.Generic.List[string]
    foreach ($role in $requiredRoles) {
        $summary = Get-OptionalValue -Object $ResourceSummary -PropertyName $role
        $samples = [int](Get-OptionalValue -Object $summary -PropertyName 'samples' -DefaultValue 0)
        if ($samples -le 0) {
            $missingRoles.Add($role)
        }
    }

    return [PSCustomObject]@{
        valid = ($missingRoles.Count -eq 0)
        missing_roles = [string]::Join(',', $missingRoles)
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
        $resourceValidation = Get-ResourceValidation -ProducerResult $data -ResourceSummary $resourceSummary
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
            pre_failure_throughput_msg_s = $recoveryMetrics.pre_failure_throughput_msg_s
            recovery_window_throughput_msg_s = $recoveryMetrics.recovery_window_throughput_msg_s
            post_recovery_throughput_msg_s = $recoveryMetrics.post_recovery_throughput_msg_s
            time_to_first_post_failure_message_ms = $recoveryMetrics.time_to_first_post_failure_message_ms
            time_to_sustained_target_ms = $recoveryMetrics.time_to_sustained_target_ms
            sustained_target_within_run = $recoveryMetrics.sustained_target_within_run
            throughput_debt_recovery_window_msg = $recoveryMetrics.throughput_debt_recovery_window_msg
            recovery_window_p95_latency_ms = $recoveryMetrics.recovery_window_p95_latency_ms
            post_failure_duplicates = $recoveryMetrics.post_failure_duplicates
            post_failure_duplicate_ratio = $recoveryMetrics.post_failure_duplicate_ratio
            post_failure_ordering_violations = $recoveryMetrics.post_failure_ordering_violations
            backlog_drain_ms = $recoveryMetrics.backlog_drain_ms
            run_completed_within_deadline = $recoveryMetrics.run_completed_within_deadline
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
            resource_stats_valid = $resourceValidation.valid
            missing_resource_roles = $resourceValidation.missing_roles
            resource_stats_missing_roles = $resourceValidation.missing_roles
        }
    } |
    Where-Object { $_ -ne $null } |
    Sort-Object transport_mode, workload_source, payload_bytes, concurrency, run_id

if (-not $rows) {
    throw 'No matching producer result files were found to export.'
}

$rows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding utf8
Write-Host "Wrote result summary to $OutputPath"
