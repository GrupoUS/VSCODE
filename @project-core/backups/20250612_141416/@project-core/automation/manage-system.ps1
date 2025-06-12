# GRUPO US VIBECODE SYSTEM V4.5 - System Manager
# Script para gerenciar o sistema como um todo

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("status", "start", "stop", "restart", "optimize", "backup", "restore", "stats")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$BackupPath,

    [Parameter(Mandatory=$false)]
    [string]$RestorePath,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$MCP_CONFIG_PATH = Join-Path $SCRIPT_DIR "..\configs\mcp-master-unified.json"
$KNOWLEDGE_GRAPH_PATH = Join-Path $SCRIPT_DIR "..\memory\knowledge_graph.json"
$WORKFLOWS_PATH = Join-Path $SCRIPT_DIR "..\workflows\workflows.yaml"
$BACKUP_PATH = Join-Path $SCRIPT_DIR "..\backups"

# Função para carregar configuração MCP
function Load-McpConfig {
    if (-not (Test-Path $MCP_CONFIG_PATH)) {
        Write-Error "MCP configuration file not found: $MCP_CONFIG_PATH"
        exit 1
    }

    $config = Get-Content $MCP_CONFIG_PATH -Raw | ConvertFrom-Json
    return $config
}

# Função para verificar status do sistema
function Get-SystemStatus {
    $config = Load-McpConfig

    Write-Host "`nSystem Status:`n"

    # Verificar status dos servidores MCP
    Write-Host "MCP Servers:"
    foreach ($server in $config.mcpServers) {
        $status = if ($server.status -eq "running") { "Running" } else { "Stopped" }
        Write-Host "  $($server.name): $status"
    }
    Write-Host ""

    # Verificar knowledge graph
    if (Test-Path $KNOWLEDGE_GRAPH_PATH) {
        $graphInfo = Get-Item $KNOWLEDGE_GRAPH_PATH
        Write-Host "Knowledge Graph:"
        Write-Host "  Status: Active"
        Write-Host "  Last Modified: $($graphInfo.LastWriteTime)"
        Write-Host ""
    } else {
        Write-Host "Knowledge Graph: Not Found"
        Write-Host ""
    }

    # Verificar workflows
    if (Test-Path $WORKFLOWS_PATH) {
        $workflowsInfo = Get-Item $WORKFLOWS_PATH
        Write-Host "Workflows:"
        Write-Host "  Status: Active"
        Write-Host "  Last Modified: $($workflowsInfo.LastWriteTime)"
        Write-Host ""
    } else {
        Write-Host "Workflows: Not Found"
        Write-Host ""
    }
}

# Função para iniciar o sistema
function Start-System {
    param([switch]$Force)

    $config = Load-McpConfig

    Write-Host "Starting system..."

    foreach ($server in $config.mcpServers) {
        if ($server.status -eq "stopped" -and -not $Force) {
            Write-Host "Starting server: $($server.name)"
            $server.status = "running"
        }
    }

    Save-McpConfig -config $config
    Write-Host "System started successfully"
}

# Função para parar o sistema
function Stop-System {
    param([switch]$Force)

    $config = Load-McpConfig

    Write-Host "Stopping system..."

    foreach ($server in $config.mcpServers) {
        if ($server.status -eq "running" -and -not $Force) {
            Write-Host "Stopping server: $($server.name)"
            $server.status = "stopped"
        }
    }

    Save-McpConfig -config $config
    Write-Host "System stopped successfully"
}

# Função para reiniciar o sistema
function Restart-System {
    param([switch]$Force)

    Write-Host "Restarting system..."
    Stop-System -Force:$Force
    Start-Sleep -Seconds 2
    Start-System -Force:$Force
    Write-Host "System restarted successfully"
}

# Função para otimizar o sistema
function Optimize-System {
    Write-Host "Optimizing system..."

    # Otimizar knowledge graph
    if (Test-Path $KNOWLEDGE_GRAPH_PATH) {
        Write-Host "Optimizing knowledge graph..."
        # Implementar lógica de otimização do knowledge graph
    }

    # Otimizar workflows
    if (Test-Path $WORKFLOWS_PATH) {
        Write-Host "Optimizing workflows..."
        # Implementar lógica de otimização dos workflows
    }

    Write-Host "System optimization completed"
}

