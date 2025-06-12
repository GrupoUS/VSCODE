# GRUPO US VIBECODE SYSTEM V4.5 - Task Manager
# Script para gerenciar as tarefas do sistema

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("list", "create", "update", "delete", "status", "assign", "complete", "stats")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$TaskId,

    [Parameter(Mandatory=$false)]
    [string]$Title,

    [Parameter(Mandatory=$false)]
    [string]$Description,

    [Parameter(Mandatory=$false)]
    [string]$Type,

    [Parameter(Mandatory=$false)]
    [string]$Priority,

    [Parameter(Mandatory=$false)]
    [string]$AgentName,

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Configurações
$TASKS_PATH = "@project-core/tasks"
$MCP_CONFIG_PATH = "@project-core/configs/mcp-master-unified.json"

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

# Função para listar tarefas
function List-Tasks {
    $tasks = Get-ChildItem -Path $TASKS_PATH -Filter "*.json" | ForEach-Object {
        $task = Get-Content $_.FullName -Raw | ConvertFrom-Json
        [PSCustomObject]@{
            Id = $task.id
            Title = $task.title
            Type = $task.type
            Priority = $task.priority
            Status = $task.status
            AssignedTo = $task.assignedTo
            CreatedAt = $task.createdAt
            UpdatedAt = $task.updatedAt
        }
    }

    Write-Host "`n📋 Tasks:`n"
    $tasks | Format-Table -AutoSize
}

# Função para criar uma nova tarefa
function New-Task {
    param(
        [string]$title,
        [string]$description,
        [string]$type,
        [string]$priority
    )

    $taskId = [guid]::NewGuid().ToString()
    $taskPath = Join-Path $TASKS_PATH "$taskId.json"

    $task = @{
        id = $taskId
        title = $title
        description = $description
        type = $type
        priority = $priority
        status = "pending"
        assignedTo = $null
        createdAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        updatedAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        steps = @()
        dependencies = @()
        metadata = @{
            estimatedTime = $null
            actualTime = $null
            complexity = $null
            tags = @()
        }
    }

    $taskJson = $task | ConvertTo-Json -Depth 10
    Set-Content -Path $taskPath -Value $taskJson

    Write-Host "✅ Task created successfully: $taskId"
}

# Função para atualizar uma tarefa
function Update-Task {
    param(
        [string]$taskId,
        [hashtable]$updates
    )

    $taskPath = Join-Path $TASKS_PATH "$taskId.json"
    if (-not (Test-Path $taskPath)) {
        Write-Error "❌ Task '$taskId' not found"
        exit 1
    }

    $task = Get-Content $taskPath -Raw | ConvertFrom-Json

    foreach ($key in $updates.Keys) {
        $task.$key = $updates[$key]
    }

    $task.updatedAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

    $taskJson = $task | ConvertTo-Json -Depth 10
    Set-Content -Path $taskPath -Value $taskJson

    Write-Host "✅ Task updated successfully: $taskId"
}

# Função para excluir uma tarefa
function Remove-Task {
    param(
        [string]$taskId,
        [switch]$Force
    )

    $taskPath = Join-Path $TASKS_PATH "$taskId.json"
    if (-not (Test-Path $taskPath)) {
        Write-Error "❌ Task '$taskId' not found"
        exit 1
    }

    $task = Get-Content $taskPath -Raw | ConvertFrom-Json

    if ($task.status -ne "completed" -and -not $Force) {
        Write-Error "❌ Cannot delete incomplete task without -Force"
        exit 1
    }

    Remove-Item -Path $taskPath -Force

    Write-Host "✅ Task deleted successfully: $taskId"
}

# Função para verificar status de uma tarefa
function Get-TaskStatus {
    param([string]$taskId)

    $taskPath = Join-Path $TASKS_PATH "$taskId.json"
    if (-not (Test-Path $taskPath)) {
        Write-Error "❌ Task '$taskId' not found"
        exit 1
    }

    $task = Get-Content $taskPath -Raw | ConvertFrom-Json

    Write-Host "`n📊 Task Status: $taskId`n"
    Write-Host "Title: $($task.title)"
    Write-Host "Type: $($task.type)"
    Write-Host "Priority: $($task.priority)"
    Write-Host "Status: $($task.status)"
    Write-Host "Assigned To: $($task.assignedTo)"
    Write-Host "Created At: $($task.createdAt)"
    Write-Host "Updated At: $($task.updatedAt)"
    Write-Host ""
    Write-Host "Steps: $($task.steps.Count)"
    Write-Host "Dependencies: $($task.dependencies.Count)"
    Write-Host ""
    Write-Host "Metadata:"
    Write-Host "  Estimated Time: $($task.metadata.estimatedTime)"
    Write-Host "  Actual Time: $($task.metadata.actualTime)"
    Write-Host "  Complexity: $($task.metadata.complexity)"
    Write-Host "  Tags: $($task.metadata.tags -join ', ')"
}

