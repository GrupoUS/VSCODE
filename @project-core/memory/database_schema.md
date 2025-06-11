# TaskMaster + Sequential Thinking Database Schema

This file provides an overview of the application's database schema to guide data interaction. [cite: 35]

## Schema Overview (File-based Data Storage)
The TaskMaster system uses JSON files for data persistence instead of traditional databases. [cite: 38]

---

## Core Data Files

### `.taskmaster/tasks/tasks.json`
**Purpose:** Main task storage with hierarchical structure
**Location:** Project root `.taskmaster/tasks/`
**Structure:**
```json
{
  "metadata": {
    "version": "string",
    "projectName": "string", 
    "lastUpdated": "ISO timestamp",
    "totalTasks": "number"
  },
  "tasks": [
    {
      "id": "number", // Unique identifier
      "title": "string", // Brief task title
      "description": "string", // Task summary
      "status": "string", // pending|in-progress|done|deferred|cancelled
      "priority": "string", // high|medium|low
      "dependencies": ["number"], // Array of task IDs
      "details": "string", // Implementation details
      "testStrategy": "string", // Verification approach
      "subtasks": [
        {
          "id": "number", // Subtask identifier
          "title": "string",
          "description": "string",
          "status": "string",
          "dependencies": ["string"], // Can reference other tasks/subtasks
          "details": "string"
        }
      ],
      "createdAt": "ISO timestamp",
      "updatedAt": "ISO timestamp"
    }
  ]
}
```

---

### `.taskmaster/config.json`
**Purpose:** System configuration and AI model settings
**Location:** Project root `.taskmaster/`
**Structure:**
```json
{
  "models": {
    "main": "string", // Primary AI model
    "research": "string", // Research model
    "fallback": "string" // Fallback model
  },
  "parameters": {
    "maxTokens": "number",
    "temperature": "number"
  },
  "logging": {
    "level": "string", // debug|info|warn|error
    "enabled": "boolean"
  },
  "project": {
    "name": "string",
    "version": "string",
    "defaultPriority": "string",
    "defaultSubtasks": "number"
  }
}
```

---

## Advanced Rules Engine Data

### Decision History (In-Memory)
**Purpose:** Track decisions for learning and improvement
**Storage:** AdvancedRulesEngine.decisionHistory array
**Structure:**
```javascript
[
  {
    "operation": "string", // Operation name
    "context": {
      "complexity": "number",
      "type": "string",
      "description": "string",
      "dependencies": ["string"],
      "hasDeadline": "boolean"
    },
    "decision": {
      "system": "string", // taskmaster|sequential|hybrid
      "confidence": "number", // 0-1
      "reasoning": "string",
      "scores": {
        "taskmaster": "number",
        "sequential": "number",
        "hybrid": "number"
      },
      "metadata": {
        "operation": "string",
        "timestamp": "ISO string",
        "decisionId": "string"
      }
    },
    "timestamp": "ISO string",
    "successful": "boolean|null" // null until outcome is known
  }
]
```

---

### Learning Patterns (In-Memory Map)
**Purpose:** Store learned patterns for decision optimization
**Storage:** AdvancedRulesEngine.learningPatterns Map
**Structure:**
```javascript
Map {
  "pattern_key": {
    "preferredSystem": "string", // taskmaster|sequential|hybrid
    "confidence": "number", // 0-1
    "occurrences": "number", // How many times seen
    "lastUsed": "ISO string" // Last usage timestamp
  }
}
```

---

### Performance Metrics (In-Memory)
**Purpose:** Track system performance and usage statistics
**Storage:** AdvancedRulesEngine.performanceMetrics object
**Structure:**
```javascript
{
  "totalDecisions": "number",
  "successfulDecisions": "number", 
  "averageConfidence": "number",
  "systemUsage": {
    "taskmaster": "number", // Usage count
    "sequential": "number",
    "hybrid": "number"
  }
}
```

---

## Individual Task Files

### `tasks/task_XXX.txt`
**Purpose:** Individual markdown files for each task
**Location:** Project root `tasks/` directory
**Structure:**
```markdown
# Task ID: {id}
# Title: {title}
# Status: {status}
# Dependencies: {comma-separated dependency IDs}
# Priority: {priority}
# Description: {brief description}

# Details:
{detailed implementation notes}

# Test Strategy:
{verification approach}

# Subtasks:
{if subtasks exist, listed here}
```

---

## Configuration Files

### `.env`
**Purpose:** Environment variables and API keys
**Location:** Project root
**Structure:**
```bash
# AI API Keys
ANTHROPIC_API_KEY=sk-ant-...
PERPLEXITY_API_KEY=pplx-...
OPENAI_API_KEY=sk-...

# Optional Configuration
TASKMASTER_LOG_LEVEL=info
DEBUG=false
```

---

### `taskmaster-integration/config/default.json`
**Purpose:** Integration system configuration
**Location:** taskmaster-integration/config/
**Structure:**
```json
{
  "coordination": {
    "defaultSystem": "taskmaster",
    "fallbackTimeout": 5000,
    "maxRetries": 3
  },
  "logging": {
    "level": "info",
    "format": "json",
    "timestamp": true
  },
  "rules": {
    "complexityThreshold": 7,
    "confidenceThreshold": 0.6,
    "learningEnabled": true
  }
}
```

---

## Data Flow Patterns

### Task Creation Flow
1. **Input:** User creates task via CLI or API
2. **Validation:** System validates task structure
3. **Storage:** Task added to tasks.json
4. **Generation:** Individual task file created in tasks/
5. **Dependencies:** System validates and updates dependency graph

### Decision Learning Flow
1. **Decision:** AdvancedRulesEngine makes coordination decision
2. **Execution:** System executes the decided operation
3. **Outcome:** Result is evaluated (success/failure)
4. **Learning:** Pattern is updated in learningPatterns Map
5. **Metrics:** Performance metrics are updated

### Configuration Update Flow
1. **Change:** Configuration parameter is modified
2. **Validation:** System validates new configuration
3. **Persistence:** Changes saved to config.json
4. **Reload:** System reloads configuration
5. **Propagation:** Changes propagated to all components

---

## Data Integrity Rules

### Task Constraints
- **Unique IDs:** All task IDs must be unique within the project
- **Valid Dependencies:** Dependencies must reference existing tasks
- **Status Validation:** Status must be one of predefined values
- **Circular Dependencies:** System prevents circular dependency chains

### Learning Data Constraints
- **Decision History Limit:** Maximum 1000 decisions stored in memory
- **Pattern Confidence:** Confidence values must be between 0 and 1
- **Timestamp Format:** All timestamps must be valid ISO strings
- **Pattern Key Format:** Pattern keys follow specific naming convention

### File System Constraints
- **JSON Validity:** All JSON files must be valid and parseable
- **File Permissions:** System must have read/write access to data directories
- **Backup Strategy:** Critical data should be backed up before major operations
- **Atomic Updates:** File updates should be atomic to prevent corruption

---

## Migration and Versioning

### Data Migration
- **Version Tracking:** Metadata includes version information
- **Backward Compatibility:** System maintains compatibility with previous versions
- **Migration Scripts:** Automated migration for schema changes
- **Rollback Support:** Ability to rollback to previous data versions

### Schema Evolution
- **Additive Changes:** New fields can be added without breaking existing data
- **Deprecation Process:** Old fields are deprecated before removal
- **Documentation Updates:** Schema changes are documented in this file
- **Testing:** All schema changes are thoroughly tested before deployment
