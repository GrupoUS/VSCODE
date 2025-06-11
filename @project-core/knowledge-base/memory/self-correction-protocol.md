# 🔄 SELF-CORRECTION PROTOCOL
## GRUPO US VIBECODE SYSTEM V2.0 - Automated Learning & Improvement System

**Purpose**: Implement an automated learning system that continuously improves based on errors and successes  
**Version**: 1.0  
**Last Updated**: 08/06/2025  
**Status**: Active

---

## 🎯 PROTOCOL OVERVIEW

The Self-Correction Protocol is an automated learning system that:
1. **Records** every command error with its correct version
2. **Updates** source documentation when incorrect commands are found
3. **Creates** reference guides for commonly used command patterns
4. **Establishes** feedback loops for continuous improvement

---

## 📝 ERROR RECORDING SYSTEM

### **Automatic Error Logging**
```powershell
# ✅ IMPLEMENTED PATTERN
function Record-CommandError {
    param(
        [string]$IncorrectCommand,
        [string]$CorrectCommand,
        [string]$Context,
        [string]$ErrorType,
        [string]$Explanation
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = @{
        Timestamp = $timestamp
        Context = $Context
        ErrorType = $ErrorType
        IncorrectCommand = $IncorrectCommand
        CorrectCommand = $CorrectCommand
        Explanation = $Explanation
    }
    
    # Append to corrections log
    $logPath = "@project-core/knowledge-base/memory/command-corrections-log.md"
    Add-CorrectionEntry -LogPath $logPath -Entry $logEntry
    
    # Update pattern library if this represents a new successful pattern
    if ($CorrectCommand -and $ErrorType -eq "Syntax Error") {
        Update-PatternLibrary -Pattern $CorrectCommand -Context $Context
    }
}
```

### **Error Classification System**
```powershell
# Error types for systematic tracking
$ErrorTypes = @{
    "SyntaxError" = "PowerShell syntax issues"
    "ParameterConflict" = "Parameter naming conflicts"
    "ConfigurationError" = "JSON/configuration file issues"
    "GitOperationError" = "Git command problems"
    "CommandNotFound" = "Unknown or unavailable commands"
    "PathHandlingError" = "File path construction issues"
    "ValidationFailure" = "Validation script failures"
    "EnvironmentError" = "Environment-specific issues"
}
```

---

## 🔧 DOCUMENTATION UPDATE SYSTEM

### **Automated Documentation Correction**
```powershell
function Update-DocumentationErrors {
    param([string]$DocumentPath, [hashtable]$Corrections)
    
    Write-StatusMessage "Scanning $DocumentPath for corrections..." "Info"
    
    $content = Get-Content $DocumentPath -Raw
    $updated = $false
    
    foreach ($correction in $Corrections.GetEnumerator()) {
        $incorrectPattern = $correction.Key
        $correctReplacement = $correction.Value
        
        if ($content -match [regex]::Escape($incorrectPattern)) {
            $content = $content -replace [regex]::Escape($incorrectPattern), $correctReplacement
            $updated = $true
            Write-StatusMessage "  ✅ Corrected: $incorrectPattern → $correctReplacement" "Success"
        }
    }
    
    if ($updated) {
        Set-Content -Path $DocumentPath -Value $content
        Write-StatusMessage "Documentation updated: $DocumentPath" "Success"
        
        # Record the update
        Record-DocumentationUpdate -Path $DocumentPath -Corrections $Corrections
    }
}
```

### **Source Code Correction System**
```powershell
function Update-ScriptErrors {
    param([string]$ScriptPath, [hashtable]$Corrections)
    
    # Backup original script
    $backupPath = "$ScriptPath.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $ScriptPath $backupPath
    
    # Apply corrections
    $content = Get-Content $ScriptPath -Raw
    $updated = $false
    
    foreach ($correction in $Corrections.GetEnumerator()) {
        if ($content -match [regex]::Escape($correction.Key)) {
            $content = $content -replace [regex]::Escape($correction.Key), $correction.Value
            $updated = $true
            Write-StatusMessage "  ✅ Script corrected: $($correction.Key)" "Success"
        }
    }
    
    if ($updated) {
        Set-Content -Path $ScriptPath -Value $content
        
        # Validate syntax after correction
        if (Test-PowerShellSyntax $ScriptPath) {
            Write-StatusMessage "Script syntax validated: $ScriptPath" "Success"
            Remove-Item $backupPath  # Remove backup if validation passes
        } else {
            # Restore backup if validation fails
            Copy-Item $backupPath $ScriptPath -Force
            Write-StatusMessage "Syntax validation failed, restored backup" "Error"
        }
    }
}
```

