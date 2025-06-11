# BACKUP CONSOLIDATION SCRIPT - GRUPO US VIBECODE SYSTEM V4.0
# Consolidates old backup directories into compressed archives
# Created: 2025-01-10
# Purpose: Reduce backup directory size while preserving historical data

param(
    [switch]$DryRun = $false,
    [string]$ArchivePath = "@project-core/backups/archived"
)

# ===============================================================================
# BACKUP CONSOLIDATION FUNCTIONS
# ===============================================================================

function Initialize-ArchiveDirectory {
    Write-Host "📁 Initializing archive directory..." -ForegroundColor Yellow
    
    if (!(Test-Path $ArchivePath)) {
        New-Item -ItemType Directory -Path $ArchivePath -Force | Out-Null
        Write-Host "  ✅ Created archive directory: $ArchivePath" -ForegroundColor Green
    } else {
        Write-Host "  ✅ Archive directory exists: $ArchivePath" -ForegroundColor Green
    }
}

function Get-BackupDirectories {
    Write-Host "🔍 Identifying backup directories for consolidation..." -ForegroundColor Yellow
    
    $backupDirs = Get-ChildItem "@project-core/backups" -Directory | Where-Object {
        $_.Name -match "\d{8}_\d{6}" -or
        $_.Name -match "clinerules-backup" -or
        $_.Name -match "taskmaster-cleanup"
    }
    
    Write-Host "  📊 Found $($backupDirs.Count) backup directories:" -ForegroundColor Blue
    foreach ($dir in $backupDirs) {
        $fileCount = (Get-ChildItem $dir.FullName -Recurse -File | Measure-Object).Count
        Write-Host "    • $($dir.Name) ($fileCount files)" -ForegroundColor White
    }
    
    return $backupDirs
}

function Consolidate-BackupDirectory {
    param(
        [System.IO.DirectoryInfo]$BackupDir,
        [string]$ArchivePath
    )
    
    $archiveName = "$($BackupDir.Name).zip"
    $archiveFullPath = Join-Path $ArchivePath $archiveName
    
    if ($DryRun) {
        Write-Host "  [DRY RUN] Would compress: $($BackupDir.Name) → $archiveName" -ForegroundColor Yellow
        return @{ Success = $true; ArchivePath = $archiveFullPath; DryRun = $true }
    }
    
    try {
        # Compress the directory
        Compress-Archive -Path $BackupDir.FullName -DestinationPath $archiveFullPath -Force
        
        # Verify the archive was created
        if (Test-Path $archiveFullPath) {
            $archiveSize = [math]::Round((Get-Item $archiveFullPath).Length / 1MB, 2)
            Write-Host "  ✅ Compressed: $($BackupDir.Name) → $archiveName ($archiveSize MB)" -ForegroundColor Green
            
            # Remove the original directory
            Remove-Item $BackupDir.FullName -Recurse -Force
            Write-Host "  🗑️ Removed original directory: $($BackupDir.Name)" -ForegroundColor Gray
            
            return @{ Success = $true; ArchivePath = $archiveFullPath; Size = $archiveSize }
        } else {
            Write-Host "  ❌ Failed to create archive: $archiveName" -ForegroundColor Red
            return @{ Success = $false; Error = "Archive not created" }
        }
    }
    catch {
        Write-Host "  ❌ Error compressing $($BackupDir.Name): $($_.Exception.Message)" -ForegroundColor Red
        return @{ Success = $false; Error = $_.Exception.Message }
    }
}

function Start-BackupConsolidation {
    Write-Host "🗜️ BACKUP CONSOLIDATION - PHASE 2B.1" -ForegroundColor Magenta
    Write-Host "Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" -ForegroundColor $(if ($DryRun) { 'Yellow' } else { 'Red' })
    Write-Host ""
    
    # Initialize archive directory
    Initialize-ArchiveDirectory
    
    # Get backup directories
    $backupDirs = Get-BackupDirectories
    
    if ($backupDirs.Count -eq 0) {
        Write-Host "  ℹ️ No backup directories found for consolidation" -ForegroundColor Blue
        return
    }
    
    Write-Host ""
    Write-Host "🗜️ Starting consolidation process..." -ForegroundColor Cyan
    
    $results = @()
    $totalSaved = 0
    $successCount = 0
    
    foreach ($backupDir in $backupDirs) {
        $result = Consolidate-BackupDirectory -BackupDir $backupDir -ArchivePath $ArchivePath
        $results += $result
        
        if ($result.Success) {
            $successCount++
            if (!$result.DryRun -and $result.Size) {
                $totalSaved += $result.Size
            }
        }
    }
    
    Write-Host ""
    Write-Host "📊 BACKUP CONSOLIDATION SUMMARY:" -ForegroundColor Green
    Write-Host "  • Directories processed: $($backupDirs.Count)" -ForegroundColor White
    Write-Host "  • Successfully consolidated: $successCount" -ForegroundColor White
    Write-Host "  • Failed: $($backupDirs.Count - $successCount)" -ForegroundColor White
    
    if (!$DryRun -and $totalSaved -gt 0) {
        Write-Host "  • Total space saved: $totalSaved MB" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "✅ Backup consolidation completed!" -ForegroundColor Green
    
    if ($DryRun) {
        Write-Host ""
        Write-Host "💡 To execute changes, run with -DryRun:`$false" -ForegroundColor Yellow
    }
    
    return $results
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

# Execute backup consolidation
$results = Start-BackupConsolidation

# Return results for further processing
return $results
