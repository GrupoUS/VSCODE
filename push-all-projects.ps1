# Script para fazer push de todos os projetos para GitHub
# Autor: Mauricio
# Data: 01/06/2025

Write-Host "=== SCRIPT DE PUSH AUTOMÁTICO PARA GITHUB ===" -ForegroundColor Green
Write-Host ""

# Configurar email do Git (substitua pelo seu email real)
$email = Read-Host "Digite seu email do GitHub"
git config --global user.email $email

# Configurar token do GitHub (necessário para criar repositórios)
$token = Read-Host "Digite seu token do GitHub (Personal Access Token)" -AsSecureString
$tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

# Seu username do GitHub
$username = Read-Host "Digite seu username do GitHub"

# Lista de projetos para fazer push
$projects = @(
    "aegiswallet",
    "assessoria", 
    "mcp-r-task-manager",
    "taskmaster-integration",
    "trintae3",
    "extensions",
    "github-server"
)

Write-Host "Projetos identificados:" -ForegroundColor Yellow
$projects | ForEach-Object { Write-Host "  - $_" -ForegroundColor Cyan }
Write-Host ""

# Função para criar repositório no GitHub via API
function Create-GitHubRepo {
    param($repoName, $token, $username)
    
    $headers = @{
        "Authorization" = "token $token"
        "Accept" = "application/vnd.github.v3+json"
    }
    
    $body = @{
        "name" = $repoName
        "description" = "Projeto $repoName - Auto-criado via script"
        "private" = $false
        "auto_init" = $false
    } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "✅ Repositório '$repoName' criado com sucesso!" -ForegroundColor Green
        return $true
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "⚠️  Repositório '$repoName' já existe" -ForegroundColor Yellow
            return $true
        }
        else {
            Write-Host "❌ Erro ao criar repositório '$repoName': $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }
}

# Função para processar cada projeto
function Process-Project {
    param($projectName, $username, $token)
    
    Write-Host "🔄 Processando projeto: $projectName" -ForegroundColor Blue
    
    # Verificar se o diretório existe
    if (-not (Test-Path $projectName)) {
        Write-Host "❌ Diretório '$projectName' não encontrado" -ForegroundColor Red
        return
    }
    
    # Entrar no diretório do projeto
    Set-Location $projectName
    
    try {
        # Verificar se já é um repositório Git
        if (-not (Test-Path ".git")) {
            Write-Host "  📁 Inicializando repositório Git..." -ForegroundColor Yellow
            git init
            git branch -M main
        }
        
        # Criar repositório no GitHub
        $repoCreated = Create-GitHubRepo -repoName $projectName -token $token -username $username
        
        if ($repoCreated) {
            # Configurar remote origin
            $remoteUrl = "https://github.com/$username/$projectName.git"
            
            # Remover origin existente se houver
            try {
                git remote remove origin 2>$null
            } catch {}
            
            git remote add origin $remoteUrl
            
            # Adicionar todos os arquivos
            Write-Host "  📦 Adicionando arquivos..." -ForegroundColor Yellow
            git add .
            
            # Fazer commit
            $commitMessage = "Initial commit - Auto-push $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            git commit -m $commitMessage
            
            # Push para GitHub
            Write-Host "  🚀 Fazendo push para GitHub..." -ForegroundColor Yellow
            git push -u origin main --force
            
            Write-Host "  ✅ Push concluído para $projectName!" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "  ❌ Erro ao processar $projectName`: $($_.Exception.Message)" -ForegroundColor Red
    }
    finally {
        # Voltar ao diretório principal
        Set-Location ..
    }
    
    Write-Host ""
}

# Processar cada projeto
foreach ($project in $projects) {
    Process-Project -projectName $project -username $username -token $tokenPlain
}

# Configurar push automático para o repositório principal
Write-Host "🔄 Configurando repositório principal..." -ForegroundColor Blue

# Criar repositório principal no GitHub
$mainRepoCreated = Create-GitHubRepo -repoName "vscode-projects" -token $tokenPlain -username $username

if ($mainRepoCreated) {
    # Configurar repositório principal
    $mainRemoteUrl = "https://github.com/$username/vscode-projects.git"
    
    try {
        git remote remove origin 2>$null
    } catch {}
    
    git remote add origin $mainRemoteUrl
    git add .
    git commit -m "Initial commit - VSCode Projects Collection $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git push -u origin main --force
    
    Write-Host "✅ Repositório principal configurado!" -ForegroundColor Green
}

# Criar script de push automático
Write-Host "🔧 Criando script de push automático..." -ForegroundColor Blue

$autoPushScript = @"
# Script de Push Automático
# Execute este script sempre que quiser fazer push de todos os projetos

`$projects = @("aegiswallet", "assessoria", "mcp-r-task-manager", "taskmaster-integration", "trintae3", "extensions", "github-server")

Write-Host "🚀 Iniciando push automático..." -ForegroundColor Green

# Push do repositório principal
Write-Host "📦 Fazendo push do repositório principal..." -ForegroundColor Yellow
git add .
git commit -m "Auto-update `$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git push origin main

# Push de cada projeto
foreach (`$project in `$projects) {
    if (Test-Path `$project) {
        Write-Host "📦 Fazendo push de `$project..." -ForegroundColor Yellow
        Set-Location `$project
        git add .
        git commit -m "Auto-update `$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git push origin main
        Set-Location ..
        Write-Host "✅ `$project atualizado!" -ForegroundColor Green
    }
}

Write-Host "🎉 Todos os projetos foram atualizados!" -ForegroundColor Green
"@

$autoPushScript | Out-File -FilePath "auto-push.ps1" -Encoding UTF8

Write-Host "✅ Script de push automático criado: auto-push.ps1" -ForegroundColor Green

# Criar GitHub Action para push automático
Write-Host "🔧 Criando GitHub Action para push automático..." -ForegroundColor Blue

$githubActionDir = ".github/workflows"
if (-not (Test-Path $githubActionDir)) {
    New-Item -ItemType Directory -Path $githubActionDir -Force
}

$githubAction = @"
name: Auto Push All Projects

on:
  push:
    branches: [ main ]
  schedule:
    # Executa todo dia às 02:00 UTC (23:00 BRT)
    - cron: '0 2 * * *'
  workflow_dispatch:

jobs:
  auto-push:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 0
        token: `${{ secrets.GITHUB_TOKEN }}
    
    - name: Configure Git
      run: |
        git config --global user.name "Mauricio"
        git config --global user.email "$email"
    
    - name: Auto commit and push
      run: |
        git add .
        git diff --staged --quiet || git commit -m "Auto-update `$(date +'%Y-%m-%d %H:%M:%S')"
        git push origin main
"@

$githubAction | Out-File -FilePath "$githubActionDir/auto-push.yml" -Encoding UTF8

Write-Host "✅ GitHub Action criada: .github/workflows/auto-push.yml" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 CONFIGURAÇÃO CONCLUÍDA!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 RESUMO:" -ForegroundColor Yellow
Write-Host "  ✅ Todos os projetos foram enviados para o GitHub" -ForegroundColor Green
Write-Host "  ✅ Script de push automático criado (auto-push.ps1)" -ForegroundColor Green
Write-Host "  ✅ GitHub Action configurada para push automático diário" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "  1. Execute 'auto-push.ps1' sempre que quiser fazer push de todos os projetos" -ForegroundColor Cyan
Write-Host "  2. O GitHub Action fará push automático todo dia às 23:00 (BRT)" -ForegroundColor Cyan
Write-Host "  3. Você pode executar o push manual no GitHub em Actions > Auto Push All Projects" -ForegroundColor Cyan
Write-Host ""
