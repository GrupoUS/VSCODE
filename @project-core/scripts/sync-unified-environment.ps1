# 🚀 GRUPO US VIBECODE SYSTEM V4.0 - UNIFIED ENVIRONMENT SYNCHRONIZATION
# MANDATORY SYNCHRONIZATION SCRIPT FOR VS CODE AND CURSOR

param(
    [switch]$Force,
    [switch]$Validate,
    [switch]$Monitor,
    [switch]$Emergency,
    [string]$LogLevel = "Info"
)

# Script Metadata
$ScriptVersion = "4.0.0"
$ScriptName = "Unified Environment Synchronization"
$Author = "GRUPO US - VIBECODE SYSTEM"
$LastUpdated = "2025-01-27"

Write-Host "🚀 $ScriptName v$ScriptVersion" -ForegroundColor Cyan
Write-Host "Author: $Author | Updated: $LastUpdated" -ForegroundColor Gray
Write-Host "=" * 60 -ForegroundColor Gray

# Configuration Paths
$ProjectCore = "@project-core"
$VSCodeConfigPath = "$ProjectCore/configs/ide/vscode"
$CursorConfigPath = "$ProjectCore/configs/ide/cursor"
$SharedConfigPath = "$ProjectCore/configs/ide/shared"
$MemoryPath = "$ProjectCore/memory"
$RulesPath = "$ProjectCore/rules"
$BackupPath = "$ProjectCore/backups/sync-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# Logging Function
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "Info",
        [string]$Color = "White"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    # Console output with color
    switch ($Level) {
        "Error" { Write-Host $logMessage -ForegroundColor Red }
        "Warning" { Write-Host $logMessage -ForegroundColor Yellow }
        "Success" { Write-Host $logMessage -ForegroundColor Green }
        "Info" { Write-Host $logMessage -ForegroundColor $Color }
        default { Write-Host $logMessage -ForegroundColor White }
    }

    # Log to file
    $logFile = "$ProjectCore/logs/sync-$(Get-Date -Format 'yyyyMMdd').log"
    if (!(Test-Path (Split-Path $logFile))) {
        New-Item -ItemType Directory -Path (Split-Path $logFile) -Force | Out-Null
    }
    Add-Content -Path $logFile -Value $logMessage
}

# Test Functions
function Test-ProjectStructure {
    Write-Log "🔍 Testing project structure..." -Level "Info" -Color "Cyan"

    $requiredPaths = @(
        "$ProjectCore/memory/master_rule.md",
        "$ProjectCore/rules/00-vibecode-system-v4-master.md",
        "$VSCodeConfigPath/settings.json",
        "$CursorConfigPath/.cursorrules",
        "$CursorConfigPath/mcp.json",
        "$SharedConfigPath/unified-config.json"
    )

    $missingPaths = @()
    foreach ($path in $requiredPaths) {
        if (!(Test-Path $path)) {
            $missingPaths += $path
            Write-Log "❌ Missing: $path" -Level "Error"
        } else {
            Write-Log "✅ Found: $path" -Level "Success"
        }
    }

    if ($missingPaths.Count -gt 0) {
        Write-Log "❌ Project structure validation FAILED" -Level "Error"
        return $false
    }

    Write-Log "✅ Project structure validation PASSED" -Level "Success"
    return $true
}

