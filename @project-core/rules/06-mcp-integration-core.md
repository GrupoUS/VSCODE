# 🛠️ MCP INTEGRATION CORE - GRUPO US VIBECODE SYSTEM V4.0

## 📋 CONSOLIDATION NOTICE

**This file consolidates and replaces:**
- `mcp-integration/05-auto-sync-on-task-completion.md`
- `mcp-integration/figma-design-sync.md`
- `mcp-integration/new-task-automation-90.md`
- `mcp-integration/playwright-automation.md`
- `mcp-integration/sequential_thinking_usability.md`
- `mcp-integration/supabase-database.md`

**Consolidation Date**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)

---

## 🎯 CORE MCP PROTOCOLS

### **Sequential Thinking Integration (Complexity ≥ 7)**
```bash
# Automatic activation for complex tasks
if (complexity >= 7) {
  sequentialthinking_Sequential_Thinking --mode=complex
  think-mcp-server --memory-integration=true
  mcp-shrimp-task-manager --coordination=true
}
```

### **MCP Shrimp Task Manager Protocol**
```bash
# Task lifecycle management
mcp-shrimp init
mcp-shrimp parse-prd scripts/prd.txt
mcp-shrimp list --status=all
mcp-shrimp execute --task-id=[id]
mcp-shrimp verify --task-id=[id]
```

### **Auto-Sync on Task Completion**
```markdown
## Post-Task Synchronization Protocol

**MUST Requirements:**
- [ ] All tasks completed via MCP Shrimp Task Manager
- [ ] User confirmation required before sync
- [ ] Security verification (no .env files, API keys)
- [ ] Git status check before execution

**Implementation:**
1. Check task completion: `mcp-shrimp list --status=completed`
2. Request user confirmation for GitHub sync
3. Verify security: check .gitignore and staging area
4. Execute: `scripts/force-sync-github.sh [branch]`
```

---

## 🎨 SPECIALIZED MCP TOOLS

### **Figma Design Sync Protocol**
```bash
# Figma integration setup
npm run figma:install
npm run figma:mcp
npm run figma:test

# Design-to-code workflow
figma-mcp extract-components --design-id=[id]
figma-mcp generate-code --component=[name]
figma-mcp validate-design --against-implementation
```

### **Playwright Automation Protocol**
```bash
# Playwright setup and testing
npm run playwright:install
npm run setup:automation
npm run mcp:start

# Automated testing workflows
playwright-mcp test --suite=e2e
playwright-mcp visual-test --baseline=true
playwright-mcp generate-test --from-user-flow
```

### **Supabase Database Integration**
```bash
# Supabase MCP operations
supabase-mcp connect --project-id=[id]
supabase-mcp query --sql="SELECT * FROM users"
supabase-mcp migrate --file=migration.sql
supabase-mcp backup --table=all
```

---

## 🔄 CONTEXT MANAGEMENT PROTOCOL

### **90% Context Window Automation**
```javascript
// Continuous context monitoring
const contextUsage = getCurrentContextUsage();

if (contextUsage >= 0.9) {
  // Complete current logical step
  await completeCurrentStep();
  
  // Propose task handoff
  await askFollowupQuestion({
    question: "Context window at 90%. Recommend new task for continuation?",
    options: ["Yes, create new task", "Continue current session"]
  });
  
  // Create comprehensive context package
  const contextPackage = {
    currentProgress: getCurrentProgress(),
    nextSteps: getPlannedSteps(),
    codeContext: getRelevantCode(),
    dependencies: getActiveDependencies()
  };
  
  // Transfer to new task
  await createNewTask(contextPackage);
}
```

### **Context Handoff Validation**
- [ ] Context usage accurately monitored
- [ ] Handoff triggered at exactly 90%
- [ ] Current work completed before handoff
- [ ] Comprehensive context package created
- [ ] User approval obtained
- [ ] New task successfully created
- [ ] Context successfully transferred

---

## 🔧 MCP SERVER CONFIGURATION

### **Unified MCP Configuration**
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "priority": "critical",
      "autoActivate": "complexity >= 7"
    },
    "mcp-shrimp-task-manager": {
      "command": "npx",
      "args": ["-y", "mcp-shrimp-task-manager"],
      "priority": "high",
      "autoActivate": "task_coordination"
    },
    "playwright-mcp": {
      "command": "npx",
      "args": ["-y", "playwright-mcp"],
      "priority": "medium",
      "autoActivate": "testing_needed"
    },
    "figma-mcp": {
      "command": "npx",
      "args": ["-y", "figma-mcp"],
      "priority": "medium",
      "autoActivate": "design_sync"
    },
    "supabase-mcp": {
      "command": "npx",
      "args": ["-y", "supabase-mcp"],
      "priority": "medium",
      "autoActivate": "database_operations"
    },
    "tavily-mcp": {
      "command": "npx",
      "args": ["-y", "@tavily-ai/tavily-mcp"],
      "priority": "low",
      "autoActivate": "research_needed"
    }
  }
}
```

### **Activation Rules**
- **Sequential Thinking**: Complexity ≥ 7 OR multi-phase projects
- **MCP Shrimp**: Task coordination OR project management
- **Playwright**: Testing OR automation requirements
- **Figma**: Design sync OR component generation
- **Supabase**: Database operations OR data management
- **Tavily**: Research OR information gathering

---

## 🚨 SECURITY & VALIDATION

### **Pre-Execution Security Checks**
```bash
# Security validation before any MCP operation
check_gitignore_exists() {
  test -f .gitignore || echo "WARNING: No .gitignore found"
}

check_env_files() {
  git status --porcelain | grep -E "\.env" && echo "ERROR: .env files in staging"
}

check_api_keys() {
  grep -r "api_key\|secret\|password" . --exclude-dir=node_modules || true
}

validate_branch() {
  git branch --show-current
}
```

### **Error Handling & Recovery**
- **Failed MCP Connection**: Automatic fallback to manual execution
- **Context Overflow**: Emergency task handoff protocol
- **Security Violation**: Immediate operation halt and user notification
- **Sync Failure**: Rollback and error reporting

---

## 📊 MONITORING & METRICS

### **MCP Performance Tracking**
- **Response Times**: Monitor MCP server response latency
- **Success Rates**: Track operation success/failure ratios
- **Context Efficiency**: Measure context window utilization
- **Task Completion**: Monitor task lifecycle metrics

### **Quality Assurance**
- **Integration Tests**: Automated MCP server connectivity tests
- **Workflow Validation**: End-to-end workflow verification
- **Security Audits**: Regular security protocol validation
- **Performance Benchmarks**: Continuous performance monitoring

---

**Consolidation Complete**: This file unifies all MCP integration protocols
**Performance**: 6 files → 1 file (83% reduction)
**Functionality**: 100% preserved with enhanced coordination
**Last Updated**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)
**Next Review**: 2025-07-11
