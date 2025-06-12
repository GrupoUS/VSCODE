# VIBECODE SYSTEM V4.0 - Verificação e Completar Sincronização dos Projetos
# Script para verificar e completar a sincronização dos projetos AgendaTrintaE3 e NeonPro

param(
    [switch]$Force,
    [switch]$CleanNodeModules = $true,
    [switch]$Verbose
)

$ProjectsPath = "@project-core/projects"
$Projects = @(
    @{
        Name = "neonpro"
        Repo = "https://github.com/GrupoUS/neonpro.git"
        Path = "$ProjectsPath/neonpro"
        LastCommitExpected = "51a6d84fee6a2da4a3cec682c9703c15e8e9e63d"
        Status = "VERIFICAR"
    },
    @{
        Name = "agendatrintae3"
        Repo = "https://github.com/GrupoUS/agendatrintae3.git"
        Path = "$ProjectsPath/agendatrintae3"
        LastCommitExpected = "58245800e7f11f92141201cdbef54fee4d70e091"
        Status = "VERIFICAR"
    },
    @{
        Name = "aegiswallet"
        Repo = "https://github.com/GrupoUS/aegiswallet.git"
        Path = "$ProjectsPath/aegiswallet"
        Status = "SINCRONIZADO"
    }
)

Write-Host "🔍 VIBECODE SYSTEM V4.0 - Verificação e Completar Sincronização" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

# Função para verificar status do Git
function Get-GitStatus {
    param($ProjectPath)
    
    try {
        Push-Location $ProjectPath
        
        $status = @{
            HasChanges = $false
            Branch = ""
            Remote = ""
            LastCommit = ""
            IsClean = $true
        }
        
        # Verificar branch atual
        $status.Branch = git rev-parse --abbrev-ref HEAD 2>$null
        
        # Verificar remote
        $status.Remote = git remote get-url origin 2>$null
        
        # Verificar último commit
        $status.LastCommit = git rev-parse HEAD 2>$null
        
        # Verificar se há mudanças
        $gitStatus = git status --porcelain 2>$null
        if ($gitStatus) {
            $status.HasChanges = $true
            $status.IsClean = $false
        }
        
        return $status
    }
    catch {
        return $null
    }
    finally {
        Pop-Location
    }
}

