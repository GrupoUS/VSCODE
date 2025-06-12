# VIBECODE SYSTEM V4.0 - Virtual Environment Activator
# Gerado automaticamente

$VenvPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE\@project-core\venv"
$ActivateScript = "$VenvPath\Scripts\Activate.ps1"

if (Test-Path $ActivateScript) {
    Write-Host "🐍 Ativando ambiente virtual VIBECODE..." -ForegroundColor Green
    & $ActivateScript
    Write-Host "✅ Ambiente virtual ativado!" -ForegroundColor Green
} else {
    Write-Host "❌ Ambiente virtual não encontrado em: $VenvPath" -ForegroundColor Red
    Write-Host "Execute: python @project-core/automation/tasks/activate_venv.py" -ForegroundColor Yellow
}
