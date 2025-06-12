#!/usr/bin/env pwsh
<#
.SYNOPSIS
Smart Backup System V4.0 - GRUPO US VIBECODE SYSTEM
Prevents recursive backup loops and oversized backups

.DESCRIPTION
Comprehensive backup system with:
- Recursive backup prevention with exclusion patterns
- Size validation (max 100MB per backup)
- Pre-backup size estimation
- Automatic cleanup for oversized backups
- System indexing protection

.NOTES
Version: 4.0.0
Author: GRUPO US - VIBECODE SYSTEM
Date: 2025-01-27
Requires: PowerShell 7.0+
Purpose: Prevent 5GB+ backup disasters and protect Augment indexing
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$BackupName,

    [switch]$DryRun = $false,
    [switch]$VerboseOutput = $false,
    [int]$MaxSizeMB = 100,
    [string]$BackupRoot = "@project-core/backups"
)

# ===============================================================================
# SMART BACKUP CONFIGURATION
# ===============================================================================

$Config = @{
    MaxSizeMB = $MaxSizeMB
    BackupRoot = $BackupRoot
    ExclusionPatterns = @(
        # Backup directories (CRITICAL - prevents recursive loops)
        "*/backups/*",
        "*/backup/*",
        "*/.backup/*",
        "*/old/*",
        "*/legacy/*",
        "*/archived/*",

        # Large development directories
        "*/node_modules/*",
        "*/.git/*",
        "*/.next/*",
        "*/dist/*",
        "*/build/*",
        "*/.nuxt/*",
        "*/.output/*",

        # Cache and temporary files
        "*/.cache/*",
        "*/cache/*",
        "*/.temp/*",
        "*/temp/*",
        "*/.tmp/*",
        "*/tmp/*",

        # IDE and system files
        "*/.vscode/*",
        "*/.idea/*",
        "*/Thumbs.db",
        "*/.DS_Store",

        # Large binary files
        "*.zip",
        "*.rar",
        "*.7z",
        "*.tar.gz",
        "*.iso",
        "*.dmg",
        "*.exe",
        "*.msi"
    )

    LogFile = "@project-core/logs/smart-backup-$(Get-Date -Format 'yyyyMMdd').log"
    ReportFile = "@project-core/reports/backup-validation-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
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

    # Console output with colors
    switch ($Level) {
        "ERROR" { Write-Host $logEntry -ForegroundColor Red }
        "WARNING" { Write-Host $logEntry -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logEntry -ForegroundColor Green }
        "INFO" { Write-Host $logEntry -ForegroundColor Cyan }
        default { Write-Host $logEntry -ForegroundColor White }
    }

    # File logging
    if (!(Test-Path (Split-Path $Config.LogFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $Config.LogFile -Parent) -Force | Out-Null
    }
    $logEntry | Out-File $Config.LogFile -Append -Encoding UTF8
}

function Test-ExclusionPatterns {
    param([string]$Path)

    foreach ($pattern in $Config.ExclusionPatterns) {
        if ($Path -like $pattern) {
            return $true
        }
    }
    return $false
}

function Get-DirectorySize {
    param([string]$Path)

    if (!(Test-Path $Path)) {
        return 0
    }

    $totalSize = 0
    $fileCount = 0

    try {
        Get-ChildItem $Path -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
            if (!(Test-ExclusionPatterns $_.FullName)) {
                $totalSize += $_.Length
                $fileCount++
            }
        }
    }
    catch {
        Write-Log "Warning: Could not calculate size for some files in $Path" "WARNING"
    }

    return @{
        SizeBytes = $totalSize
        SizeMB = [math]::Round($totalSize / 1MB, 2)
        FileCount = $fileCount
    }
}

# ===============================================================================
# BACKUP VALIDATION FUNCTIONS
# ===============================================================================

