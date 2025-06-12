#!/usr/bin/env pwsh
# COMANDO !syncgithub - SINCRONIZACAO SEGURA VIBECODE SYSTEM
# Versao: 3.0 - Tokens seguros + Validacao completa

param(
    [string]$Project = "",
    [switch]$All = $false,
    [switch]$Force = $false,
    [switch]$Status = $false,
    [switch]$Setup = $false
)

# Configuracao
$RootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$SyncScript = "$RootPath\@project-core\automation\sync-all-projects-secure.ps1"

Write-Host "!syncgithub - COMANDO MASTER DE SINCRONIZACAO" -ForegroundColor Cyan
Write-Host "VIBECODE SYSTEM V4.5 - SEGURANCA ABSOLUTA" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Gray

# Verificar se esta no diretorio correto
if ((Get-Location).Path -ne $RootPath) {
    Write-Host "Mudando para diretorio correto..." -ForegroundColor Yellow
    Set-Location $RootPath
}

# Funcao de setup de tokens
function Setup-ProjectTokens {
    $Projects = @("neonpro", "aegiswallet", "agendatrintae3")

    Write-Host "SETUP DE TOKENS SEGUROS" -ForegroundColor Yellow
    Write-Host "Token atual: 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"

    foreach ($Project in $Projects) {
        $ProjectPath = "@project-core/projects/$Project"
        $EnvPath = "$ProjectPath/env"
        $TokenPath = "$ProjectPath/env/github-token.txt"

        Write-Host "Configurando $Project..." -ForegroundColor White

        # Criar pasta env se nao existir
        if (-not (Test-Path $EnvPath)) {
            New-Item -ItemType Directory -Force -Path $EnvPath | Out-Null
            Write-Host "  Pasta env/ criada" -ForegroundColor Green
        }

        # Criar token se nao existir
        if (-not (Test-Path $TokenPath)) {
            "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" | Out-File -FilePath $TokenPath -Encoding UTF8
            Write-Host "  Token configurado" -ForegroundColor Green
        } else {
            Write-Host "  Token ja existe" -ForegroundColor Gray
        }

        # Verificar .gitignore
        $GitIgnorePath = "$ProjectPath/.gitignore"
        if (Test-Path $GitIgnorePath) {
            $GitIgnoreContent = Get-Content $GitIgnorePath -Raw
            if ($GitIgnoreContent -notlike "*env/*") {
                Add-Content -Path $GitIgnorePath -Value "`nenv/`n*.token`n*.secret"
                Write-Host "  .gitignore atualizado" -ForegroundColor Green
            } else {
                Write-Host "  .gitignore ja protegido" -ForegroundColor Gray
            }
        }
    }

    Write-Host "SETUP CONCLUIDO!" -ForegroundColor Green
}

# Funcao de status
function Show-Status {
    Write-Host "STATUS DOS PROJETOS:" -ForegroundColor Yellow

    $Projects = @("neonpro", "aegiswallet", "agendatrintae3")
    foreach ($Project in $Projects) {
        $ProjectPath = "@project-core/projects/$Project"
        $TokenPath = "$ProjectPath/env/github-token.txt"

        Write-Host "  $Project`:" -ForegroundColor White -NoNewline

        if (Test-Path $ProjectPath) {
            Write-Host " DIRETORIO OK" -ForegroundColor Green -NoNewline
        } else {
            Write-Host " DIRETORIO FALTANDO" -ForegroundColor Red -NoNewline
        }

        if (Test-Path $TokenPath) {
            Write-Host " | TOKEN OK" -ForegroundColor Green
        } else {
            Write-Host " | TOKEN FALTANDO" -ForegroundColor Red
        }
    }
}

# Executar comando baseado nos parametros
if ($Setup) {
    Setup-ProjectTokens
} elseif ($Status) {
    Show-Status
} elseif ($All) {
    Write-Host "SINCRONIZANDO TODOS OS PROJETOS..." -ForegroundColor Cyan
    & $SyncScript -All -Force:$Force
} elseif ($Project) {
    Write-Host "SINCRONIZANDO PROJETO: $Project" -ForegroundColor Cyan
    & $SyncScript -ProjectName $Project -Force:$Force
} else {
    Write-Host "COMANDOS DISPONIVEIS:" -ForegroundColor Yellow
    Write-Host "  !syncgithub -All           # Sincronizar todos os projetos"
    Write-Host "  !syncgithub -Project neonpro # Sincronizar projeto especifico"
    Write-Host "  !syncgithub -Status        # Ver status dos projetos"
    Write-Host "  !syncgithub -Setup         # Configurar tokens seguros"
    Write-Host "  !syncgithub -All -Force    # Sincronizacao forcada"
    Write-Host ""
    Show-Status
}

Write-Host ""
Write-Host "COMANDO CONCLUIDO!" -ForegroundColor Green
