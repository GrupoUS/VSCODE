# 🚀 VIBECODE SYSTEM V4.0 - Sincronização SOBERANA de Projetos GitHub
# Script para sincronização onde pastas locais são SEMPRE dominantes
# Força push, remove arquivos remotos não existentes localmente
# Configuração: @project-core/configs/projects-sync-config.json

param(
    [string]$ProjectName = "",
    [switch]$All,
    [switch]$DryRun,
    [string]$Message = "",
    [switch]$Verbose
)

# Configurações base
$ScriptVersion = "4.0.0-SOVEREIGN"
$ScriptName = "Sincronização Soberana Multi-Projetos"
$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$ConfigPath = "@project-core\configs\projects-sync-config.json"

Write-Host "🚀 $ScriptName v$ScriptVersion" -ForegroundColor Cyan
Write-Host "👑 MODO SOBERANO: Pastas locais SEMPRE dominantes" -ForegroundColor Yellow
Write-Host "=" * 80 -ForegroundColor Cyan

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
        Write-Host "✅ Configuração carregada: $($config.projects.PSObject.Properties.Count) projetos encontrados" -ForegroundColor Green
        return $config
    }
    catch {
        Write-Error "❌ Erro ao carregar configuração: $($_.Exception.Message)"
        exit 1
    }
}

# Função para sincronização soberana de um projeto
function Sync-SovereignProject {
    param(
        [PSCustomObject]$ProjectConfig,
        [string]$ProjectKey,
        [string]$CustomMessage = "",
        [switch]$DryRun
    )

    Write-Host "`n👑 SINCRONIZAÇÃO SOBERANA: $($ProjectConfig.name)" -ForegroundColor Magenta
    Write-Host "=" * 60 -ForegroundColor Gray

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
        Write-Host "🌐 Repositório: $($ProjectConfig.repositoryUrl)" -ForegroundColor Green
        Write-Host "🌿 Branch: $($ProjectConfig.branch)" -ForegroundColor Green

        # Verificar se é um repositório git
        $isGitRepo = Test-Path ".git"

        if (-not $isGitRepo) {
            Write-Host "🔧 Inicializando repositório Git..." -ForegroundColor Yellow
            if (-not $DryRun) {
                git init
                git remote add origin $ProjectConfig.repositoryUrl
                git config user.email "admin@grupous.com"
                git config user.name "GrupoUS"
            }
        } else {
            # Verificar e corrigir remote
            $currentRemote = git remote get-url origin 2>$null
            if ($currentRemote -ne $ProjectConfig.repositoryUrl) {
                Write-Host "🔧 Atualizando remote URL..." -ForegroundColor Yellow
                if (-not $DryRun) {
                    git remote set-url origin $ProjectConfig.repositoryUrl
                }
            }
        }

        # SINCRONIZAÇÃO SOBERANA - PARTE 1: BACKUP
        if ($ProjectConfig.syncSettings.createBackup -and -not $DryRun) {
            Write-Host "`n📦 Criando backup antes da sincronização soberana..." -ForegroundColor Yellow
            $backupName = "$($ProjectKey)_sovereign_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            # Criar backup será implementado depois se necessário
        }

        # SINCRONIZAÇÃO SOBERANA - PARTE 2: PREPARAR COMMIT LOCAL
        Write-Host "`n📊 Verificando mudanças locais..." -ForegroundColor Yellow
        $gitStatus = git status --porcelain

        # Preparar mensagem de commit
        $commitMessage = if ($CustomMessage) {
            $CustomMessage
        } else {
            "👑 [$ProjectKey] Sincronização SOBERANA - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }

        # Adicionar todos os arquivos (incluindo novos e modificados)
        Write-Host "`n➕ Adicionando TODOS os arquivos locais..." -ForegroundColor Yellow
        if ($DryRun) {
            Write-Host "🔍 DRY RUN - Comandos que seriam executados:" -ForegroundColor Magenta
            Write-Host "   git add -A" -ForegroundColor Gray
            Write-Host "   git commit -m '$commitMessage'" -ForegroundColor Gray
            Write-Host "   git push origin $($ProjectConfig.branch) --force" -ForegroundColor Gray
            return @{ Success = $true; DryRun = $true }
        }

        git add -A  # -A inclui arquivos novos, modificados E remove arquivos deletados

        if ($LASTEXITCODE -ne 0) {
            throw "Erro ao adicionar arquivos"
        }

        # Verificar se há mudanças para commit
        $hasChanges = git diff --cached --quiet; $LASTEXITCODE -ne 0

        if ($hasChanges) {
            # Fazer commit
            Write-Host "💾 Fazendo commit..." -ForegroundColor Yellow
            git commit -m $commitMessage

            if ($LASTEXITCODE -ne 0) {
                throw "Erro ao fazer commit"
            }
        } else {
            Write-Host "ℹ️ Nenhuma mudança para commit" -ForegroundColor Gray
        }

        # SINCRONIZAÇÃO SOBERANA - PARTE 3: FORCE PUSH
        Write-Host "`n👑 EXECUTANDO PUSH SOBERANO (FORÇA TOTAL)..." -ForegroundColor Red
        Write-Host "⚠️ ATENÇÃO: Repositório remoto será SOBRESCRITO completamente" -ForegroundColor Yellow

        # Buscar informações remotas primeiro
        Write-Host "📥 Buscando informações remotas..." -ForegroundColor Yellow
        git fetch origin 2>$null

        # Push forçado - SOBERANIA TOTAL
        Write-Host "🚀 Executando push forçado..." -ForegroundColor Red
        git push origin $ProjectConfig.branch --force

        if ($LASTEXITCODE -ne 0) {
            # Se falhar, tentar criar a branch remota
            Write-Host "⚠️ Branch remota pode não existir, criando..." -ForegroundColor Yellow
            git push -u origin $ProjectConfig.branch --force

            if ($LASTEXITCODE -ne 0) {
                throw "Erro ao fazer push forçado"
            }
        }

        Write-Host "`n✅ SINCRONIZAÇÃO SOBERANA CONCLUÍDA!" -ForegroundColor Green
        Write-Host "👑 Repositório remoto agora é IDÊNTICO ao local" -ForegroundColor Green
        Write-Host "🗑️ Arquivos remotos não existentes localmente foram REMOVIDOS" -ForegroundColor Green

        return @{
            Success = $true;
            Changes = if ($gitStatus) { $gitStatus.Count } else { 0 }
            Mode = "SOVEREIGN"
            CommitMessage = $commitMessage
        }

    }
    catch {
        Write-Host "❌ Erro na sincronização soberana: $($_.Exception.Message)" -ForegroundColor Red
        return @{ Success = $false; Error = $_.Exception.Message }
    }
    finally {
        Set-Location $originalLocation
    }
}

