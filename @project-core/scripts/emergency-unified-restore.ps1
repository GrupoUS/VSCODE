# 🚨 GRUPO US VIBECODE SYSTEM V4.0 - EMERGENCY UNIFIED RESTORE
# EMERGENCY RESTORATION SCRIPT FOR CRITICAL COMPLIANCE FAILURES

param(
    [switch]$Force,
    [switch]$FullRestore,
    [switch]$BackupFirst,
    [string]$RestorePoint
)

# Script Metadata
$ScriptVersion = "4.0.0"
$ScriptName = "Emergency Unified Restore"
$Author = "GRUPO US - VIBECODE SYSTEM"
$LastUpdated = "2025-01-27"

Write-Host "🚨 $ScriptName v$ScriptVersion" -ForegroundColor Red
Write-Host "Author: $Author | Updated: $LastUpdated" -ForegroundColor Gray
Write-Host "⚠️  EMERGENCY MODE - CRITICAL SYSTEM RESTORATION" -ForegroundColor Yellow
Write-Host "=" * 60 -ForegroundColor Red

# Configuration Paths
$ProjectCore = "@project-core"
$VSCodeConfigPath = "$ProjectCore/configs/ide/vscode"
$CursorConfigPath = "$ProjectCore/configs/ide/cursor"
$SharedConfigPath = "$ProjectCore/configs/ide/shared"
$MemoryPath = "$ProjectCore/memory"
$RulesPath = "$ProjectCore/rules"
$BackupPath = "$ProjectCore/backups"
$EmergencyBackupPath = "$BackupPath/emergency-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

