# OPTIMIZATION OPPORTUNITY SCANNER - GRUPO US VIBECODE SYSTEM V4.0
# Identifies potential consolidation and optimization opportunities
# Created: 2025-01-10
# Purpose: Systematic analysis for continuous optimization

param(
    [switch]$Detailed = $false,
    [switch]$GenerateReport = $false,
    [string]$TargetDirectory = "@project-core",
    [int]$MinFileSize = 1024  # Minimum file size to consider (bytes)
)

# ===============================================================================
# SCANNER CONFIGURATION
# ===============================================================================

$SCAN_PATTERNS = @{
    DuplicateFiles = @("*.md", "*.json", "*.js", "*.ps1", "*.txt")
    BackupPatterns = @("*backup*", "*old*", "*temp*", "*deprecated*", "*archive*")
    LargeDirectories = 50  # Minimum file count to flag as large
    SimilarityThreshold = 0.8  # File similarity threshold
}

$OPTIMIZATION_CATEGORIES = @{
    "Duplicate Content" = @()
    "Backup Consolidation" = @()
    "Large Directory Analysis" = @()
    "Naming Inconsistencies" = @()
    "Structural Improvements" = @()
}

# ===============================================================================
# ANALYSIS FUNCTIONS
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
        "OPPORTUNITY" { Write-Host "[$timestamp] 🎯 $Message" -ForegroundColor Magenta }
        default { Write-Host "[$timestamp] $Message" -ForegroundColor White }
    }
}

function Get-FileHash {
    param([string]$FilePath)
    
    try {
        $hash = Get-FileHash $FilePath -Algorithm MD5 -ErrorAction SilentlyContinue
        return $hash.Hash
    }
    catch {
        return $null
    }
}

function Find-DuplicateFiles {
    Write-ScanMessage "Scanning for duplicate files..." "INFO"
    
    $duplicates = @()
    $fileHashes = @{}
    
    foreach ($pattern in $SCAN_PATTERNS.DuplicateFiles) {
        $files = Get-ChildItem $TargetDirectory -Filter $pattern -Recurse -File -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            if ($file.Length -lt $MinFileSize) { continue }
            
            $hash = Get-FileHash -FilePath $file.FullName
            if ($hash) {
                if ($fileHashes.ContainsKey($hash)) {
                    $duplicates += @{
                        OriginalFile = $fileHashes[$hash]
                        DuplicateFile = $file.FullName
                        Size = $file.Length
                        Hash = $hash
                    }
                } else {
                    $fileHashes[$hash] = $file.FullName
                }
            }
        }
    }
    
    if ($duplicates.Count -gt 0) {
        Write-ScanMessage "Found $($duplicates.Count) duplicate files" "OPPORTUNITY"
        $OPTIMIZATION_CATEGORIES["Duplicate Content"] = $duplicates
    } else {
        Write-ScanMessage "No duplicate files found" "SUCCESS"
    }
    
    return $duplicates
}

