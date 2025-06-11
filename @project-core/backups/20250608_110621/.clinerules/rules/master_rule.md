---
description: Cline-specific caller rule that references centralized @project-core/rules/ system
author: GRUPO US VIBECODE SYSTEM V2.0 - Cline Integration - Phase 4
version: 4.0
globs: ["**/*"]
tags: ["cline", "caller", "centralized", "mandatory", "phase4"]
alwaysApply: true
---

# 🚀 CLINE CENTRALIZED RULE CALLER - GRUPO US VIBECODE SYSTEM V2.0

## 📋 CRITICAL NOTICE FOR CLINE - PHASE 4 IMPLEMENTATION

**This file is a CLINE-SPECIFIC CALLER RULE that references the centralized rule system.**

**⚠️ DO NOT MODIFY THIS FILE DIRECTLY**
**✅ ALL rule modifications must target @project-core/rules/ exclusively**

**🎯 PHASE 4 STATUS**: Centralized Rule Architecture Implementation Complete

## 🚨 MANDATORY CLINE INITIALIZATION SEQUENCE

### **STEP 0: Workspace Verification (CLINE-SPECIFIC)**

```powershell
# Cline must verify workspace before any action
Get-Location
Test-Path "memory-bank" -PathType Container
Test-Path "project-core" -PathType Container
Test-Path "memory-bank/master_rule.md" -PathType Leaf
Test-Path "project-core/README.md" -PathType Leaf
Test-Path "src" -PathType Container
Test-Path "scripts" -PathType Container
Test-Path "package.json" -PathType Leaf
```

### **STEP 1: CORE RULES (ALWAYS LOADED FOR CLINE)**

```markdown
@file:project-core/rules/00-master-execution-protocol.md
@file:project-core/rules/01-core-principles.md
@file:project-core/rules/02-coding-standards-universal.md
@file:project-core/rules/universal-pre-execution-verification.md
```

### **STEP 2: CLINE-SPECIFIC TOOLING RULES**

```markdown
@file:project-core/rules/tooling/cline-integration.md
@file:project-core/rules/workflows/development-workflow.md
@file:project-core/rules/workflows/error-handling-protocol.md
```

### **STEP 3: TASKMASTER INTEGRATION (COMPLEXITY ≥7)**

```markdown
# Mandatory for complex tasks

@file:project-core/rules/mcp-integration/taskmaster-protocol.md
@file:project-core/rules/mcp-integration/sequential_thinking_usability.md
```

### **STEP 4: FRAMEWORK DETECTION & LOADING**

```markdown
# Auto-detect and load appropriate framework rules

@file:project-core/rules/frameworks/nextjs-react.md # If Next.js detected
@file:project-core/rules/frameworks/laravel-livewire.md # If Laravel detected
@file:project-core/rules/frameworks/component-naming-standards.mdc
```

### **STEP 5: MCP INTEGRATION (CONDITIONAL)**

```markdown
# Load based on task requirements

@file:project-core/rules/mcp-integration/playwright-automation.md # UI testing tasks
@file:project-core/rules/mcp-integration/figma-design-sync.md # Design tasks
@file:project-core/rules/mcp-integration/supabase-database.md # Database tasks
```

## 🚨 CLINE-SPECIFIC ENFORCEMENT RULES

### **MANDATORY CLINE WORKFLOW:**

1. **Pre-Execution Verification**: Always verify workspace structure
2. **TaskMaster Initialization**: For complexity ≥7 tasks
3. **4-Step Execution Cycle**: ULTRATHINK → PLAN → EXECUTE → LEARN
4. **Memory Bank Updates**: Update self_correction_log.md after completion
5. **Confidence Assessment**: Maintain ≥8/10 confidence or ask for clarification

### **CLINE RULE MODIFICATION PROTOCOL:**

**✅ CORRECT ACTIONS FOR CLINE:**

- Navigate to @project-core/rules/ for all rule modifications
- Use str-replace-editor for rule updates
- Update memory-bank/self_correction_log.md with learnings
- Reference centralized rules via @file: imports

