# ===============================================================================
# CACHE CLEANUP SCRIPT - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Cleans development caches and temporary files for optimal performance
# Author: Augment Agent - Performance Optimization System
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Deep,
    
    [Parameter(Mandatory = $false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory = $false)]
    [switch]$Verbose,
    
    [Parameter(Mandatory = $false)]
    [switch]$SkipNodeModules
)

# Global variables
$script:TotalSpaceSaved = 0
$script:FilesRemoved = 0
$script:DirectoriesRemoved = 0

# Status message function
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

function Get-DirectorySize {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        return 0
    }
    
    try {
        $size = (Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | 
                Measure-Object -Property Length -Sum).Sum
        return [math]::Round($size / 1MB, 2)
    }
    catch {
        return 0
    }
}

function Remove-CacheDirectory {
    param(
        [string]$Path,
        [string]$Description,
        [bool]$IsDryRun = $false
    )
    
    if (-not (Test-Path $Path)) {
        if ($Verbose) {
            Write-StatusMessage "  ⏭️ $Description not found: $Path" "Info"
        }
        return
    }
    
    $sizeMB = Get-DirectorySize -Path $Path
    
    if ($IsDryRun) {
        Write-StatusMessage "  🔍 Would remove $Description ($sizeMB MB): $Path" "Warning"
        $script:TotalSpaceSaved += $sizeMB
        return
    }
    
    try {
        Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
        Write-StatusMessage "  ✅ Removed $Description ($sizeMB MB): $Path" "Success"
        $script:TotalSpaceSaved += $sizeMB
        $script:DirectoriesRemoved++
    }
    catch {
        Write-StatusMessage "  ❌ Failed to remove $Description: $($_.Exception.Message)" "Error"
    }
}

function Remove-CacheFiles {
    param(
        [string]$Pattern,
        [string]$Description,
        [bool]$IsDryRun = $false
    )
    
    try {
        $files = Get-ChildItem -Path . -Recurse -File -Include $Pattern -ErrorAction SilentlyContinue
        
        if ($files.Count -eq 0) {
            if ($Verbose) {
                Write-StatusMessage "  ⏭️ No $Description files found" "Info"
            }
            return
        }
        
        $totalSize = ($files | Measure-Object -Property Length -Sum).Sum
        $sizeMB = [math]::Round($totalSize / 1MB, 2)
        
        if ($IsDryRun) {
            Write-StatusMessage "  🔍 Would remove $($files.Count) $Description files ($sizeMB MB)" "Warning"
            $script:TotalSpaceSaved += $sizeMB
            return
        }
        
        foreach ($file in $files) {
            Remove-Item -Path $file.FullName -Force -ErrorAction SilentlyContinue
        }
        
        Write-StatusMessage "  ✅ Removed $($files.Count) $Description files ($sizeMB MB)" "Success"
        $script:TotalSpaceSaved += $sizeMB
        $script:FilesRemoved += $files.Count
    }
    catch {
        Write-StatusMessage "  ❌ Error removing $Description files: $($_.Exception.Message)" "Error"
    }
}

# ===============================================================================
# CLEANUP FUNCTIONS
# ===============================================================================

function Clear-NodeJSCache {
    Write-StatusMessage "=== CLEANING NODE.JS CACHE ===" "Info"
    
    # Node modules (if not skipped)
    if (-not $SkipNodeModules) {
        $nodeModulesDirs = Get-ChildItem -Path . -Recurse -Directory -Name "node_modules" -ErrorAction SilentlyContinue
        foreach ($dir in $nodeModulesDirs) {
            Remove-CacheDirectory -Path $dir -Description "Node modules" -IsDryRun $DryRun
        }
    } else {
        Write-StatusMessage "  ⏭️ Skipping node_modules cleanup as requested" "Info"
    }
    
    # NPM cache
    try {
        if (-not $DryRun) {
            & npm cache clean --force 2>$null
            Write-StatusMessage "  ✅ NPM cache cleaned" "Success"
        } else {
            Write-StatusMessage "  🔍 Would clean NPM cache" "Warning"
        }
    }
    catch {
        Write-StatusMessage "  ⚠️ NPM cache clean failed (npm may not be available)" "Warning"
    }
    
    # Yarn cache
    try {
        if (-not $DryRun) {
            & yarn cache clean 2>$null
            Write-StatusMessage "  ✅ Yarn cache cleaned" "Success"
        } else {
            Write-StatusMessage "  🔍 Would clean Yarn cache" "Warning"
        }
    }
    catch {
        Write-StatusMessage "  ⚠️ Yarn cache clean failed (yarn may not be available)" "Warning"
    }
    
    # Package lock files (if deep clean)
    if ($Deep) {
        Remove-CacheFiles -Pattern "package-lock.json" -Description "package-lock.json" -IsDryRun $DryRun
        Remove-CacheFiles -Pattern "yarn.lock" -Description "yarn.lock" -IsDryRun $DryRun
    }
}

