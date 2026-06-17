param(
    [Parameter(Mandatory = $true)]
    [string]$SummaryPath,

    [string]$OutputPath = ''
)

$ErrorActionPreference = 'Stop'
[System.Threading.Thread]::CurrentThread.CurrentCulture = [System.Globalization.CultureInfo]::InvariantCulture
[System.Threading.Thread]::CurrentThread.CurrentUICulture = [System.Globalization.CultureInfo]::InvariantCulture

function Get-BaseRunId {
    param([string]$RunId)

    if ([string]::IsNullOrWhiteSpace($RunId)) {
        return $RunId
    }

    return ($RunId -replace '-rep\d+$', '')
}

function ConvertTo-NullableNumber {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $number = 0.0
    if ([double]::TryParse($Value, [System.Globalization.NumberStyles]::Any, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$number)) {
        return $number
    }

    return $null
}

function Get-AggregatedValue {
    param(
        [System.Collections.IEnumerable]$Rows,
        [string]$PropertyName
    )

    if ($PropertyName -eq 'run_id') {
        return (Get-BaseRunId -RunId ($Rows | Select-Object -First 1).run_id)
    }

    $values = @($Rows | ForEach-Object { $_.$PropertyName })
    $nonEmptyValues = @($values | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_) })
    if ($nonEmptyValues.Count -eq 0) {
        return ''
    }

    $numericValues = New-Object System.Collections.Generic.List[double]
    foreach ($value in $nonEmptyValues) {
        $numeric = ConvertTo-NullableNumber -Value ([string]$value)
        if ($null -eq $numeric) {
            return ($nonEmptyValues | Select-Object -First 1)
        }
        $numericValues.Add($numeric)
    }

    $average = ($numericValues | Measure-Object -Average).Average
    $sorted = @($numericValues | Sort-Object)
    $middle = [int][Math]::Floor($sorted.Count / 2)
    if (($sorted.Count % 2) -eq 1) {
        $median = $sorted[$middle]
    }
    else {
        $median = ($sorted[$middle - 1] + $sorted[$middle]) / 2.0
    }
    return [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0}', $median)
}

function Get-NumericValues {
    param(
        [System.Collections.IEnumerable]$Rows,
        [string]$PropertyName
    )

    $numericValues = New-Object System.Collections.Generic.List[double]
    foreach ($row in $Rows) {
        $numeric = ConvertTo-NullableNumber -Value ([string]$row.$PropertyName)
        if ($null -ne $numeric) {
            $numericValues.Add($numeric)
        }
    }
    return $numericValues
}

$resolvedSummaryPath = [System.IO.Path]::GetFullPath($SummaryPath)
if (-not (Test-Path $resolvedSummaryPath)) {
    throw "Summary file not found: $resolvedSummaryPath"
}

if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $directory = Split-Path -Parent $resolvedSummaryPath
    $name = [System.IO.Path]::GetFileNameWithoutExtension($resolvedSummaryPath)
    $OutputPath = Join-Path $directory ("$name-aggregated.csv")
}

$rows = Import-Csv -Path $resolvedSummaryPath
if (-not $rows) {
    throw 'Summary file contained no rows to aggregate.'
}

$propertyNames = $rows[0].PSObject.Properties.Name
$aggregatedRows = $rows |
    Group-Object { Get-BaseRunId -RunId $_.run_id } |
    Sort-Object Name |
    ForEach-Object {
        $groupRows = @($_.Group)
        $aggregated = [ordered]@{}
        foreach ($propertyName in $propertyNames) {
            $aggregated[$propertyName] = Get-AggregatedValue -Rows $groupRows -PropertyName $propertyName
            if ($propertyName -eq 'run_id') {
                continue
            }
            $numericValues = Get-NumericValues -Rows $groupRows -PropertyName $propertyName
            if ($numericValues.Count -gt 0 -and $numericValues.Count -eq ($groupRows | Measure-Object).Count) {
                $min = ($numericValues | Measure-Object -Minimum).Minimum
                $max = ($numericValues | Measure-Object -Maximum).Maximum
                $aggregated["${propertyName}_min"] = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0}', $min)
                $aggregated["${propertyName}_max"] = [string]::Format([System.Globalization.CultureInfo]::InvariantCulture, '{0}', $max)
            }
        }
        $aggregated['repeat_count'] = [string]$groupRows.Count
        [PSCustomObject]$aggregated
    }

$aggregatedRows | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding utf8
Write-Host "Wrote aggregated summary to $OutputPath"