# Função para atribuir uma tarefa a um agente
function Assign-Task {
    param(
        [string]$taskId,
        [string]$agentName
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

    $taskPath = Join-Path $TASKS_PATH "$taskId.json"
    if (-not (Test-Path $taskPath)) {
        Write-Error "❌ Task '$taskId' not found"
        exit 1
    }

    $task = Get-Content $taskPath -Raw | ConvertFrom-Json

    if ($task.status -ne "pending") {
        Write-Error "❌ Task '$taskId' is not in pending status"
        exit 1
    }

    $task.status = "in_progress"
    $task.assignedTo = $agentName
    $task.updatedAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

    $taskJson = $task | ConvertTo-Json -Depth 10
    Set-Content -Path $taskPath -Value $taskJson

    # Atualizar status do agente
    $agent.status = "busy"
    $agent.currentTask = $taskId
    $agent.lastActive = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

    Save-McpConfig -config $config

    Write-Host "✅ Task assigned successfully"
}

# Função para marcar uma tarefa como concluída
function Complete-Task {
    param(
        [string]$taskId,
        [switch]$Force
    )

    $taskPath = Join-Path $TASKS_PATH "$taskId.json"
    if (-not (Test-Path $taskPath)) {
        Write-Error "❌ Task '$taskId' not found"
        exit 1
    }

    $task = Get-Content $taskPath -Raw | ConvertFrom-Json

    if ($task.status -ne "in_progress" -and -not $Force) {
        Write-Error "❌ Task '$taskId' is not in progress"
        exit 1
    }

    $config = Load-McpConfig
    $agent = $config.mcpServers | Where-Object { $_.name -eq $task.assignedTo -and $_.type -ne "refinement" }

    if ($agent) {
        $agent.status = "idle"
        $agent.currentTask = $null
        $agent.lastActive = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
        Save-McpConfig -config $config
    }

    $task.status = "completed"
    $task.updatedAt = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

    $taskJson = $task | ConvertTo-Json -Depth 10
    Set-Content -Path $taskPath -Value $taskJson

    Write-Host "✅ Task completed successfully"
}

# Função para mostrar estatísticas das tarefas
function Show-TaskStats {
    $tasks = Get-ChildItem -Path $TASKS_PATH -Filter "*.json" | ForEach-Object {
        Get-Content $_.FullName -Raw | ConvertFrom-Json
    }

    Write-Host "`n📊 Task Statistics:`n"

    $totalTasks = $tasks.Count
    $pendingTasks = ($tasks | Where-Object { $_.status -eq "pending" }).Count
    $inProgressTasks = ($tasks | Where-Object { $_.status -eq "in_progress" }).Count
    $completedTasks = ($tasks | Where-Object { $_.status -eq "completed" }).Count

    Write-Host "Total Tasks: $totalTasks"
    Write-Host "Pending Tasks: $pendingTasks"
    Write-Host "In Progress Tasks: $inProgressTasks"
    Write-Host "Completed Tasks: $completedTasks"
    Write-Host ""

    Write-Host "Tasks by Type:"
    $tasks | Group-Object type | ForEach-Object {
        $type = $_.Name
        $typeTasks = $_.Group
        $typeCompleted = ($typeTasks | Where-Object { $_.status -eq "completed" }).Count

        Write-Host "  $type"
        Write-Host "    Total: $($typeTasks.Count)"
        Write-Host "    Completed: $typeCompleted"
        Write-Host "    Completion Rate: $([math]::Round(($typeCompleted / $typeTasks.Count) * 100))%"
        Write-Host ""
    }

    Write-Host "Tasks by Priority:"
    $tasks | Group-Object priority | ForEach-Object {
        $priority = $_.Name
        $priorityTasks = $_.Group
        $priorityCompleted = ($priorityTasks | Where-Object { $_.status -eq "completed" }).Count

        Write-Host "  $priority"
        Write-Host "    Total: $($priorityTasks.Count)"
        Write-Host "    Completed: $priorityCompleted"
        Write-Host "    Completion Rate: $([math]::Round(($priorityCompleted / $priorityTasks.Count) * 100))%"
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
        List-Tasks
    }
    "create" {
        if (-not $Title -or -not $Description -or -not $Type -or -not $Priority) {
            Write-Error "❌ Title, Description, Type, and Priority are required for create action"
            exit 1
        }
        New-Task -title $Title -description $Description -type $Type -priority $Priority
    }
    "update" {
        if (-not $TaskId) {
            Write-Error "❌ TaskId is required for update action"
            exit 1
        }
        $updates = @{}
        if ($Title) { $updates.title = $Title }
        if ($Description) { $updates.description = $Description }
        if ($Type) { $updates.type = $Type }
        if ($Priority) { $updates.priority = $Priority }
        Update-Task -taskId $TaskId -updates $updates
    }
    "delete" {
        if (-not $TaskId) {
            Write-Error "❌ TaskId is required for delete action"
            exit 1
        }
        Remove-Task -taskId $TaskId -Force:$Force
    }
    "status" {
        if (-not $TaskId) {
            Write-Error "❌ TaskId is required for status action"
            exit 1
        }
        Get-TaskStatus -taskId $TaskId
    }
    "assign" {
        if (-not $TaskId -or -not $AgentName) {
            Write-Error "❌ TaskId and AgentName are required for assign action"
            exit 1
        }
        Assign-Task -taskId $TaskId -agentName $AgentName
    }
    "complete" {
        if (-not $TaskId) {
            Write-Error "❌ TaskId is required for complete action"
            exit 1
        }
        Complete-Task -taskId $TaskId -Force:$Force
    }
    "stats" {
        Show-TaskStats
    }
    default {
        Write-Host "Usage: .\manage-tasks.ps1 [-Action <action>] [parameters]"
        Write-Host "Available actions:"
        Write-Host "  list - List all tasks"
        Write-Host "  create - Create a new task"
        Write-Host "  update - Update an existing task"
        Write-Host "  delete - Delete a task"
        Write-Host "  status - Show task status"
        Write-Host "  assign - Assign a task to an agent"
        Write-Host "  complete - Mark a task as completed"
        Write-Host "  stats - Show task statistics"
    }
}
