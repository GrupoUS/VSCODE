# Legacy alias for finaltest-v4.ps1
# Redirects to finaltest_unified.py with V4 mode

Write-Host "FINALTEST V4.0 - LEGACY REDIRECT" -ForegroundColor Yellow
Write-Host "Redirecting to unified Python implementation..." -ForegroundColor Cyan
Write-Host "Command: python finaltest_unified.py --mode=v4 $args" -ForegroundColor Gray

python "@project-core/automation/finaltest_unified.py" --mode=v4 @args
