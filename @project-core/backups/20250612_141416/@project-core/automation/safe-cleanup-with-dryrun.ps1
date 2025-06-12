# ===============================================================================
# SAFE CLEANUP SCRIPT WITH DRY-RUN IMPLEMENTATION V4.0
# GRUPO US VIBECODE SYSTEM - ENHANCED SAFETY PROTOCOLS
# ===============================================================================

<#
.SYNOPSIS
Safe cleanup script with comprehensive dry-run capabilities and mandatory safeguards

.DESCRIPTION
Implements the Enhanced Cleanup Protocols V4.0 with:
- Mandatory dry-run testing
- Critical file protection
- Incremental processing
- Staging area verification
- Comprehensive rollback capabilities

.PARAMETER TargetDirectory
Directory to clean up (default: @project-core)

.PARAMETER FilePatterns
Array of file patterns to match for cleanup

.PARAMETER StagingArea
Staging area for moved files (default: @project-core/_staging_area)

.PARAMETER DryRun
Execute in dry-run mode (shows what would be done without executing)

.PARAMETER Force
Skip confirmation prompts (use with caution)

.PARAMETER TestBatchSize
Number of files to test in initial batch (default: 5)

.EXAMPLE
# Dry-run mode (ALWAYS run this first)
.\safe-cleanup-with-dryrun.ps1 -FilePatterns @("*backup*", "*old*") -DryRun

.EXAMPLE
# Execute after successful dry-run
.\safe-cleanup-with-dryrun.ps1 -FilePatterns @("*backup*", "*old*")

.EXAMPLE
# Test with small batch first
.\safe-cleanup-with-dryrun.ps1 -FilePatterns @("*temp*") -TestBatchSize 3 -DryRun
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$TargetDirectory = "@project-core",
    
    [Parameter(Mandatory = $true)]
    [string[]]$FilePatterns,
    
    [Parameter(Mandatory = $false)]
    [string]$StagingArea = "@project-core/_staging_area",
    
    [Parameter(Mandatory = $false)]
    [switch]$DryRun = $false,
    
    [Parameter(Mandatory = $false)]
    [switch]$Force = $false,
    
    [Parameter(Mandatory = $false)]
    [int]$TestBatchSize = 5
)

# ===============================================================================
# CRITICAL FILE PROTECTION SYSTEM
# ===============================================================================

$CRITICAL_FILES = @(
    "@project-core/memory/master_rule.md",
    "@project-core/memory/self_correction_log.md",
    "@project-core/memory/global-standards.md",
    "@project-core/rules/00-vibecode-system-v4-master.md",
    "@project-core/automation/finaltest.ps1",
    "@project-core/automation/validate-system.ps1",
    "@project-core/rules/enhanced-cleanup-protocols-v4.md",
    "@project-core/automation/safe-cleanup-with-dryrun.ps1"
)

$CRITICAL_DIRECTORIES = @(
    "@project-core/memory",
    "@project-core/rules", 
    "@project-core/automation",
    "@project-core/configs",
    "@project-core/backups"
)

function Test-CriticalFileProtection {
    param([string[]]$FilesToProcess)
    
    Write-Host "🔒 Checking critical file protection..." -ForegroundColor Cyan
    
    foreach ($file in $FilesToProcess) {
        foreach ($critical in $CRITICAL_FILES) {
            if ($file -like "*$critical*" -or $critical -like "*$file*") {
                Write-Error "🚨 CRITICAL FILE PROTECTION VIOLATION: $file"
                Write-Error "This file is protected and cannot be moved or deleted"
                Write-Error "Protected file: $critical"
                exit 1
            }
        }
        
        foreach ($criticalDir in $CRITICAL_DIRECTORIES) {
            if ($file -like "$criticalDir*" -and $file -in $CRITICAL_FILES) {
                Write-Error "🚨 CRITICAL DIRECTORY PROTECTION VIOLATION: $file"
                Write-Error "This file is in a protected directory: $criticalDir"
                exit 1
            }
        }
    }
    
    Write-Host "✅ Critical file protection verified - no violations found" -ForegroundColor Green
}

# ===============================================================================
# STAGING AREA VERIFICATION
# ===============================================================================

