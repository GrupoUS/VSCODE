# ===============================================================================
# BACKUP SAFETY ENFORCEMENT - SMART BACKUP SYSTEM V4.0 REQUIRED
# ===============================================================================
# WARNING: This script contains backup operations that must use Smart Backup System V4.0
# to prevent recursive backup disasters and enforce size limits.
#
# Use: @project-core/automation/smart-backup-system-v4.ps1 -SourcePath "source" -BackupName "name"
# ===============================================================================
# GRUPO US VIBECODE SYSTEM V4.5 - Backup Manager
# Script para gerenciar os backups do sistema

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("list", "create", "restore", "delete", "verify", "stats")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$BackupName,

    [Parameter(Mandatory=$false)]
    [string]$BackupPath,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$BACKUP_PATH = "@project-core/backups"
$MAX_BACKUP_AGE_DAYS = 30
$MAX_BACKUP_COUNT = 10

# Função para listar backups disponíveis
function List-Backups {
    Write-Host "`n📋 Available Backups:`n"

    if (-not (Test-Path $BACKUP_PATH)) {
        Write-Host "No backups found"
        return
    }

    Get-ChildItem -Path $BACKUP_PATH -Directory | ForEach-Object {
        $backupInfo = Get-Item $_.FullName
        $backupSize = (Get-ChildItem $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum

        Write-Host "  " + $_.Name
        Write-Host "    Size: " + [math]::Round($backupSize / 1MB, 2) + " MB"
        Write-Host "    Created: " + $backupInfo.CreationTime
        Write-Host "    Last Modified: " + $backupInfo.LastWriteTime
        Write-Host ""
    }
}

# Função para criar backup
function Create-Backup {
    param(
        [string]$backupName,
        [switch]$Force
    )

    if (-not $backupName) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupName = "backup_" + $timestamp
    }

    $backupPath = Join-Path $BACKUP_PATH $backupName

    if (Test-Path $backupPath) {
        if (-not $Force) {
            Write-Error "❌ Backup already exists: " + $backupName
            exit 1
        }
        Remove-Item $backupPath -Recurse -Force
    }

    Write-Host "📦 Creating backup: " + $backupName

    # Criar diretório de backup
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

    # Backup da configuração MCP
    $mcpConfigPath = "@project-core/configs/mcp-master-unified.json"
    if (Test-Path $mcpConfigPath) {
        Copy-Item -Path $mcpConfigPath -Destination (Join-Path $backupPath "mcp-config.json")
    }

    # Backup do knowledge graph
    $knowledgeGraphPath = "@project-core/memory/knowledge_graph.json"
    if (Test-Path $knowledgeGraphPath) {
        Copy-Item -Path $knowledgeGraphPath -Destination (Join-Path $backupPath "knowledge-graph.json")
    }

    # Backup dos workflows
    $workflowsPath = "@project-core/workflows/workflows.yaml"
    if (Test-Path $workflowsPath) {
        Copy-Item -Path $workflowsPath -Destination (Join-Path $backupPath "workflows.yaml")
    }

    # Backup dos logs
    $logsPath = "@project-core/logs"
    if (Test-Path $logsPath) {
        Copy-Item -Path $logsPath -Destination (Join-Path $backupPath "logs") -Recurse
    }

    Write-Host "✅ Backup created successfully"
}

