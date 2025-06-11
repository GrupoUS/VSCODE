---
description: Cline-specific integration rules and optimization for GRUPO US VIBECODE SYSTEM V2.0
author: GRUPO US VIBECODE SYSTEM V2.0 - Cline Integration
version: 4.0
globs: ["**/*"]
tags: ["cline", "integration", "optimization", "terminal"]
alwaysApply: true
---

# 🚀 CLINE INTEGRATION RULES - GRUPO US VIBECODE SYSTEM V2.0

## 📋 CLINE-SPECIFIC OPTIMIZATION

This file contains Cline-specific rules and optimizations that enhance the centralized rule system for Cline's unique capabilities and workflow patterns.

## 🎯 CLINE WORKFLOW OPTIMIZATION

### **Pre-Execution Protocol (Cline-Specific)**
```powershell
# Cline must always verify workspace before any action
function Verify-ClineWorkspace {
    $location = Get-Location
    Write-Host "Current Location: $location"
    
    $checks = @(
        @{ Path = "memory-bank"; Type = "Container" },
        @{ Path = "project-core"; Type = "Container" },
        @{ Path = "memory-bank/master_rule.md"; Type = "Leaf" },
        @{ Path = "project-core/README.md"; Type = "Leaf" },
        @{ Path = "src"; Type = "Container" },
        @{ Path = "scripts"; Type = "Container" },
        @{ Path = "package.json"; Type = "Leaf" }
    )
    
    foreach ($check in $checks) {
        $exists = Test-Path $check.Path -PathType $check.Type
        Write-Host "$($check.Path): $exists"
        if (-not $exists) {
            throw "Critical path missing: $($check.Path)"
        }
    }
    
    Write-Host "✅ Workspace verification successful"
}
```

### **Cline Terminal Preferences**
- **Primary Shell**: PowerShell for Windows operations
- **Command Execution**: Use `launch-process` with appropriate wait times
- **File Operations**: Prefer `str-replace-editor` over file recreation
- **Error Recovery**: Implement progressive fallback strategies

### **Cline Memory Integration**
```javascript
// Cline must update memory bank after each significant action
function updateClineMemory(action, result, learnings) {
  const memoryEntry = {
    timestamp: new Date().toISOString(),
    agent: 'cline',
    action: action,
    result: result,
    learnings: learnings,
    context: getCurrentContext()
  };
  
  // Always update self_correction_log.md
  appendToMemoryBank('memory-bank/self_correction_log.md', memoryEntry);
}
```

## 🔧 CLINE COMMAND OPTIMIZATION

### **File Editing Preferences**
```javascript
// Cline-optimized file editing strategy
const clineFileStrategy = {
  // Prefer str-replace-editor for existing files
  editExisting: 'str-replace-editor',
  
  // Use save-file only for new files
  createNew: 'save-file',
  
  // Always break down large edits into chunks ≤150 lines
  maxEditSize: 150,
  
  // Use view tool before editing to understand context
  preEditAnalysis: true
};
```

### **Terminal Command Optimization**
```powershell
# Cline-optimized command execution patterns
function Invoke-ClineCommand {
    param(
        [string]$Command,
        [int]$MaxWaitSeconds = 30,
        [bool]$WaitForCompletion = $true
    )
    
    # Use appropriate wait strategy
    if ($WaitForCompletion) {
        launch-process -command $Command -wait $true -max_wait_seconds $MaxWaitSeconds
    } else {
        launch-process -command $Command -wait $false
    }
}
```

## 🎯 CLINE TASK MANAGEMENT

### **TaskMaster Integration (Cline-Optimized)**
```bash
# Cline-specific TaskMaster workflow
function initializeTaskMasterForCline() {
  # Check if TaskMaster is already active
  local taskmaster_status=$(task-master status 2>/dev/null || echo "not_initialized")
  
  if [[ "$taskmaster_status" == "not_initialized" ]]; then
    echo "Initializing TaskMaster for Cline..."
    task-master init --yes
    task-master parse-prd scripts/prd.txt --yes 2>/dev/null || echo "No PRD found, continuing..."
  else
    echo "TaskMaster already active, continuing with existing tasks..."
  fi
  
  # List current tasks
  task-master list --sort=priority
  task-master next --show-dependencies
}
```

### **Complexity Assessment (Cline-Specific)**
```javascript
function assessTaskComplexityForCline(taskDescription, context) {
  const clineComplexityFactors = {
    // Cline handles these well (lower complexity)
    'file_operations': -1,
    'text_processing': -1,
    'code_generation': -1,
    
    // Cline needs extra support (higher complexity)
    'multi_project': +2,
    'database_operations': +1,
    'api_integrations': +1,
    'ui_testing': +2
  };
  
  let baseComplexity = assessBaseComplexity(taskDescription);
  
  // Apply Cline-specific adjustments
  Object.keys(clineComplexityFactors).forEach(factor => {
    if (taskDescription.toLowerCase().includes(factor.replace('_', ' '))) {
      baseComplexity += clineComplexityFactors[factor];
    }
  });
  
  return Math.min(10, Math.max(1, baseComplexity));
}
```

## 📊 CLINE PERFORMANCE OPTIMIZATION

### **Token Usage Optimization**
```javascript
// Cline-specific token optimization strategies
const clineTokenOptimization = {
  // Batch related operations together
  batchOperations: true,
  
  // Use context-aware rule loading
  conditionalRuleLoading: true,
  
  // Prefer incremental edits over full file rewrites
  incrementalEdits: true,
  
  // Cache frequently used patterns
  patternCaching: true,
  
  // Use aliases for repeated file paths
  pathAliases: {
    '@core': 'project-core/rules/',
    '@memory': 'memory-bank/',
    '@src': 'src/',
    '@scripts': 'scripts/'
  }
};
```