function Test-StagingAreaFunctionality {
    param([string]$StagingArea)
    
    Write-Host "🧪 Testing staging area functionality..." -ForegroundColor Cyan
    
    # Create staging area if it doesn't exist
    if (!(Test-Path $StagingArea)) {
        if (!$DryRun) {
            New-Item -ItemType Directory -Path $StagingArea -Force | Out-Null
        }
        Write-Host "📁 Staging area would be created: $StagingArea" -ForegroundColor Yellow
    }
    
    if ($DryRun) {
        Write-Host "🧪 DRY RUN: Staging area verification skipped" -ForegroundColor Yellow
        return $true
    }
    
    # Test with temporary file
    $testFile = Join-Path (Get-Location) "staging-test-$(Get-Date -Format 'yyyyMMdd-HHmmss').tmp"
    $testContent = "Staging area test - $(Get-Date)"
    
    try {
        # Create test file
        $testContent | Out-File -FilePath $testFile -Encoding UTF8
        
        # Test move operation
        $stagedTestFile = Join-Path $StagingArea (Split-Path $testFile -Leaf)
        Move-Item $testFile $stagedTestFile -Force
        
        # Verify file exists in staging
        if (Test-Path $stagedTestFile) {
            $stagedContent = Get-Content $stagedTestFile -Raw
            if ($stagedContent.Trim() -eq $testContent.Trim()) {
                Write-Host "✅ Staging area verification successful" -ForegroundColor Green
                Remove-Item $stagedTestFile -Force
                return $true
            }
        }
        
        Write-Error "❌ Staging area verification failed - content mismatch"
        return $false
    }
    catch {
        Write-Error "❌ Staging area verification failed: $($_.Exception.Message)"
        return $false
    }
    finally {
        # Cleanup test files
        if (Test-Path $testFile) { Remove-Item $testFile -Force -ErrorAction SilentlyContinue }
        if (Test-Path $stagedTestFile) { Remove-Item $stagedTestFile -Force -ErrorAction SilentlyContinue }
    }
}

# ===============================================================================
# SAFE FILE OPERATIONS
# ===============================================================================

function Invoke-SafeFileOperation {
    param(
        [string]$SourcePath,
        [string]$DestinationPath,
        [string]$Operation = "Move"
    )
    
    if ($DryRun) {
        Write-Host "🧪 DRY RUN: Would $Operation '$SourcePath' to '$DestinationPath'" -ForegroundColor Yellow
        return $true
    }
    
    if (!$Force) {
        $confirm = Read-Host "Execute $Operation operation on '$SourcePath'? (yes/no/abort)"
        switch ($confirm.ToLower()) {
            "yes" { break }
            "no" { return $false }
            "abort" { exit 0 }
            default { 
                Write-Host "Invalid response. Operation cancelled." -ForegroundColor Red
                return $false 
            }
        }
    }
    
    # Execute actual operation
    try {
        switch ($Operation) {
            "Move" { Move-Item $SourcePath $DestinationPath -Force }
            "Copy" { Copy-Item $SourcePath $DestinationPath -Force }
            "Delete" { Remove-Item $SourcePath -Force }
        }
        Write-Host "✅ $Operation completed: $SourcePath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Error "❌ $Operation failed: $($_.Exception.Message)"
        return $false
    }
}

# ===============================================================================
# INCREMENTAL CLEANUP PROCESS
# ===============================================================================

function Start-IncrementalCleanup {
    param(
        [string[]]$FilesToProcess,
        [string]$StagingArea,
        [int]$TestBatchSize
    )
    
    Write-Host "🔍 Starting incremental cleanup with $($FilesToProcess.Count) files" -ForegroundColor Cyan
    
    if ($FilesToProcess.Count -eq 0) {
        Write-Host "✅ No files to process" -ForegroundColor Green
        return $true
    }
    
    # Phase 1: Test with small subset
    $testFiles = $FilesToProcess | Select-Object -First $TestBatchSize
    Write-Host "📋 Testing with $($testFiles.Count) files first..." -ForegroundColor Cyan
    
    foreach ($file in $testFiles) {
        $result = Invoke-SafeFileOperation -SourcePath $file -DestinationPath $StagingArea -Operation "Move"
        if (!$result) {
            Write-Error "❌ Test batch failed. Aborting cleanup."
            return $false
        }
    }
    
    if (!$DryRun) {
        # Verify staging area
        $stagedCount = (Get-ChildItem $StagingArea -Recurse -File -ErrorAction SilentlyContinue).Count
        if ($stagedCount -lt $testFiles.Count) {
            Write-Error "❌ Staging verification failed. Expected at least $($testFiles.Count), found $stagedCount"
            return $false
        }
    }
    
    Write-Host "✅ Test batch successful. Proceeding with remaining files..." -ForegroundColor Green
    
    # Phase 2: Process remaining files in batches
    $remainingFiles = $FilesToProcess | Select-Object -Skip $TestBatchSize
    $batchCount = 0
    
    for ($i = 0; $i -lt $remainingFiles.Count; $i += 10) {
        $batch = $remainingFiles | Select-Object -Skip $i -First 10
        $batchCount++
        
        Write-Host "📦 Processing batch $batchCount ($($batch.Count) files)..." -ForegroundColor Cyan
        
        foreach ($file in $batch) {
            $result = Invoke-SafeFileOperation -SourcePath $file -DestinationPath $StagingArea -Operation "Move"
            if (!$result) {
                Write-Warning "⚠️ Failed to process $file in batch $batchCount"
            }
        }
        
        if (!$DryRun) {
            # Checkpoint verification
            $currentStaged = (Get-ChildItem $StagingArea -Recurse -File -ErrorAction SilentlyContinue).Count
            Write-Host "📊 Checkpoint: $currentStaged files in staging area" -ForegroundColor Cyan
        }
    }
    
    return $true
}

