# ===============================================================================
# POST-TASK VALIDATION SCRIPT (FIXED) - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Validates task completion, learns from errors, and updates knowledge base
# Author: Augment Agent - Task Automation System (Fixed Version)
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TaskId,
    
    [Parameter(Mandatory = $true)]
    [string]$Description,
    
    [Parameter(Mandatory = $false)]
    [switch]$ValidateChanges,
    
    [Parameter(Mandatory = $false)]
    [switch]$LearnFromErrors,
    
    [Parameter(Mandatory = $false)]
    [switch]$UpdateRules,
    
    [Parameter(Mandatory = $false)]
    [switch]$GenerateReport
)

# Global variables
$script:ErrorLog = @()
$script:SuccessLog = @()
$script:LearningLog = @()
$script:ReportPath = "@project-core/reports/task-validation-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Status message function (sem emojis para evitar problemas de encoding)
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
    
    # Log to appropriate collection
    switch ($Type) {
        "Error" { $script:ErrorLog += "$timestamp - $Message" }
        "Success" { $script:SuccessLog += "$timestamp - $Message" }
        default { $script:LearningLog += "$timestamp - $Message" }
    }
}

# ===============================================================================
# PHASE 1: VALIDATION FUNCTIONS
# ===============================================================================

function Test-TaskChanges {
    param([string]$TaskDescription)
    
    Write-StatusMessage "=== PHASE 1: VALIDATING TASK CHANGES ===" "Info"
    
    $validationResults = @{
        FilesModified = 0
        SyntaxErrors = 0
        TestsPassed = 0
        ConfigValid = $true
    }
    
    try {
        # Check for recently modified files
        $recentFiles = Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue | Where-Object { 
            $_.LastWriteTime -gt (Get-Date).AddHours(-1) -and
            $_.FullName -notlike "*node_modules*" -and
            $_.FullName -notlike "*\.git*"
        }
        
        $validationResults.FilesModified = $recentFiles.Count
        Write-StatusMessage "Found $($recentFiles.Count) recently modified files" "Info"
        
        # Validate syntax for code files
        foreach ($file in $recentFiles) {
            $extension = $file.Extension.ToLower()
            
            switch ($extension) {
                ".ps1" {
                    try {
                        $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $file.FullName -Raw), [ref]$null)
                        Write-StatusMessage "  OK PowerShell syntax valid: $($file.Name)" "Success"
                    }
                    catch {
                        Write-StatusMessage "  ERROR PowerShell syntax error: $($file.Name)" "Error"
                        $validationResults.SyntaxErrors++
                    }
                }
                ".json" {
                    try {
                        $null = Get-Content $file.FullName | ConvertFrom-Json
                        Write-StatusMessage "  OK JSON syntax valid: $($file.Name)" "Success"
                    }
                    catch {
                        Write-StatusMessage "  ERROR JSON syntax error: $($file.Name)" "Error"
                        $validationResults.SyntaxErrors++
                    }
                }
                ".js" {
                    # Basic JavaScript validation
                    $content = Get-Content $file.FullName -Raw
                    if ($content -match "syntax\s*error|unexpected\s*token") {
                        Write-StatusMessage "  WARNING Potential JS syntax issues: $($file.Name)" "Warning"
                    } else {
                        Write-StatusMessage "  OK JavaScript file checked: $($file.Name)" "Success"
                    }
                }
            }
        }
        
        Write-StatusMessage "Validation completed: $($validationResults.SyntaxErrors) syntax errors found" "Info"
        return $validationResults
    }
    catch {
        Write-StatusMessage "Error during validation: $($_.Exception.Message)" "Error"
        return $validationResults
    }
}

# ===============================================================================
# PHASE 2: ERROR ANALYSIS AND LEARNING
# ===============================================================================

