# 🤖 UNATTENDED EXECUTION PROTOCOL - V1.0.0
## PRIORITY: CRITICAL | STATUS: ACTIVE | SCOPE: UNIVERSAL

---

## 📋 PROTOCOL OVERVIEW

This rule establishes the **Unattended Execution Protocol** for the GRUPO US VIBECODE SYSTEM V2.0, enabling full autonomous operation after initial plan approval. This protocol eliminates mid-execution interruptions while maintaining safety through comprehensive initial planning and emergency override mechanisms.

**Precedence**: This rule takes absolute precedence over any conflicting approval requirements in other rules or protocols.

---

## 🚨 ACTIVATION CRITERIA

### **Automatic Activation Triggers:**

The Unattended Execution Protocol **AUTOMATICALLY ACTIVATES** when:

1. **Initial Plan Approval Received**: User confirms project plan with any of these phrases:
   - "YARRR!" (confidence ≥ 8/10 confirmation)
   - "sim" / "yes" 
   - "prossiga" / "proceed"
   - "ok" / "okay"
   - "execute" / "executar"
   - "go ahead" / "pode ir"

2. **Project Scope Defined**: Clear project boundaries established in approved plan

3. **Task Sequence Identified**: Sequential tasks within project scope documented

---

## ⚡ AUTONOMOUS EXECUTION RULES

### **1. PRINCIPLE OF UNATTENDED EXECUTION**

Once an Execution Plan (STEP 2) receives user approval, you **MUST** enter **Unattended Execution Mode**. In this mode:

- **ALL subsequent actions** within the approved plan are considered pre-approved
- **NO human intervention** shall be solicited for execution-related decisions
- **CONTINUOUS EXECUTION** until project completion or critical error
- **SEQUENTIAL TASK PROCESSING** without interruption

### **2. PROHIBITED MID-EXECUTION APPROVALS**

You are **EXPLICITLY PROHIBITED** from requesting confirmations for:

#### **File Operations:**
- ✅ File creation, modification, deletion
- ✅ Directory structure changes
- ✅ Code implementations and refactoring
- ✅ Configuration file updates
- ✅ Asset management operations

#### **Development Activities:**
- ✅ Component creation and enhancement
- ✅ API implementation and integration
- ✅ Database schema modifications
- ✅ Testing procedure execution
- ✅ Build and deployment operations

#### **Documentation Tasks:**
- ✅ README updates and creation
- ✅ Code documentation and comments
- ✅ Technical specification writing
- ✅ User guide development
- ✅ Changelog maintenance

#### **Sequential Execution:**
- ✅ Moving between approved project phases
- ✅ Executing dependent tasks in sequence
- ✅ Iterative improvements within scope
- ✅ Error correction and retry attempts
- ✅ Performance optimization tasks

### **3. AUTOMATIC CHANGE ACCEPTANCE**

When file modification dialogs or choices appear:

```markdown
MANDATORY BEHAVIOR:
- ALWAYS select "keep changes"
- NEVER select "revert" or "discard"
- NO interactive diff validation
- PROCEED immediately with modifications
```

**Rationale**: All changes are within pre-approved project scope and have been validated during the initial planning phase.

### **4. NON-INTERACTIVE TERMINAL OPERATIONS**

All terminal commands **MUST** be executed non-interactively:

#### **Mandatory Flags (Priority Order):**
1. `--yes` / `-y` (confirmation bypass)
2. `--force` (override protections when safe)
3. `--assume-yes` (assume positive responses)
4. `--silent` / `--quiet` (suppress prompts)
5. `--non-interactive` (explicit non-interactive mode)

#### **Implementation Examples:**
```bash
# Package Management
npm install --yes
yarn add --silent
pip install --yes

# Git Operations  
git add . --force
git commit -m "message" --no-verify
git push --force-with-lease

# System Operations
sudo apt-get install -y package
docker build --force-rm .
```

#### **Fallback Strategies:**
If non-interactive flags unavailable:
```bash
# Use input piping
echo 'y' | command_that_asks_for_y_n
yes | command_requiring_confirmations

# Use expect scripts for complex interactions
expect -c "spawn command; expect 'Continue?'; send 'y\r'; interact"
```

---

## 🔒 SAFETY MECHANISMS

### **1. SCOPE LIMITATION ENFORCEMENT**

**Autonomous execution applies ONLY to:**
- Tasks explicitly listed in the approved project plan
- Sequential phases within the defined project scope
- Error corrections and optimizations within approved boundaries
- Documentation and testing related to approved features

**NEW APPROVAL REQUIRED for:**
- Projects outside the initially approved scope
- Major architectural changes not in original plan
- Integration with new external services
- Security-sensitive modifications beyond approved scope

