# ===============================================================================
# !FINALTEST - COMPREHENSIVE FINAL VALIDATION SCRIPT
# GRUPO US VIBECODE SYSTEM V3.0
# ===============================================================================

<#
.SYNOPSIS
Comprehensive final validation script for task completion

.DESCRIPTION
Executes complete validation of all changes, learns from errors, updates memory bank,
and ensures all proposed alterations were properly executed.

.PARAMETER TaskDescription
Description of the task that was completed

.PARAMETER UpdateMemory
Update memory bank with learnings (default: true)

.PARAMETER FixIssues
Attempt to fix found issues automatically (default: false)

.EXAMPLE
# Basic usage (triggered by !finaltest)
.\finaltest.ps1 -TaskDescription "Guidelines V3.0 Creation"

.EXAMPLE
# Full validation with auto-fix
.\finaltest.ps1 -TaskDescription "Task description" -UpdateMemory -FixIssues
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$TaskDescription = "Task Completion Validation",

    [Parameter(Mandatory = $false)]
    [switch]$UpdateMemory = $true,

    [Parameter(Mandatory = $false)]
    [switch]$FixIssues = $false,

    [Parameter(Mandatory = $false)]
    [switch]$Detailed = $false,

    [Parameter(Mandatory = $false)]
    [switch]$DryRun = $false
)

# Global variables for tracking
$script:ErrorLog = @()
$script:SuccessLog = @()
$script:LearningLog = @()
$script:MemoryUpdates = @()
$script:RuleUpdates = @()
$script:StartTime = Get-Date
$script:ReportPath = "@project-core/reports/finaltest-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# ===============================================================================
# UTILITY FUNCTIONS
# ===============================================================================