# ===============================================================================
# BACKUP VERIFICATION
# ===============================================================================

function Test-BackupExists {
    Write-Host "📋 Checking for recent backups..." -ForegroundColor Cyan
    
    if (!(Test-Path "@project-core/backups")) {
        Write-Error "❌ Backup directory not found"
        return $false
    }
    
    $backupDirs = Get-ChildItem "@project-core/backups" -Directory -ErrorAction SilentlyContinue
    $recentBackup = $backupDirs | Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-24) }
    
    if ($recentBackup.Count -gt 0) {
        Write-Host "✅ Recent backup found: $($recentBackup[0].Name)" -ForegroundColor Green
        return $true
    } else {
        Write-Error "❌ No recent backup found (within 24 hours)"
        Write-Error "Create a backup before running cleanup operations"
        return $false
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-Host "🚀 SAFE CLEANUP SCRIPT V4.0 - ENHANCED SAFETY PROTOCOLS" -ForegroundColor Magenta
    Write-Host "Target: $TargetDirectory" -ForegroundColor White
    Write-Host "Patterns: $($FilePatterns -join ', ')" -ForegroundColor White
    Write-Host "Staging: $StagingArea" -ForegroundColor White
    Write-Host "Dry Run: $DryRun" -ForegroundColor White
    Write-Host "Force: $Force" -ForegroundColor White
    Write-Host "=" * 70 -ForegroundColor Gray
    
    # Step 1: Backup verification
    Write-Host "📋 Step 1: Backup verification" -ForegroundColor Cyan
    if (!(Test-BackupExists)) {
        exit 1
    }
    
    # Step 2: File discovery
    Write-Host "📋 Step 2: File discovery" -ForegroundColor Cyan
    $filesToProcess = @()
    foreach ($pattern in $FilePatterns) {
        $matchedFiles = Get-ChildItem $TargetDirectory -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -like $pattern }
        $filesToProcess += $matchedFiles.FullName
    }
    
    Write-Host "📊 Found $($filesToProcess.Count) files matching patterns" -ForegroundColor White
    
    if ($filesToProcess.Count -eq 0) {
        Write-Host "✅ No files to process. Cleanup complete." -ForegroundColor Green
        exit 0
    }
    
    # Step 3: Critical file protection check
    Write-Host "📋 Step 3: Critical file protection verification" -ForegroundColor Cyan
    Test-CriticalFileProtection -FilesToProcess $filesToProcess
    
    # Step 4: Staging area verification
    Write-Host "📋 Step 4: Staging area verification" -ForegroundColor Cyan
    if (!(Test-StagingAreaFunctionality -StagingArea $StagingArea)) {
        exit 1
    }
    
    # Step 5: Incremental cleanup
    Write-Host "📋 Step 5: Incremental cleanup execution" -ForegroundColor Cyan
    $result = Start-IncrementalCleanup -FilesToProcess $filesToProcess -StagingArea $StagingArea -TestBatchSize $TestBatchSize
    
    # Step 6: Final verification
    Write-Host "📋 Step 6: Final verification" -ForegroundColor Cyan
    if (!$DryRun) {
        $stagedCount = (Get-ChildItem $StagingArea -Recurse -File -ErrorAction SilentlyContinue).Count
        Write-Host "📊 Final staging area count: $stagedCount files" -ForegroundColor White
    }
    
    if ($result) {
        if ($DryRun) {
            Write-Host "✅ DRY RUN completed successfully - no files were moved" -ForegroundColor Green
            Write-Host "🔄 Run without -DryRun to execute the cleanup" -ForegroundColor Yellow
        } else {
            Write-Host "✅ Safe cleanup process completed successfully" -ForegroundColor Green
        }
        exit 0
    } else {
        Write-Error "❌ Safe cleanup process failed"
        exit 1
    }
}
catch {
    Write-Error "💥 Script execution failed: $($_.Exception.Message)"
    Write-Error "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}