---

## 📚 REFERENCE GUIDE GENERATION

### **Command Pattern Library Builder**
```powershell
function Build-CommandPatternLibrary {
    $patterns = @{}
    
    # Scan all correction logs for patterns
    $correctionLogs = Get-ChildItem "@project-core/knowledge-base/memory" -Filter "*corrections*.md"
    
    foreach ($log in $correctionLogs) {
        $content = Get-Content $log.FullName -Raw
        
        # Extract correction patterns using regex
        $corrections = [regex]::Matches($content, '(?s)\*\*❌ INCORRECT COMMAND\*\*:\s*```[\w]*\s*(.*?)\s*```\s*\*\*✅ CORRECTED COMMAND\*\*:\s*```[\w]*\s*(.*?)\s*```')
        
        foreach ($match in $corrections) {
            $incorrect = $match.Groups[1].Value.Trim()
            $correct = $match.Groups[2].Value.Trim()
            $patterns[$incorrect] = $correct
        }
    }
    
    # Generate reference guide
    Generate-QuickReferenceGuide -Patterns $patterns
}

function Generate-QuickReferenceGuide {
    param([hashtable]$Patterns)
    
    $guidePath = "@project-core/knowledge-base/memory/quick-reference-guide.md"
    $content = @"
# 🚀 QUICK REFERENCE GUIDE
## Common Command Patterns & Corrections

**Auto-Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")  
**Source**: Command corrections log analysis

---

## 📋 COMMON PATTERNS

"@
    
    foreach ($pattern in $Patterns.GetEnumerator()) {
        $content += @"

### Pattern: $($pattern.Key -replace '.*?([A-Za-z-]+).*', '$1')
**❌ Avoid**:
``````powershell
$($pattern.Key)
``````

**✅ Use**:
``````powershell
$($pattern.Value)
``````

"@
    }
    
    Set-Content -Path $guidePath -Value $content
    Write-StatusMessage "Quick reference guide updated: $guidePath" "Success"
}
```

---

## 🔄 FEEDBACK LOOP IMPLEMENTATION

### **Continuous Learning Cycle**
```powershell
function Start-ContinuousLearningCycle {
    param([int]$IntervalMinutes = 60)
    
    Write-StatusMessage "Starting continuous learning cycle (interval: $IntervalMinutes minutes)" "Info"
    
    while ($true) {
        try {
            # 1. Scan for new errors
            $newErrors = Scan-ForNewErrors
            
            # 2. Process and categorize errors
            foreach ($error in $newErrors) {
                Process-LearningEvent -Error $error
            }
            
            # 3. Update documentation and scripts
            Update-KnowledgeBase
            
            # 4. Regenerate reference guides
            Build-CommandPatternLibrary
            
            # 5. Validate all corrections
            Test-AllCorrections
            
            Write-StatusMessage "Learning cycle completed successfully" "Success"
        }
        catch {
            Write-StatusMessage "Learning cycle error: $($_.Exception.Message)" "Error"
        }
        
        # Wait for next cycle
        Start-Sleep -Seconds ($IntervalMinutes * 60)
    }
}
```

### **Learning Event Processing**
```powershell
function Process-LearningEvent {
    param([object]$Error)
    
    # Classify the error
    $errorType = Classify-Error -Error $Error
    
    # Extract correction if available
    $correction = Extract-Correction -Error $Error
    
    # Record in appropriate log
    Record-CommandError -IncorrectCommand $Error.Command -CorrectCommand $correction -Context $Error.Context -ErrorType $errorType -Explanation $Error.Explanation
    
    # Update relevant documentation
    $affectedDocs = Find-AffectedDocumentation -Error $Error
    foreach ($doc in $affectedDocs) {
        Update-DocumentationErrors -DocumentPath $doc -Corrections @{$Error.Command = $correction}
    }
    
    # Update pattern library
    if ($correction) {
        Update-PatternLibrary -Pattern $correction -Context $Error.Context -ErrorType $errorType
    }
}
```

---

## 🎯 VALIDATION & QUALITY ASSURANCE

