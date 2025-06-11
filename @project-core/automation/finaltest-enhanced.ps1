#!/usr/bin/env pwsh
# ===============================================================================
# ENHANCED !FINALTEST V3.1 - GRUPO US VIBECODE SYSTEM
# ===============================================================================

<#
.SYNOPSIS
Enhanced !finaltest - Comprehensive System Maintenance for GRUPO US VIBECODE SYSTEM V3.1

.DESCRIPTION
Quick execution script for the enhanced !finaltest system maintenance.
This script provides a simple interface to run comprehensive system maintenance
and optimization for the GRUPO US VIBECODE SYSTEM V3.1.

.PARAMETER DryRun
Run in dry-run mode to preview changes without making modifications

.PARAMETER Verbose
Enable verbose output for detailed logging

.PARAMETER Quick
Run only critical maintenance operations (faster execution)

.PARAMETER TaskDescription
Description of the task that was completed (optional, for legacy compatibility)

.EXAMPLE
.\finaltest-enhanced.ps1
# Run full system maintenance

.EXAMPLE
.\finaltest-enhanced.ps1 -DryRun
# Preview what would be changed without making modifications

.EXAMPLE
.\finaltest-enhanced.ps1 -Quick
# Run only critical maintenance operations

.NOTES
Version: 3.1.0
Author: GRUPO US - VIBECODE SYSTEM
Requires: PowerShell 7.0+
#>

[CmdletBinding()]
param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $false,
    [switch]$Quick = $false,
    [Parameter(Mandatory = $false)]
    [string]$TaskDescription = "Enhanced System Maintenance V3.1"
)

# Set error handling
$ErrorActionPreference = "Stop"

# Colors for output
$InfoColor = "Cyan"
$SuccessColor = "Green"
$ErrorColor = "Red"
$WarningColor = "Yellow"

# Display banner
Write-Host @"
🚀 ENHANCED !FINALTEST V3.1 - SYSTEM MAINTENANCE
================================================
GRUPO US VIBECODE SYSTEM - Comprehensive Maintenance
Task: $TaskDescription

"@ -ForegroundColor $InfoColor

# Check if enhanced script exists
$EnhancedScriptPath = "@project-core/automation/enhanced-finaltest-v3.1.ps1"

if (-not (Test-Path $EnhancedScriptPath)) {
    Write-Host "❌ Enhanced !finaltest script not found at: $EnhancedScriptPath" -ForegroundColor $ErrorColor
    Write-Host "Please ensure the GRUPO US VIBECODE SYSTEM V3.1 is properly installed." -ForegroundColor $WarningColor
    exit 1
}

