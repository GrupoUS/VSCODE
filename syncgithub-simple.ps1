# VIBECODE SYSTEM V4.0 - Sincronizacao Multi-Projetos GitHub (Versao Simplificada)
# Script para sincronizacao automatica de multiplos projetos

param(
    [switch]$Force,
    [switch]$DryRun,
    [string]$ProjectName = "",
    [switch]$All,
    [string]$Message = ""
)

# Configuracoes base
$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"

Write-Host "VIBECODE SYSTEM V4.0 - Sincronizacao Multi-Projetos" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# Configuracao dos projetos
$projects = @{
    "neonpro" = @{
        name = "NeonPro"
        localPath = "@project-core\projects\neonpro"
        repositoryUrl = "https://github.com/GrupoUS/neonpro.git"
        branch = "main"
    }
    "aegiswallet" = @{
        name = "AegisWallet"
        localPath = "@project-core\projects\aegiswallet"
        repositoryUrl = "https://github.com/GrupoUS/aegiswallet.git"
        branch = "main"
    }
    "agendatrintae3" = @{
        name = "AgendaTrintaE3"
        localPath = "@project-core\projects\agendatrintae3"
        repositoryUrl = "https://github.com/GrupoUS/agendatrintae3.git"
        branch = "main"
    }
}

# Funcao para sincronizar um projeto
function Sync-Project {
    param(
        [hashtable]$ProjectConfig,
        [string]$ProjectKey
    )
    
    Write-Host "`nSINCRONIZANDO PROJETO: $($ProjectConfig.name)" -ForegroundColor Magenta
    Write-Host "=" * 50 -ForegroundColor Gray
    
    $projectPath = Join-Path $SystemRootPath $ProjectConfig.localPath
    $originalLocation = Get-Location
    
    try {
        # Verificar se o projeto existe
        if (-not (Test-Path $projectPath)) {
            Write-Host "ERRO: Projeto nao encontrado: $projectPath" -ForegroundColor Red
            return $false
        }
        
        # Navegar para a pasta do projeto
        Set-Location $projectPath
        Write-Host "Pasta do projeto: $projectPath" -ForegroundColor Green
        
        # Verificar se e um repositorio git
        if (-not (Test-Path ".git")) {
            Write-Host "Inicializando repositorio Git..." -ForegroundColor Yellow
            git init
            git remote add origin $ProjectConfig.repositoryUrl
        }
        
        # Verificar remote
        $currentRemote = git remote get-url origin 2>$null
        if ($currentRemote -ne $ProjectConfig.repositoryUrl) {
            Write-Host "Atualizando remote URL..." -ForegroundColor Yellow
            git remote set-url origin $ProjectConfig.repositoryUrl
        }
        
        Write-Host "Repositorio: $($ProjectConfig.repositoryUrl)" -ForegroundColor Green
        Write-Host "Branch: $($ProjectConfig.branch)" -ForegroundColor Green
        
        # Verificar status do git
        Write-Host "`nVerificando status..." -ForegroundColor Yellow
        $gitStatus = git status --porcelain
        
        if ($gitStatus) {
            Write-Host "Mudancas detectadas:" -ForegroundColor Yellow
            $gitStatus | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
            
            if ($DryRun) {
                Write-Host "`nDRY RUN - Comandos que seriam executados:" -ForegroundColor Magenta
                Write-Host "   git add ." -ForegroundColor Gray
                Write-Host "   git commit -m '...'" -ForegroundColor Gray
                Write-Host "   git push origin $($ProjectConfig.branch)" -ForegroundColor Gray
                return $true
            }
            
            # Preparar mensagem de commit
            $commitMessage = if ($Message) { 
                $Message 
            } else { 
                "[$ProjectKey] Sincronizacao automatica - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 
            }
            
            # Adicionar arquivos
            Write-Host "`nAdicionando arquivos..." -ForegroundColor Yellow
            git add .
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "ERRO ao adicionar arquivos" -ForegroundColor Red
                return $false
            }
            
            # Fazer commit
            Write-Host "Fazendo commit..." -ForegroundColor Yellow
            git commit -m $commitMessage
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "ERRO ao fazer commit" -ForegroundColor Red
                return $false
            }
            
            # Fazer push
            Write-Host "Fazendo push para GitHub..." -ForegroundColor Yellow
            if ($Force) {
                git push origin $ProjectConfig.branch --force-with-lease
            } else {
                git push origin $ProjectConfig.branch
            }
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "ERRO ao fazer push" -ForegroundColor Red
                return $false
            }
            
            Write-Host "SUCESSO: Projeto $($ProjectConfig.name) sincronizado!" -ForegroundColor Green
            return $true
            
        } else {
            Write-Host "Nenhuma mudanca detectada - projeto ja sincronizado" -ForegroundColor Green
            return $true
        }
        
    }
    catch {
        Write-Host "ERRO na sincronizacao: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        Set-Location $originalLocation
    }
}

