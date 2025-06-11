# 🚀 MASTER EXECUTION PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 📋 PROTOCOL OVERVIEW

This is the unified master execution protocol that consolidates the 4-step execution cycle from memory-bank with the hierarchical coordination system from .clinerules, creating a single source of truth for all AI agent execution in the GRUPO US ecosystem.

## 🚨 STEP 0: MANDATORY WORKSPACE VERIFICATION (EXECUTE FIRST)

**CRITICAL**: Execute BEFORE any other action - NO EXCEPTIONS

### Workspace Access Verification:

```powershell
# Verify workspace access
Get-Location
Test-Path "C:\Users\Admin\OneDrive\GRUPOUS\VSCODE"
Test-Path "memory-bank" && Test-Path "project-core" && Test-Path ".clinerules"
Test-Path "memory-bank/master_rule.md" && Test-Path "project-core/README.md" && Test-Path ".cursorrules"
```

**ONLY PROCEED if ALL verifications return TRUE**
**If ANY verification fails: STOP and request user intervention**

### Critical Files Access Check:

- `memory-bank/master_rule.md` - Core execution protocols
- `project-core/rules/` - Centralized rule system
- `.clinerules/` - Tool-specific configurations
- `src/` - Source code directory
- `scripts/` - Project scripts
- `package.json` - Project configuration

## 🔄 STEP 1: TASKMASTER INITIALIZATION (MANDATORY AFTER VERIFICATION)

### TaskMaster AI Initialization Protocol:

```bash
# Initialize Task Master
task-master init --yes

# Parse PRD and verify integrity
task-master parse-prd project-core/tasks/prd.txt --validate

# List tasks with priorities
task-master list --sort=priority

# Identify next task
task-master next --show-dependencies
```

**Always ask to think more, think harder and ULTRATHINK.**

## 🎯 MULTI-PHASE PROJECT DETECTION (MANDATORY ENFORCEMENT)

### **Automatic Multi-Phase Detection Protocol:**

**CRITICAL**: Execute immediately after TaskMaster initialization for ALL projects

#### **Phase Detection Logic:**

```bash
# Analyze project structure for multi-phase indicators
task-master analyze-complexity --detect-phases

# Count project phases automatically
task-master count-phases --source=prd --source=tasks
```

#### **Mandatory TaskMaster Activation Criteria:**

- **2+ Phases Detected**: Automatic TaskMaster protocol activation
- **Complex Dependencies**: Cross-phase dependency detection
- **Multi-Stage Workflows**: Sequential execution requirements
- **Integration Points**: Multiple service/API integrations

#### **Phase Detection Indicators:**

1. **PRD Analysis**: Multiple sections, phases, or milestones
2. **Task Structure**: Hierarchical task dependencies
3. **Timeline Markers**: Distinct delivery phases
4. **Integration Complexity**: Multiple external systems
5. **User Story Mapping**: Multi-stage user journeys

#### **Enforcement Rules:**

```markdown
IF (phases_detected >= 2) THEN
MANDATORY: TaskMaster Protocol Activation
MANDATORY: Sequential Thinking MCP Integration
MANDATORY: Phase Completion Verification
MANDATORY: Error Logging After Each Phase
ELSE
OPTIONAL: Standard execution protocols
END IF
```

## 🎯 THE 4-STEP EXECUTION CYCLE (MANDATORY FOR ALL REQUESTS)

### **STEP 1: THINK (Analyze and Internalize Context)**

#### **1.1 Core Context Loading (ALWAYS FIRST)**

**Mandatory Core Rules (Always Load):**

```markdown
@file:project-core/rules/01-core-principles.md # Foundation principles
@file:project-core/rules/02-coding-standards-universal.md # Universal standards
@file:project-core/rules/universal-pre-execution-verification.md # Verification layer
@file:memory-bank/self_correction_log.md # Learning from past errors
```

#### **1.2 Task Context Detection & Conditional Loading**

**Framework Detection & Loading:**

```markdown
# Detect framework context from task description, file paths, or explicit mentions

IF (task_contains("Next.js", "React", "TypeScript", "Supabase")) THEN
@file:project-core/rules/frameworks/nextjs-react.md
END IF

IF (task_contains("Laravel", "Livewire", "PHP", "Blade")) THEN
@file:project-core/rules/frameworks/laravel-livewire.md
END IF
```

