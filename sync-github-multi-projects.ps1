# VIBECODE SYSTEM V4.0 - Sincronizacao Multi-Projetos GitHub
# Script para sincronizacao automatica de multiplos projetos com seus respectivos repositorios GitHub
# Suporte para projetos individuais dentro de @project-core/projects/

param(
    [switch]$Force,
    [switch]$DryRun,
    [string]$ProjectName = "",
    [switch]$All,
    [string]$ConfigPath = "@project-core\configs\projects-sync-config.json",
    [string]$Message = ""
)

# Configurações base
$ScriptVersion = "4.0.0"
$ScriptName = "Multi-Projects GitHub Sync"
$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"

Write-Host "🚀 $ScriptName v$ScriptVersion" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# Função para carregar configuração
function Load-ProjectsConfig {
    param([string]$ConfigPath)

    $fullConfigPath = Join-Path $SystemRootPath $ConfigPath

    if (-not (Test-Path $fullConfigPath)) {
        Write-Error "❌ Arquivo de configuração não encontrado: $fullConfigPath"
        exit 1
    }

    try {
        $config = Get-Content $fullConfigPath -Raw | ConvertFrom-Json
        Write-Host "✅ Configuração carregada: $($config.projects.Count) projetos encontrados" -ForegroundColor Green
        return $config
    }
    catch {
        Write-Error "❌ Erro ao carregar configuração: $($_.Exception.Message)"
        exit 1
    }
}

# Função para validar projeto
function Test-ProjectPath {
    param([string]$ProjectPath)

    $fullPath = Join-Path $SystemRootPath $ProjectPath
    return Test-Path $fullPath
}