function Clear-NextJSCache {
    Write-StatusMessage "=== CLEANING NEXT.JS CACHE ===" "Info"
    
    # .next directory
    Remove-CacheDirectory -Path ".next" -Description "Next.js build cache" -IsDryRun $DryRun
    
    # Next.js cache in node_modules
    Remove-CacheDirectory -Path "node_modules/.cache" -Description "Next.js node cache" -IsDryRun $DryRun
    
    # Vercel cache
    Remove-CacheDirectory -Path ".vercel" -Description "Vercel cache" -IsDryRun $DryRun
}

function Clear-FigmaCache {
    Write-StatusMessage "=== CLEANING FIGMA CACHE ===" "Info"
    
    # Figma cache directories
    $figmaCachePaths = @(
        "@project-core/tools/figma-cache",
        "@project-core/tools/figma-assets/cache",
        "figma-cache",
        ".figma-cache"
    )
    
    foreach ($path in $figmaCachePaths) {
        Remove-CacheDirectory -Path $path -Description "Figma cache" -IsDryRun $DryRun
    }
    
    # Figma temporary files
    Remove-CacheFiles -Pattern "*.figma-temp" -Description "Figma temporary" -IsDryRun $DryRun
    Remove-CacheFiles -Pattern "figma-*.tmp" -Description "Figma temp" -IsDryRun $DryRun
}

function Clear-DevelopmentCache {
    Write-StatusMessage "=== CLEANING DEVELOPMENT CACHE ===" "Info"
    
    # TypeScript cache
    Remove-CacheDirectory -Path ".tsbuildinfo" -Description "TypeScript build info" -IsDryRun $DryRun
    Remove-CacheFiles -Pattern "*.tsbuildinfo" -Description "TypeScript build info" -IsDryRun $DryRun
    
    # ESLint cache
    Remove-CacheFiles -Pattern ".eslintcache" -Description "ESLint cache" -IsDryRun $DryRun
    
    # Jest cache
    Remove-CacheDirectory -Path ".jest" -Description "Jest cache" -IsDryRun $DryRun
    
    # Turbo cache
    Remove-CacheDirectory -Path ".turbo" -Description "Turbo cache" -IsDryRun $DryRun
    
    # SWC cache
    Remove-CacheDirectory -Path ".swc" -Description "SWC cache" -IsDryRun $DryRun
}

function Clear-SystemCache {
    Write-StatusMessage "=== CLEANING SYSTEM CACHE ===" "Info"
    
    # Temporary files
    Remove-CacheFiles -Pattern "*.tmp" -Description "temporary" -IsDryRun $DryRun
    Remove-CacheFiles -Pattern "*.temp" -Description "temp" -IsDryRun $DryRun
    
    # Log files
    Remove-CacheFiles -Pattern "*.log" -Description "log" -IsDryRun $DryRun
    Remove-CacheFiles -Pattern "npm-debug.log*" -Description "npm debug log" -IsDryRun $DryRun
    Remove-CacheFiles -Pattern "yarn-error.log" -Description "yarn error log" -IsDryRun $DryRun
    
    # OS cache files
    Remove-CacheFiles -Pattern "Thumbs.db" -Description "Windows thumbnail cache" -IsDryRun $DryRun
    Remove-CacheFiles -Pattern ".DS_Store" -Description "macOS system" -IsDryRun $DryRun
    
    # Editor cache
    Remove-CacheDirectory -Path ".vscode/settings.json.bak" -Description "VS Code backup" -IsDryRun $DryRun
}

