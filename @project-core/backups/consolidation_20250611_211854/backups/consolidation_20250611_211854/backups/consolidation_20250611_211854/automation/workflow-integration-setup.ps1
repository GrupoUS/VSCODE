# WORKFLOW INTEGRATION SETUP - GRUPO US VIBECODE SYSTEM V4.0
# Integrates structure validation into development workflows
# Created: 2025-01-10
# Purpose: Automate validation integration across development tools

param(
    [switch]$InstallGitHooks = $false,
    [switch]$InstallVSCodeTasks = $false,
    [switch]$CreateAliases = $false,
    [switch]$All = $false,
    [switch]$Uninstall = $false
)

# ===============================================================================
# INTEGRATION CONFIGURATION
# ===============================================================================

$GIT_HOOKS_DIR = ".git/hooks"
$VSCODE_TASKS_FILE = ".vscode/tasks.json"
$POWERSHELL_PROFILE = $PROFILE
$VALIDATOR_SCRIPT = "@project-core/automation/pre-commit-structure-validator.ps1"

# ===============================================================================
# GIT HOOKS INTEGRATION
# ===============================================================================

function Install-GitHooks {
    Write-Host "📦 Installing Git hooks for structure validation..." -ForegroundColor Yellow
    
    if (!(Test-Path $GIT_HOOKS_DIR)) {
        Write-Host "❌ Git repository not found - no .git/hooks directory" -ForegroundColor Red
        return $false
    }
    
    # Create pre-commit hook
    $preCommitHook = @"
#!/bin/sh
# GRUPO US VIBECODE SYSTEM V4.0 - Structure Validation Hook
# Auto-generated on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

echo "🔍 Running structure validation..."

# Get list of staged files
staged_files=`$(git diff --cached --name-only --diff-filter=A)

# Check for new directories being added
for file in `$staged_files; do
    if [ -d "`$file" ]; then
        echo "📁 Validating new directory: `$file"
        
        # Run PowerShell validator
        powershell.exe -ExecutionPolicy Bypass -File "$VALIDATOR_SCRIPT" -TargetPath "`$file" -DryRun
        
        if [ `$? -ne 0 ]; then
            echo "❌ Structure validation failed for: `$file"
            echo "💡 Fix violations and try again"
            exit 1
        fi
    fi
done

echo "✅ Structure validation passed"
exit 0
"@
    
    $hookPath = "$GIT_HOOKS_DIR/pre-commit"
    
    try {
        $preCommitHook | Out-File $hookPath -Encoding ASCII
        
        # Make executable (if on Unix-like system)
        if ($IsLinux -or $IsMacOS) {
            chmod +x $hookPath
        }
        
        Write-Host "✅ Git pre-commit hook installed successfully" -ForegroundColor Green
        Write-Host "  Location: $hookPath" -ForegroundColor Gray
        return $true
    }
    catch {
        Write-Host "❌ Failed to install Git hook: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Uninstall-GitHooks {
    Write-Host "🗑️ Removing Git hooks..." -ForegroundColor Yellow
    
    $hookPath = "$GIT_HOOKS_DIR/pre-commit"
    
    if (Test-Path $hookPath) {
        try {
            Remove-Item $hookPath -Force
            Write-Host "✅ Git pre-commit hook removed" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "❌ Failed to remove Git hook: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "ℹ️ No Git hook found to remove" -ForegroundColor Blue
        return $true
    }
}

# ===============================================================================
# VS CODE TASKS INTEGRATION
# ===============================================================================

function Install-VSCodeTasks {
    Write-Host "🔧 Installing VS Code tasks for structure validation..." -ForegroundColor Yellow
    
    $vscodeDirPath = Split-Path $VSCODE_TASKS_FILE -Parent
    
    if (!(Test-Path $vscodeDirPath)) {
        New-Item -ItemType Directory -Path $vscodeDirPath -Force | Out-Null
        Write-Host "📁 Created .vscode directory" -ForegroundColor Green
    }
    
    $tasksConfig = @{
        version = "2.0.0"
        tasks = @(
            @{
                label = "Validate Directory Structure"
                type = "shell"
                command = "powershell"
                args = @(
                    "-ExecutionPolicy", "Bypass",
                    "-File", $VALIDATOR_SCRIPT,
                    "-TargetPath", "`${input:directoryPath}",
                    "-Verbose"
                )
                group = "build"
                presentation = @{
                    echo = $true
                    reveal = "always"
                    focus = $false
                    panel = "shared"
                }
                problemMatcher = @()
            },
            @{
                label = "Quick Structure Check"
                type = "shell"
                command = "powershell"
                args = @(
                    "-ExecutionPolicy", "Bypass",
                    "-File", "@project-core/automation/simple-structure-monitor.ps1",
                    "-Detailed"
                )
                group = "test"
                presentation = @{
                    echo = $true
                    reveal = "always"
                    focus = $false
                    panel = "shared"
                }
                problemMatcher = @()
            }
        )
        inputs = @(
            @{
                id = "directoryPath"
                description = "Directory path to validate"
                default = "@project-core/"
                type = "promptString"
            }
        )
    }
    
    try {
        $tasksConfig | ConvertTo-Json -Depth 10 | Out-File $VSCODE_TASKS_FILE -Encoding UTF8
        Write-Host "✅ VS Code tasks installed successfully" -ForegroundColor Green
        Write-Host "  Location: $VSCODE_TASKS_FILE" -ForegroundColor Gray
        Write-Host "  Usage: Ctrl+Shift+P → 'Tasks: Run Task' → 'Validate Directory Structure'" -ForegroundColor Blue
        return $true
    }
    catch {
        Write-Host "❌ Failed to install VS Code tasks: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Uninstall-VSCodeTasks {
    Write-Host "🗑️ Removing VS Code tasks..." -ForegroundColor Yellow
    
    if (Test-Path $VSCODE_TASKS_FILE) {
        try {
            # Read existing tasks
            $existingTasks = Get-Content $VSCODE_TASKS_FILE -Raw | ConvertFrom-Json
            
            # Remove our specific tasks
            $filteredTasks = $existingTasks.tasks | Where-Object { 
                $_.label -ne "Validate Directory Structure" -and 
                $_.label -ne "Quick Structure Check" 
            }
            
            if ($filteredTasks.Count -gt 0) {
                $existingTasks.tasks = $filteredTasks
                $existingTasks | ConvertTo-Json -Depth 10 | Out-File $VSCODE_TASKS_FILE -Encoding UTF8
                Write-Host "✅ Structure validation tasks removed from VS Code" -ForegroundColor Green
            } else {
                Remove-Item $VSCODE_TASKS_FILE -Force
                Write-Host "✅ VS Code tasks file removed (was empty)" -ForegroundColor Green
            }
            
            return $true
        }
        catch {
            Write-Host "❌ Failed to remove VS Code tasks: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "ℹ️ No VS Code tasks file found to modify" -ForegroundColor Blue
        return $true
    }
}

# ===============================================================================
# POWERSHELL ALIASES
# ===============================================================================

function Install-PowerShellAliases {
    Write-Host "⚡ Installing PowerShell aliases..." -ForegroundColor Yellow
    
    $aliases = @"

# GRUPO US VIBECODE SYSTEM V4.0 - Structure Validation Aliases
# Auto-generated on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

function Validate-Structure {
    param([string]`$Path)
    & "$VALIDATOR_SCRIPT" -TargetPath `$Path -Verbose
}

function Quick-StructureCheck {
    & "@project-core/automation/simple-structure-monitor.ps1" -Detailed
}

function Test-DirectoryNaming {
    param([string]`$Name)
    & "$VALIDATOR_SCRIPT" -TargetPath "test/`$Name" -DryRun
}

# Aliases
Set-Alias -Name "validate-dir" -Value "Validate-Structure"
Set-Alias -Name "check-structure" -Value "Quick-StructureCheck"
Set-Alias -Name "test-naming" -Value "Test-DirectoryNaming"

Write-Host "✅ GRUPO US structure validation aliases loaded" -ForegroundColor Green
"@
    
    try {
        if (!(Test-Path $POWERSHELL_PROFILE)) {
            New-Item -ItemType File -Path $POWERSHELL_PROFILE -Force | Out-Null
        }
        
        # Check if aliases already exist
        $profileContent = Get-Content $POWERSHELL_PROFILE -Raw -ErrorAction SilentlyContinue
        if ($profileContent -and $profileContent.Contains("GRUPO US VIBECODE SYSTEM V4.0 - Structure Validation Aliases")) {
            Write-Host "ℹ️ Aliases already exist in PowerShell profile" -ForegroundColor Blue
            return $true
        }
        
        $aliases | Out-File $POWERSHELL_PROFILE -Append -Encoding UTF8
        Write-Host "✅ PowerShell aliases installed successfully" -ForegroundColor Green
        Write-Host "  Location: $POWERSHELL_PROFILE" -ForegroundColor Gray
        Write-Host "  Usage: validate-dir '@project-core/new-folder'" -ForegroundColor Blue
        Write-Host "  Usage: check-structure" -ForegroundColor Blue
        Write-Host "  Usage: test-naming 'my-new-directory'" -ForegroundColor Blue
        Write-Host "💡 Restart PowerShell or run '. `$PROFILE' to load aliases" -ForegroundColor Yellow
        return $true
    }
    catch {
        Write-Host "❌ Failed to install PowerShell aliases: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Uninstall-PowerShellAliases {
    Write-Host "🗑️ Removing PowerShell aliases..." -ForegroundColor Yellow
    
    if (Test-Path $POWERSHELL_PROFILE) {
        try {
            $profileContent = Get-Content $POWERSHELL_PROFILE -Raw
            
            # Remove our aliases section
            $pattern = "# GRUPO US VIBECODE SYSTEM V4\.0 - Structure Validation Aliases.*?Write-Host.*?Green"
            $cleanedContent = $profileContent -replace $pattern, "" -replace "`r`n`r`n`r`n", "`r`n`r`n"
            
            $cleanedContent | Out-File $POWERSHELL_PROFILE -Encoding UTF8
            Write-Host "✅ PowerShell aliases removed" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "❌ Failed to remove PowerShell aliases: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "ℹ️ No PowerShell profile found to modify" -ForegroundColor Blue
        return $true
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Show-IntegrationHelp {
    Write-Host "📋 WORKFLOW INTEGRATION SETUP - USAGE GUIDE" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "PURPOSE:" -ForegroundColor Cyan
    Write-Host "  Integrates structure validation into development workflows" -ForegroundColor White
    Write-Host ""
    Write-Host "PARAMETERS:" -ForegroundColor Cyan
    Write-Host "  -InstallGitHooks      Install Git pre-commit hooks" -ForegroundColor White
    Write-Host "  -InstallVSCodeTasks   Install VS Code tasks" -ForegroundColor White
    Write-Host "  -CreateAliases        Create PowerShell aliases" -ForegroundColor White
    Write-Host "  -All                  Install all integrations" -ForegroundColor White
    Write-Host "  -Uninstall            Remove all integrations" -ForegroundColor White
    Write-Host ""
    Write-Host "EXAMPLES:" -ForegroundColor Cyan
    Write-Host "  .\workflow-integration-setup.ps1 -All" -ForegroundColor Gray
    Write-Host "  .\workflow-integration-setup.ps1 -InstallGitHooks" -ForegroundColor Gray
    Write-Host "  .\workflow-integration-setup.ps1 -Uninstall" -ForegroundColor Gray
}

function Start-WorkflowIntegration {
    Write-Host "🔧 WORKFLOW INTEGRATION SETUP - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
    Write-Host ""
    
    $success = $true
    
    if ($All) {
        $InstallGitHooks = $true
        $InstallVSCodeTasks = $true
        $CreateAliases = $true
    }
    
    if ($Uninstall) {
        Write-Host "🗑️ Uninstalling all workflow integrations..." -ForegroundColor Yellow
        $success = $success -and (Uninstall-GitHooks)
        $success = $success -and (Uninstall-VSCodeTasks)
        $success = $success -and (Uninstall-PowerShellAliases)
    } else {
        if ($InstallGitHooks) {
            $success = $success -and (Install-GitHooks)
        }
        
        if ($InstallVSCodeTasks) {
            $success = $success -and (Install-VSCodeTasks)
        }
        
        if ($CreateAliases) {
            $success = $success -and (Install-PowerShellAliases)
        }
        
        if (!$InstallGitHooks -and !$InstallVSCodeTasks -and !$CreateAliases) {
            Show-IntegrationHelp
            return $true
        }
    }
    
    Write-Host ""
    if ($success) {
        Write-Host "✅ Workflow integration completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Some integrations failed - check messages above" -ForegroundColor Yellow
    }
    
    return $success
}

# Execute workflow integration
Start-WorkflowIntegration
