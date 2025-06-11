# 🧪 GRUPO US VIBECODE SYSTEM V4.0 - MCP Configuration Validation
# COMPREHENSIVE MCP CONFIGURATION TESTING SCRIPT

param(
    [switch]$Detailed,
    [switch]$Fix,
    [switch]$Report
)

# Script Metadata
$ScriptVersion = "4.0.0"
$ScriptName = "MCP Configuration Validation"
$Author = "GRUPO US - VIBECODE SYSTEM"
$LastUpdated = "2025-01-27"

Write-Host "🧪 $ScriptName v$ScriptVersion" -ForegroundColor Cyan
Write-Host "Author: $Author | Updated: $LastUpdated" -ForegroundColor Gray
Write-Host "=" * 60 -ForegroundColor Cyan

# Configuration Paths
$ProjectCore = "@project-core"
$MasterMCPConfig = "$ProjectCore/configs/mcp-master-unified.json"
$VSCodeMCPConfig = "$ProjectCore/configs/ide/vscode/mcp.json"
$CursorMCPConfig = "$ProjectCore/configs/ide/cursor/mcp.json"
$VSCodeSettings = "$ProjectCore/configs/ide/vscode/settings.json"
$ActiveVSCodeMCP = ".vscode/mcp.json"
$ActiveCursorMCP = ".cursor/mcp.json"
$ActiveVSCodeSettings = ".vscode/settings.json"

# Validation Results
$ValidationResults = @{
    MasterConfig = $false
    VSCodeConfig = $false
    CursorConfig = $false
    AugmentSettings = $false
    MCPSettings = $false
    Synchronization = $false
    CrossEnvironment = $false
}

# Logging Function
function Write-ValidationLog {
    param(
        [string]$Message,
        [string]$Level = "Info",
        [string]$Color = "White"
    )

    $timestamp = Get-Date -Format "HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    switch ($Level) {
        "Pass" { Write-Host $logMessage -ForegroundColor Green }
        "Fail" { Write-Host $logMessage -ForegroundColor Red }
        "Warning" { Write-Host $logMessage -ForegroundColor Yellow }
        "Info" { Write-Host $logMessage -ForegroundColor $Color }
        default { Write-Host $logMessage -ForegroundColor White }
    }
}

function Test-MCPMasterConfiguration {
    Write-ValidationLog "🔍 Testing Master MCP Configuration..." -Level "Info" -Color "Cyan"

    if (!(Test-Path $MasterMCPConfig)) {
        Write-ValidationLog "❌ Master MCP config missing: $MasterMCPConfig" -Level "Fail"
        return $false
    }

    try {
        $config = Get-Content $MasterMCPConfig | ConvertFrom-Json

        # Check metadata
        if ($config.metadata.version -ne "4.0.0") {
            Write-ValidationLog "❌ Master MCP config version mismatch" -Level "Fail"
            return $false
        }

        # Check required servers
        $requiredServers = @("think-mcp-server", "sequential-thinking", "mcp-shrimp-task-manager")
        foreach ($server in $requiredServers) {
            if (!$config.mcpServers.$server) {
                Write-ValidationLog "❌ Missing server: $server" -Level "Fail"
                return $false
            }
        }

        # Check augment integration
        if (!$config.augmentIntegration) {
            Write-ValidationLog "❌ Missing Augment integration config" -Level "Fail"
            return $false
        }

        Write-ValidationLog "✅ Master MCP configuration valid" -Level "Pass"
        return $true
    }
    catch {
        Write-ValidationLog "❌ Master MCP config parse error: $($_.Exception.Message)" -Level "Fail"
        return $false
    }
}