# Função para limpar arquivos grandes
function Clean-LargeFiles {
    param($ProjectPath)
    
    Write-Host "🧹 Limpando arquivos grandes em $ProjectPath..." -ForegroundColor Yellow
    
    Push-Location $ProjectPath
    
    try {
        # Remover node_modules se existir
        if (Test-Path "node_modules") {
            Write-Host "   Removendo node_modules..." -ForegroundColor Gray
            Remove-Item "node_modules" -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Remover outros arquivos grandes
        $largePatterns = @("*.log", "*.tmp", "*.cache", "dist", "build", ".next", "coverage")
        foreach ($pattern in $largePatterns) {
            $files = Get-ChildItem -Path . -Recurse -Include $pattern -ErrorAction SilentlyContinue
            if ($files) {
                Write-Host "   Removendo: $pattern" -ForegroundColor Gray
                $files | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
        }
        
        Write-Host "✅ Limpeza concluída" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

# Função para sincronizar projeto
function Sync-Project {
    param($Project)
    
    Write-Host "`n🚀 PROCESSANDO: $($Project.Name)" -ForegroundColor Yellow
    Write-Host "Repositório: $($Project.Repo)" -ForegroundColor Gray
    
    if (-not (Test-Path $Project.Path)) {
        Write-Host "❌ ERRO: Diretório não encontrado: $($Project.Path)" -ForegroundColor Red
        return $false
    }
    
    $gitStatus = Get-GitStatus -ProjectPath $Project.Path
    
    if (-not $gitStatus) {
        Write-Host "❌ ERRO: Não é um repositório Git válido" -ForegroundColor Red
        return $false
    }
    
    Write-Host "📊 Status atual:" -ForegroundColor Cyan
    Write-Host "   Branch: $($gitStatus.Branch)" -ForegroundColor White
    Write-Host "   Remote: $($gitStatus.Remote)" -ForegroundColor White
    Write-Host "   Último commit: $($gitStatus.LastCommit)" -ForegroundColor White
    Write-Host "   Tem mudanças: $($gitStatus.HasChanges)" -ForegroundColor White
    
    # Verificar se o último commit corresponde ao esperado
    if ($Project.LastCommitExpected -and $gitStatus.LastCommit -eq $Project.LastCommitExpected) {
        Write-Host "✅ PROJETO JÁ SINCRONIZADO - Último commit corresponde ao GitHub" -ForegroundColor Green
        return $true
    }
    
    Push-Location $Project.Path
    
    try {
        # Limpar arquivos grandes se solicitado
        if ($CleanNodeModules) {
            Clean-LargeFiles -ProjectPath $Project.Path
        }
        
        # Verificar se há mudanças para commit
        $statusOutput = git status --porcelain
        
        if ($statusOutput) {
            Write-Host "📝 Mudanças detectadas - Preparando sincronização..." -ForegroundColor Yellow
            
            # Adicionar arquivos
            Write-Host "➕ Adicionando arquivos..." -ForegroundColor Yellow
            git add .
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "❌ ERRO ao adicionar arquivos" -ForegroundColor Red
                return $false
            }
            
            # Fazer commit
            $commitMessage = "[SYNC COMPLETE] Sincronização completa do $($Project.Name) - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            Write-Host "💾 Fazendo commit..." -ForegroundColor Yellow
            git commit -m $commitMessage
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "⚠️ Nenhuma mudança para commit" -ForegroundColor Yellow
            }
        }
        
        # Fazer push
        Write-Host "🚀 Fazendo push..." -ForegroundColor Yellow
        if ($Force) {
            git push origin main --force
        } else {
            git push origin main
        }
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ SUCESSO: $($Project.Name) sincronizado!" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ ERRO ao sincronizar $($Project.Name)" -ForegroundColor Red
            return $false
        }
    }
    finally {
        Pop-Location
    }
}

# Verificar e sincronizar cada projeto
$results = @()

foreach ($project in $Projects) {
    if ($project.Status -eq "SINCRONIZADO") {
        Write-Host "`n✅ $($project.Name): JÁ SINCRONIZADO (pulando)" -ForegroundColor Green
        $results += @{ Project = $project.Name; Status = "SKIPPED"; Success = $true }
        continue
    }
    
    $success = Sync-Project -Project $project
    $results += @{ 
        Project = $project.Name
        Status = if ($success) { "SUCCESS" } else { "FAILED" }
        Success = $success
    }
    
    Write-Host "─" * 50 -ForegroundColor Gray
}

# Relatório final
Write-Host "`n📊 RELATÓRIO FINAL DA SINCRONIZAÇÃO:" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

$successCount = ($results | Where-Object { $_.Success }).Count
$totalCount = $results.Count

foreach ($result in $results) {
    $color = if ($result.Success) { "Green" } else { "Red" }
    $icon = if ($result.Success) { "✅" } else { "❌" }
    Write-Host "$icon $($result.Project): $($result.Status)" -ForegroundColor $color
}

Write-Host "`n🎯 RESULTADO GERAL:" -ForegroundColor Yellow
Write-Host "   Projetos processados: $totalCount" -ForegroundColor White
Write-Host "   Sucessos: $successCount" -ForegroundColor Green
Write-Host "   Falhas: $($totalCount - $successCount)" -ForegroundColor Red

if ($successCount -eq $totalCount) {
    Write-Host "`n🎉 TODOS OS PROJETOS SINCRONIZADOS COM SUCESSO!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️ ALGUNS PROJETOS PRECISAM DE ATENÇÃO" -ForegroundColor Yellow
}

Write-Host "`n🔍 VALIDAÇÃO DOS REPOSITÓRIOS:" -ForegroundColor Cyan
Write-Host "• NeonPro: https://github.com/GrupoUS/neonpro" -ForegroundColor Blue
Write-Host "• AgendaTrintaE3: https://github.com/GrupoUS/agendatrintae3" -ForegroundColor Blue
Write-Host "• AegisWallet: https://github.com/GrupoUS/aegiswallet" -ForegroundColor Blue

Write-Host "`n🚀 VIBECODE SYSTEM V4.0 - Verificação Concluída!" -ForegroundColor Cyan
