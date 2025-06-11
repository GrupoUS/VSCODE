# COMPREHENSIVE FILE CONSOLIDATION SCANNER - GRUPO US VIBECODE SYSTEM V4.0
# Scans entire system for scattered GRUPO US/VIBECODE files outside @project-core
# Created: 2025-01-10
# Purpose: Critical file consolidation audit and migration

param(
    [switch]$DryRun = $false,
    [switch]$GenerateReport = $true,
    [string]$TargetDirectory = "@project-core"  # Relative path for portability
)

# ===============================================================================
# SCANNER CONFIGURATION
# ===============================================================================

# Dynamic search locations using environment variables for portability
$SEARCH_LOCATIONS = @(
    "$env:USERPROFILE\Desktop",
    "$env:USERPROFILE\Documents",
    "$env:USERPROFILE\Downloads",
    "$env:LOCALAPPDATA",
    "$env:APPDATA",
    "@project-core",  # Always include project-core as primary location
    "$env:TEMP",
    "$env:WINDIR\Temp"
)

$SEARCH_PATTERNS = @(
    "*grupo*",
    "*vibecode*",
    "*project-core*",
    "*@project-core*",
    "*harmoniza*",
    "*neonpro*",
    "*aegiswallet*",
    "*mcp*",
    "*sequential-thinking*",
    "*shrimp*"
)

$EXCLUDED_PATHS = @(
    "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE\@project-core",
    "*\node_modules\*",
    "*\.git\*",
    "*\AppData\Local\Microsoft\*",
    "*\AppData\Roaming\Code\*"
)

$SCATTERED_FILES = @()
$CONSOLIDATION_PLAN = @()

# ===============================================================================
# SCANNER FUNCTIONS
# ===============================================================================

function Write-ScanMessage {
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
        "FOUND" { Write-Host "[$timestamp] 🔍 $Message" -ForegroundColor Magenta }
        default { Write-Host "[$timestamp] $Message" -ForegroundColor White }
    }
}

function Test-PathExcluded {
    param([string]$Path)

    foreach ($excludedPath in $EXCLUDED_PATHS) {
        if ($Path -like $excludedPath) {
            return $true
        }
    }
    return $false
}

function Get-TargetLocation {
    param([string]$FilePath, [string]$FileName)

    # Determine appropriate location within @project-core based on file type and content
    $extension = [System.IO.Path]::GetExtension($FileName).ToLower()
    $namePattern = $FileName.ToLower()

    # Configuration files
    if ($extension -in @(".json", ".config", ".yml", ".yaml") -or $namePattern -like "*config*") {
        return "$TargetDirectory/configs/"
    }

    # Scripts and automation
    if ($extension -in @(".ps1", ".bat", ".sh") -or $namePattern -like "*script*" -or $namePattern -like "*automation*") {
        return "$TargetDirectory/automation/"
    }

    # Documentation
    if ($extension -in @(".md", ".txt", ".doc", ".docx") -or $namePattern -like "*readme*" -or $namePattern -like "*doc*") {
        return "$TargetDirectory/docs/"
    }

    # Memory and learning files
    if ($namePattern -like "*memory*" -or $namePattern -like "*learning*" -or $namePattern -like "*correction*") {
        return "$TargetDirectory/memory/"
    }

    # Rules and protocols
    if ($namePattern -like "*rule*" -or $namePattern -like "*protocol*" -or $namePattern -like "*standard*") {
        return "$TargetDirectory/rules/"
    }

    # Tools and utilities
    if ($namePattern -like "*tool*" -or $namePattern -like "*util*" -or $extension -in @(".exe", ".msi")) {
        return "$TargetDirectory/tools/"
    }

    # Backup files
    if ($namePattern -like "*backup*" -or $namePattern -like "*archive*" -or $namePattern -like "*old*") {
        return "$TargetDirectory/backups/"
    }

    # Default to tools directory for unclassified files
    return "$TargetDirectory/tools/misc/"
}

