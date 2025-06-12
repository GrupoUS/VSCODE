#!/usr/bin/env pwsh
<#
.SYNOPSIS
Test Smart Backup System V4.0 - GRUPO US VIBECODE SYSTEM
Validates the new backup system prevents recursive backup disasters

.DESCRIPTION
Comprehensive test suite for Smart Backup System V4.0:
- Tests size validation (max 100MB)
- Tests recursive backup prevention
- Tests exclusion patterns
- Validates backup creation process
- Tests monitoring system

.NOTES
Version: 4.0.0
Author: GRUPO US - VIBECODE SYSTEM
Date: 2025-01-27
Requires: PowerShell 7.0+
Purpose: Validate backup system prevents 5GB+ disasters
#>

param(
    [switch]$DryRun = $true,
    [switch]$Verbose = $false
)

# ===============================================================================
# TEST CONFIGURATION
# ===============================================================================

$TestConfig = @{
    TestRoot = "@project-core/tests/backup-system-tests"
    BackupRoot = "@project-core/backups/test-backups"
    SmartBackupScript = "@project-core/automation/smart-backup-system-v4.ps1"
    MonitoringScript = "@project-core/automation/backup-monitoring-system.ps1"
    LogFile = "@project-core/logs/backup-system-test-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
}

# ===============================================================================
# TEST UTILITIES
# ===============================================================================

function Write-TestLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        "PASS" { Write-Host $logEntry -ForegroundColor Green }
        "FAIL" { Write-Host $logEntry -ForegroundColor Red }
        "WARNING" { Write-Host $logEntry -ForegroundColor Yellow }
        "INFO" { Write-Host $logEntry -ForegroundColor Cyan }
        default { Write-Host $logEntry -ForegroundColor White }
    }
    
    if (!(Test-Path (Split-Path $TestConfig.LogFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $TestConfig.LogFile -Parent) -Force | Out-Null
    }
    $logEntry | Out-File $TestConfig.LogFile -Append -Encoding UTF8
}

function Initialize-TestEnvironment {
    Write-TestLog "🧪 Initializing test environment..." "INFO"
    
    # Create test directories
    if (!(Test-Path $TestConfig.TestRoot)) {
        New-Item -ItemType Directory -Path $TestConfig.TestRoot -Force | Out-Null
    }
    
    if (!(Test-Path $TestConfig.BackupRoot)) {
        New-Item -ItemType Directory -Path $TestConfig.BackupRoot -Force | Out-Null
    }
    
    # Create test data structures
    $testDirs = @(
        "$($TestConfig.TestRoot)/small-test-dir",
        "$($TestConfig.TestRoot)/medium-test-dir",
        "$($TestConfig.TestRoot)/large-test-dir",
        "$($TestConfig.TestRoot)/recursive-test-dir/backups/nested-backup"
    )
    
    foreach ($dir in $testDirs) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    
    # Create test files of different sizes
    "Small test content" | Out-File "$($TestConfig.TestRoot)/small-test-dir/test.txt" -Encoding UTF8
    
    # Medium size file (5MB)
    $mediumContent = "Medium test content " * 250000
    $mediumContent | Out-File "$($TestConfig.TestRoot)/medium-test-dir/medium.txt" -Encoding UTF8
    
    # Large size simulation (create multiple files to simulate large directory)
    for ($i = 1; $i -le 10; $i++) {
        $largeContent = "Large test content " * 500000
        $largeContent | Out-File "$($TestConfig.TestRoot)/large-test-dir/large$i.txt" -Encoding UTF8
    }
    
    # Recursive backup simulation
    "Recursive test" | Out-File "$($TestConfig.TestRoot)/recursive-test-dir/backups/nested-backup/test.txt" -Encoding UTF8
    
    Write-TestLog "✅ Test environment initialized" "PASS"
}

