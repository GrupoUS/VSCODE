# BACKUP RELOCATION SCRIPT - GRUPO US VIBECODE SYSTEM V4.0 + EHS V1
# Relocates all backup files from main project directory to external backup location
# Author: GRUPO US - VIBECODE SYSTEM V4.0
# Date: 2025-01-27

param(
    [string]$SourcePath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE",
    [string]$DestinationPath = "C:\Users\Admin\OneDrive\Documentos\VSCODE-BACKUP",
    [switch]$DryRun = $false,
    [switch]$Verbose = $true
)

# Function to log messages
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "$DestinationPath\backup_relocation.log" -Value $logMessage
}

# Function to ensure directory exists
function Ensure-Directory {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        }
        Write-Log "Created directory: $Path"
    }
}

# Function to move item safely
function Move-ItemSafely {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$ItemType = "File"
    )

    try {
        $destinationDir = Split-Path $Destination -Parent
        Ensure-Directory $destinationDir

        if ($DryRun) {
            Write-Log "DRY RUN: Would move $ItemType from $Source to $Destination" "INFO"
            return $true
        }

        # Check if source exists
        if (-not (Test-Path $Source)) {
            Write-Log "Source not found: $Source" "WARNING"
            return $false
        }

        # Check if destination already exists
        if (Test-Path $Destination) {
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $extension = [System.IO.Path]::GetExtension($Destination)
            $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($Destination)
            $directory = Split-Path $Destination -Parent
            $Destination = Join-Path $directory "$nameWithoutExt`_$timestamp$extension"
            Write-Log "Destination exists, using: $Destination" "WARNING"
        }

        # Perform the move
        Move-Item -Path $Source -Destination $Destination -Force
        Write-Log "Successfully moved $ItemType from $Source to $Destination" "SUCCESS"

        # Verify the move
        if (Test-Path $Destination) {
            Write-Log "Verification successful: $Destination exists" "SUCCESS"
            return $true
        } else {
            Write-Log "Verification failed: $Destination not found after move" "ERROR"
            return $false
        }

    } catch {
        Write-Log "Error moving $ItemType from $Source to $Destination`: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Main execution
Write-Log "Starting backup relocation process" "INFO"
Write-Log "Source: $SourcePath" "INFO"
Write-Log "Destination: $DestinationPath" "INFO"
Write-Log "Dry Run: $DryRun" "INFO"

# Ensure destination directory exists
Ensure-Directory $DestinationPath

# Initialize counters
$totalItems = 0
$successfulMoves = 0
$failedMoves = 0

# Define backup items to move
$backupItems = @(
    @{
        Source = "$SourcePath\test_remediation.py.backup"
        Destination = "$DestinationPath\root_level\test_remediation.py.backup"
        Type = "File"
    },
    @{
        Source = "$SourcePath\@project-core\automation_backup_phase3"
        Destination = "$DestinationPath\project-core\automation_backup_phase3"
        Type = "Directory"
    },
    @{
        Source = "$SourcePath\@project-core\backups"
        Destination = "$DestinationPath\project-core\backups"
        Type = "Directory"
    },
    @{
        Source = "$SourcePath\@project-core\memory\backups"
        Destination = "$DestinationPath\project-core\memory\backups"
        Type = "Directory"
    },
    @{
        Source = "$SourcePath\@project-core\memory\native-rag-system\backups"
        Destination = "$DestinationPath\project-core\memory\native-rag-system\backups"
        Type = "Directory"
    }
)

# Process each backup item
foreach ($item in $backupItems) {
    $totalItems++
    Write-Log "Processing $($item.Type): $($item.Source)" "INFO"

    if (Move-ItemSafely -Source $item.Source -Destination $item.Destination -ItemType $item.Type) {
        $successfulMoves++
    } else {
        $failedMoves++
    }
}

# Look for additional .bak files
Write-Log "Searching for additional .bak files..." "INFO"
$bakFiles = Get-ChildItem -Path $SourcePath -Recurse -Filter "*.bak" -ErrorAction SilentlyContinue

foreach ($bakFile in $bakFiles) {
    $totalItems++
    $relativePath = $bakFile.FullName.Replace($SourcePath, "").TrimStart('\')
    $destinationFile = Join-Path $DestinationPath "additional_bak_files\$relativePath"

    Write-Log "Processing additional .bak file: $($bakFile.FullName)" "INFO"

    if (Move-ItemSafely -Source $bakFile.FullName -Destination $destinationFile -ItemType "File") {
        $successfulMoves++
    } else {
        $failedMoves++
    }
}

# Look for additional backup directories
Write-Log "Searching for additional backup directories..." "INFO"
$backupDirs = Get-ChildItem -Path $SourcePath -Recurse -Directory -ErrorAction SilentlyContinue |
              Where-Object { $_.Name -match "backup|\.backup" -and $_.FullName -notmatch "\\backups\\" }

foreach ($backupDir in $backupDirs) {
    $totalItems++
    $relativePath = $backupDir.FullName.Replace($SourcePath, "").TrimStart('\')
    $destinationDir = Join-Path $DestinationPath "additional_backup_dirs\$relativePath"

    Write-Log "Processing additional backup directory: $($backupDir.FullName)" "INFO"

    if (Move-ItemSafely -Source $backupDir.FullName -Destination $destinationDir -ItemType "Directory") {
        $successfulMoves++
    } else {
        $failedMoves++
    }
}

# Summary
Write-Log "Backup relocation completed" "INFO"
Write-Log "Total items processed: $totalItems" "INFO"
Write-Log "Successful moves: $successfulMoves" "INFO"
Write-Log "Failed moves: $failedMoves" "INFO"

if ($failedMoves -eq 0) {
    Write-Log "All backup items successfully relocated!" "SUCCESS"
    exit 0
} else {
    Write-Log "Some items failed to move. Check log for details." "WARNING"
    exit 1
}
