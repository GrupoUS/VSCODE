# OPTIMIZED MEMORY VALIDATION SCRIPT - GRUPO US VIBECODE SYSTEM V3.1
# Validates the optimized unified memory system

param(
    [string]$MemoryFilePath = "C:\Users\Admin\AppData\Roaming\Code\User\workspaceStorage\f93728a73b8802154d6c1bd441b921c0\Augment.vscode-augment\Augment-Memories",
    [string]$CursorMemoryPath = "C:\Users\Admin\AppData\Roaming\Cursor\User\workspaceStorage\e28c962abb2db4eb8c9ce0bd74aed616\Augment.vscode-augment\Augment-Memories",
    [string]$CursorSettingsPath = "C:\Users\Admin\AppData\Roaming\Cursor\User\settings.json"
)

Write-Host "🔍 VALIDATING OPTIMIZED MEMORY SYSTEM - FASE 2" -ForegroundColor Cyan
Write-Host ""

$validationResults = @()
$totalTests = 0
$passedTests = 0

# Test 1: Primary memory file exists and is accessible
$totalTests++
Write-Host "Test 1: Primary memory file accessibility..." -ForegroundColor Yellow
if (Test-Path $MemoryFilePath) {
    $fileSize = (Get-Item $MemoryFilePath).Length
    Write-Host "✅ PASS: Primary memory file exists ($([math]::Round($fileSize/1024, 2)) KB)" -ForegroundColor Green
    $validationResults += "✅ Primary memory file: ACCESSIBLE"
    $passedTests++
} else {
    Write-Host "❌ FAIL: Primary memory file not found" -ForegroundColor Red
    $validationResults += "❌ Primary memory file: NOT FOUND"
}

# Test 2: Cursor redirection file exists
$totalTests++
Write-Host "Test 2: Cursor redirection file..." -ForegroundColor Yellow
if (Test-Path $CursorMemoryPath) {
    $content = Get-Content $CursorMemoryPath -Raw
    if ($content -match "UNIFIED MEMORY SYSTEM - REDIRECTION ACTIVE") {
        Write-Host "✅ PASS: Cursor redirection active" -ForegroundColor Green
        $validationResults += "✅ Cursor redirection: ACTIVE"
        $passedTests++
    } else {
        Write-Host "❌ FAIL: Cursor redirection not configured" -ForegroundColor Red
        $validationResults += "❌ Cursor redirection: NOT CONFIGURED"
    }
} else {
    Write-Host "❌ FAIL: Cursor memory file not found" -ForegroundColor Red
    $validationResults += "❌ Cursor memory file: NOT FOUND"
}

# Test 3: Cursor settings configuration
$totalTests++
Write-Host "Test 3: Cursor settings configuration..." -ForegroundColor Yellow
if (Test-Path $CursorSettingsPath) {
    $settings = Get-Content $CursorSettingsPath -Raw
    if ($settings -match "augment\.memory\.customPath" -and $settings -match "augment\.memory\.useUnifiedMemory") {
        Write-Host "✅ PASS: Cursor settings configured for unified memory" -ForegroundColor Green
        $validationResults += "✅ Cursor settings: CONFIGURED"
        $passedTests++
    } else {
        Write-Host "❌ FAIL: Cursor settings not configured for unified memory" -ForegroundColor Red
        $validationResults += "❌ Cursor settings: NOT CONFIGURED"
    }
} else {
    Write-Host "❌ FAIL: Cursor settings file not found" -ForegroundColor Red
    $validationResults += "❌ Cursor settings: NOT FOUND"
}

# Test 4: Memory content structure validation
$totalTests++
Write-Host "Test 4: Memory content structure..." -ForegroundColor Yellow
try {
    $memoryContent = Get-Content $MemoryFilePath
    $hasPreferences = $memoryContent | Where-Object { $_ -match "Development Environment|MCP Configuration|Workflow" }
    
    if ($hasPreferences.Count -gt 0) {
        Write-Host "✅ PASS: Memory content structure is valid" -ForegroundColor Green
        $validationResults += "✅ Memory structure: VALID"
        $passedTests++
    } else {
        Write-Host "❌ FAIL: Memory content structure is invalid" -ForegroundColor Red
        $validationResults += "❌ Memory structure: INVALID"
    }
} catch {
    Write-Host "❌ FAIL: Cannot read memory content" -ForegroundColor Red
    $validationResults += "❌ Memory content: UNREADABLE"
}

