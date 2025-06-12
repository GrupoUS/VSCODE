# VIBECODE SYSTEM V4.0 - Monitor de Sincronizacao
# Script para monitorar e gerar estatisticas das operacoes de sincronizacao

param(
    [switch]$Stats,
    [switch]$Logs,
    [switch]$Backups,
    [switch]$Health,
    [switch]$All,
    [int]$LastHours = 24,
    [string]$Project = ""
)

$SystemRootPath = "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
$LogPath = "@project-core\logs\sync-operations.log"
$BackupPath = "@project-core\backups"

Write-Host "VIBECODE SYSTEM V4.0 - Monitor de Sincronizacao" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

# Funcao para obter estatisticas dos logs
function Get-SyncStats {
    param(
        [int]$Hours = 24,
        [string]$ProjectFilter = ""
    )

    $fullLogPath = Join-Path $SystemRootPath $LogPath

    if (-not (Test-Path $fullLogPath)) {
        Write-Host "Arquivo de log nao encontrado: $fullLogPath" -ForegroundColor Red
        return
    }

    Write-Host "`nESTATISTICAS DE SINCRONIZACAO (Ultimas $Hours horas)" -ForegroundColor Yellow
    Write-Host "=" * 50 -ForegroundColor Gray

    $cutoffTime = (Get-Date).AddHours(-$Hours)
    $logContent = Get-Content $fullLogPath

    $stats = @{
        TotalLines = 0
        INFO = 0
        WARNING = 0
        ERROR = 0
        CRITICAL = 0
        Projects = @{}
        Operations = @{}
    }

    foreach ($line in $logContent) {
        if ($line -match '^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] \[(\w+)\] \[(\w+)\](.*)') {
            try {
                $logTime = [DateTime]::ParseExact($matches[1], "yyyy-MM-dd HH:mm:ss", $null)
                $level = $matches[2]
                $project = $matches[3]
                $message = $matches[4].Trim()

                if ($logTime -ge $cutoffTime) {
                    if (-not $ProjectFilter -or $project -eq $ProjectFilter) {
                        $stats.TotalLines++
                        $stats[$level]++

                        if (-not $stats.Projects.ContainsKey($project)) {
                            $stats.Projects[$project] = 0
                        }
                        $stats.Projects[$project]++

                        # Extrair operacao se presente
                        if ($message -match '\[(\w+)\]') {
                            $operation = $matches[1]
                            if (-not $stats.Operations.ContainsKey($operation)) {
                                $stats.Operations[$operation] = 0
                            }
                            $stats.Operations[$operation]++
                        }
                    }
                }
            }
            catch {
                # Ignorar linhas com formato invalido
            }
        }
    }

    # Exibir estatisticas
    Write-Host "Total de entradas: $($stats.TotalLines)" -ForegroundColor White
    Write-Host "INFO: $($stats.INFO)" -ForegroundColor Green
    Write-Host "WARNING: $($stats.WARNING)" -ForegroundColor Yellow
    Write-Host "ERROR: $($stats.ERROR)" -ForegroundColor Red
    Write-Host "CRITICAL: $($stats.CRITICAL)" -ForegroundColor Magenta

    if ($stats.Projects.Count -gt 0) {
        Write-Host "`nAtividade por Projeto:" -ForegroundColor Yellow
        $stats.Projects.GetEnumerator() | Sort-Object Value -Descending | ForEach-Object {
            Write-Host "  $($_.Key): $($_.Value) entradas" -ForegroundColor White
        }
    }

    if ($stats.Operations.Count -gt 0) {
        Write-Host "`nOperacoes Mais Frequentes:" -ForegroundColor Yellow
        $stats.Operations.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5 | ForEach-Object {
            Write-Host "  $($_.Key): $($_.Value) vezes" -ForegroundColor White
        }
    }
}

