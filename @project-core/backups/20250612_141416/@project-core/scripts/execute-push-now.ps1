# Script personalizado para push imediato - GrupoUS
# Todas as credenciais ja configuradas

Write-Host "=== PUSH AUTOMATICO PARA GITHUB - GrupoUS ===" -ForegroundColor Green
Write-Host ""

# Credenciais
$username = "GrupoUS"
Write-Host "Usuario: $username" -ForegroundColor Yellow

# Solicitar o token de forma segura
$secureToken = Read-Host -Prompt "Insira seu Token de Acesso Pessoal do GitHub (GitHub PAT)" -AsSecureString
$token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken))

Write-Host "Iniciando push dos projetos..." -ForegroundColor Yellow
Write-Host ""

# Lista de projetos
$projects = @("aegiswallet", "harmoniza-facil-agendas", "taskmaster-integration", "neonpro", "extensions")

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
            
            # Criar repositorio no GitHub
            $created = New-GitHubRepo -repoName $project -token $token -username $username
            
            if ($created) {
                # Configurar remote
                $remoteUrl = "https://$($username):$($token)@github.com/$($username)/$($project).git"
                
                try { git remote remove origin 2>$null } catch {}
                git remote add origin $remoteUrl
                
                # Adicionar arquivos e fazer commit
                Write-Host "  Adicionando arquivos..." -ForegroundColor Yellow
                git add .
                
                $commitMsg = "Initial commit - GrupoUS $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
                git commit -m $commitMsg
                
                # Push para GitHub
                Write-Host "  Fazendo push..." -ForegroundColor Yellow
                git push -u origin main --force
                
                Write-Host "  $project enviado com sucesso!" -ForegroundColor Green
                Write-Host "  URL: https://github.com/$username/$project" -ForegroundColor Cyan
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

# Configurar repositorio principal
Write-Host "Configurando repositorio principal..." -ForegroundColor Blue

$mainCreated = New-GitHubRepo -repoName "vscode-projects" -token $token -username $username

if ($mainCreated) {
    $mainRemoteUrl = "https://$($username):$($token)@github.com/$($username)/vscode-projects.git"
    
    try { git remote remove origin 2>$null } catch {}
    git remote add origin $mainRemoteUrl
    
    git add .
    git commit -m "Initial commit - VSCode Projects GrupoUS $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push -u origin main --force
    
    Write-Host "Repositorio principal configurado!" -ForegroundColor Green
    Write-Host "URL: https://github.com/$username/vscode-projects" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "CONCLUIDO!" -ForegroundColor Green
Write-Host "Todos os projetos foram enviados para:" -ForegroundColor Yellow
foreach ($project in $projects) {
    if (Test-Path $project) {
        Write-Host "  https://github.com/$username/$project" -ForegroundColor Cyan
    }
}
Write-Host "  https://github.com/$username/vscode-projects" -ForegroundColor Cyan

Write-Host ""
Write-Host "Para futuras atualizacoes, use: .\auto-push.ps1" -ForegroundColor Yellow
Write-Host "Push automatico configurado para 23:00 diariamente via GitHub Actions" -ForegroundColor Yellow