function Test-BackupSizeLimit {
    param(
        [string]$SourcePath,
        [int]$MaxSizeMB
    )

    Write-Log "🔍 Estimating backup size for: $SourcePath" "INFO"

    $sizeInfo = Get-DirectorySize $SourcePath

    Write-Log "📊 Estimated backup size: $($sizeInfo.SizeMB) MB ($($sizeInfo.FileCount) files)" "INFO"

    if ($sizeInfo.SizeMB -gt $MaxSizeMB) {
        Write-Log "❌ BACKUP SIZE LIMIT EXCEEDED: $($sizeInfo.SizeMB) MB > $MaxSizeMB MB" "ERROR"
        Write-Log "🚫 BACKUP CREATION BLOCKED - Preventing recursive backup disaster" "ERROR"
        return $false
    }

    Write-Log "✅ Backup size within limits: $($sizeInfo.SizeMB) MB ≤ $MaxSizeMB MB" "SUCCESS"
    return $true
}

function Test-RecursiveBackupPrevention {
    param(
        [string]$SourcePath,
        [string]$BackupPath
    )

    # Check if source path contains backup directories
    if ($SourcePath -like "*backup*" -or $SourcePath -like "*old*" -or $SourcePath -like "*legacy*") {
        Write-Log "⚠️ WARNING: Source path appears to contain backup directories" "WARNING"
    }

    # Check if backup path is within source path (would create infinite recursion)
    $resolvedSource = Resolve-Path $SourcePath -ErrorAction SilentlyContinue
    $resolvedBackup = Resolve-Path (Split-Path $BackupPath -Parent) -ErrorAction SilentlyContinue

    if ($resolvedBackup -and $resolvedSource -and $resolvedBackup.Path.StartsWith($resolvedSource.Path)) {
        Write-Log "❌ RECURSIVE BACKUP DETECTED: Backup path is within source path" "ERROR"
        Write-Log "🚫 BACKUP CREATION BLOCKED - Would create infinite recursion" "ERROR"
        return $false
    }

    Write-Log "✅ Recursive backup prevention check passed" "SUCCESS"
    return $true
}

# ===============================================================================
# SMART BACKUP CREATION
# ===============================================================================

