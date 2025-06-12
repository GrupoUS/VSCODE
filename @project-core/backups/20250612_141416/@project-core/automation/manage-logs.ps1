# GRUPO US VIBECODE SYSTEM V4.5 - Log Manager
# Script para gerenciar os logs do sistema

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("list", "show", "clear", "archive", "analyze", "stats")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$LogName,

    [Parameter(Mandatory=$false)]
    [string]$Date,

    [Parameter(Mandatory=$false)]
    [string]$ArchivePath,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$LOGS_PATH = "@project-core/logs"
$ARCHIVE_PATH = "@project-core/logs/archive"
$MAX_LOG_AGE_DAYS = 30
$MAX_ARCHIVE_AGE_DAYS = 365

# Função para listar logs disponíveis
function List-Logs {
    Write-Host "`n📋 Available Logs:`n"

    # Listar logs ativos
    Write-Host "Active Logs:"
    Get-ChildItem -Path $LOGS_PATH -Filter "*.log" | ForEach-Object {
        $logInfo = Get-Item $_.FullName
        Write-Host "  " + $_.Name
        Write-Host "    Size: " + [math]::Round($logInfo.Length / 1KB, 2) + " KB"
        Write-Host "    Last Modified: " + $logInfo.LastWriteTime
        Write-Host ""
    }

    # Listar logs arquivados
    if (Test-Path $ARCHIVE_PATH) {
        Write-Host "Archived Logs:"
        Get-ChildItem -Path $ARCHIVE_PATH -Filter "*.log" | ForEach-Object {
            $logInfo = Get-Item $_.FullName
            Write-Host "  " + $_.Name
            Write-Host "    Size: " + [math]::Round($logInfo.Length / 1KB, 2) + " KB"
            Write-Host "    Archived: " + $logInfo.LastWriteTime
            Write-Host ""
        }
    }
}

# Função para mostrar conteúdo de um log
function Show-Log {
    param(
        [string]$logName,
        [string]$date
    )

    if (-not $logName) {
        Write-Error "❌ LogName is required"
        exit 1
    }

    $logPath = Join-Path $LOGS_PATH $logName
    if (-not (Test-Path $logPath)) {
        Write-Error "❌ Log not found: " + $logName
        exit 1
    }

    Write-Host "`n📖 Log Content: " + $logName + "`n"

    if ($date) {
        # Filtrar por data
        $targetDate = [datetime]::ParseExact($date, "yyyy-MM-dd", $null)
        Get-Content $logPath | Where-Object {
            $lineDate = [datetime]::ParseExact($_.Substring(0, 10), "yyyy-MM-dd", $null)
            $lineDate.Date -eq $targetDate.Date
        } | ForEach-Object { Write-Host $_ }
    } else {
        # Mostrar todo o conteúdo
        Get-Content $logPath | ForEach-Object { Write-Host $_ }
    }
}

# Função para limpar logs
function Clear-Logs {
    param([switch]$Force)

    if (-not $Force) {
        $confirmation = Read-Host "⚠️ Are you sure you want to clear all logs? (y/N)"
        if ($confirmation -ne "y") {
            Write-Host "Operation cancelled"
            return
        }
    }

    Write-Host "🧹 Clearing logs..."

    # Limpar logs ativos
    Get-ChildItem -Path $LOGS_PATH -Filter "*.log" | ForEach-Object {
        Clear-Content $_.FullName
        Write-Host "Cleared: " + $_.Name
    }

    Write-Host "✅ Logs cleared successfully"
}

# Função para arquivar logs
function Archive-Logs {
    param(
        [string]$archivePath,
        [switch]$Force
    )

    if (-not $archivePath) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $archivePath = Join-Path $ARCHIVE_PATH "archive_" + $timestamp
    }

    if (-not (Test-Path $archivePath)) {
        New-Item -ItemType Directory -Path $archivePath -Force | Out-Null
    }

    Write-Host "📦 Archiving logs to: " + $archivePath

    # Arquivar logs ativos
    Get-ChildItem -Path $LOGS_PATH -Filter "*.log" | ForEach-Object {
        $archiveFile = Join-Path $archivePath $_.Name
        Copy-Item $_.FullName -Destination $archiveFile
        Write-Host "Archived: " + $_.Name
    }

    # Limpar logs antigos
    if (-not $Force) {
        $oldLogs = Get-ChildItem -Path $LOGS_PATH -Filter "*.log" | Where-Object {
            $_.LastWriteTime -lt (Get-Date).AddDays(-$MAX_LOG_AGE_DAYS)
        }

        if ($oldLogs.Count -gt 0) {
            $confirmation = Read-Host "Found " + $oldLogs.Count + " old logs. Clear them? (y/N)"
            if ($confirmation -eq "y") {
                $oldLogs | ForEach-Object {
                    Remove-Item $_.FullName
                    Write-Host "Removed old log: " + $_.Name
                }
            }
        }
    }

    Write-Host "✅ Logs archived successfully"
}

