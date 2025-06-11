# 🚀 VIBECODE SYSTEM V4.0 - Configuração de Sincronização Automática
# Script para configurar sincronização automática com GitHub

param(
    [switch]$Install,
    [switch]$Uninstall,
    [int]$IntervalMinutes = 30
)

$ScriptPath = Join-Path $PSScriptRoot "sync-github-auto.ps1"
$TaskName = "VIBECODE-GitHub-AutoSync"

Write-Host "🚀 VIBECODE SYSTEM V4.0 - Configuração de Sincronização Automática" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

if ($Install) {
    Write-Host "`n📋 Configurando tarefa agendada..." -ForegroundColor Yellow

    # Verificar se o script existe
    if (-not (Test-Path $ScriptPath)) {
        Write-Error "❌ Script de sincronização não encontrado: $ScriptPath"
        exit 1
    }

    # Remover tarefa existente se houver
    $existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($existingTask) {
        Write-Host "🗑️ Removendo tarefa existente..." -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    }

    # Criar nova tarefa agendada
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$ScriptPath`""
    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) -RepetitionDuration (New-TimeSpan -Days 3650)
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 1)
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Sincronização automática do VIBECODE SYSTEM V4.0 com GitHub"

    Write-Host "✅ Tarefa agendada criada com sucesso!" -ForegroundColor Green
    Write-Host "📅 Intervalo: $IntervalMinutes minutos" -ForegroundColor Green
    Write-Host "📝 Nome da tarefa: $TaskName" -ForegroundColor Green

    # Testar execução
    Write-Host "`n🧪 Testando sincronização..." -ForegroundColor Yellow
    & $ScriptPath -DryRun

    Write-Host "`n🎉 Configuração concluída!" -ForegroundColor Cyan
    Write-Host "A sincronização automática está ativa e será executada a cada $IntervalMinutes minutos." -ForegroundColor Green

} elseif ($Uninstall) {
    Write-Host "`n🗑️ Removendo sincronização automática..." -ForegroundColor Yellow

    $existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($existingTask) {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
        Write-Host "✅ Tarefa agendada removida com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "ℹ️ Nenhuma tarefa agendada encontrada" -ForegroundColor Yellow
    }

} else {
    Write-Host "`n📋 Status da Sincronização Automática" -ForegroundColor Yellow
    Write-Host "====================================" -ForegroundColor Yellow

    $existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($existingTask) {
        Write-Host "✅ Sincronização automática: ATIVA" -ForegroundColor Green
        Write-Host "📝 Nome da tarefa: $TaskName" -ForegroundColor White
        Write-Host "📅 Próxima execução: $($existingTask.Triggers[0].StartBoundary)" -ForegroundColor White
        Write-Host "🔄 Estado: $($existingTask.State)" -ForegroundColor White

        # Mostrar últimas execuções
        Write-Host "`n📊 Histórico de execuções:" -ForegroundColor Yellow
        Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TaskScheduler/Operational'; ID=201} -MaxEvents 5 -ErrorAction SilentlyContinue |
            Where-Object { $_.Message -like "*$TaskName*" } |
            ForEach-Object {
                Write-Host "   $($_.TimeCreated): $($_.LevelDisplayName)" -ForegroundColor White
            }
    } else {
        Write-Host "❌ Sincronização automática: INATIVA" -ForegroundColor Red
    }

    Write-Host "`n📖 Comandos disponíveis:" -ForegroundColor Cyan
    Write-Host "   .\setup-auto-sync.ps1 -Install              # Instalar sincronização automática" -ForegroundColor White
    Write-Host "   .\setup-auto-sync.ps1 -Install -IntervalMinutes 15  # Instalar com intervalo personalizado" -ForegroundColor White
    Write-Host "   .\setup-auto-sync.ps1 -Uninstall            # Remover sincronização automática" -ForegroundColor White
    Write-Host "   .\sync-github-auto.ps1                      # Executar sincronização manual" -ForegroundColor White
    Write-Host "   .\sync-github-auto.ps1 -DryRun              # Testar sincronização (sem executar)" -ForegroundColor White
}

Write-Host "`n=================================================================" -ForegroundColor Cyan