### **Correction Validation System**
```powershell
function Test-AllCorrections {
    Write-StatusMessage "Validating all recorded corrections..." "Info"
    
    $correctionLog = "@project-core/knowledge-base/memory/command-corrections-log.md"
    $content = Get-Content $correctionLog -Raw
    
    # Extract all corrections
    $corrections = [regex]::Matches($content, '(?s)\*\*✅ CORRECTED COMMAND\*\*:\s*```[\w]*\s*(.*?)\s*```')
    
    $validationResults = @{}
    foreach ($match in $corrections) {
        $command = $match.Groups[1].Value.Trim()
        
        # Validate PowerShell syntax if it's a PowerShell command
        if ($command -match '^[A-Za-z-]+' -and $command -notmatch '^git|npm|task-master') {
            try {
                $null = [System.Management.Automation.PSParser]::Tokenize($command, [ref]$null)
                $validationResults[$command] = "Valid"
            }
            catch {
                $validationResults[$command] = "Invalid: $($_.Exception.Message)"
                Write-StatusMessage "  ⚠️ Invalid correction found: $command" "Warning"
            }
        } else {
            $validationResults[$command] = "Skipped (non-PowerShell)"
        }
    }
    
    # Report validation results
    $validCount = ($validationResults.Values | Where-Object { $_ -eq "Valid" }).Count
    $totalCount = $validationResults.Count
    Write-StatusMessage "Correction validation: $validCount/$totalCount valid" "Info"
    
    return $validationResults
}
```

### **Knowledge Base Integrity Check**
```powershell
function Test-KnowledgeBaseIntegrity {
    Write-StatusMessage "Checking knowledge base integrity..." "Info"
    
    $knowledgeBasePath = "@project-core/knowledge-base"
    $issues = @()
    
    # Check for broken links
    $markdownFiles = Get-ChildItem $knowledgeBasePath -Recurse -Filter "*.md"
    foreach ($file in $markdownFiles) {
        $content = Get-Content $file.FullName -Raw
        $links = [regex]::Matches($content, '\[.*?\]\((.*?)\)')
        
        foreach ($link in $links) {
            $linkPath = $link.Groups[1].Value
            if ($linkPath -notmatch '^https?://' -and -not (Test-Path (Join-Path $file.Directory $linkPath))) {
                $issues += "Broken link in $($file.Name): $linkPath"
            }
        }
    }
    
    # Check for duplicate entries
    $correctionLog = Join-Path $knowledgeBasePath "memory/command-corrections-log.md"
    if (Test-Path $correctionLog) {
        $content = Get-Content $correctionLog -Raw
        $entries = [regex]::Matches($content, '### \*\*Entry #(\d+):')
        $entryNumbers = $entries | ForEach-Object { [int]$_.Groups[1].Value }
        $duplicates = $entryNumbers | Group-Object | Where-Object { $_.Count -gt 1 }
        
        foreach ($duplicate in $duplicates) {
            $issues += "Duplicate entry number: $($duplicate.Name)"
        }
    }
    
    if ($issues.Count -eq 0) {
        Write-StatusMessage "Knowledge base integrity check passed" "Success"
    } else {
        Write-StatusMessage "Knowledge base issues found:" "Warning"
        foreach ($issue in $issues) {
            Write-StatusMessage "  - $issue" "Warning"
        }
    }
    
    return $issues
}
```

---

## 📊 METRICS & REPORTING

