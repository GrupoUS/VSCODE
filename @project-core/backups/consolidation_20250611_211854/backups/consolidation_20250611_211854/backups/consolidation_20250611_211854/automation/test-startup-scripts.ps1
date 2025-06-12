# ===============================================================================
# TEST STARTUP SCRIPTS - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Testa a sintaxe correta dos comandos para startup scripts do terminal
# Author: Augment Agent - Testing System
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$TestAll,
    
    [Parameter(Mandatory = $false)]
    [switch]$GenerateCommands
)

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
}

# ===============================================================================
# TEST FUNCTIONS
# ===============================================================================

function Test-ScriptSyntax {
    param([string]$ScriptPath, [string]$ScriptName)
    
    Write-StatusMessage "Testing syntax: $ScriptName" "Info"
    
    if (-not (Test-Path $ScriptPath)) {
        Write-StatusMessage "  MISSING: $ScriptPath" "Error"
        return $false
    }
    
    try {
        # Test PowerShell syntax
        $null = [System.Management.Automation.PSParser]::Tokenize((Get-Content $ScriptPath -Raw), [ref]$null)
        Write-StatusMessage "  OK: $ScriptName syntax valid" "Success"
        return $true
    }
    catch {
        Write-StatusMessage "  ERROR: $ScriptName syntax invalid - $($_.Exception.Message)" "Error"
        return $false
    }
}

function Test-CommandFormats {
    Write-StatusMessage "=== TESTING COMMAND FORMATS ===" "Info"
    
    $testCommands = @(
        # Format 1: Relative path with forward slashes
        "@project-core/automation/taskmaster-init.ps1",
        
        # Format 2: Relative path with backslashes
        "@project-core\automation\taskmaster-init.ps1",
        
        # Format 3: PowerShell execution with relative path
        "powershell -ExecutionPolicy Bypass -File @project-core/automation/taskmaster-init.ps1",
        
        # Format 4: PowerShell execution with backslashes
        "powershell -ExecutionPolicy Bypass -File @project-core\automation\taskmaster-init.ps1",
        
        # Format 5: Direct execution (if in PATH)
        ".\@project-core\automation\taskmaster-init.ps1"
    )
    
    Write-StatusMessage "Command format options:" "Info"
    for ($i = 0; $i -lt $testCommands.Count; $i++) {
        Write-StatusMessage "  Format $($i + 1): $($testCommands[$i])" "Info"
    }
    
    return $testCommands
}

function Get-RecommendedStartupCommands {
    Write-StatusMessage "=== GENERATING RECOMMENDED STARTUP COMMANDS ===" "Info"
    
    $scripts = @(
        @{
            Name = "TaskMaster Init"
            Path = "@project-core/automation/taskmaster-init.ps1"
            Parameters = "-SkipPRD"
            Description = "Initialize TaskMaster for project management"
            Priority = 1
        },
        @{
            Name = "System Health Check"
            Path = "@project-core/automation/system-health-check.ps1"
            Parameters = ""
            Description = "Verify system integrity and configuration"
            Priority = 2
        },
        @{
            Name = "Cache Cleanup"
            Path = "@project-core/automation/cache-cleanup.ps1"
            Parameters = "-DryRun"
            Description = "Clean development caches (dry run mode)"
            Priority = 3
        },
        @{
            Name = "Dependency Check"
            Path = "@project-core/automation/dependency-check.ps1"
            Parameters = ""
            Description = "Check for security vulnerabilities and updates"
            Priority = 4
        }
    )
    
    $commands = @()
    
    foreach ($script in $scripts) {
        # Test if script exists
        if (Test-Path $script.Path) {
            $command = if ($script.Parameters) {
                "powershell -ExecutionPolicy Bypass -File `"$($script.Path)`" $($script.Parameters)"
            } else {
                "powershell -ExecutionPolicy Bypass -File `"$($script.Path)`""
            }
            
            $commands += @{
                Command = $command
                Description = $script.Description
                Priority = $script.Priority
                Status = "Available"
            }
            
            Write-StatusMessage "  AVAILABLE: $($script.Name)" "Success"
        } else {
            Write-StatusMessage "  MISSING: $($script.Name) at $($script.Path)" "Warning"
            
            $commands += @{
                Command = "# MISSING: $($script.Path)"
                Description = "$($script.Description) - SCRIPT NOT FOUND"
                Priority = $script.Priority
                Status = "Missing"
            }
        }
    }
    
    return $commands
}

