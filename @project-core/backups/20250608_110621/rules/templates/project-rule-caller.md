---
description: Universal caller rule template that references centralized @project-core/rules/ system
author: GRUPO US VIBECODE SYSTEM V2.0
version: 4.0
globs: ["**/*"]
tags: ["caller", "centralized", "template", "mandatory"]
alwaysApply: true
---

# 🚀 GRUPO US CENTRALIZED RULE CALLER - PROJECT TEMPLATE

## 📋 CRITICAL NOTICE

**This file is a CALLER RULE that references the centralized rule system.**

**⚠️ DO NOT MODIFY THIS FILE DIRECTLY**  
**✅ ALL rule modifications must target @project-core/rules/ exclusively**

## 🎯 CENTRALIZED RULE SYSTEM REFERENCE

### **MANDATORY RULE LOADING SEQUENCE:**

#### **STEP 1: CORE RULES (ALWAYS LOADED)**
```markdown
@file:project-core/rules/00-master-execution-protocol.md
@file:project-core/rules/01-core-principles.md
@file:project-core/rules/02-coding-standards-universal.md
@file:project-core/rules/universal-pre-execution-verification.md
```

#### **STEP 2: FRAMEWORK RULES (CONDITIONAL)**
```markdown
# Load based on project tech stack detection
@file:project-core/rules/frameworks/nextjs-react.md          # For Next.js projects
@file:project-core/rules/frameworks/laravel-livewire.md     # For Laravel projects
@file:project-core/rules/frameworks/component-naming-standards.mdc  # Universal components
```

#### **STEP 3: MCP INTEGRATION RULES (CONDITIONAL)**
```markdown
# Load based on complexity and task requirements
@file:project-core/rules/mcp-integration/taskmaster-protocol.md      # Complexity ≥7
@file:project-core/rules/mcp-integration/playwright-automation.md    # UI testing
@file:project-core/rules/mcp-integration/figma-design-sync.md        # Design integration
@file:project-core/rules/mcp-integration/supabase-database.md        # Database operations
@file:project-core/rules/mcp-integration/sequential_thinking_usability.md  # Complex reasoning
```

#### **STEP 4: WORKFLOW RULES (CONDITIONAL)**
```markdown
# Load based on task type and context
@file:project-core/rules/workflows/development-workflow.md     # Standard development
@file:project-core/rules/workflows/error-handling-protocol.md  # Error scenarios
@file:project-core/rules/workflows/self-improvement-protocol.md # Learning tasks
@file:project-core/rules/workflows/project-sync-automation.md  # Cross-project tasks
```

#### **STEP 5: TOOLING RULES (CONDITIONAL)**
```markdown
# Load based on active AI agent
@file:project-core/rules/tooling/cursor-integration.md    # For Cursor agent
@file:project-core/rules/tooling/roo-code-integration.md  # For Roo Code agent
@file:project-core/rules/tooling/cline-integration.md     # For Cline agent
```

#### **STEP 6: PROJECT OVERRIDES (CONDITIONAL)**
```markdown
# Load project-specific overrides if they exist
@file:project-core/rules/project-overrides/{PROJECT_NAME}-overrides.md
```

## 🚨 ENFORCEMENT RULES

### **MANDATORY REDIRECTION PROTOCOL:**

**✅ CORRECT ACTIONS:**
- Update rules in @project-core/rules/
- Create new rules in @project-core/rules/
- Modify existing rules in @project-core/rules/
- Reference centralized rules via @file: imports

**❌ FORBIDDEN ACTIONS:**
- Modify this caller rule file
- Create local rule files in project directories
- Update scattered rule files outside @project-core/
- Bypass centralized rule system

### **RULE MODIFICATION WORKFLOW:**

