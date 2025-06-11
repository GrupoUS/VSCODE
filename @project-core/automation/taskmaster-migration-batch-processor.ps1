# TASKMASTER TO MCP SHRIMP TASK MANAGER BATCH MIGRATION PROCESSOR
# GRUPO US VIBECODE SYSTEM V4.0 - Comprehensive Rule Migration
# Created: 2025-01-11
# Purpose: Systematic batch replacement of TaskMaster references

param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $true,
    [string]$TargetDirectory = "@project-core"
)

# ===============================================================================
# MIGRATION CONFIGURATION
# ===============================================================================

$REPLACEMENT_MAPPINGS = @{
    "TaskMaster" = "MCP Shrimp Task Manager"
    "taskmaster" = "MCP Shrimp Task Manager"
    "TASKMASTER" = "MCP SHRIMP TASK MANAGER"
    "task-master" = "MCP Shrimp Task Manager"
    "task_master" = "MCP Shrimp Task Manager"
    "TaskMaster AI" = "MCP Shrimp Task Manager"
    "TaskMaster Protocol" = "MCP Shrimp Task Manager Protocol"
    "TaskMaster system" = "MCP Shrimp Task Manager system"
    "TaskMaster integration" = "MCP Shrimp Task Manager integration"
    "TaskMaster workflow" = "MCP Shrimp Task Manager workflow"
    "TaskMaster execution" = "MCP Shrimp Task Manager execution"
    "TaskMaster coordination" = "MCP Shrimp Task Manager coordination"
    "TaskMaster tools" = "MCP Shrimp Task Manager tools"
    "TaskMaster commands" = "MCP Shrimp Task Manager commands"
    "TaskMaster API" = "MCP Shrimp Task Manager API"
    "TaskMaster configuration" = "MCP Shrimp Task Manager configuration"
    "TaskMaster methodology" = "MCP Shrimp Task Manager methodology"
    "TaskMaster Performance" = "MCP Shrimp Task Manager Performance"
    "taskmaster-protocol.md" = "mcp-shrimp-task-manager-protocol.md"
    "taskmaster-integration-unified.md" = "mcp-shrimp-task-manager-integration-unified.md"
}

$SEARCH_DIRECTORIES = @(
    "$TargetDirectory/rules",
    "$TargetDirectory/workflows"
)

$FILE_EXTENSIONS = @("*.md", "*.json", "*.js", "*.ts", "*.ps1", "*.txt")

$PROCESSED_FILES = @()
$MIGRATION_LOG = @()

# ===============================================================================
# UTILITY FUNCTIONS
# ===============================================================================

function Write-MigrationMessage {
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
        "PROCESS" { Write-Host "[$timestamp] 🔄 $Message" -ForegroundColor Cyan }
        default { Write-Host "[$timestamp] $Message" -ForegroundColor White }
    }
}

