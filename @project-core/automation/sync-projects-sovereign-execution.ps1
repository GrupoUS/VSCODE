# 🚀 EXECUÇÃO IMEDIATA - Sincronização Soberana de Projetos
# Token já configurado e autenticado via GitHub CLI
# Configuração: @project-core/configs/projects-sync-config.json

param(
    [switch]$All = $true,
    [switch]$DryRun = $false
)

$ScriptVersion = "4.0.0-EXECUTION"
$ScriptName = "Execução Sincronização Soberana"
$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$ConfigPath = "@project-core\configs\projects-sync-config.json"

Write-Host "🚀 $ScriptName v$ScriptVersion" -ForegroundColor Cyan
Write-Host "👑 MODO SOBERANO: Pastas locais SEMPRE dominantes" -ForegroundColor Yellow
Write-Host "🔐 AUTENTICAÇÃO: GitHub CLI ativo (token configurado)" -ForegroundColor Green

# Carregar configuração
if (-not (Test-Path $ConfigPath)) {
    Write-Error "❌ Arquivo de configuração não encontrado: $ConfigPath"
    exit 1
}

$config = Get-Content $ConfigPath | ConvertFrom-Json
Write-Host "✅ Configuração carregada: $($config.projects.PSObject.Properties.Count) projetos" -ForegroundColor Green

# Função para sincronizar projeto individual
function Sync-Project {
    param(
        [string]$ProjectName,
        [object]$ProjectConfig,
        [bool]$IsDryRun = $false
    )

    Write-Host "`n🔄 SINCRONIZANDO: $ProjectName" -ForegroundColor Cyan
    Write-Host "📁 Local: $($ProjectConfig.localPath)" -ForegroundColor Gray
    Write-Host "🔗 GitHub: $($ProjectConfig.repositoryUrl)" -ForegroundColor Gray

    $localPath = Join-Path $SystemRootPath $ProjectConfig.localPath

    # Verificar se pasta local existe
    if (-not (Test-Path $localPath)) {
        Write-Warning "⚠️ Pasta local não encontrada: $localPath"
        return $false
    }

    # Navegar para o diretório
    Push-Location $localPath

    try {
        # Verificar se é repositório Git
        if (-not (Test-Path ".git")) {
            Write-Host "🔧 Inicializando repositório Git..." -ForegroundColor Yellow
            if (-not $IsDryRun) {
                git init
                git remote add origin $ProjectConfig.repositoryUrl
            }
        }

        # Configurar remote com autenticação
        $tokenUrl = $ProjectConfig.repositoryUrl -replace "https://github.com/", "https://${env:GITHUB_TOKEN}@github.com/"

        if (-not $IsDryRun) {
            Write-Host "🔐 Configurando autenticação..." -ForegroundColor Yellow
            git remote set-url origin $tokenUrl
        }

        # Verificar status
        $status = git status --porcelain
        Write-Host "📊 Status: $($status.Count) arquivos modificados/novos" -ForegroundColor Gray

        if (-not $IsDryRun) {
            # Stage todas as alterações
            Write-Host "➕ Adicionando arquivos..." -ForegroundColor Yellow
            git add .

            # Commit
            $commitMessage = "🚀 SINCRONIZAÇÃO SOBERANA: $ProjectName - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Write-Host "💾 Criando commit..." -ForegroundColor Yellow
            git commit -m $commitMessage -q

            # Push forçado (soberano)
            Write-Host "⬆️ Executando push soberano..." -ForegroundColor Yellow
            git push origin main --force

            Write-Host "✅ $ProjectName sincronizado com sucesso!" -ForegroundColor Green
        } else {
            Write-Host "🧪 DRY RUN: Simulação concluída para $ProjectName" -ForegroundColor Cyan
        }

        return $true

    } catch {
        Write-Error "❌ Erro ao sincronizar $ProjectName`: $($_.Exception.Message)"
        return $false
    } finally {
        Pop-Location
    }
}

# Executar sincronização
$projects = @("neonpro", "agendatrintae3", "aegiswallet")
$successCount = 0
$totalCount = $projects.Count

Write-Host "`n🎯 INICIANDO SINCRONIZAÇÃO SOBERANA" -ForegroundColor Magenta
Write-Host "📋 Projetos: $($projects -join ', ')" -ForegroundColor Gray
Write-Host "🧪 Modo: $(if ($DryRun) { 'DRY RUN (Simulação)' } else { 'EXECUÇÃO REAL' })" -ForegroundColor Gray

foreach ($projectName in $projects) {
    if ($config.projects.$projectName) {
        $success = Sync-Project -ProjectName $projectName -ProjectConfig $config.projects.$projectName -IsDryRun $DryRun
        if ($success) { $successCount++ }
    } else {
        Write-Warning "⚠️ Projeto $projectName não encontrado na configuração"
    }
}

# Resultado final
Write-Host "`n📊 RESULTADO FINAL" -ForegroundColor Magenta
Write-Host "✅ Sucessos: $successCount/$totalCount" -ForegroundColor Green
Write-Host "🎯 Taxa de sucesso: $(($successCount/$totalCount*100).ToString('F1'))%" -ForegroundColor $(if ($successCount -eq $totalCount) { 'Green' } else { 'Yellow' })

if ($successCount -eq $totalCount) {
    Write-Host "`n🏆 SINCRONIZAÇÃO SOBERANA COMPLETA!" -ForegroundColor Green
    Write-Host "👑 Todos os projetos estão sincronizados com suas pastas locais dominantes" -ForegroundColor Yellow
} else {
    Write-Host "`n⚠️ Alguns projetos falharam na sincronização" -ForegroundColor Red
}

Write-Host "`n🔗 Repositórios atualizados:" -ForegroundColor Cyan
foreach ($projectName in $projects) {
    if ($config.projects.$projectName) {
        Write-Host "  • $projectName`: $($config.projects.$projectName.repositoryUrl)" -ForegroundColor Gray
    }
}
