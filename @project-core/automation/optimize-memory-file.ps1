# MEMORY FILE OPTIMIZATION SCRIPT - GRUPO US VIBECODE SYSTEM V3.1
# Optimizes Augment memory file for better performance

param(
    [string]$MemoryFilePath = "C:\Users\Admin\AppData\Roaming\Code\User\workspaceStorage\f93728a73b8802154d6c1bd441b921c0\Augment.vscode-augment\Augment-Memories",
    [string]$BackupPath = "@project-core/memory/augment-memory-backup-optimization-$(Get-Date -Format 'yyyyMMdd-HHmmss').md",
    [switch]$DryRun = $false
)

Write-Host "🚀 MEMORY FILE OPTIMIZATION - FASE 2" -ForegroundColor Cyan
Write-Host "File: $MemoryFilePath" -ForegroundColor Gray
Write-Host "Backup: $BackupPath" -ForegroundColor Gray
Write-Host "Mode: $(if($DryRun){'DRY RUN'}else{'LIVE OPTIMIZATION'})" -ForegroundColor $(if($DryRun){'Yellow'}else{'Green'})
Write-Host ""

# Check if file exists
if (-not (Test-Path $MemoryFilePath)) {
    Write-Host "❌ ERROR: Memory file not found!" -ForegroundColor Red
    exit 1
}