**MCP Integration Detection & Loading:**

```markdown
# Load MCP rules based on task requirements

IF (complexity >= 7 OR multi_phase_detected) THEN
@file:project-core/rules/mcp-integration/taskmaster-protocol.md
END IF

IF (task_contains("automation", "testing", "browser", "e2e")) THEN
@file:project-core/rules/mcp-integration/playwright-automation.md
END IF

IF (task_contains("design", "figma", "component generation", "visual")) THEN
@file:project-core/rules/mcp-integration/figma-design-sync.md
END IF

IF (task_contains("database", "supabase", "sql", "migration")) THEN
@file:project-core/rules/mcp-integration/supabase-database.md
END IF

IF (context_usage >= 90%) THEN
@file:project-core/rules/mcp-integration/new-task-automation-90.md
END IF
```

#### **1.3 Task Complexity Assessment (1-10 scale)**

- **1-3**: Simple tasks (core rules only)
- **4-6**: Moderate tasks (core + framework rules)
- **7-10**: Complex tasks (core + framework + MCP rules + specialized protocols)

#### **1.4 Specialized Protocol Activation**

**Load Additional Protocols (if complexity ≥ 7 OR multi-phase project):**

- Sequential Thinking MCP (`sequential-thinking` alias) for deep analysis
- Completeness Verification for systematic validation
- TaskMaster Performance for large task decomposition
- Multi-Phase Coordination for cross-phase dependencies

#### **1.5 Context Integration Architecture**

- **Memory-Bank System**: Active learning and improvement
- **Project-Core Rules**: Centralized standards and protocols (conditional loading)
- **MCP Integration**: TaskMaster, Playwright, Figma, Supabase (on-demand)
- **Framework Standards**: Technology-specific guidelines (context-aware)

### **STEP 2: PLAN (Strategic Planning with Confirmation)**

#### Planning Requirements:

1. **Describe Clear Action Plan**:

   - Break down into numbered, sequential steps
   - Identify required tools and integrations
   - Estimate complexity and resource requirements
   - Specify validation checkpoints

2. **Example Planning Format**:

   ```markdown
   ## 📋 EXECUTION PLAN (Complexity: X/10)

   **Understanding**: [Clear description of the task]
   **Approach**: [High-level strategy]

   ### Steps:

   1. [Specific action with tool/method]
   2. [Specific action with tool/method]
   3. [Validation checkpoint]

   **Risks**: [Identified risks and mitigations]
   **Success Criteria**: [How to measure completion]

   **Awaiting confirmation to proceed...**
   ```

3. **APPROVAL PROTOCOL (UPDATED)**:

   **For Multi-Phase Projects (2+ phases detected):**

   - **WAIT** for initial plan approval ("sim", "prossiga", "ok", "proceed")
   - **EXECUTE** all phases sequentially without mid-execution approvals
   - **CONTINUE** through all approved phases without interruption

   **For Simple Tasks (single phase):**

   - **WAIT** for explicit approval ("sim", "prossiga", "ok", "proceed")
   - **DO NOT** proceed without confirmation

   **Exception - Always Require Approval:**

   - Major destructive operations (data deletion, file removal)
   - External integrations (API connections, third-party services)
   - Security-sensitive changes (authentication, permissions)

### **STEP 3: EXECUTE (Implementation with Excellence)**

#### Execution Standards:

1. **Complete Implementation**:

   - NO TODOs or placeholders
   - Full functionality implementation
   - Proper error handling and loading states
   - Comprehensive testing coverage

2. **Code Quality Requirements**:

   - Follow `project-core/rules/frameworks/` standards
   - Implement security best practices
   - Optimize for performance
   - Maintain clean, readable code

3. **Integration Requirements**:

   - Use appropriate MCP tools (TaskMaster, Playwright, Figma, Sequential Thinking)
   - Follow established patterns and conventions
   - Validate all external integrations
   - Document any new patterns discovered

