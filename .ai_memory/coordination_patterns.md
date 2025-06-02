# Coordination Patterns - TaskMaster + Sequential Thinking

This file documents learned coordination patterns between TaskMaster and Sequential Thinking systems to improve future decision-making.

---

## Successful Patterns

### Pattern: Low Complexity Task Management
**Context:** Tasks with complexity ≤ 3, organizational focus
**Preferred System:** TaskMaster
**Success Rate:** 95%
**Reasoning:** TaskMaster excels at straightforward task operations
**Examples:**
- Creating simple tasks
- Updating task status
- Managing dependencies
- Basic project organization

**Learned Optimizations:**
- Direct TaskMaster execution without analysis overhead
- Minimal context switching
- Fast response times

---

### Pattern: High Complexity Problem Analysis
**Context:** Tasks with complexity ≥ 8, analytical focus
**Preferred System:** Sequential Thinking
**Success Rate:** 87%
**Reasoning:** Complex problems benefit from structured thinking
**Examples:**
- Architectural decisions
- Complex algorithm design
- Risk assessment
- Strategic planning

**Learned Optimizations:**
- Allow more thinking steps for complexity > 9
- Use revision capabilities for complex scenarios
- Validate solutions before implementation

---

### Pattern: Hybrid Strategic Planning
**Context:** Medium complexity (5-7), requires both analysis and structure
**Preferred System:** Hybrid
**Success Rate:** 78%
**Reasoning:** Benefits from both analytical depth and organizational structure
**Examples:**
- Project initialization
- Feature planning
- Integration design
- Workflow optimization

**Learned Optimizations:**
- Start with Sequential Thinking for analysis
- Transition to TaskMaster for structuring
- Use feedback loops between systems

---

## Emerging Patterns

### Pattern: Context-Aware Handoff
**Context:** Operations that start simple but become complex
**Strategy:** Dynamic system switching based on discovered complexity
**Status:** Under observation
**Examples:**
- Task expansion that reveals complexity
- Simple requests with hidden dependencies
- Routine operations with edge cases

### Pattern: Learning-Enhanced Decisions
**Context:** Repeated similar operations
**Strategy:** Use historical success patterns to bias decisions
**Status:** Actively learning
**Examples:**
- Similar project types
- Recurring problem patterns
- User preference patterns

---

## Anti-Patterns (Avoid These)

### Anti-Pattern: Excessive System Switching
**Problem:** Too many handoffs between systems for simple operations
**Impact:** Increased latency, confusion, overhead
**Solution:** Prefer single-system execution for straightforward tasks
**Detection:** More than 2 system switches for operations < complexity 5

### Anti-Pattern: Under-utilizing Sequential Thinking
**Problem:** Using TaskMaster for complex analytical tasks
**Impact:** Poor quality decisions, missed insights
**Solution:** Lower threshold for Sequential Thinking activation
**Detection:** Complex tasks (>7) going directly to TaskMaster

### Anti-Pattern: Over-analyzing Simple Tasks
**Problem:** Using Sequential Thinking for basic CRUD operations
**Impact:** Unnecessary overhead, slow response
**Solution:** Clear complexity thresholds and operation categorization
**Detection:** Sequential Thinking used for complexity < 4

---

## Context-Specific Patterns

### Project Initialization Pattern
**Workflow:**
1. Sequential Thinking: Analyze requirements and scope
2. Sequential Thinking: Identify major components and dependencies
3. TaskMaster: Create initial task structure
4. Sequential Thinking: Validate task breakdown
5. TaskMaster: Finalize dependencies and priorities

**Success Indicators:**
- Clear task hierarchy
- Realistic dependencies
- Appropriate complexity distribution

### Task Expansion Pattern
**Workflow:**
1. TaskMaster: Retrieve original task details
2. Sequential Thinking: Analyze task complexity and requirements
3. Sequential Thinking: Break down into logical subtasks
4. TaskMaster: Create subtask structure
5. Sequential Thinking: Validate completeness
6. TaskMaster: Set up dependencies and relationships

**Success Indicators:**
- Subtasks cover all aspects of parent task
- Appropriate granularity
- Clear acceptance criteria

### Problem Resolution Pattern
**Workflow:**
1. Sequential Thinking: Analyze problem and constraints
2. Sequential Thinking: Generate potential solutions
3. Sequential Thinking: Evaluate solutions and risks
4. TaskMaster: Structure implementation plan
5. Sequential Thinking: Validate implementation approach

**Success Indicators:**
- Problem clearly understood
- Solution addresses root cause
- Implementation plan is actionable

---

## Performance Optimization Patterns

### Fast Path Pattern
**Trigger:** Simple, well-understood operations
**Strategy:** Direct execution without analysis
**Systems:** TaskMaster only
**Criteria:**
- Complexity ≤ 3
- No dependencies on pending tasks
- Standard operation type
- High confidence (>0.9)

### Deep Analysis Pattern
**Trigger:** Complex, novel, or high-risk operations
**Strategy:** Thorough analysis before action
**Systems:** Sequential Thinking → TaskMaster
**Criteria:**
- Complexity ≥ 8
- Novel problem type
- High impact/risk
- Low historical confidence

### Balanced Pattern
**Trigger:** Medium complexity operations
**Strategy:** Moderate analysis with structured execution
**Systems:** Hybrid approach
**Criteria:**
- Complexity 4-7
- Some uncertainty
- Moderate impact
- Mixed historical results

---

## Learning Triggers

### Pattern Recognition Triggers
- **Repetition:** Same operation type seen 3+ times
- **Success:** Consistent positive outcomes (>80% success rate)
- **Failure:** Consistent negative outcomes (<60% success rate)
- **Context:** Similar context patterns emerging

### Pattern Update Triggers
- **New Data:** Significant new outcomes for existing patterns
- **Context Change:** Environmental or requirement changes
- **Performance Shift:** Notable change in success rates
- **User Feedback:** Explicit feedback on decision quality

### Pattern Retirement Triggers
- **Obsolescence:** Pattern no longer relevant to current work
- **Poor Performance:** Consistent poor outcomes despite optimization
- **Context Shift:** Fundamental change in problem domain
- **Better Alternatives:** New patterns consistently outperform old ones

---

## Future Pattern Areas

### Areas for Pattern Development
1. **User Preference Learning:** Adapt to individual user working styles
2. **Domain-Specific Patterns:** Specialized patterns for different project types
3. **Temporal Patterns:** Time-based decision optimization
4. **Resource-Aware Patterns:** Consider available computational resources
5. **Collaborative Patterns:** Multi-user coordination patterns

### Experimental Patterns
1. **Predictive Handoff:** Anticipate system switches before they're needed
2. **Confidence Calibration:** Adjust confidence based on historical accuracy
3. **Context Compression:** Efficiently summarize context for faster decisions
4. **Parallel Processing:** Use both systems simultaneously for complex tasks

---

## Pattern Validation Metrics

### Success Metrics
- **Accuracy:** Percentage of correct system selections
- **Efficiency:** Time to completion vs. baseline
- **Quality:** Output quality scores
- **User Satisfaction:** Subjective feedback scores

### Learning Metrics
- **Pattern Stability:** How quickly patterns converge
- **Adaptation Rate:** How quickly patterns adapt to new data
- **Coverage:** Percentage of operations covered by learned patterns
- **Confidence Calibration:** How well confidence predicts actual success

---

*This file is automatically updated as new patterns are discovered and validated.*