function Clear-BackupFiles {
    Write-StatusMessage "=== CLEANING BACKUP FILES ===" "Info"
    
    if ($Deep) {
        # Old backup directories (older than 7 days)
        $oldBackups = Get-ChildItem -Directory | Where-Object { 
            $_.Name -like "backup-*" -and 
            $_.CreationTime -lt (Get-Date).AddDays(-7) 
        }
        
        foreach ($backup in $oldBackups) {
            Remove-CacheDirectory -Path $backup.FullName -Description "old backup ($($backup.Name))" -IsDryRun $DryRun
        }
        
        # Backup files
        Remove-CacheFiles -Pattern "*.bak" -Description "backup" -IsDryRun $DryRun
        Remove-CacheFiles -Pattern "*~" -Description "editor backup" -IsDryRun $DryRun
    } else {
        Write-StatusMessage "  ⏭️ Skipping backup cleanup (use -Deep for backup cleanup)" "Info"
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "🧹 CACHE CLEANUP - GRUPO US VIBECODE SYSTEM V2.0" "Info"
    Write-StatusMessage "================================================================" "Info"
    
    if ($DryRun) {
        Write-StatusMessage "🔍 DRY RUN MODE - No files will be deleted" "Warning"
    }
    
    if ($Deep) {
        Write-StatusMessage "🔥 DEEP CLEANUP MODE - Including package locks and backups" "Warning"
    }
    
    # Initialize counters
    $script:TotalSpaceSaved = 0
    $script:FilesRemoved = 0
    $script:DirectoriesRemoved = 0
    
    # Run cleanup functions
    Clear-NodeJSCache
    Clear-NextJSCache
    Clear-FigmaCache
    Clear-DevelopmentCache
    Clear-SystemCache
    Clear-BackupFiles
    
    # Final summary
    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "🎉 CACHE CLEANUP COMPLETED!" "Success"
    Write-StatusMessage "================================================================" "Info"
    
    Write-StatusMessage "Summary:" "Info"
    Write-StatusMessage "  📁 Directories removed: $script:DirectoriesRemoved" "Info"
    Write-StatusMessage "  📄 Files removed: $script:FilesRemoved" "Info"
    Write-StatusMessage "  💾 Space saved: $([math]::Round($script:TotalSpaceSaved, 2)) MB" "Success"
    
    if ($DryRun) {
        Write-StatusMessage "  🔍 This was a dry run - no files were actually deleted" "Warning"
        Write-StatusMessage "  ▶️ Run without -DryRun to perform actual cleanup" "Info"
    }
    
    Write-StatusMessage "Recommendations:" "Info"
    Write-StatusMessage "  • Run this script weekly for optimal performance" "Info"
    Write-StatusMessage "  • Use -Deep monthly for thorough cleanup" "Info"
    Write-StatusMessage "  • Monitor disk space regularly" "Info"
    
    exit 0
}
catch {
    Write-StatusMessage "Cache cleanup failed: $($_.Exception.Message)" "Error"
    exit 1
}

# ===============================================================================
# USAGE EXAMPLES
# ===============================================================================
<#
.SYNOPSIS
Cache cleanup script for GRUPO US VIBECODE SYSTEM V2.0

.DESCRIPTION
Cleans development caches, temporary files, and build artifacts to optimize
performance and free up disk space.

.PARAMETER Deep
Perform deep cleanup including package locks and old backups

.PARAMETER DryRun
Show what would be deleted without actually deleting

.PARAMETER Verbose
Show detailed information about cleanup process

.PARAMETER SkipNodeModules
Skip node_modules cleanup (useful for active development)

.EXAMPLE
# Basic cleanup
.\cache-cleanup.ps1

.EXAMPLE
# Dry run to see what would be cleaned
.\cache-cleanup.ps1 -DryRun -Verbose

.EXAMPLE
# Deep cleanup with verbose output
.\cache-cleanup.ps1 -Deep -Verbose

.EXAMPLE
# Cleanup without touching node_modules
.\cache-cleanup.ps1 -SkipNodeModules
#>