4. **Multi-Phase Project Requirements** (if 2+ phases detected):
   - **Phase Completion Verification**: Validate each phase before proceeding
   - **Cross-Phase Dependency Management**: Ensure prerequisites are met
   - **Sequential Thinking Integration**: Use `sequential-thinking` MCP for complex analysis
   - **Automatic Error Logging**: Log phase completion and errors to memory-bank

#### Technology-Specific Execution:

- **Frontend**: Next.js 14+, TypeScript, Tailwind CSS, Shadcn/ui
- **Backend**: Node.js, Express/Fastify, Prisma ORM, PostgreSQL
- **Auth**: NextAuth.js/Clerk with proper security
- **Payments**: Stripe integration with proper error handling

### **STEP 4: LEARN & IMPROVE (Reflection and Evolution)**

#### Mandatory Post-Execution Actions:

1. **Self-Improvement Protocol Activation**:

   - Analyze execution success/failure
   - Identify improvement opportunities
   - Update `memory-bank/self_correction_log.md`
   - Document new patterns or solutions

2. **Multi-Phase Project Logging** (if 2+ phases detected):

   - **Phase Completion Documentation**:

     ```bash
     # Log phase completion to memory-bank
     task-master log-phase --phase-id={current_phase} --status=completed --errors={error_count}

     # Update memory-bank with phase learnings
     echo "### Phase {phase_number} Completion - $(date)" >> memory-bank/self_correction_log.md
     echo "**Task ID**: {task_id}" >> memory-bank/self_correction_log.md
     echo "**Phase Completed**: {phase_name}" >> memory-bank/self_correction_log.md
     echo "**Errors Detected**: {error_list}" >> memory-bank/self_correction_log.md
     echo "**Solutions Applied**: {solution_list}" >> memory-bank/self_correction_log.md
     echo "**Next Phase Prerequisites**: {prerequisites}" >> memory-bank/self_correction_log.md
     echo "---" >> memory-bank/self_correction_log.md
     ```

   - **Cross-Phase Dependency Validation**:

     ```bash
     # Verify next phase prerequisites
     task-master validate-dependencies --next-phase={next_phase_id}

     # Check Sequential Thinking MCP integration health
     task-master health-check --mcp=sequential-thinking
     ```

3. **Knowledge Capture**:

   - Record successful patterns for reuse
   - Document error solutions for future reference
   - Update relevant standards if needed
   - Share insights with the team

4. **System Evolution**:
   - Suggest improvements to protocols
   - Identify gaps in current standards
   - Propose new tools or integrations
   - Contribute to continuous improvement

## 🏗️ HIERARCHICAL PROTOCOL COORDINATION

### Precedence Order (Automatic Application):

#### **0. Initialization Protocols (ABSOLUTE PRECEDENCE)**

- Workspace Verification (STEP 0)
- TaskMaster AI Integration
- MCP Server Initialization

#### **1. Execution Protocols (MACRO STRUCTURE)**

- 4-Step Execution Cycle (this protocol)
- Unified Protocol Layers (Memory → Meta → Verification → Learning)

#### **2. Specialized Protocols (ON-DEMAND)**

- Sequential Thinking MCP (complexity ≥ 7 OR multi-phase projects)
- Multi-Phase Coordination (2+ phases detected)
- Completeness Verification (complex tasks)
- Performance Optimization (resource-intensive tasks)

#### **3. Background Protocols (CONTINUOUS)**

- Cost Optimization (all operations)
- Context Management (token monitoring)
- Quality Assurance (ongoing validation)

## 🎯 SPECIALIZED PROTOCOL ACTIVATION

### Multi-Phase Project Protocol (2+ Phases Detected):

1. **Phase Detection and Announcement**: "Multi-phase project detected. Activating enhanced protocols."
2. **TaskMaster + Sequential Thinking Integration**: Mandatory activation of both MCP tools
3. **Phase-by-Phase Execution**: Complete one phase before proceeding to next
4. **Phase Completion Verification**: Validate phase completion and log to memory-bank
5. **Cross-Phase Dependency Management**: Ensure prerequisites are met before phase transitions

### TaskMaster Protocol (Large/Complex Tasks):

1. **Estimate and Announce**: "This is a large task. Using TaskMaster Protocol."
2. **Decompose into Plan**: Create numbered, sequential sub-tasks
3. **Execute Sequentially**: One sub-task at a time with confirmation
4. **Synthesize Result**: Provide comprehensive final summary

