# PRE-COMMIT STRUCTURE VALIDATOR - GRUPO US VIBECODE SYSTEM V4.0
# Prevents creation of nested @project-core directories and validates structure
# Created: 2025-01-10
# Purpose: Proactive prevention of structural violations

param(
    [string]$TargetPath = "",
    [switch]$DryRun = $false,
    [switch]$Verbose = $false
)

# ===============================================================================
# VALIDATION CONFIGURATION
# ===============================================================================

$FORBIDDEN_PATTERNS = @(
    "*/@project-core/@project-core*",
    "*/@project-core/memory/@project-core*",
    "*/@project-core/*/memory/@project-core*",
    "*/@project-core/*/@project-core*"
)

$APPROVED_TOP_LEVEL = @(
    "memory", "rules", "automation", "configs", "docs", 
    "tools", "scripts", "backups", "monitoring", "templates"
)

$NAMING_PATTERN = "^[a-z0-9][a-z0-9\-_]*[a-z0-9]$|^[a-z0-9]$"

# ===============================================================================
# VALIDATION FUNCTIONS
# ===============================================================================

function Write-ValidationMessage {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    
    switch ($Type) {
        "SUCCESS" { Write-Host "[$timestamp] ✅ $Message" -ForegroundColor Green }
        "WARNING" { Write-Host "[$timestamp] ⚠️ $Message" -ForegroundColor Yellow }
        "ERROR" { Write-Host "[$timestamp] ❌ $Message" -ForegroundColor Red }
        "INFO" { Write-Host "[$timestamp] ℹ️ $Message" -ForegroundColor Blue }
        default { Write-Host "[$timestamp] $Message" -ForegroundColor White }
    }
}

function Test-ForbiddenPatterns {
    param([string]$Path)
    
    Write-ValidationMessage "Checking for forbidden nested patterns..." "INFO"
    
    foreach ($pattern in $FORBIDDEN_PATTERNS) {
        if ($Path -like $pattern) {
            Write-ValidationMessage "CRITICAL VIOLATION: Path matches forbidden pattern '$pattern'" "ERROR"
            Write-ValidationMessage "Path: $Path" "ERROR"
            return $false
        }
    }
    
    # Check if creating nested @project-core
    if ($Path -match "@project-core.*@project-core") {
        Write-ValidationMessage "CRITICAL VIOLATION: Nested @project-core structure detected" "ERROR"
        Write-ValidationMessage "Path: $Path" "ERROR"
        return $false
    }
    
    Write-ValidationMessage "No forbidden patterns detected" "SUCCESS"
    return $true
}

function Test-NamingConvention {
    param([string]$DirectoryName)
    
    Write-ValidationMessage "Validating naming convention for: $DirectoryName" "INFO"
    
    # Allow special cases
    $specialCases = @("@project-core", ".git", ".vscode", "node_modules")
    if ($DirectoryName -in $specialCases) {
        Write-ValidationMessage "Special case directory approved: $DirectoryName" "SUCCESS"
        return $true
    }
    
    # Check naming pattern
    if ($DirectoryName -match $NAMING_PATTERN) {
        Write-ValidationMessage "Naming convention approved: $DirectoryName" "SUCCESS"
        return $true
    } else {
        Write-ValidationMessage "NAMING VIOLATION: '$DirectoryName' doesn't follow naming convention" "ERROR"
        Write-ValidationMessage "Required: lowercase, numbers, hyphens, underscores only" "ERROR"
        Write-ValidationMessage "Examples: 'my-directory', 'config_files', 'tools'" "INFO"
        return $false
    }
}

function Test-LogicalPlacement {
    param([string]$Path)
    
    Write-ValidationMessage "Validating logical placement..." "INFO"
    
    # Extract the path components
    $pathParts = $Path -split "[\\/]" | Where-Object { $_ -ne "" }
    
    # Find @project-core index
    $projectCoreIndex = -1
    for ($i = 0; $i -lt $pathParts.Count; $i++) {
        if ($pathParts[$i] -eq "@project-core") {
            $projectCoreIndex = $i
            break
        }
    }
    
    if ($projectCoreIndex -eq -1) {
        Write-ValidationMessage "Path is outside @project-core - no validation needed" "INFO"
        return $true
    }
    
    # Check if it's a top-level directory under @project-core
    if ($projectCoreIndex + 1 -lt $pathParts.Count) {
        $topLevelDir = $pathParts[$projectCoreIndex + 1]
        
        if ($topLevelDir -notin $APPROVED_TOP_LEVEL) {
            Write-ValidationMessage "PLACEMENT WARNING: '$topLevelDir' is not an approved top-level directory" "WARNING"
            Write-ValidationMessage "Approved directories: $($APPROVED_TOP_LEVEL -join ', ')" "INFO"
            Write-ValidationMessage "Consider placing content in appropriate existing directory" "INFO"
            
            if (!$DryRun) {
                $response = Read-Host "Continue anyway? (y/N)"
                if ($response -ne "y" -and $response -ne "Y") {
                    return $false
                }
            }
        } else {
            Write-ValidationMessage "Logical placement approved: @project-core/$topLevelDir" "SUCCESS"
        }
    }
    
    return $true
}

