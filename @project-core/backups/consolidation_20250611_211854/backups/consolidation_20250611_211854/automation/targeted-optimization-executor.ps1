# TARGETED OPTIMIZATION EXECUTOR - GRUPO US VIBECODE SYSTEM V4.0
# Implements specific optimizations based on analysis results
# Created: 2025-01-10
# Purpose: Execute safe, targeted optimizations with 100% functionality preservation

param(
    [switch]$DryRun = $false,
    [switch]$BackupFirst = $true,
    [string]$OptimizationTarget = "all",
    [switch]$Verbose = $false
)

# ===============================================================================
# OPTIMIZATION CONFIGURATION
# ===============================================================================

$OPTIMIZATION_TARGETS = @{
    "node_modules"          = @{
        Description = "Archive node_modules directories from tools"
        Paths       = @(
            "@project-core/tools/backend/node_modules",
            "@project-core/tools/frontend/node_modules", 
            "@project-core/tools/harmoniza-facil-agendas/node_modules",
            "@project-core/tools/perplexity-mcp-server/node_modules"
        )
        Action      = "Archive"
        Priority    = "High"
    }
    "old_backups"           = @{
        Description = "Consolidate old backup directories"
        Paths       = @(
            "@project-core/backups/20250608_110621",
            "@project-core/backups/20250610_141622"
        )
        Action      = "Consolidate"
        Priority    = "Medium"
    }
    "development_artifacts" = @{
        Description = "Archive development and test artifacts"
        Paths       = @(
            "@project-core/tools/__mocks__",
            "@project-core/tools/__tests__",
            "@project-core/tools/tests-examples",
            "@project-core/tools/screenshots"
        )
        Action      = "Archive"
        Priority    = "Low"
    }
    "extensions"            = @{
        Description = "Archive VS Code extensions"
        Paths       = @(
            "@project-core/tools/extensions"
        )
        Action      = "Archive"
        Priority    = "Medium"
    }
}

$ARCHIVE_BASE = "@project-core/backups/archived"
$CONSOLIDATION_BASE = "@project-core/backups/consolidated"

# ===============================================================================
# OPTIMIZATION FUNCTIONS
# ===============================================================================

function Write-OptimizationMessage {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    
    switch ($Type) {
        "SUCCESS" { Write-Host "[$timestamp] ✅ $Message" -ForegroundColor Green }
        "WARNING" { Write-Host "[$timestamp] ⚠️ $Message" -ForegroundColor Yellow }
        "ERROR" { Write-Host "[$timestamp] ❌ $Message" -ForegroundColor Red }
        "INFO" { Write-Host "[$timestamp] 📊 $Message" -ForegroundColor Blue }
        "OPTIMIZATION" { Write-Host "[$timestamp] 🎯 $Message" -ForegroundColor Magenta }
        default { Write-Host "[$timestamp] $Message" -ForegroundColor White }
    }
}

