# 🚀 UNIFIED DEVELOPMENT ENVIRONMENT RULES - VIBECODE SYSTEM V4.0
## MANDATORY SYNCHRONIZATION BETWEEN VS CODE AND CURSOR

**VERSÃO**: 4.0 - Unificação Mandatória Absoluta
**DATA**: 2025-01-27
**AUTOR**: GRUPO US - VIBECODE SYSTEM
**STATUS**: REGRAS OBRIGATÓRIAS - CONFORMIDADE ABSOLUTA

---

## 📋 DECLARAÇÃO DE UNIFICAÇÃO MANDATÓRIA

### **PRINCÍPIO FUNDAMENTAL**
VS Code e Cursor DEVEM operar como um **SISTEMA ÚNICO E COESO**, compartilhando configurações, regras e workflows de forma **OBRIGATÓRIA, FORÇADA E SINCRONIZADA**. Qualquer desvio é automaticamente corrigido.

### **CONFORMIDADE ABSOLUTA**
- ✅ **Configurações Idênticas**: Sincronização forçada entre ambientes
- ✅ **Memory Bank Compartilhado**: Acesso unificado ao @project-core/memory/
- ✅ **Regras Universais**: Aplicação idêntica em ambos ambientes
- ❌ **Configurações Locais**: PROIBIDAS de sobrepor configurações centrais
- ❌ **Desvios de Padrão**: AUTOMATICAMENTE corrigidos

---

## 🧠 UNIFIED MEMORY SYSTEM PROTOCOL

### **Mandatory Memory Consultation (Both Environments)**

**🚨 CRITICAL: BEFORE ANY ACTION IN ANY ENVIRONMENT**

```bash
# 1. ALWAYS consult memory bank first
cat @project-core/memory/master_rule.md
cat @project-core/memory/self_correction_log.md
cat @project-core/memory/global-standards.md

# 2. Check for error patterns
grep -i "erro\|error\|bug" @project-core/memory/self_correction_log.md

# 3. Load environment-specific context
cat @project-core/rules/unified-development-environment-rules.md
```

### **Memory Bank Structure (Shared Across Environments)**

```
@project-core/memory/
├── master_rule.md                    # Core execution protocol
├── augment-agent-guidelines-v3.md    # Augment-specific guidelines
├── self_correction_log.md            # Shared learning and error prevention
├── global-standards.md               # Universal coding standards
├── coding_standards/                 # Stack-specific standards
├── protocols/                        # Execution and coordination protocols
└── unified-system-status.md          # Cross-environment status
```

---

## 🎯 ENVIRONMENT SPECIALIZATION MATRIX

### **VS Code + Augment - Backend & Architecture Specialist**
- **Primary Focus**: Complex architecture, backend development, system design
- **Complexity Range**: 7-10 (High complexity tasks)
- **Agents**: ARCHITECT (9-10), CODER (7-8)
- **Specializations**: Backend APIs, database operations, complex refactoring, system migrations
- **Tools**: Chat mode, Next Edit, Instructions, Sequential Thinking MCP, think-mcp-server
- **Memory Integration**: Full access to @project-core/memory/ system

### **Cursor AI - Frontend & UI Specialist**
- **Primary Focus**: Interactive development, component creation, UI/UX improvements
- **Complexity Range**: 3-6 (Low to medium complexity tasks)
- **Agents**: MANAGER (5-6), EXECUTOR (3-4)
- **Specializations**: Frontend components, styling, interactive debugging, visual testing
- **Tools**: Composer mode, Chat mode, Figma MCP, Playwright MCP
- **Memory Integration**: Shared access to @project-core/memory/ system

### **Both Environments - Research Specialist**
- **Primary Focus**: Research, analysis, documentation
- **Complexity Range**: 1-2 (Research and analysis tasks)
- **Agent**: RESEARCHER
- **Tools**: Tavily MCP, documentation tools
- **Memory Integration**: Contributes to shared knowledge base

---

## 🔄 UNIFIED EXECUTION PROTOCOL

### **Step 1: THINK (Unified Analysis)**
- **Memory Consultation**: MANDATORY consultation of @project-core/memory/master_rule.md
- **Environment Selection**: Automatic routing based on complexity and domain
- **Agent Selection**: ARCHITECT/CODER (VS Code) or MANAGER/EXECUTOR (Cursor)
- **Tool Activation**: MCP tools configured based on environment and complexity
- **Cross-Environment Awareness**: Context sharing between environments

### **Step 2: PLAN (Coordinated Planning)**
- **Unified Planning**: Shared planning process with cross-environment considerations
- **Handoff Planning**: When tasks require both environments, plan handoff protocols
- **Resource Allocation**: MCP tools and memory resources allocated per environment
- **Quality Gates**: Unified quality standards applied across environments
- **Sync Verification**: Ensure configuration and memory synchronization

### **Step 3: EXECUTE (Coordinated Implementation)**
- **VS Code Execution**: Use Chat for exploration, Next Edit for refactoring, Instructions for precise changes
- **Cursor Execution**: Use Composer for multi-file changes, Chat for debugging
- **Shared Standards**: Apply @project-core/rules/ coding standards universally
- **Memory Updates**: Document learnings in shared memory bank
- **Cross-Environment Coordination**: Manage handoffs and context preservation

