#!/usr/bin/env pwsh
<#
.SYNOPSIS
Backup Monitoring System - GRUPO US VIBECODE SYSTEM V4.0
Monitors backup directory growth and prevents indexing conflicts

.DESCRIPTION
Comprehensive backup monitoring system that:
- Monitors backup directory size growth
- Detects oversized backups automatically
- Provides cleanup recommendations
- Protects Augment workspace indexing performance
- Generates monitoring reports

.NOTES
Version: 4.0.0
Author: GRUPO US - VIBECODE SYSTEM
Date: 2025-01-27
Requires: PowerShell 7.0+
Purpose: Prevent backup-related indexing performance issues
#>

param(
    [string]$BackupRoot = "@project-core/backups",
    [int]$MaxTotalSizeGB = 1,
    [int]$MaxIndividualSizeMB = 100,
    [switch]$AutoCleanup = $false,
    [switch]$DryRun = $false,
    [switch]$Verbose = $false
)

# ===============================================================================
# MONITORING CONFIGURATION
# ===============================================================================

$Config = @{
    BackupRoot = $BackupRoot
    MaxTotalSizeGB = $MaxTotalSizeGB
    MaxIndividualSizeMB = $MaxIndividualSizeMB
    AutoCleanup = $AutoCleanup
    
    # Thresholds for alerts
    WarningThresholdGB = $MaxTotalSizeGB * 0.8  # 80% of max
    CriticalThresholdGB = $MaxTotalSizeGB * 0.95  # 95% of max
    
    LogFile = "@project-core/logs/backup-monitoring-$(Get-Date -Format 'yyyyMMdd').log"
    ReportFile = "@project-core/reports/backup-monitoring-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    AlertFile = "@project-core/reports/backup-alerts-$(Get-Date -Format 'yyyyMMdd').json"
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
        "CRITICAL" { Write-Host $logEntry -ForegroundColor Magenta }
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

function Get-DirectorySize {
    param([string]$Path)
    
    if (!(Test-Path $Path)) {
        return @{ SizeBytes = 0; SizeMB = 0; SizeGB = 0; FileCount = 0 }
    }
    
    $totalSize = 0
    $fileCount = 0
    
    try {
        Get-ChildItem $Path -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
            $totalSize += $_.Length
            $fileCount++
        }
    }
    catch {
        Write-Log "Warning: Could not calculate size for some files in $Path" "WARNING"
    }
    
    return @{
        SizeBytes = $totalSize
        SizeMB = [math]::Round($totalSize / 1MB, 2)
        SizeGB = [math]::Round($totalSize / 1GB, 3)
        FileCount = $fileCount
    }
}

# ===============================================================================
# BACKUP MONITORING FUNCTIONS
# ===============================================================================