# Função para analisar logs
function Analyze-Logs {
    param([string]$date)

    Write-Host "`n🔍 Log Analysis:`n"

    # Análise de logs ativos
    Write-Host "Active Logs Analysis:"
    Get-ChildItem -Path $LOGS_PATH -Filter "*.log" | ForEach-Object {
        $logPath = $_.FullName
        $logContent = Get-Content $logPath

        Write-Host "  " + $_.Name

        # Contagem de linhas
        $totalLines = $logContent.Count
        Write-Host "    Total Lines: " + $totalLines

        # Contagem de erros
        $errorCount = ($logContent | Where-Object { $_ -match "ERROR|error|Error" }).Count
        Write-Host "    Errors: " + $errorCount

        # Contagem de avisos
        $warningCount = ($logContent | Where-Object { $_ -match "WARN|warn|Warn" }).Count
        Write-Host "    Warnings: " + $warningCount

        # Análise por data
        if ($date) {
            $targetDate = [datetime]::ParseExact($date, "yyyy-MM-dd", $null)
            $dateLines = $logContent | Where-Object {
                $_.Substring(0, 10) -eq $date
            }

            Write-Host "    Lines for " + $date + ": " + $dateLines.Count
            Write-Host "    Errors for " + $date + ": " + ($dateLines | Where-Object { $_ -match "ERROR|error|Error" }).Count
            Write-Host "    Warnings for " + $date + ": " + ($dateLines | Where-Object { $_ -match "WARN|warn|Warn" }).Count
        }

        Write-Host ""
    }
}

# Função para mostrar estatísticas dos logs
function Show-LogStats {
    Write-Host "`n📊 Log Statistics:`n"

    # Estatísticas de logs ativos
    $activeLogs = Get-ChildItem -Path $LOGS_PATH -Filter "*.log"
    $totalActiveSize = ($activeLogs | Measure-Object -Property Length -Sum).Sum
    $totalActiveLines = ($activeLogs | ForEach-Object { (Get-Content $_.FullName).Count } | Measure-Object -Sum).Sum

    Write-Host "Active Logs:"
    Write-Host "  Total Files: " + $activeLogs.Count
    Write-Host "  Total Size: " + [math]::Round($totalActiveSize / 1MB, 2) + " MB"
    Write-Host "  Total Lines: " + $totalActiveLines
    Write-Host ""

    # Estatísticas de logs arquivados
    if (Test-Path $ARCHIVE_PATH) {
        $archivedLogs = Get-ChildItem -Path $ARCHIVE_PATH -Filter "*.log" -Recurse
        $totalArchivedSize = ($archivedLogs | Measure-Object -Property Length -Sum).Sum
        $totalArchivedLines = ($archivedLogs | ForEach-Object { (Get-Content $_.FullName).Count } | Measure-Object -Sum).Sum

        Write-Host "Archived Logs:"
        Write-Host "  Total Files: " + $archivedLogs.Count
        Write-Host "  Total Size: " + [math]::Round($totalArchivedSize / 1MB, 2) + " MB"
        Write-Host "  Total Lines: " + $totalArchivedLines
        Write-Host ""
    }

    # Estatísticas de retenção
    $oldActiveLogs = $activeLogs | Where-Object {
        $_.LastWriteTime -lt (Get-Date).AddDays(-$MAX_LOG_AGE_DAYS)
    }

    Write-Host "Retention Status:"
    Write-Host "  Old Active Logs: " + $oldActiveLogs.Count
    Write-Host "  Max Log Age: " + $MAX_LOG_AGE_DAYS + " days"
    Write-Host "  Max Archive Age: " + $MAX_ARCHIVE_AGE_DAYS + " days"
    Write-Host ""
}

# Main execution
switch ($Action) {
    "list" {
        List-Logs
    }
    "show" {
        Show-Log -logName $LogName -date $Date
    }
    "clear" {
        Clear-Logs -Force:$Force
    }
    "archive" {
        Archive-Logs -archivePath $ArchivePath -Force:$Force
    }
    "analyze" {
        Analyze-Logs -date $Date
    }
    "stats" {
        Show-LogStats
    }
    default {
        Write-Host "Usage: .\manage-logs.ps1 [-Action <action>] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  list - List available logs"
        Write-Host "  show - Show log content"
        Write-Host "  clear - Clear all logs"
        Write-Host "  archive - Archive logs"
        Write-Host "  analyze - Analyze logs"
        Write-Host "  stats - Show log statistics"
    }
}
