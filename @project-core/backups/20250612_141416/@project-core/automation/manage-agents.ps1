# GRUPO US VIBECODE SYSTEM V4.5 - Agent Manager
# Script para gerenciar os agentes do sistema

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("list", "status", "assign", "release", "configure", "stats")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$AgentName,

    [Parameter(Mandatory=$false)]
    [string]$TaskId,

    [Parameter(Mandatory=$false)]
    [string]$ConfigPath,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$MCP_CONFIG_PATH = "@project-core/configs/mcp-master-unified.json"
$AGENTS_PATH = "@project-core/agents"
$TASKS_PATH = "@project-core/tasks"

# Função para carregar configuração MCP
function Load-McpConfig {
    if (Test-Path $MCP_CONFIG_PATH) {
        $configContent = Get-Content $MCP_CONFIG_PATH -Raw
        return $configContent | ConvertFrom-Json
    } else {
        Write-Error "❌ MCP config file not found at $MCP_CONFIG_PATH"
        exit 1
    }
}

# Função para listar agentes disponíveis
function List-Agents {
    $config = Load-McpConfig

    Write-Host "`n📋 Available Agents:`n"

    foreach ($server in $config.mcpServers) {
        if ($server.type -ne "refinement") {
            Write-Host "🔹 $($server.name)"
            Write-Host "   Type: $($server.type)"
            Write-Host "   Status: $($server.status)"
            Write-Host "   Capabilities: $($server.capabilities -join ', ')"
            Write-Host "   Current Task: $($server.currentTask)"
            Write-Host ""
        }
    }
}

# Função para verificar status dos agentes
function Get-AgentStatus {
    param([string]$agentName)

    $config = Load-McpConfig
    $agent = $config.mcpServers | Where-Object { $_.name -eq $agentName -and $_.type -ne "refinement" }

    if (-not $agent) {
        Write-Error "❌ Agent '$agentName' not found"
        exit 1
    }

    Write-Host "`n📊 Agent Status: $agentName`n"
    Write-Host "Status: $($agent.status)"
    Write-Host "Type: $($agent.type)"
    Write-Host "Capabilities: $($agent.capabilities -join ', ')"
    Write-Host "Current Task: $($agent.currentTask)"
    Write-Host "Last Active: $($agent.lastActive)"
    Write-Host "Performance: $($agent.performance)%"
    Write-Host "Success Rate: $($agent.successRate)%"
}

# Função para atribuir uma tarefa a um agente
function Assign-Task {
    param(
        [string]$agentName,
        [string]$taskId
    )

    $config = Load-McpConfig
    $agent = $config.mcpServers | Where-Object { $_.name -eq $agentName -and $_.type -ne "refinement" }

    if (-not $agent) {
        Write-Error "❌ Agent '$agentName' not found"
        exit 1
    }

    if ($agent.status -ne "idle") {
        Write-Error "❌ Agent '$agentName' is not available"
        exit 1
    }

    # Verificar se a tarefa existe
    $taskPath = Join-Path $TASKS_PATH "$taskId.json"
    if (-not (Test-Path $taskPath)) {
        Write-Error "❌ Task '$taskId' not found"
        exit 1
    }

    Write-Host "🎯 Assigning task '$taskId' to agent '$agentName'"

    # Atualizar status do agente
    $agent.status = "busy"
    $agent.currentTask = $taskId
    $agent.lastActive = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

    Save-McpConfig -config $config

    Write-Host "✅ Task assigned successfully"
}

# Função para liberar um agente
function Release-Agent {
    param(
        [string]$agentName,
        [switch]$Force
    )

    $config = Load-McpConfig
    $agent = $config.mcpServers | Where-Object { $_.name -eq $agentName -and $_.type -ne "refinement" }

    if (-not $agent) {
        Write-Error "❌ Agent '$agentName' not found"
        exit 1
    }

    if ($agent.status -eq "idle" -and -not $Force) {
        Write-Host "ℹ️ Agent '$agentName' is already idle"
        return
    }

    Write-Host "🔄 Releasing agent: $agentName"

    # Implementar lógica de liberação
    # Por exemplo:
    # - Salvar estado atual
    # - Finalizar tarefa atual
    # - Limpar recursos
    # - Atualizar estatísticas

    $agent.status = "idle"
    $agent.currentTask = $null
    $agent.lastActive = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

    Save-McpConfig -config $config

    Write-Host "✅ Agent released successfully"
}

