# MEMORY FILE ANALYSIS SCRIPT - GRUPO US VIBECODE SYSTEM V3.1
# Analyzes Augment memory file for optimization opportunities

param(
    [string]$MemoryFilePath = "C:\Users\Admin\AppData\Roaming\Code\User\workspaceStorage\f93728a73b8802154d6c1bd441b921c0\Augment.vscode-augment\Augment-Memories"
)

Write-Host "🔍 ANALYZING MEMORY FILE FOR OPTIMIZATION..." -ForegroundColor Cyan
Write-Host "File: $MemoryFilePath" -ForegroundColor Gray
Write-Host ""

# Check if file exists
if (-not (Test-Path $MemoryFilePath)) {
    Write-Host "❌ ERROR: Memory file not found!" -ForegroundColor Red
    exit 1
}

# Get file info
$fileInfo = Get-ItemProperty $MemoryFilePath
$fileSizeKB = [math]::Round($fileInfo.Length / 1024, 2)

Write-Host "📊 FILE STATISTICS:" -ForegroundColor Yellow
Write-Host "Size: $fileSizeKB KB ($($fileInfo.Length) bytes)" -ForegroundColor White

# Read content for analysis
try {
    $content = Get-Content $MemoryFilePath -ErrorAction Stop
    $totalLines = $content.Count
    
    Write-Host "Lines: $totalLines" -ForegroundColor White
    Write-Host ""
    
    # Analyze content patterns
    Write-Host "🔍 CONTENT ANALYSIS:" -ForegroundColor Yellow
    
    # Count empty lines
    $emptyLines = ($content | Where-Object { $_.Trim() -eq "" }).Count
    $emptyPercentage = [math]::Round(($emptyLines / $totalLines) * 100, 1)
    
    Write-Host "Empty lines: $emptyLines ($emptyPercentage%)" -ForegroundColor White
    
    # Count comment lines
    $commentLines = ($content | Where-Object { $_.Trim().StartsWith("#") }).Count
    $commentPercentage = [math]::Round(($commentLines / $totalLines) * 100, 1)
    
    Write-Host "Comment lines: $commentLines ($commentPercentage%)" -ForegroundColor White
    
    # Look for repetitive patterns
    $duplicateLines = $content | Group-Object | Where-Object { $_.Count -gt 1 } | Sort-Object Count -Descending
    $duplicateCount = ($duplicateLines | Measure-Object -Property Count -Sum).Sum - $duplicateLines.Count
    
    Write-Host "Duplicate lines: $duplicateCount" -ForegroundColor White
    
    # Analyze sections
    $sections = $content | Where-Object { $_.Trim().StartsWith("# ") }
    Write-Host "Sections found: $($sections.Count)" -ForegroundColor White
    
    Write-Host ""
    Write-Host "📋 OPTIMIZATION OPPORTUNITIES:" -ForegroundColor Green
    
    $optimizations = @()
    
    if ($emptyPercentage -gt 10) {
        $optimizations += "• Remove excessive empty lines ($emptyPercentage% of file)"
    }
    
    if ($duplicateCount -gt 5) {
        $optimizations += "• Consolidate $duplicateCount duplicate lines"
    }
    
    if ($fileSizeKB -gt 50) {
        $optimizations += "• File size ($fileSizeKB KB) could be optimized"
    }
    
    # Look for specific patterns that could be optimized
    $longLines = $content | Where-Object { $_.Length -gt 200 }
    if ($longLines.Count -gt 10) {
        $optimizations += "• Break down $($longLines.Count) very long lines"
    }
    
    if ($optimizations.Count -eq 0) {
        Write-Host "✅ File appears to be well optimized!" -ForegroundColor Green
    } else {
        foreach ($opt in $optimizations) {
            Write-Host $opt -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "🎯 RECOMMENDATIONS:" -ForegroundColor Magenta
    
    if ($emptyPercentage -gt 15) {
        Write-Host "• HIGH PRIORITY: Reduce empty lines" -ForegroundColor Red
    }
    
    if ($duplicateCount -gt 10) {
        Write-Host "• HIGH PRIORITY: Remove duplicates" -ForegroundColor Red
    }
    
    if ($fileSizeKB -gt 100) {
        Write-Host "• MEDIUM PRIORITY: Consider archiving old content" -ForegroundColor Yellow
    }
    
    # Calculate potential savings
    $potentialSavings = $emptyLines + $duplicateCount
    $savingsPercentage = [math]::Round(($potentialSavings / $totalLines) * 100, 1)
    
    Write-Host ""
    Write-Host "💾 POTENTIAL SAVINGS:" -ForegroundColor Cyan
    Write-Host "Lines that could be optimized: $potentialSavings ($savingsPercentage%)" -ForegroundColor White
    
    $estimatedNewSize = [math]::Round($fileSizeKB * (1 - $savingsPercentage / 100), 2)
    Write-Host "Estimated optimized size: $estimatedNewSize KB" -ForegroundColor White
    
} catch {
    Write-Host "❌ ERROR reading file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ ANALYSIS COMPLETE!" -ForegroundColor Green