function Find-BackupOpportunities {
    Write-ScanMessage "Scanning for backup consolidation opportunities..." "INFO"
    
    $backupItems = @()
    
    foreach ($pattern in $SCAN_PATTERNS.BackupPatterns) {
        $items = Get-ChildItem $TargetDirectory -Filter $pattern -Recurse -ErrorAction SilentlyContinue
        
        foreach ($item in $items) {
            $backupItems += @{
                Path = $item.FullName
                Type = if ($item.PSIsContainer) { "Directory" } else { "File" }
                Size = if ($item.PSIsContainer) { 
                    (Get-ChildItem $item.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum 
                } else { 
                    $item.Length 
                }
                LastModified = $item.LastWriteTime
                Pattern = $pattern
            }
        }
    }
    
    if ($backupItems.Count -gt 0) {
        Write-ScanMessage "Found $($backupItems.Count) backup items for potential consolidation" "OPPORTUNITY"
        $OPTIMIZATION_CATEGORIES["Backup Consolidation"] = $backupItems
    } else {
        Write-ScanMessage "No backup consolidation opportunities found" "SUCCESS"
    }
    
    return $backupItems
}

function Analyze-LargeDirectories {
    Write-ScanMessage "Analyzing large directories..." "INFO"
    
    $largeDirectories = @()
    $directories = Get-ChildItem $TargetDirectory -Directory -Recurse -ErrorAction SilentlyContinue
    
    foreach ($dir in $directories) {
        $fileCount = (Get-ChildItem $dir.FullName -File -ErrorAction SilentlyContinue).Count
        $subdirCount = (Get-ChildItem $dir.FullName -Directory -ErrorAction SilentlyContinue).Count
        
        if ($fileCount -ge $SCAN_PATTERNS.LargeDirectories) {
            $totalSize = (Get-ChildItem $dir.FullName -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            
            $largeDirectories += @{
                Path = $dir.FullName
                FileCount = $fileCount
                SubdirectoryCount = $subdirCount
                TotalSize = $totalSize
                LastModified = $dir.LastWriteTime
            }
        }
    }
    
    if ($largeDirectories.Count -gt 0) {
        Write-ScanMessage "Found $($largeDirectories.Count) large directories for analysis" "OPPORTUNITY"
        $OPTIMIZATION_CATEGORIES["Large Directory Analysis"] = $largeDirectories
    } else {
        Write-ScanMessage "No large directories requiring analysis" "SUCCESS"
    }
    
    return $largeDirectories
}

function Find-NamingInconsistencies {
    Write-ScanMessage "Scanning for naming inconsistencies..." "INFO"
    
    $inconsistencies = @()
    $items = Get-ChildItem $TargetDirectory -Recurse -ErrorAction SilentlyContinue
    
    foreach ($item in $items) {
        $name = $item.Name
        $issues = @()
        
        # Check for mixed case patterns
        if ($name -cmatch "[A-Z]" -and $name -cmatch "[a-z]" -and $name -match "_|-") {
            $issues += "Mixed case with separators"
        }
        
        # Check for spaces in names
        if ($name -match " ") {
            $issues += "Contains spaces"
        }
        
        # Check for multiple separators
        if ($name -match "__" -or $name -match "--") {
            $issues += "Multiple consecutive separators"
        }
        
        # Check for inconsistent extensions
        if ($item.Extension -and $item.Extension -cmatch "[A-Z]") {
            $issues += "Uppercase file extension"
        }
        
        if ($issues.Count -gt 0) {
            $inconsistencies += @{
                Path = $item.FullName
                Name = $name
                Issues = $issues
                Type = if ($item.PSIsContainer) { "Directory" } else { "File" }
            }
        }
    }
    
    if ($inconsistencies.Count -gt 0) {
        Write-ScanMessage "Found $($inconsistencies.Count) naming inconsistencies" "OPPORTUNITY"
        $OPTIMIZATION_CATEGORIES["Naming Inconsistencies"] = $inconsistencies
    } else {
        Write-ScanMessage "No naming inconsistencies found" "SUCCESS"
    }
    
    return $inconsistencies
}

function Analyze-StructuralImprovements {
    Write-ScanMessage "Analyzing structural improvement opportunities..." "INFO"
    
    $improvements = @()
    
    # Check for deeply nested structures
    $deepPaths = Get-ChildItem $TargetDirectory -Recurse -ErrorAction SilentlyContinue | 
                 Where-Object { ($_.FullName -split "[\\/]").Count -gt 8 }
    
    foreach ($path in $deepPaths) {
        $improvements += @{
            Type = "Deep Nesting"
            Path = $path.FullName
            Depth = ($path.FullName -split "[\\/]").Count
            Suggestion = "Consider flattening directory structure"
        }
    }
    
    # Check for single-item directories
    $directories = Get-ChildItem $TargetDirectory -Directory -Recurse -ErrorAction SilentlyContinue
    foreach ($dir in $directories) {
        $items = Get-ChildItem $dir.FullName -ErrorAction SilentlyContinue
        if ($items.Count -eq 1 -and $items[0].PSIsContainer) {
            $improvements += @{
                Type = "Single Item Directory"
                Path = $dir.FullName
                Suggestion = "Consider merging with parent or child directory"
                ChildPath = $items[0].FullName
            }
        }
    }
    
    if ($improvements.Count -gt 0) {
        Write-ScanMessage "Found $($improvements.Count) structural improvement opportunities" "OPPORTUNITY"
        $OPTIMIZATION_CATEGORIES["Structural Improvements"] = $improvements
    } else {
        Write-ScanMessage "No structural improvements identified" "SUCCESS"
    }
    
    return $improvements
}

function Generate-OptimizationReport {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $reportPath = "@project-core/monitoring/optimization-report-$timestamp.md"
    $reportDir = Split-Path $reportPath -Parent
    
    if (!(Test-Path $reportDir)) {
        New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
    }
    
    $report = @"
# 🎯 OPTIMIZATION OPPORTUNITY REPORT

**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Target Directory**: $TargetDirectory  
**Scan Parameters**: MinFileSize=$MinFileSize bytes  
**Methodology**: GRUPO US VIBECODE SYSTEM V4.0

---

## 📊 EXECUTIVE SUMMARY

"@
    
    $totalOpportunities = 0
    foreach ($category in $OPTIMIZATION_CATEGORIES.Keys) {
        $count = $OPTIMIZATION_CATEGORIES[$category].Count
        $totalOpportunities += $count
        $report += "`n- **$category**: $count opportunities"
    }
    
    $report += @"

**Total Optimization Opportunities**: $totalOpportunities

---

"@
    
    foreach ($category in $OPTIMIZATION_CATEGORIES.Keys) {
        $opportunities = $OPTIMIZATION_CATEGORIES[$category]
        if ($opportunities.Count -gt 0) {
            $report += @"

## 🔍 $category

**Count**: $($opportunities.Count) opportunities identified

"@
            
            foreach ($opportunity in $opportunities) {
                $report += "### Opportunity: $($opportunity.Path -replace [regex]::Escape($TargetDirectory), '')`n"
                
                foreach ($key in $opportunity.Keys) {
                    if ($key -ne "Path") {
                        $value = $opportunity[$key]
                        if ($value -is [array]) {
                            $value = $value -join ", "
                        }
                        $report += "- **$key**: $value`n"
                    }
                }
                $report += "`n"
            }
        }
    }
    
    $report += @"

---

## 🎯 RECOMMENDED ACTIONS

### Priority 1: Critical Optimizations
- Address duplicate files to reduce storage overhead
- Consolidate backup directories for better organization
- Fix naming inconsistencies for improved maintainability

### Priority 2: Structural Improvements
- Analyze large directories for potential subdivision
- Flatten overly nested structures where appropriate
- Merge single-item directories to reduce complexity

### Priority 3: Continuous Monitoring
- Implement regular optimization scans
- Establish naming convention enforcement
- Monitor directory growth patterns

---

**Report Generated by**: GRUPO US VIBECODE SYSTEM V4.0 Optimization Scanner  
**Next Scan Recommended**: $(Get-Date (Get-Date).AddDays(7) -Format 'yyyy-MM-dd')
"@
    
    $report | Out-File $reportPath -Encoding UTF8
    Write-ScanMessage "Optimization report generated: $reportPath" "SUCCESS"
    
    return $reportPath
}

function Show-OptimizationSummary {
    Write-Host ""
    Write-ScanMessage "OPTIMIZATION SCAN SUMMARY:" "INFO"
    Write-Host "  ===========================================" -ForegroundColor Cyan
    
    $totalOpportunities = 0
    foreach ($category in $OPTIMIZATION_CATEGORIES.Keys) {
        $count = $OPTIMIZATION_CATEGORIES[$category].Count
        $totalOpportunities += $count
        
        $color = if ($count -gt 0) { "Yellow" } else { "Green" }
        Write-Host "  $category`: $count" -ForegroundColor $color
    }
    
    Write-Host "  ===========================================" -ForegroundColor Cyan
    Write-Host "  Total Opportunities: $totalOpportunities" -ForegroundColor $(if ($totalOpportunities -gt 0) { "Yellow" } else { "Green" })
    
    if ($totalOpportunities -gt 0) {
        Write-ScanMessage "Optimization opportunities identified - review recommendations" "OPPORTUNITY"
    } else {
        Write-ScanMessage "No optimization opportunities found - system is well-optimized" "SUCCESS"
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

function Start-OptimizationScan {
    Write-Host "🎯 OPTIMIZATION OPPORTUNITY SCANNER - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
    Write-Host "Target: $TargetDirectory" -ForegroundColor Cyan
    Write-Host ""
    
    # Execute all scans
    Find-DuplicateFiles
    Find-BackupOpportunities
    Analyze-LargeDirectories
    Find-NamingInconsistencies
    Analyze-StructuralImprovements
    
    # Show summary
    Show-OptimizationSummary
    
    # Generate report if requested
    if ($GenerateReport) {
        $reportPath = Generate-OptimizationReport
        Write-Host ""
        Write-ScanMessage "Detailed report available at: $reportPath" "INFO"
    }
    
    Write-Host ""
    Write-ScanMessage "Optimization scan completed!" "SUCCESS"
    
    return $OPTIMIZATION_CATEGORIES
}

# Execute optimization scan
Start-OptimizationScan