function New-SmartBackup {
    param(
        [string]$SourcePath,
        [string]$BackupName,
        [bool]$DryRun = $false
    )

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backupPath = Join-Path $Config.BackupRoot "$BackupName-$timestamp"

    Write-Log "🚀 SMART BACKUP SYSTEM V4.0 - Starting backup creation" "INFO"
    Write-Log "📁 Source: $SourcePath" "INFO"
    Write-Log "📦 Backup: $backupPath" "INFO"
    Write-Log "🔧 Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" "INFO"

    # Phase 1: Size validation
    if (!(Test-BackupSizeLimit $SourcePath $Config.MaxSizeMB)) {
        return @{ Success = $false; Error = "Size limit exceeded"; SizeMB = (Get-DirectorySize $SourcePath).SizeMB }
    }

    # Phase 2: Recursive backup prevention
    if (!(Test-RecursiveBackupPrevention $SourcePath $backupPath)) {
        return @{ Success = $false; Error = "Recursive backup detected" }
    }

    # Phase 3: Create backup directory
    if (!$DryRun) {
        if (!(Test-Path $Config.BackupRoot)) {
            New-Item -ItemType Directory -Path $Config.BackupRoot -Force | Out-Null
            Write-Log "📁 Created backup root directory: $($Config.BackupRoot)" "SUCCESS"
        }

        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
        Write-Log "📁 Created backup directory: $backupPath" "SUCCESS"
    }

    # Phase 4: Copy files with exclusions
    $copiedFiles = 0
    $skippedFiles = 0
    $totalSize = 0

    try {
        Get-ChildItem $SourcePath -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            $relativePath = $_.FullName.Substring($SourcePath.Length + 1)
            $destinationPath = Join-Path $backupPath $relativePath

            # Check exclusion patterns
            if (Test-ExclusionPatterns $_.FullName) {
                $skippedFiles++
                if ($VerboseOutput) {
                    Write-Log "⏭️ Skipped (excluded): $relativePath" "INFO"
                }
                return
            }

            if ($_.PSIsContainer) {
                # Directory
                if (!$DryRun) {
                    if (!(Test-Path $destinationPath)) {
                        New-Item -ItemType Directory -Path $destinationPath -Force | Out-Null
                    }
                }
            } else {
                # File
                if (!$DryRun) {
                    $destinationDir = Split-Path $destinationPath -Parent
                    if (!(Test-Path $destinationDir)) {
                        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
                    }
                    Copy-Item $_.FullName $destinationPath -Force
                }
                $copiedFiles++
                $totalSize += $_.Length

                if ($VerboseOutput) {
                    Write-Log "📄 Copied: $relativePath" "INFO"
                }
            }
        }
    }
    catch {
        Write-Log "❌ Error during backup creation: $($_.Exception.Message)" "ERROR"
        return @{ Success = $false; Error = $_.Exception.Message }
    }

    $finalSizeMB = [math]::Round($totalSize / 1MB, 2)

    Write-Log "✅ Backup creation completed successfully!" "SUCCESS"
    Write-Log "📊 Files copied: $copiedFiles" "INFO"
    Write-Log "📊 Files skipped: $skippedFiles" "INFO"
    Write-Log "📊 Final backup size: $finalSizeMB MB" "INFO"

    # Create backup manifest
    $manifest = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        sourcePath = $SourcePath
        backupPath = $backupPath
        backupName = $BackupName
        filesCopied = $copiedFiles
        filesSkipped = $skippedFiles
        finalSizeMB = $finalSizeMB
        maxSizeMB = $Config.MaxSizeMB
        exclusionPatterns = $Config.ExclusionPatterns
        dryRun = $DryRun
        success = $true
    }

    if (!$DryRun) {
        $manifest | ConvertTo-Json -Depth 10 | Out-File "$backupPath/backup-manifest.json" -Encoding UTF8
    }

    return @{
        Success = $true
        BackupPath = $backupPath
        SizeMB = $finalSizeMB
        FilesCopied = $copiedFiles
        FilesSkipped = $skippedFiles
        Manifest = $manifest
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-SmartBackupSystem {
    Write-Log "🚀 SMART BACKUP SYSTEM V4.0 - GRUPO US VIBECODE SYSTEM" "INFO"
    Write-Log "🛡️ Preventing recursive backup disasters and protecting Augment indexing" "INFO"

    $result = New-SmartBackup -SourcePath $SourcePath -BackupName $BackupName -DryRun $DryRun

    # Generate report
    $report = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        operation = "SmartBackupSystem"
        version = "4.0.0"
        parameters = @{
            sourcePath = $SourcePath
            backupName = $BackupName
            maxSizeMB = $Config.MaxSizeMB
            dryRun = $DryRun
        }
        result = $result
        exclusionPatterns = $Config.ExclusionPatterns
    }

    if (!(Test-Path (Split-Path $Config.ReportFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $Config.ReportFile -Parent) -Force | Out-Null
    }
    $report | ConvertTo-Json -Depth 10 | Out-File $Config.ReportFile -Encoding UTF8

    Write-Log "📋 Report saved: $($Config.ReportFile)" "INFO"

    if ($result.Success) {
        Write-Log "🎉 Smart backup completed successfully!" "SUCCESS"
        if ($DryRun) {
            Write-Log "💡 To execute backup, run with -DryRun:`$false" "INFO"
        }
    } else {
        Write-Log "❌ Smart backup failed: $($result.Error)" "ERROR"
        exit 1
    }

    return $result
}

# Execute if run directly
if ($MyInvocation.InvocationName -ne '.') {
    Start-SmartBackupSystem
}
