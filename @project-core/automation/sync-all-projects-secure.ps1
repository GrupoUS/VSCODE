#!/usr/bin/env pwsh
# SINCRONIZACAO SEGURA DE TODOS OS PROJETOS - GRUPO US
# Versao: 2.0 - Tokens seguros isolados por projeto

param(
    [string]$ProjectName = "",
    [switch]$All = $false,
    [switch]$Force = $false
)

$Projects = @{
    "neonpro" = @{
        "path" = "@project-core/projects/neonpro"
        "repo" = "github.com/GrupoUS/neonpro.git"
        "branch" = "clean-branch"
    }
    "aegiswallet" = @{
        "path" = "@project-core/projects/aegiswallet"
        "repo" = "github.com/GrupoUS/aegiswallet.git"
        "branch" = "main"
    }
    "agendatrintae3" = @{
        "path" = "@project-core/projects/agendatrintae3"
        "repo" = "github.com/GrupoUS/agendatrintae3.git"
        "branch" = "main"
    }
}

Write-Host "SINCRONIZACAO SEGURA DE PROJETOS - GRUPO US" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Gray

function Sync-Project {
    param($Name, $Config)

    Write-Host "SINCRONIZANDO: $Name" -ForegroundColor Yellow

    # Verificar se diretorio existe
    if (-not (Test-Path $Config.path)) {
        Write-Error "Diretorio nao encontrado: $($Config.path)"
        return $false
    }

    # Entrar no diretorio
    Push-Location $Config.path

    try {
        # Verificar se existe pasta env com token
        $TokenPath = "env/github-token.txt"
        if (-not (Test-Path $TokenPath)) {
            Write-Warning "Token nao encontrado em $TokenPath para $Name"
            Write-Host "Execute: echo 'seu_token' > $TokenPath"
            return $false
        }

        # Ler token
        $GitHubToken = Get-Content $TokenPath -ErrorAction Stop
        Write-Host "Token carregado para $Name" -ForegroundColor Green

        # Configurar remote com URL correta
        $RepoUrl = "https://$GitHubToken@$($Config.repo)"
        Write-Host "URL: $RepoUrl" -ForegroundColor Gray
        git remote set-url origin $RepoUrl

        # Status
        $Status = git status --porcelain
        if (-not $Status) {
            Write-Host "Nenhuma alteracao em $Name" -ForegroundColor Gray
            return $true
        }

        # Sincronizar
        git add .
        $Message = "SYNC $Name`: Atualizacao automatica $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git commit -m $Message

        if ($Force) {
            git push origin $Config.branch --force
        } else {
            git push origin $Config.branch
        }

        if ($LASTEXITCODE -eq 0) {
            Write-Host "SUCESSO: $Name sincronizado!" -ForegroundColor Green
            return $true
        } else {
            Write-Error "ERRO: Falha ao sincronizar $Name"
            return $false
        }

    } catch {
        Write-Error "EXCECAO em $Name`: $_"
        return $false
    } finally {
        # Limpar token
        $GitHubToken = $null
        Pop-Location
    }
}

# Executar sincronizacao
$Results = @{}

if ($All) {
    Write-Host "SINCRONIZANDO TODOS OS PROJETOS..." -ForegroundColor Cyan
    foreach ($Project in $Projects.Keys) {
        $Results[$Project] = Sync-Project -Name $Project -Config $Projects[$Project]
    }
} elseif ($ProjectName -and $Projects.ContainsKey($ProjectName)) {
    Write-Host "SINCRONIZANDO PROJETO: $ProjectName" -ForegroundColor Cyan
    $Results[$ProjectName] = Sync-Project -Name $ProjectName -Config $Projects[$ProjectName]
} else {
    Write-Host "PROJETOS DISPONIVEIS:" -ForegroundColor Yellow
    foreach ($Project in $Projects.Keys) {
        Write-Host "  - $Project" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "USO:" -ForegroundColor Cyan
    Write-Host "  .\sync-all-projects-secure.ps1 -ProjectName neonpro"
    Write-Host "  .\sync-all-projects-secure.ps1 -All"
    Write-Host "  .\sync-all-projects-secure.ps1 -All -Force"
    exit 0
}

# Relatorio final
Write-Host ""
Write-Host "RELATORIO DE SINCRONIZACAO:" -ForegroundColor Green
Write-Host "=" * 30 -ForegroundColor Gray

$Success = 0
$Failed = 0

foreach ($Project in $Results.Keys) {
    $Status = if ($Results[$Project]) { "SUCESSO" } else { "FALHA" }
    $Color = if ($Results[$Project]) { "Green" } else { "Red" }

    Write-Host "$Project`: $Status" -ForegroundColor $Color

    if ($Results[$Project]) { $Success++ } else { $Failed++ }
}

Write-Host ""
Write-Host "TOTAL: $Success sucessos, $Failed falhas" -ForegroundColor $(if ($Failed -eq 0) { "Green" } else { "Yellow" })

# Codigo de saida
if ($Failed -gt 0) { exit 1 } else { exit 0 }