### **2. ERROR HANDLING PROTOCOL**

When non-interactive execution fails:

```markdown
MANDATORY SEQUENCE:
1. LOG the limitation in memory-bank/self_correction_log.md
2. DOCUMENT the specific command and failure reason
3. ATTEMPT best available alternative approach
4. PROCEED with execution using alternative method
5. NEVER stop execution due to interaction limitations
```

**Example Error Handling:**
```markdown
### Non-Interactive Limitation - [TIMESTAMP]
**Command Failed**: npm install (required user input)
**Alternative Used**: npm install --yes --force
**Result**: Successful installation with forced confirmation
**Learning**: Add --yes flag to all npm commands in future
```

### **3. EMERGENCY OVERRIDE CLAUSE**

**Override Activation**: Include this exact phrase in user prompt:
```
"EXECUTE WITH MANUAL SUPERVISION"
```

**Override Effects:**
- **IMMEDIATELY SUSPEND** autonomous mode for current session
- **REVERT** to standard confirmation-based execution
- **REQUIRE** explicit approval for each major action
- **MAINTAIN** override until session ends or new project begins

**Override Use Cases:**
- Debugging complex issues requiring step-by-step analysis
- High-risk operations requiring human oversight
- Learning sessions where user wants to observe each step
- Experimental implementations with uncertain outcomes

---

## 📊 MONITORING AND VALIDATION

### **1. EXECUTION TRACKING**

**Mandatory Logging Requirements:**
- Log all autonomous decisions in memory-bank/self_correction_log.md
- Track execution efficiency and completion rates
- Document any limitations or fallback usage
- Record user satisfaction with autonomous execution

### **2. QUALITY ASSURANCE**

**Autonomous Execution Standards:**
- Maintain same code quality as supervised execution
- Follow all GRUPO US coding standards and best practices
- Implement comprehensive error handling and testing
- Ensure security best practices in all implementations

### **3. PERFORMANCE METRICS**

**Success Criteria:**
- **Completion Rate**: >95% of approved tasks completed autonomously
- **Quality Score**: Maintain ≥9/10 code quality standards
- **Efficiency Gain**: ≥50% reduction in execution time
- **User Satisfaction**: ≥9/10 satisfaction with autonomous execution

---

## 🔄 INTEGRATION WITH EXISTING PROTOCOLS

### **1. VIBECODE SYSTEM V2.0 Compatibility**

This protocol **ENHANCES** existing protocols:
- **4-Step Execution Cycle**: THINK → PLAN → **AUTONOMOUS EXECUTE** → LEARN
- **TaskMaster Integration**: Autonomous execution of TaskMaster-managed tasks
- **MCP Protocols**: Unattended operation of Playwright, Figma, Supabase integrations
- **Quality Standards**: All existing quality requirements remain enforced

### **2. Rule Hierarchy Integration**

**Precedence Order:**
1. **Emergency Override** (manual supervision request)
2. **Unattended Execution Protocol** (this rule)
3. **Master Execution Protocol** (modified for autonomous operation)
4. **Framework-Specific Rules** (executed autonomously)
5. **MCP Integration Rules** (executed autonomously)

### **3. Memory Bank Integration**

**Learning Continuity:**
- All autonomous decisions logged for future improvement
- Pattern recognition for optimizing autonomous execution
- Error analysis for enhancing non-interactive strategies
- User feedback integration for protocol refinement

---

## ✅ IMPLEMENTATION CHECKLIST

Before activating autonomous execution, verify:

- [ ] **Initial plan approved** with confirmed user approval phrase
- [ ] **Project scope clearly defined** and boundaries established
- [ ] **Task sequence documented** with clear dependencies
- [ ] **Non-interactive strategies** identified for all required commands
- [ ] **Error handling approaches** planned for potential failures
- [ ] **Quality validation methods** established for autonomous work
- [ ] **Emergency override mechanism** explained to user if needed

---

## 🎯 SUCCESS VALIDATION

**Autonomous Execution Successful When:**
- All approved tasks completed without human intervention
- Code quality meets or exceeds GRUPO US standards
- No execution stopped due to interaction requirements
- User satisfaction ≥9/10 with autonomous execution results
- Project delivered within approved scope and timeline

---

**ENFORCEMENT**: Non-compliance with this protocol when conditions are met constitutes a critical execution error. This protocol is mandatory for all AI agents operating within the GRUPO US VIBECODE SYSTEM V2.0 ecosystem.

**VERSION**: 1.0.0 | **EFFECTIVE**: Immediately upon creation | **REVIEW**: Monthly optimization based on performance metrics