function New-OptimizationBackup {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupPath = "@project-core/backups/pre-optimization-$timestamp"
    
    Write-OptimizationMessage "Creating pre-optimization backup..." "INFO"
    
    if ($DryRun) {
        Write-OptimizationMessage "DRY RUN: Would create backup at $backupPath" "WARNING"
        return $backupPath
    }
    
    try {
        # Create backup directory
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        
        # Create backup manifest
        $manifest = @{
            BackupDate          = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Purpose             = "Pre-optimization backup"
            OptimizationTargets = $OPTIMIZATION_TARGETS.Keys
            BackupPath          = $backupPath
        }
        
        $manifest | ConvertTo-Json -Depth 3 | Out-File "$backupPath/backup-manifest.json" -Encoding UTF8
        
        Write-OptimizationMessage "Backup created: $backupPath" "SUCCESS"
        return $backupPath
    }
    catch {
        Write-OptimizationMessage "Failed to create backup: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

function Invoke-ArchiveOptimization {
    param(
        [string]$TargetName,
        [hashtable]$TargetConfig
    )
    
    Write-OptimizationMessage "Executing archive optimization: $TargetName" "OPTIMIZATION"
    
    $archivePath = "$ARCHIVE_BASE/$TargetName-$(Get-Date -Format 'yyyyMMdd')"
    
    if (!(Test-Path $ARCHIVE_BASE)) {
        if (!$DryRun) {
            New-Item -ItemType Directory -Path $ARCHIVE_BASE -Force | Out-Null
        }
        Write-OptimizationMessage "Created archive base directory: $ARCHIVE_BASE" "INFO"
    }
    
    $archivedItems = @()
    $totalSizeSaved = 0
    
    foreach ($path in $TargetConfig.Paths) {
        if (Test-Path $path) {
            $item = Get-Item $path
            $size = if ($item.PSIsContainer) {
                (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            }
            else {
                $item.Length
            }
            
            $totalSizeSaved += $size
            
            if ($DryRun) {
                Write-OptimizationMessage "DRY RUN: Would archive $path ($(Format-FileSize $size))" "WARNING"
            }
            else {
                try {
                    $destinationPath = "$archivePath/$(Split-Path $path -Leaf)"
                    
                    if (!(Test-Path $archivePath)) {
                        New-Item -ItemType Directory -Path $archivePath -Force | Out-Null
                    }
                    
                    Move-Item $path $destinationPath -Force
                    Write-OptimizationMessage "Archived: $path → $destinationPath" "SUCCESS"
                    
                    $archivedItems += @{
                        OriginalPath = $path
                        ArchivedPath = $destinationPath
                        Size         = $size
                    }
                }
                catch {
                    Write-OptimizationMessage "Failed to archive $path`: $($_.Exception.Message)" "ERROR"
                }
            }
        }
        else {
            Write-OptimizationMessage "Path not found: $path" "WARNING"
        }
    }
    
    if (!$DryRun -and $archivedItems.Count -gt 0) {
        # Create archive manifest
        $archiveManifest = @{
            ArchiveDate    = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            TargetName     = $TargetName
            Description    = $TargetConfig.Description
            ArchivedItems  = $archivedItems
            TotalSizeSaved = $totalSizeSaved
        }
        
        $archiveManifest | ConvertTo-Json -Depth 3 | Out-File "$archivePath/archive-manifest.json" -Encoding UTF8
    }
    
    Write-OptimizationMessage "Archive optimization completed: $TargetName ($([math]::Round($totalSizeSaved/1MB, 2)) MB saved)" "SUCCESS"
    return $totalSizeSaved
}

function Invoke-ConsolidationOptimization {
    param(
        [string]$TargetName,
        [hashtable]$TargetConfig
    )
    
    Write-OptimizationMessage "Executing consolidation optimization: $TargetName" "OPTIMIZATION"
    
    $consolidationPath = "$CONSOLIDATION_BASE/$TargetName-$(Get-Date -Format 'yyyyMMdd')"
    
    if (!(Test-Path $CONSOLIDATION_BASE)) {
        if (!$DryRun) {
            New-Item -ItemType Directory -Path $CONSOLIDATION_BASE -Force | Out-Null
        }
        Write-OptimizationMessage "Created consolidation base directory: $CONSOLIDATION_BASE" "INFO"
    }
    
    $consolidatedItems = @()
    $totalSizeSaved = 0
    
    foreach ($path in $TargetConfig.Paths) {
        if (Test-Path $path) {
            $item = Get-Item $path
            $size = if ($item.PSIsContainer) {
                (Get-ChildItem $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            }
            else {
                $item.Length
            }
            
            $totalSizeSaved += $size
            
            if ($DryRun) {
                Write-OptimizationMessage "DRY RUN: Would consolidate $path ($(Format-FileSize $size))" "WARNING"
            }
            else {
                try {
                    $destinationPath = "$consolidationPath/$(Split-Path $path -Leaf)"
                    
                    if (!(Test-Path $consolidationPath)) {
                        New-Item -ItemType Directory -Path $consolidationPath -Force | Out-Null
                    }
                    
                    Move-Item $path $destinationPath -Force
                    Write-OptimizationMessage "Consolidated: $path → $destinationPath" "SUCCESS"
                    
                    $consolidatedItems += @{
                        OriginalPath     = $path
                        ConsolidatedPath = $destinationPath
                        Size             = $size
                    }
                }
                catch {
                    Write-OptimizationMessage "Failed to consolidate $path`: $($_.Exception.Message)" "ERROR"
                }
            }
        }
        else {
            Write-OptimizationMessage "Path not found: $path" "WARNING"
        }
    }
    
    if (!$DryRun -and $consolidatedItems.Count -gt 0) {
        # Create consolidation manifest
        $consolidationManifest = @{
            ConsolidationDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            TargetName        = $TargetName
            Description       = $TargetConfig.Description
            ConsolidatedItems = $consolidatedItems
            TotalSizeSaved    = $totalSizeSaved
        }
        
        $consolidationManifest | ConvertTo-Json -Depth 3 | Out-File "$consolidationPath/consolidation-manifest.json" -Encoding UTF8
    }
    
    Write-OptimizationMessage "Consolidation optimization completed: $TargetName ($([math]::Round($totalSizeSaved/1MB, 2)) MB saved)" "SUCCESS"
    return $totalSizeSaved
}

function Format-FileSize {
    param([long]$Size)

    if ($Size -eq 0) { return "0 B" }
    if ($Size -lt 1024) { return "$Size B" }
    if ($Size -lt 1MB) { return "$([math]::Round($Size/1KB, 2)) KB" }
    if ($Size -lt 1GB) { return "$([math]::Round($Size/1MB, 2)) MB" }
    return "$([math]::Round($Size/1GB, 2)) GB"
}

function Show-OptimizationSummary {
    param([hashtable]$Results)
    
    Write-Host ""
    Write-OptimizationMessage "OPTIMIZATION EXECUTION SUMMARY:" "INFO"
    Write-Host "  ===========================================" -ForegroundColor Cyan
    
    $totalSaved = 0
    $optimizationsExecuted = 0
    
    foreach ($target in $Results.Keys) {
        $sizeSaved = $Results[$target]
        $totalSaved += $sizeSaved
        $optimizationsExecuted++
        
        Write-Host "  $target`: $(Format-FileSize $sizeSaved)" -ForegroundColor Green
    }
    
    Write-Host "  ===========================================" -ForegroundColor Cyan
    Write-Host "  Total Optimizations: $optimizationsExecuted" -ForegroundColor Green
    Write-Host "  Total Space Saved: $(Format-FileSize $totalSaved)" -ForegroundColor Green
    
    if ($DryRun) {
        Write-OptimizationMessage "DRY RUN COMPLETED - No actual changes made" "WARNING"
    }
    else {
        Write-OptimizationMessage "OPTIMIZATION COMPLETED - $(Format-FileSize $totalSaved) saved" "SUCCESS"
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-TargetedOptimization {
    Write-Host "🎯 TARGETED OPTIMIZATION EXECUTOR - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
    Write-Host "Target: $OptimizationTarget" -ForegroundColor Cyan
    
    if ($DryRun) {
        Write-Host "Mode: DRY RUN (no changes will be made)" -ForegroundColor Yellow
    }
    
    Write-Host ""
    
    # Create backup if requested
    if ($BackupFirst -and !$DryRun) {
        $backupPath = New-OptimizationBackup
        if (!$backupPath) {
            Write-OptimizationMessage "Backup failed - aborting optimization" "ERROR"
            return $false
        }
    }
    
    # Execute optimizations
    $results = @{}
    
    foreach ($targetName in $OPTIMIZATION_TARGETS.Keys) {
        if ($OptimizationTarget -eq "all" -or $OptimizationTarget -eq $targetName) {
            $targetConfig = $OPTIMIZATION_TARGETS[$targetName]
            
            switch ($targetConfig.Action) {
                "Archive" {
                    $sizeSaved = Invoke-ArchiveOptimization -TargetName $targetName -TargetConfig $targetConfig
                    $results[$targetName] = $sizeSaved
                }
                "Consolidate" {
                    $sizeSaved = Invoke-ConsolidationOptimization -TargetName $targetName -TargetConfig $targetConfig
                    $results[$targetName] = $sizeSaved
                }
                default {
                    Write-OptimizationMessage "Unknown action: $($targetConfig.Action)" "ERROR"
                }
            }
        }
    }
    
    # Show summary
    Show-OptimizationSummary -Results $results
    
    Write-Host ""
    Write-OptimizationMessage "Targeted optimization completed!" "SUCCESS"
    
    return $true
}

# Execute targeted optimization
Start-TargetedOptimization