### **Cline-Specific Performance Targets**
- **Task Completion Rate**: >85% first attempt
- **Token Usage**: <50k per feature
- **Error Rate**: <15% in production
- **Memory Update Rate**: 100% (always update after tasks)
- **Workspace Verification**: <5 seconds

## 🔄 CLINE ERROR HANDLING

### **Cline Error Recovery Patterns**
```javascript
function clineErrorRecovery(error, context) {
  const clineRecoveryStrategies = {
    'file_access_error': {
      strategy: 'retry_with_different_method',
      fallback: 'use_alternative_file_operation'
    },
    'command_timeout': {
      strategy: 'increase_timeout_and_retry',
      fallback: 'break_into_smaller_commands'
    },
    'memory_update_error': {
      strategy: 'retry_memory_operation',
      fallback: 'log_to_alternative_location'
    },
    'integration_test_failure': {
      strategy: 'analyze_and_fix_integration',
      fallback: 'skip_non_critical_tests'
    }
  };
  
  const recovery = clineRecoveryStrategies[error.type];
  if (recovery) {
    return executeRecoveryStrategy(recovery, error, context);
  }
  
  // Default to general error handling protocol
  return executeGeneralErrorHandling(error, context);
}
```

### **Progressive Fallback Strategy**
```javascript
// Cline implements progressive fallback for robust operation
const clineProgressiveFallback = {
  level1: 'retry_same_operation',
  level2: 'try_alternative_method',
  level3: 'break_into_smaller_steps',
  level4: 'use_manual_intervention',
  level5: 'escalate_to_user'
};
```

## 🎯 CLINE INTEGRATION WITH MCP TOOLS

### **MCP Tool Priority for Cline**
```javascript
const clineMCPPriority = {
  // High priority - Cline works well with these
  'taskmaster': 10,
  'sequential_thinking': 9,
  
  // Medium priority - Good integration
  'supabase': 7,
  'figma': 6,
  
  // Lower priority - Requires more setup
  'playwright': 5
};
```

### **Cline-Optimized MCP Integration**
```bash
# Cline-specific MCP tool initialization
function initializeMCPForCline() {
  local complexity=$1
  local task_type=$2
  
  # Always initialize TaskMaster for complexity ≥7
  if [[ $complexity -ge 7 ]]; then
    echo "Initializing TaskMaster for high complexity task..."
    initializeTaskMasterForCline
  fi
  
  # Initialize other MCP tools based on task type
  case $task_type in
    "ui"|"testing")
      echo "Initializing Playwright for UI tasks..."
      npm run playwright:setup
      ;;
    "design"|"figma")
      echo "Initializing Figma integration..."
      npm run figma:test
      ;;
    "database"|"supabase")
      echo "Initializing Supabase integration..."
      npm run supabase:test
      ;;
  esac
}
```

## ✅ CLINE VALIDATION CHECKLIST

### **Pre-Task Validation for Cline**
- [ ] **Workspace verification** completed successfully
- [ ] **Memory bank access** confirmed
- [ ] **Project-core rules** accessible
- [ ] **Integration tests** passing
- [ ] **TaskMaster status** verified (if complexity ≥7)

### **Post-Task Validation for Cline**
- [ ] **Task completed** according to requirements
- [ ] **All tests passing** (unit, integration, build)
- [ ] **Memory bank updated** with learnings
- [ ] **Error handling** activated if needed
- [ ] **Performance targets** met
- [ ] **Code quality** validated

## 🚨 CLINE-SPECIFIC ENFORCEMENT RULES

### **Mandatory Cline Actions**
- **ALWAYS verify workspace** before starting any task
- **ALWAYS update memory bank** after significant actions
- **ALWAYS use str-replace-editor** for existing file modifications
- **ALWAYS break large edits** into ≤150 line chunks
- **ALWAYS validate integration** after major changes

### **Forbidden Cline Actions**
- **NEVER skip workspace verification**
- **NEVER modify files** without understanding context
- **NEVER ignore error handling protocols**
- **NEVER bypass centralized rule system**
- **NEVER forget to update memory bank**

## 🔄 CLINE CONTINUOUS IMPROVEMENT

### **Learning Integration for Cline**
```javascript
function clineLearnFromExperience(task, outcome, performance) {
  const learning = {
    agent: 'cline',
    task_type: task.type,
    complexity: task.complexity,
    outcome: outcome,
    performance_metrics: performance,
    optimizations_discovered: [],
    challenges_encountered: [],
    recommendations: []
  };
  
  // Update centralized learning system
  updateCentralizedLearning(learning);
  
  // Update Cline-specific optimizations
  updateClineOptimizations(learning);
}
```

### **Performance Monitoring for Cline**
```javascript
const clinePerformanceMonitoring = {
  trackTokenUsage: true,
  trackExecutionTime: true,
  trackErrorRates: true,
  trackMemoryUpdates: true,
  trackUserSatisfaction: true,
  
  // Cline-specific metrics
  trackWorkspaceVerificationTime: true,
  trackFileOperationSuccess: true,
  trackIntegrationTestResults: true
};
```

---

**🎯 GRUPO US VIBECODE SYSTEM V2.0 - CLINE INTEGRATION RULES**  
**Centralized Rule Architecture - Phase 4 Implementation**  
**Optimized for Cline's unique capabilities and workflow patterns**