# Create backup
Write-Host "📋 Creating backup..." -ForegroundColor Yellow
try {
    $originalContent = Get-Content $MemoryFilePath -Raw
    if (-not $DryRun) {
        $originalContent | Out-File -FilePath $BackupPath -Encoding UTF8
        Write-Host "✅ Backup created: $BackupPath" -ForegroundColor Green
    } else {
        Write-Host "✅ Backup would be created: $BackupPath" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ ERROR creating backup: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Read and analyze content
$content = Get-Content $MemoryFilePath
$originalLines = $content.Count
$originalSize = (Get-Item $MemoryFilePath).Length

Write-Host ""
Write-Host "📊 ORIGINAL FILE STATS:" -ForegroundColor Yellow
Write-Host "Lines: $originalLines" -ForegroundColor White
Write-Host "Size: $([math]::Round($originalSize/1024, 2)) KB" -ForegroundColor White

# Optimization patterns based on memory bank learnings
Write-Host ""
Write-Host "🔧 APPLYING OPTIMIZATIONS..." -ForegroundColor Cyan

$optimizedContent = @()
$removedLines = 0
$consolidatedSections = 0

# Pattern 1: Remove excessive empty lines (keep max 2 consecutive)
Write-Host "• Removing excessive empty lines..." -ForegroundColor Gray
$emptyLineCount = 0
foreach ($line in $content) {
    if ($line.Trim() -eq "") {
        $emptyLineCount++
        if ($emptyLineCount -le 2) {
            $optimizedContent += $line
        } else {
            $removedLines++
        }
    } else {
        $emptyLineCount = 0
        $optimizedContent += $line
    }
}

# Pattern 2: Consolidate duplicate preference entries
Write-Host "• Consolidating duplicate preferences..." -ForegroundColor Gray
$preferences = @{}
$newContent = @()
$inPreferenceSection = $false

foreach ($line in $optimizedContent) {
    if ($line.StartsWith("# ") -and $line.Contains("Development Environment")) {
        $inPreferenceSection = $true
        $newContent += $line
    } elseif ($line.StartsWith("# ") -and $inPreferenceSection) {
        $inPreferenceSection = $false
        $newContent += $line
    } elseif ($inPreferenceSection -and $line.StartsWith("- User prefers")) {
        $key = $line.Split(':')[0].Trim()
        if (-not $preferences.ContainsKey($key)) {
            $preferences[$key] = $line
            $newContent += $line
        } else {
            $removedLines++
            $consolidatedSections++
        }
    } else {
        $newContent += $line
    }
}

$optimizedContent = $newContent

# Pattern 3: Remove redundant configuration blocks
Write-Host "• Removing redundant configuration blocks..." -ForegroundColor Gray
$configBlocks = @{}
$finalContent = @()
$currentBlock = ""
$blockLines = @()

foreach ($line in $optimizedContent) {
    if ($line.StartsWith("## ") -or $line.StartsWith("### ")) {
        # Process previous block
        if ($currentBlock -ne "" -and $blockLines.Count -gt 0) {
            $blockHash = ($blockLines -join "`n").GetHashCode()
            if (-not $configBlocks.ContainsKey($blockHash)) {
                $configBlocks[$blockHash] = $true
                $finalContent += $blockLines
            } else {
                $removedLines += $blockLines.Count
                $consolidatedSections++
            }
        }
        
        # Start new block
        $currentBlock = $line
        $blockLines = @($line)
    } else {
        $blockLines += $line
    }
}

# Add final block
if ($currentBlock -ne "" -and $blockLines.Count -gt 0) {
    $blockHash = ($blockLines -join "`n").GetHashCode()
    if (-not $configBlocks.ContainsKey($blockHash)) {
        $finalContent += $blockLines
    } else {
        $removedLines += $blockLines.Count
        $consolidatedSections++
    }
}

$optimizedContent = $finalContent

# Pattern 4: Optimize long lines (break at 120 characters)
Write-Host "• Optimizing long lines..." -ForegroundColor Gray
$lineOptimizedContent = @()
foreach ($line in $optimizedContent) {
    if ($line.Length -gt 120 -and $line.StartsWith("- ")) {
        # Break long preference lines
        $words = $line.Split(' ')
        $currentLine = $words[0] + " " + $words[1]
        for ($i = 2; $i -lt $words.Count; $i++) {
            if (($currentLine + " " + $words[$i]).Length -gt 120) {
                $lineOptimizedContent += $currentLine
                $currentLine = "  " + $words[$i]
            } else {
                $currentLine += " " + $words[$i]
            }
        }
        $lineOptimizedContent += $currentLine
    } else {
        $lineOptimizedContent += $line
    }
}

$optimizedContent = $lineOptimizedContent

# Calculate results
$optimizedLines = $optimizedContent.Count
$lineReduction = $originalLines - $optimizedLines
$reductionPercentage = [math]::Round(($lineReduction / $originalLines) * 100, 1)

Write-Host ""
Write-Host "📊 OPTIMIZATION RESULTS:" -ForegroundColor Green
Write-Host "Original lines: $originalLines" -ForegroundColor White
Write-Host "Optimized lines: $optimizedLines" -ForegroundColor White
Write-Host "Lines removed: $lineReduction ($reductionPercentage%)" -ForegroundColor Yellow
Write-Host "Sections consolidated: $consolidatedSections" -ForegroundColor Yellow

# Estimate new file size
$estimatedNewSize = [math]::Round($originalSize * (1 - $reductionPercentage / 100), 2)
$sizeSavings = [math]::Round($originalSize - $estimatedNewSize, 2)

Write-Host "Estimated size reduction: $([math]::Round($sizeSavings/1024, 2)) KB" -ForegroundColor Green

# Apply changes
if (-not $DryRun) {
    Write-Host ""
    Write-Host "💾 Applying optimizations..." -ForegroundColor Cyan
    try {
        $optimizedContent | Out-File -FilePath $MemoryFilePath -Encoding UTF8
        $newSize = (Get-Item $MemoryFilePath).Length
        $actualSavings = $originalSize - $newSize
        
        Write-Host "✅ Optimization complete!" -ForegroundColor Green
        Write-Host "Actual size reduction: $([math]::Round($actualSavings/1024, 2)) KB" -ForegroundColor Green
        Write-Host "New file size: $([math]::Round($newSize/1024, 2)) KB" -ForegroundColor White
    } catch {
        Write-Host "❌ ERROR applying optimizations: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Restoring from backup..." -ForegroundColor Yellow
        $originalContent | Out-File -FilePath $MemoryFilePath -Encoding UTF8
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "✅ DRY RUN COMPLETE - No changes applied" -ForegroundColor Yellow
    Write-Host "Run without -DryRun to apply optimizations" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🎯 OPTIMIZATION SUMMARY:" -ForegroundColor Magenta
Write-Host "• Empty lines optimized" -ForegroundColor White
Write-Host "• Duplicate preferences consolidated" -ForegroundColor White
Write-Host "• Redundant blocks removed" -ForegroundColor White
Write-Host "• Long lines optimized" -ForegroundColor White
Write-Host "• Performance improved" -ForegroundColor White
