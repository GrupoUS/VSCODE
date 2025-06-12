# SIMPLE STRUCTURE MONITOR - GRUPO US VIBECODE SYSTEM V4.0
# Direct execution monitoring for @project-core directory structure integrity
# Created: 2025-01-10

param(
    [switch]$Detailed = $false
)

Write-Host "🔧 STRUCTURE INTEGRITY MONITOR - GRUPO US VIBECODE SYSTEM V4.0" -ForegroundColor Magenta
Write-Host ""

# Initialize monitoring log
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logPath = "@project-core/monitoring/structure-integrity-log.txt"
$logDir = Split-Path $logPath -Parent

if (!(Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

"[$timestamp] STRUCTURE INTEGRITY MONITOR - SESSION STARTED" | Out-File $logPath -Append
Write-Host "📊 Structure Integrity Monitor Initialized" -ForegroundColor Green

# Test 1: Check for nested @project-core duplicates
Write-Host "🔍 Scanning for nested @project-core duplicates..." -ForegroundColor Yellow

$violations = 0
$forbiddenPaths = @(
    "@project-core/@project-core",
    "@project-core/memory/@project-core",
    "@project-core/*/memory/@project-core"
)

foreach ($pattern in $forbiddenPaths) {
    if (Test-Path $pattern) {
        $message = "❌ CRITICAL: Nested duplicate detected at $pattern"
        Write-Host $message -ForegroundColor Red
        "[$timestamp] $message" | Out-File $logPath -Append
        $violations++
    }
}

if ($violations -eq 0) {
    Write-Host "  ✅ No nested duplicates detected" -ForegroundColor Green
    "[$timestamp] ✅ No nested duplicates detected" | Out-File $logPath -Append
}

# Test 2: Validate RAG systems location
Write-Host "🧠 Validating RAG systems location..." -ForegroundColor Yellow

$ragSystems = @(
    "@project-core/memory/native-rag-system",
    "@project-core/memory/rag-enhanced"
)

foreach ($ragSystem in $ragSystems) {
    if (!(Test-Path $ragSystem)) {
        $message = "⚠️ HIGH: RAG system missing at $ragSystem"
        Write-Host $message -ForegroundColor Red
        "[$timestamp] $message" | Out-File $logPath -Append
        $violations++
    } else {
        Write-Host "  ✅ RAG system verified: $(Split-Path $ragSystem -Leaf)" -ForegroundColor Green
        if ($Detailed) {
            "[$timestamp] ✅ RAG system verified: $ragSystem" | Out-File $logPath -Append
        }
    }
}

# Test 3: Verify critical files integrity
Write-Host "🔒 Verifying critical files integrity..." -ForegroundColor Yellow

$protectedFiles = @(
    "master_rule.md",
    "@project-core/memory/self_correction_log.md",
    "@project-core/memory/global-standards.md",
    "@project-core/rules/00-vibecode-system-v4-master.md"
)

foreach ($file in $protectedFiles) {
    if (!(Test-Path $file)) {
        $message = "❌ CRITICAL: Protected file missing at $file"
        Write-Host $message -ForegroundColor Red
        "[$timestamp] $message" | Out-File $logPath -Append
        $violations++
    } else {
        Write-Host "  ✅ Critical file verified: $(Split-Path $file -Leaf)" -ForegroundColor Green
        if ($Detailed) {
            "[$timestamp] ✅ Critical file verified: $file" | Out-File $logPath -Append
        }
    }
}

# Test 4: Validate workflow hierarchy
Write-Host "🔄 Validating workflow hierarchy integrity..." -ForegroundColor Yellow

$mcpConfig = "@project-core/configs/mcp-master-unified.json"
if (Test-Path $mcpConfig) {
    try {
        $configContent = Get-Content $mcpConfig -Raw | ConvertFrom-Json
        $requiredMCPs = @("sequential-thinking", "think-mcp-server", "mcp-shrimp-task-manager")
        $missingMCPs = @()
        
        foreach ($mcp in $requiredMCPs) {
            if (!($configContent.PSObject.Properties.Name -contains $mcp)) {
                $missingMCPs += $mcp
            }
        }
        
        if ($missingMCPs.Count -gt 0) {
            $message = "⚠️ HIGH: Workflow hierarchy incomplete - Missing: $($missingMCPs -join ', ')"
            Write-Host $message -ForegroundColor Red
            "[$timestamp] $message" | Out-File $logPath -Append
            $violations++
        } else {
            Write-Host "  ✅ Workflow hierarchy verified: Sequential Thinking → think-mcp-server → MCP Shrimp" -ForegroundColor Green
            "[$timestamp] ✅ Workflow hierarchy verified" | Out-File $logPath -Append
        }
    }
    catch {
        $message = "❌ CRITICAL: Failed to parse MCP configuration: $($_.Exception.Message)"
        Write-Host $message -ForegroundColor Red
        "[$timestamp] $message" | Out-File $logPath -Append
        $violations++
    }
} else {
    $message = "❌ CRITICAL: MCP configuration missing at $mcpConfig"
    Write-Host $message -ForegroundColor Red
    "[$timestamp] $message" | Out-File $logPath -Append
    $violations++
}

# Test 5: Check critical directories
Write-Host "📁 Analyzing directory structure health..." -ForegroundColor Yellow

$criticalDirs = @(
    "@project-core/memory",
    "@project-core/rules", 
    "@project-core/automation",
    "@project-core/configs"
)

foreach ($dir in $criticalDirs) {
    if (!(Test-Path $dir)) {
        $message = "❌ CRITICAL: Critical directory missing at $dir"
        Write-Host $message -ForegroundColor Red
        "[$timestamp] $message" | Out-File $logPath -Append
        $violations++
    } else {
        Write-Host "  ✅ Critical directory verified: $(Split-Path $dir -Leaf)" -ForegroundColor Green
        if ($Detailed) {
            "[$timestamp] ✅ Critical directory verified: $dir" | Out-File $logPath -Append
        }
    }
}

# Summary
Write-Host ""
Write-Host "📊 INTEGRITY MONITORING SUMMARY:" -ForegroundColor Green
Write-Host "  • Total checks performed: 5" -ForegroundColor White
Write-Host "  • Violations detected: $violations" -ForegroundColor $(if ($violations -eq 0) { 'Green' } else { 'Red' })

if ($violations -eq 0) {
    Write-Host "  • Status: ✅ ALL SYSTEMS HEALTHY" -ForegroundColor Green
    "[$timestamp] ✅ ALL SYSTEMS HEALTHY - No violations detected" | Out-File $logPath -Append
} else {
    Write-Host "  • Status: ⚠️ $violations VIOLATIONS DETECTED" -ForegroundColor Red
    "[$timestamp] ⚠️ $violations VIOLATIONS DETECTED" | Out-File $logPath -Append
}

Write-Host ""
Write-Host "✅ Structure integrity monitoring completed!" -ForegroundColor Green
Write-Host "📝 Log saved to: $logPath" -ForegroundColor Blue

# Return violation count for automation
exit $violations