try {
    # Import the enhanced script
    Write-Host "📋 Loading enhanced !finaltest V3.1..." -ForegroundColor $SuccessColor
    . $EnhancedScriptPath

    # Prepare execution parameters
    $ExecutionParams = @{
        DryRun = $DryRun
        Verbose = $Verbose
    }

    if ($Quick) {
        Write-Host "⚡ Quick mode: Running critical maintenance only..." -ForegroundColor $WarningColor
        
        # Quick mode - run only essential operations
        Write-Host "🔄 Initializing backup system..." -ForegroundColor $SuccessColor
        Initialize-Backup
        
        Write-Host "📝 Updating task-driven rules..." -ForegroundColor $SuccessColor
        Update-TaskDrivenRules
        
        Write-Host "🔄 Synchronizing project-core system..." -ForegroundColor $SuccessColor
        Sync-ProjectCoreSystem
        
        Write-Host "✅ Validating system integrity..." -ForegroundColor $SuccessColor
        Test-SystemValidation
        
        Write-Host "📊 Generating quick maintenance report..." -ForegroundColor $SuccessColor
        $QuickReport = @{
            timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
            mode = "Quick Maintenance"
            taskDescription = $TaskDescription
            operations = @("Task-driven rules", "System sync", "Validation")
            status = "✅ COMPLETED"
        }
        
        $QuickReportPath = "@project-core/reports/quick-maintenance-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        if (-not (Test-Path "@project-core/reports")) {
            New-Item -ItemType Directory -Path "@project-core/reports" -Force | Out-Null
        }
        $QuickReport | ConvertTo-Json -Depth 10 | Out-File $QuickReportPath -Encoding UTF8
        
        Write-Host "`n🎉 Quick maintenance completed successfully!" -ForegroundColor $SuccessColor
        Write-Host "📄 Report: $QuickReportPath" -ForegroundColor $WarningColor
    } else {
        # Full maintenance mode
        Write-Host "🔄 Running comprehensive system maintenance..." -ForegroundColor $SuccessColor
        
        # Execute the full enhanced finaltest
        $Result = Start-EnhancedFinalTest @ExecutionParams
        
        if ($Result) {
            Write-Host "`n🎉 Enhanced !finaltest V3.1 completed successfully!" -ForegroundColor $SuccessColor
            
            # Display key results
            if ($Result.summary.validationResults) {
                $PassedTests = ($Result.summary.validationResults | Where-Object { $_.Status -like "*PASSED*" }).Count
                $TotalTests = $Result.summary.validationResults.Count
                Write-Host "📊 Validation: $PassedTests/$TotalTests tests passed" -ForegroundColor $InfoColor
            }
            
            if ($Result.summary.cleanupResults) {
                Write-Host "🗑️ Cleanup: $($Result.summary.cleanupResults.Count) operations completed" -ForegroundColor $InfoColor
            }
        } else {
            Write-Host "`n⚠️ Enhanced !finaltest V3.1 completed with warnings" -ForegroundColor $WarningColor
        }
    }

    # Final system status check
    Write-Host "`n🔍 Final system status check..." -ForegroundColor $SuccessColor
    
    $CriticalFiles = @(
        "GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md",
        "@project-core/memory/master_rule.md",
        "@project-core/configs/mcp-master-unified.json"
    )
    
    $SystemHealthy = $true
    foreach ($File in $CriticalFiles) {
        if (Test-Path $File) {
            Write-Host "  ✅ $File" -ForegroundColor $SuccessColor
        } else {
            Write-Host "  ❌ $File" -ForegroundColor $ErrorColor
            $SystemHealthy = $false
        }
    }
    
    if ($SystemHealthy) {
        Write-Host "`n✅ GRUPO US VIBECODE SYSTEM V3.1: HEALTHY" -ForegroundColor $SuccessColor
        Write-Host "🚀 System ready for optimal development workflow!" -ForegroundColor $InfoColor
        Write-Host "📋 Task '$TaskDescription' maintenance completed successfully!" -ForegroundColor $InfoColor
    } else {
        Write-Host "`n⚠️ GRUPO US VIBECODE SYSTEM V3.1: NEEDS ATTENTION" -ForegroundColor $WarningColor
        Write-Host "Please check missing critical files above." -ForegroundColor $WarningColor
    }

    # Success exit
    exit 0
} catch {
    Write-Host "`n❌ Enhanced !finaltest execution failed: $($_.Exception.Message)" -ForegroundColor $ErrorColor
    Write-Host "Stack trace:" -ForegroundColor $ErrorColor
    Write-Host $_.ScriptStackTrace -ForegroundColor $ErrorColor
    
    # Error exit
    exit 1
}

<#
.NOTES
USAGE EXAMPLES:

# Standard maintenance (recommended monthly)
.\finaltest-enhanced.ps1

# Preview changes without making modifications
.\finaltest-enhanced.ps1 -DryRun

# Quick maintenance for daily use
.\finaltest-enhanced.ps1 -Quick

# Verbose output for troubleshooting
.\finaltest-enhanced.ps1 -Verbose

# Combination of options
.\finaltest-enhanced.ps1 -DryRun -Verbose

WHAT THIS SCRIPT DOES:

1. 🔄 Task-Driven Rule Updates
   - Updates self-correction log with session learnings
   - Refreshes global standards with new patterns
   - Synchronizes unified development environment rules

2. 🔄 Project-Core System Synchronization  
   - Validates all configuration files
   - Refreshes MCP server configurations
   - Updates environment specialization rules

3. 🗑️ Legacy System Cleanup (Full mode only)
   - Removes deprecated rule files and configurations
   - Cleans up outdated folders and unused files
   - Eliminates references to deprecated systems

4. ⚡ Performance Optimization (Full mode only)
   - Consolidates fragmented rule files
   - Removes redundant documentation
   - Optimizes file structure for faster access

5. ✅ System Validation
   - Validates critical system files
   - Tests unified system loading capability
   - Verifies cross-environment coordination protocols

The script maintains backward compatibility, creates backups before changes,
and generates comprehensive reports for audit purposes.

SAFETY FEATURES:
- Automatic backup creation before any changes
- Dry-run mode for safe preview
- Comprehensive validation and error handling
- Detailed logging and reporting
- Zero-downtime maintenance approach
#>
