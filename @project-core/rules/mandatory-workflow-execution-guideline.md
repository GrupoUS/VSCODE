# 🚨 MANDATORY WORKFLOW EXECUTION GUIDELINE V4.5

## FOR CURSOR USER RULES - ENFORCE COMPLETE MCP WORKFLOW COMPLIANCE

---

## 🎯 **CRITICAL DIRECTIVE: MEMORY-FIRST + MCP-ENFORCED EXECUTION**

**⚠️ ATTENTION: This guideline MUST be included in Cursor User Rules to enforce proper VIBECODE SYSTEM V4.5 workflow execution. Any deviation constitutes a CRITICAL PROTOCOL VIOLATION.**

---

## 🧠 **PHASE 0: MANDATORY MEMORY CONSULTATION (NON-NEGOTIABLE)**

**BEFORE ANY ACTION, YOU MUST:**

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

```bash
# Complexity Assessment Protocol
COMPLEXITY_LEVEL=$(assess_task_complexity)

if [ $COMPLEXITY_LEVEL -ge 7 ]; then
    echo "🧠 HIGH COMPLEXITY DETECTED - ACTIVATING SEQUENTIAL THINKING MCP"
    # MANDATORY: Activate Sequential Thinking MCP
    think --complexity=$COMPLEXITY_LEVEL --domain="${DOMAIN}" --task="${TASK}"
else
    echo "📝 STANDARD COMPLEXITY - PROCEEDING WITH DIRECT EXECUTION"
fi
```

### **1.2 SEQUENTIAL THINKING MCP ACTIVATION (COMPLEXITY ≥7)**

**MANDATORY for complexity 7-10:**

```bash
# SEQUENTIAL THINKING MCP - MANDATORY ACTIVATION
think --complexity=${COMPLEXITY} \
      --domain="${TASK_DOMAIN}" \
      --task="${TASK_DESCRIPTION}" \
      --phases="analysis,decomposition,coordination,validation" \
      --output-format="structured" \
      --thought-chain="detailed"
```

**Expected Output:**

```markdown
🧠 SEQUENTIAL THINKING MCP ANALYSIS
├── Task Decomposition: [phases identified]
├── Complexity Justification: [reasoning]
├── Agent Assignment: [ARCHITECT/CODER/MANAGER/EXECUTOR]
├── MCP Dependencies: [required MCPs]
└── Coordination Requirements: [Shrimp Task Manager needed: Y/N]
```

### **1.3 PERSONA SELECTION (MANDATORY)**

Based on complexity and domain:

- **COMPLEXITY 1-2**: RESEARCHER
- **COMPLEXITY 3-6**: MANAGER/EXECUTOR
- **COMPLEXITY 7-10**: ARCHITECT/CODER (+ MCP activation required)

---

## 📋 **PHASE 2: PLAN - SHRIMP TASK MANAGER COORDINATION**

### **2.1 TASK DELEGATION ASSESSMENT**

**For ANY multi-phase or complex task:**

```bash
# Evaluate if Shrimp Task Manager coordination is needed
if [ $PHASES -gt 1 ] || [ $COMPLEXITY -ge 5 ]; then
    echo "🦐 ACTIVATING SHRIMP TASK MANAGER"
    # MANDATORY: Delegate to Shrimp Task Manager
    shrimp plan --task="${TASK_NAME}" \
                --complexity=$COMPLEXITY \
                --phases=$PHASES \
                --agents="${AGENT_LIST}" \
                --deliverables="${DELIVERABLES}"
fi
```

### **2.2 SHRIMP TASK MANAGER DELEGATION (CONDITIONAL MANDATORY)**

**MANDATORY when:**

- Complexity ≥ 5
- Multiple phases required
- Cross-agent coordination needed
- Integration between environments required