# Função para restaurar backup
function Restore-Backup {
    param(
        [string]$backupName,
        [switch]$Force
    )

    if (-not $backupName) {
        Write-Error "❌ BackupName is required"
        exit 1
    }

    $backupPath = Join-Path $BACKUP_PATH $backupName
    if (-not (Test-Path $backupPath)) {
        Write-Error "❌ Backup not found: " + $backupName
        exit 1
    }

    if (-not $Force) {
        $confirmation = Read-Host "⚠️ Are you sure you want to restore from backup " + $backupName + "? (y/N)"
        if ($confirmation -ne "y") {
            Write-Host "Operation cancelled"
            return
        }
    }

    Write-Host "🔄 Restoring from backup: " + $backupName

    # Restaurar configuração MCP
    $mcpBackup = Join-Path $backupPath "mcp-config.json"
    if (Test-Path $mcpBackup) {
        Copy-Item -Path $mcpBackup -Destination "@project-core/configs/mcp-master-unified.json" -Force
    }

    # Restaurar knowledge graph
    $graphBackup = Join-Path $backupPath "knowledge-graph.json"
    if (Test-Path $graphBackup) {
        Copy-Item -Path $graphBackup -Destination "@project-core/memory/knowledge_graph.json" -Force
    }

    # Restaurar workflows
    $workflowsBackup = Join-Path $backupPath "workflows.yaml"
    if (Test-Path $workflowsBackup) {
        Copy-Item -Path $workflowsBackup -Destination "@project-core/workflows/workflows.yaml" -Force
    }

    # Restaurar logs
    $logsBackup = Join-Path $backupPath "logs"
    if (Test-Path $logsBackup) {
        # Use Smart Backup System V4.0 for safe restore operation
        if (Test-Path "@project-core/automation/smart-backup-system-v4.ps1") {
            Write-Host "🛡️ Using Smart Backup System V4.0 for safe restore operation" -ForegroundColor Cyan
            try {
                $restoreResult = & "@project-core/automation/smart-backup-system-v4.ps1" -SourcePath $logsBackup -BackupName "logs-restore" -MaxSizeMB 100 -DryRun:$false
                if ($restoreResult.Success) {
                    Write-Host "✅ Smart restore completed for logs" -ForegroundColor Green
                } else {
                    Write-Host "⚠️ Smart restore failed, using fallback method" -ForegroundColor Yellow
                    Copy-Item -Path $logsBackup -Destination "@project-core/logs" -Recurse -Force
                }
            }
            catch {
                Write-Host "⚠️ Smart restore error, using fallback method: $($_.Exception.Message)" -ForegroundColor Yellow
                Copy-Item -Path $logsBackup -Destination "@project-core/logs" -Recurse -Force
            }
        } else {
            Write-Host "⚠️ Smart Backup System not found, using basic copy" -ForegroundColor Yellow
            Copy-Item -Path $logsBackup -Destination "@project-core/logs" -Recurse -Force
        }
    }

    Write-Host "✅ Backup restored successfully"
}

# Função para deletar backup
function Delete-Backup {
    param(
        [string]$backupName,
        [switch]$Force
    )

    if (-not $backupName) {
        Write-Error "❌ BackupName is required"
        exit 1
    }

    $backupPath = Join-Path $BACKUP_PATH $backupName
    if (-not (Test-Path $backupPath)) {
        Write-Error "❌ Backup not found: " + $backupName
        exit 1
    }

    if (-not $Force) {
        $confirmation = Read-Host "⚠️ Are you sure you want to delete backup " + $backupName + "? (y/N)"
        if ($confirmation -ne "y") {
            Write-Host "Operation cancelled"
            return
        }
    }

    Write-Host "🗑️ Deleting backup: " + $backupName
    Remove-Item $backupPath -Recurse -Force
    Write-Host "✅ Backup deleted successfully"
}

