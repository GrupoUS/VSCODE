# Script de teste para verificar configuracao do Git
Write-Host "=== TESTE DE CONFIGURACAO GIT ===" -ForegroundColor Green
Write-Host ""

# Verificar se Git esta instalado
try {
    $gitVersion = git --version
    Write-Host "Git instalado: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "Git nao encontrado. Instale o Git primeiro!" -ForegroundColor Red
    exit 1
}

# Verificar configuracao do usuario
$userName = git config --global user.name
$userEmail = git config --global user.email

Write-Host "Nome configurado: $userName" -ForegroundColor Yellow
Write-Host "Email configurado: $userEmail" -ForegroundColor Yellow

if ($userEmail -eq "you@example.com" -or $userEmail -eq "") {
    Write-Host "Email precisa ser configurado!" -ForegroundColor Red
    $newEmail = Read-Host "Digite seu email do GitHub"
    git config --global user.email $newEmail
    Write-Host "Email configurado: $newEmail" -ForegroundColor Green
}

# Verificar status do repositorio atual
Write-Host ""
Write-Host "Status do repositorio atual:" -ForegroundColor Blue
git status --short

Write-Host ""
Write-Host "Remotes configurados:" -ForegroundColor Blue
try {
    git remote -v
} catch {
    Write-Host "Nenhum remote configurado ainda" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Projetos encontrados:" -ForegroundColor Blue
$projects = @("aegiswallet", "assessoria", "mcp-r-task-manager", "taskmaster-integration", "trintae3", "extensions", "github-server")

foreach ($project in $projects) {
    if (Test-Path $project) {
        Write-Host "  $project" -ForegroundColor Green
        
        # Verificar se e um repositorio Git
        if (Test-Path "$project\.git") {
            Write-Host "    Git inicializado" -ForegroundColor Cyan
        } else {
            Write-Host "    Git nao inicializado" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  $project (nao encontrado)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Proximos passos:" -ForegroundColor Yellow
Write-Host "1. Crie um Personal Access Token no GitHub" -ForegroundColor Cyan
Write-Host "2. Execute: .\push-all-projects.ps1" -ForegroundColor Cyan
Write-Host "3. Siga as instrucoes do script" -ForegroundColor Cyan
