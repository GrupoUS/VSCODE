# 🚀 SINCRONIZAÇÃO DIRETA DOS PROJETOS SOBERANOS
# Versão simplificada para execução imediata

Write-Host "🚀 INICIANDO SINCRONIZAÇÃO SOBERANA DOS PROJETOS" -ForegroundColor Cyan
Write-Host "👑 Pastas locais são SEMPRE dominantes" -ForegroundColor Yellow

$projects = @{
    "neonpro" = @{
        "path" = "@project-core\projects\neonpro"
        "repo" = "https://github.com/GrupoUS/neonpro.git"
    }
    "agendatrintae3" = @{
        "path" = "@project-core\projects\agendatrintae3"
        "repo" = "https://github.com/GrupoUS/agendatrintae3.git"
    }
    "aegiswallet" = @{
        "path" = "@project-core\projects\aegiswallet"
        "repo" = "https://github.com/GrupoUS/aegiswallet.git"
    }
}

$token = $env:GITHUB_TOKEN # Token deve ser definido como variável de ambiente
$successCount = 0

foreach ($projectName in $projects.Keys) {
    Write-Host "`n🔄 SINCRONIZANDO: $projectName" -ForegroundColor Magenta

    $projectPath = $projects[$projectName]["path"]
    $repoUrl = $projects[$projectName]["repo"]

    # Verificar se pasta existe
    if (Test-Path $projectPath) {
        Write-Host "📁 Pasta encontrada: $projectPath" -ForegroundColor Green

        # Navegar para o diretório
        Set-Location $projectPath

        # Verificar se é repositório Git
        if (-not (Test-Path ".git")) {
            Write-Host "🔧 Inicializando repositório Git..." -ForegroundColor Yellow
            git init
            $tokenUrl = $repoUrl -replace "https://github.com/", "https://$token@github.com/"
            git remote add origin $tokenUrl
        } else {
            Write-Host "📂 Repositório Git já existe" -ForegroundColor Green
            $tokenUrl = $repoUrl -replace "https://github.com/", "https://$token@github.com/"
            git remote set-url origin $tokenUrl
        }

        # Status
        Write-Host "📊 Verificando status..." -ForegroundColor Gray
        git status --short

        # Adicionar todas as alterações
        Write-Host "➕ Adicionando arquivos..." -ForegroundColor Yellow
        git add .

        # Commit
        $commitMsg = "SYNC SOBERANO: $projectName - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        Write-Host "💾 Criando commit..." -ForegroundColor Yellow
        git commit -m $commitMsg

        # Push forçado
        Write-Host "⬆️ Push soberano..." -ForegroundColor Yellow
        git push origin main --force

        Write-Host "✅ $projectName sincronizado!" -ForegroundColor Green
        $successCount++

        # Voltar para raiz
        Set-Location $PSScriptRoot
        Set-Location ".."
        Set-Location ".."

    } else {
        Write-Host "❌ Pasta não encontrada: $projectPath" -ForegroundColor Red
    }
}

Write-Host "`n📊 RESULTADO FINAL" -ForegroundColor Magenta
Write-Host "✅ Projetos sincronizados: $successCount/3" -ForegroundColor Green

if ($successCount -eq 3) {
    Write-Host "🏆 SINCRONIZAÇÃO SOBERANA COMPLETA!" -ForegroundColor Green
} else {
    Write-Host "⚠️ Alguns projetos não foram sincronizados" -ForegroundColor Yellow
}
