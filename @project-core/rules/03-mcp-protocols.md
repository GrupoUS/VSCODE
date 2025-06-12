# 🧠 **MCP PROTOCOLS - VIBECODE SYSTEM V4.0**

## 📋 **MODEL CONTEXT PROTOCOL STANDARDS**

### **1. MCP ARCHITECTURE OVERVIEW**
- **Unified Configuration**: Single source of truth em `mcp-master-unified.json`
- **Cross-Environment Support**: Sincronização automática VSCode ↔ Cursor
- **Intelligent Routing**: Servidores especializados por domínio
- **Auto-healing**: Detecção e correção automática de problemas

### **2. SERVER HIERARCHY**
```
Priority 1: sequential-thinking      # Raciocínio avançado (complexidade ≥7)
Priority 2: mcp-shrimp-task-manager # Coordenação de tarefas
Priority 3: context7-mcp            # Documentação e exemplos
Priority 4: playwright-mcp          # Automação de browser
Priority 5: figma-context-mcp       # Design-to-code (Cursor only)
```

---

## 🔧 **SERVIDOR MCP CONFIGURATIONS**

### **SEQUENTIAL THINKING MCP**
```json
{
  "command": "npx",
  "args": ["-y", "sequential-thinking-mcp"],
  "enabled": true,
  "priority": 2,
  "capabilities": ["reasoning", "analysis", "problem-solving"],
  "activationTrigger": "complexity >= 7",
  "env": {
    "SEQUENTIAL_THINKING_MODE": "enhanced",
    "MAX_THOUGHTS": "10",
    "ENABLE_BRANCHING": "true"
  }
}
```

**Activation Rules:**
- **Automatic**: Complexidade ≥ 7 (detectada automaticamente)
- **Manual**: Comando explícito do usuário
- **Context**: Tarefas que requerem raciocínio estruturado
- **Integration**: Integra com Task Manager para coordenação

### **MCP SHRIMP TASK MANAGER**
```json
{
  "command": "npx",
  "args": ["-y", "mcp-shrimp-task-manager"],
  "enabled": true,
  "priority": 3,
  "capabilities": ["task-management", "coordination", "workflow"],
  "activationTrigger": "multi-phase OR complexity >= 5",
  "env": {
    "TASK_COORDINATION": "active",
    "CROSS_ENVIRONMENT": "true",
    "HANDOFF_SUPPORT": "vscode-cursor"
  }
}
```

**Coordination Rules:**
- **Multi-phase Tasks**: Tarefas com múltiplas fases
- **Cross-environment**: Handoffs entre VSCode e Cursor
- **Dependency Management**: Gerenciamento de dependências entre tarefas
- **Progress Tracking**: Acompanhamento de progresso em tempo real

### **CONTEXT7 MCP**
```json
{
  "command": "npx",
  "args": ["-y", "@smithery/cli@latest", "run", "@upstash/context7-mcp"],
  "enabled": true,
  "priority": 4,
  "capabilities": ["documentation", "examples", "library-search"],
  "env": {
    "UPSTASH_EMAIL": "${UPSTASH_EMAIL}",
    "UPSTASH_API_KEY": "${UPSTASH_API_KEY}"
  }
}
```

**Usage Patterns:**
- **Library Documentation**: Busca de documentação de bibliotecas
- **Code Examples**: Exemplos práticos de implementação
- **Best Practices**: Padrões e melhores práticas
- **API References**: Referências de APIs atualizadas

### **PLAYWRIGHT MCP**
```json
{
  "command": "npx",
  "args": ["-y", "@playwright/mcp@latest", "mcp"],
  "enabled": true,
  "priority": 5,
  "capabilities": ["browser-automation", "testing", "scraping"],
  "env": {
    "PLAYWRIGHT_BROWSERS_PATH": "0",
    "PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD": "false"
  }
}
```

**Automation Capabilities:**
- **Browser Testing**: Testes automatizados de interface
- **Web Scraping**: Extração de dados de páginas web
- **Visual Testing**: Testes visuais e screenshots
- **Performance Testing**: Testes de performance web

---

## 🔄 **SYNCHRONIZATION PROTOCOLS**

### **MASTER CONFIGURATION SYNC**
```python
# Automatic sync trigger conditions
SYNC_TRIGGERS = {
    "file_change": "mcp-master-unified.json modified",
    "validation_failure": "Configuration validation failed",
    "manual_request": "Explicit sync command",
    "scheduled": "Every 5 minutes during active development"
}

# Sync targets
SYNC_TARGETS = {
    "cursor": ".cursor/mcp.json",
    "vscode": ".vscode/mcp.json"
}
```

### **ENVIRONMENT-SPECIFIC GENERATION**
```python
# VSCode/Augment Configuration
def generate_vscode_config(master_config):
    return {
        "servers": ["sequential-thinking", "mcp-shrimp-task-manager"],
        "environment": "vscode-augment",
        "integration": "augment-native",
        "specialization": "backend-architecture"
    }

# Cursor Configuration  
def generate_cursor_config(master_config):
    return {
        "servers": ["sequential-thinking", "mcp-shrimp-task-manager", 
                   "figma-context-mcp", "playwright-mcp"],
        "environment": "cursor-frontend",
        "integration": "composer-chat",
        "specialization": "frontend-ui-ux"
    }
```

---

## 🎯 **ACTIVATION PROTOCOLS**