function Invoke-SystemScan {
    Write-ScanMessage "Starting comprehensive system scan for scattered files..." "INFO"

    $totalFound = 0

    foreach ($location in $SEARCH_LOCATIONS) {
        if (!(Test-Path $location)) {
            Write-ScanMessage "Location not found: $location" "WARNING"
            continue
        }

        Write-ScanMessage "Scanning location: $location" "INFO"

        foreach ($pattern in $SEARCH_PATTERNS) {
            try {
                $foundItems = Get-ChildItem $location -Filter $pattern -Recurse -ErrorAction SilentlyContinue |
                Where-Object { !(Test-PathExcluded $_.FullName) }

                foreach ($item in $foundItems) {
                    $scatteredFile = @{
                        FullPath       = $item.FullName
                        Name           = $item.Name
                        Size           = if ($item.PSIsContainer) { 0 } else { $item.Length }
                        Type           = if ($item.PSIsContainer) { "Directory" } else { "File" }
                        LastModified   = $item.LastWriteTime
                        Pattern        = $pattern
                        SourceLocation = $location
                        TargetLocation = Get-TargetLocation -FilePath $item.FullName -FileName $item.Name
                    }

                    $SCATTERED_FILES += $scatteredFile
                    $totalFound++

                    Write-ScanMessage "FOUND: $($item.FullName)" "FOUND"
                }
            }
            catch {
                Write-ScanMessage "Error scanning $location with pattern $pattern`: $($_.Exception.Message)" "ERROR"
            }
        }
    }

    Write-ScanMessage "Scan completed. Found $totalFound scattered items." "SUCCESS"
    return $SCATTERED_FILES
}

function New-ConsolidationPlan {
    param([array]$ScatteredFiles)

    Write-ScanMessage "Creating consolidation plan..." "INFO"

    foreach ($file in $ScatteredFiles) {
        $consolidationItem = @{
            SourcePath  = $file.FullPath
            TargetPath  = Join-Path $file.TargetLocation $file.Name
            Action      = if ($file.Type -eq "Directory") { "MoveDirectory" } else { "MoveFile" }
            Priority    = Get-ConsolidationPriority -File $file
            SafetyCheck = Test-ConsolidationSafety -File $file
        }

        $CONSOLIDATION_PLAN += $consolidationItem
    }

    # Sort by priority (High, Medium, Low)
    $CONSOLIDATION_PLAN = $CONSOLIDATION_PLAN | Sort-Object Priority

    Write-ScanMessage "Consolidation plan created with $($CONSOLIDATION_PLAN.Count) items." "SUCCESS"
    return $CONSOLIDATION_PLAN
}

function Get-ConsolidationPriority {
    param([hashtable]$File)

    $name = $File.Name.ToLower()

    # High priority: Configuration, rules, critical scripts
    if ($name -like "*config*" -or $name -like "*rule*" -or $name -like "*mcp*" -or $name -like "*sequential*") {
        return "High"
    }

    # Medium priority: Documentation, automation scripts
    if ($name -like "*.md" -or $name -like "*.ps1" -or $name -like "*doc*" -or $name -like "*automation*") {
        return "Medium"
    }

    # Low priority: Backups, temporary files
    return "Low"
}

function Test-ConsolidationSafety {
    param([hashtable]$File)

    $sourcePath = $File.FullPath

    # Check if file is currently in use
    try {
        if ($File.Type -eq "File") {
            $fileStream = [System.IO.File]::Open($sourcePath, 'Open', 'Read', 'None')
            $fileStream.Close()
        }
        return $true
    }
    catch {
        return $false
    }
}

function Invoke-FileConsolidation {
    param([array]$ConsolidationPlan)

    if ($DryRun) {
        Write-ScanMessage "DRY RUN MODE - No actual file movements will be performed" "WARNING"
    }

    $successCount = 0
    $errorCount = 0

    foreach ($item in $ConsolidationPlan) {
        Write-ScanMessage "Processing: $($item.SourcePath)" "INFO"

        if (!$item.SafetyCheck) {
            Write-ScanMessage "SKIPPED (safety check failed): $($item.SourcePath)" "WARNING"
            continue
        }

        if ($DryRun) {
            Write-ScanMessage "DRY RUN: Would move $($item.SourcePath) → $($item.TargetPath)" "INFO"
            $successCount++
            continue
        }

        try {
            # Ensure target directory exists
            $targetDir = Split-Path $item.TargetPath -Parent
            if (!(Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }

            # Handle potential naming conflicts
            $finalTargetPath = $item.TargetPath
            if (Test-Path $finalTargetPath) {
                $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
                $extension = [System.IO.Path]::GetExtension($finalTargetPath)
                $nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($finalTargetPath)
                $directory = Split-Path $finalTargetPath -Parent
                $finalTargetPath = Join-Path $directory "$nameWithoutExt-$timestamp$extension"
            }

            # Perform the move
            Move-Item $item.SourcePath $finalTargetPath -Force
            Write-ScanMessage "MOVED: $($item.SourcePath) → $finalTargetPath" "SUCCESS"
            $successCount++
        }
        catch {
            Write-ScanMessage "ERROR moving $($item.SourcePath)`: $($_.Exception.Message)" "ERROR"
            $errorCount++
        }
    }

    Write-ScanMessage "Consolidation completed: $successCount successful, $errorCount errors" "SUCCESS"
}

function New-ConsolidationReport {
    param([array]$ScatteredFiles, [array]$ConsolidationPlan)

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportPath = "$TargetDirectory/monitoring/file-consolidation-report-$timestamp.md"
    $reportDir = Split-Path $reportPath -Parent

    if (!(Test-Path $reportDir)) {
        New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    }

    $report = @"
# 🔍 COMPREHENSIVE FILE CONSOLIDATION REPORT

**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**Methodology**: GRUPO US VIBECODE SYSTEM V4.0 - Critical File Consolidation
**Target Directory**: $TargetDirectory

---

## 📊 EXECUTIVE SUMMARY

**Total Scattered Files Found**: $($ScatteredFiles.Count)
**Consolidation Items Planned**: $($ConsolidationPlan.Count)
**Scan Mode**: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })

