# Script Final - Push Completo para GitHub com Token Correto
Write-Host "=== PUSH COMPLETO PARA GITHUB - GrupoUS ===" -ForegroundColor Green
Write-Host ""

# Credenciais
$username = "GrupoUS"
Write-Host "Usuario: $username" -ForegroundColor Yellow

# Solicitar o token de forma segura
$secureToken = Read-Host -Prompt "Insira seu Token de Acesso Pessoal do GitHub (GitHub PAT)" -AsSecureString
$tokenPlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken))

Write-Host "Validando token..." -ForegroundColor Yellow

# Validar token
try {
    if (-not [string]::IsNullOrWhiteSpace($tokenPlainText)) {
        $headers = @{"Authorization" = "Bearer $tokenPlainText"}
        $user = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers $headers
        Write-Host "Token valido! Usuario: $($user.login)" -ForegroundColor Green
    } else {
        Write-Host "Erro: Token nao pode ser vazio!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "Erro: Token invalido! $($_.Exception.ToString())" -ForegroundColor Red # Usar ToString() para mais detalhes
    exit 1
}

Write-Host ""

# Obter repositorios existentes
Write-Host "Verificando repositorios existentes..." -ForegroundColor Yellow
$existingRepos = @()
try {
    $repos = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers
    $existingRepos = $repos | ForEach-Object { $_.name }
    Write-Host "Repositorios existentes: $($existingRepos -join ', ')" -ForegroundColor Cyan
} catch {
    Write-Host "Erro ao obter repositorios existentes" -ForegroundColor Red
}

Write-Host ""

# Lista de projetos locais
$localProjects = @()
$projectDirs = Get-ChildItem -Directory | Where-Object { 
    $_.Name -notmatch "^(\.|\w+\.json|tasks|\.git)" -and 
    $_.Name -ne "cli" -and
    $_.Name -ne "github-server"
}

foreach ($dir in $projectDirs) {
    $localProjects += $dir.Name
}

Write-Host "Projetos locais encontrados: $($localProjects -join ', ')" -ForegroundColor Cyan
Write-Host ""

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
        Write-Host "  Criando repositorio $repoName no GitHub..." -ForegroundColor Yellow
        Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body -ContentType "application/json"
        Write-Host "  Repositorio $repoName criado!" -ForegroundColor Green
        return $true
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            Write-Host "  Repositorio $repoName ja existe" -ForegroundColor Yellow
            return $true
        }
        else {
            Write-Host "  Erro ao criar $repoName`: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }
}