# Funcao para exibir logs recentes
function Show-RecentLogs {
    param(
        [int]$Hours = 24,
        [string]$ProjectFilter = ""
    )

    $fullLogPath = Join-Path $SystemRootPath $LogPath

    if (-not (Test-Path $fullLogPath)) {
        Write-Host "Arquivo de log nao encontrado: $fullLogPath" -ForegroundColor Red
        return
    }

    Write-Host "`nLOGS RECENTES (Ultimas $Hours horas)" -ForegroundColor Yellow
    Write-Host "=" * 50 -ForegroundColor Gray

    $cutoffTime = (Get-Date).AddHours(-$Hours)
    $logContent = Get-Content $fullLogPath
    $recentLogs = @()

    foreach ($line in $logContent) {
        if ($line -match '^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] \[(\w+)\] \[(\w+)\]') {
            try {
                $logTime = [DateTime]::ParseExact($matches[1], "yyyy-MM-dd HH:mm:ss", $null)
                $level = $matches[2]
                $project = $matches[3]

                if ($logTime -ge $cutoffTime) {
                    if (-not $ProjectFilter -or $project -eq $ProjectFilter) {
                        $recentLogs += $line
                    }
                }
            }
            catch {
                # Ignorar linhas com formato invalido
            }
        }
    }

    # Exibir ultimas 20 entradas
    $recentLogs | Select-Object -Last 20 | ForEach-Object {
        $color = "White"
        if ($_ -match '\[ERROR\]') { $color = "Red" }
        elseif ($_ -match '\[WARNING\]') { $color = "Yellow" }
        elseif ($_ -match '\[CRITICAL\]') { $color = "Magenta" }
        elseif ($_ -match '\[INFO\]') { $color = "Green" }

        Write-Host $_ -ForegroundColor $color
    }
}

# Funcao para listar backups
function Show-Backups {
    $fullBackupPath = Join-Path $SystemRootPath $BackupPath

    if (-not (Test-Path $fullBackupPath)) {
        Write-Host "Diretorio de backup nao encontrado: $fullBackupPath" -ForegroundColor Red
        return
    }

    Write-Host "`nBACKUPS DISPONIVEIS" -ForegroundColor Yellow
    Write-Host "=" * 50 -ForegroundColor Gray

    $backups = Get-ChildItem $fullBackupPath -Directory | Sort-Object CreationTime -Descending

    if ($backups.Count -eq 0) {
        Write-Host "Nenhum backup encontrado" -ForegroundColor Gray
        return
    }

    foreach ($backup in $backups) {
        $size = (Get-ChildItem $backup.FullName -Recurse -File | Measure-Object -Property Length -Sum).Sum
        $sizeText = if ($size -gt 1MB) {
            "$([math]::Round($size/1MB, 2)) MB"
        } else {
            "$([math]::Round($size/1KB, 2)) KB"
        }

        $age = (Get-Date) - $backup.CreationTime
        $ageText = if ($age.Days -gt 0) {
            "$($age.Days) dias"
        } elseif ($age.Hours -gt 0) {
            "$($age.Hours) horas"
        } else {
            "$($age.Minutes) minutos"
        }

        Write-Host "$($backup.Name)" -ForegroundColor White
        Write-Host "  Criado: $($backup.CreationTime.ToString('yyyy-MM-dd HH:mm:ss')) ($ageText atras)" -ForegroundColor Gray
        Write-Host "  Tamanho: $sizeText" -ForegroundColor Gray
        Write-Host ""
    }
}

