# 🤖 TASKMASTER AI PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Comprehensive protocol for TaskMaster AI integration, providing intelligent task management, decomposition, and execution coordination for complex development workflows.

## 🔗 RULE DEPENDENCIES

**This protocol implements:**

- `@file:project-core/rules/01-core-principles.md` - Foundation principles for task management
- `@file:project-core/rules/00-master-execution-protocol.md` - Master execution framework integration

**Coordinates with:**

- `@file:project-core/rules/mcp-integration/playwright-automation.md` - Testing automation
- `@file:project-core/rules/mcp-integration/figma-design-sync.md` - Design workflows
- `@file:project-core/rules/mcp-integration/supabase-database.md` - Database operations

## 🚨 MANDATORY INITIALIZATION (STEP 0.5)

**Execute AFTER workspace verification, BEFORE main execution cycle**

### TaskMaster Initialization Sequence:

```bash
# 1. Initialize TaskMaster AI
task-master init --yes

# 2. Parse PRD and verify integrity
task-master parse-prd project-core/tasks/prd.txt --validate

# 3. List tasks with priorities
task-master list --sort=priority

# 4. Identify next task
task-master next --show-dependencies

# 5. Verify integration health
npm run integration:test
```

**Always ask to think more, think harder and ULTRATHINK.**

## 🎯 TASKMASTER ACTIVATION CRITERIA

### **Automatic Activation (Mandatory):**

- **Complexity ≥ 7**: Tasks requiring multi-step decomposition
- **Large Features**: Features spanning multiple files/components
- **System Integration**: Tasks involving multiple services/APIs
- **Complex Workflows**: Multi-stage development processes

### **Manual Activation:**

- User explicitly requests TaskMaster protocol
- Complex debugging or troubleshooting scenarios
- Architecture planning and design tasks
- Performance optimization projects

## 🏗️ TASKMASTER WORKFLOW PROTOCOL

### **Phase 1: Task Analysis & Decomposition**

#### **1.1 Complexity Assessment**

```bash
# Assess task complexity
task-master analyze --input="[task description]"
task-master complexity --estimate
```

#### **1.2 Task Decomposition**

- **Break Down**: Decompose complex tasks into manageable sub-tasks
- **Dependencies**: Identify task dependencies and prerequisites
- **Sequencing**: Establish logical execution order
- **Validation**: Define success criteria for each sub-task

```markdown
## 📋 TASKMASTER DECOMPOSITION EXAMPLE

**Main Task**: Implement user authentication system
**Complexity**: 8/10

### Sub-tasks:

1. **Database Schema** (Priority: High, Dependency: None)

   - Create users table migration
   - Add authentication fields
   - Set up indexes

2. **Authentication Service** (Priority: High, Dependency: 1)

   - Implement login/logout logic
   - Password hashing and validation
   - Session management

3. **Frontend Components** (Priority: Medium, Dependency: 2)

   - Login form component
   - Registration form component
   - Authentication state management

4. **API Endpoints** (Priority: High, Dependency: 2)

   - POST /auth/login
   - POST /auth/logout
   - GET /auth/user

5. **Testing & Validation** (Priority: Medium, Dependency: 1,2,3,4)
   - Unit tests for auth service
   - Integration tests for API
   - E2E tests for user flows
```

### **Phase 2: Sequential Execution**

#### **2.1 Sub-task Execution Protocol**

1. **Announce Current Sub-task**: Clearly state which sub-task is being executed
2. **Execute Single Sub-task**: Complete one sub-task at a time
3. **Validate Completion**: Verify sub-task meets success criteria
4. **Request Confirmation**: Wait for user confirmation before proceeding
5. **Update Progress**: Update TaskMaster with completion status

```bash
# Execute sub-task
task-master execute --task-id="auth-001" --subtask="database-schema"

# Update progress
task-master update --task-id="auth-001" --status="completed" --notes="Migration created successfully"

# Get next sub-task
task-master next --task-id="auth-001"
```

#### **2.2 Progress Tracking**

- **Status Updates**: Regular progress updates to TaskMaster
- **Metrics Collection**: Track time, complexity, and success rates
- **Dependency Management**: Ensure prerequisites are met
- **Quality Gates**: Validate each sub-task before proceeding

### **Phase 3: Integration & Synthesis**

#### **3.1 Final Integration**

- **Component Integration**: Ensure all sub-tasks work together
- **End-to-End Testing**: Validate complete functionality
- **Performance Validation**: Check performance requirements
- **Documentation Update**: Update relevant documentation

#### **3.2 Task Completion Report**