### **Step 4: LEARN & IMPROVE (Unified Learning)**
- **Shared Documentation**: Update @project-core/memory/self_correction_log.md
- **Cross-Environment Patterns**: Document successful handoff patterns
- **Performance Metrics**: Track efficiency across both environments
- **Continuous Improvement**: Apply learnings to both environments

---

## 🤝 COORDINATION PROTOCOLS

### **Task Routing Algorithm**

```javascript
function routeTask(complexity, domain, context) {
  // Unified routing logic
  if (complexity >= 9 || domain.includes(["architecture", "migration"])) {
    return { environment: "vscode", agent: "ARCHITECT", tools: ["sequential-thinking"] };
  }
  if (complexity >= 7 || domain.includes(["backend", "api", "database"])) {
    return { environment: "vscode", agent: "CODER", tools: ["think-mcp-server"] };
  }
  if (complexity >= 5 || domain.includes(["coordination", "planning"])) {
    return { environment: "cursor", agent: "MANAGER", tools: ["mcp-shrimp"] };
  }
  if (complexity >= 3 || domain.includes(["frontend", "ui", "components"])) {
    return { environment: "cursor", agent: "EXECUTOR", tools: ["figma-mcp"] };
  }
  return { environment: "both", agent: "RESEARCHER", tools: ["tavily-mcp"] };
}
```

### **Handoff Protocols**

#### **VS Code → Cursor Handoff**
```markdown
**Trigger**: Frontend implementation needed
**Artifacts Transfer**:
- [ ] API specifications (functional and tested)
- [ ] Database schemas and operations
- [ ] Component specifications and requirements
- [ ] Integration points and protocols
- [ ] Performance requirements and benchmarks

**Validation Criteria**:
- [ ] APIs tested and functional
- [ ] Database operations validated
- [ ] Design patterns confirmed
- [ ] Performance benchmarks met
```

#### **Cursor → VS Code Handoff**
```markdown
**Trigger**: Backend integration or complex logic needed
**Artifacts Transfer**:
- [ ] UI components implemented and tested
- [ ] Frontend interfaces complete
- [ ] Integration tests written
- [ ] Component documentation
- [ ] Usability feedback and requirements

**Validation Criteria**:
- [ ] Responsive design confirmed
- [ ] Accessibility compliance verified (WCAG 2.1 AA)
- [ ] Performance optimized (≥90 Lighthouse)
- [ ] Cross-browser compatibility tested
```

---

## 🛠️ UNIFIED MCP INTEGRATION

### **MCP Servers (Environment-Specific)**

#### **VS Code MCP Stack**
- **Sequential Thinking**: Complex reasoning (complexity ≥ 7)
- **think-mcp-server**: Memory consultation and thought caching
- **MCP Shrimp Task Manager**: Task coordination and management

#### **Cursor MCP Stack**
- **MCP Shrimp Task Manager**: Task coordination and management
- **Figma MCP**: Design-to-code generation
- **Playwright MCP**: Visual testing and automation
- **Tavily MCP**: Research and documentation

### **MCP Configuration Path**
```json
{
  "unifiedMcpConfig": "@project-core/configs/mcp-master-unified.json",
  "vsCodeConfig": "@project-core/configs/ide/vscode/settings.json",
  "cursorConfig": "@project-core/configs/ide/cursor/mcp.json",
  "sharedAccess": true,
  "crossEnvironmentCompatibility": true,
  "syncRequired": true
}
```

---

## 🔒 SYNCHRONIZATION ENFORCEMENT

### **Configuration Synchronization (MANDATORY)**

```powershell
# Automatic synchronization script (runs continuously)
function Sync-UnifiedEnvironment {
    param(
        [switch]$Force
    )
    
    Write-Host "🔄 Starting Unified Environment Synchronization..."
    
    # Sync VS Code settings
    Copy-Item "@project-core/configs/ide/vscode/settings.json" ".vscode/settings.json" -Force
    
    # Sync Cursor rules
    Copy-Item "@project-core/configs/ide/cursor/.cursorrules" ".cursorrules" -Force
    Copy-Item "@project-core/configs/ide/cursor/mcp.json" ".cursor/mcp.json" -Force
    
    # Validate synchronization
    if (!(Test-UnifiedCompliance)) {
        if ($Force) {
            Write-Warning "⚠️ Forcing compliance..."
            Force-UnifiedCompliance
        } else {
            Write-Error "❌ SYNC FAILED - Manual intervention required"
            return $false
        }
    }
    
    Write-Host "✅ Unified Environment Synchronized Successfully"
    return $true
}
```

### **Compliance Validation (CONTINUOUS)**