### **Learning Progress Tracking**
```powershell
function Get-LearningMetrics {
    $metrics = @{
        TotalCorrections = 0
        CorrectionsByType = @{}
        DocumentationUpdates = 0
        PatternLibraryEntries = 0
        ValidationSuccessRate = 0
        LastUpdateDate = $null
    }
    
    # Count corrections
    $correctionLog = "@project-core/knowledge-base/memory/command-corrections-log.md"
    if (Test-Path $correctionLog) {
        $content = Get-Content $correctionLog -Raw
        $corrections = [regex]::Matches($content, '### \*\*Entry #\d+:')
        $metrics.TotalCorrections = $corrections.Count
        
        # Count by type
        $types = [regex]::Matches($content, '\*\*Error Type\*\*: ([^\n]+)')
        foreach ($type in $types) {
            $typeName = $type.Groups[1].Value.Trim()
            if ($metrics.CorrectionsByType.ContainsKey($typeName)) {
                $metrics.CorrectionsByType[$typeName]++
            } else {
                $metrics.CorrectionsByType[$typeName] = 1
            }
        }
    }
    
    # Count pattern library entries
    $patternLibrary = "@project-core/knowledge-base/memory/successful-patterns-library.md"
    if (Test-Path $patternLibrary) {
        $content = Get-Content $patternLibrary -Raw
        $patterns = [regex]::Matches($content, '### \*\*Pattern #\d+:')
        $metrics.PatternLibraryEntries = $patterns.Count
    }
    
    # Validation success rate
    $validationResults = Test-AllCorrections
    $validCount = ($validationResults.Values | Where-Object { $_ -eq "Valid" }).Count
    $totalCount = $validationResults.Count
    if ($totalCount -gt 0) {
        $metrics.ValidationSuccessRate = [math]::Round(($validCount / $totalCount) * 100, 1)
    }
    
    $metrics.LastUpdateDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    return $metrics
}

function Generate-LearningReport {
    $metrics = Get-LearningMetrics
    
    $reportPath = "@project-core/knowledge-base/memory/learning-progress-report.md"
    $content = @"
# 📊 LEARNING PROGRESS REPORT
## Self-Correction Protocol Metrics

**Generated**: $($metrics.LastUpdateDate)  
**Protocol Version**: 1.0

---

## 📈 OVERALL METRICS

- **Total Corrections Recorded**: $($metrics.TotalCorrections)
- **Pattern Library Entries**: $($metrics.PatternLibraryEntries)
- **Validation Success Rate**: $($metrics.ValidationSuccessRate)%

## 📋 CORRECTIONS BY TYPE

"@
    
    foreach ($type in $metrics.CorrectionsByType.GetEnumerator()) {
        $content += "- **$($type.Key)**: $($type.Value) corrections`n"
    }
    
    $content += @"

## 🎯 QUALITY INDICATORS

- **Knowledge Base Integrity**: $(if ((Test-KnowledgeBaseIntegrity).Count -eq 0) { "✅ Passed" } else { "⚠️ Issues Found" })
- **Correction Validation**: $($metrics.ValidationSuccessRate)% success rate
- **Documentation Coverage**: Comprehensive

## 🔄 NEXT ACTIONS

- Continue monitoring for new error patterns
- Update pattern library with successful approaches
- Validate and correct any identified issues
- Expand automated learning capabilities

---

*This report is automatically generated by the Self-Correction Protocol*
"@
    
    Set-Content -Path $reportPath -Value $content
    Write-StatusMessage "Learning progress report generated: $reportPath" "Success"
}
```

---

## 🚀 PROTOCOL ACTIVATION

### **Initialization Script**
```powershell
# Initialize the Self-Correction Protocol
function Initialize-SelfCorrectionProtocol {
    Write-StatusMessage "Initializing Self-Correction Protocol..." "Info"
    
    # Ensure all required directories exist
    $requiredPaths = @(
        "@project-core/knowledge-base/memory",
        "@project-core/knowledge-base/memory/backups"
    )
    
    foreach ($path in $requiredPaths) {
        if (-not (Test-Path $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-StatusMessage "Created directory: $path" "Success"
        }
    }
    
    # Initialize log files if they don't exist
    $logFiles = @(
        "@project-core/knowledge-base/memory/command-corrections-log.md",
        "@project-core/knowledge-base/memory/successful-patterns-library.md",
        "@project-core/knowledge-base/memory/architecture-consolidation-lessons.md"
    )
    
    foreach ($logFile in $logFiles) {
        if (-not (Test-Path $logFile)) {
            Write-StatusMessage "Log file missing: $logFile" "Warning"
        } else {
            Write-StatusMessage "Log file verified: $logFile" "Success"
        }
    }
    
    # Generate initial learning report
    Generate-LearningReport
    
    # Validate knowledge base integrity
    $issues = Test-KnowledgeBaseIntegrity
    if ($issues.Count -eq 0) {
        Write-StatusMessage "Self-Correction Protocol initialized successfully" "Success"
    } else {
        Write-StatusMessage "Protocol initialized with $($issues.Count) issues to address" "Warning"
    }
}
```

---

**The Self-Correction Protocol ensures continuous improvement and learning from every interaction, creating a self-improving system that becomes more effective over time.**

*Protocol Status: ✅ ACTIVE*  
*Next Review: 08/07/2025*