### **COMPLEXITY-BASED ACTIVATION**
```python
def assess_task_complexity(task_description, context):
    """
    Assess task complexity on scale 1-10
    
    Complexity ≥ 7: Activate Sequential Thinking MCP
    Complexity ≥ 5: Activate Task Manager MCP
    Multi-phase: Always activate Task Manager
    """
    complexity_factors = {
        "multi_step_reasoning": +3,
        "cross_domain_knowledge": +2,
        "architectural_decisions": +3,
        "integration_requirements": +2,
        "performance_optimization": +2,
        "security_considerations": +2,
        "multiple_technologies": +1,
        "complex_algorithms": +3
    }
    
    base_complexity = 1
    for factor, weight in complexity_factors.items():
        if factor in task_description.lower():
            base_complexity += weight
    
    return min(base_complexity, 10)
```

### **AUTOMATIC MCP SELECTION**
```python
def select_mcp_servers(task_type, complexity, environment):
    """Select appropriate MCP servers based on task characteristics."""
    
    servers = []
    
    # Always include core servers
    servers.append("sequential-thinking")  # For complex reasoning
    servers.append("mcp-shrimp-task-manager")  # For coordination
    
    # Add specialized servers based on task type
    if task_type in ["documentation", "research", "examples"]:
        servers.append("context7-mcp")
    
    if task_type in ["testing", "automation", "web"]:
        servers.append("playwright-mcp")
    
    if environment == "cursor" and task_type in ["ui", "design", "frontend"]:
        servers.append("figma-context-mcp")
    
    return servers
```

---

## 🔍 **VALIDATION PROTOCOLS**

### **CONFIGURATION VALIDATION**
```python
VALIDATION_RULES = {
    "required_fields": ["command", "args", "enabled"],
    "valid_commands": ["npx", "cmd", "python", "node"],
    "environment_variables": {
        "pattern": r"^\$\{[A-Z_]+\}$",
        "no_hardcoded_secrets": True
    },
    "server_health": {
        "response_timeout": 5000,  # 5 seconds
        "retry_attempts": 3
    }
}
```

### **SECURITY VALIDATION**
```python
def validate_security(server_config):
    """Validate security aspects of MCP server configuration."""
    
    security_checks = {
        "no_hardcoded_secrets": check_hardcoded_secrets(server_config),
        "environment_variables": validate_env_vars(server_config),
        "command_safety": validate_command_safety(server_config),
        "network_access": validate_network_permissions(server_config)
    }
    
    return all(security_checks.values())
```

---

## 🚨 **ERROR HANDLING PROTOCOLS**

### **SERVER FAILURE HANDLING**
```python
def handle_server_failure(server_name, error_type):
    """Handle MCP server failures with automatic recovery."""
    
    recovery_strategies = {
        "connection_timeout": restart_server,
        "invalid_response": validate_and_repair_config,
        "authentication_error": refresh_credentials,
        "resource_exhaustion": scale_resources
    }
    
    strategy = recovery_strategies.get(error_type, log_and_alert)
    return strategy(server_name)
```

### **FALLBACK MECHANISMS**
```python
FALLBACK_HIERARCHY = {
    "sequential-thinking": ["local-reasoning", "basic-analysis"],
    "mcp-shrimp-task-manager": ["simple-task-queue", "manual-coordination"],
    "context7-mcp": ["local-docs", "cached-examples"],
    "playwright-mcp": ["manual-testing", "basic-automation"]
}
```

---

## 📊 **MONITORING PROTOCOLS**

### **HEALTH CHECK SYSTEM**
```python
def health_check_all_servers():
    """Perform health check on all MCP servers."""
    
    health_status = {}
    
    for server_name, config in mcp_servers.items():
        try:
            response_time = ping_server(server_name)
            health_status[server_name] = {
                "status": "healthy" if response_time < 1000 else "slow",
                "response_time": response_time,
                "last_check": datetime.now().isoformat()
            }
        except Exception as e:
            health_status[server_name] = {
                "status": "unhealthy",
                "error": str(e),
                "last_check": datetime.now().isoformat()
            }
    
    return health_status
```

### **PERFORMANCE METRICS**
```python
PERFORMANCE_TARGETS = {
    "response_time": {
        "sequential-thinking": 100,  # ms
        "mcp-shrimp-task-manager": 150,  # ms
        "context7-mcp": 200,  # ms
        "playwright-mcp": 300  # ms
    },
    "availability": 99.5,  # %
    "error_rate": 0.1  # %
}
```

---

## 🔧 **MAINTENANCE PROTOCOLS**

### **AUTOMATIC UPDATES**
```python
def check_for_updates():
    """Check for MCP server updates and apply if safe."""
    
    update_policy = {
        "auto_update": ["patch", "security"],
        "manual_approval": ["minor", "major"],
        "testing_required": ["major", "breaking"]
    }
    
    for server in mcp_servers:
        available_updates = get_available_updates(server)
        for update in available_updates:
            if update.type in update_policy["auto_update"]:
                apply_update(server, update)
            else:
                schedule_manual_review(server, update)
```

### **BACKUP AND RECOVERY**
```python
def backup_mcp_configurations():
    """Create backup of all MCP configurations."""
    
    backup_data = {
        "timestamp": datetime.now().isoformat(),
        "master_config": load_master_config(),
        "generated_configs": {
            "cursor": load_cursor_config(),
            "vscode": load_vscode_config()
        },
        "server_states": get_all_server_states()
    }
    
    save_backup(backup_data)
    return backup_data
```

---

**🧠 VIBECODE SYSTEM V4.0 - MCP PROTOCOLS FOR INTELLIGENT COORDINATION**

*"Protocolos inteligentes para coordenação perfeita entre agentes especializados."*