```powershell
function Test-UnifiedCompliance {
    $compliance = @{
        MasterRule = Test-Path "@project-core/memory/master_rule.md"
        VSCodeSettings = Test-Path ".vscode/settings.json"
        CursorRules = Test-Path ".cursorrules"
        CursorMCP = Test-Path ".cursor/mcp.json"
        UnifiedConfig = Test-Path "@project-core/configs/ide/shared/unified-config.json"
        MemoryBankAccess = Test-MemoryBankIntegrity
        ConfigSync = Test-ConfigurationSync
    }
    
    $failedChecks = $compliance.GetEnumerator() | Where-Object { -not $_.Value }
    
    if ($failedChecks.Count -gt 0) {
        Write-Error "❌ COMPLIANCE FAILURES:"
        $failedChecks | ForEach-Object { Write-Error "  - $($_.Key)" }
        return $false
    }
    
    Write-Host "✅ UNIFIED COMPLIANCE VERIFIED"
    return $true
}
```

---

## 📊 UNIFIED QUALITY METRICS

### **Cross-Environment KPIs**
- **Configuration Sync Rate**: 100% (perfect synchronization)
- **Memory Bank Utilization**: ≥ 95% (maximum knowledge reuse)
- **Cross-Environment Consistency**: ≥ 98% (near-perfect consistency)
- **Handoff Success Rate**: ≥ 95% (smooth transitions)
- **Unified Learning Integration**: ≥ 90% (shared knowledge application)

### **Environment-Specific KPIs**

#### **VS Code + Augment**
- **Architecture Quality**: ≥ 95% (design pattern compliance)
- **Backend Performance**: ≥ 90% (API response times)
- **Code Complexity Management**: ≤ 7 (maintainable complexity)
- **Refactoring Success**: ≥ 95% (successful refactoring operations)

#### **Cursor AI**
- **UI Component Quality**: ≥ 95% (component reusability and quality)
- **Frontend Performance**: ≥ 90 Lighthouse Score
- **Accessibility Compliance**: 100% WCAG 2.1 AA
- **Visual Testing Coverage**: ≥ 90% (UI test coverage)

---

## 🚨 EMERGENCY PROTOCOLS

### **Configuration Drift Detection**
```powershell
# Continuous monitoring for configuration drift
function Monitor-ConfigurationDrift {
    while ($true) {
        if (!(Test-UnifiedCompliance)) {
            Write-Warning "🚨 CONFIGURATION DRIFT DETECTED"
            Sync-UnifiedEnvironment -Force
            
            # Log the incident
            Add-Content "@project-core/memory/self_correction_log.md" @"
## Configuration Drift Incident - $(Get-Date)
**Issue**: Configuration drift detected between VS Code and Cursor
**Action**: Automatic synchronization forced
**Status**: Resolved
**Prevention**: Enhanced monitoring implemented
"@
        }
        Start-Sleep -Seconds 30
    }
}
```

### **Emergency Restoration**
```powershell
# Emergency restoration of unified environment
function Restore-UnifiedEnvironment {
    Write-Host "🚨 EMERGENCY RESTORATION INITIATED"
    
    # Backup current state
    $backupPath = "@project-core/backups/emergency-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    New-Item -ItemType Directory -Path $backupPath -Force
    
    # Restore from master configurations
    Copy-Item "@project-core/configs/ide/" -Destination $backupPath -Recurse
    
    # Force synchronization
    Sync-UnifiedEnvironment -Force
    
    # Validate restoration
    if (Test-UnifiedCompliance) {
        Write-Host "✅ EMERGENCY RESTORATION SUCCESSFUL"
    } else {
        Write-Error "❌ EMERGENCY RESTORATION FAILED - MANUAL INTERVENTION REQUIRED"
    }
}
```

---

## 🎯 SUCCESS CRITERIA

### **Unified Environment Success Indicators**
- ✅ **Perfect Synchronization**: 100% configuration sync between environments
- ✅ **Seamless Handoffs**: ≥95% successful task transitions
- ✅ **Shared Learning**: Unified memory bank with cross-environment insights
- ✅ **Quality Consistency**: Uniform quality standards across environments
- ✅ **Performance Optimization**: 25-35% improvement through unified workflows

### **Operational Excellence Markers**
- ✅ **Zero Configuration Drift**: Automatic detection and correction
- ✅ **Unified Memory Access**: 100% memory bank utilization
- ✅ **Cross-Environment Learning**: Shared patterns and optimizations
- ✅ **Quality Gate Compliance**: 100% adherence to unified standards
- ✅ **Emergency Recovery**: <5 minutes restoration time

---

**LEMBRE-SE SEMPRE:**

- 🧠 **MEMORY FIRST** - Consulta obrigatória ao memory bank em ambos ambientes
- 🔄 **SYNC ALWAYS** - Sincronização contínua e forçada
- 🤖 **ROUTE SMART** - Roteamento inteligente baseado em complexidade
- 🤝 **HANDOFF SMOOTH** - Transições suaves entre ambientes
- 📚 **LEARN TOGETHER** - Aprendizado compartilhado e unificado
- 🎯 **EXCEL UNIFIED** - Excelência através da unificação

---

**UNIFIED DEVELOPMENT ENVIRONMENT - VIBECODE SYSTEM V4.0** - Where VS Code and Cursor Become One! 🚀🔄🤖

_"Na unificação dos ambientes, encontramos a perfeição do desenvolvimento."_
