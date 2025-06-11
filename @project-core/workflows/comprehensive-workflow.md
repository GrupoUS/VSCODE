# 🔄 COMPREHENSIVE WORKFLOW - GRUPO US VIBECODE SYSTEM V4.0

## 📋 CONSOLIDATION NOTICE

**This file consolidates and replaces:**
- `workflows/development-workflow.md`
- `workflows/error-handling-protocol.md`
- `workflows/intelligent-task-workflow.md`
- `workflows/sync-github.md`

**Consolidation Date**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)

---

## 🚀 MASTER DEVELOPMENT WORKFLOW

### **Phase 1: Project Initialization**
```bash
# 1. Load VIBECODE System V4.0
cat @project-core/memory/master_rule.md

# 2. Assess Task Complexity (1-10 scale)
complexity_assessment=$(assess_task_complexity "$task_description")

# 3. Select Appropriate Agent
if [ $complexity_assessment -ge 9 ]; then
  agent="ARCHITECT"
  model="claude-sonnet-4"
elif [ $complexity_assessment -ge 7 ]; then
  agent="CODER"
  model="claude-sonnet-4"
elif [ $complexity_assessment -ge 5 ]; then
  agent="MANAGER"
  model="gemini-2.5-pro"
elif [ $complexity_assessment -ge 3 ]; then
  agent="EXECUTOR"
  model="gemini-flash"
else
  agent="RESEARCHER"
  model="gemini-flash"
fi

# 4. Activate MCP Tools Based on Complexity
if [ $complexity_assessment -ge 7 ]; then
  activate_sequential_thinking
  activate_think_mcp_server
  activate_mcp_shrimp_task_manager
fi
```

### **Phase 2: Memory Bank Consultation**
```bash
# Mandatory FMC consultation
cat @project-core/memory/self_correction_log.md
cat @project-core/memory/global-standards.md

# Check for error patterns
grep -i "erro\|error\|bug" @project-core/memory/self_correction_log.md

# Load relevant coding standards
cat @project-core/rules/02-coding-standards-universal.md
```

### **Phase 3: Planning & Strategy**
```bash
# For complexity >= 7: Use Sequential Thinking MCP
if [ $complexity_assessment -ge 7 ]; then
  sequentialthinking_Sequential_Thinking \
    --thought="Analyzing task requirements and dependencies" \
    --complexity=$complexity_assessment
fi

# For all tasks: Use MCP Shrimp for task coordination
mcp-shrimp-task-manager plan_task \
  --description="$task_description" \
  --complexity=$complexity_assessment \
  --agent=$agent
```

### **Phase 4: Implementation**
```bash
# Execute with selected agent and tools
case $agent in
  "ARCHITECT")
    # Complex architectural work
    implement_architecture_changes
    validate_system_design
    ;;
  "CODER")
    # Backend/API development
    implement_backend_features
    run_integration_tests
    ;;
  "MANAGER")
    # Project coordination
    coordinate_team_tasks
    manage_project_timeline
    ;;
  "EXECUTOR")
    # Frontend/UI work
    implement_ui_components
    apply_design_system
    ;;
  "RESEARCHER")
    # Research and analysis
    conduct_technical_research
    document_findings
    ;;
esac
```

### **Phase 5: Quality Assurance**
```bash
# Run comprehensive validation
npm run lint
npm run type-check
npm run test
npm run build

# Security validation
check_for_secrets
validate_gitignore
audit_dependencies

# Performance validation
run_performance_tests
validate_bundle_size
```

### **Phase 6: Documentation & Learning**
```bash
# Update memory bank with learnings
update_self_correction_log "$task_results"

# Document new patterns
if [ "$new_pattern_identified" = true ]; then
  document_pattern_in_memory_bank
fi

# Update global standards if needed
if [ "$standards_update_needed" = true ]; then
  update_global_standards
fi
```

---

## 🔄 INTELLIGENT TASK WORKFLOW

### **Context-Aware Task Routing**
```javascript
const intelligentTaskRouter = {
  analyzeTask: (taskDescription) => {
    const complexity = assessComplexity(taskDescription)
    const domain = identifyDomain(taskDescription)
    const urgency = assessUrgency(taskDescription)
    
    return {
      complexity,
      domain,
      urgency,
      recommendedAgent: selectAgent(complexity, domain),
      requiredMCP: selectMCPTools(complexity, domain),
      estimatedTime: estimateTime(complexity, domain)
    }
  },
  
  executeTask: async (taskAnalysis) => {
    // Activate required MCP tools
    await activateMCPTools(taskAnalysis.requiredMCP)
    
    // Load relevant memory patterns
    const relevantPatterns = await loadRelevantPatterns(taskAnalysis.domain)
    
    // Execute with selected agent
    const result = await executeWithAgent(taskAnalysis.recommendedAgent, {
      task: taskAnalysis,
      patterns: relevantPatterns,
      mcpTools: taskAnalysis.requiredMCP
    })
    
    // Learn from execution
    await updateMemoryBank(result)
    
    return result
  }
}
```