function Get-BackupDirectoryAnalysis {
    Write-Log "🔍 Analyzing backup directory structure..." "INFO"
    
    if (!(Test-Path $Config.BackupRoot)) {
        Write-Log "📁 Backup root directory does not exist: $($Config.BackupRoot)" "INFO"
        return @{
            TotalSize = @{ SizeBytes = 0; SizeMB = 0; SizeGB = 0; FileCount = 0 }
            Directories = @()
            Issues = @()
        }
    }
    
    $backupDirs = Get-ChildItem $Config.BackupRoot -Directory -ErrorAction SilentlyContinue
    $analysis = @{
        TotalSize = @{ SizeBytes = 0; SizeMB = 0; SizeGB = 0; FileCount = 0 }
        Directories = @()
        Issues = @()
    }
    
    foreach ($dir in $backupDirs) {
        Write-Log "📊 Analyzing: $($dir.Name)" "INFO"
        
        $dirSize = Get-DirectorySize $dir.FullName
        $dirInfo = @{
            Name = $dir.Name
            Path = $dir.FullName
            Created = $dir.CreationTime
            LastModified = $dir.LastWriteTime
            Size = $dirSize
            IsOversized = $dirSize.SizeMB -gt $Config.MaxIndividualSizeMB
            Age = (Get-Date) - $dir.CreationTime
        }
        
        # Check for issues
        if ($dirInfo.IsOversized) {
            $issue = @{
                Type = "OversizedBackup"
                Directory = $dir.Name
                SizeMB = $dirSize.SizeMB
                MaxSizeMB = $Config.MaxIndividualSizeMB
                Severity = if ($dirSize.SizeMB -gt ($Config.MaxIndividualSizeMB * 10)) { "CRITICAL" } else { "WARNING" }
                Recommendation = "Consider cleanup or compression"
            }
            $analysis.Issues += $issue
            
            Write-Log "⚠️ Oversized backup detected: $($dir.Name) ($($dirSize.SizeMB) MB)" "WARNING"
        }
        
        # Check for recursive backup patterns
        if ($dir.Name -like "*backup*" -and (Get-ChildItem $dir.FullName -Directory -Name | Where-Object { $_ -like "*backup*" })) {
            $issue = @{
                Type = "RecursiveBackup"
                Directory = $dir.Name
                Severity = "CRITICAL"
                Recommendation = "Immediate cleanup required - recursive backup detected"
            }
            $analysis.Issues += $issue
            
            Write-Log "🚨 CRITICAL: Recursive backup pattern detected in: $($dir.Name)" "CRITICAL"
        }
        
        $analysis.Directories += $dirInfo
        $analysis.TotalSize.SizeBytes += $dirSize.SizeBytes
        $analysis.TotalSize.FileCount += $dirSize.FileCount
    }
    
    # Calculate total size
    $analysis.TotalSize.SizeMB = [math]::Round($analysis.TotalSize.SizeBytes / 1MB, 2)
    $analysis.TotalSize.SizeGB = [math]::Round($analysis.TotalSize.SizeBytes / 1GB, 3)
    
    # Check total size thresholds
    if ($analysis.TotalSize.SizeGB -gt $Config.CriticalThresholdGB) {
        $issue = @{
            Type = "TotalSizeCritical"
            SizeGB = $analysis.TotalSize.SizeGB
            MaxSizeGB = $Config.MaxTotalSizeGB
            Severity = "CRITICAL"
            Recommendation = "Immediate cleanup required - total backup size exceeds critical threshold"
        }
        $analysis.Issues += $issue
        Write-Log "🚨 CRITICAL: Total backup size exceeds critical threshold: $($analysis.TotalSize.SizeGB) GB" "CRITICAL"
    }
    elseif ($analysis.TotalSize.SizeGB -gt $Config.WarningThresholdGB) {
        $issue = @{
            Type = "TotalSizeWarning"
            SizeGB = $analysis.TotalSize.SizeGB
            MaxSizeGB = $Config.MaxTotalSizeGB
            Severity = "WARNING"
            Recommendation = "Consider cleanup - total backup size approaching limit"
        }
        $analysis.Issues += $issue
        Write-Log "⚠️ WARNING: Total backup size approaching limit: $($analysis.TotalSize.SizeGB) GB" "WARNING"
    }
    
    return $analysis
}

function Get-CleanupRecommendations {
    param($Analysis)
    
    $recommendations = @()
    
    # Sort directories by size (largest first)
    $sortedDirs = $Analysis.Directories | Sort-Object { $_.Size.SizeMB } -Descending
    
    foreach ($dir in $sortedDirs) {
        if ($dir.IsOversized) {
            $rec = @{
                Action = "Delete or Compress"
                Directory = $dir.Name
                SizeMB = $dir.Size.SizeMB
                Age = $dir.Age.Days
                Priority = if ($dir.Size.SizeMB -gt ($Config.MaxIndividualSizeMB * 10)) { "HIGH" } else { "MEDIUM" }
                Command = "Remove-Item '$($dir.Path)' -Recurse -Force"
            }
            $recommendations += $rec
        }
        elseif ($dir.Age.Days -gt 30 -and $dir.Size.SizeMB -gt 10) {
            $rec = @{
                Action = "Archive"
                Directory = $dir.Name
                SizeMB = $dir.Size.SizeMB
                Age = $dir.Age.Days
                Priority = "LOW"
                Command = "Compress-Archive -Path '$($dir.Path)' -DestinationPath '$($dir.Path).zip' && Remove-Item '$($dir.Path)' -Recurse -Force"
            }
            $recommendations += $rec
        }
    }
    
    return $recommendations
}

