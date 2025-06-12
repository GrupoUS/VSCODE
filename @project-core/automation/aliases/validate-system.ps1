# Legacy alias for validate-system.ps1
# Redirects to validation_suite.py with system mode

Write-Host "VALIDATE SYSTEM - LEGACY REDIRECT" -ForegroundColor Yellow
Write-Host "Redirecting to unified Python implementation..." -ForegroundColor Cyan
Write-Host "Command: python validation_suite.py --type=system $args" -ForegroundColor Gray

python "@project-core/automation/validation_suite.py" --type=system @args