function New-StartupScriptConfiguration {
    param([array]$Commands)
    
    Write-StatusMessage "=== GENERATING STARTUP SCRIPT CONFIGURATION ===" "Info"
    
    try {
        $configPath = "@project-core/configs/startup-scripts-config.txt"
        
        # Ensure configs directory exists
        $configsDir = "@project-core/configs"
        if (-not (Test-Path $configsDir)) {
            New-Item -ItemType Directory -Path $configsDir -Force | Out-Null
        }
        
        $config = @"
# ===============================================================================
# STARTUP SCRIPTS CONFIGURATION - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Commands to be added to VS Code Terminal Startup Script setting
# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
# ===============================================================================

# RECOMMENDED COMMANDS FOR VS CODE TERMINAL STARTUP:
# Copy and paste these commands into VS Code Settings:
# File > Preferences > Settings > Search "terminal startup"
# Terminal > Integrated > Profiles > Windows > PowerShell > Startup Script

# ===============================================================================
# PRIORITY 1 - ESSENTIAL STARTUP COMMANDS
# ===============================================================================

$(($Commands | Where-Object { $_.Priority -eq 1 -and $_.Status -eq "Available" } | ForEach-Object { $_.Command }) -join "`n")

# ===============================================================================
# PRIORITY 2 - SYSTEM VERIFICATION
# ===============================================================================

$(($Commands | Where-Object { $_.Priority -eq 2 -and $_.Status -eq "Available" } | ForEach-Object { $_.Command }) -join "`n")

# ===============================================================================
# PRIORITY 3 - MAINTENANCE (OPTIONAL)
# ===============================================================================

$(($Commands | Where-Object { $_.Priority -eq 3 -and $_.Status -eq "Available" } | ForEach-Object { $_.Command }) -join "`n")

# ===============================================================================
# PRIORITY 4 - SECURITY CHECKS (OPTIONAL)
# ===============================================================================

$(($Commands | Where-Object { $_.Priority -eq 4 -and $_.Status -eq "Available" } | ForEach-Object { $_.Command }) -join "`n")

# ===============================================================================
# MISSING SCRIPTS (CREATE THESE FIRST)
# ===============================================================================

$(($Commands | Where-Object { $_.Status -eq "Missing" } | ForEach-Object { $_.Command }) -join "`n")

# ===============================================================================
# USAGE INSTRUCTIONS
# ===============================================================================

# 1. Copy the PRIORITY 1 commands above
# 2. Open VS Code Settings (Ctrl+,)
# 3. Search for "terminal startup"
# 4. Find "Terminal > Integrated > Profiles > Windows > PowerShell"
# 5. Add to "Startup Script" field
# 6. Restart VS Code terminal to test

# ALTERNATIVE: Add to PowerShell Profile
# Add these commands to your PowerShell profile:
# notepad $PROFILE

# TESTING: Run individual commands to test before adding to startup
"@
        
        Set-Content -Path $configPath -Value $config -Encoding UTF8
        Write-StatusMessage "Configuration saved: $configPath" "Success"
        
        return $configPath
    }
    catch {
        Write-StatusMessage "Error generating configuration: $($_.Exception.Message)" "Error"
        return $null
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "STARTUP SCRIPTS TEST - GRUPO US VIBECODE SYSTEM V2.0" "Info"
    Write-StatusMessage "================================================================" "Info"
    
    # Test script syntax
    $scriptsToTest = @(
        @{ Path = "@project-core/automation/taskmaster-init.ps1"; Name = "TaskMaster Init" },
        @{ Path = "@project-core/automation/cache-cleanup.ps1"; Name = "Cache Cleanup" },
        @{ Path = "@project-core/automation/auto-backup.ps1"; Name = "Auto Backup" },
        @{ Path = "@project-core/automation/optimize-build.ps1"; Name = "Optimize Build" },
        @{ Path = "@project-core/automation/dependency-check.ps1"; Name = "Dependency Check" },
        @{ Path = "@project-core/automation/post-task-validation.ps1"; Name = "Post Task Validation" }
    )
    
    $syntaxResults = @()
    foreach ($script in $scriptsToTest) {
        $result = Test-ScriptSyntax -ScriptPath $script.Path -ScriptName $script.Name
        $syntaxResults += $result
    }
    
    # Test command formats
    if ($TestAll) {
        $commandFormats = Test-CommandFormats
    }
    
    # Generate recommended commands
    $recommendedCommands = Get-RecommendedStartupCommands
    
    # Generate configuration file
    if ($GenerateCommands) {
        $configPath = New-StartupScriptConfiguration -Commands $recommendedCommands
    }
    
    # Summary
    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "TEST SUMMARY" "Info"
    Write-StatusMessage "================================================================" "Info"
    
    $passedSyntax = ($syntaxResults | Where-Object { $_ -eq $true }).Count
    $totalSyntax = $syntaxResults.Count
    
    Write-StatusMessage "Syntax Tests: $passedSyntax/$totalSyntax passed" "Info"
    
    $availableCommands = ($recommendedCommands | Where-Object { $_.Status -eq "Available" }).Count
    $totalCommands = $recommendedCommands.Count
    
    Write-StatusMessage "Available Scripts: $availableCommands/$totalCommands" "Info"
    
    if ($GenerateCommands -and $configPath) {
        Write-StatusMessage "Configuration generated: $configPath" "Success"
    }
    
    # Recommendations
    Write-StatusMessage "RECOMMENDATIONS:" "Info"
    Write-StatusMessage "1. Fix any syntax errors before using scripts" "Info"
    Write-StatusMessage "2. Test individual commands before adding to startup" "Info"
    Write-StatusMessage "3. Use -GenerateCommands to create configuration file" "Info"
    Write-StatusMessage "4. Start with Priority 1 commands only" "Info"
    
    exit 0
}
catch {
    Write-StatusMessage "Test failed: $($_.Exception.Message)" "Error"
    exit 1
}

# ===============================================================================
# USAGE EXAMPLES
# ===============================================================================
<#
.SYNOPSIS
Tests startup scripts syntax and generates configuration

.DESCRIPTION
Verifica a sintaxe dos scripts de automação e gera comandos corretos
para usar no startup script do terminal VS Code.

.PARAMETER TestAll
Test all command format variations

.PARAMETER GenerateCommands
Generate startup script configuration file

.EXAMPLE
# Basic test
.\test-startup-scripts.ps1

.EXAMPLE
# Full test with command generation
.\test-startup-scripts.ps1 -TestAll -GenerateCommands
#>