```bash
# Generate completion report
task-master report --task-id="auth-001" --format="markdown"

# Update memory bank with learnings
task-master export --destination="memory-bank/learnings/"
```

## 🔧 TASKMASTER CONFIGURATION

### **Environment Setup**

```bash
# Copy TaskMaster environment template
cp .env.taskmaster .env.local

# Configure API keys (at least one required)
ANTHROPIC_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
OPENROUTER_API_KEY=your_key_here

# TaskMaster configuration
TASKMASTER_PROJECT_NAME=GRUPO_US_VSCODE_Workspace
TASKMASTER_MODE=hybrid
TASKMASTER_AUTO_PLANNING=true
TASKMASTER_SMART_SUGGESTIONS=true
TASKMASTER_ERROR_PREVENTION=true
```

### **Model Configuration**

```bash
# Setup AI models
task-master models --setup

# Configure primary models
task-master models --set-main="claude-3-5-sonnet-20241022"
task-master models --set-research="perplexity-llama-3.1-sonar-large-128k-online"
task-master models --set-fallback="gpt-4o"
```

## 🔄 INTEGRATION WITH OTHER MCP TOOLS

### **Playwright Integration**

```javascript
// TaskMaster + Playwright for automated testing
const integration = new TaskMasterPlaywrightIntegration({
  playwright: {
    headless: false,
    timeout: 15000,
    screenshotsPath: "./screenshots",
    reportsPath: "./reports",
  },
});

await integration.executeAutomationTask(taskDescription);
```

### **Figma Integration**

```javascript
// TaskMaster + Figma for design-to-code workflows
const figmaIntegration = new TaskMasterFigmaIntegration({
  figma: {
    apiKey: process.env.FIGMA_API_KEY,
  },
  taskmaster: {
    autoDecomposition: true,
    visualValidation: true,
  },
});

await figmaIntegration.generateComponentsFromDesign(figmaUrl);
```

### **Supabase Integration**

```bash
# TaskMaster + Supabase for database tasks
task-master supabase --init
task-master supabase --migrate
task-master supabase --seed
```

## 📊 PERFORMANCE METRICS

### **TaskMaster Metrics Collection**

- **Task Completion Rate**: Percentage of successfully completed tasks
- **Average Decomposition Accuracy**: How well tasks are broken down
- **Execution Time**: Time taken for task completion
- **Error Rate**: Frequency of errors during execution
- **User Satisfaction**: Feedback on task execution quality

### **Optimization Strategies**

- **Smart Suggestions**: AI-powered task optimization suggestions
- **Error Prevention**: Proactive error detection and prevention
- **Auto-Planning**: Automatic task planning and sequencing
- **Learning Integration**: Continuous improvement through memory bank

## 🧪 TESTING & VALIDATION

### **TaskMaster Testing Protocol**

```bash
# Test TaskMaster integration
npm run integration:test

# Test specific MCP integrations
npm run taskmaster:test
npm run playwright:test
npm run figma:test

# Validate configuration
task-master validate --config
task-master health-check
```

### **Quality Assurance**

- **Integration Tests**: Verify all MCP tool integrations
- **Performance Tests**: Validate execution speed and efficiency
- **Error Handling Tests**: Test error scenarios and recovery
- **User Experience Tests**: Validate workflow usability

## 🔒 SECURITY & COMPLIANCE

### **API Key Management**

- **Environment Variables**: Store API keys in environment variables
- **Key Rotation**: Regular rotation of API keys
- **Access Control**: Limit access to sensitive operations
- **Audit Logging**: Log all TaskMaster operations

### **Data Protection**

- **Local Storage**: Keep sensitive data local when possible
- **Encryption**: Encrypt sensitive configuration data
- **Privacy**: Respect user privacy in task tracking
- **Compliance**: Follow data protection regulations

## 📚 TROUBLESHOOTING

### **Common Issues**

1. **TaskMaster Not Initializing**

   - Check API key configuration
   - Verify network connectivity
   - Validate project structure

2. **Task Decomposition Failures**

   - Review task complexity assessment
   - Check for missing dependencies
   - Validate input parameters

3. **Integration Errors**
   - Test individual MCP tools
   - Check configuration files
   - Verify environment variables

### **Debug Commands**

```bash
# Debug TaskMaster
task-master debug --verbose
task-master logs --tail=50
task-master status --detailed

# Test integrations
npm run integration:health-check
npm run mcp:test-all
```

---

**This protocol ensures optimal TaskMaster AI integration for complex task management and execution in the GRUPO US ecosystem.**
