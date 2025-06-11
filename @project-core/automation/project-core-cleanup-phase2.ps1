# PROJECT-CORE CLEANUP PHASE 2: SYSTEMATIC CONSOLIDATION
# GRUPO US VIBECODE SYSTEM V4.0 - Enhanced Memory System Cleanup
# Created: 2025-01-10
# Purpose: Safe consolidation of @project-core directory with 30-40% file reduction

param(
    [switch]$DryRun = $true,
    [switch]$Force = $false,
    [string]$StagingArea = "@project-core/_pending_deletion"
)

# ===============================================================================
# CRITICAL FILE PROTECTION SYSTEM (MANDATORY)
# ===============================================================================

$CRITICAL_FILES = @(
    "@project-core/memory/master_rule.md",
    "@project-core/memory/self_correction_log.md", 
    "@project-core/memory/global-standards.md",
    "@project-core/rules/00-vibecode-system-v4-master.md",
    "@project-core/automation/finaltest.ps1",
    "@project-core/automation/validate-system.ps1"
)

$CRITICAL_DIRECTORIES = @(
    "@project-core/memory",
    "@project-core/rules",
    "@project-core/automation",
    "@project-core/configs"
)

# ===============================================================================
# SAFETY VALIDATION FUNCTIONS
# ===============================================================================

function Test-CriticalFileProtection {
    Write-Host "🔒 Verifying critical file protection..." -ForegroundColor Yellow
    
    foreach ($file in $CRITICAL_FILES) {
        if (!(Test-Path $file)) {
            Write-Error "❌ CRITICAL FILE MISSING: $file - ABORT OPERATION"
            exit 1
        }
        Write-Host "  ✅ Protected: $file" -ForegroundColor Green
    }
    
    foreach ($dir in $CRITICAL_DIRECTORIES) {
        if (!(Test-Path $dir)) {
            Write-Error "❌ CRITICAL DIRECTORY MISSING: $dir - ABORT OPERATION"
            exit 1
        }
        Write-Host "  ✅ Protected: $dir" -ForegroundColor Green
    }
    
    Write-Host "✅ All critical files and directories protected" -ForegroundColor Green
}

function Initialize-StagingArea {
    Write-Host "📁 Initializing staging area..." -ForegroundColor Yellow
    
    if (!(Test-Path $StagingArea)) {
        New-Item -ItemType Directory -Path $StagingArea -Force | Out-Null
        Write-Host "  ✅ Created staging area: $StagingArea" -ForegroundColor Green
    }
    
    # Test staging area functionality
    $testFile = "$StagingArea/test-staging-verification.txt"
    "test" | Out-File $testFile -Force
    
    if (Test-Path $testFile) {
        Remove-Item $testFile -Force
        Write-Host "  ✅ Staging area verified and functional" -ForegroundColor Green
    } else {
        Write-Error "❌ Staging area not working - ABORT ALL OPERATIONS"
        exit 1
    }
}

function Get-FileCount {
    param([string]$Path)
    
    if (Test-Path $Path) {
        return (Get-ChildItem $Path -Recurse -File | Measure-Object).Count
    }
    return 0
}

# ===============================================================================
# CONSOLIDATION FUNCTIONS
# ===============================================================================

function Remove-BackupDirectories {
    Write-Host "🗂️ Phase 2.1: Consolidating backup directories..." -ForegroundColor Cyan
    
    $backupDirs = Get-ChildItem "@project-core" -Directory | Where-Object { 
        $_.Name -match "backup|old|legacy|deprecated" -or
        $_.Name -match "\d{8}-\d{6}" -or
        $_.Name -match "mcp-centralization"
    }
    
    $totalFiles = 0
    foreach ($dir in $backupDirs) {
        $fileCount = Get-FileCount $dir.FullName
        $totalFiles += $fileCount
        
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would move: $($dir.Name) ($fileCount files)" -ForegroundColor Yellow
        } else {
            Write-Host "  Moving to staging: $($dir.Name) ($fileCount files)" -ForegroundColor Yellow
            Move-Item $dir.FullName "$StagingArea/" -Force
        }
    }
    
    Write-Host "  📊 Backup directories: $($backupDirs.Count) directories, $totalFiles files" -ForegroundColor Green
    return @{ Directories = $backupDirs.Count; Files = $totalFiles }
}

function Consolidate-ConfigurationFiles {
    Write-Host "⚙️ Phase 2.2: Consolidating configuration files..." -ForegroundColor Cyan
    
    # Identify duplicate MCP configurations
    $mcpConfigs = Get-ChildItem "@project-core/configs" -Filter "*mcp*.json"
    $duplicateConfigs = @()
    
    foreach ($config in $mcpConfigs) {
        if ($config.Name -ne "mcp-master-centralized.json") {
            $duplicateConfigs += $config
        }
    }
    
    $totalFiles = $duplicateConfigs.Count
    foreach ($config in $duplicateConfigs) {
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would consolidate: $($config.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "  Moving to staging: $($config.Name)" -ForegroundColor Yellow
            Move-Item $config.FullName "$StagingArea/" -Force
        }
    }
    
    Write-Host "  📊 Configuration consolidation: $totalFiles files" -ForegroundColor Green
    return @{ Files = $totalFiles }
}