### Sequential Thinking MCP Protocol (Complex Analysis):

1. **Activation Criteria**: Complexity ≥ 7 OR multi-phase project detected
2. **MCP Integration**: Use `sequential-thinking` alias for MCP server connection
3. **Structured Analysis**: Apply problem_definition → analysis → synthesis stages
4. **Context Preservation**: Maintain thinking context across phase transitions

### Comprehensive Audit Protocol (System-Wide Reviews):

1. **Initial Assessment**: Identify all audit categories
2. **Category-by-Category**: Process one category at a time
3. **Incremental Fixes**: Implement improvements progressively
4. **Progress Tracking**: Maintain clear status updates
5. **Final Synthesis**: Comprehensive summary of all improvements

### Safe File Modification Protocol (Code Changes):

1. **Read Full File**: Load complete current content
2. **Modify in Memory**: Build complete final version
3. **Overwrite Entire File**: Replace with new content
4. **Verify Changes**: Read back to confirm modifications

## 🎯 RULE ORCHESTRATION ENGINE

### **Conditional Loading Algorithm**

```markdown
# Master Rule Loading Logic

FUNCTION loadRulesForTask(taskDescription, complexity, context):

    # PHASE 1: Always load core rules
    rules = []
    rules.append("01-core-principles.md")
    rules.append("02-coding-standards-universal.md")
    rules.append("universal-pre-execution-verification.md")

    # PHASE 2: Framework detection and loading
    IF detectFramework(taskDescription, context) == "nextjs":
        rules.append("frameworks/nextjs-react.md")
    ELIF detectFramework(taskDescription, context) == "laravel":
        rules.append("frameworks/laravel-livewire.md")
    END IF

    # PHASE 3: MCP integration based on complexity and keywords
    IF complexity >= 7 OR detectMultiPhase(taskDescription):
        rules.append("mcp-integration/taskmaster-protocol.md")
    END IF

    IF containsKeywords(taskDescription, ["automation", "testing", "e2e"]):
        rules.append("mcp-integration/playwright-automation.md")
    END IF

    IF containsKeywords(taskDescription, ["design", "figma", "component"]):
        rules.append("mcp-integration/figma-design-sync.md")
    END IF

    IF containsKeywords(taskDescription, ["database", "supabase", "migration"]):
        rules.append("mcp-integration/supabase-database.md")
    END IF

    IF getContextUsage() >= 90%:
        rules.append("mcp-integration/new-task-automation-90.md")
    END IF

    RETURN rules

END FUNCTION
```

### **Rule Dependency Resolution**

```markdown
# Ensure orphan rules are properly connected

FUNCTION resolveRuleDependencies(loadedRules):

    # Ensure core principles are referenced by all framework rules
    IF "frameworks/nextjs-react.md" IN loadedRules:
        ensureReference("frameworks/nextjs-react.md", "01-core-principles.md")
        ensureReference("frameworks/nextjs-react.md", "02-coding-standards-universal.md")
    END IF

    # Ensure MCP rules reference core principles
    FOR each mcpRule IN loadedRules WHERE mcpRule.startsWith("mcp-integration/"):
        ensureReference(mcpRule, "01-core-principles.md")
    END FOR

    RETURN loadedRules

END FUNCTION
```

## ⚡ PERFORMANCE OPTIMIZATION

### **Smart Loading Metrics**

- **Rule Loading Time**: < 5ms average per rule
- **Context Reduction**: 40-60% reduction in initial context load
- **Cache Hit Rate**: > 80% for frequently used rule combinations
- **Memory Efficiency**: < 2MB rule cache footprint

### **Token Efficiency Improvements**

- **Conditional Loading**: Load only relevant rules (estimated 40-60% token reduction)
- **Rule Caching**: Cache frequently used rule combinations
- **Lazy Loading**: Load specialized rules only when triggered
- **Smart Aliases**: Use shortened references for repeated rule paths

### **Quality Metrics (Enhanced)**