1. **Identify Rule Category**: Core, Framework, MCP, Workflow, Tooling, or Override
2. **Target Correct Directory**: Navigate to appropriate @project-core/rules/ subdirectory
3. **Update Centralized Rule**: Make changes in centralized location
4. **Validate Integration**: Run integration tests to ensure rule loading works
5. **Update Documentation**: Update @project-core/rules/README.md if needed

## 🔄 CONDITIONAL LOADING ALGORITHM

### **Framework Detection:**
```javascript
function detectFramework(taskDescription, projectContext) {
  if (projectContext.includes('next.js') || projectContext.includes('react')) {
    return 'nextjs-react';
  }
  if (projectContext.includes('laravel') || projectContext.includes('livewire')) {
    return 'laravel-livewire';
  }
  return 'universal';
}
```

### **Complexity Assessment:**
```javascript
function assessComplexity(taskDescription) {
  const complexityIndicators = [
    'multi-phase', 'architecture', 'refactor', 'migration',
    'integration', 'optimization', 'security', 'performance'
  ];
  
  const matches = complexityIndicators.filter(indicator => 
    taskDescription.toLowerCase().includes(indicator)
  ).length;
  
  return Math.min(10, Math.max(1, matches * 2 + 3));
}
```

### **MCP Tool Selection:**
```javascript
function selectMCPTools(complexity, taskDescription) {
  const tools = [];
  
  if (complexity >= 7) {
    tools.push('taskmaster-protocol');
  }
  
  if (taskDescription.includes('ui') || taskDescription.includes('test')) {
    tools.push('playwright-automation');
  }
  
  if (taskDescription.includes('design') || taskDescription.includes('figma')) {
    tools.push('figma-design-sync');
  }
  
  if (taskDescription.includes('database') || taskDescription.includes('supabase')) {
    tools.push('supabase-database');
  }
  
  if (complexity >= 5) {
    tools.push('sequential_thinking_usability');
  }
  
  return tools;
}
```

## 📊 PERFORMANCE OPTIMIZATION

### **Token Usage Reduction:**
- **Conditional Loading**: Only load relevant rules for current task
- **Smart Caching**: Cache frequently used rule combinations
- **Lazy Loading**: Load specialized rules only when needed
- **Context Awareness**: Detect project type and load appropriate frameworks

### **Loading Efficiency:**
- **Hierarchical Loading**: Master → Core → Conditional
- **Dependency Resolution**: Load dependencies in correct order
- **Conflict Prevention**: Centralized rules prevent conflicts
- **Version Control**: Single source of truth for all rule versions

## 🎯 PROJECT CUSTOMIZATION

### **To Customize This Caller Rule for Specific Project:**

1. **Copy Template**: Copy this file to project Rules/ directory
2. **Update Project Name**: Replace {PROJECT_NAME} with actual project name
3. **Configure Overrides**: Create project-specific override file if needed
4. **Test Integration**: Validate rule loading with integration tests

### **Project-Specific Override Example:**
```markdown
# In project-core/rules/project-overrides/neonpro-overrides.md
- **NEONPRO-Specific Rule**: Use Horizon UI Pro components exclusively
- **Performance Target**: Build time <60s, Component generation <5s
- **Tech Stack Override**: Next.js 14 + TypeScript + Tailwind CSS + Supabase
```

## ✅ VALIDATION CHECKLIST

Before deploying this caller rule:

- [ ] All @file: references point to existing centralized rules
- [ ] Project-specific overrides created if needed
- [ ] Integration tests pass with new rule structure
- [ ] Performance metrics meet targets (<50k tokens per feature)
- [ ] Documentation updated in @project-core/rules/README.md

---

**REMEMBER**: This is a CALLER RULE. All actual rule content lives in @project-core/rules/.  
**Modifications**: Target @project-core/rules/ exclusively for all rule changes.  
**Enforcement**: Centralized rule architecture prevents rule fragmentation.  

**🎯 GRUPO US VIBECODE SYSTEM V2.0 - PHASE 4 CENTRALIZED RULE ARCHITECTURE**