```bash
# SHRIMP TASK MANAGER - DELEGATION PROTOCOL
shrimp plan --task="${TASK_NAME}" \
            --complexity=${COMPLEXITY} \
            --phases=${PHASE_COUNT} \
            --agents="${PRIMARY_AGENT},${SECONDARY_AGENTS}" \
            --deliverables="${EXPECTED_OUTPUTS}" \
            --coordination-mode="active" \
            --integration-points="${HANDOFF_POINTS}"
```

**Expected Output:**

```markdown
🦐 SHRIMP TASK MANAGER COORDINATION PLAN
├── Task: ${TASK_NAME}
├── Breakdown:
│ ├── Phase 1: [agent] → [deliverable]
│ ├── Phase 2: [agent] → [deliverable]
│ └── Phase N: [agent] → [deliverable]
├── Dependencies: [phase relationships]
├── Handoff Points: [coordination requirements]
└── Success Criteria: [validation checkpoints]
```

---

## ⚡ **PHASE 3: EXECUTE - COORDINATED IMPLEMENTATION**

### **3.1 EXECUTION PROTOCOL**

**Choose execution path based on coordination requirements:**

#### **3.1.A: DIRECT EXECUTION (Complexity < 5, Single Phase)**

```bash
# Direct implementation with monitoring
execute_task --agent="${SELECTED_AGENT}" \
             --monitoring="enabled" \
             --validation="continuous"
```

#### **3.1.B: SHRIMP-COORDINATED EXECUTION (Complexity ≥5 or Multi-phase)**

```bash
# Coordinated execution through Shrimp Task Manager
shrimp execute --follow-plan \
               --coordination-mode="active" \
               --progress-tracking="real-time" \
               --handoff-management="automated"
```

### **3.2 QUALITY GATES (MANDATORY)**

**Every execution MUST pass these gates:**

```bash
# MANDATORY QUALITY GATES
quality_gate_check() {
    echo "🔍 RUNNING MANDATORY QUALITY GATES"

    # Gate 1: Architecture Compliance
    validate_architecture --compliance-check

    # Gate 2: Code Quality
    run_linting --strict --zero-warnings

    # Gate 3: Performance Standards
    performance_check --benchmark-compliance

    # Gate 4: Security Validation
    security_scan --comprehensive

    # Gate 5: Integration Tests
    run_integration_tests --full-coverage
}
```

---

## 📚 **PHASE 4: LEARN - MANDATORY KNOWLEDGE CAPTURE**

### **4.1 LEARNING DOCUMENTATION (MANDATORY)**

**EVERY task completion MUST update the learning log:**

```bash
# MANDATORY: Update self-correction log
update_learning_log() {
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    cat >> @project-core/memory/self_correction_log.md << EOF

---

## 📝 TASK COMPLETION LEARNING - ${TIMESTAMP}

### **TASK SUMMARY**
- **Task**: ${TASK_NAME}
- **Complexity**: ${COMPLEXITY}/10
- **Agent**: ${EXECUTED_AGENT}
- **MCP Usage**: ${MCP_ACTIVATION_STATUS}

### **WORKFLOW COMPLIANCE**
- ✅ Memory consultation completed
- ✅ Sequential Thinking MCP: ${SEQUENTIAL_THINKING_STATUS}
- ✅ Shrimp Task Manager: ${SHRIMP_COORDINATION_STATUS}
- ✅ Quality gates passed: ${QUALITY_GATES_STATUS}

### **LEARNINGS CAPTURED**
${CAPTURED_PATTERNS}

### **OPTIMIZATION APPLIED**
${OPTIMIZATIONS_IMPLEMENTED}

### **PREVENTION MEASURES**
${ERROR_PREVENTION_RULES}

---
EOF
}
```

### **4.2 PATTERN EXTRACTION (MANDATORY)**

```bash
# Extract and catalog successful patterns
extract_patterns() {
    echo "🧠 EXTRACTING SUCCESS PATTERNS"

    # Pattern recognition for reuse
    identify_reusable_solutions
    catalog_optimization_opportunities
    document_architectural_decisions
    update_best_practices_database
}
```

---

## 🚨 **COMPLIANCE VERIFICATION CHECKLIST**