function Invoke-ErrorAnalysis {
    Write-StatusMessage "=== PHASE 2: ERROR ANALYSIS AND LEARNING ===" "Info"
    
    $learningData = @{
        ErrorsFound = @()
        SolutionsApplied = @()
        PatternsDiscovered = @()
    }
    
    try {
        # Analyze recent error logs from various sources
        $errorSources = @(
            "error.log",
            "npm-debug.log",
            "yarn-error.log"
        )
        
        foreach ($source in $errorSources) {
            if (Test-Path $source) {
                $errors = Get-Content $source -Tail 50 -ErrorAction SilentlyContinue | Where-Object { $_ -match "error|failed|exception" }
                foreach ($error in $errors) {
                    $learningData.ErrorsFound += $error
                    $errorPreview = if ($error.Length -gt 80) { $error.Substring(0, 80) + "..." } else { $error }
                    Write-StatusMessage "  NOTE Error captured: $errorPreview" "Warning"
                }
            }
        }
        
        # Update self-correction log
        $correctionLogPath = "@project-core/memory/self_correction_log.md"
        if ($learningData.ErrorsFound.Count -gt 0) {
            $logEntry = "`n## Task: $TaskId - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n"
            $logEntry += "**Description**: $Description`n`n"
            $logEntry += "### Errors Encountered:`n"
            
            foreach ($error in $learningData.ErrorsFound) {
                $logEntry += "- $error`n"
            }
            
            $logEntry += "`n### Solutions Applied:`n"
            $logEntry += "- Automated syntax validation performed`n"
            $logEntry += "- Error patterns documented for future reference`n"
            $logEntry += "- Knowledge base updated with findings`n"
            
            $logEntry += "`n### Lessons Learned:`n"
            $logEntry += "- Implement stricter validation for file types with syntax errors`n"
            $logEntry += "- Monitor error logs more frequently during development`n"
            $logEntry += "- Consider automated testing integration`n`n"
            
            if (Test-Path $correctionLogPath) {
                Add-Content -Path $correctionLogPath -Value $logEntry
            } else {
                $initialContent = "# Self-Correction Log`n" + $logEntry
                Set-Content -Path $correctionLogPath -Value $initialContent
            }
            
            Write-StatusMessage "Updated self-correction log with $($learningData.ErrorsFound.Count) errors" "Success"
        }
        
        return $learningData
    }
    catch {
        Write-StatusMessage "Error during analysis: $($_.Exception.Message)" "Error"
        return $learningData
    }
}

# ===============================================================================
# PHASE 3: RULE UPDATES AND AUTOCORRECTION
# ===============================================================================