function Test-VSCodeMCPConfiguration {
    Write-ValidationLog "🔍 Testing VS Code MCP Configuration..." -Level "Info" -Color "Cyan"

    if (!(Test-Path $VSCodeMCPConfig)) {
        Write-ValidationLog "❌ VS Code MCP config missing: $VSCodeMCPConfig" -Level "Fail"
        return $false
    }

    if (!(Test-Path $ActiveVSCodeMCP)) {
        Write-ValidationLog "❌ Active VS Code MCP config missing: $ActiveVSCodeMCP" -Level "Fail"
        return $false
    }

    try {
        $sourceConfig = Get-Content $VSCodeMCPConfig | ConvertFrom-Json
        $activeConfig = Get-Content $ActiveVSCodeMCP | ConvertFrom-Json

        # Check if synchronized
        if ($sourceConfig.metadata.version -ne $activeConfig.metadata.version) {
            Write-ValidationLog "❌ VS Code MCP configs out of sync" -Level "Fail"
            return $false
        }

        # Check augment integration
        if (!$sourceConfig.vsCodeSpecificConfig.augmentIntegration.enabled) {
            Write-ValidationLog "❌ Augment integration not enabled" -Level "Fail"
            return $false
        }

        Write-ValidationLog "✅ VS Code MCP configuration valid and synchronized" -Level "Pass"
        return $true
    }
    catch {
        Write-ValidationLog "❌ VS Code MCP config error: $($_.Exception.Message)" -Level "Fail"
        return $false
    }
}

function Test-CursorMCPConfiguration {
    Write-ValidationLog "🔍 Testing Cursor MCP Configuration..." -Level "Info" -Color "Cyan"

    if (!(Test-Path $CursorMCPConfig)) {
        Write-ValidationLog "❌ Cursor MCP config missing: $CursorMCPConfig" -Level "Fail"
        return $false
    }

    if (!(Test-Path $ActiveCursorMCP)) {
        Write-ValidationLog "❌ Active Cursor MCP config missing: $ActiveCursorMCP" -Level "Fail"
        return $false
    }

    try {
        $sourceConfig = Get-Content $CursorMCPConfig | ConvertFrom-Json
        $activeConfig = Get-Content $ActiveCursorMCP | ConvertFrom-Json

        # Check if synchronized
        if ($sourceConfig.metadata.version -ne $activeConfig.metadata.version) {
            Write-ValidationLog "❌ Cursor MCP configs out of sync" -Level "Fail"
            return $false
        }

        # Check required servers
        $requiredServers = @("mcp-shrimp-task-manager", "figma-mcp", "playwright-mcp", "tavily-mcp")
        foreach ($server in $requiredServers) {
            if (!$sourceConfig.mcpServers.$server) {
                Write-ValidationLog "❌ Missing Cursor server: $server" -Level "Fail"
                return $false
            }
        }

        Write-ValidationLog "✅ Cursor MCP configuration valid and synchronized" -Level "Pass"
        return $true
    }
    catch {
        Write-ValidationLog "❌ Cursor MCP config error: $($_.Exception.Message)" -Level "Fail"
        return $false
    }
}

function Test-AugmentSettings {
    Write-ValidationLog "🔍 Testing Augment Settings..." -Level "Info" -Color "Cyan"

    if (!(Test-Path $ActiveVSCodeSettings)) {
        Write-ValidationLog "❌ Active VS Code settings missing: $ActiveVSCodeSettings" -Level "Fail"
        return $false
    }

    try {
        $settings = Get-Content $ActiveVSCodeSettings | ConvertFrom-Json

        # Check Augment MCP settings
        $requiredAugmentSettings = @(
            "augment.mcp.enabled",
            "augment.mcp.configPath",
            "augment.mcp.autoStart",
            "augment.mcp.servers.thinkMcp",
            "augment.mcp.servers.sequentialThinking",
            "augment.mcp.servers.shrimpTaskManager"
        )

        foreach ($setting in $requiredAugmentSettings) {
            $value = $settings.$setting
            if ($null -eq $value -or $value -eq $false) {
                Write-ValidationLog "❌ Missing or disabled Augment setting: $setting" -Level "Fail"
                return $false
            }
        }

        # Check MCP general settings
        if (!$settings."mcp.enabled" -or !$settings."mcp.autoStart") {
            Write-ValidationLog "❌ MCP general settings not properly configured" -Level "Fail"
            return $false
        }

        Write-ValidationLog "✅ Augment settings properly configured" -Level "Pass"
        return $true
    }
    catch {
        Write-ValidationLog "❌ Augment settings error: $($_.Exception.Message)" -Level "Fail"
        return $false
    }
}