**❌ FORBIDDEN ACTIONS FOR CLINE:**

- Modify .clinerules/ files directly (except this caller)
- Create new rule files outside @project-core/
- Bypass centralized rule system
- Skip pre-execution verification

## 🔄 CLINE CONDITIONAL LOADING ALGORITHM

### **Cline Task Analysis:**

```javascript
function analyzeTaskForCline(taskDescription, context) {
  const analysis = {
    complexity: assessComplexity(taskDescription),
    framework: detectFramework(context),
    mcpTools: [],
    workflows: ["development-workflow"],
  };

  // TaskMaster required for complexity ≥7
  if (analysis.complexity >= 7) {
    analysis.mcpTools.push("taskmaster-protocol");
    analysis.mcpTools.push("sequential_thinking_usability");
  }

  // UI/Testing tasks
  if (taskDescription.includes("ui") || taskDescription.includes("test")) {
    analysis.mcpTools.push("playwright-automation");
  }

  // Design tasks
  if (taskDescription.includes("design") || taskDescription.includes("figma")) {
    analysis.mcpTools.push("figma-design-sync");
  }

  // Database tasks
  if (
    taskDescription.includes("database") ||
    taskDescription.includes("supabase")
  ) {
    analysis.mcpTools.push("supabase-database");
  }

  // Error handling
  if (taskDescription.includes("error") || taskDescription.includes("fix")) {
    analysis.workflows.push("error-handling-protocol");
  }

  return analysis;
}
```

## 🎯 CLINE MEMORY INTEGRATION

### **Memory Bank Integration:**

```markdown
# Cline must reference memory bank for learning

@file:memory-bank/master_rule.md # Core memory rules
@file:memory-bank/self_correction_log.md # Learning history
@file:memory-bank/augment-agent-guidelines-v2.md # Updated guidelines
```

### **Learning Protocol for Cline:**

```markdown
# After task completion, Cline must update:

1. memory-bank/self_correction_log.md - Document learnings
2. project-core/rules/ - Update relevant rules if needed
3. Validate changes with integration tests
4. Ensure centralized rule architecture maintained
```

## 📊 CLINE PERFORMANCE OPTIMIZATION

### **Token Usage Optimization for Cline:**

- **Conditional Loading**: Load only relevant rules for current task
- **Context Awareness**: Use workspace verification to optimize loading
- **Batch Operations**: Group related rule updates together
- **Smart Caching**: Cache frequently used rule combinations

### **Cline-Specific Targets:**

- **Completion Rate**: >85% first attempt
- **Token Usage**: <50k per feature
- **Error Rate**: <15% in production
- **User Satisfaction**: >9/10

## 🔧 CLINE INTEGRATION VALIDATION

### **Pre-Task Validation for Cline:**

```bash
# Cline must run these checks before starting any task
npm run integration:test
task-master status
task-master list --status=pending
```

### **Post-Task Validation for Cline:**

```bash
# Cline must run these checks after completing any task
npm run integration:test
task-master complete [task-id]
# Update memory-bank/self_correction_log.md
```

## ✅ CLINE DEPLOYMENT CHECKLIST

Before using this caller rule with Cline:

- [ ] Workspace verification commands work
- [ ] All @file: references point to existing centralized rules
- [ ] TaskMaster integration functional
- [ ] Memory bank integration working
- [ ] Integration tests pass
- [ ] Performance targets achievable

---

**REMEMBER FOR CLINE**: This is a CALLER RULE. All actual rule content lives in @project-core/rules/.
**Cline Workflow**: Pre-verification → Rule loading → Task execution → Memory update
**Enforcement**: Centralized rule architecture prevents rule fragmentation.

**🎯 GRUPO US VIBECODE SYSTEM V2.0 - PHASE 4 CLINE INTEGRATION**
**Status**: ✅ CENTRALIZED RULE ARCHITECTURE IMPLEMENTATION COMPLETE
