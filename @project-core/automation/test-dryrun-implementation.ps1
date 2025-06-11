# ===============================================================================
# DRY-RUN IMPLEMENTATION TEST SUITE V4.0
# GRUPO US VIBECODE SYSTEM - ENHANCED SAFETY PROTOCOLS
# ===============================================================================

<#
.SYNOPSIS
Comprehensive test suite for dry-run implementation and safety protocols

.DESCRIPTION
Tests all dry-run capabilities and safety features:
- Safe cleanup script dry-run functionality
- Finaltest script dry-run mode
- Critical file protection
- Staging area verification
- Incremental processing

.EXAMPLE
.\test-dryrun-implementation.ps1
#>

[CmdletBinding()]
param()

# Global test results
$script:TestResults = @()
$script:TestCount = 0
$script:PassedTests = 0
$script:FailedTests = 0

function Write-TestResult {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Details = ""
    )
    
    $script:TestCount++
    
    if ($Passed) {
        $script:PassedTests++
        Write-Host "✅ PASS: $TestName" -ForegroundColor Green
    } else {
        $script:FailedTests++
        Write-Host "❌ FAIL: $TestName" -ForegroundColor Red
    }
    
    if ($Details) {
        Write-Host "   $Details" -ForegroundColor Gray
    }
    
    $script:TestResults += @{
        Name = $TestName
        Passed = $Passed
        Details = $Details
    }
}