- **Completion Rate**: > 85% first attempt (maintained)
- **Token Usage**: < 30k per feature (improved from 50k through conditional loading)
- **Error Rate**: < 15% in production (maintained)
- **User Satisfaction**: > 9/10 (maintained)
- **Rule Loading Efficiency**: > 90% relevant rules loaded per task

## 🔒 SECURITY AND COMPLIANCE

### Data Protection:

- NEVER commit .env files
- ALWAYS use environment variables
- VALIDATE all user inputs
- IMPLEMENT rate limiting

### Git Workflow:

```bash
# Feature branch mandatory
git checkout -b feature/descriptive-name

# Semantic commits
git commit -m "feat: add new functionality"
git commit -m "fix: resolve component X bug"
```

## ✅ ENFORCEMENT AND VALIDATION

### Critical Requirements:

- **Non-compliance with this protocol is a critical error**
- **ALL steps must be followed in sequence**
- **Confirmation required before execution**
- **Learning phase is MANDATORY**

### Success Validation:

- [ ] Workspace verification passed
- [ ] TaskMaster initialized
- [ ] Multi-phase detection completed (if applicable)
- [ ] **Rule orchestration executed**: Conditional loading algorithm applied
- [ ] **Core rules loaded**: Foundation principles and standards loaded
- [ ] **Framework rules loaded**: Context-appropriate framework rules loaded
- [ ] **MCP rules loaded**: Task-relevant MCP integration rules loaded
- [ ] **Orphan rules integrated**: All rules connected to dependency graph
- [ ] Sequential Thinking MCP activated (if complexity ≥ 7 or multi-phase)
- [ ] Plan confirmed by user
- [ ] Implementation complete
- [ ] Phase completion verified (if multi-phase)
- [ ] Error logging to memory-bank completed
- [ ] **Rule performance measured**: Loading efficiency and token usage tracked
- [ ] Learning captured
- [ ] Documentation updated

## 📊 RULE SYSTEM HEALTH MONITORING

### **Performance Metrics Dashboard**

```bash
# Monitor rule loading performance
npm run rules:performance-test

# Validate rule dependencies
npm run rules:dependency-check

# Test conditional loading algorithm
npm run rules:conditional-loading-test

# Measure token usage improvements
npm run rules:token-efficiency-report
```

### **Continuous Improvement Tracking**

- **Weekly**: Review rule loading patterns and optimize frequently used combinations
- **Monthly**: Analyze token usage improvements and adjust conditional loading thresholds
- **Quarterly**: Evaluate new rule integration opportunities and system architecture

---

## 🏗️ PROJECT STRUCTURE STANDARDIZATION PROTOCOL

### **MANDATORY PROJECT STRUCTURE COMPLIANCE**

All GRUPO US projects MUST follow the standardized structure defined in `@project-core/docs/project-structure-template.md`.

#### **Refactoring Protocol for Existing Projects:**

1. **Complexity Assessment** (using `@project-core/rules/complexity-assessment-guidelines.md`):

   - Score 1-6: Skip TaskMaster initialization
   - Score 7-10: Initialize TaskMaster for complex refactoring

2. **5-Phase Refactoring Protocol** (detailed in `@project-core/docs/refactoring-playbook.md`):

   - **Phase 1**: Backup (conditional - skip if user confirms external backups)
   - **Phase 2**: Cleanup and Consolidation
   - **Phase 3**: Rule Centralization to `Rules/` directory
   - **Phase 4**: Structure Optimization to match template
   - **Phase 5**: Final Cleanup and Validation

3. **Automation Standards** (reference `@project-core/docs/automation-flags-reference.md`):
   - Use `-Force -ErrorAction SilentlyContinue` for PowerShell operations
   - Use `--silent` flags for npm operations
   - Use `--yes` flags for TaskMaster operations

#### **New Project Requirements:**

- **MUST** use the official template structure
- **MUST** implement required technology stack (Next.js 14+, TypeScript, Tailwind CSS)
- **MUST** centralize all rules in `Rules/` directory
- **MUST** pass structure validation before deployment

#### **Enforcement:**

- Non-compliant projects will be rejected from production
- All existing projects have 30-day grace period for compliance
- Refactoring assistance available through TaskMaster integration

---

**This enhanced protocol ensures optimal rule orchestration, performance optimization, and continuous system evolution across all GRUPO US development activities.**