function Test-ConfigurationSync {
    Write-Log "🔍 Testing configuration synchronization..." -Level "Info" -Color "Cyan"

    $syncChecks = @{
        "VS Code Settings" = @{
            Source = "$VSCodeConfigPath/settings.json"
            Target = ".vscode/settings.json"
        }
        "VS Code MCP" = @{
            Source = "$VSCodeConfigPath/mcp.json"
            Target = ".vscode/mcp.json"
        }
        "Cursor Rules" = @{
            Source = "$CursorConfigPath/.cursorrules"
            Target = ".cursorrules"
        }
        "Cursor MCP" = @{
            Source = "$CursorConfigPath/mcp.json"
            Target = ".cursor/mcp.json"
        }
    }

    $syncFailures = @()
    foreach ($check in $syncChecks.GetEnumerator()) {
        $source = $check.Value.Source
        $target = $check.Value.Target

        if (!(Test-Path $source)) {
            Write-Log "❌ Source missing: $source" -Level "Error"
            $syncFailures += $check.Key
            continue
        }

        if (!(Test-Path $target)) {
            Write-Log "⚠️ Target missing: $target" -Level "Warning"
            $syncFailures += $check.Key
            continue
        }

        # Compare file hashes
        $sourceHash = Get-FileHash $source -Algorithm SHA256
        $targetHash = Get-FileHash $target -Algorithm SHA256

        if ($sourceHash.Hash -ne $targetHash.Hash) {
            Write-Log "⚠️ Files out of sync: $($check.Key)" -Level "Warning"
            $syncFailures += $check.Key
        } else {
            Write-Log "✅ Synchronized: $($check.Key)" -Level "Success"
        }
    }

    if ($syncFailures.Count -gt 0) {
        Write-Log "❌ Configuration sync validation FAILED" -Level "Error"
        return $false
    }

    Write-Log "✅ Configuration sync validation PASSED" -Level "Success"
    return $true
}

function Test-MemoryBankIntegrity {
    Write-Log "🔍 Testing memory bank integrity..." -Level "Info" -Color "Cyan"

    $memoryFiles = @(
        "$MemoryPath/master_rule.md",
        "$MemoryPath/self_correction_log.md",
        "$MemoryPath/global-standards.md"
    )

    $integrityFailures = @()
    foreach ($file in $memoryFiles) {
        if (!(Test-Path $file)) {
            Write-Log "❌ Memory file missing: $file" -Level "Error"
            $integrityFailures += $file
        } else {
            # Check if file is not empty
            $content = Get-Content $file -Raw
            if ([string]::IsNullOrWhiteSpace($content)) {
                Write-Log "❌ Memory file empty: $file" -Level "Error"
                $integrityFailures += $file
            } else {
                Write-Log "✅ Memory file valid: $file" -Level "Success"
            }
        }
    }

    if ($integrityFailures.Count -gt 0) {
        Write-Log "❌ Memory bank integrity validation FAILED" -Level "Error"
        return $false
    }

    Write-Log "✅ Memory bank integrity validation PASSED" -Level "Success"
    return $true
}

function Test-UnifiedCompliance {
    Write-Log "🔍 Running unified compliance check..." -Level "Info" -Color "Cyan"

    $structureValid = Test-ProjectStructure
    $syncValid = Test-ConfigurationSync
    $memoryValid = Test-MemoryBankIntegrity

    $overallCompliance = $structureValid -and $syncValid -and $memoryValid

    if ($overallCompliance) {
        Write-Log "✅ UNIFIED COMPLIANCE VERIFIED" -Level "Success"
    } else {
        Write-Log "❌ UNIFIED COMPLIANCE FAILED" -Level "Error"
    }

    return $overallCompliance
}