# Processar cada projeto local
foreach ($project in $localProjects) {
    if (Test-Path $project) {
        Write-Host "Processando $project..." -ForegroundColor Blue
        
        Set-Location $project
        
        try {
            # Inicializar Git se necessario
            if (-not (Test-Path ".git")) {
                Write-Host "  Inicializando Git..." -ForegroundColor Yellow
                git init
                git branch -M main # Define o branch como main para novos repositórios
            } else {
                # Para repositórios existentes, verificar o branch atual
                $currentBranch = git rev-parse --abbrev-ref HEAD
                if ($currentBranch -ne "main") {
                    # Verificar se 'main' existe
                    $mainExists = git branch --list main | Measure-Object | Select-Object -ExpandProperty Count
                    if ($mainExists -gt 0) {
                        # Se 'main' existe e não é o atual, fazer checkout
                        Write-Host "  Fazendo checkout para branch 'main'..." -ForegroundColor Yellow
                        git checkout main
                    } else {
                        # Se 'main' não existe, renomear o branch atual para 'main'
                        Write-Host "  Branch atual e '$currentBranch'. Renomeando para 'main'..." -ForegroundColor Yellow
                        git branch -M main
                    }
                }
            }
            # Garantir que estamos no branch main e que ele tem os commits mais recentes
            git checkout main 2>$null # Ocultar erro se já estiver no main
            
            # Verificar se repositorio existe ou criar
            if ($existingRepos -contains $project) {
                Write-Host "  Repositorio $project ja existe no GitHub" -ForegroundColor Green
                $created = $true
            } else {
                # Passar tokenPlainText para a função de criação
                $created = New-GitHubRepo -repoName $project -token $tokenPlainText -username $username
            }
            
            if ($created) {
                # Configurar remote
                $remoteUrl = "https://$($username):$($tokenPlainText)@github.com/$($username)/$($project).git"
                
                # Remover remote existente se houver
                try { 
                    git remote remove origin 2>$null 
                } catch {}
                
                git remote add origin $remoteUrl
                Write-Host "  Remote configurado" -ForegroundColor Green
                
                # Adicionar arquivos
                git add .
                
                # Verificar se ha mudancas para commit
                $hasChanges = $false
                try {
                    git diff --cached --quiet
                    if ($LASTEXITCODE -ne 0) { $hasChanges = $true }
                } catch {
                    $hasChanges = $true
                }
                
                if ($hasChanges) {
                    $commitMsg = "Sync from local - GrupoUS $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
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
}

# Configurar repositorio principal (VSCODE)
Write-Host "Configurando repositorio principal VSCODE..." -ForegroundColor Blue

try {
    # Remover o diretório .git existente para limpar o histórico antigo e começar de novo
    if (Test-Path ".git") {
        Write-Host "  Removendo histórico Git local existente para o repositório VSCODE..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force ".git"
    }

    Write-Host "  Inicializando novo repositório Git para VSCODE..." -ForegroundColor Yellow
    git init
    git branch -M main
    
    $mainRemoteUrl = "https://$($username):$($tokenPlainText)@github.com/$($username)/VSCODE.git"
    git remote add origin $mainRemoteUrl
    Write-Host "  Remote configurado para VSCODE." -ForegroundColor Green
    
    git add .
    Write-Host "  Arquivos adicionados ao stage." -ForegroundColor Green
    
    # Fazer um novo commit inicial
    # Verificar se há algo para commitar, exceto se for o primeiro commit em um repo vazio
    $statusOutput = git status --porcelain
    if (-not [string]::IsNullOrWhiteSpace($statusOutput)) {
        Write-Host "  Criando novo commit inicial para VSCODE..." -ForegroundColor Yellow
        git commit -m "Initial clean commit for VSCODE project structure - GrupoUS $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        
        Write-Host "  Fazendo push forçado do novo histórico para VSCODE..." -ForegroundColor Yellow
        git push -u origin main --force
        Write-Host "Repositorio principal VSCODE sincronizado com novo histórico!" -ForegroundColor Green
    } else {
        Write-Host "  Nenhuma alteração detectada para o commit inicial do VSCODE." -ForegroundColor Yellow
        # Mesmo sem alterações locais, pode ser necessário forçar um push vazio se o remoto estiver diferente
        Write-Host "  Tentando push para garantir que o remoto está alinhado (pode falhar se o remoto não existir ou estiver vazio)..." -ForegroundColor Yellow
        git push -u origin main --force
    }
    
    Write-Host "URL: https://github.com/$username/VSCODE" -ForegroundColor Cyan
}
catch {
    Write-Host "Erro no repositorio principal VSCODE: $($_.Exception.ToString())" -ForegroundColor Red
}

Write-Host ""
Write-Host "CONCLUIDO!" -ForegroundColor Green
Write-Host "Projetos sincronizados:" -ForegroundColor Yellow
foreach ($project in $localProjects) {
    if (Test-Path $project) {
        Write-Host "  https://github.com/$username/$project" -ForegroundColor Cyan
    }
}
Write-Host "  https://github.com/$username/VSCODE (repositorio principal)" -ForegroundColor Cyan

Write-Host ""
Write-Host "Para futuras atualizacoes, use: .\auto-sync.ps1" -ForegroundColor Yellow