function Test-ExistingStructure {
    param([string]$Path)
    
    Write-ValidationMessage "Checking for conflicts with existing structure..." "INFO"
    
    if (Test-Path $Path) {
        Write-ValidationMessage "WARNING: Path already exists: $Path" "WARNING"
        
        if (Test-Path $Path -PathType Container) {
            $itemCount = (Get-ChildItem $Path -ErrorAction SilentlyContinue).Count
            Write-ValidationMessage "Existing directory contains $itemCount items" "INFO"
        }
        
        if (!$DryRun) {
            $response = Read-Host "Path exists. Continue? (y/N)"
            if ($response -ne "y" -and $response -ne "Y") {
                return $false
            }
        }
    } else {
        Write-ValidationMessage "Path is available for creation" "SUCCESS"
    }
    
    return $true
}

function Invoke-ComprehensiveValidation {
    param([string]$Path)
    
    Write-ValidationMessage "Starting comprehensive structure validation..." "INFO"
    Write-ValidationMessage "Target path: $Path" "INFO"
    
    if ($DryRun) {
        Write-ValidationMessage "DRY RUN MODE - No actual changes will be made" "WARNING"
    }
    
    $validationResults = @{
        ForbiddenPatterns = $false
        NamingConvention = $false
        LogicalPlacement = $false
        ExistingStructure = $false
    }
    
    # Test 1: Forbidden patterns
    $validationResults.ForbiddenPatterns = Test-ForbiddenPatterns -Path $Path
    
    # Test 2: Naming convention
    $directoryName = Split-Path $Path -Leaf
    $validationResults.NamingConvention = Test-NamingConvention -DirectoryName $directoryName
    
    # Test 3: Logical placement
    $validationResults.LogicalPlacement = Test-LogicalPlacement -Path $Path
    
    # Test 4: Existing structure
    $validationResults.ExistingStructure = Test-ExistingStructure -Path $Path
    
    return $validationResults
}

function Show-ValidationSummary {
    param([hashtable]$Results)
    
    Write-Host ""
    Write-ValidationMessage "VALIDATION SUMMARY:" "INFO"
    Write-Host "  ===========================================" -ForegroundColor Cyan
    
    $allPassed = $true
    $criticalFailed = $false
    
    foreach ($test in $Results.Keys) {
        $status = if ($Results[$test]) { "PASS" } else { "FAIL" }
        $color = if ($Results[$test]) { "Green" } else { "Red" }
        
        Write-Host "  $test`: $status" -ForegroundColor $color
        
        if (!$Results[$test]) {
            $allPassed = $false
            if ($test -eq "ForbiddenPatterns" -or $test -eq "NamingConvention") {
                $criticalFailed = $true
            }
        }
    }
    
    Write-Host "  ===========================================" -ForegroundColor Cyan
    
    if ($allPassed) {
        Write-ValidationMessage "ALL VALIDATIONS PASSED - Structure creation approved!" "SUCCESS"
        return $true
    } elseif ($criticalFailed) {
        Write-ValidationMessage "CRITICAL VALIDATIONS FAILED - Structure creation BLOCKED!" "ERROR"
        return $false
    } else {
        Write-ValidationMessage "Some validations failed but creation may proceed with caution" "WARNING"
        return $true
    }
}

function Show-UsageHelp {
    Write-Host "📋 PRE-COMMIT STRUCTURE VALIDATOR - USAGE GUIDE" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "PURPOSE:" -ForegroundColor Cyan
    Write-Host "  Validates directory structure before creation to prevent violations" -ForegroundColor White
    Write-Host ""
    Write-Host "PARAMETERS:" -ForegroundColor Cyan
    Write-Host "  -TargetPath    Path to validate (required)" -ForegroundColor White
    Write-Host "  -DryRun        Test validation without user prompts" -ForegroundColor White
    Write-Host "  -Verbose       Show detailed validation information" -ForegroundColor White
    Write-Host ""
    Write-Host "EXAMPLES:" -ForegroundColor Cyan
    Write-Host "  .\pre-commit-structure-validator.ps1 -TargetPath '@project-core/memory/new-feature'" -ForegroundColor Gray
    Write-Host "  .\pre-commit-structure-validator.ps1 -TargetPath 'some/path' -DryRun" -ForegroundColor Gray
    Write-Host ""
    Write-Host "VALIDATION CHECKS:" -ForegroundColor Cyan
    Write-Host "  • Forbidden nested @project-core patterns" -ForegroundColor White
    Write-Host "  • Naming convention compliance" -ForegroundColor White
    Write-Host "  • Logical content placement" -ForegroundColor White
    Write-Host "  • Existing structure conflicts" -ForegroundColor White
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-PreCommitValidation {
    Write-Host "🔧 PRE-COMMIT STRUCTURE VALIDATOR - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
    Write-Host ""
    
    if ([string]::IsNullOrWhiteSpace($TargetPath)) {
        Write-ValidationMessage "No target path specified" "ERROR"
        Show-UsageHelp
        return $false
    }
    
    # Normalize path
    $normalizedPath = $TargetPath -replace "\\", "/"
    
    # Run comprehensive validation
    $results = Invoke-ComprehensiveValidation -Path $normalizedPath
    
    # Show summary and return result
    $success = Show-ValidationSummary -Results $results
    
    if ($success) {
        Write-ValidationMessage "Structure validation completed successfully!" "SUCCESS"
        exit 0
    } else {
        Write-ValidationMessage "Structure validation failed - creation blocked!" "ERROR"
        exit 1
    }
}

# Execute validation
Start-PreCommitValidation