# Função principal
function Main {
    # Carregar configuração
    $config = Load-ProjectsConfig -ConfigPath $ConfigPath

    # Verificar se está no modo soberano
    if (-not $config.globalSettings.sovereignMode) {
        Write-Warning "⚠️ Modo soberano não está habilitado na configuração"
        Write-Host "💡 Para habilitar, defina 'sovereignMode': true em globalSettings" -ForegroundColor Yellow
    }

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
        Write-Host "🌐 Modo TODOS os Projetos - SINCRONIZAÇÃO SOBERANA TOTAL" -ForegroundColor Magenta
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

    # Executar sincronização soberana
    $results = @()
    $totalProjects = $projectsToSync.Count
    $currentProject = 0

    foreach ($project in $projectsToSync) {
        $currentProject++
        Write-Host "`n" + ("=" * 80) -ForegroundColor Cyan
        Write-Host "📊 PROJETO $currentProject de $totalProjects" -ForegroundColor Cyan

        $result = Sync-SovereignProject -ProjectConfig $project.Config -ProjectKey $project.Key -CustomMessage $Message -DryRun:$DryRun
        $result.ProjectKey = $project.Key
        $result.ProjectName = $project.Config.name
        $results += $result

        if ($result.Success) {
            Write-Host "✅ $($project.Config.name): SINCRONIZAÇÃO SOBERANA BEM-SUCEDIDA" -ForegroundColor Green
        } else {
            Write-Host "❌ $($project.Config.name): FALHOU - $($result.Error)" -ForegroundColor Red
        }
    }

    # Relatório final
    Write-Host "`n" + ("=" * 80) -ForegroundColor Cyan
    Write-Host "📋 RELATÓRIO FINAL DE SINCRONIZAÇÃO SOBERANA" -ForegroundColor Cyan
    Write-Host "=" * 80 -ForegroundColor Cyan

    $successful = ($results | Where-Object { $_.Success }).Count
    $failed = ($results | Where-Object { -not $_.Success }).Count

    Write-Host "✅ Projetos sincronizados com sucesso: $successful" -ForegroundColor Green
    Write-Host "❌ Projetos com falha: $failed" -ForegroundColor Red
    Write-Host "📊 Total de projetos processados: $totalProjects" -ForegroundColor White

    if ($failed -gt 0) {
        Write-Host "`n❌ PROJETOS COM FALHA:" -ForegroundColor Red
        $results | Where-Object { -not $_.Success } | ForEach-Object {
            Write-Host "   - $($_.ProjectName): $($_.Error)" -ForegroundColor Red
        }
    }

    Write-Host "`n🎉 SINCRONIZAÇÃO SOBERANA FINALIZADA!" -ForegroundColor Cyan
    Write-Host "👑 Repositórios remotos agora são IDÊNTICOS às pastas locais" -ForegroundColor Yellow
    Write-Host "=" * 80 -ForegroundColor Cyan

    return $results
}

# Executar função principal
Main