# Funcao para verificar saude do sistema
function Test-SystemHealth {
    Write-Host "`nVERIFICACAO DE SAUDE DO SISTEMA" -ForegroundColor Yellow
    Write-Host "=" * 50 -ForegroundColor Gray

    $health = @{
        LogFile = $false
        BackupDir = $false
        Projects = @{}
        GitConnectivity = $false
    }

    # Verificar arquivo de log
    $fullLogPath = Join-Path $SystemRootPath $LogPath
    $health.LogFile = Test-Path $fullLogPath
    $status = if ($health.LogFile) { "OK" } else { "FALHA" }
    $color = if ($health.LogFile) { "Green" } else { "Red" }
    Write-Host "Arquivo de log: $status" -ForegroundColor $color

    # Verificar diretorio de backup
    $fullBackupPath = Join-Path $SystemRootPath $BackupPath
    $health.BackupDir = Test-Path $fullBackupPath
    $status = if ($health.BackupDir) { "OK" } else { "FALHA" }
    $color = if ($health.BackupDir) { "Green" } else { "Red" }
    Write-Host "Diretorio de backup: $status" -ForegroundColor $color

    # Verificar projetos
    $projects = @("neonpro", "aegiswallet", "agendatrintae3")
    foreach ($project in $projects) {
        $projectPath = Join-Path $SystemRootPath "@project-core\projects\$project"
        $health.Projects[$project] = Test-Path $projectPath
        $status = if ($health.Projects[$project]) { "OK" } else { "FALHA" }
        $color = if ($health.Projects[$project]) { "Green" } else { "Red" }
        Write-Host "Projeto $project : $status" -ForegroundColor $color
    }

    # Verificar conectividade com GitHub
    try {
        $response = Invoke-WebRequest -Uri "https://api.github.com" -TimeoutSec 5 -UseBasicParsing
        $health.GitConnectivity = ($response.StatusCode -eq 200)
    }
    catch {
        $health.GitConnectivity = $false
    }

    $status = if ($health.GitConnectivity) { "OK" } else { "FALHA" }
    $color = if ($health.GitConnectivity) { "Green" } else { "Red" }
    Write-Host "Conectividade GitHub: $status" -ForegroundColor $color

    # Resumo geral
    $totalChecks = 3 + $projects.Count + 1
    $passedChecks = 0
    if ($health.LogFile) { $passedChecks++ }
    if ($health.BackupDir) { $passedChecks++ }
    if ($health.GitConnectivity) { $passedChecks++ }
    $passedChecks += ($health.Projects.Values | Where-Object { $_ }).Count

    $healthPercentage = [math]::Round(($passedChecks / $totalChecks) * 100, 1)

    Write-Host "`nSAUDE GERAL DO SISTEMA: $healthPercentage%" -ForegroundColor $(
        if ($healthPercentage -ge 90) { "Green" }
        elseif ($healthPercentage -ge 70) { "Yellow" }
        else { "Red" }
    )
}

# Executar baseado nos parametros
if ($All) {
    Get-SyncStats -Hours $LastHours -ProjectFilter $Project
    Show-RecentLogs -Hours $LastHours -ProjectFilter $Project
    Show-Backups
    Test-SystemHealth
}
elseif ($Stats) {
    Get-SyncStats -Hours $LastHours -ProjectFilter $Project
}
elseif ($Logs) {
    Show-RecentLogs -Hours $LastHours -ProjectFilter $Project
}
elseif ($Backups) {
    Show-Backups
}
elseif ($Health) {
    Test-SystemHealth
}
else {
    Write-Host "Uso: sync-monitor.ps1 [-Stats] [-Logs] [-Backups] [-Health] [-All]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opcoes:" -ForegroundColor White
    Write-Host "  -Stats      Mostrar estatisticas de sincronizacao" -ForegroundColor Gray
    Write-Host "  -Logs       Mostrar logs recentes" -ForegroundColor Gray
    Write-Host "  -Backups    Listar backups disponiveis" -ForegroundColor Gray
    Write-Host "  -Health     Verificar saude do sistema" -ForegroundColor Gray
    Write-Host "  -All        Mostrar tudo" -ForegroundColor Gray
    Write-Host "  -LastHours  Numero de horas para analise (padrao: 24)" -ForegroundColor Gray
    Write-Host "  -Project    Filtrar por projeto especifico" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Exemplos:" -ForegroundColor White
    Write-Host "  sync-monitor.ps1 -Stats" -ForegroundColor Gray
    Write-Host "  sync-monitor.ps1 -All -LastHours 48" -ForegroundColor Gray
    Write-Host "  sync-monitor.ps1 -Logs -Project neonpro" -ForegroundColor Gray
}
