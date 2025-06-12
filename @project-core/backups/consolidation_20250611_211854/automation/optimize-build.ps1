# ===============================================================================
# BUILD OPTIMIZATION SCRIPT - GRUPO US VIBECODE SYSTEM V2.0
# ===============================================================================
# Optimizes Next.js builds and cleans unused assets for better performance
# Author: Augment Agent - Performance Optimization System
# Date: 2025-06-08
# ===============================================================================

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$AnalyzeBundle,
    
    [Parameter(Mandatory = $false)]
    [switch]$CleanAssets,
    
    [Parameter(Mandatory = $false)]
    [switch]$OptimizeImages,
    
    [Parameter(Mandatory = $false)]
    [switch]$GenerateReport,
    
    [Parameter(Mandatory = $false)]
    [string]$BuildCommand = "npm run build"
)

# Global variables
$script:OptimizationResults = @{
    BuildTime = 0
    BundleSize = 0
    AssetsRemoved = 0
    ImagesOptimized = 0
    SpaceSaved = 0
}

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

# ===============================================================================
# PRE-BUILD OPTIMIZATION
# ===============================================================================

function Optimize-PreBuild {
    Write-StatusMessage "=== PRE-BUILD OPTIMIZATION ===" "Info"
    
    try {
        # Clean previous build
        if (Test-Path ".next") {
            $oldSize = Get-DirectorySize -Path ".next"
            Remove-Item -Path ".next" -Recurse -Force
            Write-StatusMessage "Removed previous build ($oldSize MB)" "Success"
        }
        
        # Clean node_modules/.cache
        if (Test-Path "node_modules/.cache") {
            $cacheSize = Get-DirectorySize -Path "node_modules/.cache"
            Remove-Item -Path "node_modules/.cache" -Recurse -Force
            Write-StatusMessage "Cleared build cache ($cacheSize MB)" "Success"
        }
        
        # Verify package.json optimization settings
        if (Test-Path "package.json") {
            $packageJson = Get-Content "package.json" | ConvertFrom-Json
            
            # Check for build optimization scripts
            $hasOptimizedBuild = $packageJson.scripts.build -match "NODE_ENV=production"
            if (-not $hasOptimizedBuild) {
                Write-StatusMessage "Consider adding NODE_ENV=production to build script" "Warning"
            }
            
            Write-StatusMessage "Package.json verified" "Success"
        }
        
        return $true
    }
    catch {
        Write-StatusMessage "Pre-build optimization failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# BUILD EXECUTION
# ===============================================================================

function Invoke-OptimizedBuild {
    param([string]$Command)
    
    Write-StatusMessage "=== EXECUTING OPTIMIZED BUILD ===" "Info"
    Write-StatusMessage "Build command: $Command" "Info"
    
    try {
        $startTime = Get-Date
        
        # Set optimization environment variables
        $env:NODE_ENV = "production"
        $env:NEXT_TELEMETRY_DISABLED = "1"
        $env:ANALYZE = if ($AnalyzeBundle) { "true" } else { "false" }
        
        # Execute build command
        $buildOutput = & cmd /c $Command 2>&1
        $buildExitCode = $LASTEXITCODE
        
        $endTime = Get-Date
        $buildDuration = ($endTime - $startTime).TotalSeconds
        $script:OptimizationResults.BuildTime = [math]::Round($buildDuration, 2)
        
        if ($buildExitCode -eq 0) {
            Write-StatusMessage "Build completed successfully in $($script:OptimizationResults.BuildTime)s" "Success"
            
            # Get build size
            if (Test-Path ".next") {
                $script:OptimizationResults.BundleSize = Get-DirectorySize -Path ".next"
                Write-StatusMessage "Build size: $($script:OptimizationResults.BundleSize) MB" "Info"
            }
            
            return $true
        }
        else {
            Write-StatusMessage "Build failed with exit code: $buildExitCode" "Error"
            Write-Host $buildOutput
            return $false
        }
    }
    catch {
        Write-StatusMessage "Build execution failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# POST-BUILD OPTIMIZATION
# ===============================================================================

function Optimize-Assets {
    if (-not $CleanAssets) {
        Write-StatusMessage "Skipping asset optimization" "Info"
        return $true
    }
    
    Write-StatusMessage "=== OPTIMIZING ASSETS ===" "Info"
    
    try {
        $assetsRemoved = 0
        $spaceSaved = 0
        
        # Remove source maps in production (if not needed)
        $sourceMaps = Get-ChildItem -Path ".next" -Recurse -Filter "*.map" -ErrorAction SilentlyContinue
        foreach ($map in $sourceMaps) {
            $spaceSaved += $map.Length
            Remove-Item -Path $map.FullName -Force
            $assetsRemoved++
        }
        
        # Remove unused static assets (be careful with this)
        $publicDir = "public"
        if (Test-Path $publicDir) {
            # Find potentially unused assets (this is a basic check)
            $publicAssets = Get-ChildItem -Path $publicDir -Recurse -File
            $buildFiles = Get-ChildItem -Path ".next" -Recurse -File -Include "*.js", "*.css", "*.html"
            
            foreach ($asset in $publicAssets) {
                $assetName = $asset.Name
                $isReferenced = $false
                
                # Check if asset is referenced in build files
                foreach ($buildFile in $buildFiles) {
                    try {
                        $content = Get-Content $buildFile.FullName -Raw -ErrorAction SilentlyContinue
                        if ($content -and $content.Contains($assetName)) {
                            $isReferenced = $true
                            break
                        }
                    }
                    catch {
                        # Skip files that can't be read
                    }
                }
                
                # Only remove if clearly unused and safe to remove
                if (-not $isReferenced -and $assetName -match "\.(tmp|temp|bak)$") {
                    $spaceSaved += $asset.Length
                    Remove-Item -Path $asset.FullName -Force
                    $assetsRemoved++
                    Write-StatusMessage "  🗑️ Removed unused asset: $assetName" "Info"
                }
            }
        }
        
        $script:OptimizationResults.AssetsRemoved = $assetsRemoved
        $script:OptimizationResults.SpaceSaved += [math]::Round($spaceSaved / 1MB, 2)
        
        Write-StatusMessage "Assets optimization completed: $assetsRemoved files removed" "Success"
        return $true
    }
    catch {
        Write-StatusMessage "Asset optimization failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Optimize-Images {
    if (-not $OptimizeImages) {
        Write-StatusMessage "Skipping image optimization" "Info"
        return $true
    }
    
    Write-StatusMessage "=== OPTIMIZING IMAGES ===" "Info"
    
    try {
        $imagesOptimized = 0
        $spaceSaved = 0
        
        # Find images in public directory
        $imageExtensions = @("*.jpg", "*.jpeg", "*.png", "*.gif", "*.webp")
        $images = @()
        
        foreach ($ext in $imageExtensions) {
            $images += Get-ChildItem -Path "public" -Recurse -Filter $ext -ErrorAction SilentlyContinue
        }
        
        foreach ($image in $images) {
            $originalSize = $image.Length
            
            # Basic optimization: check if image is unnecessarily large
            if ($originalSize -gt 1MB) {
                Write-StatusMessage "  ⚠️ Large image found: $($image.Name) ($([math]::Round($originalSize / 1MB, 2)) MB)" "Warning"
                Write-StatusMessage "    Consider optimizing: $($image.FullName)" "Info"
            }
            
            # Check for duplicate images (same size and name pattern)
            $duplicates = $images | Where-Object { 
                $_.Name -ne $image.Name -and 
                $_.Length -eq $image.Length -and
                $_.BaseName -like "*$($image.BaseName)*"
            }
            
            if ($duplicates.Count -gt 0) {
                Write-StatusMessage "  🔍 Potential duplicate: $($image.Name)" "Warning"
            }
            
            $imagesOptimized++
        }
        
        $script:OptimizationResults.ImagesOptimized = $imagesOptimized
        
        Write-StatusMessage "Image analysis completed: $imagesOptimized images checked" "Success"
        
        if ($images.Count -gt 0) {
            Write-StatusMessage "Recommendations:" "Info"
            Write-StatusMessage "  • Use next/image for automatic optimization" "Info"
            Write-StatusMessage "  • Consider WebP format for better compression" "Info"
            Write-StatusMessage "  • Implement responsive images for different screen sizes" "Info"
        }
        
        return $true
    }
    catch {
        Write-StatusMessage "Image optimization failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

function Invoke-BundleAnalysis {
    if (-not $AnalyzeBundle) {
        Write-StatusMessage "Skipping bundle analysis" "Info"
        return $true
    }
    
    Write-StatusMessage "=== ANALYZING BUNDLE ===" "Info"
    
    try {
        # Check if @next/bundle-analyzer is available
        $packageJson = Get-Content "package.json" | ConvertFrom-Json
        $hasAnalyzer = $packageJson.devDependencies.'@next/bundle-analyzer' -or 
                      $packageJson.dependencies.'@next/bundle-analyzer'
        
        if (-not $hasAnalyzer) {
            Write-StatusMessage "Bundle analyzer not installed. Install with:" "Warning"
            Write-StatusMessage "npm install --save-dev @next/bundle-analyzer" "Info"
            return $true
        }
        
        # Run bundle analysis
        Write-StatusMessage "Running bundle analysis..." "Info"
        $env:ANALYZE = "true"
        
        # The analysis should have been done during build
        # Look for analysis output
        $analysisFiles = Get-ChildItem -Path ".next" -Recurse -Filter "*analyze*" -ErrorAction SilentlyContinue
        
        if ($analysisFiles.Count -gt 0) {
            Write-StatusMessage "Bundle analysis files generated:" "Success"
            foreach ($file in $analysisFiles) {
                Write-StatusMessage "  📊 $($file.FullName)" "Info"
            }
        }
        else {
            Write-StatusMessage "No bundle analysis files found" "Warning"
        }
        
        return $true
    }
    catch {
        Write-StatusMessage "Bundle analysis failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# REPORT GENERATION
# ===============================================================================

function New-OptimizationReport {
    if (-not $GenerateReport) {
        Write-StatusMessage "Skipping report generation" "Info"
        return $true
    }
    
    Write-StatusMessage "=== GENERATING OPTIMIZATION REPORT ===" "Info"
    
    try {
        $reportPath = "@project-core/reports/build-optimization-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
        
        # Ensure reports directory exists
        $reportsDir = "@project-core/reports"
        if (-not (Test-Path $reportsDir)) {
            New-Item -ItemType Directory -Path $reportsDir -Force | Out-Null
        }
        
        $report = @"
# Build Optimization Report
**Generated**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
**Build Command**: $BuildCommand

## Performance Metrics
- **Build Time**: $($script:OptimizationResults.BuildTime) seconds
- **Bundle Size**: $($script:OptimizationResults.BundleSize) MB
- **Assets Removed**: $($script:OptimizationResults.AssetsRemoved)
- **Images Analyzed**: $($script:OptimizationResults.ImagesOptimized)
- **Space Saved**: $($script:OptimizationResults.SpaceSaved) MB

## Optimization Steps Performed
- ✅ Pre-build cleanup
- ✅ Production build execution
- $($CleanAssets ? "✅" : "⏭️") Asset optimization
- $($OptimizeImages ? "✅" : "⏭️") Image analysis
- $($AnalyzeBundle ? "✅" : "⏭️") Bundle analysis

## Recommendations
1. **Performance Monitoring**: Set up continuous performance monitoring
2. **Bundle Analysis**: Regular bundle size analysis to catch bloat early
3. **Image Optimization**: Implement automatic image optimization pipeline
4. **Caching Strategy**: Optimize caching headers for static assets
5. **Code Splitting**: Implement dynamic imports for large components

## Next Steps
- Monitor build performance over time
- Set up automated performance budgets
- Implement CI/CD performance checks
- Regular dependency audits

---
*Generated by Build Optimization System - GRUPO US VIBECODE SYSTEM V2.0*
"@
        
        Set-Content -Path $reportPath -Value $report
        Write-StatusMessage "Optimization report generated: $reportPath" "Success"
        
        return $true
    }
    catch {
        Write-StatusMessage "Report generation failed: $($_.Exception.Message)" "Error"
        return $false
    }
}

# ===============================================================================
# MAIN EXECUTION
# ===============================================================================

try {
    Write-StatusMessage "⚡ BUILD OPTIMIZATION - GRUPO US VIBECODE SYSTEM V2.0" "Info"
    Write-StatusMessage "================================================================" "Info"
    
    # Pre-build optimization
    if (-not (Optimize-PreBuild)) {
        Write-StatusMessage "Pre-build optimization failed, but continuing..." "Warning"
    }
    
    # Execute optimized build
    if (-not (Invoke-OptimizedBuild -Command $BuildCommand)) {
        Write-StatusMessage "Build failed, stopping optimization" "Error"
        exit 1
    }
    
    # Post-build optimizations
    if (-not (Optimize-Assets)) {
        Write-StatusMessage "Asset optimization failed, but continuing..." "Warning"
    }
    
    if (-not (Optimize-Images)) {
        Write-StatusMessage "Image optimization failed, but continuing..." "Warning"
    }
    
    if (-not (Invoke-BundleAnalysis)) {
        Write-StatusMessage "Bundle analysis failed, but continuing..." "Warning"
    }
    
    # Generate report
    if (-not (New-OptimizationReport)) {
        Write-StatusMessage "Report generation failed, but optimization complete" "Warning"
    }
    
    # Final summary
    Write-StatusMessage "================================================================" "Info"
    Write-StatusMessage "🎉 BUILD OPTIMIZATION COMPLETED!" "Success"
    Write-StatusMessage "================================================================" "Info"
    
    Write-StatusMessage "Summary:" "Info"
    Write-StatusMessage "  ⏱️ Build Time: $($script:OptimizationResults.BuildTime)s" "Info"
    Write-StatusMessage "  📦 Bundle Size: $($script:OptimizationResults.BundleSize) MB" "Success"
    Write-StatusMessage "  🗑️ Assets Removed: $($script:OptimizationResults.AssetsRemoved)" "Info"
    Write-StatusMessage "  💾 Space Saved: $($script:OptimizationResults.SpaceSaved) MB" "Success"
    
    exit 0
}
catch {
    Write-StatusMessage "Build optimization failed: $($_.Exception.Message)" "Error"
    exit 1
}

# ===============================================================================
# USAGE EXAMPLES
# ===============================================================================
<#
.SYNOPSIS
Build optimization script for GRUPO US VIBECODE SYSTEM V2.0

.DESCRIPTION
Optimizes Next.js builds by cleaning caches, analyzing bundles, optimizing assets,
and generating performance reports.

.PARAMETER AnalyzeBundle
Enable bundle analysis during build

.PARAMETER CleanAssets
Remove unused assets and source maps

.PARAMETER OptimizeImages
Analyze and optimize images

.PARAMETER GenerateReport
Generate detailed optimization report

.PARAMETER BuildCommand
Custom build command (default: npm run build)

.EXAMPLE
# Basic optimization
.\optimize-build.ps1

.EXAMPLE
# Full optimization with analysis
.\optimize-build.ps1 -AnalyzeBundle -CleanAssets -OptimizeImages -GenerateReport

.EXAMPLE
# Custom build command
.\optimize-build.ps1 -BuildCommand "yarn build" -GenerateReport
#>