function Test-CrossEnvironmentIntegration {
    Write-ValidationLog "🔍 Testing Cross-Environment Integration..." -Level "Info" -Color "Cyan"

    try {
        # Check if both configs reference unified memory bank
        $vsCodeConfig = Get-Content $ActiveVSCodeMCP | ConvertFrom-Json
        $cursorConfig = Get-Content $ActiveCursorMCP | ConvertFrom-Json

        $vsCodeMemoryPath = $vsCodeConfig.unifiedIntegration.memoryBankIntegration.path
        $cursorMemoryPath = $cursorConfig.unifiedIntegration.memoryBankIntegration.path

        if ($vsCodeMemoryPath -ne $cursorMemoryPath) {
            Write-ValidationLog "❌ Memory bank paths not synchronized" -Level "Fail"
            return $false
        }

        # Check handoff protocols
        if (!$vsCodeConfig.workflowIntegration.handoffWorkflows.toCursor -or
            !$cursorConfig.workflowIntegration.handoffWorkflows.fromVSCode) {
            Write-ValidationLog "❌ Handoff protocols not properly configured" -Level "Fail"
            return $false
        }

        # Check shared server (mcp-shrimp-task-manager)
        if (!$vsCodeConfig.mcpServers."mcp-shrimp-task-manager" -or
            !$cursorConfig.mcpServers."mcp-shrimp-task-manager") {
            Write-ValidationLog "❌ Shared MCP server not configured in both environments" -Level "Fail"
            return $false
        }

        Write-ValidationLog "✅ Cross-environment integration properly configured" -Level "Pass"
        return $true
    }
    catch {
        Write-ValidationLog "❌ Cross-environment integration error: $($_.Exception.Message)" -Level "Fail"
        return $false
    }
}

function Repair-MCPConfiguration {
    Write-ValidationLog "🔧 Attempting to repair MCP configuration..." -Level "Info" -Color "Yellow"

    try {
        # Run synchronization script
        $syncScript = "$ProjectCore/scripts/sync-unified-environment.ps1"
        if (Test-Path $syncScript) {
            & $syncScript -Force
            Write-ValidationLog "✅ Synchronization script executed" -Level "Pass"
        } else {
            Write-ValidationLog "⚠️ Synchronization script not found" -Level "Warning"
        }

        return $true
    }
    catch {
        Write-ValidationLog "❌ Repair failed: $($_.Exception.Message)" -Level "Fail"
        return $false
    }
}

function Generate-ValidationReport {
    Write-ValidationLog "📊 Generating Validation Report..." -Level "Info" -Color "Cyan"

    $reportPath = "$ProjectCore/logs/mcp-validation-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

    $masterStatus = if($ValidationResults.MasterConfig){"PASS"}else{"FAIL"}
    $vsCodeStatus = if($ValidationResults.VSCodeConfig){"PASS"}else{"FAIL"}
    $cursorStatus = if($ValidationResults.CursorConfig){"PASS"}else{"FAIL"}
    $augmentStatus = if($ValidationResults.AugmentSettings){"PASS"}else{"FAIL"}
    $crossEnvStatus = if($ValidationResults.CrossEnvironment){"PASS"}else{"FAIL"}
    $overallStatus = if(($ValidationResults.Values | Where-Object {$_ -eq $false}).Count -eq 0){"ALL TESTS PASSED - MCP UNIFIED CONFIGURATION OPERATIONAL"}else{"SOME TESTS FAILED - CONFIGURATION NEEDS ATTENTION"}

    $report = @"
# MCP Configuration Validation Report
**Date**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Script Version**: $ScriptVersion

## Validation Results

- Master MCP Config: $masterStatus - $MasterMCPConfig
- VS Code MCP Config: $vsCodeStatus - $VSCodeMCPConfig
- Cursor MCP Config: $cursorStatus - $CursorMCPConfig
- Augment Settings: $augmentStatus - $ActiveVSCodeSettings
- Cross-Environment: $crossEnvStatus - Integration check

## Overall Status
$overallStatus

## Recommendations
$(if($ValidationResults.MasterConfig -eq $false){"- Fix Master MCP Configuration"}else{""})
$(if($ValidationResults.VSCodeConfig -eq $false){"- Synchronize VS Code MCP Configuration"}else{""})
$(if($ValidationResults.CursorConfig -eq $false){"- Synchronize Cursor MCP Configuration"}else{""})
$(if($ValidationResults.AugmentSettings -eq $false){"- Update Augment Settings"}else{""})
$(if($ValidationResults.CrossEnvironment -eq $false){"- Fix Cross-Environment Integration"}else{""})
"@

    $report | Set-Content $reportPath
    Write-ValidationLog "📄 Report saved to: $reportPath" -Level "Info"
}

