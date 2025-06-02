# Script para conectar projetos locais aos repositorios existentes no GitHub
Write-Host "=== CONECTANDO PROJETOS AOS REPOSITORIOS GITHUB ===" -ForegroundColor Green
Write-Host ""

# Credenciais
$username = "GrupoUS"
Write-Host "Usuario: $username" -ForegroundColor Yellow

# Solicitar o token de forma segura
$secureToken = Read-Host -Prompt "Insira seu Token de Acesso Pessoal do GitHub (GitHub PAT)" -AsSecureString
$token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken))

# Lista de projetos
$projects = @("aegiswallet", "assessoria", "mcp-r-task-manager", "taskmaster-integration", "trintae3", "extensions")

# Repositorios que ja existem no GitHub
$existingRepos = @("assessoria", "mcp-r-task-manager")

# Funcao para criar repositorio no GitHub
function New-GitHubRepo {
    param($repoName, $token, $username)
    
    $headers = @{
        "Authorization" = "Bearer $token"
        "Accept" = "application/vnd.github.v3+json"
        "User-Agent" = "PowerShell-Script"
    }
    
    $body = @{
        "name" = $repoName
        "description" = "Projeto $repoName - GrupoUS"
        "private" = $false
    } | ConvertTo-Json
    
    try {
        Write-Host "Criando repositorio $repoName no GitHub..." -ForegroundColor Yellow
        Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "Repositorio $repoName criado!" -ForegroundColor Green
        return $true
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "Repositorio $repoName ja existe" -ForegroundColor Yellow
            return $true
        }
        else {
            Write-Host "Erro ao criar $repoName`: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }
}

# Processar cada projeto
foreach ($project in $projects) {
    if (Test-Path $project) {
        Write-Host "Processando $project..." -ForegroundColor Blue
        
        Set-Location $project
        
        try {
            # Inicializar Git se necessario
            if (-not (Test-Path ".git")) {
                Write-Host "  Inicializando Git..." -ForegroundColor Yellow
                git init
                git branch -M main
            }
            
            # Verificar se ja existe no GitHub ou criar
            if ($existingRepos -contains $project) {
                Write-Host "  Repositorio $project ja existe no GitHub" -ForegroundColor Green
                $created = $true
            } else {
                $created = New-GitHubRepo -repoName $project -token $token -username $username
            }
            
            if ($created) {
                # Configurar remote
                $remoteUrl = "https://$($username):$($token)@github.com/$($username)/$($project).git"
                
                # Remover remote existente se houver
                try { 
                    git remote remove origin 2>$null 
                    Write-Host "  Remote anterior removido" -ForegroundColor Yellow
                } catch {}
                
                git remote add origin $remoteUrl
                Write-Host "  Remote configurado" -ForegroundColor Green
                
                # Verificar se ha arquivos para commit
                git add .
                
                # Verificar se ha mudancas para commit
                $hasChanges = $false
                try {
                    git diff --staged --quiet
                    if ($LASTEXITCODE -ne 0) { $hasChanges = $true }
                } catch {
                    $hasChanges = $true
                }
                
                if ($hasChanges) {
                    $commitMsg = "Update from local - GrupoUS $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
                    git commit -m $commitMsg
                    Write-Host "  Commit criado" -ForegroundColor Green
                } else {
                    Write-Host "  Nenhuma alteracao para commit" -ForegroundColor Yellow
                }
                
                # Push para GitHub
                Write-Host "  Fazendo push..." -ForegroundColor Yellow
                try {
                    git push -u origin main --force
                    Write-Host "  $project sincronizado com sucesso!" -ForegroundColor Green
                    Write-Host "  URL: https://github.com/$username/$project" -ForegroundColor Cyan
                } catch {
                    Write-Host "  Erro no push: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }
        catch {
            Write-Host "  Erro em $project`: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Set-Location ..
        Write-Host ""
    }
    else {
        Write-Host "$project nao encontrado" -ForegroundColor Red
    }
}

# Configurar repositorio principal se nao existir
Write-Host "Configurando repositorio principal..." -ForegroundColor Blue

$mainCreated = New-GitHubRepo -repoName "vscode-projects" -token $token -username $username

if ($mainCreated) {
    $mainRemoteUrl = "https://$($username):$($token)@github.com/$($username)/vscode-projects.git"
    
    try { git remote remove origin 2>$null } catch {}
    git remote add origin $mainRemoteUrl
    
    git add .
    
    # Verificar se ha mudancas
    $hasMainChanges = $false
    try {
        git diff --staged --quiet
        if ($LASTEXITCODE -ne 0) { $hasMainChanges = $true }
    } catch {
        $hasMainChanges = $true
    }
    
    if ($hasMainChanges) {
        git commit -m "Update VSCode Projects - GrupoUS $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git push -u origin main --force
        Write-Host "Repositorio principal sincronizado!" -ForegroundColor Green
    } else {
        Write-Host "Repositorio principal ja esta atualizado" -ForegroundColor Yellow
    }
    
    Write-Host "URL: https://github.com/$username/vscode-projects" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "CONCLUIDO!" -ForegroundColor Green
Write-Host "Projetos sincronizados:" -ForegroundColor Yellow
foreach ($project in $projects) {
    if (Test-Path $project) {
        Write-Host "  https://github.com/$username/$project" -ForegroundColor Cyan
    }
}
Write-Host "  https://github.com/$username/vscode-projects" -ForegroundColor Cyan

Write-Host ""
Write-Host "Para futuras atualizacoes, use: .\auto-push.ps1" -ForegroundColor Yellow
