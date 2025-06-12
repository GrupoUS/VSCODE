# 🔄 **WORKFLOW PROTOCOLS - VIBECODE SYSTEM V4.0**

## 📋 **MANDATORY WORKFLOW EXECUTION GUIDELINE V4.5**

### **CRITICAL DIRECTIVE: MEMORY-FIRST + MCP-ENFORCED EXECUTION**
**⚠️ ATTENTION: This guideline MUST be included in Cursor User Rules to enforce proper VIBECODE SYSTEM V4.5 workflow execution. Any deviation constitutes a CRITICAL PROTOCOL VIOLATION.**

---

## 🧠 **PHASE 0: MANDATORY MEMORY CONSULTATION (NON-NEGOTIABLE)**

### **BEFORE ANY ACTION, YOU MUST:**

1. **🔍 CONSULT MASTER RULE (MANDATORY)**
   ```bash
   # FIRST ACTION - Read the supreme source of truth
   cat @project-core/memory/master_rule.md
   ```

2. **📋 CHECK ERROR PATTERNS (MANDATORY)**
   ```bash
   # Prevent known failures
   grep -i "violation\|critical\|error" @project-core/memory/self_correction_log.md
   ```

3. **📊 LOAD GLOBAL STANDARDS (MANDATORY)**
   ```bash
   # Ensure compliance with current standards
   cat @project-core/memory/global-standards.md
   ```

**🚨 STOP EXECUTION if confidence < 8/10 after memory consultation**

---

## ⚡ **PHASE 1: THINK - COMPLEXITY ASSESSMENT & MCP ACTIVATION**

### **1.1 COMPLEXITY EVALUATION (MANDATORY)**

**Classify task complexity (1-10) and activate corresponding protocols:**

```python
def assess_task_complexity(task_description, domain, context):
    """
    Assess task complexity on scale 1-10
    
    Returns:
        int: Complexity level (1-10)
        dict: Activation recommendations
    """
    
    complexity_factors = {
        "multi_step_reasoning": 3,
        "cross_domain_knowledge": 2,
        "architectural_decisions": 3,
        "integration_requirements": 2,
        "performance_optimization": 2,
        "security_considerations": 2,
        "multiple_technologies": 1,
        "complex_algorithms": 3,
        "system_refactoring": 4,
        "cross_environment_coordination": 2
    }
    
    base_complexity = 1
    activated_factors = []
    
    for factor, weight in complexity_factors.items():
        if factor.replace('_', ' ') in task_description.lower():
            base_complexity += weight
            activated_factors.append(factor)
    
    complexity = min(base_complexity, 10)
    
    recommendations = {
        "sequential_thinking": complexity >= 7,
        "task_manager": complexity >= 5 or "multi" in task_description.lower(),
        "specialized_mcps": get_specialized_mcps(domain),
        "activated_factors": activated_factors
    }
    
    return complexity, recommendations
```

### **1.2 SEQUENTIAL THINKING MCP ACTIVATION (COMPLEXITY ≥7)**

**MANDATORY for complexity 7-10:**

```python
def activate_sequential_thinking(complexity, domain, task):
    """Activate Sequential Thinking MCP for complex tasks."""
    
    if complexity >= 7:
        return {
            "mcp": "sequential-thinking",
            "mode": "enhanced",
            "phases": ["analysis", "decomposition", "coordination", "validation"],
            "thought_chain": "detailed",
            "max_thoughts": min(complexity + 3, 15),
            "enable_branching": True,
            "domain_focus": domain
        }
    
    return None
```

### **1.3 PERSONA SELECTION (MANDATORY)**

Based on complexity and domain:

```python
PERSONA_MAPPING = {
    (1, 2): "RESEARCHER",           # Simple research tasks
    (3, 6): "MANAGER/EXECUTOR",     # Standard implementation
    (7, 10): "ARCHITECT/CODER"      # Complex architecture + MCP activation
}

def select_persona(complexity, domain):
    """Select appropriate persona based on complexity and domain."""
    
    for (min_comp, max_comp), persona in PERSONA_MAPPING.items():
        if min_comp <= complexity <= max_comp:
            return {
                "persona": persona,
                "mcp_required": complexity >= 7,
                "coordination_required": complexity >= 5,
                "specialization": get_domain_specialization(domain)
            }
```

