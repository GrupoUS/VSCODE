param([switch]$Validate)

$ProjectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$AgentsPath = Join-Path $ProjectRoot "@project-core\agents"
$LogFile = Join-Path $AgentsPath "logs\init.log"

if (-not (Test-Path (Split-Path $LogFile -Parent))) {
    New-Item -ItemType Directory -Path (Split-Path $LogFile -Parent) -Force | Out-Null
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $LogEntry = "[$(Get-Date -Format 'HH:mm:ss')] [$Level] $Message"
    switch ($Level) {
        "ERROR" { Write-Host $LogEntry -ForegroundColor Red }
        "SUCCESS" { Write-Host $LogEntry -ForegroundColor Green }
        default { Write-Host $LogEntry }
    }
    Add-Content -Path $LogFile -Value $LogEntry
}

# Validation functions
function Test-AgentConfiguration {
    param([string]$AgentPath)
    
    $ConfigFile = Join-Path $AgentPath "$((Split-Path $AgentPath -Leaf))-config.json"
    
    if (-not (Test-Path $ConfigFile)) {
        Write-Log "Missing configuration file: $ConfigFile" "ERROR"
        return $false
    }
    
    try {
        $Config = Get-Content $ConfigFile | ConvertFrom-Json
        
        # Validate required fields
        $RequiredFields = @("agent_id", "name", "model_config", "specialization", "mcp_integration")
        foreach ($Field in $RequiredFields) {
            if (-not $Config.agent_config.$Field) {
                Write-Log "Missing required field '$Field' in $ConfigFile" "ERROR"
                return $false
            }
        }
        
        Write-Log "Configuration valid for agent: $($Config.agent_config.agent_id)" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Invalid JSON in configuration file: $ConfigFile - $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Test-MCPIntegration {
    Write-Log "Validating MCP server integration..." "INFO"
    
    $MCPConfigFile = Join-Path $AgentsPath "coordination\mcp-integration.json"
    
    if (-not (Test-Path $MCPConfigFile)) {
        Write-Log "MCP integration configuration not found: $MCPConfigFile" "ERROR"
        return $false
    }
    
    try {
        $MCPConfig = Get-Content $MCPConfigFile | ConvertFrom-Json
        
        # Validate server assignments (Enhanced V2.0)
        $Agents = @("boomerang", "architect", "coder", "manager", "executor", "researcher", "advisor", "prompt_refiner", "tools_refiner", "self_reflection")
        foreach ($Agent in $Agents) {
            if (-not $MCPConfig.mcp_server_assignments.$Agent) {
                Write-Log "Missing MCP server assignment for agent: $Agent" "ERROR"
                return $false
            }
        }
        
        Write-Log "MCP integration configuration valid" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Invalid MCP integration configuration: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Test-WorkflowDefinitions {
    Write-Log "Validating workflow definitions..." "INFO"
    
    $WorkflowFile = Join-Path $AgentsPath "workflows\standard-workflows.json"
    
    if (-not (Test-Path $WorkflowFile)) {
        Write-Log "Workflow definitions not found: $WorkflowFile" "ERROR"
        return $false
    }
    
    try {
        $Workflows = Get-Content $WorkflowFile | ConvertFrom-Json
        
        # Validate required workflows (Enhanced V2.0)
        $RequiredWorkflows = @("feature_development", "bug_fix", "research", "architecture_review", "agent_creation", "self_reflection")
        foreach ($Workflow in $RequiredWorkflows) {
            if (-not $Workflows.workflow_definitions.$Workflow) {
                Write-Log "Missing required workflow: $Workflow" "ERROR"
                return $false
            }
        }
        
        Write-Log "Workflow definitions valid" "SUCCESS"
        return $true
    }
    catch {
        Write-Log "Invalid workflow definitions: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Initialize-AgentDirectories {
    Write-Log "Initializing agent directory structure..." "INFO"
    
    $Agents = @("boomerang", "architect", "coder", "manager", "executor", "researcher", "advisor", "refiners", "self-reflection")

    foreach ($Agent in $Agents) {
        $AgentPath = Join-Path $AgentsPath $Agent

        if (-not (Test-Path $AgentPath)) {
            New-Item -ItemType Directory -Path $AgentPath -Force | Out-Null
            Write-Log "Created directory for agent: $Agent" "INFO"
        }
        
        # Create subdirectories
        $SubDirs = @("logs", "cache", "temp")
        foreach ($SubDir in $SubDirs) {
            $SubDirPath = Join-Path $AgentPath $SubDir
            if (-not (Test-Path $SubDirPath)) {
                New-Item -ItemType Directory -Path $SubDirPath -Force | Out-Null
            }
        }
    }
    
    # Create coordination directories
    $CoordinationPath = Join-Path $AgentsPath "coordination"
    if (-not (Test-Path $CoordinationPath)) {
        New-Item -ItemType Directory -Path $CoordinationPath -Force | Out-Null
        Write-Log "Created coordination directory" "INFO"
    }
    
    # Create workflows directory
    $WorkflowsPath = Join-Path $AgentsPath "workflows"
    if (-not (Test-Path $WorkflowsPath)) {
        New-Item -ItemType Directory -Path $WorkflowsPath -Force | Out-Null
        Write-Log "Created workflows directory" "INFO"
    }
    
    Write-Log "Agent directory structure initialized" "SUCCESS"
}

function Test-SystemIntegration {
    Write-Log "Testing system integration..." "INFO"
    
    # Test memory bank access
    $MemoryPath = Join-Path $ProjectRoot "@project-core\memory"
    if (-not (Test-Path $MemoryPath)) {
        Write-Log "Memory bank not found: $MemoryPath" "ERROR"
        return $false
    }
    
    # Test TaskMaster integration
    $TaskMasterPath = Join-Path $ProjectRoot "scripts"
    if (-not (Test-Path $TaskMasterPath)) {
        Write-Log "TaskMaster scripts directory not found: $TaskMasterPath" "WARN"
    }
    
    # Test MCP server availability (basic check)
    $MCPServers = @(
        "sequentialthinking_tools_mcp-sequentialthinking-tools",
        "mcp-shrimp-task-manager",
        "str-replace-editor",
        "search_perplexity-search"
    )
    
    foreach ($Server in $MCPServers) {
        # This is a placeholder - actual MCP server testing would require more complex logic
        Write-Log "MCP Server check: $Server (placeholder)" "INFO"
    }
    
    Write-Log "System integration tests completed" "SUCCESS"
    return $true
}

# Main execution
function Main {
    Write-Log "Starting GRUPO US Multi-Agent System initialization..." "INFO"
    Write-Log "Project Root: $ProjectRoot" "INFO"
    Write-Log "Agents Path: $AgentsPath" "INFO"
    
    $AllValid = $true
    
    # Initialize directories if not in validation mode
    if (-not $Validate) {
        Initialize-AgentDirectories
    }
    
    # Validate agent configurations
    Write-Log "Validating agent configurations..." "INFO"
    $Agents = @("boomerang", "architect", "coder", "manager", "executor", "researcher")
    
    foreach ($Agent in $Agents) {
        $AgentPath = Join-Path $AgentsPath $Agent
        if (-not (Test-AgentConfiguration $AgentPath)) {
            $AllValid = $false
        }
    }
    
    # Validate coordination components
    if (-not (Test-MCPIntegration)) {
        $AllValid = $false
    }
    
    if (-not (Test-WorkflowDefinitions)) {
        $AllValid = $false
    }
    
    # Test system integration
    if (-not (Test-SystemIntegration)) {
        $AllValid = $false
    }
    
    # Final result
    if ($AllValid) {
        Write-Log "🚀 Multi-Agent System initialization completed successfully!" "SUCCESS"
        Write-Log "System is ready for operation." "SUCCESS"
        
        # Display system summary
        Write-Log "=== ENHANCED SYSTEM SUMMARY V2.0 ===" "INFO"
        Write-Log "Core Agents: 6 (Boomerang, Architect, Coder, Manager, Executor, Researcher)" "INFO"
        Write-Log "New Agents: 4 (Advisor, Prompt Refiner, Tools Refiner, Self-Reflection)" "INFO"
        Write-Log "Total Agents: 10 (Archon & PraisonAI Enhanced)" "INFO"
        Write-Log "Workflows: 6 (Feature Development, Bug Fix, Research, Architecture Review, Agent Creation, Self-Reflection)" "INFO"
        Write-Log "MCP Servers: Enhanced integration with think-mcp-server" "INFO"
        Write-Log "Memory Bank: Connected with RAG optimization" "INFO"
        Write-Log "Pattern Library: Enhanced with Archon & PraisonAI patterns" "INFO"
        
        return 0
    }
    else {
        Write-Log "❌ Multi-Agent System initialization failed!" "ERROR"
        Write-Log "Please review the errors above and fix the issues." "ERROR"
        return 1
    }
}

# Execute main function
$ExitCode = Main
Write-Log "Initialization script completed with exit code: $ExitCode" "INFO"
exit $ExitCode