function Consolidate-AutomationScripts {
    Write-Host "🤖 Phase 2.3: Consolidating automation scripts..." -ForegroundColor Cyan
    
    # Identify redundant automation scripts
    $automationFiles = Get-ChildItem "@project-core/automation" -Filter "*.ps1"
    $redundantScripts = @()
    
    foreach ($script in $automationFiles) {
        # Keep only essential scripts
        if ($script.Name -notin @("finaltest.ps1", "validate-system.ps1", "project-core-cleanup-phase2.ps1")) {
            if ($script.Name -match "enhanced|backup|old|deprecated|test") {
                $redundantScripts += $script
            }
        }
    }
    
    $totalFiles = $redundantScripts.Count
    foreach ($script in $redundantScripts) {
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would consolidate: $($script.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "  Moving to staging: $($script.Name)" -ForegroundColor Yellow
            Move-Item $script.FullName "$StagingArea/" -Force
        }
    }
    
    Write-Host "  📊 Automation consolidation: $totalFiles files" -ForegroundColor Green
    return @{ Files = $totalFiles }
}

function Consolidate-ToolsDirectory {
    Write-Host "🔧 Phase 2.4: Consolidating tools directory..." -ForegroundColor Cyan
    
    # Identify oversized subdirectories in tools
    $toolsSubdirs = Get-ChildItem "@project-core/tools" -Directory
    $consolidationCandidates = @()
    
    foreach ($dir in $toolsSubdirs) {
        $fileCount = Get-FileCount $dir.FullName
        
        # Mark for consolidation if it's a large directory with specific patterns
        if ($dir.Name -match "backend|frontend|harmoniza|extensions|figma-test|screenshots" -or $fileCount -gt 50) {
            $consolidationCandidates += @{
                Directory = $dir
                FileCount = $fileCount
            }
        }
    }
    
    $totalFiles = 0
    foreach ($candidate in $consolidationCandidates) {
        $totalFiles += $candidate.FileCount
        
        if ($DryRun) {
            Write-Host "  [DRY RUN] Would consolidate: $($candidate.Directory.Name) ($($candidate.FileCount) files)" -ForegroundColor Yellow
        } else {
            Write-Host "  Moving to staging: $($candidate.Directory.Name) ($($candidate.FileCount) files)" -ForegroundColor Yellow
            Move-Item $candidate.Directory.FullName "$StagingArea/" -Force
        }
    }
    
    Write-Host "  📊 Tools consolidation: $($consolidationCandidates.Count) directories, $totalFiles files" -ForegroundColor Green
    return @{ Directories = $consolidationCandidates.Count; Files = $totalFiles }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-Phase2Consolidation {
    Write-Host "🚀 PROJECT-CORE CLEANUP PHASE 2: SYSTEMATIC CONSOLIDATION" -ForegroundColor Magenta
    Write-Host "Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" -ForegroundColor $(if ($DryRun) { 'Yellow' } else { 'Red' })
    Write-Host ""
    
    # Safety checks
    Test-CriticalFileProtection
    Initialize-StagingArea
    
    # Get initial file count
    $initialCount = Get-FileCount "@project-core"
    Write-Host "📊 Initial file count: $initialCount files" -ForegroundColor Blue
    Write-Host ""
    
    # Execute consolidation phases
    $results = @{}
    $results.Backups = Remove-BackupDirectories
    $results.Configs = Consolidate-ConfigurationFiles  
    $results.Automation = Consolidate-AutomationScripts
    $results.Tools = Consolidate-ToolsDirectory
    
    # Calculate totals
    $totalFilesReduced = $results.Backups.Files + $results.Configs.Files + $results.Automation.Files + $results.Tools.Files
    $totalDirsReduced = $results.Backups.Directories + $results.Tools.Directories
    
    Write-Host ""
    Write-Host "📊 PHASE 2 CONSOLIDATION SUMMARY:" -ForegroundColor Green
    Write-Host "  • Backup directories removed: $($results.Backups.Directories)" -ForegroundColor White
    Write-Host "  • Configuration files consolidated: $($results.Configs.Files)" -ForegroundColor White
    Write-Host "  • Automation scripts consolidated: $($results.Automation.Files)" -ForegroundColor White
    Write-Host "  • Tools directories consolidated: $($results.Tools.Directories)" -ForegroundColor White
    Write-Host "  • Total directories reduced: $totalDirsReduced" -ForegroundColor White
    Write-Host "  • Total files reduced: $totalFilesReduced" -ForegroundColor White
    
    if (!$DryRun) {
        $finalCount = Get-FileCount "@project-core"
        $reductionPercent = [math]::Round((($initialCount - $finalCount) / $initialCount) * 100, 1)
        Write-Host "  • File reduction achieved: $reductionPercent%" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "✅ Phase 2 consolidation completed successfully!" -ForegroundColor Green
    
    if ($DryRun) {
        Write-Host ""
        Write-Host "💡 To execute changes, run with -DryRun:`$false" -ForegroundColor Yellow
    }
}

# Execute Phase 2
Start-Phase2Consolidation