# Synchronization Functions
function Sync-VSCodeConfiguration {
    Write-Log "🔄 Synchronizing VS Code configuration..." -Level "Info" -Color "Cyan"

    try {
        # Ensure .vscode directory exists
        if (!(Test-Path ".vscode")) {
            New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null
            Write-Log "📁 Created .vscode directory" -Level "Info"
        }

        # Copy VS Code settings
        Copy-Item "$VSCodeConfigPath/settings.json" ".vscode/settings.json" -Force
        Write-Log "✅ VS Code settings synchronized" -Level "Success"

        # Copy VS Code MCP configuration
        if (Test-Path "$VSCodeConfigPath/mcp.json") {
            Copy-Item "$VSCodeConfigPath/mcp.json" ".vscode/mcp.json" -Force
            Write-Log "✅ VS Code MCP configuration synchronized" -Level "Success"
        } else {
            Write-Log "⚠️ VS Code MCP configuration not found" -Level "Warning"
        }

        return $true
    }
    catch {
        Write-Log "❌ VS Code synchronization failed: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Sync-CursorConfiguration {
    Write-Log "🔄 Synchronizing Cursor configuration..." -Level "Info" -Color "Cyan"

    try {
        # Ensure .cursor directory exists
        if (!(Test-Path ".cursor")) {
            New-Item -ItemType Directory -Path ".cursor" -Force | Out-Null
            Write-Log "📁 Created .cursor directory" -Level "Info"
        }

        # Copy Cursor rules
        Copy-Item "$CursorConfigPath/.cursorrules" ".cursorrules" -Force
        Write-Log "✅ Cursor rules synchronized" -Level "Success"

        # Copy Cursor MCP configuration
        Copy-Item "$CursorConfigPath/mcp.json" ".cursor/mcp.json" -Force
        Write-Log "✅ Cursor MCP configuration synchronized" -Level "Success"

        return $true
    }
    catch {
        Write-Log "❌ Cursor synchronization failed: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Sync-UnifiedEnvironment {
    Write-Log "🚀 Starting unified environment synchronization..." -Level "Info" -Color "Cyan"

    # Create backup if not in emergency mode
    if (!$Emergency) {
        Write-Log "💾 Creating backup..." -Level "Info"
        if (!(Test-Path $BackupPath)) {
            New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
        }

        # Backup existing configurations
        if (Test-Path ".vscode/settings.json") {
            Copy-Item ".vscode/settings.json" "$BackupPath/vscode-settings.json" -Force
        }
        if (Test-Path ".cursorrules") {
            Copy-Item ".cursorrules" "$BackupPath/cursorrules" -Force
        }
        if (Test-Path ".cursor/mcp.json") {
            Copy-Item ".cursor/mcp.json" "$BackupPath/cursor-mcp.json" -Force
        }
        Write-Log "✅ Backup created at: $BackupPath" -Level "Success"
    }

    # Perform synchronization
    $vsCodeSync = Sync-VSCodeConfiguration
    $cursorSync = Sync-CursorConfiguration

    $syncSuccess = $vsCodeSync -and $cursorSync

    if ($syncSuccess) {
        Write-Log "✅ UNIFIED ENVIRONMENT SYNCHRONIZED SUCCESSFULLY" -Level "Success"

        # Update sync status
        $syncStatus = @{
            LastSync = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Version = $ScriptVersion
            Status = "SUCCESS"
            VSCodeSync = $vsCodeSync
            CursorSync = $cursorSync
        }

        $syncStatus | ConvertTo-Json | Set-Content "$ProjectCore/logs/last-sync-status.json"

    } else {
        Write-Log "❌ UNIFIED ENVIRONMENT SYNCHRONIZATION FAILED" -Level "Error"

        if ($Force) {
            Write-Log "⚠️ Force mode enabled - attempting emergency restoration..." -Level "Warning"
            return Restore-UnifiedEnvironment
        }
    }

    return $syncSuccess
}

function Force-UnifiedCompliance {
    Write-Log "🚨 FORCING UNIFIED COMPLIANCE..." -Level "Warning"

    # Force synchronization
    $syncResult = Sync-UnifiedEnvironment

    # Validate after forced sync
    $complianceResult = Test-UnifiedCompliance

    if ($complianceResult) {
        Write-Log "✅ FORCED COMPLIANCE SUCCESSFUL" -Level "Success"
    } else {
        Write-Log "❌ FORCED COMPLIANCE FAILED - MANUAL INTERVENTION REQUIRED" -Level "Error"
    }

    return $complianceResult
}

function Restore-UnifiedEnvironment {
    Write-Log "🚨 EMERGENCY RESTORATION INITIATED" -Level "Warning"

    try {
        # Remove existing configurations
        if (Test-Path ".vscode/settings.json") {
            Remove-Item ".vscode/settings.json" -Force
        }
        if (Test-Path ".cursorrules") {
            Remove-Item ".cursorrules" -Force
        }
        if (Test-Path ".cursor/mcp.json") {
            Remove-Item ".cursor/mcp.json" -Force
        }

        # Force fresh synchronization
        $Emergency = $true
        $restoreResult = Sync-UnifiedEnvironment

        # Validate restoration
        $validationResult = Test-UnifiedCompliance

        if ($restoreResult -and $validationResult) {
            Write-Log "✅ EMERGENCY RESTORATION SUCCESSFUL" -Level "Success"
            return $true
        } else {
            Write-Log "❌ EMERGENCY RESTORATION FAILED" -Level "Error"
            return $false
        }
    }
    catch {
        Write-Log "❌ Emergency restoration error: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Start-ContinuousMonitoring {
    Write-Log "👁️ Starting continuous monitoring..." -Level "Info" -Color "Cyan"

    while ($true) {
        try {
            if (!(Test-UnifiedCompliance)) {
                Write-Log "🚨 COMPLIANCE VIOLATION DETECTED" -Level "Warning"

                # Attempt automatic correction
                $correctionResult = Force-UnifiedCompliance

                if ($correctionResult) {
                    Write-Log "✅ Automatic correction successful" -Level "Success"
                } else {
                    Write-Log "❌ Automatic correction failed - alerting..." -Level "Error"
                    # Here you could add alerting mechanisms (email, Slack, etc.)
                }

                # Log the incident
                $incident = @{
                    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    Type = "Compliance Violation"
                    Action = "Automatic Correction"
                    Result = if ($correctionResult) { "Success" } else { "Failed" }
                }

                Add-Content "$MemoryPath/self_correction_log.md" @"

## Compliance Violation Incident - $($incident.Timestamp)
**Type**: $($incident.Type)
**Action**: $($incident.Action)
**Result**: $($incident.Result)
**Prevention**: Enhanced monitoring and automatic correction
"@
            } else {
                Write-Log "✅ Compliance check passed" -Level "Success"
            }

            Start-Sleep -Seconds 30
        }
        catch {
            Write-Log "❌ Monitoring error: $($_.Exception.Message)" -Level "Error"
            Start-Sleep -Seconds 60
        }
    }
}

# Main Execution Logic
try {
    if ($Emergency) {
        Write-Log "🚨 EMERGENCY MODE ACTIVATED" -Level "Warning"
        $result = Restore-UnifiedEnvironment
        exit $(if ($result) { 0 } else { 1 })
    }

    if ($Validate) {
        Write-Log "🔍 VALIDATION MODE ACTIVATED" -Level "Info" -Color "Cyan"
        $result = Test-UnifiedCompliance
        exit $(if ($result) { 0 } else { 1 })
    }

    if ($Monitor) {
        Write-Log "👁️ MONITORING MODE ACTIVATED" -Level "Info" -Color "Cyan"
        Start-ContinuousMonitoring
        # This will run indefinitely
    }

    # Default: Synchronization mode
    Write-Log "🔄 SYNCHRONIZATION MODE ACTIVATED" -Level "Info" -Color "Cyan"

    if ($Force) {
        $result = Force-UnifiedCompliance
    } else {
        $result = Sync-UnifiedEnvironment
    }

    # Final validation
    if ($result) {
        $finalValidation = Test-UnifiedCompliance
        if ($finalValidation) {
            Write-Log "🎉 VIBECODE SYSTEM V4.0 UNIFIED ENVIRONMENT OPERATIONAL" -Level "Success"
            exit 0
        } else {
            Write-Log "❌ Final validation failed" -Level "Error"
            exit 1
        }
    } else {
        Write-Log "❌ Synchronization failed" -Level "Error"
        exit 1
    }
}
catch {
    Write-Log "❌ Script execution error: $($_.Exception.Message)" -Level "Error"
    Write-Log "Stack trace: $($_.ScriptStackTrace)" -Level "Error"
    exit 1
}
finally {
    Write-Log "📝 Script execution completed" -Level "Info"
    Write-Host "=" * 60 -ForegroundColor Gray
}