# Função para configurar um agente
function Configure-Agent {
    param(
        [string]$agentName,
        [string]$configPath
    )

    if (-not (Test-Path $configPath)) {
        Write-Error "❌ Configuration file not found at $configPath"
        exit 1
    }

    $config = Load-McpConfig
    $agent = $config.mcpServers | Where-Object { $_.name -eq $agentName -and $_.type -ne "refinement" }

    if (-not $agent) {
        Write-Error "❌ Agent '$agentName' not found"
        exit 1
    }

    Write-Host "⚙️ Configuring agent: $agentName"

    # Carregar nova configuração
    $newConfig = Get-Content $configPath -Raw | ConvertFrom-Json

    # Atualizar configuração
    $agent.capabilities = $newConfig.capabilities
    $agent.optimizationLevel = $newConfig.optimizationLevel
    $agent.activationConditions = $newConfig.activationConditions

    Save-McpConfig -config $config

    Write-Host "✅ Agent configured successfully"
}

# Função para mostrar estatísticas dos agentes
function Show-AgentStats {
    $config = Load-McpConfig

    Write-Host "`n📊 Agent Statistics:`n"

    $totalAgents = ($config.mcpServers | Where-Object { $_.type -ne "refinement" }).Count
    $busyAgents = ($config.mcpServers | Where-Object { $_.type -ne "refinement" -and $_.status -eq "busy" }).Count
    $idleAgents = ($config.mcpServers | Where-Object { $_.type -ne "refinement" -and $_.status -eq "idle" }).Count

    Write-Host "Total Agents: $totalAgents"
    Write-Host "Busy Agents: $busyAgents"
    Write-Host "Idle Agents: $idleAgents"
    Write-Host ""

    Write-Host "Performance by Type:"
    $config.mcpServers | Where-Object { $_.type -ne "refinement" } | Group-Object type | ForEach-Object {
        $type = $_.Name
        $agents = $_.Group
        $avgPerformance = ($agents | Measure-Object -Property performance -Average).Average
        $avgSuccessRate = ($agents | Measure-Object -Property successRate -Average).Average

        Write-Host "  $type"
        Write-Host "    Average Performance: $avgPerformance%"
        Write-Host "    Average Success Rate: $avgSuccessRate%"
        Write-Host ""
    }
}

# Função para salvar configuração MCP
function Save-McpConfig {
    param($config)

    $configJson = $config | ConvertTo-Json -Depth 10
    Set-Content -Path $MCP_CONFIG_PATH -Value $configJson
}

# Main execution
switch ($Action) {
    "list" {
        List-Agents
    }
    "status" {
        if (-not $AgentName) {
            Write-Error "❌ AgentName is required for status action"
            exit 1
        }
        Get-AgentStatus -agentName $AgentName
    }
    "assign" {
        if (-not $AgentName -or -not $TaskId) {
            Write-Error "❌ AgentName and TaskId are required for assign action"
            exit 1
        }
        Assign-Task -agentName $AgentName -taskId $TaskId
    }
    "release" {
        if (-not $AgentName) {
            Write-Error "❌ AgentName is required for release action"
            exit 1
        }
        Release-Agent -agentName $AgentName -Force:$Force
    }
    "configure" {
        if (-not $AgentName -or -not $ConfigPath) {
            Write-Error "❌ AgentName and ConfigPath are required for configure action"
            exit 1
        }
        Configure-Agent -agentName $AgentName -configPath $ConfigPath
    }
    "stats" {
        Show-AgentStats
    }
    default {
        Write-Host "Usage: .\manage-agents.ps1 [-Action <action>] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  list - List available agents"
        Write-Host "  status - Show agent status"
        Write-Host "  assign - Assign a task to an agent"
        Write-Host "  release - Release an agent"
        Write-Host "  configure - Configure an agent"
        Write-Host "  stats - Show agent statistics"
    }
}
