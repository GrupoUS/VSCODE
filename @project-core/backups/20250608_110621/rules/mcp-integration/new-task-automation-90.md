# 🔄 NEW TASK AUTOMATION PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

**Version**: 1.0.0
**Purpose**: Proactive context window management through automated task handoff
**Activation Threshold**: 90% context usage
**Integration**: Mandatory for all AI agents in GRUPO US ecosystem

This protocol establishes a mandatory, automated system for managing AI context window overflow by proactively initiating task handoffs when context usage reaches critical levels, ensuring seamless long-running development sessions without data loss.

## 🔗 RULE DEPENDENCIES

**This protocol implements:**

- `@file:project-core/rules/01-core-principles.md` - Foundation principles for continuous improvement
- `@file:project-core/rules/00-master-execution-protocol.md` - Master execution framework integration

**Integrates with:**

- `@file:project-core/rules/mcp-integration/taskmaster-protocol.md` - Task management coordination
- `@file:memory-bank/self_correction_log.md` - Learning and error prevention

## 🚨 MANDATORY ACTIVATION CRITERIA

### **Automatic Trigger (REQUIRED)**

- **Context Usage ≥ 90%**: Immediate activation when context window reaches 90% capacity
- **Continuous Monitoring**: Agent MUST monitor `context_window_usage` during every operation
- **Proactive Intervention**: Act BEFORE reaching 100% to prevent context overflow errors

### **Implementation Requirements**

- **MUST** complete current logical step before initiating handoff
- **MUST** use `ask_followup_question` tool to propose new task creation
- **MUST** provide comprehensive context summary for seamless transition
- **NEVER** wait until context is completely full

## 🎯 ACTIVATION PROTOCOL

### **Step 1: Context Monitoring (CONTINUOUS)**

```javascript
// Monitor context usage during every operation
const contextUsage = environment_details.context_window_usage;

if (contextUsage >= 0.9) {
  // Trigger handoff protocol immediately after current step
  await initiateContextHandoff();
}
```

### **Step 2: Current Step Completion (MANDATORY)**

- **Complete** the current logical operation (function, component, or logical block)
- **DO NOT** start new complex operations when at 90%+ usage
- **Ensure** current work is in a stable, committable state

### **Step 3: Handoff Proposal (REQUIRED)**

```xml
<ask_followup_question>
<question>Context window usage has reached 90%. To preserve session integrity and prevent data loss, I recommend creating a new task with complete context transfer. This ensures we can continue seamlessly without losing our progress. Shall I proceed with the handoff?</question>
<options>["Yes, create new task", "Continue in current session", "Let me save work first"]</options>
</ask_followup_question>
```

### **Step 4: Context Transfer (IF APPROVED)**

If user approves, immediately create new task with comprehensive context package.

## 📦 CONTEXT HANDOFF STRUCTURE

### **Mandatory Context Package Format**

```markdown
<context>
## 🎯 Task Master State
- **Current Task ID**: [ID da task atual]
- **Completed Tasks**: [Lista de tasks completadas nesta sessão]
- **Next Planned Task**: [Próxima task identificada pelo TaskMaster]
- **Task Priority**: [Prioridade da próxima task]

## ✅ Completed Work Summary

- **Files Modified**: [Lista completa de arquivos criados/modificados com resumo das mudanças]
- **Features Implemented**: [Lista detalhada de funcionalidades completadas]
- **Components Created**: [Componentes React/Vue criados ou modificados]
- **API Endpoints**: [Endpoints criados ou modificados]
- **Database Changes**: [Alterações no schema, migrations, seeds]

## 🏗️ Current Project State

- **Git Branch**: [Nome do branch atual]
- **Last Commit**: [Hash e mensagem do último commit]
- **Pending Changes**: [Arquivos modificados mas não commitados]
- **Dependencies Added**: [Novas dependências npm/yarn instaladas]
- **Environment Variables**: [Novas variáveis de ambiente necessárias]

## 🎯 Next Steps & Continuation Plan

- **Immediate Next Action**: [Próxima ação específica a ser executada]
- **Planned Implementation**: [Plano detalhado dos próximos 3-5 passos]
- **Known Blockers**: [Problemas identificados que precisam ser resolvidos]
- **Testing Requirements**: [Testes que precisam ser escritos ou executados]

## 📚 Core References & Context

- **PRD**: @file:scripts/prd.txt
- **Architecture**: @file:docs/architecture.md
- **Current Rules**: @file:project-core/rules/00-master-execution-protocol.md
- **Repository**: https://github.com/GrupoUS/teste
- **Memory Bank**: @file:memory-bank/master_rule.md

## 🔧 Technical Context

- **Tech Stack**: [Stack específico sendo usado: Next.js, Laravel, etc.]
- **Database**: [PostgreSQL/MySQL com Prisma/Eloquent]
- **Authentication**: [NextAuth.js/Clerk/Laravel Sanctum]
- **Deployment**: [Vercel/Railway/outros]
- **Key Integrations**: [Supabase, Stripe, Figma, etc.]
  </context>
```

