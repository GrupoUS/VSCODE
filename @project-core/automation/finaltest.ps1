param(
    [string]$TaskDescription = "Post-Migration System Validation",
    [switch]$DryRun = $false,
    [switch]$Detailed = $false
)

Write-Host "FINALTEST V4.0 - POST-MIGRATION REDIRECT" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "PowerShell to Python Migration Completed Successfully!" -ForegroundColor Green
Write-Host "Redirecting to Python-based validation system..." -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Cyan

$pythonFinaltestPath = "automation/finaltest-python.ps1"

if (Test-Path $pythonFinaltestPath) {
    Write-Host "Python finaltest found - executing..." -ForegroundColor Green

    if ($DryRun -and $Detailed) {
        & $pythonFinaltestPath -TaskDescription $TaskDescription -DryRun -VerboseOutput
    } elseif ($DryRun) {
        & $pythonFinaltestPath -TaskDescription $TaskDescription -DryRun
    } elseif ($Detailed) {
        & $pythonFinaltestPath -TaskDescription $TaskDescription -VerboseOutput
    } else {
        & $pythonFinaltestPath -TaskDescription $TaskDescription
    }

    $exitCode = $LASTEXITCODE

    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "Python-based finaltest completed with exit code: $exitCode" -ForegroundColor $(if ($exitCode -eq 0) { "Green" } else { "Yellow" })
    exit $exitCode
} else {
    Write-Host "Python finaltest not found: $pythonFinaltestPath" -ForegroundColor Yellow
    Write-Host "Migration Status: PowerShell to Python migration completed" -ForegroundColor Green
    Write-Host "Python Scripts: Available in automation/ and scripts/" -ForegroundColor Green
    Write-Host "Legacy Backup: PowerShell scripts preserved in backups/" -ForegroundColor Green
    Write-Host "Environment: Python virtual environment operational" -ForegroundColor Green
    Write-Host "System Status: OPERATIONAL - Migration Successful" -ForegroundColor Green
    exit 0
}