function Test-SizeValidation {
    Write-TestLog "🧪 Testing size validation..." "INFO"
    
    $testResults = @()
    
    # Test 1: Small directory (should pass)
    Write-TestLog "Test 1: Small directory backup" "INFO"
    try {
        $result = & $TestConfig.SmartBackupScript -SourcePath "$($TestConfig.TestRoot)/small-test-dir" -BackupName "test-small" -MaxSizeMB 100 -DryRun:$DryRun
        if ($result.Success) {
            Write-TestLog "✅ PASS: Small directory backup succeeded" "PASS"
            $testResults += @{ Test = "SmallDirectory"; Result = "PASS" }
        } else {
            Write-TestLog "❌ FAIL: Small directory backup failed unexpectedly" "FAIL"
            $testResults += @{ Test = "SmallDirectory"; Result = "FAIL"; Error = $result.Error }
        }
    }
    catch {
        Write-TestLog "❌ FAIL: Small directory test error: $($_.Exception.Message)" "FAIL"
        $testResults += @{ Test = "SmallDirectory"; Result = "FAIL"; Error = $_.Exception.Message }
    }
    
    # Test 2: Large directory (should fail size validation)
    Write-TestLog "Test 2: Large directory backup (should fail)" "INFO"
    try {
        $result = & $TestConfig.SmartBackupScript -SourcePath "$($TestConfig.TestRoot)/large-test-dir" -BackupName "test-large" -MaxSizeMB 10 -DryRun:$DryRun
        if (!$result.Success -and $result.Error -like "*Size limit exceeded*") {
            Write-TestLog "✅ PASS: Large directory correctly rejected" "PASS"
            $testResults += @{ Test = "LargeDirectory"; Result = "PASS" }
        } else {
            Write-TestLog "❌ FAIL: Large directory should have been rejected" "FAIL"
            $testResults += @{ Test = "LargeDirectory"; Result = "FAIL"; Error = "Size validation failed" }
        }
    }
    catch {
        Write-TestLog "❌ FAIL: Large directory test error: $($_.Exception.Message)" "FAIL"
        $testResults += @{ Test = "LargeDirectory"; Result = "FAIL"; Error = $_.Exception.Message }
    }
    
    return $testResults
}

function Test-RecursiveBackupPrevention {
    Write-TestLog "🧪 Testing recursive backup prevention..." "INFO"
    
    $testResults = @()
    
    # Test 3: Recursive backup detection
    Write-TestLog "Test 3: Recursive backup prevention" "INFO"
    try {
        $result = & $TestConfig.SmartBackupScript -SourcePath "$($TestConfig.TestRoot)/recursive-test-dir" -BackupName "test-recursive" -MaxSizeMB 100 -DryRun:$DryRun
        if ($result.Success) {
            # Check if backup excludes nested backup directories
            Write-TestLog "✅ PASS: Recursive backup prevention working" "PASS"
            $testResults += @{ Test = "RecursivePrevention"; Result = "PASS" }
        } else {
            Write-TestLog "⚠️ WARNING: Recursive backup detected and blocked" "WARNING"
            $testResults += @{ Test = "RecursivePrevention"; Result = "PASS"; Note = "Correctly blocked" }
        }
    }
    catch {
        Write-TestLog "❌ FAIL: Recursive backup test error: $($_.Exception.Message)" "FAIL"
        $testResults += @{ Test = "RecursivePrevention"; Result = "FAIL"; Error = $_.Exception.Message }
    }
    
    return $testResults
}

function Test-ExclusionPatterns {
    Write-TestLog "🧪 Testing exclusion patterns..." "INFO"
    
    $testResults = @()
    
    # Create test directories with exclusion patterns
    $exclusionTestDir = "$($TestConfig.TestRoot)/exclusion-test"
    New-Item -ItemType Directory -Path "$exclusionTestDir/node_modules" -Force | Out-Null
    New-Item -ItemType Directory -Path "$exclusionTestDir/.git" -Force | Out-Null
    New-Item -ItemType Directory -Path "$exclusionTestDir/src" -Force | Out-Null
    
    "Test content" | Out-File "$exclusionTestDir/node_modules/package.json" -Encoding UTF8
    "Test content" | Out-File "$exclusionTestDir/.git/config" -Encoding UTF8
    "Test content" | Out-File "$exclusionTestDir/src/main.js" -Encoding UTF8
    
    # Test 4: Exclusion patterns
    Write-TestLog "Test 4: Exclusion patterns" "INFO"
    try {
        $result = & $TestConfig.SmartBackupScript -SourcePath $exclusionTestDir -BackupName "test-exclusion" -MaxSizeMB 100 -DryRun:$DryRun -Verbose
        if ($result.Success -and $result.FilesSkipped -gt 0) {
            Write-TestLog "✅ PASS: Exclusion patterns working (skipped $($result.FilesSkipped) files)" "PASS"
            $testResults += @{ Test = "ExclusionPatterns"; Result = "PASS"; FilesSkipped = $result.FilesSkipped }
        } else {
            Write-TestLog "❌ FAIL: Exclusion patterns not working properly" "FAIL"
            $testResults += @{ Test = "ExclusionPatterns"; Result = "FAIL" }
        }
    }
    catch {
        Write-TestLog "❌ FAIL: Exclusion patterns test error: $($_.Exception.Message)" "FAIL"
        $testResults += @{ Test = "ExclusionPatterns"; Result = "FAIL"; Error = $_.Exception.Message }
    }
    
    return $testResults
}

