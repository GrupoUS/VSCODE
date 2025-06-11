# Script de Push Automatico
# Execute este script sempre que quiser fazer push de todos os projetos

Write-Host "=== PUSH AUTOMATICO ===" -ForegroundColor Green
Write-Host ""

$projects = @("aegiswallet", "assessoria", "taskmaster-integration", "trintae3", "extensions")

Write-Host "Iniciando push automatico..." -ForegroundColor Green

# Push do repositorio principal
Write-Host "Fazendo push do repositorio principal..." -ForegroundColor Yellow
try {
    git add .
    $hasChanges = git diff --staged --quiet; $LASTEXITCODE -ne 0
    
    if ($hasChanges) {
        git commit -m "Auto-update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git push origin main
        Write-Host "Repositorio principal atualizado!" -ForegroundColor Green
    } else {
        Write-Host "Nenhuma alteracao no repositorio principal" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Erro no repositorio principal: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Push de cada projeto
foreach ($project in $projects) {
    if (Test-Path $project) {
        Write-Host "Fazendo push de $project..." -ForegroundColor Yellow
        Set-Location $project
        
        try {
            git add .
            $hasChanges = git diff --staged --quiet; $LASTEXITCODE -ne 0
            
            if ($hasChanges) {
                git commit -m "Auto-update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
                git push origin main
                Write-Host "$project atualizado!" -ForegroundColor Green
            } else {
                Write-Host "Nenhuma alteracao em $project" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "Erro em $project`: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Set-Location ..
    } else {
        Write-Host "$project nao encontrado" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Push automatico concluido!" -ForegroundColor Green
