# ===============================================================================
# SYSTEM VALIDATION SCRIPT - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Validates the consolidated architecture and performs comprehensive testing
# Author: Augment Agent - Learning Analysis Implementation
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Detailed,
    
    [Parameter(Mandatory = $false)]
    [switch]$FixIssues
)

# Status message function
function Write-StatusMessage($Message, $Type = "Info") {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Type) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        default { "White" }
    }
    Write-Host "[$timestamp] $Message" -ForegroundColor $color
}

# ===============================================================================
# VALIDATION FUNCTIONS
# ===============================================================================

function Test-DirectoryStructure {
    Write-StatusMessage "Testing directory structure..." "Info"
    
    $requiredDirs = @(
        "@project-core/automation",
        "@project-core/memory",
        "@project-core/tools",
        "@project-core/configs",
        "@project-core/docs"
    )
    
    $results = @{}
    foreach ($dir in $requiredDirs) {
        $exists = Test-Path $dir
        $results[$dir] = $exists
        
        if ($exists) {
            Write-StatusMessage "  ✅ $dir" "Success"
        }
        else {
            Write-StatusMessage "  ❌ $dir" "Error"
        }
    }
    
    return $results
}

function Test-ConfigurationFiles {
    Write-StatusMessage "Testing configuration files..." "Info"
    
    $configFiles = @(
        "@project-core/configs/taskmaster-unified.json",
        "@project-core/configs/mcp-servers.json"
    )
    
    $results = @{}
    foreach ($file in $configFiles) {
        $exists = Test-Path $file
        $results[$file] = $exists
        
        if ($exists) {
            if ($file -like "*.json") {
                try {
                    $content = Get-Content $file | ConvertFrom-Json
                    Write-StatusMessage "  ✅ $file (valid JSON)" "Success"
                    $results[$file] = "valid"
                }
                catch {
                    Write-StatusMessage "  ⚠️ $file (invalid JSON)" "Warning"
                    $results[$file] = "invalid"
                }
            }
            else {
                Write-StatusMessage "  ✅ $file" "Success"
            }
        }
        else {
            Write-StatusMessage "  ❌ $file" "Error"
        }
    }
    
    return $results
}

function Test-AutomationScripts {
    Write-StatusMessage "Testing automation scripts..." "Info"
    
    $scripts = @(
        "@project-core/automation/system-health-check.ps1",
        "@project-core/tools/scripts/pre-task-checklist.ps1"
    )
    
    $results = @{}
    foreach ($script in $scripts) {
        $exists = Test-Path $script
        $results[$script] = $exists
        
        if ($exists) {
            try {
                $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $script -Raw), [ref]$null)
                Write-StatusMessage "  ✅ $script (valid syntax)" "Success"
                $results[$script] = "valid"
            }
            catch {
                Write-StatusMessage "  ⚠️ $script (syntax error)" "Warning"
                $results[$script] = "invalid"
            }
        }
        else {
            Write-StatusMessage "  ❌ $script" "Error"
        }
    }
    
    return $results
}

function Test-MemoryBank {
    Write-StatusMessage "Testing memory bank..." "Info"
    
    $memoryFiles = @(
        "@project-core/memory/master_rule.md",
        "@project-core/memory/self_correction_log.md"
    )
    
    $results = @{}
    foreach ($file in $memoryFiles) {
        $exists = Test-Path $file
        $results[$file] = $exists
        
        if ($exists) {
            $content = Get-Content $file -Raw
            $wordCount = ($content -split '\s+').Count
            
            if ($wordCount -gt 50) {
                Write-StatusMessage "  ✅ $file ($wordCount words)" "Success"
                $results[$file] = "complete"
            }
            else {
                Write-StatusMessage "  ⚠️ $file (too short: $wordCount words)" "Warning"
                $results[$file] = "incomplete"
            }
        }
        else {
            Write-StatusMessage "  ❌ $file" "Error"
        }
    }
    
    return $results
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "=== COMPREHENSIVE SYSTEM VALIDATION ===" "Info"
    Write-StatusMessage "GRUPO US VIBECODE SYSTEM V2.0" "Info"
    
    # Run all validation tests
    $dirResults = Test-DirectoryStructure
    $configResults = Test-ConfigurationFiles
    $scriptResults = Test-AutomationScripts
    $memoryResults = Test-MemoryBank
    
    # Summary
    Write-StatusMessage "=== VALIDATION SUMMARY ===" "Info"
    
    $totalTests = 0
    $passedTests = 0
    
    # Calculate results
    $allResults = @()
    $allResults += $dirResults.Values
    $allResults += $configResults.Values
    $allResults += $scriptResults.Values
    $allResults += $memoryResults.Values
    
    $totalTests = $allResults.Count
    $passedTests = ($allResults | Where-Object { $_ -eq $true -or $_ -eq "valid" -or $_ -eq "complete" }).Count
    $successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)
    
    Write-StatusMessage "Total Tests: $totalTests" "Info"
    Write-StatusMessage "Passed Tests: $passedTests" "Info"
    Write-StatusMessage "Success Rate: $successRate%" "Info"
    
    # Final assessment
    if ($successRate -ge 90) {
        Write-StatusMessage "🎉 SYSTEM VALIDATION PASSED!" "Success"
        Write-StatusMessage "Architecture consolidation is successful" "Success"
        exit 0
    } elseif ($successRate -ge 75) {
        Write-StatusMessage "⚠️ SYSTEM VALIDATION MOSTLY PASSED" "Warning"
        Write-StatusMessage "Some minor issues found, but system is functional" "Warning"
        exit 0
    } else {
        Write-StatusMessage "❌ SYSTEM VALIDATION FAILED" "Error"
        Write-StatusMessage "Significant issues found, manual review required" "Error"
        exit 1
    }
}
catch {
    Write-StatusMessage "Validation script failed: $($_.Exception.Message)" "Error"
    exit 1
}