---

## 📋 **PHASE 2: PLAN - SHRIMP TASK MANAGER COORDINATION**

### **2.1 TASK DELEGATION ASSESSMENT**

**For ANY multi-phase or complex task:**

```python
def assess_delegation_need(task, complexity, phases):
    """Assess if Shrimp Task Manager coordination is needed."""
    
    delegation_triggers = {
        "complexity_threshold": complexity >= 5,
        "multi_phase": phases > 1,
        "cross_environment": "handoff" in task.lower(),
        "integration_required": "integration" in task.lower(),
        "coordination_needed": "coordinate" in task.lower()
    }
    
    if any(delegation_triggers.values()):
        return {
            "delegate": True,
            "coordination_mode": "active",
            "triggers": [k for k, v in delegation_triggers.items() if v]
        }
    
    return {"delegate": False}
```

### **2.2 SHRIMP TASK MANAGER DELEGATION (CONDITIONAL MANDATORY)**

**MANDATORY when:**
- Complexity ≥ 5
- Multiple phases required
- Cross-agent coordination needed
- Integration between environments required

```python
def delegate_to_shrimp_manager(task_name, complexity, phases, agents):
    """Delegate task to Shrimp Task Manager."""
    
    delegation_config = {
        "task": task_name,
        "complexity": complexity,
        "phases": phases,
        "agents": agents,
        "coordination_mode": "active",
        "integration_points": identify_handoff_points(task_name),
        "success_criteria": define_validation_checkpoints(complexity)
    }
    
    return delegation_config
```

---

## ⚡ **PHASE 3: EXECUTE - COORDINATED IMPLEMENTATION**

### **3.1 EXECUTION PROTOCOL**

**Choose execution path based on coordination requirements:**

#### **3.1.A: DIRECT EXECUTION (Complexity < 5, Single Phase)**
```python
def direct_execution(task, agent, monitoring=True):
    """Direct implementation with monitoring."""
    
    execution_config = {
        "agent": agent,
        "monitoring": "enabled" if monitoring else "disabled",
        "validation": "continuous",
        "backup": "automatic",
        "rollback": "on_failure"
    }
    
    return execute_task(task, execution_config)
```

#### **3.1.B: SHRIMP-COORDINATED EXECUTION (Complexity ≥5 or Multi-phase)**
```python
def coordinated_execution(task, coordination_plan):
    """Coordinated execution through Shrimp Task Manager."""
    
    execution_config = {
        "coordination_mode": "active",
        "progress_tracking": "real-time",
        "handoff_management": "automated",
        "quality_gates": "mandatory",
        "cross_validation": "enabled"
    }
    
    return shrimp_execute(task, coordination_plan, execution_config)
```

### **3.2 QUALITY GATES (MANDATORY)**

**Every execution MUST pass these gates:**

```python
def quality_gate_check(task_result, requirements):
    """Mandatory quality gates for all executions."""
    
    gates = {
        "architecture_compliance": validate_architecture(task_result),
        "code_quality": run_linting_strict(task_result),
        "performance_standards": performance_check(task_result),
        "security_validation": security_scan_comprehensive(task_result),
        "integration_tests": run_integration_tests(task_result)
    }
    
    passed_gates = sum(1 for gate, result in gates.items() if result)
    total_gates = len(gates)
    
    return {
        "passed": passed_gates == total_gates,
        "score": (passed_gates / total_gates) * 100,
        "failed_gates": [gate for gate, result in gates.items() if not result],
        "details": gates
    }
```

---

## 📚 **PHASE 4: LEARN - MANDATORY KNOWLEDGE CAPTURE**

### **4.1 LEARNING DOCUMENTATION (MANDATORY)**

**EVERY task completion MUST update the learning log:**

```python
def update_learning_log(task_name, complexity, agent, mcp_usage, patterns, optimizations):
    """Update self-correction log with new learnings."""
    
    timestamp = datetime.now().isoformat()
    
    learning_entry = {
        "timestamp": timestamp,
        "task": task_name,
        "complexity": complexity,
        "agent": agent,
        "mcp_usage": mcp_usage,
        "workflow_compliance": {
            "memory_consultation": True,
            "sequential_thinking": mcp_usage.get("sequential-thinking", False),
            "shrimp_coordination": mcp_usage.get("task-manager", False),
            "quality_gates": True
        },
        "learnings_captured": patterns,
        "optimizations_applied": optimizations,
        "prevention_measures": extract_prevention_rules(patterns)
    }
    
    append_to_learning_log(learning_entry)
    return learning_entry
```

