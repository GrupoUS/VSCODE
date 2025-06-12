# GRUPO US VIBECODE SYSTEM V4.5 - Refiner Manager
# Script para gerenciar os refiners do sistema

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("list", "status", "start", "stop", "restart", "configure")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$RefinerName,

    [Parameter(Mandatory=$false)]
    [string]$ConfigPath,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$MCP_CONFIG_PATH = Join-Path $SCRIPT_DIR "..\configs\mcp-master-unified.json"
$REFINERS_PATH = Join-Path $SCRIPT_DIR "..\refiners"

# Função para carregar configuração MCP
function Load-McpConfig {
    if (-not (Test-Path $MCP_CONFIG_PATH)) {
        Write-Error "MCP configuration file not found: $MCP_CONFIG_PATH"
        exit 1
    }

    $config = Get-Content $MCP_CONFIG_PATH -Raw | ConvertFrom-Json
    return $config
}

# Função para listar refiners disponíveis
function List-Refiners {
    $config = Load-McpConfig

    Write-Host "`nAvailable Refiners:`n"

    foreach ($refinerName in $config.metadata.mcpServers.refinement) {
        $refiner = $config.mcpServers.$refinerName
        if ($refiner) {
            $status = if ($refiner.enabled) { "enabled" } else { "disabled" }
            Write-Host "  $($refiner.name)"
            Write-Host "    Type: refinement"
            Write-Host "    Status: $status"
            Write-Host "    Capabilities: $($refiner.capabilities -join ', ')"
            Write-Host ""
        }
    }
}

# Função para verificar status do refiner
function Get-RefinerStatus {
    param([string]$refinerName)

    if (-not $refinerName) {
        Write-Error "RefinerName is required"
        exit 1
    }

    $config = Load-McpConfig
    $refiner = $config.mcpServers.$refinerName

    if (-not $refiner) {
        Write-Error "Refiner '$refinerName' not found"
        exit 1
    }

    $status = if ($refiner.enabled) { "enabled" } else { "disabled" }

    Write-Host "`nRefiner Status: $($refiner.name)`n"
    Write-Host "  Type: refinement"
    Write-Host "  Status: $status"
    Write-Host "  Priority: $($refiner.priority)"
    Write-Host "  Capabilities: $($refiner.capabilities -join ', ')"
    Write-Host "  Environments: $($refiner.environments -join ', ')"
    Write-Host "  Complexity Range: $($refiner.complexityRange[0])-$($refiner.complexityRange[1])"
    Write-Host ""
}

# Função para iniciar refiner
function Start-Refiner {
    param(
        [string]$refinerName,
        [switch]$Force
    )

    if (-not $refinerName) {
        Write-Error "RefinerName is required"
        exit 1
    }

    $config = Load-McpConfig
    $refiner = $config.mcpServers.$refinerName

    if (-not $refiner) {
        Write-Error "Refiner '$refinerName' not found"
        exit 1
    }

    if ($refiner.enabled -and -not $Force) {
        Write-Host "Refiner '$($refiner.name)' is already enabled"
        return
    }

    Write-Host "Starting refiner: $($refiner.name)"
    $refiner.enabled = $true

    Save-McpConfig -config $config
    Write-Host "Refiner started successfully"
}

# Função para parar refiner
function Stop-Refiner {
    param(
        [string]$refinerName,
        [switch]$Force
    )

    if (-not $refinerName) {
        Write-Error "RefinerName is required"
        exit 1
    }

    $config = Load-McpConfig
    $refiner = $config.mcpServers.$refinerName

    if (-not $refiner) {
        Write-Error "Refiner '$refinerName' not found"
        exit 1
    }

    if (-not $refiner.enabled -and -not $Force) {
        Write-Host "Refiner '$($refiner.name)' is already disabled"
        return
    }

    Write-Host "Stopping refiner: $($refiner.name)"
    $refiner.enabled = $false

    Save-McpConfig -config $config
    Write-Host "Refiner stopped successfully"
}

# Função para reiniciar refiner
function Restart-Refiner {
    param(
        [string]$refinerName,
        [switch]$Force
    )

    Write-Host "Restarting refiner: $refinerName"
    Stop-Refiner -refinerName $refinerName -Force:$Force
    Start-Sleep -Seconds 2
    Start-Refiner -refinerName $refinerName -Force:$Force
    Write-Host "Refiner restarted successfully"
}

# Função para configurar refiner
function Configure-Refiner {
    param(
        [string]$refinerName,
        [string]$configPath
    )

    if (-not $refinerName) {
        Write-Error "RefinerName is required"
        exit 1
    }

    if (-not $configPath) {
        Write-Error "ConfigPath is required"
        exit 1
    }

    if (-not (Test-Path $configPath)) {
        Write-Error "Configuration file not found: $configPath"
        exit 1
    }

    $config = Load-McpConfig
    $refiner = $config.mcpServers.$refinerName

    if (-not $refiner) {
        Write-Error "Refiner '$refinerName' not found"
        exit 1
    }

    Write-Host "Configuring refiner: $($refiner.name)"
    $refinerConfig = Get-Content $configPath -Raw | ConvertFrom-Json
    $refiner.config = $refinerConfig

    Save-McpConfig -config $config
    Write-Host "Refiner configured successfully"
}

# Função para salvar configuração MCP
function Save-McpConfig {
    param($config)

    $config | ConvertTo-Json -Depth 10 | Set-Content $MCP_CONFIG_PATH
}

# Main execution
switch ($Action) {
    "list" {
        List-Refiners
    }
    "status" {
        Get-RefinerStatus -refinerName $RefinerName
    }
    "start" {
        Start-Refiner -refinerName $RefinerName -Force:$Force
    }
    "stop" {
        Stop-Refiner -refinerName $RefinerName -Force:$Force
    }
    "restart" {
        Restart-Refiner -refinerName $RefinerName -Force:$Force
    }
    "configure" {
        Configure-Refiner -refinerName $RefinerName -configPath $ConfigPath
    }
    default {
        Write-Host "Usage: .\manage-refiners.ps1 [-Action <action>] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  list - List available refiners"
        Write-Host "  status - Check refiner status"
        Write-Host "  start - Start a refiner"
        Write-Host "  stop - Stop a refiner"
        Write-Host "  restart - Restart a refiner"
        Write-Host "  configure - Configure a refiner"
    }
}