# Função para sincronizar um projeto específico
function Sync-SingleProject {
    param(
        [PSCustomObject]$ProjectConfig,
        [string]$ProjectKey,
        [string]$CustomMessage = ""
    )

    Write-Host "`n🎯 SINCRONIZANDO PROJETO: $($ProjectConfig.name)" -ForegroundColor Magenta
    Write-Host "=" * 50 -ForegroundColor Gray

    $projectPath = Join-Path $SystemRootPath $ProjectConfig.localPath
    $originalLocation = Get-Location

    try {
        # Verificar se o projeto existe
        if (-not (Test-Path $projectPath)) {
            Write-Host "❌ Projeto não encontrado: $projectPath" -ForegroundColor Red
            return @{ Success = $false; Error = "Projeto não encontrado" }
        }

        # Navegar para a pasta do projeto
        Set-Location $projectPath
        Write-Host "📁 Pasta do projeto: $projectPath" -ForegroundColor Green

        # Verificar se é um repositório git
        if (-not (Test-Path ".git")) {
            Write-Host "Inicializando repositório Git..." -ForegroundColor Yellow
            git init
            git remote add origin $ProjectConfig.repositoryUrl
        }

        # Verificar remote
        $currentRemote = git remote get-url origin 2>$null
        if ($currentRemote -ne $ProjectConfig.repositoryUrl) {
            Write-Host "🔧 Atualizando remote URL..." -ForegroundColor Yellow
            git remote set-url origin $ProjectConfig.repositoryUrl
        }

        Write-Host "🌐 Repositório: $($ProjectConfig.repositoryUrl)" -ForegroundColor Green
        Write-Host "🌿 Branch: $($ProjectConfig.branch)" -ForegroundColor Green

        # Verificar status do git
        Write-Host "`n📊 Verificando status..." -ForegroundColor Yellow
        $gitStatus = git status --porcelain

        if ($gitStatus) {
            Write-Host "📝 Mudanças detectadas:" -ForegroundColor Yellow
            $gitStatus | ForEach-Object { Write-Host "   $_" -ForegroundColor White }

            if ($DryRun) {
                Write-Host "`n🔍 DRY RUN - Comandos que seriam executados:" -ForegroundColor Magenta
                Write-Host "   git add ." -ForegroundColor Gray
                Write-Host "   git commit -m '...'" -ForegroundColor Gray
                Write-Host "   git push origin $($ProjectConfig.branch)" -ForegroundColor Gray
                return @{ Success = $true; DryRun = $true }
            }

            # Preparar mensagem de commit
            $commitMessage = if ($CustomMessage) {
                $CustomMessage
            } else {
                "🔄 [$ProjectKey] Sincronização automática - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            }

            # Adicionar arquivos
            Write-Host "`n➕ Adicionando arquivos..." -ForegroundColor Yellow
            git add .

            if ($LASTEXITCODE -ne 0) {
                throw "Erro ao adicionar arquivos"
            }

            # Fazer commit
            Write-Host "💾 Fazendo commit..." -ForegroundColor Yellow
            git commit -m $commitMessage

            if ($LASTEXITCODE -ne 0) {
                throw "Erro ao fazer commit"
            }

            # Fazer push
            Write-Host "🚀 Fazendo push para GitHub..." -ForegroundColor Yellow
            if ($Force) {
                git push origin $ProjectConfig.branch --force-with-lease
            } else {
                git push origin $ProjectConfig.branch
            }

            if ($LASTEXITCODE -ne 0) {
                throw "Erro ao fazer push"
            }

            Write-Host "✅ Projeto $($ProjectConfig.name) sincronizado com sucesso!" -ForegroundColor Green
            return @{ Success = $true; Changes = $gitStatus.Count }

        } else {
            Write-Host "✅ Nenhuma mudança detectada - projeto já sincronizado" -ForegroundColor Green
            return @{ Success = $true; Changes = 0 }
        }

    }
    catch {
        Write-Host "❌ Erro na sincronização: $($_.Exception.Message)" -ForegroundColor Red
        return @{ Success = $false; Error = $_.Exception.Message }
    }
    finally {
        Set-Location $originalLocation
    }
}

# Carregar configuração
$config = Load-ProjectsConfig -ConfigPath $ConfigPath

# Determinar quais projetos sincronizar
$projectsToSync = @()

if ($ProjectName) {
    # Sincronizar projeto específico
    if ($config.projects.PSObject.Properties.Name -contains $ProjectName) {
        $projectsToSync += @{ Key = $ProjectName; Config = $config.projects.$ProjectName }
        Write-Host "🎯 Modo Projeto Específico: $ProjectName" -ForegroundColor Magenta
    } else {
        Write-Error "❌ Projeto '$ProjectName' não encontrado na configuração"
        Write-Host "💡 Projetos disponíveis:" -ForegroundColor Yellow
        $config.projects.PSObject.Properties.Name | ForEach-Object {
            Write-Host "   - $_" -ForegroundColor White
        }
        exit 1
    }
} elseif ($All) {
    # Sincronizar todos os projetos
    Write-Host "🌐 Modo Todos os Projetos" -ForegroundColor Magenta
    $config.projects.PSObject.Properties | ForEach-Object {
        if ($_.Value.enabled) {
            $projectsToSync += @{ Key = $_.Name; Config = $_.Value }
        }
    }
} else {
    Write-Host "⚠️ Especifique um projeto (-ProjectName) ou use -All para todos os projetos" -ForegroundColor Yellow
    Write-Host "💡 Projetos disponíveis:" -ForegroundColor Yellow
    $config.projects.PSObject.Properties.Name | ForEach-Object {
        Write-Host "   - $_" -ForegroundColor White
    }
    exit 1
}

# Executar sincronização
$results = @()
$totalProjects = $projectsToSync.Count
$currentProject = 0

Write-Host "`n🚀 INICIANDO SINCRONIZAÇÃO DE $totalProjects PROJETO(S)..." -ForegroundColor Cyan

foreach ($project in $projectsToSync) {
    $currentProject++
    Write-Host "`n[$currentProject/$totalProjects]" -ForegroundColor Gray

    $result = Sync-SingleProject -ProjectConfig $project.Config -ProjectKey $project.Key -CustomMessage $Message
    $results += @{
        Project = $project.Key
        Name = $project.Config.name
        Result = $result
    }
}

# Relatório final
Write-Host "`n" + "=" * 60 -ForegroundColor Cyan
Write-Host "📊 RELATÓRIO DE SINCRONIZAÇÃO" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

$successful = ($results | Where-Object { $_.Result.Success }).Count
$failed = ($results | Where-Object { -not $_.Result.Success }).Count

Write-Host "✅ Sucessos: $successful" -ForegroundColor Green
Write-Host "❌ Falhas: $failed" -ForegroundColor Red

foreach ($result in $results) {
    $status = if ($result.Result.Success) { "✅" } else { "❌" }
    $details = if ($result.Result.DryRun) {
        "(DRY RUN)"
    } elseif ($result.Result.Changes) {
        "($($result.Result.Changes) mudanças)"
    } elseif ($result.Result.Error) {
        "($($result.Result.Error))"
    } else {
        "(sem mudanças)"
    }

    Write-Host "$status $($result.Name) $details" -ForegroundColor $(if ($result.Result.Success) { "Green" } else { "Red" })
}

Write-Host "`n🎉 Sincronização multi-projetos finalizada!" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# Exit code baseado nos resultados
exit $(if ($failed -eq 0) { 0 } else { 1 })