# Logging Function
function Write-EmergencyLog {
    param(
        [string]$Message,
        [string]$Level = "Info"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [EMERGENCY] [$Level] $Message"
    
    # Console output with appropriate colors
    switch ($Level) {
        "Critical" { Write-Host $logMessage -ForegroundColor Red -BackgroundColor Yellow }
        "Error" { Write-Host $logMessage -ForegroundColor Red }
        "Warning" { Write-Host $logMessage -ForegroundColor Yellow }
        "Success" { Write-Host $logMessage -ForegroundColor Green }
        "Info" { Write-Host $logMessage -ForegroundColor Cyan }
        default { Write-Host $logMessage -ForegroundColor White }
    }
    
    # Emergency log file
    $emergencyLogFile = "$ProjectCore/logs/emergency-$(Get-Date -Format 'yyyyMMdd').log"
    if (!(Test-Path (Split-Path $emergencyLogFile))) {
        New-Item -ItemType Directory -Path (Split-Path $emergencyLogFile) -Force | Out-Null
    }
    Add-Content -Path $emergencyLogFile -Value $logMessage
}

function Test-CriticalSystemState {
    Write-EmergencyLog "🔍 Assessing critical system state..." -Level "Info"
    
    $criticalIssues = @()
    
    # Check for master rule
    if (!(Test-Path "$MemoryPath/master_rule.md")) {
        $criticalIssues += "Master Rule Missing"
        Write-EmergencyLog "❌ CRITICAL: Master Rule missing" -Level "Critical"
    }
    
    # Check for constitution
    if (!(Test-Path "$RulesPath/00-vibecode-system-v4-master.md")) {
        $criticalIssues += "Constitution Missing"
        Write-EmergencyLog "❌ CRITICAL: Constitution missing" -Level "Critical"
    }
    
    # Check for VS Code config
    if (!(Test-Path "$VSCodeConfigPath/settings.json")) {
        $criticalIssues += "VS Code Config Missing"
        Write-EmergencyLog "❌ CRITICAL: VS Code config missing" -Level "Critical"
    }
    
    # Check for Cursor config
    if (!(Test-Path "$CursorConfigPath/.cursorrules")) {
        $criticalIssues += "Cursor Rules Missing"
        Write-EmergencyLog "❌ CRITICAL: Cursor rules missing" -Level "Critical"
    }
    
    # Check for unified config
    if (!(Test-Path "$SharedConfigPath/unified-config.json")) {
        $criticalIssues += "Unified Config Missing"
        Write-EmergencyLog "❌ CRITICAL: Unified config missing" -Level "Critical"
    }
    
    # Check for active configurations
    $activeIssues = @()
    if (!(Test-Path ".vscode/settings.json")) {
        $activeIssues += "Active VS Code Config Missing"
    }
    if (!(Test-Path ".cursorrules")) {
        $activeIssues += "Active Cursor Rules Missing"
    }
    if (!(Test-Path ".cursor/mcp.json")) {
        $activeIssues += "Active Cursor MCP Missing"
    }
    
    $totalIssues = $criticalIssues.Count + $activeIssues.Count
    
    Write-EmergencyLog "📊 Assessment complete: $totalIssues critical issues found" -Level "Info"
    
    if ($criticalIssues.Count -gt 0) {
        Write-EmergencyLog "🚨 CRITICAL SYSTEM FAILURE DETECTED" -Level "Critical"
        foreach ($issue in $criticalIssues) {
            Write-EmergencyLog "  - $issue" -Level "Critical"
        }
    }
    
    if ($activeIssues.Count -gt 0) {
        Write-EmergencyLog "⚠️ Active configuration issues detected" -Level "Warning"
        foreach ($issue in $activeIssues) {
            Write-EmergencyLog "  - $issue" -Level "Warning"
        }
    }
    
    return @{
        CriticalIssues = $criticalIssues
        ActiveIssues = $activeIssues
        TotalIssues = $totalIssues
        SystemState = if ($criticalIssues.Count -gt 0) { "CRITICAL" } elseif ($activeIssues.Count -gt 0) { "DEGRADED" } else { "STABLE" }
    }
}

function Backup-CurrentState {
    Write-EmergencyLog "💾 Creating emergency backup..." -Level "Info"
    
    try {
        # Create emergency backup directory
        if (!(Test-Path $EmergencyBackupPath)) {
            New-Item -ItemType Directory -Path $EmergencyBackupPath -Force | Out-Null
        }
        
        # Backup existing configurations
        $backupItems = @(
            @{ Source = ".vscode/settings.json"; Target = "vscode-settings.json" },
            @{ Source = ".cursorrules"; Target = "cursorrules" },
            @{ Source = ".cursor/mcp.json"; Target = "cursor-mcp.json" },
            @{ Source = ".augmentignore"; Target = "augmentignore" },
            @{ Source = ".augment-guidelines"; Target = "augment-guidelines" }
        )
        
        $backedUpCount = 0
        foreach ($item in $backupItems) {
            if (Test-Path $item.Source) {
                Copy-Item $item.Source "$EmergencyBackupPath/$($item.Target)" -Force
                $backedUpCount++
                Write-EmergencyLog "✅ Backed up: $($item.Source)" -Level "Success"
            }
        }
        
        # Create backup manifest
        $manifest = @{
            BackupTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            BackupPath = $EmergencyBackupPath
            ItemsBackedUp = $backedUpCount
            ScriptVersion = $ScriptVersion
            SystemState = "EMERGENCY_BACKUP"
        }
        
        $manifest | ConvertTo-Json | Set-Content "$EmergencyBackupPath/backup-manifest.json"
        
        Write-EmergencyLog "✅ Emergency backup completed: $backedUpCount items backed up" -Level "Success"
        Write-EmergencyLog "📁 Backup location: $EmergencyBackupPath" -Level "Info"
        
        return $true
    }
    catch {
        Write-EmergencyLog "❌ Emergency backup failed: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Restore-MasterRule {
    Write-EmergencyLog "🧠 Restoring Master Rule..." -Level "Info"
    
    try {
        $masterRulePath = "$MemoryPath/master_rule.md"
        
        if (!(Test-Path $masterRulePath)) {
            # Check for backup
            $backupMasterRule = Get-ChildItem "$BackupPath" -Recurse -Filter "master_rule.md" | Select-Object -First 1
            
            if ($backupMasterRule) {
                Copy-Item $backupMasterRule.FullName $masterRulePath -Force
                Write-EmergencyLog "✅ Master Rule restored from backup" -Level "Success"
            } else {
                Write-EmergencyLog "❌ No Master Rule backup found - CRITICAL FAILURE" -Level "Critical"
                return $false
            }
        } else {
            Write-EmergencyLog "✅ Master Rule already exists" -Level "Success"
        }
        
        return $true
    }
    catch {
        Write-EmergencyLog "❌ Master Rule restoration failed: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Restore-Constitution {
    Write-EmergencyLog "📜 Restoring Constitution..." -Level "Info"
    
    try {
        $constitutionPath = "$RulesPath/00-vibecode-system-v4-master.md"
        
        if (!(Test-Path $constitutionPath)) {
            # Check for backup
            $backupConstitution = Get-ChildItem "$BackupPath" -Recurse -Filter "00-vibecode-system-v4-master.md" | Select-Object -First 1
            
            if ($backupConstitution) {
                Copy-Item $backupConstitution.FullName $constitutionPath -Force
                Write-EmergencyLog "✅ Constitution restored from backup" -Level "Success"
            } else {
                Write-EmergencyLog "❌ No Constitution backup found - CRITICAL FAILURE" -Level "Critical"
                return $false
            }
        } else {
            Write-EmergencyLog "✅ Constitution already exists" -Level "Success"
        }
        
        return $true
    }
    catch {
        Write-EmergencyLog "❌ Constitution restoration failed: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Restore-VSCodeConfiguration {
    Write-EmergencyLog "🔧 Restoring VS Code configuration..." -Level "Info"
    
    try {
        # Ensure .vscode directory exists
        if (!(Test-Path ".vscode")) {
            New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null
            Write-EmergencyLog "📁 Created .vscode directory" -Level "Info"
        }
        
        # Restore VS Code settings
        if (Test-Path "$VSCodeConfigPath/settings.json") {
            Copy-Item "$VSCodeConfigPath/settings.json" ".vscode/settings.json" -Force
            Write-EmergencyLog "✅ VS Code settings restored" -Level "Success"
        } else {
            Write-EmergencyLog "❌ VS Code source config missing" -Level "Error"
            return $false
        }
        
        return $true
    }
    catch {
        Write-EmergencyLog "❌ VS Code restoration failed: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Restore-CursorConfiguration {
    Write-EmergencyLog "🎯 Restoring Cursor configuration..." -Level "Info"
    
    try {
        # Ensure .cursor directory exists
        if (!(Test-Path ".cursor")) {
            New-Item -ItemType Directory -Path ".cursor" -Force | Out-Null
            Write-EmergencyLog "📁 Created .cursor directory" -Level "Info"
        }
        
        # Restore Cursor rules
        if (Test-Path "$CursorConfigPath/.cursorrules") {
            Copy-Item "$CursorConfigPath/.cursorrules" ".cursorrules" -Force
            Write-EmergencyLog "✅ Cursor rules restored" -Level "Success"
        } else {
            Write-EmergencyLog "❌ Cursor rules source missing" -Level "Error"
            return $false
        }
        
        # Restore Cursor MCP configuration
        if (Test-Path "$CursorConfigPath/mcp.json") {
            Copy-Item "$CursorConfigPath/mcp.json" ".cursor/mcp.json" -Force
            Write-EmergencyLog "✅ Cursor MCP configuration restored" -Level "Success"
        } else {
            Write-EmergencyLog "❌ Cursor MCP source missing" -Level "Error"
            return $false
        }
        
        return $true
    }
    catch {
        Write-EmergencyLog "❌ Cursor restoration failed: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Validate-EmergencyRestoration {
    Write-EmergencyLog "🔍 Validating emergency restoration..." -Level "Info"
    
    # Run the main sync script validation
    try {
        $validationScript = "$ProjectCore/scripts/sync-unified-environment.ps1"
        if (Test-Path $validationScript) {
            $validationResult = & $validationScript -Validate
            
            if ($LASTEXITCODE -eq 0) {
                Write-EmergencyLog "✅ Emergency restoration validation PASSED" -Level "Success"
                return $true
            } else {
                Write-EmergencyLog "❌ Emergency restoration validation FAILED" -Level "Error"
                return $false
            }
        } else {
            Write-EmergencyLog "⚠️ Validation script not found - performing basic checks" -Level "Warning"
            
            # Basic validation
            $basicChecks = @(
                ".vscode/settings.json",
                ".cursorrules",
                ".cursor/mcp.json",
                "$MemoryPath/master_rule.md",
                "$RulesPath/00-vibecode-system-v4-master.md"
            )
            
            $failedChecks = @()
            foreach ($check in $basicChecks) {
                if (!(Test-Path $check)) {
                    $failedChecks += $check
                }
            }
            
            if ($failedChecks.Count -eq 0) {
                Write-EmergencyLog "✅ Basic validation PASSED" -Level "Success"
                return $true
            } else {
                Write-EmergencyLog "❌ Basic validation FAILED: $($failedChecks -join ', ')" -Level "Error"
                return $false
            }
        }
    }
    catch {
        Write-EmergencyLog "❌ Validation error: $($_.Exception.Message)" -Level "Error"
        return $false
    }
}

function Perform-EmergencyRestoration {
    Write-EmergencyLog "🚨 INITIATING EMERGENCY RESTORATION SEQUENCE" -Level "Critical"
    
    # Step 1: Backup current state (if requested)
    if ($BackupFirst) {
        $backupResult = Backup-CurrentState
        if (!$backupResult) {
            Write-EmergencyLog "⚠️ Backup failed but continuing with restoration..." -Level "Warning"
        }
    }
    
    # Step 2: Restore critical system files
    Write-EmergencyLog "🔧 Restoring critical system files..." -Level "Info"
    
    $masterRuleResult = Restore-MasterRule
    $constitutionResult = Restore-Constitution
    
    if (!$masterRuleResult -or !$constitutionResult) {
        Write-EmergencyLog "❌ CRITICAL SYSTEM FILES RESTORATION FAILED" -Level "Critical"
        return $false
    }
    
    # Step 3: Restore environment configurations
    Write-EmergencyLog "⚙️ Restoring environment configurations..." -Level "Info"
    
    $vsCodeResult = Restore-VSCodeConfiguration
    $cursorResult = Restore-CursorConfiguration
    
    if (!$vsCodeResult -or !$cursorResult) {
        Write-EmergencyLog "❌ ENVIRONMENT CONFIGURATION RESTORATION FAILED" -Level "Error"
        return $false
    }
    
    # Step 4: Validate restoration
    Write-EmergencyLog "✅ Validating emergency restoration..." -Level "Info"
    
    $validationResult = Validate-EmergencyRestoration
    
    if ($validationResult) {
        Write-EmergencyLog "🎉 EMERGENCY RESTORATION COMPLETED SUCCESSFULLY" -Level "Success"
        
        # Log the emergency restoration
        $restorationLog = @{
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Type = "Emergency Restoration"
            Result = "Success"
            BackupCreated = $BackupFirst
            BackupPath = if ($BackupFirst) { $EmergencyBackupPath } else { "None" }
            ScriptVersion = $ScriptVersion
        }
        
        Add-Content "$MemoryPath/self_correction_log.md" @"

## Emergency Restoration - $($restorationLog.Timestamp)
**Type**: $($restorationLog.Type)
**Result**: $($restorationLog.Result)
**Backup Created**: $($restorationLog.BackupCreated)
**Backup Path**: $($restorationLog.BackupPath)
**Script Version**: $($restorationLog.ScriptVersion)
**Action**: Complete system restoration from emergency state
**Prevention**: Enhanced monitoring and backup procedures implemented
"@
        
        return $true
    } else {
        Write-EmergencyLog "❌ EMERGENCY RESTORATION VALIDATION FAILED" -Level "Critical"
        return $false
    }
}

# Main Execution Logic
try {
    Write-EmergencyLog "🚨 EMERGENCY UNIFIED RESTORE INITIATED" -Level "Critical"
    
    # Assess current system state
    $systemState = Test-CriticalSystemState
    
    Write-EmergencyLog "📊 System State: $($systemState.SystemState)" -Level "Info"
    Write-EmergencyLog "📊 Critical Issues: $($systemState.CriticalIssues.Count)" -Level "Info"
    Write-EmergencyLog "📊 Active Issues: $($systemState.ActiveIssues.Count)" -Level "Info"
    
    # Determine if emergency restoration is needed
    if ($systemState.SystemState -eq "STABLE" -and !$Force) {
        Write-EmergencyLog "✅ System is stable - no emergency restoration needed" -Level "Success"
        Write-EmergencyLog "💡 Use -Force to perform restoration anyway" -Level "Info"
        exit 0
    }
    
    if ($systemState.SystemState -eq "CRITICAL" -or $Force -or $FullRestore) {
        Write-EmergencyLog "🚨 CRITICAL STATE DETECTED - EMERGENCY RESTORATION REQUIRED" -Level "Critical"
        
        if (!$Force) {
            Write-Host ""
            Write-Host "⚠️  WARNING: This will overwrite current configurations!" -ForegroundColor Yellow
            Write-Host "⚠️  Backup will be created automatically." -ForegroundColor Yellow
            Write-Host ""
            $confirmation = Read-Host "Continue with emergency restoration? (yes/no)"
            
            if ($confirmation -ne "yes") {
                Write-EmergencyLog "❌ Emergency restoration cancelled by user" -Level "Info"
                exit 1
            }
        }
        
        # Force backup creation in emergency mode
        $BackupFirst = $true
        
        $restorationResult = Perform-EmergencyRestoration
        
        if ($restorationResult) {
            Write-EmergencyLog "🎉 EMERGENCY RESTORATION SUCCESSFUL" -Level "Success"
            Write-EmergencyLog "🚀 VIBECODE SYSTEM V4.0 RESTORED TO OPERATIONAL STATE" -Level "Success"
            exit 0
        } else {
            Write-EmergencyLog "❌ EMERGENCY RESTORATION FAILED" -Level "Critical"
            Write-EmergencyLog "🆘 MANUAL INTERVENTION REQUIRED" -Level "Critical"
            exit 1
        }
    } else {
        Write-EmergencyLog "⚠️ System degraded but not critical - consider running sync script first" -Level "Warning"
        Write-EmergencyLog "💡 Use -Force to perform emergency restoration anyway" -Level "Info"
        exit 1
    }
}
catch {
    Write-EmergencyLog "❌ Emergency restoration script error: $($_.Exception.Message)" -Level "Critical"
    Write-EmergencyLog "Stack trace: $($_.ScriptStackTrace)" -Level "Error"
    exit 1
}
finally {
    Write-EmergencyLog "📝 Emergency restoration script completed" -Level "Info"
    Write-Host "=" * 60 -ForegroundColor Red
}