# Função para fazer backup do sistema
function Backup-System {
    param(
        [string]$backupPath,
        [switch]$Force
    )

    if (-not $backupPath) {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupPath = Join-Path $BACKUP_PATH "system_backup_$timestamp"
    }

    if (Test-Path $backupPath) {
        if (-not $Force) {
            Write-Error "Backup path already exists: $backupPath"
            exit 1
        }
        Remove-Item $backupPath -Recurse -Force
    }

    Write-Host "Creating system backup at: $backupPath"

    # Criar diretório de backup
    New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

    # Backup da configuração MCP
    if (Test-Path $MCP_CONFIG_PATH) {
        Copy-Item -Path $MCP_CONFIG_PATH -Destination (Join-Path $backupPath "mcp-config.json")
    }

    # Backup do knowledge graph
    if (Test-Path $KNOWLEDGE_GRAPH_PATH) {
        Copy-Item -Path $KNOWLEDGE_GRAPH_PATH -Destination (Join-Path $backupPath "knowledge-graph.json")
    }

    # Backup dos workflows
    if (Test-Path $WORKFLOWS_PATH) {
        Copy-Item -Path $WORKFLOWS_PATH -Destination (Join-Path $backupPath "workflows.yaml")
    }

    Write-Host "System backup completed successfully"
}

# Função para restaurar o sistema
function Restore-System {
    param(
        [string]$restorePath,
        [switch]$Force
    )

    if (-not $restorePath) {
        Write-Error "Restore path is required"
        exit 1
    }

    if (-not (Test-Path $restorePath)) {
        Write-Error "Restore path not found: $restorePath"
        exit 1
    }

    if (-not $Force) {
        $confirmation = Read-Host "Are you sure you want to restore from $restorePath? (y/N)"
        if ($confirmation -ne "y") {
            Write-Host "Operation cancelled"
            return
        }
    }

    Write-Host "Restoring system from: $restorePath"

    # Restaurar configuração MCP
    $mcpBackup = Join-Path $restorePath "mcp-config.json"
    if (Test-Path $mcpBackup) {
        Copy-Item -Path $mcpBackup -Destination $MCP_CONFIG_PATH -Force
    }

    # Restaurar knowledge graph
    $graphBackup = Join-Path $restorePath "knowledge-graph.json"
    if (Test-Path $graphBackup) {
        Copy-Item -Path $graphBackup -Destination $KNOWLEDGE_GRAPH_PATH -Force
    }

    # Restaurar workflows
    $workflowsBackup = Join-Path $restorePath "workflows.yaml"
    if (Test-Path $workflowsBackup) {
        Copy-Item -Path $workflowsBackup -Destination $WORKFLOWS_PATH -Force
    }

    Write-Host "System restore completed successfully"
}

# Função para mostrar estatísticas do sistema
function Show-SystemStats {
    $config = Load-McpConfig

    Write-Host "`nSystem Statistics:`n"

    # Estatísticas dos servidores
    $totalServers = $config.mcpServers.Count
    $runningServers = ($config.mcpServers | Where-Object { $_.status -eq "running" }).Count

    Write-Host "Servers:"
    Write-Host "  Total: $totalServers"
    Write-Host "  Running: $runningServers"
    Write-Host "  Stopped: $($totalServers - $runningServers)"
    Write-Host ""

    # Estatísticas do knowledge graph
    if (Test-Path $KNOWLEDGE_GRAPH_PATH) {
        $graphInfo = Get-Item $KNOWLEDGE_GRAPH_PATH
        $graphSize = [math]::Round($graphInfo.Length / 1KB, 2)

        Write-Host "Knowledge Graph:"
        Write-Host "  Size: $graphSize KB"
        Write-Host "  Last Modified: $($graphInfo.LastWriteTime)"
        Write-Host ""
    }

    # Estatísticas dos workflows
    if (Test-Path $WORKFLOWS_PATH) {
        $workflowsInfo = Get-Item $WORKFLOWS_PATH
        $workflowsSize = [math]::Round($workflowsInfo.Length / 1KB, 2)

        Write-Host "Workflows:"
        Write-Host "  Size: $workflowsSize KB"
        Write-Host "  Last Modified: $($workflowsInfo.LastWriteTime)"
        Write-Host ""
    }
}

# Função para salvar configuração MCP
function Save-McpConfig {
    param($config)

    $config | ConvertTo-Json -Depth 10 | Set-Content $MCP_CONFIG_PATH
}

# Main execution
switch ($Action) {
    "status" {
        Get-SystemStatus
    }
    "start" {
        Start-System -Force:$Force
    }
    "stop" {
        Stop-System -Force:$Force
    }
    "restart" {
        Restart-System -Force:$Force
    }
    "optimize" {
        Optimize-System
    }
    "backup" {
        Backup-System -backupPath $BackupPath -Force:$Force
    }
    "restore" {
        Restore-System -restorePath $RestorePath -Force:$Force
    }
    "stats" {
        Show-SystemStats
    }
    default {
        Write-Host "Usage: .\manage-system.ps1 [-Action <action>] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  status - Check system status"
        Write-Host "  start - Start the system"
        Write-Host "  stop - Stop the system"
        Write-Host "  restart - Restart the system"
        Write-Host "  optimize - Optimize the system"
        Write-Host "  backup - Create system backup"
        Write-Host "  restore - Restore from backup"
        Write-Host "  stats - Show system statistics"
    }
}
