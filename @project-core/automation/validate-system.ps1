# ===============================================================================
# SYSTEM VALIDATION SCRIPT - GRUPO US VIBECODE SYSTEM V4.0
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
        "@project-core/knowledge-base/rules",
        "@project-core/knowledge-base/memory",
        "@project-core/configs",
        "@project-core/configs/project-templates",
        "@project-core/docs",
        "@project-core/docs/setup",
        "@project-core/docs/workflows",
        "@project-core/docs/architecture",
        ".taskmaster",
        ".cursor"
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
        "@project-core/configs/mcp-servers.json",
        "configs/README.md",
        ".cursor/mcp.json",
        "@project-core/tools/taskmaster-integration/config/default.json"
    )

    $results = @{}
    foreach ($file in $configFiles) {
        $exists = Test-Path $file
        $results[$file] = $exists

        if ($exists) {
            # Test JSON syntax for JSON files
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
        "@project-core/automation/validate-system.ps1",
        "@project-core/automation/retroactive-corrections.ps1",
        "configs/migrate-configurations.ps1",
        "configs/project-templates/generate-project.ps1"
    )

    $results = @{}
    foreach ($script in $scripts) {
        $exists = Test-Path $script
        $results[$script] = $exists

        if ($exists) {
            # Test PowerShell syntax
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

function Test-DocumentationFiles {
    Write-StatusMessage "Testing documentation files..." "Info"

    $docFiles = @(
        "README.md",
        "docs/README.md",
        "docs/setup/setup-guide.md",
        "docs/workflows/development-workflow.md",
        "@project-core/knowledge-base/rules/00-master-protocol.md",
        "@project-core/knowledge-base/rules/01-core-principles.md",
        "@project-core/knowledge-base/rules/02-coding-standards-universal.md"
    )

    $results = @{}
    foreach ($file in $docFiles) {
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
    Write-StatusMessage "GRUPO US VIBECODE SYSTEM V4.0" "Info"

    # Run all validation tests
    $dirResults = Test-DirectoryStructure
    $configResults = Test-ConfigurationFiles
    $scriptResults = Test-AutomationScripts
    $docResults = Test-DocumentationFiles

    # Summary
    Write-StatusMessage "=== VALIDATION SUMMARY ===" "Info"

    $totalTests = 0
    $passedTests = 0

    # Directory structure
    $dirPassed = ($dirResults.Values | Where-Object { $_ -eq $true }).Count
    $dirTotal = $dirResults.Count
    $totalTests += $dirTotal
    $passedTests += $dirPassed
    Write-StatusMessage "Directory Structure: $dirPassed/$dirTotal" "Info"

    # Configuration files
    $configPassed = ($configResults.Values | Where-Object { $_ -eq $true -or $_ -eq "valid" }).Count
    $configTotal = $configResults.Count
    $totalTests += $configTotal
    $passedTests += $configPassed
    Write-StatusMessage "Configuration Files: $configPassed/$configTotal" "Info"

    # Scripts
    $scriptPassed = ($scriptResults.Values | Where-Object { $_ -eq $true -or $_ -eq "valid" }).Count
    $scriptTotal = $scriptResults.Count
    $totalTests += $scriptTotal
    $passedTests += $scriptPassed
    Write-StatusMessage "Automation Scripts: $scriptPassed/$scriptTotal" "Info"

    # Documentation
    $docPassed = ($docResults.Values | Where-Object { $_ -eq $true -or $_ -eq "complete" }).Count
    $docTotal = $docResults.Count
    $totalTests += $docTotal
    $passedTests += $docPassed
    Write-StatusMessage "Documentation: $docPassed/$docTotal" "Info"

    # Overall score
    $successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)
    Write-StatusMessage "Overall Success Rate: $successRate% ($passedTests/$totalTests)" "Info"

    # Final assessment
    if ($successRate -ge 90) {
        Write-StatusMessage "🎉 SYSTEM VALIDATION PASSED!" "Success"
        Write-StatusMessage "Learning analysis implementation successful" "Success"
        exit 0
    }
    elseif ($successRate -ge 75) {
        Write-StatusMessage "⚠️ SYSTEM VALIDATION MOSTLY PASSED" "Warning"
        Write-StatusMessage "Some minor issues found, but system is functional" "Warning"
        exit 0
    }
    else {
        Write-StatusMessage "❌ SYSTEM VALIDATION FAILED" "Error"
        Write-StatusMessage "Significant issues found, manual review required" "Error"
        exit 1
    }
}
catch {
    Write-StatusMessage "❌ ERROR DURING VALIDATION: $_" "Error"
    Write-StatusMessage "Stack Trace: $($_.ScriptStackTrace)" "Error"
    exit 1
}
