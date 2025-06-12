# SIMPLE VALIDATION TEST - GRUPO US VIBECODE SYSTEM V3.1
# Quick validation of unified memory system

Write-Host "🔍 UNIFIED MEMORY SYSTEM VALIDATION" -ForegroundColor Cyan
Write-Host ""

$results = @()

# Test 1: VS Code Memory File
Write-Host "Test 1: VS Code Memory File..." -ForegroundColor Yellow
$vscodeFile = "C:\Users\Admin\AppData\Roaming\Code\User\workspaceStorage\f93728a73b8802154d6c1bd441b921c0\Augment.vscode-augment\Augment-Memories"
if (Test-Path $vscodeFile) {
    $size = (Get-Item $vscodeFile).Length
    Write-Host "✅ PASS: VS Code memory file accessible ($([math]::Round($size/1024, 2)) KB)" -ForegroundColor Green
    $results += "✅ VS Code Memory: ACCESSIBLE"
} else {
    Write-Host "❌ FAIL: VS Code memory file not found" -ForegroundColor Red
    $results += "❌ VS Code Memory: NOT FOUND"
}

# Test 2: Cursor Memory File
Write-Host "Test 2: Cursor Memory File..." -ForegroundColor Yellow
$cursorFile = "C:\Users\Admin\AppData\Roaming\Cursor\User\workspaceStorage\e28c962abb2db4eb8c9ce0bd74aed616\Augment.vscode-augment\Augment-Memories"
if (Test-Path $cursorFile) {
    $content = Get-Content $cursorFile -Raw
    if ($content -match "UNIFIED MEMORY SYSTEM - REDIRECTION ACTIVE") {
        Write-Host "✅ PASS: Cursor redirection active" -ForegroundColor Green
        $results += "✅ Cursor Redirection: ACTIVE"
    } else {
        Write-Host "⚠️ WARNING: Cursor file exists but redirection not detected" -ForegroundColor Yellow
        $results += "⚠️ Cursor Redirection: PARTIAL"
    }
} else {
    Write-Host "❌ FAIL: Cursor memory file not found" -ForegroundColor Red
    $results += "❌ Cursor Memory: NOT FOUND"
}

# Test 3: Cursor Settings
Write-Host "Test 3: Cursor Settings..." -ForegroundColor Yellow
$settingsFile = "C:\Users\Admin\AppData\Roaming\Cursor\User\settings.json"
if (Test-Path $settingsFile) {
    $settings = Get-Content $settingsFile -Raw
    if ($settings -match "augment\.memory\.customPath" -and $settings -match "augment\.memory\.useUnifiedMemory") {
        Write-Host "✅ PASS: Cursor settings configured for unified memory" -ForegroundColor Green
        $results += "✅ Cursor Settings: CONFIGURED"
    } else {
        Write-Host "❌ FAIL: Cursor settings not configured for unified memory" -ForegroundColor Red
        $results += "❌ Cursor Settings: NOT CONFIGURED"
    }
} else {
    Write-Host "❌ FAIL: Cursor settings file not found" -ForegroundColor Red
    $results += "❌ Cursor Settings: NOT FOUND"
}

# Test 4: Documentation Files
Write-Host "Test 4: Documentation Files..." -ForegroundColor Yellow
$docFiles = @(
    "@project-core/memory/unified-memory-system-configuration.md",
    "@project-core/memory/memory-optimization-report.md",
    "@project-core/memory/optimized-memory-structure.md"
)

$docCount = 0
foreach ($doc in $docFiles) {
    if (Test-Path $doc) {
        $docCount++
    }
}

if ($docCount -eq $docFiles.Count) {
    Write-Host "✅ PASS: All documentation files exist ($docCount/$($docFiles.Count))" -ForegroundColor Green
    $results += "✅ Documentation: COMPLETE"
} else {
    Write-Host "⚠️ WARNING: Some documentation missing ($docCount/$($docFiles.Count))" -ForegroundColor Yellow
    $results += "⚠️ Documentation: PARTIAL ($docCount/$($docFiles.Count))"
}

# Test 5: Backup Files
Write-Host "Test 5: Backup Files..." -ForegroundColor Yellow
$backupFiles = Get-ChildItem "@project-core/memory/" -Filter "*backup*" -ErrorAction SilentlyContinue
if ($backupFiles.Count -gt 0) {
    Write-Host "✅ PASS: Backup files exist ($($backupFiles.Count) found)" -ForegroundColor Green
    $results += "✅ Backup Files: EXIST ($($backupFiles.Count))"
} else {
    Write-Host "❌ FAIL: No backup files found" -ForegroundColor Red
    $results += "❌ Backup Files: NOT FOUND"
}

# Calculate success rate
$passedTests = ($results | Where-Object { $_ -match "✅" }).Count
$totalTests = $results.Count
$successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)

Write-Host ""
Write-Host "📊 VALIDATION SUMMARY:" -ForegroundColor Magenta
Write-Host "Total Tests: $totalTests" -ForegroundColor White
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Success Rate: $successRate%" -ForegroundColor $(if($successRate -ge 80){'Green'}elseif($successRate -ge 60){'Yellow'}else{'Red'})

Write-Host ""
Write-Host "📋 DETAILED RESULTS:" -ForegroundColor Cyan
foreach ($result in $results) {
    Write-Host $result -ForegroundColor White
}

Write-Host ""
if ($successRate -ge 80) {
    Write-Host "🎉 VALIDATION SUCCESSFUL - System ready for real-world testing!" -ForegroundColor Green
} elseif ($successRate -ge 60) {
    Write-Host "⚠️ VALIDATION PARTIAL - Some issues need attention" -ForegroundColor Yellow
} else {
    Write-Host "❌ VALIDATION FAILED - Critical issues detected" -ForegroundColor Red
}

Write-Host ""
Write-Host "✅ VALIDATION COMPLETE!" -ForegroundColor Green
