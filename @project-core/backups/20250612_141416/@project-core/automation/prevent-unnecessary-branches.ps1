# VIBECODE SYSTEM V4.0 - Prevenção de Branches Desnecessários
# Script para configurar Git e evitar criação de branches desnecessários

param(
    [switch]$Global,
    [switch]$Local,
    [switch]$Reset
)

$DefaultBranch = "clean-final"
$RepositoryUrl = "https://github.com/GrupoUS/VSCODE.git"

Write-Host "VIBECODE SYSTEM V4.0 - Configuração Anti-Branches Desnecessários" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

if ($Reset) {
    Write-Host "`nResetando configurações Git..." -ForegroundColor Yellow
    
    # Reset configurações globais
    git config --global --unset init.defaultBranch 2>$null
    git config --global --unset push.default 2>$null
    git config --global --unset branch.autosetupmerge 2>$null
    git config --global --unset branch.autosetuprebase 2>$null
    git config --global --unset pull.rebase 2>$null
    git config --global --unset merge.ff 2>$null
    
    # Reset configurações locais
    git config --unset init.defaultBranch 2>$null
    git config --unset push.default 2>$null
    git config --unset branch.autosetupmerge 2>$null
    git config --unset branch.autosetuprebase 2>$null
    git config --unset pull.rebase 2>$null
    git config --unset merge.ff 2>$null
    
    Write-Host "Configurações resetadas!" -ForegroundColor Green
    exit 0
}

# Configurações globais (aplicam a todos os repositórios)
if ($Global -or (-not $Local)) {
    Write-Host "`nConfigurando Git globalmente..." -ForegroundColor Yellow
    
    # Branch padrão sempre clean-final
    git config --global init.defaultBranch $DefaultBranch
    Write-Host "✓ Branch padrão definido como: $DefaultBranch" -ForegroundColor Green
    
    # Push simples (apenas branch atual)
    git config --global push.default simple
    Write-Host "✓ Push configurado para modo simples" -ForegroundColor Green
    
    # Auto-setup de merge e rebase
    git config --global branch.autosetupmerge always
    git config --global branch.autosetuprebase always
    Write-Host "✓ Auto-setup de merge/rebase configurado" -ForegroundColor Green
    
    # Pull com rebase por padrão
    git config --global pull.rebase true
    Write-Host "✓ Pull com rebase habilitado" -ForegroundColor Green
    
    # Merge fast-forward only
    git config --global merge.ff only
    Write-Host "✓ Merge fast-forward only configurado" -ForegroundColor Green
    
    # Configurações adicionais para evitar branches
    git config --global advice.detachedHead false
    git config --global advice.pushNonFastForward false
    git config --global advice.statusHints false
    Write-Host "✓ Avisos desnecessários desabilitados" -ForegroundColor Green
}

# Configurações locais (apenas para este repositório)
if ($Local -or (-not $Global)) {
    Write-Host "`nConfigurando Git localmente..." -ForegroundColor Yellow
    
    # Verificar se estamos em um repositório Git
    if (-not (Test-Path ".git")) {
        Write-Host "ERRO: Não é um repositório Git" -ForegroundColor Red
        exit 1
    }
    
    # Configurações locais
    git config init.defaultBranch $DefaultBranch
    git config push.default simple
    git config branch.autosetupmerge always
    git config branch.autosetuprebase always
    git config pull.rebase true
    git config merge.ff only
    
    # Configurar remote se necessário
    $currentRemote = git remote get-url origin 2>$null
    if ($currentRemote -ne $RepositoryUrl) {
        Write-Host "Configurando remote URL..." -ForegroundColor Yellow
        git remote set-url origin $RepositoryUrl
    }
    
    # Verificar branch atual
    $currentBranch = git branch --show-current
    if ($currentBranch -ne $DefaultBranch) {
        Write-Host "AVISO: Branch atual é '$currentBranch', deveria ser '$DefaultBranch'" -ForegroundColor Yellow
        Write-Host "Execute: git checkout $DefaultBranch" -ForegroundColor White
    }
    
    Write-Host "✓ Configurações locais aplicadas" -ForegroundColor Green
}

# Criar hook pre-commit para prevenir branches desnecessários
Write-Host "`nConfigurando hooks Git..." -ForegroundColor Yellow

$hookDir = ".git/hooks"
$preCommitHook = "$hookDir/pre-commit"

if (-not (Test-Path $hookDir)) {
    New-Item -ItemType Directory -Path $hookDir -Force | Out-Null
}

$hookContent = @"
#!/bin/sh
# VIBECODE SYSTEM V4.0 - Pre-commit Hook
# Previne commits em branches que não sejam o default

DEFAULT_BRANCH="$DefaultBranch"
CURRENT_BRANCH=`$(git branch --show-current)

if [ "`$CURRENT_BRANCH" != "`$DEFAULT_BRANCH" ]; then
    echo "ERRO: Commits só são permitidos no branch '$DefaultBranch'"
    echo "Branch atual: `$CURRENT_BRANCH"
    echo "Execute: git checkout $DefaultBranch"
    exit 1
fi

exit 0
"@

Set-Content -Path $preCommitHook -Value $hookContent -Encoding UTF8
Write-Host "✓ Hook pre-commit criado" -ForegroundColor Green

# Tornar o hook executável (no Windows isso é automático)
if ($IsLinux -or $IsMacOS) {
    chmod +x $preCommitHook
}

# Criar alias úteis
Write-Host "`nConfigurando aliases Git..." -ForegroundColor Yellow

git config --global alias.sync "!git add . && git commit -m 'Sync: $(date)' && git push origin $DefaultBranch"
git config --global alias.safe-push "push origin $DefaultBranch"
git config --global alias.check-branch "!git branch --show-current"
git config --global alias.force-default "checkout $DefaultBranch"

Write-Host "✓ Aliases configurados:" -ForegroundColor Green
Write-Host "   git sync          - Adiciona, commita e faz push" -ForegroundColor White
Write-Host "   git safe-push     - Push seguro para branch default" -ForegroundColor White
Write-Host "   git check-branch  - Mostra branch atual" -ForegroundColor White
Write-Host "   git force-default - Força mudança para branch default" -ForegroundColor White

# Verificar configurações
Write-Host "`nVerificando configurações..." -ForegroundColor Yellow

$configs = @(
    "init.defaultBranch",
    "push.default",
    "branch.autosetupmerge",
    "branch.autosetuprebase",
    "pull.rebase",
    "merge.ff"
)

foreach ($config in $configs) {
    $globalValue = git config --global $config 2>$null
    $localValue = git config $config 2>$null
    
    $value = if ($localValue) { $localValue } else { $globalValue }
    
    if ($value) {
        Write-Host "✓ $config = $value" -ForegroundColor Green
    } else {
        Write-Host "✗ $config não configurado" -ForegroundColor Red
    }
}

Write-Host "`nConfiguração concluída!" -ForegroundColor Cyan
Write-Host "Agora o Git está configurado para:" -ForegroundColor White
Write-Host "• Sempre usar o branch '$DefaultBranch' como padrão" -ForegroundColor White
Write-Host "• Prevenir criação de branches desnecessários" -ForegroundColor White
Write-Host "• Fazer push apenas para o branch correto" -ForegroundColor White
Write-Host "• Usar rebase em vez de merge por padrão" -ForegroundColor White

Write-Host "`nPara usar:" -ForegroundColor Yellow
Write-Host "• git sync                    - Sincronização rápida" -ForegroundColor White
Write-Host "• git force-default           - Voltar ao branch correto" -ForegroundColor White
Write-Host "• git check-branch            - Verificar branch atual" -ForegroundColor White
