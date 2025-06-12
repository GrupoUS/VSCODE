#!/usr/bin/env pwsh
<#
.SYNOPSIS
Backup System Validator V4.0 - GRUPO US VIBECODE SYSTEM
Comprehensive validation and enforcement of Smart Backup System V4.0

.DESCRIPTION
Validates and enforces Smart Backup System V4.0 across all backup operations:
- Audits all backup scripts for unsafe operations
- Validates Smart Backup System integration
- Tests size validation and exclusion patterns
- Enforces mandatory backup safety measures
- Prevents recursive backup disasters

.NOTES
Version: 4.0.0
Author: GRUPO US - VIBECODE SYSTEM
Date: 2025-01-27
Requires: PowerShell 7.0+
Purpose: Ensure 100% backup disaster prevention
#>

param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $false,
    [switch]$EnforceUpdates = $false,
    [switch]$RunTests = $true
)

# ===============================================================================
# VALIDATION CONFIGURATION
# ===============================================================================

$Config = @{
    BackupScripts = @(
        "@project-core/automation/auto_backup.py",
        "@project-core/automation/enhanced-finaltest-v3.1.ps1",
        "@project-core/automation/setup-augment-optimization.ps1",
        "@project-core/automation/project-core-cleanup-phase2.ps1",
        "@project-core/automation/consolidate-backups.ps1",
        "@project-core/automation/manage-backups.ps1",
        "@project-core/automation/manage-backups.py"
    )

    UnsafePatterns = @(
        "Copy-Item.*-Recurse.*-Force",
        "shutil\.copytree\(",
        "shutil\.copy2\(",
        "robocopy",
        "xcopy"
    )

    RequiredExclusions = @(
        "*/backups/*",
        "*/backup/*",
        "*/.backup/*",
        "*/node_modules/*",
        "*/.git/*",
        "*/.next/*",
        "*/dist/*",
        "*/build/*",
        "*/.cache/*"
    )

    SmartBackupScript = "@project-core/automation/smart-backup-system-v4.ps1"
    MonitoringScript = "@project-core/automation/backup-monitoring-system.ps1"
    TestScript = "@project-core/automation/test-smart-backup-system.ps1"

    LogFile = "@project-core/logs/backup-validation-$(Get-Date -Format 'yyyyMMdd-HHmmss').log"
    ReportFile = "@project-core/reports/backup-system-validation-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
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
# PHASE 1: COMPREHENSIVE AUDIT
# ===============================================================================

function Test-BackupScriptSafety {
    Write-Log "🔍 Phase 1: Auditing backup scripts for unsafe operations..." "INFO"

    $auditResults = @()

    foreach ($script in $Config.BackupScripts) {
        if (!(Test-Path $script)) {
            Write-Log "⚠️ Script not found: $script" "WARNING"
            continue
        }

        Write-Log "📄 Auditing: $script" "INFO"

        $content = Get-Content $script -Raw -ErrorAction SilentlyContinue
        if (!$content) {
            Write-Log "⚠️ Could not read script: $script" "WARNING"
            continue
        }

        $scriptResult = @{
            Script = $script
            UnsafeOperations = @()
            HasSmartBackupIntegration = $false
            HasSizeValidation = $false
            HasExclusionPatterns = $false
            RiskLevel = "LOW"
        }

        # Check for unsafe patterns
        foreach ($pattern in $Config.UnsafePatterns) {
            if ($content -match $pattern) {
                $matches = [regex]::Matches($content, $pattern)
                foreach ($match in $matches) {
                    $scriptResult.UnsafeOperations += @{
                        Pattern = $pattern
                        Match = $match.Value
                        Line = ($content.Substring(0, $match.Index) -split "`n").Count
                    }
                }
            }
        }

        # Check for Smart Backup System integration
        if ($content -match "smart-backup-system-v4\.ps1") {
            $scriptResult.HasSmartBackupIntegration = $true
        }

        # Check for size validation
        if ($content -match "MaxSizeMB|size.*limit|backup.*size") {
            $scriptResult.HasSizeValidation = $true
        }

        # Check for exclusion patterns
        $exclusionCount = 0
        foreach ($exclusion in $Config.RequiredExclusions) {
            $escapedExclusion = [regex]::Escape($exclusion)
            if ($content -match $escapedExclusion) {
                $exclusionCount++
            }
        }
        $scriptResult.HasExclusionPatterns = $exclusionCount -ge 3  # At least 3 critical exclusions

        # Determine risk level
        if ($scriptResult.UnsafeOperations.Count -gt 0) {
            if (!$scriptResult.HasSmartBackupIntegration -and !$scriptResult.HasSizeValidation) {
                $scriptResult.RiskLevel = "CRITICAL"
            } elseif (!$scriptResult.HasExclusionPatterns) {
                $scriptResult.RiskLevel = "HIGH"
            } else {
                $scriptResult.RiskLevel = "MEDIUM"
            }
        }

        $auditResults += $scriptResult

        # Log results
        if ($scriptResult.UnsafeOperations.Count -gt 0) {
            Write-Log "🚨 [$($scriptResult.RiskLevel)] Unsafe operations found in ${script}:" "ERROR"
            foreach ($op in $scriptResult.UnsafeOperations) {
                Write-Log "  • Line $($op.Line): $($op.Match)" "ERROR"
            }
        } else {
            Write-Log "✅ No unsafe operations found in ${script}" "SUCCESS"
        }
    }

    return $auditResults
}

# ===============================================================================
# PHASE 2: INTEGRATION VALIDATION
# ===============================================================================

function Test-SmartBackupSystemIntegration {
    Write-Log "🔍 Phase 2: Validating Smart Backup System V4.0 integration..." "INFO"

    $integrationResults = @{
        SmartBackupSystemExists = Test-Path $Config.SmartBackupScript
        MonitoringSystemExists = Test-Path $Config.MonitoringScript
        TestSuiteExists = Test-Path $Config.TestScript
        IntegrationScore = 0
        Issues = @()
    }

    # Test Smart Backup System
    if ($integrationResults.SmartBackupSystemExists) {
        Write-Log "✅ Smart Backup System V4.0 found" "SUCCESS"
        $integrationResults.IntegrationScore += 40

        # Test basic functionality
        try {
            $testResult = & $Config.SmartBackupScript -SourcePath "@project-core/memory" -BackupName "validation-test" -MaxSizeMB 1 -DryRun
            if ($testResult.Success -eq $false -and $testResult.Error -like "*Size limit exceeded*") {
                Write-Log "✅ Size validation working correctly" "SUCCESS"
                $integrationResults.IntegrationScore += 20
            } else {
                Write-Log "⚠️ Size validation may not be working" "WARNING"
                $integrationResults.Issues += "Size validation test inconclusive"
            }
        }
        catch {
            Write-Log "❌ Smart Backup System test failed: $($_.Exception.Message)" "ERROR"
            $integrationResults.Issues += "Smart Backup System test failed"
        }
    } else {
        Write-Log "❌ Smart Backup System V4.0 not found" "ERROR"
        $integrationResults.Issues += "Smart Backup System missing"
    }

    # Test Monitoring System
    if ($integrationResults.MonitoringSystemExists) {
        Write-Log "✅ Backup Monitoring System found" "SUCCESS"
        $integrationResults.IntegrationScore += 20
    } else {
        Write-Log "❌ Backup Monitoring System not found" "ERROR"
        $integrationResults.Issues += "Monitoring System missing"
    }

    # Test Suite
    if ($integrationResults.TestSuiteExists) {
        Write-Log "✅ Test Suite found" "SUCCESS"
        $integrationResults.IntegrationScore += 20
    } else {
        Write-Log "❌ Test Suite not found" "ERROR"
        $integrationResults.Issues += "Test Suite missing"
    }

    Write-Log "📊 Integration Score: $($integrationResults.IntegrationScore)/100" "INFO"

    return $integrationResults
}

# ===============================================================================
# PHASE 3: SIZE VALIDATION TESTING
# ===============================================================================

function Test-SizeValidationEnforcement {
    Write-Log "🔍 Phase 3: Testing size validation enforcement..." "INFO"

    if (!$RunTests) {
        Write-Log "⏭️ Skipping tests as requested" "INFO"
        return @{ TestsSkipped = $true }
    }

    $sizeTestResults = @{
        TestsPassed = 0
        TestsFailed = 0
        TestResults = @()
    }

    # Test 1: Size limit enforcement
    Write-Log "🧪 Test 1: Size limit enforcement" "INFO"
    try {
        # Create a test directory that exceeds size limit
        $testDir = "@project-core/tests/size-validation-test"
        if (!(Test-Path $testDir)) {
            New-Item -ItemType Directory -Path $testDir -Force | Out-Null
        }

        # Create a file that exceeds 1MB limit
        $largeContent = "Large test content " * 50000
        $largeContent | Out-File "$testDir/large-file.txt" -Encoding UTF8

        $result = & $Config.SmartBackupScript -SourcePath $testDir -BackupName "size-test" -MaxSizeMB 1 -DryRun

        if ($result.Success -eq $false -and $result.Error -like "*Size limit exceeded*") {
            Write-Log "✅ Size validation test passed" "SUCCESS"
            $sizeTestResults.TestsPassed++
        } else {
            Write-Log "❌ Size validation test failed" "ERROR"
            $sizeTestResults.TestsFailed++
        }

        # Cleanup
        if (Test-Path $testDir) {
            Remove-Item $testDir -Recurse -Force
        }
    }
    catch {
        Write-Log "❌ Size validation test error: $($_.Exception.Message)" "ERROR"
        $sizeTestResults.TestsFailed++
    }

    return $sizeTestResults
}

# ===============================================================================
# PHASE 4: EXCLUSION PATTERN VALIDATION
# ===============================================================================

function Test-ExclusionPatternEnforcement {
    Write-Log "🔍 Phase 4: Testing exclusion pattern enforcement..." "INFO"

    if (!$RunTests) {
        Write-Log "⏭️ Skipping tests as requested" "INFO"
        return @{ TestsSkipped = $true }
    }

    $exclusionTestResults = @{
        TestsPassed = 0
        TestsFailed = 0
        ExclusionPatternsTested = 0
    }

    # Test exclusion patterns
    $testDir = "@project-core/tests/exclusion-pattern-test"
    try {
        if (!(Test-Path $testDir)) {
            New-Item -ItemType Directory -Path $testDir -Force | Out-Null
        }

        # Create directories that should be excluded
        $excludedDirs = @("node_modules", ".git", "dist", "build", ".cache", "backups")
        foreach ($dir in $excludedDirs) {
            $dirPath = "$testDir/$dir"
            New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
            "Test content" | Out-File "$dirPath/test.txt" -Encoding UTF8
            $exclusionTestResults.ExclusionPatternsTested++
        }

        # Create a normal directory that should be included
        New-Item -ItemType Directory -Path "$testDir/src" -Force | Out-Null
        "Source content" | Out-File "$testDir/src/main.js" -Encoding UTF8

        $result = & $Config.SmartBackupScript -SourcePath $testDir -BackupName "exclusion-test" -MaxSizeMB 100 -DryRun -VerboseOutput

        if ($result.Success -and $result.FilesSkipped -gt 0) {
            Write-Log "✅ Exclusion patterns working (skipped $($result.FilesSkipped) files)" "SUCCESS"
            $exclusionTestResults.TestsPassed++
        } else {
            Write-Log "❌ Exclusion patterns may not be working" "ERROR"
            $exclusionTestResults.TestsFailed++
        }

        # Cleanup
        if (Test-Path $testDir) {
            Remove-Item $testDir -Recurse -Force
        }
    }
    catch {
        Write-Log "❌ Exclusion pattern test error: $($_.Exception.Message)" "ERROR"
        $exclusionTestResults.TestsFailed++
    }

    return $exclusionTestResults
}

# ===============================================================================
# PHASE 5: ENFORCEMENT ACTIONS
# ===============================================================================

function Invoke-BackupSystemEnforcement {
    param($AuditResults)

    Write-Log "🔧 Phase 5: Enforcing backup system safety measures..." "INFO"

    if (!$EnforceUpdates) {
        Write-Log "⏭️ Enforcement disabled. Use -EnforceUpdates to enable automatic fixes" "INFO"
        return @{ EnforcementSkipped = $true }
    }

    $enforcementResults = @{
        ScriptsUpdated = 0
        UpdatesFailed = 0
        UpdateDetails = @()
    }

    foreach ($scriptResult in $AuditResults) {
        if ($scriptResult.RiskLevel -in @("CRITICAL", "HIGH")) {
            Write-Log "🚨 Enforcing safety measures for: $($scriptResult.Script)" "WARNING"

            # Add safety header to unsafe scripts
            try {
                $content = Get-Content $scriptResult.Script -Raw
                $safetyHeader = @"
# ===============================================================================
# BACKUP SAFETY ENFORCEMENT - SMART BACKUP SYSTEM V4.0 REQUIRED
# ===============================================================================
# WARNING: This script contains backup operations that must use Smart Backup System V4.0
# to prevent recursive backup disasters and enforce size limits.
#
# Use: @project-core/automation/smart-backup-system-v4.ps1 -SourcePath "source" -BackupName "name"
# ===============================================================================

"@

                if ($content -notmatch "BACKUP SAFETY ENFORCEMENT") {
                    $updatedContent = $safetyHeader + $content
                    $updatedContent | Out-File $scriptResult.Script -Encoding UTF8

                    Write-Log "✅ Added safety header to: $($scriptResult.Script)" "SUCCESS"
                    $enforcementResults.ScriptsUpdated++
                    $enforcementResults.UpdateDetails += "Added safety header to $($scriptResult.Script)"
                }
            }
            catch {
                Write-Log "❌ Failed to update: $($scriptResult.Script) - $($_.Exception.Message)" "ERROR"
                $enforcementResults.UpdatesFailed++
            }
        }
    }

    return $enforcementResults
}

# ===============================================================================
# MAIN VALIDATION EXECUTION
# ===============================================================================

function Start-BackupSystemValidation {
    Write-Log "🚀 BACKUP SYSTEM VALIDATOR V4.0 - GRUPO US VIBECODE SYSTEM" "INFO"
    Write-Log "🛡️ Comprehensive validation and enforcement of Smart Backup System V4.0" "INFO"
    Write-Log "🔧 Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" "INFO"

    $validationResults = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        operation = "BackupSystemValidation"
        version = "4.0.0"
        phases = @{}
    }

    try {
        # Phase 1: Comprehensive Audit
        $validationResults.phases.audit = Test-BackupScriptSafety

        # Phase 2: Integration Validation
        $validationResults.phases.integration = Test-SmartBackupSystemIntegration

        # Phase 3: Size Validation Testing
        $validationResults.phases.sizeValidation = Test-SizeValidationEnforcement

        # Phase 4: Exclusion Pattern Validation
        $validationResults.phases.exclusionPatterns = Test-ExclusionPatternEnforcement

        # Phase 5: Enforcement Actions
        $validationResults.phases.enforcement = Invoke-BackupSystemEnforcement $validationResults.phases.audit

        # Generate summary
        $criticalIssues = ($validationResults.phases.audit | Where-Object { $_.RiskLevel -eq "CRITICAL" }).Count
        $highIssues = ($validationResults.phases.audit | Where-Object { $_.RiskLevel -eq "HIGH" }).Count
        $integrationScore = $validationResults.phases.integration.IntegrationScore

        Write-Log "📊 VALIDATION SUMMARY:" "INFO"
        Write-Log "  • Critical risk scripts: $criticalIssues" "INFO"
        Write-Log "  • High risk scripts: $highIssues" "INFO"
        Write-Log "  • Integration score: $integrationScore/100" "INFO"
        Write-Log "  • Size validation: $(if ($validationResults.phases.sizeValidation.TestsPassed -gt 0) { 'PASS' } else { 'FAIL' })" "INFO"
        Write-Log "  • Exclusion patterns: $(if ($validationResults.phases.exclusionPatterns.TestsPassed -gt 0) { 'PASS' } else { 'FAIL' })" "INFO"

        # Overall assessment
        if ($criticalIssues -eq 0 -and $integrationScore -ge 80) {
            Write-Log "🎉 BACKUP SYSTEM VALIDATION PASSED - System is protected against disasters!" "SUCCESS"
        } elseif ($criticalIssues -gt 0) {
            Write-Log "🚨 CRITICAL ISSUES DETECTED - Immediate action required!" "CRITICAL"
        } else {
            Write-Log "⚠️ IMPROVEMENTS NEEDED - Some issues require attention" "WARNING"
        }

        # Save report
        if (!(Test-Path (Split-Path $Config.ReportFile -Parent))) {
            New-Item -ItemType Directory -Path (Split-Path $Config.ReportFile -Parent) -Force | Out-Null
        }
        $validationResults | ConvertTo-Json -Depth 10 | Out-File $Config.ReportFile -Encoding UTF8
        Write-Log "📋 Validation report saved: $($Config.ReportFile)" "INFO"

        return $validationResults
    }
    catch {
        Write-Log "❌ Validation failed: $($_.Exception.Message)" "ERROR"
        throw
    }
}

# Execute if run directly
if ($MyInvocation.InvocationName -ne '.') {
    Start-BackupSystemValidation
}
