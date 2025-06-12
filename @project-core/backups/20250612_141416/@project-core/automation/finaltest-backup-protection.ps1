#!/usr/bin/env pwsh
<#
.SYNOPSIS
Final Test - Backup Protection Validation V4.0
Comprehensive validation of Smart Backup System V4.0 implementation

.DESCRIPTION
Executes comprehensive validation of backup disaster prevention:
- Validates all backup scripts use Smart Backup System V4.0
- Tests size validation and exclusion patterns
- Confirms recursive backup prevention
- Validates monitoring system functionality
- Generates comprehensive protection report

.NOTES
Version: 4.0.0
Author: GRUPO US - VIBECODE SYSTEM
Date: 2025-01-27
Requires: PowerShell 7.0+
Purpose: Final validation of backup disaster prevention system
#>

param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $false,
    [switch]$GenerateReport = $true
)

# ===============================================================================
# FINAL TEST CONFIGURATION
# ===============================================================================

$Config = @{
    TestSuite = "@project-core/automation/test-smart-backup-system.ps1"
    Validator = "@project-core/automation/backup-system-validator-v4.ps1"
    Monitoring = "@project-core/automation/backup-monitoring-system.ps1"
    SmartBackup = "@project-core/automation/smart-backup-system-v4.ps1"

    LogFile = "@project-core/logs/finaltest-backup-protection-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    ReportFile = "@project-core/reports/finaltest-backup-protection-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"

    RequiredComponents = @(
        "Smart Backup System V4.0",
        "Backup Monitoring System",
        "Test Suite",
        "Backup System Validator"
    )

    SuccessCriteria = @{
        MinTestSuccessRate = 80
        MaxHighRiskScripts = 2
        MinIntegrationScore = 80
        RequiredExclusionPatterns = @("*/backups/*", "*/node_modules/*", "*/.git/*")
    }
}