# Função para verificar backup
function Verify-Backup {
    param([string]$backupName)

    if (-not $backupName) {
        Write-Error "❌ BackupName is required"
        exit 1
    }

    $backupPath = Join-Path $BACKUP_PATH $backupName
    if (-not (Test-Path $backupPath)) {
        Write-Error "❌ Backup not found: " + $backupName
        exit 1
    }

    Write-Host "🔍 Verifying backup: " + $backupName

    # Verificar arquivos essenciais
    $essentialFiles = @(
        "mcp-config.json",
        "knowledge-graph.json",
        "workflows.yaml"
    )

    $missingFiles = @()
    foreach ($file in $essentialFiles) {
        if (-not (Test-Path (Join-Path $backupPath $file))) {
            $missingFiles += $file
        }
    }

    if ($missingFiles.Count -gt 0) {
        Write-Host "❌ Missing essential files:"
        $missingFiles | ForEach-Object { Write-Host "  - " + $_ }
    } else {
        Write-Host "✅ All essential files present"
    }

    # Verificar integridade dos arquivos
    $corruptedFiles = @()
    foreach ($file in $essentialFiles) {
        $filePath = Join-Path $backupPath $file
        if (Test-Path $filePath) {
            try {
                $content = Get-Content $filePath -Raw
                if ($file -eq "mcp-config.json" -or $file -eq "knowledge-graph.json") {
                    $null = $content | ConvertFrom-Json
                } elseif ($file -eq "workflows.yaml") {
                    $null = $content | ConvertFrom-Yaml
                }
            } catch {
                $corruptedFiles += $file
            }
        }
    }

    if ($corruptedFiles.Count -gt 0) {
        Write-Host "❌ Corrupted files:"
        $corruptedFiles | ForEach-Object { Write-Host "  - " + $_ }
    } else {
        Write-Host "✅ All files are valid"
    }
}

# Função para mostrar estatísticas dos backups
function Show-BackupStats {
    Write-Host "`n📊 Backup Statistics:`n"

    if (-not (Test-Path $BACKUP_PATH)) {
        Write-Host "No backups found"
        return
    }

    $backups = Get-ChildItem -Path $BACKUP_PATH -Directory
    $totalBackups = $backups.Count
    $totalSize = ($backups | ForEach-Object { (Get-ChildItem $_.FullName -Recurse | Measure-Object -Property Length -Sum).Sum } | Measure-Object -Sum).Sum

    Write-Host "Total Backups: " + $totalBackups
    Write-Host "Total Size: " + [math]::Round($totalSize / 1MB, 2) + " MB"
    Write-Host ""

    # Estatísticas por idade
    $oldBackups = $backups | Where-Object {
        $_.CreationTime -lt (Get-Date).AddDays(-$MAX_BACKUP_AGE_DAYS)
    }

    Write-Host "Age Statistics:"
    Write-Host "  Old Backups: " + $oldBackups.Count
    Write-Host "  Max Age: " + $MAX_BACKUP_AGE_DAYS + " days"
    Write-Host ""

    # Estatísticas de uso
    if ($totalBackups -gt $MAX_BACKUP_COUNT) {
        Write-Host "⚠️ Warning: Exceeding maximum backup count (" + $MAX_BACKUP_COUNT + ")"
    }

    # Estatísticas de espaço
    $drive = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -eq (Split-Path $BACKUP_PATH -Qualifier) }
    $freeSpace = $drive.Free
    $freeSpaceMB = [math]::Round($freeSpace / 1MB, 2)

    Write-Host "Space Statistics:"
    Write-Host "  Free Space: " + $freeSpaceMB + " MB"
    Write-Host ""
}

# Main execution
switch ($Action) {
    "list" {
        List-Backups
    }
    "create" {
        Create-Backup -backupName $BackupName -Force:$Force
    }
    "restore" {
        Restore-Backup -backupName $BackupName -Force:$Force
    }
    "delete" {
        Delete-Backup -backupName $BackupName -Force:$Force
    }
    "verify" {
        Verify-Backup -backupName $BackupName
    }
    "stats" {
        Show-BackupStats
    }
    default {
        Write-Host "Usage: .\manage-backups.ps1 [-Action <action>] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  list - List available backups"
        Write-Host "  create - Create a new backup"
        Write-Host "  restore - Restore from a backup"
        Write-Host "  delete - Delete a backup"
        Write-Host "  verify - Verify backup integrity"
        Write-Host "  stats - Show backup statistics"
    }
}

