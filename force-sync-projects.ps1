# VIBECODE SYSTEM V4.0 - Sincronização Forçada dos 3 Projetos
# Script para sincronizar forçadamente os projetos com limpeza de arquivos grandes

param(
    [switch]$DryRun,
    [switch]$CleanNodeModules = $true,
    [switch]$Force = $true
)

$ProjectsPath = "@project-core/projects"
$Projects = @(
    @{
        Name = "neonpro"
        Repo = "https://github.com/GrupoUS/neonpro.git"
        Path = "$ProjectsPath/neonpro"
    },
    @{
        Name = "agendatrintae3"
        Repo = "https://github.com/GrupoUS/agendatrintae3.git"
        Path = "$ProjectsPath/agendatrintae3"
    },
    @{
        Name = "aegiswallet"
        Repo = "https://github.com/GrupoUS/aegiswallet.git"
        Path = "$ProjectsPath/aegiswallet"
    }
)

Write-Host "VIBECODE SYSTEM V4.0 - Sincronização Forçada dos Projetos" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

foreach ($project in $Projects) {
    Write-Host "`n🚀 PROCESSANDO: $($project.Name)" -ForegroundColor Yellow
    Write-Host "Repositório: $($project.Repo)" -ForegroundColor Gray
    
    # Navegar para o diretório do projeto
    if (-not (Test-Path $project.Path)) {
        Write-Host "❌ ERRO: Diretório não encontrado: $($project.Path)" -ForegroundColor Red
        continue
    }
    
    Set-Location $project.Path
    Write-Host "📁 Diretório: $($project.Path)" -ForegroundColor Green
    
    # Verificar se é um repositório Git
    if (-not (Test-Path ".git")) {
        Write-Host "⚠️ Inicializando repositório Git..." -ForegroundColor Yellow
        git init
        git remote add origin $project.Repo
    }
    
    # Verificar remote
    $currentRemote = git remote get-url origin 2>$null
    if ($currentRemote -ne $project.Repo) {
        Write-Host "🔧 Atualizando remote URL..." -ForegroundColor Yellow
        git remote set-url origin $project.Repo
    }
    
    # Limpar arquivos grandes se solicitado
    if ($CleanNodeModules) {
        Write-Host "🧹 Limpando arquivos grandes..." -ForegroundColor Yellow
        
        # Remover node_modules
        if (Test-Path "node_modules") {
            Write-Host "   Removendo node_modules..." -ForegroundColor Gray
            if (-not $DryRun) {
                Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        
        # Remover outros arquivos grandes comuns
        $largeFiles = @(
            "*.log",
            "*.tmp",
            "*.cache",
            "dist/*",
            "build/*",
            ".next/*",
            "coverage/*",
            "*.zip",
            "*.tar.gz",
            "*.exe",
            "*.msi"
        )
        
        foreach ($pattern in $largeFiles) {
            $files = Get-ChildItem -Path . -Recurse -Include $pattern -ErrorAction SilentlyContinue
            if ($files) {
                Write-Host "   Removendo arquivos: $pattern" -ForegroundColor Gray
                if (-not $DryRun) {
                    $files | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                }
            }
        }
    }
    
    # Criar/atualizar .gitignore
    $gitignoreContent = @"
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Production builds
dist/
build/
.next/
out/

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Cache
.cache/
.parcel-cache/
.eslintcache

# Coverage
coverage/

# Temporary files
*.tmp
*.temp

# Large files
*.zip
*.tar.gz
*.exe
*.msi
*.dmg
"@
    
    if (-not $DryRun) {
        Set-Content -Path ".gitignore" -Value $gitignoreContent -Encoding UTF8
        Write-Host "✅ .gitignore atualizado" -ForegroundColor Green
    }
    
    # Verificar status
    Write-Host "📊 Verificando status..." -ForegroundColor Yellow
    $gitStatus = git status --porcelain
    
    if ($gitStatus) {
        Write-Host "📝 Mudanças detectadas:" -ForegroundColor Yellow
        $gitStatus | ForEach-Object { Write-Host "   $_" -ForegroundColor White }
        
        if ($DryRun) {
            Write-Host "🔍 DRY RUN - Comandos que seriam executados:" -ForegroundColor Magenta
            Write-Host "   git add ." -ForegroundColor Gray
            Write-Host "   git commit -m '[FORCE SYNC] ...'" -ForegroundColor Gray
            Write-Host "   git push origin main --force" -ForegroundColor Gray
        } else {
            # Adicionar arquivos
            Write-Host "➕ Adicionando arquivos..." -ForegroundColor Yellow
            git add .
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "❌ ERRO ao adicionar arquivos" -ForegroundColor Red
                continue
            }
            
            # Fazer commit
            $commitMessage = "[FORCE SYNC] Sincronização forçada completa do $($project.Name) - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Write-Host "💾 Fazendo commit..." -ForegroundColor Yellow
            git commit -m $commitMessage
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "⚠️ Nenhuma mudança para commit ou erro no commit" -ForegroundColor Yellow
            }
            
            # Fazer push forçado
            Write-Host "🚀 Fazendo push forçado..." -ForegroundColor Yellow
            if ($Force) {
                git push origin main --force
            } else {
                git push origin main --force-with-lease
            }
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ SUCESSO: $($project.Name) sincronizado!" -ForegroundColor Green
            } else {
                Write-Host "❌ ERRO ao sincronizar $($project.Name)" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "✅ Nenhuma mudança detectada - projeto já sincronizado" -ForegroundColor Green
    }
    
    Write-Host "─" * 50 -ForegroundColor Gray
}

# Voltar ao diretório raiz
Set-Location "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"

Write-Host "`n🎉 SINCRONIZAÇÃO FORÇADA CONCLUÍDA!" -ForegroundColor Cyan
Write-Host "Todos os projetos foram processados." -ForegroundColor Green

# Validar repositórios GitHub
Write-Host "`n🔍 VALIDAÇÃO DOS REPOSITÓRIOS:" -ForegroundColor Yellow
foreach ($project in $Projects) {
    Write-Host "   $($project.Name): $($project.Repo)" -ForegroundColor White
}

Write-Host "`nPara verificar os repositórios, acesse:" -ForegroundColor Cyan
Write-Host "• https://github.com/GrupoUS/neonpro" -ForegroundColor Blue
Write-Host "• https://github.com/GrupoUS/agendatrintae3" -ForegroundColor Blue  
Write-Host "• https://github.com/GrupoUS/aegiswallet" -ForegroundColor Blue