function Test-SafeCleanupDryRun {
    Write-Host "🧪 Testing Safe Cleanup Dry-Run Implementation..." -ForegroundColor Cyan
    
    # Test 1: Script exists and is executable
    $scriptPath = "@project-core/automation/safe-cleanup-with-dryrun.ps1"
    $scriptExists = Test-Path $scriptPath
    Write-TestResult "Safe cleanup script exists" $scriptExists "Path: $scriptPath"
    
    if (!$scriptExists) {
        return
    }
    
    # Test 2: Dry-run parameter support
    try {
        $help = Get-Help $scriptPath -ErrorAction Stop
        $dryRunParam = $help.Parameters.Parameter | Where-Object { $_.Name -eq "DryRun" }
        $hasDryRun = $dryRunParam -ne $null
        Write-TestResult "Script supports -DryRun parameter" $hasDryRun
    }
    catch {
        Write-TestResult "Script supports -DryRun parameter" $false "Error getting help: $($_.Exception.Message)"
    }
    
    # Test 3: Create test files for dry-run
    $testDir = "@project-core/_test_cleanup"
    $testFiles = @()
    
    try {
        if (!(Test-Path $testDir)) {
            New-Item -ItemType Directory -Path $testDir -Force | Out-Null
        }
        
        # Create test files
        for ($i = 1; $i -le 3; $i++) {
            $testFile = Join-Path $testDir "test-backup-file-$i.txt"
            "Test content $i" | Out-File -FilePath $testFile -Encoding UTF8
            $testFiles += $testFile
        }
        
        Write-TestResult "Test files created successfully" $true "Created $($testFiles.Count) test files"
    }
    catch {
        Write-TestResult "Test files created successfully" $false "Error: $($_.Exception.Message)"
        return
    }
    
    # Test 4: Execute dry-run (should not move files)
    try {
        $output = & $scriptPath -TargetDirectory $testDir -FilePatterns @("*backup*") -DryRun 2>&1
        $dryRunSuccess = $LASTEXITCODE -eq 0
        
        # Verify files still exist (not moved)
        $filesStillExist = $true
        foreach ($file in $testFiles) {
            if (!(Test-Path $file)) {
                $filesStillExist = $false
                break
            }
        }
        
        Write-TestResult "Dry-run execution successful" $dryRunSuccess "Exit code: $LASTEXITCODE"
        Write-TestResult "Files not moved in dry-run" $filesStillExist "All test files should still exist"
    }
    catch {
        Write-TestResult "Dry-run execution successful" $false "Error: $($_.Exception.Message)"
    }
    finally {
        # Cleanup test files
        if (Test-Path $testDir) {
            Remove-Item $testDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

function Test-FinaltestDryRun {
    Write-Host "🧪 Testing Finaltest Dry-Run Implementation..." -ForegroundColor Cyan
    
    # Test 1: Script exists
    $scriptPath = "@project-core/automation/finaltest.ps1"
    $scriptExists = Test-Path $scriptPath
    Write-TestResult "Finaltest script exists" $scriptExists "Path: $scriptPath"
    
    if (!$scriptExists) {
        return
    }
    
    # Test 2: Dry-run parameter support
    try {
        $content = Get-Content $scriptPath -Raw
        $hasDryRunParam = $content -match '\[switch\]\$DryRun'
        Write-TestResult "Finaltest supports -DryRun parameter" $hasDryRunParam
    }
    catch {
        Write-TestResult "Finaltest supports -DryRun parameter" $false "Error reading script: $($_.Exception.Message)"
    }
    
    # Test 3: Execute dry-run
    try {
        $output = & $scriptPath -TaskDescription "Dry-Run Test" -DryRun 2>&1
        $dryRunSuccess = $LASTEXITCODE -eq 0
        
        # Check if dry-run mode was indicated in output
        $outputString = $output -join " "
        $dryRunIndicated = $outputString -match "DRY RUN"
        
        Write-TestResult "Finaltest dry-run execution" $dryRunSuccess "Exit code: $LASTEXITCODE"
        Write-TestResult "Dry-run mode indicated in output" $dryRunIndicated
    }
    catch {
        Write-TestResult "Finaltest dry-run execution" $false "Error: $($_.Exception.Message)"
    }
}

function Test-CriticalFileProtection {
    Write-Host "🧪 Testing Critical File Protection..." -ForegroundColor Cyan
    
    # Test 1: Critical files list exists
    $protocolPath = "@project-core/rules/enhanced-cleanup-protocols-v4.md"
    $protocolExists = Test-Path $protocolPath
    Write-TestResult "Enhanced cleanup protocols exist" $protocolExists "Path: $protocolPath"
    
    if (!$protocolExists) {
        return
    }
    
    # Test 2: Critical files are protected
    $criticalFiles = @(
        "@project-core/memory/master_rule.md",
        "@project-core/memory/self_correction_log.md",
        "@project-core/memory/global-standards.md",
        "@project-core/rules/00-vibecode-system-v4-master.md",
        "@project-core/automation/finaltest.ps1",
        "@project-core/automation/validate-system.ps1"
    )
    
    $allCriticalFilesExist = $true
    $missingFiles = @()
    
    foreach ($file in $criticalFiles) {
        if (!(Test-Path $file)) {
            $allCriticalFilesExist = $false
            $missingFiles += $file
        }
    }
    
    Write-TestResult "All critical files exist" $allCriticalFilesExist "Missing: $($missingFiles -join ', ')"
    
    # Test 3: Protection function exists in safe cleanup script
    $safeCleanupPath = "@project-core/automation/safe-cleanup-with-dryrun.ps1"
    if (Test-Path $safeCleanupPath) {
        $content = Get-Content $safeCleanupPath -Raw
        $hasProtectionFunction = $content -match "Test-CriticalFileProtection"
        Write-TestResult "Critical file protection function exists" $hasProtectionFunction
    }
}

function Test-StagingAreaVerification {
    Write-Host "🧪 Testing Staging Area Verification..." -ForegroundColor Cyan
    
    # Test 1: Staging verification function exists
    $safeCleanupPath = "@project-core/automation/safe-cleanup-with-dryrun.ps1"
    if (Test-Path $safeCleanupPath) {
        $content = Get-Content $safeCleanupPath -Raw
        $hasStagingFunction = $content -match "Test-StagingAreaFunctionality"
        Write-TestResult "Staging area verification function exists" $hasStagingFunction
        
        # Test 2: Staging area can be created
        $testStagingArea = "@project-core/_test_staging"
        try {
            if (Test-Path $testStagingArea) {
                Remove-Item $testStagingArea -Recurse -Force
            }
            
            New-Item -ItemType Directory -Path $testStagingArea -Force | Out-Null
            $stagingCreated = Test-Path $testStagingArea
            Write-TestResult "Staging area can be created" $stagingCreated "Path: $testStagingArea"
            
            # Test 3: Files can be moved to staging
            $testFile = Join-Path $testStagingArea "test-staging.txt"
            "Test staging content" | Out-File -FilePath $testFile -Encoding UTF8
            $fileInStaging = Test-Path $testFile
            Write-TestResult "Files can be placed in staging area" $fileInStaging
            
            # Cleanup
            Remove-Item $testStagingArea -Recurse -Force -ErrorAction SilentlyContinue
        }
        catch {
            Write-TestResult "Staging area functionality" $false "Error: $($_.Exception.Message)"
        }
    }
}

function Test-IncrementalProcessing {
    Write-Host "🧪 Testing Incremental Processing..." -ForegroundColor Cyan
    
    # Test 1: Incremental function exists
    $safeCleanupPath = "@project-core/automation/safe-cleanup-with-dryrun.ps1"
    if (Test-Path $safeCleanupPath) {
        $content = Get-Content $safeCleanupPath -Raw
        $hasIncrementalFunction = $content -match "Start-IncrementalCleanup"
        Write-TestResult "Incremental cleanup function exists" $hasIncrementalFunction
        
        # Test 2: Test batch size parameter support
        $hasTestBatchSize = $content -match "TestBatchSize"
        Write-TestResult "Test batch size parameter supported" $hasTestBatchSize
        
        # Test 3: Batch processing logic exists
        $hasBatchProcessing = $content -match "Select-Object -First.*TestBatchSize"
        Write-TestResult "Batch processing logic implemented" $hasBatchProcessing
    }
}

function Show-TestSummary {
    Write-Host "`n" + "=" * 70 -ForegroundColor Gray
    Write-Host "🧪 DRY-RUN IMPLEMENTATION TEST SUMMARY" -ForegroundColor Magenta
    Write-Host "=" * 70 -ForegroundColor Gray
    
    Write-Host "Total Tests: $script:TestCount" -ForegroundColor White
    Write-Host "Passed: $script:PassedTests" -ForegroundColor Green
    Write-Host "Failed: $script:FailedTests" -ForegroundColor Red
    
    $successRate = if ($script:TestCount -gt 0) { 
        [math]::Round(($script:PassedTests / $script:TestCount) * 100, 1) 
    } else { 0 }
    
    Write-Host "Success Rate: $successRate%" -ForegroundColor $(if ($successRate -ge 90) { "Green" } elseif ($successRate -ge 70) { "Yellow" } else { "Red" })
    
    if ($script:FailedTests -gt 0) {
        Write-Host "`nFailed Tests:" -ForegroundColor Red
        foreach ($result in $script:TestResults) {
            if (!$result.Passed) {
                Write-Host "  ❌ $($result.Name)" -ForegroundColor Red
                if ($result.Details) {
                    Write-Host "     $($result.Details)" -ForegroundColor Gray
                }
            }
        }
    }
    
    Write-Host "`n" + "=" * 70 -ForegroundColor Gray
    
    if ($successRate -ge 90) {
        Write-Host "✅ DRY-RUN IMPLEMENTATION: EXCELLENT" -ForegroundColor Green
    } elseif ($successRate -ge 70) {
        Write-Host "⚠️ DRY-RUN IMPLEMENTATION: GOOD (some improvements needed)" -ForegroundColor Yellow
    } else {
        Write-Host "❌ DRY-RUN IMPLEMENTATION: NEEDS ATTENTION" -ForegroundColor Red
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-Host "🚀 DRY-RUN IMPLEMENTATION TEST SUITE V4.0" -ForegroundColor Magenta
    Write-Host "Testing comprehensive dry-run capabilities and safety protocols" -ForegroundColor White
    Write-Host "=" * 70 -ForegroundColor Gray
    
    # Execute all test suites
    Test-SafeCleanupDryRun
    Test-FinaltestDryRun
    Test-CriticalFileProtection
    Test-StagingAreaVerification
    Test-IncrementalProcessing
    
    # Show summary
    Show-TestSummary
    
    # Exit with appropriate code
    if ($script:FailedTests -eq 0) {
        exit 0
    } else {
        exit 1
    }
}
catch {
    Write-Error "💥 Test suite execution failed: $($_.Exception.Message)"
    Write-Error "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}