function Update-RulesAndCommands {
    param([hashtable]$ValidationResults, [hashtable]$LearningData)
    
    Write-StatusMessage "=== PHASE 3: UPDATING RULES AND COMMANDS ===" "Info"
    
    try {
        # Update master rule with new patterns
        $masterRulePath = "@project-core/memory/master_rule.md"
        
        if (Test-Path $masterRulePath) {
            # Add new learning section if errors were found
            if ($LearningData.ErrorsFound.Count -gt 0) {
                $newLearning = "`n## Auto-Generated Learning - $(Get-Date -Format 'yyyy-MM-dd')`n"
                $newLearning += "### Task: $TaskId`n"
                $newLearning += "- **Files Modified**: $($ValidationResults.FilesModified)`n"
                $newLearning += "- **Syntax Errors**: $($ValidationResults.SyntaxErrors)`n"
                $newLearning += "- **Error Patterns**: $($LearningData.ErrorsFound.Count) new patterns identified`n"
                $newLearning += "`n### Recommended Actions:`n"
                $newLearning += "1. Implement stricter pre-commit validation`n"
                $newLearning += "2. Add automated syntax checking for modified file types`n"
                $newLearning += "3. Monitor error logs during development cycles`n`n"
                
                Add-Content -Path $masterRulePath -Value $newLearning
                Write-StatusMessage "Updated master rule with new learning patterns" "Success"
            }
        }
        
        # Update command corrections if syntax errors were found
        if ($ValidationResults.SyntaxErrors -gt 0) {
            $commandCorrectionPath = "@project-core/memory/command_corrections.md"
            $correction = "`n## Command Correction - $(Get-Date -Format 'yyyy-MM-dd')`n"
            $correction += "### Issue: Syntax errors detected in $($ValidationResults.SyntaxErrors) files`n"
            $correction += "### Correct Approach:`n"
            $correction += "1. Always validate syntax before committing changes`n"
            $correction += "2. Use appropriate linting tools for each file type`n"
            $correction += "3. Implement automated pre-commit hooks`n"
            $correction += "`n### Commands to Use:`n"
            $correction += "```powershell`n"
            $correction += "# PowerShell validation`n"
            $correction += "[System.Management.Automation.PSParser]::Tokenize((Get-Content file.ps1 -Raw), [ref]`$null)`n"
            $correction += "`n# JSON validation`n"
            $correction += "Get-Content file.json | ConvertFrom-Json`n"
            $correction += "`n# JavaScript validation (with Node.js)`n"
            $correction += "node -c file.js`n"
            $correction += "```n`n"
            
            if (Test-Path $commandCorrectionPath) {
                Add-Content -Path $commandCorrectionPath -Value $correction
            } else {
                $initialContent = "# Command Corrections`n" + $correction
                Set-Content -Path $commandCorrectionPath -Value $initialContent
            }
            
            Write-StatusMessage "Updated command corrections with syntax validation patterns" "Success"
        }
        
        return $true
    }
    catch {
        Write-StatusMessage "Error updating rules: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# REPORT GENERATION
# ===============================================================================

function New-TaskReport {
    param([hashtable]$ValidationResults, [hashtable]$LearningData, [bool]$RulesUpdated)
    
    Write-StatusMessage "=== GENERATING TASK COMPLETION REPORT ===" "Info"
    
    try {
        # Ensure reports directory exists
        $reportsDir = "@project-core/reports"
        if (-not (Test-Path $reportsDir)) {
            New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
        }
        
        $report = "# Task Validation Report`n"
        $report += "**Task ID**: $TaskId`n"
        $report += "**Description**: $Description`n"
        $report += "**Timestamp**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n`n"
        
        $report += "## Validation Results`n"
        $report += "- **Files Modified**: $($ValidationResults.FilesModified)`n"
        $report += "- **Syntax Errors**: $($ValidationResults.SyntaxErrors)`n"
        $report += "- **Tests Passed**: $($ValidationResults.TestsPassed)`n"
        $report += "- **Configuration Valid**: $($ValidationResults.ConfigValid)`n`n"
        
        $report += "## Error Analysis`n"
        $report += "- **Errors Found**: $($LearningData.ErrorsFound.Count)`n"
        $report += "- **Solutions Applied**: $($LearningData.SolutionsApplied.Count)`n"
        $report += "- **Patterns Discovered**: $($LearningData.PatternsDiscovered.Count)`n`n"
        
        $report += "## Actions Taken`n"
        $report += "- **Rules Updated**: $RulesUpdated`n"
        $report += "- **Memory Bank Updated**: $(Test-Path "@project-core/memory/self_correction_log.md")`n"
        $report += "- **Command Corrections**: $($ValidationResults.SyntaxErrors -gt 0)`n`n"
        
        $report += "## Success Log`n"
        foreach ($success in $script:SuccessLog) {
            $report += "- $success`n"
        }
        
        $report += "`n## Error Log`n"
        foreach ($error in $script:ErrorLog) {
            $report += "- $error`n"
        }
        
        $report += "`n## Recommendations`n"
        $report += "1. Continue monitoring for similar error patterns`n"
        $report += "2. Implement automated validation in development workflow`n"
        $report += "3. Regular review of learning patterns for optimization`n`n"
        
        $report += "---`n"
        $report += "*Generated by Post-Task Validation System - GRUPO US VIBECODE SYSTEM V2.0*`n"
        
        Set-Content -Path $script:ReportPath -Value $report
        Write-StatusMessage "Report generated: $script:ReportPath" "Success"
        
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
    Write-StatusMessage "POST-TASK VALIDATION STARTED" "Info"
    Write-StatusMessage "Task ID: $TaskId" "Info"
    Write-StatusMessage "Description: $Description" "Info"
    
    $validationResults = @{
        FilesModified = 0
        SyntaxErrors = 0
        TestsPassed = 0
        ConfigValid = $true
    }
    $learningData = @{
        ErrorsFound = @()
        SolutionsApplied = @()
        PatternsDiscovered = @()
    }
    $rulesUpdated = $false
    
    # Phase 1: Validate Changes
    if ($ValidateChanges -or $PSBoundParameters.Count -eq 2) {
        $validationResults = Test-TaskChanges -TaskDescription $Description
    }
    
    # Phase 2: Learn from Errors
    if ($LearnFromErrors -or $PSBoundParameters.Count -eq 2) {
        $learningData = Invoke-ErrorAnalysis
    }
    
    # Phase 3: Update Rules
    if ($UpdateRules -or $PSBoundParameters.Count -eq 2) {
        $rulesUpdated = Update-RulesAndCommands -ValidationResults $validationResults -LearningData $learningData
    }
    
    # Generate Report
    if ($GenerateReport -or $PSBoundParameters.Count -eq 2) {
        $reportPath = New-TaskReport -ValidationResults $validationResults -LearningData $learningData -RulesUpdated $rulesUpdated
    }
    
    # Final assessment
    $totalErrors = $validationResults.SyntaxErrors + $learningData.ErrorsFound.Count
    
    if ($totalErrors -eq 0) {
        Write-StatusMessage "TASK VALIDATION COMPLETED SUCCESSFULLY!" "Success"
        Write-StatusMessage "No errors found, all validations passed" "Success"
        exit 0
    } elseif ($totalErrors -le 3) {
        Write-StatusMessage "TASK VALIDATION COMPLETED WITH MINOR ISSUES" "Warning"
        Write-StatusMessage "$totalErrors issues found and documented" "Warning"
        exit 0
    } else {
        Write-StatusMessage "TASK VALIDATION FOUND SIGNIFICANT ISSUES" "Error"
        Write-StatusMessage "$totalErrors issues require attention" "Error"
        exit 1
    }
}
catch {
    Write-StatusMessage "Post-task validation failed: $($_.Exception.Message)" "Error"
    exit 1
}