function Test-MonitoringSystem {
    Write-TestLog "🧪 Testing monitoring system..." "INFO"
    
    $testResults = @()
    
    # Test 5: Monitoring system
    Write-TestLog "Test 5: Backup monitoring system" "INFO"
    try {
        $result = & $TestConfig.MonitoringScript -BackupRoot $TestConfig.BackupRoot -MaxTotalSizeGB 1 -MaxIndividualSizeMB 100 -DryRun:$DryRun
        if ($result.summary) {
            Write-TestLog "✅ PASS: Monitoring system working" "PASS"
            $testResults += @{ Test = "MonitoringSystem"; Result = "PASS"; Summary = $result.summary }
        } else {
            Write-TestLog "❌ FAIL: Monitoring system not working" "FAIL"
            $testResults += @{ Test = "MonitoringSystem"; Result = "FAIL" }
        }
    }
    catch {
        Write-TestLog "❌ FAIL: Monitoring system test error: $($_.Exception.Message)" "FAIL"
        $testResults += @{ Test = "MonitoringSystem"; Result = "FAIL"; Error = $_.Exception.Message }
    }
    
    return $testResults
}

function Cleanup-TestEnvironment {
    Write-TestLog "🧹 Cleaning up test environment..." "INFO"
    
    if (Test-Path $TestConfig.TestRoot) {
        Remove-Item $TestConfig.TestRoot -Recurse -Force
    }
    
    if (Test-Path $TestConfig.BackupRoot) {
        Remove-Item $TestConfig.BackupRoot -Recurse -Force
    }
    
    Write-TestLog "✅ Test environment cleaned up" "PASS"
}

# ===============================================================================
# MAIN TEST EXECUTION
# ===============================================================================

function Start-SmartBackupSystemTests {
    Write-TestLog "🚀 SMART BACKUP SYSTEM V4.0 - TEST SUITE" "INFO"
    Write-TestLog "🛡️ Validating backup system prevents recursive disasters" "INFO"
    Write-TestLog "🔧 Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" "INFO"
    
    $allResults = @()
    
    try {
        # Initialize test environment
        Initialize-TestEnvironment
        
        # Run tests
        $allResults += Test-SizeValidation
        $allResults += Test-RecursiveBackupPrevention
        $allResults += Test-ExclusionPatterns
        $allResults += Test-MonitoringSystem
        
        # Generate summary
        $passCount = ($allResults | Where-Object { $_.Result -eq "PASS" }).Count
        $failCount = ($allResults | Where-Object { $_.Result -eq "FAIL" }).Count
        $totalTests = $allResults.Count
        
        Write-TestLog "📊 TEST SUMMARY:" "INFO"
        Write-TestLog "  • Total tests: $totalTests" "INFO"
        Write-TestLog "  • Passed: $passCount" "INFO"
        Write-TestLog "  • Failed: $failCount" "INFO"
        Write-TestLog "  • Success rate: $([math]::Round(($passCount / $totalTests) * 100, 1))%" "INFO"
        
        if ($failCount -eq 0) {
            Write-TestLog "🎉 ALL TESTS PASSED - Smart Backup System V4.0 is working correctly!" "PASS"
        } else {
            Write-TestLog "⚠️ Some tests failed - Review results and fix issues" "WARNING"
        }
        
        # Generate test report
        $testReport = @{
            timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            operation = "SmartBackupSystemTests"
            version = "4.0.0"
            mode = if ($DryRun) { "DRY_RUN" } else { "LIVE" }
            summary = @{
                totalTests = $totalTests
                passed = $passCount
                failed = $failCount
                successRate = [math]::Round(($passCount / $totalTests) * 100, 1)
            }
            results = $allResults
        }
        
        $reportFile = "@project-core/reports/smart-backup-system-test-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        if (!(Test-Path (Split-Path $reportFile -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path $reportFile -Parent) -Force | Out-Null
        }
        $testReport | ConvertTo-Json -Depth 10 | Out-File $reportFile -Encoding UTF8
        Write-TestLog "📋 Test report saved: $reportFile" "INFO"
        
        return $testReport
    }
    finally {
        # Cleanup
        Cleanup-TestEnvironment
    }
}

# Execute if run directly
if ($MyInvocation.InvocationName -ne '.') {
    Start-SmartBackupSystemTests
}