# Determinar quais projetos sincronizar
$projectsToSync = @()

if ($ProjectName) {
    # Sincronizar projeto especifico
    if ($projects.ContainsKey($ProjectName)) {
        $projectsToSync += @{ Key = $ProjectName; Config = $projects[$ProjectName] }
        Write-Host "Modo Projeto Especifico: $ProjectName" -ForegroundColor Magenta
    } else {
        Write-Host "ERRO: Projeto '$ProjectName' nao encontrado" -ForegroundColor Red
        Write-Host "Projetos disponiveis:" -ForegroundColor Yellow
        $projects.Keys | ForEach-Object { 
            Write-Host "   - $_" -ForegroundColor White 
        }
        exit 1
    }
} elseif ($All) {
    # Sincronizar todos os projetos
    Write-Host "Modo Todos os Projetos" -ForegroundColor Magenta
    $projects.GetEnumerator() | ForEach-Object {
        $projectsToSync += @{ Key = $_.Key; Config = $_.Value }
    }
} else {
    Write-Host "Especifique um projeto (-ProjectName) ou use -All para todos os projetos" -ForegroundColor Yellow
    Write-Host "Projetos disponiveis:" -ForegroundColor Yellow
    $projects.Keys | ForEach-Object { 
        Write-Host "   - $_" -ForegroundColor White 
    }
    exit 1
}

# Executar sincronizacao
$results = @()
$totalProjects = $projectsToSync.Count
$currentProject = 0

Write-Host "`nINICIANDO SINCRONIZACAO DE $totalProjects PROJETO(S)..." -ForegroundColor Cyan

foreach ($project in $projectsToSync) {
    $currentProject++
    Write-Host "`n[$currentProject/$totalProjects]" -ForegroundColor Gray
    
    $success = Sync-Project -ProjectConfig $project.Config -ProjectKey $project.Key
    $results += @{
        Project = $project.Key
        Name = $project.Config.name
        Success = $success
    }
}

# Relatorio final
Write-Host "`n" + "=" * 60 -ForegroundColor Cyan
Write-Host "RELATORIO DE SINCRONIZACAO" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

$successful = ($results | Where-Object { $_.Success }).Count
$failed = ($results | Where-Object { -not $_.Success }).Count

Write-Host "Sucessos: $successful" -ForegroundColor Green
Write-Host "Falhas: $failed" -ForegroundColor Red

foreach ($result in $results) {
    $status = if ($result.Success) { "SUCESSO" } else { "FALHA" }
    $color = if ($result.Success) { "Green" } else { "Red" }
    Write-Host "$status $($result.Name)" -ForegroundColor $color
}

Write-Host "`nSincronizacao multi-projetos finalizada!" -ForegroundColor Cyan

# Exit code baseado nos resultados
exit $(if ($failed -eq 0) { 0 } else { 1 })