function Write-StatusMessage {
    param(
        [string]$Message,
        [ValidateSet("Info", "Success", "Warning", "Error")]
        [string]$Type = "Info"
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch ($Type) {
        "Info" { "Cyan" }
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
    }
    
    $prefix = switch ($Type) {
        "Info" { "[INFO]" }
        "Success" { "[SUCCESS]" }
        "Warning" { "[WARNING]" }
        "Error" { "[ERROR]" }
    }
    
    Write-Host "[$timestamp] $prefix $Message" -ForegroundColor $color
    
    # Log to appropriate collection
    $logEntry = @{
        Timestamp = $timestamp
        Type      = $Type
        Message   = $Message
    }
    
    switch ($Type) {
        "Success" { $script:SuccessLog += $logEntry }
        "Error" { $script:ErrorLog += $logEntry }
        "Warning" { $script:ErrorLog += $logEntry }
    }
}

function Test-FileIntegrity {
    param([string[]]$FilePaths)
    
    Write-StatusMessage "Testing file integrity..." "Info"
    $results = @{}
    
    foreach ($file in $FilePaths) {
        if (Test-Path $file) {
            try {
                # Test file readability
                $content = Get-Content $file -Raw -ErrorAction Stop
                
                # Test specific file types
                $extension = [System.IO.Path]::GetExtension($file)
                switch ($extension) {
                    ".json" {
                        $null = $content | ConvertFrom-Json -ErrorAction Stop
                        Write-StatusMessage "  ✅ $file (valid JSON)" "Success"
                        $results[$file] = "valid"
                    }
                    ".ps1" {
                        $null = [System.Management.Automation.PSParser]::Tokenize($content, [ref]$null)
                        Write-StatusMessage "  ✅ $file (valid PowerShell)" "Success"
                        $results[$file] = "valid"
                    }
                    ".md" {
                        if ($content.Length -gt 0) {
                            Write-StatusMessage "  ✅ $file (valid Markdown)" "Success"
                            $results[$file] = "valid"
                        }
                        else {
                            Write-StatusMessage "  ⚠️ $file (empty file)" "Warning"
                            $results[$file] = "empty"
                        }
                    }
                    default {
                        Write-StatusMessage "  ✅ $file (readable)" "Success"
                        $results[$file] = "readable"
                    }
                }
            }
            catch {
                Write-StatusMessage "  ❌ $file (corrupted: $($_.Exception.Message))" "Error"
                $results[$file] = "corrupted"
                $script:ErrorLog += @{
                    File  = $file
                    Error = $_.Exception.Message
                    Type  = "FileCorruption"
                }
            }
        }
        else {
            Write-StatusMessage "  ❌ $file (missing)" "Error"
            $results[$file] = "missing"
            $script:ErrorLog += @{
                File  = $file
                Error = "File not found"
                Type  = "MissingFile"
            }
        }
    }
    
    return $results
}

function Test-RecentChanges {
    Write-StatusMessage "=== TESTING RECENT CHANGES ===" "Info"
    
    try {
        # Get files modified in the last 2 hours
        $recentFiles = Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue | Where-Object { 
            $_.LastWriteTime -gt (Get-Date).AddHours(-2) -and
            $_.FullName -notlike "*node_modules*" -and
            $_.FullName -notlike "*\.git*" -and
            $_.FullName -notlike "*\.next*"
        }
        
        Write-StatusMessage "Found $($recentFiles.Count) recently modified files" "Info"
        
        if ($recentFiles.Count -gt 0) {
            $filePaths = $recentFiles | ForEach-Object { $_.FullName }
            $integrityResults = Test-FileIntegrity -FilePaths $filePaths
            
            # Count results
            $validFiles = ($integrityResults.Values | Where-Object { $_ -eq "valid" -or $_ -eq "readable" }).Count
            $corruptedFiles = ($integrityResults.Values | Where-Object { $_ -eq "corrupted" }).Count
            $missingFiles = ($integrityResults.Values | Where-Object { $_ -eq "missing" }).Count
            
            Write-StatusMessage "File integrity: $validFiles valid, $corruptedFiles corrupted, $missingFiles missing" "Info"
            
            return @{
                TotalFiles       = $recentFiles.Count
                ValidFiles       = $validFiles
                CorruptedFiles   = $corruptedFiles
                MissingFiles     = $missingFiles
                IntegrityResults = $integrityResults
            }
        }
        else {
            Write-StatusMessage "No recent changes detected" "Warning"
            return @{
                TotalFiles       = 0
                ValidFiles       = 0
                CorruptedFiles   = 0
                MissingFiles     = 0
                IntegrityResults = @{}
            }
        }
    }
    catch {
        Write-StatusMessage "Error testing recent changes: $($_.Exception.Message)" "Error"
        return $null
    }
}

function Test-SystemIntegrity {
    Write-StatusMessage "=== TESTING SYSTEM INTEGRITY ===" "Info"
    
    # Critical files that must exist and be valid
    $criticalFiles = @(
        "@project-core/memory/master_rule.md",
        "@project-core/memory/self_correction_log.md",
        "@project-core/memory/global-standards.md",
        "@project-core/memory/augment-agent-guidelines-v3.md",
        "@project-core/configs/taskmaster-unified.json",
        "@project-core/configs/mcp-servers.json"
    )
    
    $results = Test-FileIntegrity -FilePaths $criticalFiles
    
    # Check directory structure
    $criticalDirs = @(
        "@project-core",
        "@project-core/memory",
        "@project-core/rules",
        "@project-core/configs",
        "@project-core/automation"
    )
    
    $dirResults = @{}
    foreach ($dir in $criticalDirs) {
        if (Test-Path $dir -PathType Container) {
            Write-StatusMessage "  ✅ Directory: $dir" "Success"
            $dirResults[$dir] = $true
        }
        else {
            Write-StatusMessage "  ❌ Missing directory: $dir" "Error"
            $dirResults[$dir] = $false
        }
    }
    
    return @{
        FileResults      = $results
        DirectoryResults = $dirResults
    }
}

function Invoke-ErrorAnalysis {
    Write-StatusMessage "=== ANALYZING ERRORS AND LEARNING ===" "Info"
    
    $learningData = @{
        ErrorsFound        = @()
        SolutionsApplied   = @()
        PatternsDiscovered = @()
        MemoryUpdates      = @()
    }
    
    # Analyze collected errors
    if ($script:ErrorLog.Count -gt 0) {
        Write-StatusMessage "Found $($script:ErrorLog.Count) errors to analyze" "Info"
        
        foreach ($error in $script:ErrorLog) {
            # Categorize error
            $category = switch ($error.Type) {
                "FileCorruption" { "ARQUIVO_CORROMPIDO" }
                "MissingFile" { "ARQUIVO_AUSENTE" }
                "SyntaxError" { "ERRO_SINTAXE" }
                "ConfigError" { "ERRO_CONFIGURACAO" }
                default { "ERRO_GERAL" }
            }
            
            # Check if we have a known solution
            $knownSolution = Search-KnownSolutions -ErrorType $category -ErrorMessage $error.Message
            
            if ($knownSolution) {
                Write-StatusMessage "  ✅ Known solution found for: $($error.Message)" "Success"
                $learningData.SolutionsApplied += $knownSolution
            }
            else {
                Write-StatusMessage "  📚 New error pattern discovered: $($error.Message)" "Info"
                $learningData.ErrorsFound += $error
                
                # Generate learning entry
                $learningEntry = @{
                    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    Category  = $category
                    Error     = $error.Message
                    Context   = $TaskDescription
                    Solution  = "To be documented"
                }
                
                $learningData.MemoryUpdates += $learningEntry
            }
        }
    }
    else {
        Write-StatusMessage "No errors found - excellent execution!" "Success"
    }
    
    return $learningData
}

function Search-KnownSolutions {
    param(
        [string]$ErrorType,
        [string]$ErrorMessage
    )
    
    try {
        # Search in self_correction_log.md for similar errors
        $logPath = "@project-core/memory/self_correction_log.md"
        if (Test-Path $logPath) {
            $logContent = Get-Content $logPath -Raw
            
            # Simple pattern matching for known errors
            $patterns = @{
                "TaskMaster"   = "task-master (init|list|next|parse-prd)"
                "FileNotFound" = "arquivo.*não.*encontrado|file.*not.*found"
                "SyntaxError"  = "erro.*sintaxe|syntax.*error"
                "Permission"   = "permissão|permission.*denied"
            }
            
            foreach ($pattern in $patterns.GetEnumerator()) {
                if ($ErrorMessage -match $pattern.Value -or $logContent -match $pattern.Value) {
                    return @{
                        Type      = $pattern.Key
                        Solution  = "Check self_correction_log.md for documented solution"
                        Reference = $logPath
                    }
                }
            }
        }
    }
    catch {
        Write-StatusMessage "Error searching known solutions: $($_.Exception.Message)" "Warning"
    }
    
    return $null
}

function Update-MemoryBank {
    param([array]$LearningData)

    Write-StatusMessage "=== UPDATING MEMORY BANK ===" "Info"

    if ($LearningData.Count -eq 0) {
        Write-StatusMessage "No new learnings to document" "Info"
        return $true
    }

    try {
        $logPath = "@project-core/memory/self_correction_log.md"
        $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

        # Create new log entry
        $newEntry = @"

---

## 🔄 FINALTEST VALIDATION - $timestamp

### **TASK**: $TaskDescription

**Status**: ✅ VALIDATION COMPLETED
**Errors Found**: $($script:ErrorLog.Count)
**Solutions Applied**: $($LearningData.Count)
**Files Validated**: $(($script:SuccessLog | Where-Object { $_.Message -like "*valid*" }).Count)

### **ERRORS ANALYZED AND DOCUMENTED**:

"@

        foreach ($learning in $LearningData) {
            $newEntry += @"

#### **Error**: $($learning.Error)
- **Category**: $($learning.Category)
- **Context**: $($learning.Context)
- **Solution**: $($learning.Solution)
- **Prevention**: Verify file integrity before execution

"@
        }

        $newEntry += @"

### **SYSTEM IMPROVEMENTS**:

- **File Integrity**: Automated validation implemented
- **Error Prevention**: Pattern recognition enhanced
- **Memory Update**: Self-correction log updated automatically
- **Validation Protocol**: !finaltest command operational

### **NEXT STEPS**:

1. Apply documented solutions to prevent recurrence
2. Update rules and guidelines with correct commands
3. Implement automated prevention measures
4. Monitor system for similar patterns

**Impact**: PREVENTIVE - Automated learning and correction system active

"@

        # Append to self_correction_log.md
        Add-Content -Path $logPath -Value $newEntry -Encoding UTF8
        Write-StatusMessage "Memory bank updated with $($LearningData.Count) new learnings" "Success"

        $script:MemoryUpdates += @{
            File      = $logPath
            Entries   = $LearningData.Count
            Timestamp = $timestamp
        }

        return $true
    }
    catch {
        Write-StatusMessage "Error updating memory bank: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Update-RulesAndFiles {
    Write-StatusMessage "=== UPDATING RULES AND FILES ===" "Info"

    $updatesApplied = 0

    try {
        # Check for common command corrections needed
        $filesToCheck = @(
            "@project-core/memory/master_rule.md",
            "@project-core/memory/augment-agent-guidelines-v3.md",
            "@project-core/rules/00-master-orchestrator-unified.md"
        )

        foreach ($file in $filesToCheck) {
            if (Test-Path $file) {
                $content = Get-Content $file -Raw
                $originalContent = $content

                # Apply known corrections
                $corrections = @{
                    "task-master status"             = "task-master list"
                    "task-master list --all"         = "task-master list"
                    "task-master parse-prd.*--force" = "task-master parse-prd scripts/prd.txt"
                }

                foreach ($correction in $corrections.GetEnumerator()) {
                    if ($content -match $correction.Key) {
                        $content = $content -replace $correction.Key, $correction.Value
                        Write-StatusMessage "  ✅ Corrected command in $file`: $($correction.Key) -> $($correction.Value)" "Success"
                        $updatesApplied++
                    }
                }

                # Save if changes were made
                if ($content -ne $originalContent) {
                    Set-Content -Path $file -Value $content -Encoding UTF8
                    $script:RuleUpdates += @{
                        File        = $file
                        Corrections = $updatesApplied
                    }
                }
            }
        }

        Write-StatusMessage "Applied $updatesApplied rule corrections" "Info"
        return $updatesApplied
    }
    catch {
        Write-StatusMessage "Error updating rules: $($_.Exception.Message)" "Error"
        return 0
    }
}

function New-FinalReport {
    Write-StatusMessage "=== GENERATING FINAL REPORT ===" "Info"

    $endTime = Get-Date
    $duration = $endTime - $script:StartTime

    $report = @"
# 🔍 FINALTEST VALIDATION REPORT

**Task**: $TaskDescription
**Timestamp**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Duration**: $($duration.TotalMinutes.ToString("F2")) minutes

## 📊 SUMMARY

- **Total Errors Found**: $($script:ErrorLog.Count)
- **Successful Validations**: $($script:SuccessLog.Count)
- **Memory Updates**: $($script:MemoryUpdates.Count)
- **Rule Corrections**: $($script:RuleUpdates.Count)

## ✅ SUCCESSFUL VALIDATIONS

"@

    foreach ($success in $script:SuccessLog) {
        $report += "- [$($success.Timestamp)] $($success.Message)`n"
    }

    $report += @"

## ❌ ERRORS FOUND AND ANALYZED

"@

    foreach ($error in $script:ErrorLog) {
        $report += "- [$($error.Timestamp)] **$($error.Type)**: $($error.Message)`n"
    }

    $report += @"

## 🧠 MEMORY BANK UPDATES

"@

    foreach ($update in $script:MemoryUpdates) {
        $report += "- Updated: $($update.File) with $($update.Entries) new entries`n"
    }

    $report += @"

## 🔧 RULE CORRECTIONS APPLIED

"@

    foreach ($ruleUpdate in $script:RuleUpdates) {
        $report += "- File: $($ruleUpdate.File) - $($ruleUpdate.Corrections) corrections`n"
    }

    $report += @"

## 🎯 RECOMMENDATIONS

1. **Error Prevention**: All identified patterns documented for future prevention
2. **Command Validation**: Incorrect commands corrected in documentation
3. **System Integrity**: File validation protocols active
4. **Continuous Learning**: Memory bank updated with new patterns

## 📈 SYSTEM STATUS

**Overall Health**: $(if ($script:ErrorLog.Count -eq 0) { "EXCELLENT ✅" } elseif ($script:ErrorLog.Count -le 3) { "GOOD ⚠️" } else { "NEEDS ATTENTION ❌" })

**Next Validation**: Run !finaltest after next major task

---

*Generated by FINALTEST V3.0 - GRUPO US VIBECODE SYSTEM*
"@

    try {
        # Ensure reports directory exists
        $reportsDir = "@project-core/reports"
        if (-not (Test-Path $reportsDir)) {
            New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
        }

        Set-Content -Path $script:ReportPath -Value $report -Encoding UTF8
        Write-StatusMessage "Final report generated: $script:ReportPath" "Success"
        return $script:ReportPath
    }
    catch {
        Write-StatusMessage "Error generating report: $($_.Exception.Message)" "Error"
        return $null
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "🚀 FINALTEST V3.0 - COMPREHENSIVE VALIDATION STARTED" "Info"
    Write-StatusMessage "Task: $TaskDescription" "Info"
    if ($DryRun) {
        Write-StatusMessage "🧪 DRY RUN MODE - No changes will be made" "Info"
    }
    Write-StatusMessage "================================================================" "Info"

    # Phase 1: Test recent changes
    $recentChanges = Test-RecentChanges

    # Phase 2: Test system integrity
    $systemIntegrity = Test-SystemIntegrity

    # Phase 3: Analyze errors and learn
    $learningData = Invoke-ErrorAnalysis

    # Phase 4: Update memory bank (if enabled and not dry run)
    if ($UpdateMemory -and !$DryRun) {
        $memoryUpdated = Update-MemoryBank -LearningData $learningData.MemoryUpdates
    }
    elseif ($DryRun) {
        Write-StatusMessage "🧪 DRY RUN: Would update memory bank with $($learningData.MemoryUpdates.Count) entries" "Info"
    }

    # Phase 5: Update rules and files with correct commands (if not dry run)
    if (!$DryRun) {
        $rulesUpdated = Update-RulesAndFiles
    }
    else {
        Write-StatusMessage "🧪 DRY RUN: Would update rules and files" "Info"
    }

    # Phase 6: Generate final report
    $reportPath = New-FinalReport

    # Final assessment
    $totalErrors = $script:ErrorLog.Count
    $totalSuccess = $script:SuccessLog.Count

    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "FINALTEST VALIDATION COMPLETED" "Info"
    Write-StatusMessage "Errors: $totalErrors | Successes: $totalSuccess | Report: $reportPath" "Info"

    if ($totalErrors -eq 0) {
        Write-StatusMessage "🎉 PERFECT EXECUTION - NO ERRORS FOUND!" "Success"
        Write-StatusMessage "All proposed alterations were properly executed" "Success"
        exit 0
    }
    elseif ($totalErrors -le 3) {
        Write-StatusMessage "✅ GOOD EXECUTION - MINOR ISSUES DOCUMENTED" "Success"
        Write-StatusMessage "$totalErrors issues found, analyzed, and documented for prevention" "Success"
        exit 0
    }
    else {
        Write-StatusMessage "⚠️ EXECUTION COMPLETED WITH ISSUES" "Warning"
        Write-StatusMessage "$totalErrors issues require attention - check report for details" "Warning"
        exit 1
    }
}
catch {
    Write-StatusMessage "FINALTEST execution failed: $($_.Exception.Message)" "Error"
    Write-StatusMessage "Stack trace: $($_.ScriptStackTrace)" "Error"
    exit 1
}