## 💡 IMPLEMENTATION EXAMPLES

### **✅ CORRECT Implementation**

```javascript
// During a complex component implementation
const contextUsage = getCurrentContextUsage();

if (contextUsage >= 0.9) {
  // Complete current function
  const handleSubmit = async (data) => {
    // ... finish implementation
  };

  // Then propose handoff
  await askFollowupQuestion({
    question: "Context window at 90%. Recommend new task for continuation?",
    options: ["Yes, create new task", "Continue current session"],
  });
}
```

### **❌ INCORRECT Implementation**

```javascript
// DON'T: Ignore context usage and continue
if (contextUsage >= 0.9) {
  // Starting new complex feature - WRONG!
  await implementComplexFeature();
}

// DON'T: Wait until 100% usage
if (contextUsage >= 1.0) {
  // Too late - context already overflowed
}
```

## 🔧 INTEGRATION WITH EXISTING SYSTEMS

### **TaskMaster Integration**

- **Sync with TaskMaster**: Ensure new task aligns with TaskMaster priorities
- **Preserve Task Hierarchy**: Maintain parent-child task relationships
- **Update Task Status**: Mark current task as "continued in new session"

### **Memory Bank Integration**

- **Archive Context**: Store current session context in memory-bank
- **Learning Preservation**: Maintain continuity of learning and patterns
- **Error Prevention**: Use archived context to avoid repeating mistakes

### **MCP Tools Coordination**

- **Playwright**: Preserve test automation context and results
- **Figma**: Maintain design sync state and component mappings
- **Supabase**: Preserve database connection and schema context

## 📊 MONITORING & OPTIMIZATION

### **Success Metrics**

- **Handoff Success Rate**: > 95% successful context transfers
- **Context Preservation**: > 90% of critical context maintained
- **Session Continuity**: < 5% rework due to context loss
- **User Satisfaction**: > 9/10 for handoff experience

### **Performance Tracking**

```javascript
// Track handoff metrics
const handoffMetrics = {
  triggerTime: Date.now(),
  contextUsage: 0.9,
  contextItemsTransferred: contextPackage.items.length,
  handoffSuccess: true,
  userApproval: true,
  continuationSuccess: true,
};
```

### **Optimization Opportunities**

- **Threshold Adjustment**: Monitor for optimal threshold (85-95% range)
- **Context Compression**: Implement smart context summarization
- **Predictive Handoff**: Anticipate handoff needs based on task complexity

## 🛡️ ERROR HANDLING & FALLBACKS

### **Handoff Failure Scenarios**

1. **User Declines Handoff**: Continue with emergency context cleanup
2. **Context Transfer Fails**: Implement emergency context archival
3. **New Task Creation Fails**: Provide manual context export option

### **Emergency Protocols**

```javascript
// Emergency context preservation
if (handoffFailed) {
  await emergencyContextArchive();
  await notifyUserOfContextRisk();
  await implementAggressiveContextCleanup();
}
```

## 📋 VALIDATION & TESTING

### **Handoff Validation Checklist**

- [ ] Context usage accurately monitored
- [ ] Handoff triggered at exactly 90%
- [ ] Current work completed before handoff
- [ ] Comprehensive context package created
- [ ] User approval obtained
- [ ] New task successfully created
- [ ] Context successfully transferred
- [ ] Continuation seamless

### **Testing Scenarios**

1. **Normal Handoff**: Standard 90% threshold activation
2. **Rapid Context Growth**: Quick context accumulation scenarios
3. **Complex Task Handoff**: Multi-file, multi-component task transfers
4. **Error Recovery**: Failed handoff recovery procedures

## 🔄 CONTINUOUS IMPROVEMENT

### **Learning Integration**

- **Document Patterns**: Record successful handoff patterns
- **Identify Improvements**: Track handoff pain points
- **Optimize Threshold**: Adjust based on real-world usage
- **Enhance Context**: Improve context package quality

### **Version History**

- **v1.0.0**: Initial implementation with 90% threshold
- **Future**: Planned adaptive threshold based on task complexity

---

## 📝 IMPLEMENTATION NOTES

### **Critical Success Factors**

1. **Proactive Monitoring**: Continuous context usage awareness
2. **User Communication**: Clear explanation of handoff necessity
3. **Comprehensive Context**: Complete information transfer
4. **Seamless Transition**: Minimal disruption to workflow

### **Integration Requirements**

- **Memory Bank**: Must integrate with existing memory-bank system
- **TaskMaster**: Must coordinate with TaskMaster task management
- **MCP Tools**: Must preserve state across all MCP integrations
- **Git Workflow**: Must respect current branch and commit state

---

**This protocol ensures optimal context management and seamless task continuity across all GRUPO US development activities, preventing context overflow while maintaining productivity and session integrity.**
