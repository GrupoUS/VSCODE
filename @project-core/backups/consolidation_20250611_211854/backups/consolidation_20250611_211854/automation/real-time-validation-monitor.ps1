# REAL-TIME VALIDATION MONITOR - GRUPO US VIBECODE SYSTEM V3.1
# Monitors unified memory system performance during real-world testing

param(
    [string]$VSCodeMemoryPath = "@project-core/configs/ide/vscode/Augment-Memories",  # Centralized in @project-core
    [string]$CursorMemoryPath = "@project-core/configs/ide/cursor/Augment-Memories",  # Centralized in @project-core
    [string]$LogPath = "@project-core/monitoring/real-time-validation-log.json",
    [int]$MonitorDurationMinutes = 30,
    [switch]$ContinuousMode = $false
)

Write-Host "🔍 REAL-TIME VALIDATION MONITOR STARTED" -ForegroundColor Cyan
Write-Host "Duration: $(if($ContinuousMode){'Continuous'}else{"$MonitorDurationMinutes minutes"})" -ForegroundColor Gray
Write-Host "Log: $LogPath" -ForegroundColor Gray
Write-Host ""

# Initialize monitoring data
$monitoringData = @{
    startTime = Get-Date
    testResults = @()
    performanceMetrics = @()
    syncValidation = @()
    errors = @()
    summary = @{}
}

# Create monitoring directory if it doesn't exist
$logDir = Split-Path $LogPath -Parent
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Function to test VS Code memory access
function Test-VSCodeMemory {
    try {
        $startTime = Get-Date
        $exists = Test-Path $VSCodeMemoryPath
        $endTime = Get-Date
        $responseTime = ($endTime - $startTime).TotalMilliseconds

        if ($exists) {
            $size = (Get-Item $VSCodeMemoryPath).Length
            $content = Get-Content $VSCodeMemoryPath -TotalCount 10 -ErrorAction SilentlyContinue

            return @{
                timestamp = $startTime
                test = "VSCode Memory Access"
                status = "SUCCESS"
                responseTime = $responseTime
                fileSize = $size
                accessible = $true
                contentPreview = $content -join "`n"
            }
        } else {
            return @{
                timestamp = $startTime
                test = "VSCode Memory Access"
                status = "FAILED"
                responseTime = $responseTime
                error = "File not found"
                accessible = $false
            }
        }
    } catch {
        return @{
            timestamp = Get-Date
            test = "VSCode Memory Access"
            status = "ERROR"
            error = $_.Exception.Message
            accessible = $false
        }
    }
}

# Function to test Cursor memory redirection
function Test-CursorMemory {
    try {
        $startTime = Get-Date
        $exists = Test-Path $CursorMemoryPath
        $endTime = Get-Date
        $responseTime = ($endTime - $startTime).TotalMilliseconds

        if ($exists) {
            $content = Get-Content $CursorMemoryPath -Raw -ErrorAction SilentlyContinue
            $isRedirection = $content -match "UNIFIED MEMORY SYSTEM - REDIRECTION ACTIVE"

            return @{
                timestamp = $startTime
                test = "Cursor Memory Redirection"
                status = if($isRedirection){"SUCCESS"}else{"WARNING"}
                responseTime = $responseTime
                isRedirection = $isRedirection
                accessible = $true
                contentLength = $content.Length
            }
        } else {
            return @{
                timestamp = $startTime
                test = "Cursor Memory Redirection"
                status = "FAILED"
                responseTime = $responseTime
                error = "File not found"
                accessible = $false
            }
        }
    } catch {
        return @{
            timestamp = Get-Date
            test = "Cursor Memory Redirection"
            status = "ERROR"
            error = $_.Exception.Message
            accessible = $false
        }
    }
}

# Function to test synchronization
function Test-Synchronization {
    try {
        $startTime = Get-Date

        # Get VS Code file info
        $vscodeInfo = if (Test-Path $VSCodeMemoryPath) {
            $item = Get-Item $VSCodeMemoryPath
            @{
                exists = $true
                size = $item.Length
                lastWrite = $item.LastWriteTime
            }
        } else {
            @{ exists = $false }
        }

        # Get Cursor file info
        $cursorInfo = if (Test-Path $CursorMemoryPath) {
            $item = Get-Item $CursorMemoryPath
            @{
                exists = $true
                size = $item.Length
                lastWrite = $item.LastWriteTime
            }
        } else {
            @{ exists = $false }
        }

        $endTime = Get-Date
        $responseTime = ($endTime - $startTime).TotalMilliseconds

        return @{
            timestamp = $startTime
            test = "Synchronization Check"
            status = if($vscodeInfo.exists -and $cursorInfo.exists){"SUCCESS"}else{"FAILED"}
            responseTime = $responseTime
            vscodeFile = $vscodeInfo
            cursorFile = $cursorInfo
        }
    } catch {
        return @{
            timestamp = Get-Date
            test = "Synchronization Check"
            status = "ERROR"
            error = $_.Exception.Message
        }
    }
}

