# VIBECODE SYSTEM V4.0 - Comando !syncgithub
# Wrapper para sincronizacao multi-projetos GitHub com recursos avancados

param(
    [switch]$Force,
    [switch]$DryRun,
    [string]$Project = "",
    [switch]$All,
    [switch]$Help,
    [string]$Message = "",
    [switch]$Advanced,
    [switch]$SkipSecurity,
    [switch]$SkipBackup,
    [switch]$Verbose
)

$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"

# Funcao para mostrar ajuda
function Show-Help {
    Write-Host "VIBECODE SYSTEM V4.0 - Comando !syncgithub" -ForegroundColor Cyan
    Write-Host "=" * 60 -ForegroundColor Cyan
    Write-Host ""
    Write-Host "SINTAXE:" -ForegroundColor Yellow
    Write-Host "  !syncgithub [opcoes]" -ForegroundColor White
    Write-Host ""
    Write-Host "OPCOES:" -ForegroundColor Yellow
    Write-Host "  -All              Sincronizar todos os projetos" -ForegroundColor White
    Write-Host "  -Project <nome>   Sincronizar projeto especifico" -ForegroundColor White
    Write-Host "  -Force            Forcar push (--force-with-lease)" -ForegroundColor White
    Write-Host "  -DryRun           Simular execucao sem mudancas" -ForegroundColor White
    Write-Host "  -Message <msg>    Mensagem personalizada de commit" -ForegroundColor White
    Write-Host "  -Advanced         Usar modo avancado (logging, backup, seguranca)" -ForegroundColor White
    Write-Host "  -SkipSecurity     Pular validacao de seguranca (modo avancado)" -ForegroundColor White
    Write-Host "  -SkipBackup       Pular backup automatico (modo avancado)" -ForegroundColor White
    Write-Host "  -Verbose          Saida detalhada" -ForegroundColor White
    Write-Host "  -Help             Mostrar esta ajuda" -ForegroundColor White
    Write-Host ""
    Write-Host "PROJETOS DISPONIVEIS:" -ForegroundColor Yellow
    Write-Host "  neonpro        - Sistema principal" -ForegroundColor White
    Write-Host "  aegiswallet    - Carteira digital" -ForegroundColor White
    Write-Host "  agendatrintae3 - Sistema de agendamento" -ForegroundColor White
    Write-Host ""
    Write-Host "EXEMPLOS:" -ForegroundColor Yellow
    Write-Host "  !syncgithub -All" -ForegroundColor Gray
    Write-Host "  !syncgithub -Project neonpro" -ForegroundColor Gray
    Write-Host "  !syncgithub -Project aegiswallet -Force" -ForegroundColor Gray
    Write-Host "  !syncgithub -All -DryRun" -ForegroundColor Gray
    Write-Host "  !syncgithub -All -Advanced" -ForegroundColor Gray
    Write-Host "  !syncgithub -Project neonpro -Advanced -Verbose" -ForegroundColor Gray
    Write-Host ""
    Write-Host "REPOSITORIOS:" -ForegroundColor Yellow
    Write-Host "  neonpro        -> https://github.com/GrupoUS/neonpro" -ForegroundColor Gray
    Write-Host "  aegiswallet    -> https://github.com/GrupoUS/aegiswallet" -ForegroundColor Gray
    Write-Host "  agendatrintae3 -> https://github.com/GrupoUS/agendatrintae3" -ForegroundColor Gray
    Write-Host ""
}

# Mostrar ajuda se solicitado
if ($Help) {
    Show-Help
    exit 0
}

# Verificar se nenhuma opcao foi especificada
if (-not $All -and -not $Project) {
    Write-Host "Como voce gostaria de sincronizar?" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Todos os projetos (-All)" -ForegroundColor Cyan
    Write-Host "2. Projeto especifico (-Project <nome>)" -ForegroundColor Cyan
    Write-Host "3. Ver ajuda (-Help)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Exemplo: !syncgithub -All" -ForegroundColor Gray
    Write-Host "Exemplo: !syncgithub -Project neonpro" -ForegroundColor Gray
    exit 0
}

# Preparar parametros para o script de sincronizacao
$syncParams = @{}

# Determinar parametros baseado na opcao
if ($All) {
    Write-Host "SINCRONIZACAO DE TODOS OS PROJETOS" -ForegroundColor Magenta
    $syncParams.All = $true
} elseif ($Project) {
    Write-Host "SINCRONIZACAO DO PROJETO: $Project" -ForegroundColor Magenta
    $syncParams.ProjectName = $Project
}

if ($Force) { $syncParams.Force = $true }
if ($DryRun) { $syncParams.DryRun = $true }
if ($Message) { $syncParams.Message = $Message }
if ($SkipSecurity) { $syncParams.SkipSecurity = $true }
if ($SkipBackup) { $syncParams.SkipBackup = $true }
if ($Verbose) { $syncParams.Verbose = $true }

# Executar script de sincronizacao
$scriptName = if ($Advanced) { "syncgithub-enhanced.ps1" } else { "syncgithub-simple.ps1" }
$scriptPath = Join-Path $SystemRootPath $scriptName

if (Test-Path $scriptPath) {
    $modeText = if ($Advanced) { "MELHORADA" } else { "SIMPLES" }
    Write-Host "Executando sincronizacao $modeText..." -ForegroundColor Green
    Write-Host ""

    & $scriptPath @syncParams
    $exitCode = $LASTEXITCODE

    Write-Host ""
    if ($exitCode -eq 0) {
        Write-Host "Sincronizacao concluida com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "Sincronizacao falhou com codigo: $exitCode" -ForegroundColor Red
    }

    exit $exitCode
} else {
    Write-Error "Script de sincronizacao nao encontrado: $scriptPath"
    exit 1
}
