# Script de validação para sincronização
# GRUPO US VIBECODE SYSTEM V4.0

function Write-Status {
    param(
        [string]$Message,
        [string]$Type = "info"
    )

    $colors = @{
        "info" = "Cyan"
        "success" = "Green"
        "warning" = "Yellow"
        "error" = "Red"
    }

    $color = $colors[$Type]
    Write-Host "`n[$Type] $Message" -ForegroundColor $color
}

function Test-Environment {
    Write-Status "🔍 Validando ambiente..." "info"

    # Verifica diretório
    $currentDir = Get-Location
    if (-not $currentDir.Path.Contains("GRUPOUS\VSCODE")) {
        Write-Status "❌ Diretório incorreto" "error"
        Write-Status "Execute este script em C:\Users\Admin\OneDrive\GRUPOUS\VSCODE" "warning"
        return $false
    }

    # Verifica Git
    try {
        $gitVersion = git --version
        Write-Status "✅ Git instalado: $gitVersion" "success"
    } catch {
        Write-Status "❌ Git não está instalado" "error"
        return $false
    }

    # Verifica repositório
    if (-not (Test-Path ".git")) {
        Write-Status "❌ Este diretório não é um repositório Git" "error"
        return $false
    }

    # Verifica git-secrets
    try {
        $gitSecrets = wsl git secrets --version 2>$null
        if (-not $?) {
            Write-Status "❌ git-secrets não está instalado" "error"
            Write-Status "Execute .\setup-git-secrets.ps1 primeiro" "warning"
            return $false
        }
        Write-Status "✅ git-secrets instalado" "success"
    } catch {
        Write-Status "❌ Erro ao verificar git-secrets" "error"
        return $false
    }

    # Verifica WSL
    try {
        $wslStatus = wsl --status 2>$null
        if (-not $?) {
            Write-Status "❌ WSL não está instalado" "error"
            Write-Status "Instale o WSL para continuar" "warning"
            return $false
        }
        Write-Status "✅ WSL instalado" "success"
    } catch {
        Write-Status "❌ Erro ao verificar WSL" "error"
        return $false
    }

    # Verifica arquivos .env
    $envFiles = Get-ChildItem -Path "@project-core/env" -Filter ".env" -File
    if ($envFiles) {
        Write-Status "❌ Arquivos .env detectados no repositório" "error"
        Write-Status "Remova os arquivos .env antes de continuar" "warning"
        return $false
    }
    Write-Status "✅ Nenhum arquivo .env detectado" "success"

    # Verifica secrets
    $secretsCheck = wsl git secrets --scan
    if ($LASTEXITCODE -ne 0) {
        Write-Status "❌ Secrets detectados nos arquivos" "error"
        Write-Status "Remova os secrets antes de continuar" "warning"
        return $false
    }
    Write-Status "✅ Nenhum secret detectado" "success"

    # Verifica branch
    $currentBranch = git rev-parse --abbrev-ref HEAD
    if ($currentBranch -ne "clean-final") {
        Write-Status "⚠️ Branch atual: $currentBranch" "warning"
        Write-Status "Recomendado: Mude para o branch clean-final" "warning"
    } else {
        Write-Status "✅ Branch correto: clean-final" "success"
    }

    Write-Status "✨ Validação concluída" "success"
    return $true
}

# Execução principal
try {
    if (Test-Environment) {
        Write-Status "`n✅ Ambiente validado com sucesso!" "success"
        Write-Status "Você pode prosseguir com a sincronização usando:" "info"
        Write-Status ".\sync-github-auto.ps1" "info"
    } else {
        Write-Status "`n❌ Validação falhou" "error"
        Write-Status "Corrija os problemas acima antes de prosseguir" "warning"
        exit 1
    }
} catch {
    Write-Status "❌ Erro fatal: $_" "error"
    exit 1
}
