# Script de Sincronização Automática - GrupoUS
# Executa push automático para todos os repositórios

param(
    [string]$Message = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
)

Write-Host "=== SINCRONIZAÇÃO AUTOMÁTICA - GrupoUS ===" -ForegroundColor Green
Write-Host "Mensagem do commit: $Message" -ForegroundColor Yellow

# Lista de projetos para sincronizar
$projects = @(
    "aegiswallet",
    "assessoria", 
    "extensions",
    "harmoniza-facil-agendas",
    "neonpro",
    "taskmaster-integration",
    "trintae3",
    "trintae3-1"
)

$successCount = 0
$failCount = 0

foreach ($project in $projects) {
    if (Test-Path $project) {
        Write-Host "`nProcessando $project..." -ForegroundColor Cyan
        
        Push-Location $project
        try {
            # Verifica se há alterações
            $status = git status --porcelain
            
            if ($status) {
                Write-Host "  Alterações detectadas, fazendo commit..." -ForegroundColor Yellow
                git add .
                git commit -m $Message
                git push origin main
                Write-Host "  ✅ $project sincronizado!" -ForegroundColor Green
            } else {
                Write-Host "  ℹ️ Nenhuma alteração em $project" -ForegroundColor Gray
            }
            $successCount++
        }
        catch {
            Write-Host "  ❌ Erro ao sincronizar $project`: $_" -ForegroundColor Red
            $failCount++
        }
        finally {
            Pop-Location
        }
    } else {
        Write-Host "❌ Projeto $project não encontrado" -ForegroundColor Red
        $failCount++
    }
}

# Sincronizar repositório principal VSCODE
Write-Host "`nSincronizando repositório principal VSCODE..." -ForegroundColor Cyan
try {
    $status = git status --porcelain
    if ($status) {
        git add .
        git commit -m "Auto-sync VSCODE: $Message"
        git push origin main
        Write-Host "✅ Repositório principal VSCODE sincronizado!" -ForegroundColor Green
    } else {
        Write-Host "ℹ️ Nenhuma alteração no repositório principal" -ForegroundColor Gray
    }
    $successCount++
}
catch {
    Write-Host "❌ Erro ao sincronizar repositório principal: $_" -ForegroundColor Red
    $failCount++
}

Write-Host "`n=== RESUMO ===" -ForegroundColor Green
Write-Host "Sucessos: $successCount" -ForegroundColor Green
Write-Host "Falhas: $failCount" -ForegroundColor Red

if ($failCount -eq 0) {
    Write-Host "`n🎉 Todos os repositórios foram sincronizados com sucesso!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ Alguns repositórios apresentaram problemas. Verifique os logs acima." -ForegroundColor Yellow
}