**BEFORE marking any task as complete, verify ALL items:**

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

```bash
# Automated violation detection
detect_workflow_violations() {
    # Check for MCP activation compliance
    if [ $COMPLEXITY -ge 7 ] && [ "$SEQUENTIAL_THINKING_USED" != "true" ]; then
        echo "🚨 CRITICAL VIOLATION: Sequential Thinking MCP not activated for high complexity task"
        VIOLATION_DETECTED=true
    fi

    if [ $PHASES -gt 1 ] && [ "$SHRIMP_COORDINATION_USED" != "true" ]; then
        echo "🚨 CRITICAL VIOLATION: Shrimp Task Manager not used for multi-phase task"
        VIOLATION_DETECTED=true
    fi

    if [ "$VIOLATION_DETECTED" = "true" ]; then
        log_violation_and_correct
    fi
}
```

### **VIOLATION RESPONSE**

```bash
# Immediate violation response protocol
log_violation_and_correct() {
    echo "🚨 LOGGING CRITICAL WORKFLOW VIOLATION"

    # Document violation
    cat >> @project-core/memory/self_correction_log.md << EOF
## 🚨 CRITICAL WORKFLOW VIOLATION - $(date -u +"%Y-%m-%dT%H:%M:%SZ")

**VIOLATION**: MCP workflow protocol not followed
**TASK**: ${TASK_NAME}
**COMPLEXITY**: ${COMPLEXITY}/10
**MISSING**: ${VIOLATION_DETAILS}

**IMMEDIATE CORRECTION**: Retrospective compliance analysis initiated
**PREVENTION**: Enhanced workflow validation implemented
EOF

    # Halt execution for manual review
    echo "⛔ EXECUTION HALTED - Manual workflow review required"
    exit 1
}
```

---

## 🔧 **IMPLEMENTATION FOR CURSOR USER RULES**

**Add this to your Cursor User Rules (.cursor/rules):**

```json
{
  "workflow_enforcement": {
    "mandatory_consultation": [
      "@project-core/memory/master_rule.md",
      "@project-core/memory/self_correction_log.md",
      "@project-core/memory/global-standards.md"
    ],
    "complexity_thresholds": {
      "sequential_thinking_activation": 7,
      "shrimp_task_manager_activation": 5,
      "multi_phase_coordination": 1
    },
    "quality_gates": [
      "architecture_compliance",
      "code_quality_zero_warnings",
      "performance_benchmarks",
      "security_validation",
      "integration_tests"
    ],
    "learning_requirements": {
      "mandatory_log_update": true,
      "pattern_extraction": true,
      "optimization_documentation": true
    }
  },
  "violation_response": {
    "halt_on_violation": true,
    "require_manual_review": true,
    "document_all_violations": true
  }
}
```

---

## 📋 **QUICK REFERENCE COMMANDS**

### **Pre-Task Setup**

```bash
# Memory consultation
cat @project-core/memory/master_rule.md
grep -i "critical\|violation" @project-core/memory/self_correction_log.md

# Complexity assessment
COMPLEXITY=$(assess_complexity --task="${TASK}")
```

### **MCP Activation**

```bash
# High complexity (≥7)
think --complexity=$COMPLEXITY --domain="${DOMAIN}" --task="${TASK}"

# Multi-phase coordination (≥5 or multi-phase)
shrimp plan --task="${TASK}" --complexity=$COMPLEXITY --phases=$PHASES
```

### **Quality Validation**

```bash
# Comprehensive quality check
run_quality_gates --architecture --code-quality --performance --security --integration
```

### **Learning Documentation**

```bash
# Update learning log
update_self_correction_log --task="${TASK}" --learnings="${PATTERNS}" --optimizations="${IMPROVEMENTS}"
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

**🚀 GRUPO US VIBECODE SYSTEM V4.5 - ARCHITECTURAL EXCELLENCE THROUGH DISCIPLINED EXECUTION**

_"Where workflow discipline meets technical excellence, architectural mastery is born."_
