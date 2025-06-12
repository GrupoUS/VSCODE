# 🚀 VIBECODE SYSTEM V4.0 - Sincronização Automática GitHub
# Script para sincronização automática entre pasta local e repositório GitHub

param(
    [switch]$Force,
    [switch]$DryRun,
    [string]$Message = "🔄 Sincronização automática - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

# Configurações
$LocalPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$RemoteRepo = "https://github.com/GrupoUS/VSCODE.git"
$Branch = "clean-final"

Write-Host "🚀 VIBECODE SYSTEM V4.0 - Sincronização Automática" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Verificar se estamos na pasta correta
if (-not (Test-Path $LocalPath)) {
    Write-Error "❌ Pasta local não encontrada: $LocalPath"
    exit 1
}

Set-Location $LocalPath

# Verificar se é um repositório git
if (-not (Test-Path ".git")) {
    Write-Error "❌ Não é um repositório git válido"
    exit 1
}

Write-Host "📁 Pasta local: $LocalPath" -ForegroundColor Green
Write-Host "🌐 Repositório remoto: $RemoteRepo" -ForegroundColor Green
Write-Host "🌿 Branch: $Branch" -ForegroundColor Green

# Verificar status do git
Write-Host "`n📊 Verificando status..." -ForegroundColor Yellow
$gitStatus = git status --porcelain

if ($gitStatus) {
    Write-Host "📝 Mudanças detectadas:" -ForegroundColor Yellow
    $gitStatus | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
    
    if ($DryRun) {
        Write-Host "`n🔍 DRY RUN - Não executando mudanças" -ForegroundColor Magenta
        Write-Host "Comandos que seriam executados:" -ForegroundColor Magenta
        Write-Host "   git add ." -ForegroundColor Gray
        Write-Host "   git commit -m '$Message'" -ForegroundColor Gray
        Write-Host "   git push origin $Branch" -ForegroundColor Gray
        exit 0
    }
    
    # Adicionar arquivos
    Write-Host "`n➕ Adicionando arquivos..." -ForegroundColor Yellow
    git add .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Erro ao adicionar arquivos"
        exit 1
    }
    
    # Fazer commit
    Write-Host "💾 Fazendo commit..." -ForegroundColor Yellow
    git commit -m $Message
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Erro ao fazer commit"
        exit 1
    }
    
    # Fazer push
    Write-Host "🚀 Fazendo push para GitHub..." -ForegroundColor Yellow
    if ($Force) {
        git push origin $Branch --force-with-lease
    } else {
        git push origin $Branch
    }
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Erro ao fazer push"
        exit 1
    }
    
    Write-Host "`n✅ Sincronização concluída com sucesso!" -ForegroundColor Green
    Write-Host "🌐 Arquivos enviados para: $RemoteRepo" -ForegroundColor Green
    
} else {
    Write-Host "`n✅ Nenhuma mudança detectada - repositório já sincronizado" -ForegroundColor Green
}

# Verificar se há atualizações remotas
Write-Host "`n🔄 Verificando atualizações remotas..." -ForegroundColor Yellow
git fetch origin

$localCommit = git rev-parse HEAD
$remoteCommit = git rev-parse "origin/$Branch"

if ($localCommit -ne $remoteCommit) {
    Write-Host "📥 Atualizações remotas detectadas" -ForegroundColor Yellow
    
    if ($DryRun) {
        Write-Host "🔍 DRY RUN - Comando que seria executado:" -ForegroundColor Magenta
        Write-Host "   git pull origin $Branch" -ForegroundColor Gray
    } else {
        Write-Host "📥 Fazendo pull das atualizações..." -ForegroundColor Yellow
        git pull origin $Branch
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Atualizações baixadas com sucesso!" -ForegroundColor Green
        } else {
            Write-Warning "⚠️ Conflitos detectados - resolução manual necessária"
        }
    }
} else {
    Write-Host "✅ Repositório local está atualizado" -ForegroundColor Green
}

Write-Host "`n🎉 Sincronização automática finalizada!" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