# Test 5: Backup files exist
$totalTests++
Write-Host "Test 5: Backup files..." -ForegroundColor Yellow
$backupFiles = Get-ChildItem "@project-core/memory/" -Filter "*backup*" -ErrorAction SilentlyContinue
if ($backupFiles.Count -gt 0) {
    Write-Host "✅ PASS: Backup files exist ($($backupFiles.Count) found)" -ForegroundColor Green
    $validationResults += "✅ Backup files: EXIST ($($backupFiles.Count))"
    $passedTests++
} else {
    Write-Host "❌ FAIL: No backup files found" -ForegroundColor Red
    $validationResults += "❌ Backup files: NOT FOUND"
}

# Test 6: Optimization documentation
$totalTests++
Write-Host "Test 6: Optimization documentation..." -ForegroundColor Yellow
$docFiles = @(
    "@project-core/memory/unified-memory-system-configuration.md",
    "@project-core/memory/optimized-memory-structure.md",
    "@project-core/memory/memory-optimization-report.md"
)

$docCount = 0
foreach ($doc in $docFiles) {
    if (Test-Path $doc) {
        $docCount++
    }
}

if ($docCount -eq $docFiles.Count) {
    Write-Host "✅ PASS: All optimization documentation exists" -ForegroundColor Green
    $validationResults += "✅ Documentation: COMPLETE"
    $passedTests++
} else {
    Write-Host "❌ FAIL: Missing optimization documentation ($docCount/$($docFiles.Count))" -ForegroundColor Red
    $validationResults += "❌ Documentation: INCOMPLETE ($docCount/$($docFiles.Count))"
}

# Test 7: System integration check
$totalTests++
Write-Host "Test 7: System integration..." -ForegroundColor Yellow
$integrationScore = 0

# Check if memory file is not too large (performance)
$fileSize = (Get-Item $MemoryFilePath).Length
if ($fileSize -lt 50KB) {
    $integrationScore++
}

# Check if redirection is properly configured
if (Test-Path $CursorMemoryPath) {
    $redirectContent = Get-Content $CursorMemoryPath -Raw
    if ($redirectContent -match "Primary Memory Path") {
        $integrationScore++
    }
}

# Check if settings are properly configured
if (Test-Path $CursorSettingsPath) {
    $settingsContent = Get-Content $CursorSettingsPath -Raw
    if ($settingsContent -match "useUnifiedMemory.*true") {
        $integrationScore++
    }
}

if ($integrationScore -eq 3) {
    Write-Host "✅ PASS: System integration is optimal" -ForegroundColor Green
    $validationResults += "✅ System integration: OPTIMAL"
    $passedTests++
} else {
    Write-Host "⚠️ PARTIAL: System integration needs attention ($integrationScore/3)" -ForegroundColor Yellow
    $validationResults += "⚠️ System integration: PARTIAL ($integrationScore/3)"
}

# Calculate success rate
$successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)

Write-Host ""
Write-Host "📊 VALIDATION SUMMARY:" -ForegroundColor Magenta
Write-Host "Total Tests: $totalTests" -ForegroundColor White
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Failed: $($totalTests - $passedTests)" -ForegroundColor Red
Write-Host "Success Rate: $successRate%" -ForegroundColor $(if($successRate -ge 85){'Green'}elseif($successRate -ge 70){'Yellow'}else{'Red'})

Write-Host ""
Write-Host "📋 DETAILED RESULTS:" -ForegroundColor Cyan
foreach ($result in $validationResults) {
    Write-Host $result -ForegroundColor White
}

Write-Host ""
if ($successRate -ge 85) {
    Write-Host "🎉 VALIDATION SUCCESSFUL - System is optimized and ready!" -ForegroundColor Green
    Write-Host "✅ Unified memory system is functioning optimally" -ForegroundColor Green
} elseif ($successRate -ge 70) {
    Write-Host "⚠️ VALIDATION PARTIAL - Some issues need attention" -ForegroundColor Yellow
    Write-Host "🔧 Review failed tests and apply corrections" -ForegroundColor Yellow
} else {
    Write-Host "❌ VALIDATION FAILED - Critical issues detected" -ForegroundColor Red
    Write-Host "🚨 System requires immediate attention" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 NEXT STEPS:" -ForegroundColor Magenta
if ($successRate -ge 85) {
    Write-Host "• Test unified memory functionality in both VS Code and Cursor" -ForegroundColor White
    Write-Host "• Monitor performance and synchronization" -ForegroundColor White
    Write-Host "• Document any additional optimizations needed" -ForegroundColor White
} else {
    Write-Host "• Address failed validation tests" -ForegroundColor White
    Write-Host "• Verify configuration settings" -ForegroundColor White
    Write-Host "• Re-run validation after corrections" -ForegroundColor White
}

return $successRate
