# Script simplificado para sincronizar apenas repositorios existentes
Write-Host "=== SINCRONIZANDO REPOSITORIOS EXISTENTES ===" -ForegroundColor Green
Write-Host ""

# Credenciais
$username = "GrupoUS"
Write-Host "Usuario: $username" -ForegroundColor Yellow

# Solicitar o token de forma segura
$secureToken = Read-Host -Prompt "Insira seu Token de Acesso Pessoal do GitHub (GitHub PAT)" -AsSecureString
$token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken))

# Repositorios que ja existem no GitHub (confirmados)
$existingProjects = @("assessoria", "mcp-r-task-manager")

Write-Host "Sincronizando projetos existentes..." -ForegroundColor Yellow
Write-Host ""

foreach ($project in $existingProjects) {
    if (Test-Path $project) {
        Write-Host "Sincronizando $project..." -ForegroundColor Blue
        
        Set-Location $project
        
        try {
            # Configurar remote
            $remoteUrl = "https://$($username):$($token)@github.com/$($username)/$($project).git"
            
            # Remover e recriar remote
            try { git remote remove origin 2>$null } catch {}
            git remote add origin $remoteUrl
            Write-Host "  Remote configurado" -ForegroundColor Green
            
            # Adicionar arquivos
            git add .
            
            # Fazer commit se houver mudancas
            try {
                git commit -m "Sync from local - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
                Write-Host "  Commit criado" -ForegroundColor Green
            } catch {
                Write-Host "  Nenhuma mudanca para commit" -ForegroundColor Yellow
            }
            
            # Push
            Write-Host "  Fazendo push..." -ForegroundColor Yellow
            
            # Verificar branch atual e fazer push
            $currentBranch = git branch --show-current
            if ($currentBranch -eq "master") {
                git push -u origin master --force
            } else {
                git push -u origin main --force
            }
            
            Write-Host "  $project sincronizado!" -ForegroundColor Green
            Write-Host "  URL: https://github.com/$username/$project" -ForegroundColor Cyan
        }
        catch {
            Write-Host "  Erro: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        Set-Location ..
        Write-Host ""
    }
}

# Configurar repositorio principal (diretorio atual)
Write-Host "Configurando repositorio principal..." -ForegroundColor Blue

try {
    # Inicializar Git se necessario
    if (-not (Test-Path ".git")) {
        git init
        git branch -M main
    }
    
    # Tentar criar repositorio principal via GitHub CLI ou manual
    Write-Host "Para criar o repositorio principal 'vscode-projects':" -ForegroundColor Yellow
    Write-Host "1. Acesse: https://github.com/new" -ForegroundColor Cyan
    Write-Host "2. Nome: vscode-projects" -ForegroundColor Cyan
    Write-Host "3. Publico" -ForegroundColor Cyan
    Write-Host "4. Nao inicializar com README" -ForegroundColor Cyan
    Write-Host ""
    
    $createMain = Read-Host "Ja criou o repositorio vscode-projects? (s/n)"
    
    if ($createMain -eq "s" -or $createMain -eq "S") {
        $mainRemoteUrl = "https://$($username):$($token)@github.com/$($username)/vscode-projects.git"
        
        try { git remote remove origin 2>$null } catch {}
        git remote add origin $mainRemoteUrl
        
        git add .
        git commit -m "Initial commit - VSCode Projects"
        git push -u origin main --force
        
        Write-Host "Repositorio principal configurado!" -ForegroundColor Green
        Write-Host "URL: https://github.com/$username/vscode-projects" -ForegroundColor Cyan
    }
}
catch {
    Write-Host "Erro no repositorio principal: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "CONCLUIDO!" -ForegroundColor Green
Write-Host "Repositorios sincronizados:" -ForegroundColor Yellow
foreach ($project in $existingProjects) {
    Write-Host "  https://github.com/$username/$project" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Para os outros projetos (aegiswallet, taskmaster-integration, etc):" -ForegroundColor Yellow
Write-Host "1. Crie manualmente no GitHub: https://github.com/new" -ForegroundColor Cyan
Write-Host "2. Execute este script novamente adicionando-os na lista" -ForegroundColor Cyan