function Invoke-AutoCleanup {
    param($Analysis, $Recommendations)
    
    if (!$Config.AutoCleanup) {
        Write-Log "ℹ️ Auto-cleanup disabled. Use -AutoCleanup to enable automatic cleanup." "INFO"
        return
    }
    
    Write-Log "🧹 Starting automatic cleanup..." "INFO"
    
    $cleanedSize = 0
    $cleanedCount = 0
    
    foreach ($rec in $Recommendations) {
        if ($rec.Priority -eq "HIGH" -or ($rec.Priority -eq "MEDIUM" -and $Analysis.TotalSize.SizeGB -gt $Config.CriticalThresholdGB)) {
            Write-Log "🗑️ Auto-cleanup: $($rec.Action) - $($rec.Directory) ($($rec.SizeMB) MB)" "INFO"
            
            if (!$DryRun) {
                try {
                    Invoke-Expression $rec.Command
                    $cleanedSize += $rec.SizeMB
                    $cleanedCount++
                    Write-Log "✅ Cleaned up: $($rec.Directory)" "SUCCESS"
                }
                catch {
                    Write-Log "❌ Failed to clean up $($rec.Directory): $($_.Exception.Message)" "ERROR"
                }
            }
            else {
                Write-Log "🔍 [DRY RUN] Would clean up: $($rec.Directory)" "INFO"
                $cleanedSize += $rec.SizeMB
                $cleanedCount++
            }
        }
    }
    
    Write-Log "📊 Auto-cleanup summary: $cleanedCount items, $([math]::Round($cleanedSize / 1024, 2)) GB freed" "SUCCESS"
}

# ===============================================================================
# MAIN MONITORING EXECUTION
# ===============================================================================

function Start-BackupMonitoring {
    Write-Log "🚀 BACKUP MONITORING SYSTEM V4.0 - GRUPO US VIBECODE SYSTEM" "INFO"
    Write-Log "🛡️ Protecting Augment workspace indexing performance" "INFO"
    
    # Perform analysis
    $analysis = Get-BackupDirectoryAnalysis
    
    # Generate recommendations
    $recommendations = Get-CleanupRecommendations $analysis
    
    # Display summary
    Write-Log "📊 BACKUP MONITORING SUMMARY:" "INFO"
    Write-Log "  • Total backup size: $($analysis.TotalSize.SizeGB) GB" "INFO"
    Write-Log "  • Total directories: $($analysis.Directories.Count)" "INFO"
    Write-Log "  • Total files: $($analysis.TotalSize.FileCount)" "INFO"
    Write-Log "  • Issues detected: $($analysis.Issues.Count)" "INFO"
    Write-Log "  • Cleanup recommendations: $($recommendations.Count)" "INFO"
    
    # Handle issues
    if ($analysis.Issues.Count -gt 0) {
        Write-Log "⚠️ ISSUES DETECTED:" "WARNING"
        foreach ($issue in $analysis.Issues) {
            Write-Log "  • [$($issue.Severity)] $($issue.Type): $($issue.Recommendation)" $issue.Severity
        }
    }
    
    # Auto-cleanup if enabled
    if ($Config.AutoCleanup -or $analysis.Issues | Where-Object { $_.Severity -eq "CRITICAL" }) {
        Invoke-AutoCleanup $analysis $recommendations
    }
    
    # Generate reports
    $report = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        operation = "BackupMonitoring"
        version = "4.0.0"
        configuration = $Config
        analysis = $analysis
        recommendations = $recommendations
        summary = @{
            totalSizeGB = $analysis.TotalSize.SizeGB
            directoryCount = $analysis.Directories.Count
            issueCount = $analysis.Issues.Count
            recommendationCount = $recommendations.Count
        }
    }
    
    # Save reports
    if (!(Test-Path (Split-Path $Config.ReportFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $Config.ReportFile -Parent) -Force | Out-Null
    }
    $report | ConvertTo-Json -Depth 10 | Out-File $Config.ReportFile -Encoding UTF8
    Write-Log "📋 Report saved: $($Config.ReportFile)" "INFO"
    
    # Save alerts if issues exist
    if ($analysis.Issues.Count -gt 0) {
        $analysis.Issues | ConvertTo-Json -Depth 10 | Out-File $Config.AlertFile -Encoding UTF8
        Write-Log "🚨 Alerts saved: $($Config.AlertFile)" "WARNING"
    }
    
    Write-Log "✅ Backup monitoring completed!" "SUCCESS"
    
    return $report
}

# Execute if run directly
if ($MyInvocation.InvocationName -ne '.') {
    Start-BackupMonitoring
}