function Test-FileContainsTaskMaster {
    param([string]$FilePath)
    
    try {
        $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
        if ($content) {
            foreach ($pattern in $REPLACEMENT_MAPPINGS.Keys) {
                if ($content -match [regex]::Escape($pattern)) {
                    return $true
                }
            }
        }
        return $false
    }
    catch {
        Write-MigrationMessage "Error reading file $FilePath`: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Invoke-FileTaskMasterMigration {
    param([string]$FilePath)
    
    Write-MigrationMessage "Processing file: $FilePath" "PROCESS"
    
    try {
        # Read file content
        $originalContent = Get-Content $FilePath -Raw -ErrorAction Stop
        $modifiedContent = $originalContent
        $replacementCount = 0
        
        # Apply all replacement mappings
        foreach ($pattern in $REPLACEMENT_MAPPINGS.Keys) {
            $replacement = $REPLACEMENT_MAPPINGS[$pattern]
            
            # Use regex for case-sensitive exact matches
            $regex = [regex]::new([regex]::Escape($pattern))
            $matches = $regex.Matches($modifiedContent)
            
            if ($matches.Count -gt 0) {
                $modifiedContent = $regex.Replace($modifiedContent, $replacement)
                $replacementCount += $matches.Count
                
                if ($Verbose) {
                    Write-MigrationMessage "  Replaced '$pattern' → '$replacement' ($($matches.Count) occurrences)" "INFO"
                }
            }
        }
        
        # Write modified content if changes were made
        if ($replacementCount -gt 0) {
            if (-not $DryRun) {
                Set-Content $FilePath $modifiedContent -Encoding UTF8 -NoNewline
                Write-MigrationMessage "  File updated: $replacementCount total replacements" "SUCCESS"
            } else {
                Write-MigrationMessage "  DRY RUN: Would make $replacementCount replacements" "WARNING"
            }
            
            # Log the migration
            $MIGRATION_LOG += @{
                File = $FilePath
                Replacements = $replacementCount
                Status = if ($DryRun) { "DRY_RUN" } else { "COMPLETED" }
                Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            }
            
            return $true
        } else {
            Write-MigrationMessage "  No TaskMaster references found" "INFO"
            return $false
        }
    }
    catch {
        Write-MigrationMessage "Error processing file $FilePath`: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function New-MigrationReport {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportPath = "$TargetDirectory/docs/taskmaster-migration-batch-report-$timestamp.md"
    
    $report = @"
# 🔄 TASKMASTER MIGRATION BATCH REPORT

**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Mode**: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })  
**Target Directory**: $TargetDirectory

---

## 📊 MIGRATION SUMMARY

**Total Files Processed**: $($PROCESSED_FILES.Count)  
**Files Modified**: $($MIGRATION_LOG.Count)  
**Total Replacements**: $(($MIGRATION_LOG | Measure-Object -Property Replacements -Sum).Sum)

---

## 📋 PROCESSED FILES

"@
    
    foreach ($logEntry in $MIGRATION_LOG) {
        $report += "`n### $($logEntry.File)`n"
        $report += "- **Replacements**: $($logEntry.Replacements)`n"
        $report += "- **Status**: $($logEntry.Status)`n"
        $report += "- **Timestamp**: $($logEntry.Timestamp)`n"
    }
    
    $report += @"

---

## 🎯 REPLACEMENT MAPPINGS APPLIED

"@
    
    foreach ($mapping in $REPLACEMENT_MAPPINGS.GetEnumerator()) {
        $report += "- `$($mapping.Key)` → `$($mapping.Value)`n"
    }
    
    $report += @"

---

**Migration Authority**: GRUPO US VIBECODE SYSTEM V4.0  
**Batch Processor**: taskmaster-migration-batch-processor.ps1  
**Next Phase**: Manual validation and testing
"@
    
    $report | Out-File $reportPath -Encoding UTF8
    Write-MigrationMessage "Migration report generated: $reportPath" "SUCCESS"
    
    return $reportPath
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-TaskMasterMigrationBatch {
    Write-Host "🔄 TASKMASTER TO MCP SHRIMP TASK MANAGER BATCH MIGRATION" -ForegroundColor Magenta
    Write-Host "Target Directory: $TargetDirectory" -ForegroundColor Cyan
    Write-Host "Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" -ForegroundColor Yellow
    Write-Host ""
    
    $totalFilesFound = 0
    $totalFilesProcessed = 0
    
    # Process each search directory
    foreach ($directory in $SEARCH_DIRECTORIES) {
        if (Test-Path $directory) {
            Write-MigrationMessage "Scanning directory: $directory" "INFO"
            
            foreach ($extension in $FILE_EXTENSIONS) {
                $files = Get-ChildItem $directory -Filter $extension -Recurse -ErrorAction SilentlyContinue
                
                foreach ($file in $files) {
                    $totalFilesFound++
                    
                    # Skip already processed critical files
                    if ($file.Name -in @("00-master-execution-protocol.md", "00-master-orchestrator-unified.md")) {
                        Write-MigrationMessage "Skipping already processed file: $($file.Name)" "INFO"
                        continue
                    }
                    
                    if (Test-FileContainsTaskMaster $file.FullName) {
                        $PROCESSED_FILES += $file.FullName
                        
                        if (Invoke-FileTaskMasterMigration $file.FullName) {
                            $totalFilesProcessed++
                        }
                    }
                }
            }
        } else {
            Write-MigrationMessage "Directory not found: $directory" "WARNING"
        }
    }
    
    Write-Host ""
    Write-MigrationMessage "Batch migration completed!" "SUCCESS"
    Write-MigrationMessage "Files scanned: $totalFilesFound" "INFO"
    Write-MigrationMessage "Files with TaskMaster references: $($PROCESSED_FILES.Count)" "INFO"
    Write-MigrationMessage "Files successfully migrated: $totalFilesProcessed" "INFO"
    Write-MigrationMessage "Total replacements made: $(($MIGRATION_LOG | Measure-Object -Property Replacements -Sum).Sum)" "INFO"
    
    # Generate migration report
    $reportPath = New-MigrationReport
    
    return @{
        FilesScanned = $totalFilesFound
        FilesWithReferences = $PROCESSED_FILES.Count
        FilesMigrated = $totalFilesProcessed
        TotalReplacements = ($MIGRATION_LOG | Measure-Object -Property Replacements -Sum).Sum
        ReportPath = $reportPath
    }
}

# Execute batch migration
$result = Start-TaskMasterMigrationBatch

# Return results for further processing
return $result