### **4.2 PATTERN EXTRACTION (MANDATORY)**

```python
def extract_success_patterns(task_result, execution_data):
    """Extract and catalog successful patterns for reuse."""
    
    patterns = {
        "reusable_solutions": identify_reusable_components(task_result),
        "optimization_opportunities": find_optimization_points(execution_data),
        "architectural_decisions": extract_architectural_patterns(task_result),
        "best_practices": catalog_best_practices(execution_data)
    }
    
    update_pattern_database(patterns)
    return patterns
```

---

## 🚨 **COMPLIANCE VERIFICATION CHECKLIST**

### **PRE-EXECUTION CHECKLIST**
- [ ] Master rule consulted and understood
- [ ] Self-correction log reviewed for relevant patterns
- [ ] Global standards loaded and compliance verified
- [ ] Complexity assessed (1-10 scale)
- [ ] Appropriate persona selected
- [ ] MCP activation decision made based on complexity

### **EXECUTION COMPLIANCE CHECKLIST**
- [ ] **Sequential Thinking MCP**: Activated if complexity ≥7
- [ ] **Shrimp Task Manager**: Activated if multi-phase or complexity ≥5
- [ ] Thought chain documented (if applicable)
- [ ] Task decomposition completed (if applicable)
- [ ] Agent coordination plan established (if applicable)

### **QUALITY ASSURANCE CHECKLIST**
- [ ] All quality gates passed (100% success rate)
- [ ] Architecture compliance verified
- [ ] Code quality standards met (zero warnings)
- [ ] Performance benchmarks achieved
- [ ] Security validation completed
- [ ] Integration tests successful

### **LEARNING INTEGRATION CHECKLIST**
- [ ] Self-correction log updated with new learnings
- [ ] Success patterns extracted and catalogued
- [ ] Optimization opportunities documented
- [ ] Error prevention measures established
- [ ] Knowledge base enhanced

---

## ⚠️ **CRITICAL VIOLATION PROTOCOLS**

### **VIOLATION DETECTION**
```python
def detect_workflow_violations(execution_data):
    """Automated violation detection."""
    
    violations = []
    
    # Check MCP activation compliance
    if execution_data.complexity >= 7 and not execution_data.sequential_thinking_used:
        violations.append("CRITICAL: Sequential Thinking MCP not activated for high complexity task")
    
    if execution_data.phases > 1 and not execution_data.shrimp_coordination_used:
        violations.append("CRITICAL: Shrimp Task Manager not used for multi-phase task")
    
    if not execution_data.memory_consultation:
        violations.append("CRITICAL: Memory consultation not performed")
    
    if violations:
        log_violations_and_halt(violations)
    
    return len(violations) == 0
```

### **VIOLATION RESPONSE**
```python
def handle_workflow_violation(violation_details):
    """Immediate violation response protocol."""
    
    violation_entry = {
        "timestamp": datetime.now().isoformat(),
        "violation_type": "CRITICAL_WORKFLOW_VIOLATION",
        "details": violation_details,
        "immediate_action": "EXECUTION_HALTED",
        "required_action": "MANUAL_REVIEW_REQUIRED"
    }
    
    log_critical_violation(violation_entry)
    halt_execution_for_review()
    
    return False  # Execution must stop
```

---

## 🎯 **SUCCESS CRITERIA**

**A task is considered successfully completed ONLY when:**

1. ✅ **Memory Consultation**: All required files reviewed
2. ✅ **Workflow Compliance**: Appropriate MCPs activated based on complexity
3. ✅ **Quality Achievement**: All quality gates passed  
4. ✅ **Learning Integration**: Self-correction log updated with new patterns
5. ✅ **Prevention Measures**: Error prevention rules established

**Confidence Level**: Must maintain ≥9/10 throughout execution

---

**🔄 VIBECODE SYSTEM V4.0 - WORKFLOW PROTOCOLS FOR DISCIPLINED EXCELLENCE**

*"Onde disciplina de workflow encontra excelência técnica, maestria arquitetural nasce."*