# Main Execution
try {
    Write-ValidationLog "🚀 Starting MCP Configuration Validation..." -Level "Info" -Color "Cyan"

    # Run all tests
    $ValidationResults.MasterConfig = Test-MCPMasterConfiguration
    $ValidationResults.VSCodeConfig = Test-VSCodeMCPConfiguration
    $ValidationResults.CursorConfig = Test-CursorMCPConfiguration
    $ValidationResults.AugmentSettings = Test-AugmentSettings
    $ValidationResults.CrossEnvironment = Test-CrossEnvironmentIntegration

    # Calculate overall result
    $failedTests = ($ValidationResults.Values | Where-Object {$_ -eq $false}).Count
    $totalTests = $ValidationResults.Count
    $passedTests = $totalTests - $failedTests

    Write-Host ""
    Write-Host "📊 VALIDATION SUMMARY" -ForegroundColor Cyan
    Write-Host "=" * 40 -ForegroundColor Cyan
    Write-Host "✅ Passed: $passedTests/$totalTests" -ForegroundColor Green
    Write-Host "❌ Failed: $failedTests/$totalTests" -ForegroundColor Red
    Write-Host ""

    if ($failedTests -eq 0) {
        Write-Host "🎉 ALL TESTS PASSED - MCP UNIFIED CONFIGURATION OPERATIONAL!" -ForegroundColor Green
        Write-Host "🚀 Augment Extension and Cursor should now detect MCP servers" -ForegroundColor Green
        $exitCode = 0
    } else {
        Write-Host "❌ SOME TESTS FAILED - CONFIGURATION NEEDS ATTENTION" -ForegroundColor Red

        if ($Fix) {
            Write-Host ""
            Write-Host "🔧 ATTEMPTING AUTOMATIC REPAIR..." -ForegroundColor Yellow
            if (Repair-MCPConfiguration) {
                Write-Host "✅ Repair completed - please re-run validation" -ForegroundColor Green
            } else {
                Write-Host "❌ Repair failed - manual intervention required" -ForegroundColor Red
            }
        } else {
            Write-Host "💡 Use -Fix parameter to attempt automatic repair" -ForegroundColor Yellow
        }

        $exitCode = 1
    }

    if ($Report) {
        Generate-ValidationReport
    }

    Write-Host ""
    Write-Host "📋 NEXT STEPS:" -ForegroundColor Cyan
    Write-Host "1. Restart VS Code to reload Augment configuration" -ForegroundColor White
    Write-Host "2. Restart Cursor to reload MCP configuration" -ForegroundColor White
    Write-Host "3. Test MCP server detection in both environments" -ForegroundColor White
    Write-Host "4. Verify cross-environment handoff functionality" -ForegroundColor White

    exit $exitCode
}
catch {
    Write-ValidationLog "❌ Validation script error: $($_.Exception.Message)" -Level "Fail"
    exit 1
}
finally {
    Write-Host "=" * 60 -ForegroundColor Cyan
}
