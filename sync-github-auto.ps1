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

# Função para verificar se um comando existe
function Test-CommandExists {
    param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try { if (Get-Command $command) { return $true } }
    catch { return $false }
    finally { $ErrorActionPreference = $oldPreference }
}

# Função para executar validação de segurança
function Test-SecurityValidation {
    Write-Host "🔒 Executando validação de segurança..." -ForegroundColor Cyan

    # Verificar se git-secrets está instalado
    if (-not (Test-CommandExists git-secrets)) {
        Write-Host "⚠️  git-secrets não encontrado. Executando setup..." -ForegroundColor Yellow
        python setup_git_secrets.py
    }

    # Executar verificação de secrets
    $secretsCheck = git secrets --scan
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Secrets encontrados no código. Commit bloqueado." -ForegroundColor Red
        return $false
    }

    # Verificar arquivos .env
    $envFiles = git ls-files | Select-String -Pattern '\.env$' | Where-Object { $_ -notmatch '.env.example' }
    if ($envFiles) {
        Write-Host "❌ Arquivos .env encontrados no repositório:" -ForegroundColor Red
        $envFiles | ForEach-Object { Write-Host "  - $_" }
        return $false
    }

    Write-Host "✅ Validação de segurança concluída com sucesso!" -ForegroundColor Green
    return $true
}

# Função principal de sincronização
function Start-GitSync {
    Write-Host "🚀 Iniciando sincronização com GitHub..." -ForegroundColor Green

    # Verificar mudanças
    $changes = git status --porcelain
    if ($changes) {
        Write-Host "📝 Mudanças detectadas:" -ForegroundColor Yellow
        $changes | ForEach-Object { Write-Host "  $_" }

        # Executar validação de segurança
        if (-not (Test-SecurityValidation)) {
            Write-Host "❌ Sincronização cancelada devido a problemas de segurança." -ForegroundColor Red
            return
        }

        # Adicionar e commitar mudanças
        git add .
        $commitMessage = "🔄 Sync automático: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git commit -m $commitMessage

        # Push para o GitHub
        git push origin main
        Write-Host "✅ Sincronização concluída com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "✨ Nenhuma mudança detectada." -ForegroundColor Cyan
    }
}

# Executar sincronização
Start-GitSync