---

## 🔍 SCATTERED FILES DISCOVERED

"@

    $groupedByLocation = $ScatteredFiles | Group-Object SourceLocation
    foreach ($group in $groupedByLocation) {
        $report += "`n### $($group.Name)`n"
        $report += "**Files Found**: $($group.Count)`n`n"

        foreach ($file in $group.Group) {
            $report += "- **$($file.Name)** ($($file.Type))`n"
            $report += "  - Path: $($file.FullPath)`n"
            $report += "  - Size: $(if ($file.Size -gt 0) { [math]::Round($file.Size/1KB, 2) } else { 0 }) KB`n"
            $report += "  - Target: $($file.TargetLocation)`n`n"
        }
    }

    $report += @"

---

## 🎯 CONSOLIDATION PLAN

"@

    $groupedByPriority = $ConsolidationPlan | Group-Object Priority
    foreach ($priorityGroup in $groupedByPriority) {
        $report += "`n### $($priorityGroup.Name) Priority`n"
        $report += "**Items**: $($priorityGroup.Count)`n`n"

        foreach ($item in $priorityGroup.Group) {
            $report += "- **Source**: $($item.SourcePath)`n"
            $report += "  **Target**: $($item.TargetPath)`n"
            $report += "  **Action**: $($item.Action)`n"
            $report += "  **Safety**: $(if ($item.SafetyCheck) { '✅ Safe' } else { '⚠️ Requires attention' })`n`n"
        }
    }

    $report += @"

---

## 📋 NEXT STEPS

1. **Review Consolidation Plan**: Verify all target locations are appropriate
2. **Execute Consolidation**: Run with -DryRun:$false to perform actual moves
3. **Validate Results**: Ensure all files are accessible in new locations
4. **Update References**: Update any hardcoded paths in configurations
5. **Clean Up**: Remove empty directories from source locations

---

**Report Generated by**: GRUPO US VIBECODE SYSTEM V4.0 File Consolidation Scanner
**Next Scan Recommended**: After consolidation completion
"@

    $report | Out-File $reportPath -Encoding UTF8
    Write-ScanMessage "Consolidation report generated: $reportPath" "SUCCESS"

    return $reportPath
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-ComprehensiveFileConsolidation {
    Write-Host "🔍 COMPREHENSIVE FILE CONSOLIDATION SCANNER - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
    Write-Host "Target Directory: $TargetDirectory" -ForegroundColor Cyan
    Write-Host "Mode: $(if ($DryRun) { 'DRY RUN' } else { 'LIVE EXECUTION' })" -ForegroundColor Yellow
    Write-Host ""

    # Phase 1: System Scan
    $scatteredFiles = Invoke-SystemScan

    if ($scatteredFiles.Count -eq 0) {
        Write-ScanMessage "No scattered files found - system is already consolidated!" "SUCCESS"
        return $true
    }

    # Phase 2: Create Consolidation Plan
    $consolidationPlan = New-ConsolidationPlan -ScatteredFiles $scatteredFiles

    # Phase 3: Generate Report
    if ($GenerateReport) {
        $reportPath = New-ConsolidationReport -ScatteredFiles $scatteredFiles -ConsolidationPlan $consolidationPlan
    }

    # Phase 4: Execute Consolidation
    Invoke-FileConsolidation -ConsolidationPlan $consolidationPlan

    Write-Host ""
    Write-ScanMessage "Comprehensive file consolidation completed!" "SUCCESS"

    return $true
}

# Execute comprehensive file consolidation
Start-ComprehensiveFileConsolidation
