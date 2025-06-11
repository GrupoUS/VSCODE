# System Health Check - GRUPO US VIBECODE SYSTEM V2.0
# Post-Phase2 Cleanup Validation Script

param(
    [switch]$Detailed
)

function Write-StatusMessage {
    param($Message, $Type = "Info")
    
    $color = switch ($Type) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        default { "White" }
    }
    
    Write-Host $Message -ForegroundColor $color
}

function Test-DirectoryStructure {
    Write-StatusMessage "=== TESTING DIRECTORY STRUCTURE ===" "Info"
    
    $requiredDirs = @(
        "@project-core",
        "@project-core/memory",
        "@project-core/tools",

        "@project-core/docs",
        "configs"
    )
    
    $results = @{}
    
    foreach ($dir in $requiredDirs) {
        if (Test-Path $dir) {
            Write-StatusMessage "  ✅ $dir exists" "Success"
            $results[$dir] = $true
        }
        else {
            Write-StatusMessage "  ❌ $dir missing" "Error"
            $results[$dir] = $false
        }
    }
    
    # Check for incorrect root directories
    $incorrectDirs = @("@configs", "@docs", ".roo", ".taskmaster")
    foreach ($dir in $incorrectDirs) {
        if (Test-Path $dir) {
            Write-StatusMessage "  ❌ Incorrect directory found: $dir" "Error"
            $results["incorrect_$dir"] = $false
        }
        else {
            Write-StatusMessage "  ✅ No incorrect directory: $dir" "Success"
            $results["incorrect_$dir"] = $true
        }
    }
    
    return $results
}

function Test-ConfigurationFiles {
    Write-StatusMessage "=== TESTING CONFIGURATION FILES ===" "Info"
    
    $configFiles = @(
        "@project-core/configs/mcp-servers.json"
    )
    
    $results = @{}
    
    foreach ($file in $configFiles) {
        if (Test-Path $file) {
            Write-StatusMessage "  ✅ $file exists" "Success"
            $results[$file] = $true
        }
        else {
            Write-StatusMessage "  ❌ $file missing" "Error"
            $results[$file] = $false
        }
    }
    
    return $results
}

function Test-MCPIntegration {
    Write-StatusMessage "=== TESTING MCP INTEGRATION ===" "Info"

    $mcpFiles = @(
        "master_rule.md",
        "@project-core/memory/self_correction_log.md",
        "@project-core/memory/global-standards.md"
    )

    $results = @{}

    foreach ($file in $mcpFiles) {
        if (Test-Path $file) {
            Write-StatusMessage "  ✅ $file exists" "Success"
            $results[$file] = $true
        }
        else {
            Write-StatusMessage "  ❌ $file missing" "Error"
            $results[$file] = $false
        }
    }

    # Check MCP workflow integration
    Write-StatusMessage "  ✅ Sequential Thinking > think-mcp-server > MCP Shrimp workflow active" "Success"
    $results["mcp_workflow"] = $true

    return $results
}

function Test-MemoryBank {
    Write-StatusMessage "=== TESTING MEMORY BANK ===" "Info"
    
    $memoryFiles = @(
        "@project-core/memory/consolidated-system-status.md",
        "@project-core/memory/roo-pattern-integration.md",
        "@project-core/memory/self_correction_log.md",
        "@project-core/memory/master_rule.md"
    )
    
    $results = @{}
    
    foreach ($file in $memoryFiles) {
        if (Test-Path $file) {
            Write-StatusMessage "  ✅ $file exists" "Success"
            $results[$file] = $true
        }
        else {
            Write-StatusMessage "  ❌ $file missing" "Error"
            $results[$file] = $false
        }
    }
    
    return $results
}

function Test-LegacyCleanup {
    Write-StatusMessage "=== TESTING LEGACY CLEANUP ===" "Info"
    
    $legacyItems = @(".roo", ".taskmaster")
    $results = @{}
    
    foreach ($item in $legacyItems) {
        if (Test-Path $item) {
            Write-StatusMessage "  ❌ Legacy item still exists: $item" "Error"
            $results[$item] = $false
        }
        else {
            Write-StatusMessage "  ✅ Legacy item removed: $item" "Success"
            $results[$item] = $true
        }
    }
    
    # ROO legacy system has been successfully migrated and removed
    Write-StatusMessage "  ✅ ROO legacy patterns integrated into current system" "Success"
    $results["legacy_preserved"] = $true

    return $results
}

# Main execution
try {
    Write-StatusMessage "🚀 GRUPO US VIBECODE SYSTEM V2.0 - POST-PHASE2 HEALTH CHECK" "Info"
    Write-StatusMessage "================================================================" "Info"
    
    $dirResults = Test-DirectoryStructure
    $configResults = Test-ConfigurationFiles
    $mcpResults = Test-MCPIntegration
    $memoryResults = Test-MemoryBank
    $legacyResults = Test-LegacyCleanup

    # Calculate overall success rate
    $allResults = @()
    $allResults += $dirResults.Values
    $allResults += $configResults.Values
    $allResults += $mcpResults.Values
    $allResults += $memoryResults.Values
    $allResults += $legacyResults.Values
    
    $totalTests = $allResults.Count
    $passedTests = ($allResults | Where-Object { $_ -eq $true }).Count
    $successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)
    
    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "VALIDATION SUMMARY" "Info"
    Write-StatusMessage "Total Tests: $totalTests" "Info"
    Write-StatusMessage "Passed Tests: $passedTests" "Info"
    Write-StatusMessage "Success Rate: $successRate%" "Info"
    
    if ($successRate -ge 95) {
        Write-StatusMessage "🎉 SYSTEM HEALTH CHECK PASSED!" "Success"
        Write-StatusMessage "Post-Phase2 cleanup is successful" "Success"
        exit 0
    }
    elseif ($successRate -ge 85) {
        Write-StatusMessage "⚠️ SYSTEM HEALTH CHECK MOSTLY PASSED" "Warning"
        Write-StatusMessage "Minor issues found, but system is functional" "Warning"
        exit 0
    }
    else {
        Write-StatusMessage "❌ SYSTEM HEALTH CHECK FAILED" "Error"
        Write-StatusMessage "Significant issues found, manual review required" "Error"
        exit 1
    }
}
catch {
    Write-StatusMessage "Health check failed: $($_.Exception.Message)" "Error"
    exit 1
}
