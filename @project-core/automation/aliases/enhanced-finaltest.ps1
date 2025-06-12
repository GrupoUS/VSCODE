# Legacy alias for enhanced-finaltest.ps1
# Redirects to finaltest_unified.py with enhanced mode

Write-Host "ENHANCED FINALTEST - LEGACY REDIRECT" -ForegroundColor Yellow
Write-Host "Redirecting to unified Python implementation..." -ForegroundColor Cyan
Write-Host "Command: python finaltest_unified.py --mode=enhanced $args" -ForegroundColor Gray

python "@project-core/automation/finaltest_unified.py" --mode=enhanced @args