### **Adaptive Workflow Patterns**
```javascript
const workflowPatterns = {
  sequential: {
    description: "Linear task execution",
    bestFor: ["simple tasks", "clear dependencies"],
    steps: ["analyze", "plan", "execute", "validate", "learn"]
  },
  
  hierarchical: {
    description: "Break down complex tasks",
    bestFor: ["complex projects", "multiple domains"],
    steps: ["decompose", "prioritize", "delegate", "coordinate", "integrate"]
  },
  
  iterative: {
    description: "Continuous improvement cycles",
    bestFor: ["research tasks", "optimization"],
    steps: ["hypothesis", "test", "measure", "refine", "repeat"]
  },
  
  collaborative: {
    description: "Multi-agent coordination",
    bestFor: ["full-stack development", "cross-domain tasks"],
    steps: ["coordinate", "parallel_execute", "integrate", "validate", "optimize"]
  }
}
```

---

## 🔄 ERROR HANDLING WORKFLOW

### **Proactive Error Prevention**
```bash
# Pre-execution validation
validate_environment() {
  check_node_version
  check_dependencies
  validate_config_files
  check_git_status
}

# Real-time monitoring
monitor_execution() {
  watch_for_error_patterns
  monitor_resource_usage
  track_performance_metrics
  alert_on_anomalies
}
```

### **Reactive Error Correction**
```bash
# Error detection and response
handle_error() {
  local error_type=$1
  local error_context=$2
  
  # Immediate response
  halt_execution
  log_error_details
  
  # Analysis
  analyze_root_cause
  check_memory_bank_for_solutions
  
  # Correction
  apply_known_solution || generate_new_solution
  
  # Learning
  update_memory_bank_with_solution
  create_prevention_rule
}
```

---

## 🔄 GITHUB SYNC WORKFLOW

### **Automated Sync Protocol**
```bash
#!/bin/bash
# GitHub Sync Workflow

sync_github() {
  local branch=${1:-main}
  
  # Pre-sync validation
  echo "🔍 Validating before sync..."
  
  # Security check
  if grep -r "api_key\|secret\|password" . --exclude-dir=node_modules; then
    echo "❌ Security violation: Secrets detected in code"
    exit 1
  fi
  
  # Git status check
  if [[ -n $(git status --porcelain) ]]; then
    echo "📝 Changes detected, preparing commit..."
    
    # Stage changes
    git add .
    
    # Generate commit message
    commit_message="feat: $(generate_commit_message)"
    
    # Commit
    git commit -m "$commit_message"
  fi
  
  # Push to remote
  echo "🚀 Pushing to GitHub..."
  git push origin $branch
  
  # Post-sync validation
  validate_remote_sync
  
  echo "✅ GitHub sync completed successfully"
}

# Auto-sync on task completion
auto_sync_on_completion() {
  if [ "$task_status" = "completed" ]; then
    echo "🎯 Task completed, initiating auto-sync..."
    
    # Request user confirmation
    read -p "Sync changes to GitHub? (y/n): " confirm
    
    if [ "$confirm" = "y" ]; then
      sync_github
    fi
  fi
}
```

---

## 📊 WORKFLOW METRICS & OPTIMIZATION

### **Performance Tracking**
```javascript
const workflowMetrics = {
  trackExecution: (workflow) => {
    const metrics = {
      startTime: Date.now(),
      agent: workflow.agent,
      complexity: workflow.complexity,
      mcpTools: workflow.mcpTools,
      steps: []
    }
    
    return metrics
  },
  
  optimizeWorkflow: (historicalData) => {
    const patterns = analyzePatterns(historicalData)
    const optimizations = identifyOptimizations(patterns)
    
    return {
      recommendedChanges: optimizations,
      expectedImprovement: calculateImprovement(optimizations),
      implementationPlan: createImplementationPlan(optimizations)
    }
  }
}
```

### **Continuous Improvement**
```bash
# Weekly workflow optimization
optimize_workflows() {
  # Analyze last week's performance
  analyze_workflow_performance
  
  # Identify bottlenecks
  identify_bottlenecks
  
  # Generate optimization recommendations
  generate_optimization_plan
  
  # Update workflow configurations
  update_workflow_configs
  
  # Document improvements
  document_workflow_improvements
}
```

---

**Consolidation Complete**: This file unifies all workflow protocols
**Performance**: 4 files → 1 file (75% reduction)
**Functionality**: 100% preserved with enhanced intelligence
**Last Updated**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)
**Next Review**: 2025-07-11
