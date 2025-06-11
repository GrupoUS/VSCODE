# ===============================================================================
# AUTO BACKUP SCRIPT - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Creates incremental backups before critical changes
# Author: Augment Agent - Data Protection System
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$BackupType = "incremental",
    
    [Parameter(Mandatory = $false)]
    [string]$Description = "Automated backup",
    
    [Parameter(Mandatory = $false)]
    [switch]$Compress,
    
    [Parameter(Mandatory = $false)]
    [int]$RetentionDays = 7,
    
    [Parameter(Mandatory = $false)]
    [switch]$SkipGit
)

# Global variables
$script:BackupRoot = "@project-core/backups"
$script:BackupTimestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$script:BackupPath = "$script:BackupRoot/$script:BackupTimestamp"

# Status message function
function Write-StatusMessage($Message, $Type = "Info") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Type) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        "Info" { "Cyan" }
        default { "White" }
    }
    Write-Host "[$timestamp] $Message" -ForegroundColor $color
}

# ===============================================================================
# BACKUP FUNCTIONS
# ===============================================================================

function Initialize-BackupEnvironment {
    Write-StatusMessage "Initializing backup environment..." "Info"
    
    try {
        # Create backup root directory if it doesn't exist
        if (-not (Test-Path $script:BackupRoot)) {
            New-Item -ItemType Directory -Path $script:BackupRoot -Force | Out-Null
            Write-StatusMessage "Created backup directory: $script:BackupRoot" "Success"
        }
        
        # Create timestamped backup directory
        New-Item -ItemType Directory -Path $script:BackupPath -Force | Out-Null
        Write-StatusMessage "Created backup path: $script:BackupPath" "Success"
        
        return $true
    }
    catch {
        Write-StatusMessage "Failed to initialize backup environment: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Get-CriticalFiles {
    Write-StatusMessage "Identifying critical files for backup..." "Info"
    
    $criticalPaths = @(
        # Configuration files
        "@project-core/configs",
        "@project-core/memory",
        "@project-core/rules",
        
        # Scripts and automation
        "@project-core/automation",
        "@project-core/tools",
        "@project-core/scripts",
        
        # Documentation
        "@project-core/docs",
        
        # Project files
        "package.json",
        "package-lock.json",
        "yarn.lock",
        "tsconfig.json",
        "next.config.js",
        "tailwind.config.js",
        
        # Environment and config
        ".env.example",
        ".gitignore",
        "README.md",
        
        # Source code (if exists)
        "src",
        "pages",
        "app",
        "components",
        "lib",
        "utils",
        "styles",
        "public"
    )
    
    $existingPaths = @()
    foreach ($path in $criticalPaths) {
        if (Test-Path $path) {
            $existingPaths += $path
            Write-StatusMessage "  ✅ Found: $path" "Success"
        }
    }
    
    Write-StatusMessage "Identified $($existingPaths.Count) critical paths for backup" "Info"
    return $existingPaths
}

function New-IncrementalBackup {
    param([array]$FilePaths)
    
    Write-StatusMessage "Creating incremental backup..." "Info"
    
    try {
        $backupManifest = @{
            Timestamp = $script:BackupTimestamp
            Type = "incremental"
            Description = $Description
            Files = @()
            TotalSize = 0
        }
        
        foreach ($path in $FilePaths) {
            $destinationPath = Join-Path $script:BackupPath $path
            $destinationDir = Split-Path $destinationPath -Parent
            
            # Create destination directory structure
            if (-not (Test-Path $destinationDir)) {
                New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
            }
            
            if (Test-Path $path -PathType Container) {
                # Copy directory
                Copy-Item -Path $path -Destination $destinationPath -Recurse -Force
                $size = (Get-ChildItem -Path $path -Recurse -File | Measure-Object -Property Length -Sum).Sum
            }
            else {
                # Copy file
                Copy-Item -Path $path -Destination $destinationPath -Force
                $size = (Get-Item $path).Length
            }
            
            $backupManifest.Files += @{
                Path = $path
                Size = $size
                LastModified = (Get-Item $path).LastWriteTime
            }
            
            $backupManifest.TotalSize += $size
            Write-StatusMessage "  ✅ Backed up: $path" "Success"
        }
        
        # Save backup manifest
        $manifestPath = Join-Path $script:BackupPath "backup-manifest.json"
        $backupManifest | ConvertTo-Json -Depth 3 | Set-Content -Path $manifestPath
        
        $sizeMB = [math]::Round($backupManifest.TotalSize / 1MB, 2)
        Write-StatusMessage "Incremental backup completed: $sizeMB MB" "Success"
        
        return $true
    }
    catch {
        Write-StatusMessage "Incremental backup failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

function New-GitBackup {
    if ($SkipGit) {
        Write-StatusMessage "Skipping Git backup as requested" "Info"
        return $true
    }
    
    Write-StatusMessage "Creating Git state backup..." "Info"
    
    try {
        # Check if we're in a Git repository
        $gitStatus = & git status 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-StatusMessage "Not in a Git repository, skipping Git backup" "Warning"
            return $true
        }
        
        # Create Git info file
        $gitInfoPath = Join-Path $script:BackupPath "git-info.txt"
        $gitInfo = @"
Git Backup Information
Generated: $(Get-Date)
Description: $Description

Current Branch:
$(& git branch --show-current 2>$null)

Recent Commits:
$(& git log --oneline -10 2>$null)

Status:
$(& git status --porcelain 2>$null)

Stash List:
$(& git stash list 2>$null)
"@
        
        Set-Content -Path $gitInfoPath -Value $gitInfo
        
        # Create patch of uncommitted changes
        $patchPath = Join-Path $script:BackupPath "uncommitted-changes.patch"
        & git diff > $patchPath 2>$null
        
        # Create patch of staged changes
        $stagedPatchPath = Join-Path $script:BackupPath "staged-changes.patch"
        & git diff --cached > $stagedPatchPath 2>$null
        
        Write-StatusMessage "Git state backup completed" "Success"
        return $true
    }
    catch {
        Write-StatusMessage "Git backup failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Compress-Backup {
    if (-not $Compress) {
        Write-StatusMessage "Skipping compression" "Info"
        return $true
    }
    
    Write-StatusMessage "Compressing backup..." "Info"
    
    try {
        $archivePath = "$script:BackupPath.zip"
        
        # Use PowerShell's Compress-Archive
        Compress-Archive -Path "$script:BackupPath\*" -DestinationPath $archivePath -Force
        
        # Remove uncompressed backup
        Remove-Item -Path $script:BackupPath -Recurse -Force
        
        $archiveSize = [math]::Round((Get-Item $archivePath).Length / 1MB, 2)
        Write-StatusMessage "Backup compressed: $archiveSize MB" "Success"
        
        return $true
    }
    catch {
        Write-StatusMessage "Compression failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Remove-OldBackups {
    param([int]$RetentionDays)
    
    Write-StatusMessage "Cleaning up old backups (retention: $RetentionDays days)..." "Info"
    
    try {
        $cutoffDate = (Get-Date).AddDays(-$RetentionDays)
        $oldBackups = Get-ChildItem -Path $script:BackupRoot | Where-Object {
            $_.CreationTime -lt $cutoffDate -and
            ($_.PSIsContainer -or $_.Extension -eq ".zip")
        }
        
        $removedCount = 0
        $spaceSaved = 0
        
        foreach ($backup in $oldBackups) {
            try {
                if ($backup.PSIsContainer) {
                    $size = (Get-ChildItem -Path $backup.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
                    Remove-Item -Path $backup.FullName -Recurse -Force
                }
                else {
                    $size = $backup.Length
                    Remove-Item -Path $backup.FullName -Force
                }
                
                $spaceSaved += $size
                $removedCount++
                Write-StatusMessage "  🗑️ Removed old backup: $($backup.Name)" "Info"
            }
            catch {
                Write-StatusMessage "  ❌ Failed to remove: $($backup.Name)" "Warning"
            }
        }
        
        if ($removedCount -gt 0) {
            $spaceSavedMB = [math]::Round($spaceSaved / 1MB, 2)
            Write-StatusMessage "Removed $removedCount old backups, freed $spaceSavedMB MB" "Success"
        }
        else {
            Write-StatusMessage "No old backups to remove" "Info"
        }
        
        return $true
    }
    catch {
        Write-StatusMessage "Cleanup failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

function New-BackupReport {
    Write-StatusMessage "Generating backup report..." "Info"
    
    try {
        $reportPath = Join-Path $script:BackupPath "backup-report.md"
        
        $report = @"
# Backup Report
**Timestamp**: $script:BackupTimestamp
**Type**: $BackupType
**Description**: $Description
**Compression**: $($Compress ? "Enabled" : "Disabled")

## Backup Details
- **Backup Path**: $script:BackupPath
- **Created**: $(Get-Date)
- **Retention**: $RetentionDays days

## System Information
- **PowerShell Version**: $($PSVersionTable.PSVersion)
- **OS**: $($PSVersionTable.OS)
- **Machine**: $env:COMPUTERNAME
- **User**: $env:USERNAME

## Next Steps
1. Verify backup integrity if needed
2. Test restore procedure periodically
3. Monitor backup storage space
4. Update retention policy as needed

---
*Generated by Auto-Backup System - GRUPO US VIBECODE SYSTEM V2.0*
"@
        
        Set-Content -Path $reportPath -Value $report
        Write-StatusMessage "Backup report generated: $reportPath" "Success"
        
        return $true
    }
    catch {
        Write-StatusMessage "Report generation failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "💾 AUTO BACKUP - GRUPO US VIBECODE SYSTEM V2.0" "Info"
    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "Backup Type: $BackupType" "Info"
    Write-StatusMessage "Description: $Description" "Info"
    Write-StatusMessage "Compression: $($Compress ? 'Enabled' : 'Disabled')" "Info"
    Write-StatusMessage "Retention: $RetentionDays days" "Info"
    
    # Initialize backup environment
    if (-not (Initialize-BackupEnvironment)) {
        exit 1
    }
    
    # Get critical files
    $criticalFiles = Get-CriticalFiles
    if ($criticalFiles.Count -eq 0) {
        Write-StatusMessage "No critical files found for backup" "Warning"
        exit 1
    }
    
    # Create incremental backup
    if (-not (New-IncrementalBackup -FilePaths $criticalFiles)) {
        exit 1
    }
    
    # Create Git backup
    if (-not (New-GitBackup)) {
        Write-StatusMessage "Git backup failed, but continuing..." "Warning"
    }
    
    # Generate report
    if (-not (New-BackupReport)) {
        Write-StatusMessage "Report generation failed, but continuing..." "Warning"
    }
    
    # Compress if requested
    if (-not (Compress-Backup)) {
        Write-StatusMessage "Compression failed, but backup is complete" "Warning"
    }
    
    # Clean up old backups
    if (-not (Remove-OldBackups -RetentionDays $RetentionDays)) {
        Write-StatusMessage "Cleanup failed, but backup is complete" "Warning"
    }
    
    # Final success message
    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "🎉 AUTO BACKUP COMPLETED SUCCESSFULLY!" "Success"
    Write-StatusMessage "================================================================" "Info"
    
    $finalPath = if ($Compress) { "$script:BackupPath.zip" } else { $script:BackupPath }
    Write-StatusMessage "Backup Location: $finalPath" "Success"
    Write-StatusMessage "Files Backed Up: $($criticalFiles.Count)" "Info"
    
    exit 0
}
catch {
    Write-StatusMessage "Auto backup failed: $($_.Exception.Message)" "Error"
    exit 1
}

# ===============================================================================
# USAGE EXAMPLES
# ===============================================================================
<#
.SYNOPSIS
Automated backup script for GRUPO US VIBECODE SYSTEM V2.0

.DESCRIPTION
Creates incremental backups of critical project files before major changes,
with optional compression and automatic cleanup of old backups.

.PARAMETER BackupType
Type of backup to create (incremental, full)

.PARAMETER Description
Description of the backup for documentation

.PARAMETER Compress
Compress the backup into a ZIP file

.PARAMETER RetentionDays
Number of days to keep old backups (default: 7)

.PARAMETER SkipGit
Skip Git state backup

.EXAMPLE
# Basic backup
.\auto-backup.ps1

.EXAMPLE
# Backup before major refactoring
.\auto-backup.ps1 -Description "Before architecture refactoring" -Compress

.EXAMPLE
# Quick backup without Git info
.\auto-backup.ps1 -Description "Quick checkpoint" -SkipGit -RetentionDays 3
#>