# Function to calculate performance metrics
function Calculate-PerformanceMetrics {
    param($testResults)

    $successfulTests = $testResults | Where-Object { $_.status -eq "SUCCESS" }
    $failedTests = $testResults | Where-Object { $_.status -eq "FAILED" -or $_.status -eq "ERROR" }

    $avgResponseTime = if ($successfulTests.Count -gt 0) {
        ($successfulTests | Measure-Object -Property responseTime -Average).Average
    } else { 0 }

    return @{
        totalTests = $testResults.Count
        successfulTests = $successfulTests.Count
        failedTests = $failedTests.Count
        successRate = if($testResults.Count -gt 0){[math]::Round(($successfulTests.Count / $testResults.Count) * 100, 2)}else{0}
        averageResponseTime = [math]::Round($avgResponseTime, 2)
        timestamp = Get-Date
    }
}

# Main monitoring loop
$endTime = if ($ContinuousMode) { [DateTime]::MaxValue } else { (Get-Date).AddMinutes($MonitorDurationMinutes) }
$testCount = 0

Write-Host "🚀 Starting validation tests..." -ForegroundColor Green
Write-Host ""

while ((Get-Date) -lt $endTime) {
    $testCount++
    Write-Host "Test Cycle $testCount - $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Yellow

    # Run tests
    $vscodeTest = Test-VSCodeMemory
    $cursorTest = Test-CursorMemory
    $syncTest = Test-Synchronization

    # Add to monitoring data
    $monitoringData.testResults += $vscodeTest, $cursorTest, $syncTest

    # Display results
    Write-Host "  VS Code Memory: $($vscodeTest.status) ($($vscodeTest.responseTime)ms)" -ForegroundColor $(if($vscodeTest.status -eq "SUCCESS"){"Green"}else{"Red"})
    Write-Host "  Cursor Redirect: $($cursorTest.status) ($($cursorTest.responseTime)ms)" -ForegroundColor $(if($cursorTest.status -eq "SUCCESS"){"Green"}else{"Yellow"})
    Write-Host "  Synchronization: $($syncTest.status) ($($syncTest.responseTime)ms)" -ForegroundColor $(if($syncTest.status -eq "SUCCESS"){"Green"}else{"Red"})

    # Calculate current metrics
    $currentMetrics = Calculate-PerformanceMetrics $monitoringData.testResults
    $monitoringData.performanceMetrics += $currentMetrics

    Write-Host "  Success Rate: $($currentMetrics.successRate)% | Avg Response: $($currentMetrics.averageResponseTime)ms" -ForegroundColor Cyan
    Write-Host ""

    # Save intermediate results
    $monitoringData.summary = @{
        currentCycle = $testCount
        overallSuccessRate = $currentMetrics.successRate
        averageResponseTime = $currentMetrics.averageResponseTime
        lastUpdate = Get-Date
        status = if($currentMetrics.successRate -ge 90){"EXCELLENT"}elseif($currentMetrics.successRate -ge 75){"GOOD"}elseif($currentMetrics.successRate -ge 50){"ACCEPTABLE"}else{"POOR"}
    }

    # Save to log file
    try {
        $monitoringData | ConvertTo-Json -Depth 10 | Out-File -FilePath $LogPath -Encoding UTF8
    } catch {
        Write-Host "Warning: Could not save log file: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    # Wait before next cycle (unless continuous mode with short interval)
    if (-not $ContinuousMode) {
        Start-Sleep -Seconds 30
    } else {
        Start-Sleep -Seconds 10
    }
}

# Final summary
Write-Host "📊 VALIDATION MONITORING COMPLETE" -ForegroundColor Green
Write-Host ""
Write-Host "Final Results:" -ForegroundColor Cyan
Write-Host "  Total Test Cycles: $testCount" -ForegroundColor White
Write-Host "  Overall Success Rate: $($monitoringData.summary.overallSuccessRate)%" -ForegroundColor White
Write-Host "  Average Response Time: $($monitoringData.summary.averageResponseTime)ms" -ForegroundColor White
Write-Host "  System Status: $($monitoringData.summary.status)" -ForegroundColor $(if($monitoringData.summary.status -eq "EXCELLENT"){"Green"}elseif($monitoringData.summary.status -eq "GOOD"){"Yellow"}else{"Red"})
Write-Host ""
Write-Host "Log saved to: $LogPath" -ForegroundColor Gray

return $monitoringData.summary