# ===============================================================================
# LOGGING AND UTILITIES
# ===============================================================================

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"

    switch ($Level) {
        "CRITICAL" { Write-Host $logEntry -ForegroundColor Magenta }
        "ERROR" { Write-Host $logEntry -ForegroundColor Red }
        "WARNING" { Write-Host $logEntry -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        "INFO" { Write-Host $logEntry -ForegroundColor Cyan }
        default { Write-Host $logEntry -ForegroundColor White }
    }

    if (!(Test-Path (Split-Path $Config.LogFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $Config.LogFile -Parent) -Force | Out-Null
    }
    $logEntry | Out-File $Config.LogFile -Append -Encoding UTF8
}

# ===============================================================================
# VALIDATION PHASES
# ===============================================================================

function Test-ComponentAvailability {
    Write-Log "🔍 Phase 1: Testing component availability..." "INFO"

    $componentResults = @{}

    foreach ($component in $Config.RequiredComponents) {
        $scriptPath = switch ($component) {
            "Smart Backup System V4.0" { $Config.SmartBackup }
            "Backup Monitoring System" { $Config.Monitoring }
            "Test Suite" { $Config.TestSuite }
            "Backup System Validator" { $Config.Validator }
        }

        if (Test-Path $scriptPath) {
            Write-Log "✅ ${component}: Available" "SUCCESS"
            $componentResults[$component] = @{ Available = $true; Path = $scriptPath }
        } else {
            Write-Log "❌ ${component}: Missing" "ERROR"
            $componentResults[$component] = @{ Available = $false; Path = $scriptPath }
        }
    }

    return $componentResults
}

function Test-BackupSystemValidation {
    Write-Log "🔍 Phase 2: Running backup system validation..." "INFO"

    try {
        $validationResult = & $Config.Validator -DryRun:$DryRun -EnforceUpdates:$false

        $validationSummary = @{
            CriticalRiskScripts = ($validationResult.phases.audit | Where-Object { $_.RiskLevel -eq "CRITICAL" }).Count
            HighRiskScripts = ($validationResult.phases.audit | Where-Object { $_.RiskLevel -eq "HIGH" }).Count
            IntegrationScore = $validationResult.phases.integration.IntegrationScore
            SizeValidationWorking = $validationResult.phases.sizeValidation.TestsPassed -gt 0
            ExclusionPatternsWorking = $validationResult.phases.exclusionPatterns.TestsPassed -gt 0
        }

        Write-Log "📊 Validation Results:" "INFO"
        Write-Log "  • Critical risk scripts: $($validationSummary.CriticalRiskScripts)" "INFO"
        Write-Log "  • High risk scripts: $($validationSummary.HighRiskScripts)" "INFO"
        Write-Log "  • Integration score: $($validationSummary.IntegrationScore)/100" "INFO"
        Write-Log "  • Size validation: $(if ($validationSummary.SizeValidationWorking) { 'WORKING' } else { 'FAILED' })" "INFO"
        Write-Log "  • Exclusion patterns: $(if ($validationSummary.ExclusionPatternsWorking) { 'WORKING' } else { 'FAILED' })" "INFO"

        return $validationSummary
    }
    catch {
        Write-Log "❌ Validation failed: $($_.Exception.Message)" "ERROR"
        return @{ Error = $_.Exception.Message }
    }
}

function Test-SmartBackupSystemFunctionality {
    Write-Log "🔍 Phase 3: Testing Smart Backup System functionality..." "INFO"

    try {
        $testResult = & $Config.TestSuite -DryRun:$DryRun

        $testSummary = @{
            TotalTests = $testResult.summary.totalTests
            TestsPassed = $testResult.summary.passed
            TestsFailed = $testResult.summary.failed
            SuccessRate = $testResult.summary.successRate
        }

        Write-Log "📊 Test Results:" "INFO"
        Write-Log "  • Total tests: $($testSummary.TotalTests)" "INFO"
        Write-Log "  • Tests passed: $($testSummary.TestsPassed)" "INFO"
        Write-Log "  • Tests failed: $($testSummary.TestsFailed)" "INFO"
        Write-Log "  • Success rate: $($testSummary.SuccessRate)%" "INFO"

        return $testSummary
    }
    catch {
        Write-Log "❌ Test suite failed: $($_.Exception.Message)" "ERROR"
        return @{ Error = $_.Exception.Message }
    }
}

function Test-MonitoringSystemFunctionality {
    Write-Log "🔍 Phase 4: Testing monitoring system functionality..." "INFO"

    try {
        $monitoringResult = & $Config.Monitoring -BackupRoot "@project-core/backups" -MaxTotalSizeGB 1 -MaxIndividualSizeMB 100 -DryRun:$DryRun

        $monitoringSummary = @{
            TotalSizeGB = $monitoringResult.summary.totalSizeGB
            DirectoryCount = $monitoringResult.summary.directoryCount
            IssueCount = $monitoringResult.summary.issueCount
            RecommendationCount = $monitoringResult.summary.recommendationCount
        }

        Write-Log "📊 Monitoring Results:" "INFO"
        Write-Log "  • Total backup size: $($monitoringSummary.TotalSizeGB) GB" "INFO"
        Write-Log "  • Backup directories: $($monitoringSummary.DirectoryCount)" "INFO"
        Write-Log "  • Issues detected: $($monitoringSummary.IssueCount)" "INFO"
        Write-Log "  • Recommendations: $($monitoringSummary.RecommendationCount)" "INFO"

        return $monitoringSummary
    }
    catch {
        Write-Log "❌ Monitoring system failed: $($_.Exception.Message)" "ERROR"
        return @{ Error = $_.Exception.Message }
    }
}

function Test-SuccessCriteria {
    param(
        $ComponentResults,
        $ValidationResults,
        $TestResults,
        $MonitoringResults
    )

    Write-Log "🔍 Phase 5: Evaluating success criteria..." "INFO"

    $criteriaResults = @{
        ComponentAvailability = $true
        ValidationCriteria = $true
        TestCriteria = $true
        MonitoringCriteria = $true
        OverallSuccess = $true
        Issues = @()
    }

    # Check component availability
    foreach ($component in $Config.RequiredComponents) {
        if (!$ComponentResults[$component].Available) {
            $criteriaResults.ComponentAvailability = $false
            $criteriaResults.Issues += "Missing component: $component"
        }
    }

    # Check validation criteria
    if ($ValidationResults.HighRiskScripts -gt $Config.SuccessCriteria.MaxHighRiskScripts) {
        $criteriaResults.ValidationCriteria = $false
        $criteriaResults.Issues += "Too many high-risk scripts: $($ValidationResults.HighRiskScripts) > $($Config.SuccessCriteria.MaxHighRiskScripts)"
    }

    if ($ValidationResults.IntegrationScore -lt $Config.SuccessCriteria.MinIntegrationScore) {
        $criteriaResults.ValidationCriteria = $false
        $criteriaResults.Issues += "Integration score too low: $($ValidationResults.IntegrationScore) < $($Config.SuccessCriteria.MinIntegrationScore)"
    }

    # Check test criteria
    if ($TestResults.SuccessRate -lt $Config.SuccessCriteria.MinTestSuccessRate) {
        $criteriaResults.TestCriteria = $false
        $criteriaResults.Issues += "Test success rate too low: $($TestResults.SuccessRate)% < $($Config.SuccessCriteria.MinTestSuccessRate)%"
    }

    # Check monitoring criteria
    if ($MonitoringResults.IssueCount -gt 0) {
        $criteriaResults.MonitoringCriteria = $false
        $criteriaResults.Issues += "Monitoring detected $($MonitoringResults.IssueCount) issues"
    }

    # Overall success
    $criteriaResults.OverallSuccess = $criteriaResults.ComponentAvailability -and
                                     $criteriaResults.ValidationCriteria -and
                                     $criteriaResults.TestCriteria -and
                                     $criteriaResults.MonitoringCriteria

    return $criteriaResults
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-FinalTestBackupProtection {
    Write-Log "🚀 FINAL TEST - BACKUP PROTECTION VALIDATION V4.0" "INFO"
    Write-Log "🛡️ Comprehensive validation of Smart Backup System V4.0 implementation" "INFO"
    Write-Log "🔧 Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" "INFO"

    $finalResults = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        operation = "FinalTestBackupProtection"
        version = "4.0.0"
        mode = if ($DryRun) { "DRY_RUN" } else { "LIVE" }
        phases = @{}
    }

    try {
        # Phase 1: Component Availability
        $finalResults.phases.components = Test-ComponentAvailability

        # Phase 2: Backup System Validation
        $finalResults.phases.validation = Test-BackupSystemValidation

        # Phase 3: Smart Backup System Testing
        $finalResults.phases.testing = Test-SmartBackupSystemFunctionality

        # Phase 4: Monitoring System Testing
        $finalResults.phases.monitoring = Test-MonitoringSystemFunctionality

        # Phase 5: Success Criteria Evaluation
        $finalResults.phases.criteria = Test-SuccessCriteria $finalResults.phases.components $finalResults.phases.validation $finalResults.phases.testing $finalResults.phases.monitoring

        # Generate final assessment
        if ($finalResults.phases.criteria.OverallSuccess) {
            Write-Log "🎉 FINAL TEST PASSED - Smart Backup System V4.0 is fully operational!" "SUCCESS"
            Write-Log "🛡️ System is protected against backup disasters" "SUCCESS"
            $finalResults.result = "SUCCESS"
            $finalResults.message = "Smart Backup System V4.0 validation completed successfully"
        } else {
            Write-Log "⚠️ FINAL TEST ISSUES DETECTED" "WARNING"
            foreach ($issue in $finalResults.phases.criteria.Issues) {
                Write-Log "  • $issue" "WARNING"
            }
            $finalResults.result = "ISSUES_DETECTED"
            $finalResults.message = "Some issues require attention"
        }

        # Generate report
        if ($GenerateReport) {
            if (!(Test-Path (Split-Path $Config.ReportFile -Parent))) {
                New-Item -ItemType Directory -Path (Split-Path $Config.ReportFile -Parent) -Force | Out-Null
            }
            $finalResults | ConvertTo-Json -Depth 10 | Out-File $Config.ReportFile -Encoding UTF8
            Write-Log "📋 Final test report saved: $($Config.ReportFile)" "INFO"
        }

        return $finalResults
    }
    catch {
        Write-Log "❌ Final test failed: $($_.Exception.Message)" "ERROR"
        throw
    }
}

# Execute if run directly
if ($MyInvocation.InvocationName -ne '.') {
    Start-FinalTestBackupProtection
}
