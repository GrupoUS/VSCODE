# VIBECODE SYSTEM V4.0 - Sincronização Repositório Principal VSCODE
# Script para sincronizar o repositório principal com branch default clean-final

param(
    [switch]$Force,
    [switch]$DryRun,
    [string]$Message = "",
    [switch]$CleanBranches
)

$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$DefaultBranch = "clean-final"
$RepositoryUrl = "https://github.com/GrupoUS/VSCODE.git"

Write-Host "VIBECODE SYSTEM V4.0 - Sincronização Repositório Principal" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# Navegar para o diretório raiz
Set-Location $SystemRootPath

# Verificar se é um repositório git
if (-not (Test-Path ".git")) {
    Write-Host "Inicializando repositório Git..." -ForegroundColor Yellow
    git init
    git remote add origin $RepositoryUrl
}

# Verificar remote
$currentRemote = git remote get-url origin 2>$null
if ($currentRemote -ne $RepositoryUrl) {
    Write-Host "Atualizando remote URL..." -ForegroundColor Yellow
    git remote set-url origin $RepositoryUrl
}

Write-Host "Repositório: $RepositoryUrl" -ForegroundColor Green
Write-Host "Branch Default: $DefaultBranch" -ForegroundColor Green

# Verificar branch atual
$currentBranch = git branch --show-current
Write-Host "Branch Atual: $currentBranch" -ForegroundColor Yellow

# Mudar para o branch default se necessário
if ($currentBranch -ne $DefaultBranch) {
    Write-Host "Mudando para branch default: $DefaultBranch" -ForegroundColor Yellow

    # Verificar se o branch existe localmente
    $branchExists = git branch --list $DefaultBranch
    if (-not $branchExists) {
        # Tentar fazer fetch do branch remoto
        Write-Host "Fazendo fetch do branch remoto..." -ForegroundColor Yellow
        git fetch origin $DefaultBranch

        # Criar branch local baseado no remoto
        git checkout -b $DefaultBranch origin/$DefaultBranch
    } else {
        git checkout $DefaultBranch
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO ao mudar para branch $DefaultBranch" -ForegroundColor Red
        exit 1
    }
}

# Limpar branches desnecessários se solicitado
if ($CleanBranches) {
    Write-Host "`nLimpando branches desnecessários..." -ForegroundColor Yellow

    # Listar todos os branches locais exceto o default
    $localBranches = git branch --format="%(refname:short)" | Where-Object { $_ -ne $DefaultBranch -and $_ -ne "main" -and $_ -ne "master" }

    if ($localBranches) {
        Write-Host "Branches a serem removidos:" -ForegroundColor Red
        $localBranches | ForEach-Object { Write-Host "   - $_" -ForegroundColor White }

        if (-not $DryRun) {
            foreach ($branch in $localBranches) {
                Write-Host "Removendo branch: $branch" -ForegroundColor Yellow
                git branch -D $branch
            }
        } else {
            Write-Host "DRY RUN - Branches não foram removidos" -ForegroundColor Magenta
        }
    } else {
        Write-Host "Nenhum branch desnecessário encontrado" -ForegroundColor Green
    }
}

# Verificar status do git
Write-Host "`nVerificando status..." -ForegroundColor Yellow
$gitStatus = git status --porcelain

if ($gitStatus) {
    Write-Host "Mudanças detectadas:" -ForegroundColor Yellow
    $gitStatus | ForEach-Object { Write-Host "   $_" -ForegroundColor White }

    if ($DryRun) {
        Write-Host "`nDRY RUN - Comandos que seriam executados:" -ForegroundColor Magenta
        Write-Host "   git add ." -ForegroundColor Gray
        Write-Host "   git commit -m '...'" -ForegroundColor Gray
        Write-Host "   git push origin $DefaultBranch" -ForegroundColor Gray
        exit 0
    }

    # Preparar mensagem de commit
    $commitMessage = if ($Message) {
        $Message
    } else {
        "[VSCODE] Sincronização automática repositório principal - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    }

    # Adicionar arquivos
    Write-Host "`nAdicionando arquivos..." -ForegroundColor Yellow
    git add .

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO ao adicionar arquivos" -ForegroundColor Red
        exit 1
    }

    # Fazer commit
    Write-Host "Fazendo commit..." -ForegroundColor Yellow
    git commit -m $commitMessage

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO ao fazer commit" -ForegroundColor Red
        exit 1
    }

    # Fazer push
    Write-Host "Fazendo push para GitHub..." -ForegroundColor Yellow
    if ($Force) {
        git push origin $DefaultBranch --force-with-lease
    } else {
        git push origin $DefaultBranch
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO ao fazer push" -ForegroundColor Red
        exit 1
    }

    Write-Host "SUCESSO: Repositório principal sincronizado!" -ForegroundColor Green

} else {
    Write-Host "Nenhuma mudança detectada - repositório já sincronizado" -ForegroundColor Green
}

# Configurar Git para sempre usar o branch default
Write-Host "`nConfigurando Git para usar branch default..." -ForegroundColor Yellow
git config branch.autosetupmerge always
git config branch.autosetuprebase always
git config push.default simple

# Configurar para evitar criação de branches desnecessários
git config --global init.defaultBranch clean-final
git config --global pull.rebase true
git config --global merge.ff only

# Sincronizar repositório principal VSCODE
Write-Host "`nSincronizando repositório principal VSCODE..." -ForegroundColor Yellow
$gitStatus = git status --porcelain

if ($gitStatus) {
    Write-Host "Mudanças detectadas no repositório principal:" -ForegroundColor Yellow
    $gitStatus | ForEach-Object { Write-Host "   $_" -ForegroundColor White }

    if (-not $DryRun) {
        # Preparar mensagem de commit para o repositório principal
        $mainCommitMessage = if ($Message) {
            $Message
        } else {
            "[VSCODE] Sincronização repositório principal - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        }

        # Adicionar, commit e push do repositório principal
        Write-Host "Adicionando arquivos do repositório principal..." -ForegroundColor Yellow
        git add .

        Write-Host "Fazendo commit do repositório principal..." -ForegroundColor Yellow
        git commit -m $mainCommitMessage

        Write-Host "Fazendo push do repositório principal..." -ForegroundColor Yellow
        if ($Force) {
            git push origin $DefaultBranch --force-with-lease
        } else {
            git push origin $DefaultBranch
        }

        if ($LASTEXITCODE -eq 0) {
            Write-Host "SUCESSO: Repositório principal VSCODE sincronizado!" -ForegroundColor Green
        } else {
            Write-Host "ERRO ao sincronizar repositório principal" -ForegroundColor Red
        }
    } else {
        Write-Host "DRY RUN - Repositório principal não foi sincronizado" -ForegroundColor Magenta
    }
} else {
    Write-Host "Nenhuma mudança detectada no repositório principal" -ForegroundColor Green
}

Write-Host "`nSincronização do repositório principal finalizada!" -ForegroundColor Cyan
