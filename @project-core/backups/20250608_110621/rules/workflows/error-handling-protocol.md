---
description: Comprehensive error handling protocol for GRUPO US projects with automatic escalation
author: GRUPO US VIBECODE SYSTEM V2.0
version: 4.0
globs: ["**/*"]
tags: ["error-handling", "protocol", "automatic", "escalation"]
alwaysApply: true
---

# 🚨 GRUPO US COMPREHENSIVE ERROR HANDLING PROTOCOL

## 📋 OVERVIEW

This protocol consolidates all error handling procedures across GRUPO US projects, implementing automatic escalation, learning integration, and centralized error resolution strategies.

**Consolidated from**: `.clinerules/workflows/error_handling_protocol.md`, `.clinerules/workflows/error_handling_protocol_v2.md`, and enhanced with Phase 4 centralized architecture.

## 🎯 ERROR CLASSIFICATION SYSTEM

### **LEVEL 1: CRITICAL ERRORS (Immediate Stop)**
- **JSON malformed** in MCP tool calls
- **Authentication failures** in APIs
- **Syntax errors** that break execution
- **Timeouts** in critical operations
- **Permission denied** in file operations
- **Database connection failures**
- **Build failures** that prevent deployment

### **LEVEL 2: RECOVERABLE ERRORS (Automatic Retry)**
- **Network timeouts** (temporary)
- **Rate limiting** responses
- **Temporary file locks**
- **Cache misses**
- **Non-critical API failures**

### **LEVEL 3: WARNING LEVEL (Log & Continue)**
- **Deprecation warnings**
- **Performance warnings**
- **Non-critical validation failures**
- **Optional feature failures**

## 🚨 MANDATORY ERROR RESPONSE PROTOCOL

### **PHASE 1: IMMEDIATE RESPONSE (First Occurrence)**

#### **Step 1: Immediate Stop & Assessment**
```javascript
// Automatic error detection and classification
function handleError(error, context) {
  // MANDATORY: Stop all execution immediately
  pauseExecution();
  
  // Classify error level
  const errorLevel = classifyError(error);
  
  // Log error with full context
  logError(error, context, errorLevel);
  
  // Determine response strategy
  return selectResponseStrategy(errorLevel, error);
}
```

#### **Step 2: Diagnostic Analysis**
- **Capture Full Context**: Error message, stack trace, environment state
- **Identify Root Cause**: Analyze error source and contributing factors
- **Assess Impact**: Determine scope of error impact on current task
- **Document Findings**: Record diagnostic information for learning

#### **Step 3: Resolution Strategy Selection**
```javascript
function selectResolutionStrategy(error, context) {
  const strategies = {
    'syntax_error': 'immediate_fix',
    'api_failure': 'retry_with_backoff',
    'permission_error': 'escalate_permissions',
    'timeout_error': 'increase_timeout_retry',
    'dependency_error': 'resolve_dependency'
  };
  
  return strategies[error.type] || 'manual_intervention';
}
```

### **PHASE 2: RESOLUTION EXECUTION**

#### **Automatic Resolution Strategies**

**Strategy 1: Immediate Fix (Syntax/Logic Errors)**
```javascript
function immediateFixStrategy(error) {
  // Analyze error pattern
  const pattern = analyzeErrorPattern(error);
  
  // Apply known fix if available
  if (knownFixes[pattern]) {
    return applyKnownFix(pattern);
  }
  
  // Generate fix based on error analysis
  return generateFix(error);
}
```

**Strategy 2: Retry with Backoff (Network/API Errors)**
```javascript
function retryWithBackoffStrategy(error, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    const delay = Math.pow(2, attempt) * 1000; // Exponential backoff
    
    await sleep(delay);
    
    try {
      return retryOperation();
    } catch (retryError) {
      if (attempt === maxRetries) {
        escalateError(retryError, 'max_retries_exceeded');
      }
    }
  }
}
```

**Strategy 3: Fallback Implementation**
```javascript
function fallbackStrategy(error, operation) {
  const fallbacks = {
    'file_operation': 'use_alternative_file_method',
    'api_call': 'use_cached_data_or_alternative_endpoint',
    'build_process': 'use_alternative_build_configuration',
    'test_execution': 'skip_non_critical_tests'
  };
  
  return executeFallback(fallbacks[operation.type]);
}
```

### **PHASE 3: ESCALATION PROTOCOL (Recurrent Errors)**

#### **Automatic Escalation Triggers**
- **Same error occurs 2+ times** in single session
- **Error resolution fails** after 3 attempts
- **Critical system errors** that cannot be auto-resolved
- **Security-related errors** requiring manual review

#### **Escalation Process**
```javascript
function escalateError(error, escalationReason) {
  // Document escalation
  const escalationRecord = {
    timestamp: new Date().toISOString(),
    error: error,
    reason: escalationReason,
    context: getCurrentContext(),
    previousAttempts: getErrorHistory(error.signature)
  };
  
  // Save to centralized error tracking
  saveToErrorTracking(escalationRecord);
  
  // Activate advanced resolution
  return activateAdvancedResolution(escalationRecord);
}
```

## 🔧 FRAMEWORK-SPECIFIC ERROR HANDLING

### **Next.js Error Handling**
```javascript
// Next.js specific error patterns and resolutions
const nextjsErrorHandlers = {
  'build_error': {
    patterns: ['Module not found', 'Type error', 'Import error'],
    resolution: 'fix_imports_and_types'
  },
  'runtime_error': {
    patterns: ['Hydration mismatch', 'Component error'],
    resolution: 'fix_component_logic'
  },
  'api_error': {
    patterns: ['API route error', 'Middleware error'],
    resolution: 'fix_api_implementation'
  }
};
```

### **Vite Error Handling**
```javascript
// Vite specific error patterns and resolutions
const viteErrorHandlers = {
  'build_error': {
    patterns: ['Rollup error', 'Plugin error', 'Dependency error'],
    resolution: 'fix_vite_configuration'
  },
  'dev_server_error': {
    patterns: ['HMR error', 'Proxy error'],
    resolution: 'restart_dev_server'
  }
};
```

### **Database Error Handling**
```javascript
// Database specific error patterns and resolutions
const databaseErrorHandlers = {
  'connection_error': {
    patterns: ['Connection timeout', 'Authentication failed'],
    resolution: 'check_database_configuration'
  },
  'query_error': {
    patterns: ['Syntax error', 'Constraint violation'],
    resolution: 'fix_query_or_schema'
  }
};
```

## 📊 ERROR LEARNING SYSTEM

### **Pattern Recognition**
```javascript
function learnFromError(error, resolution, success) {
  const errorPattern = {
    signature: generateErrorSignature(error),
    context: getCurrentContext(),
    resolution: resolution,
    success: success,
    timestamp: new Date().toISOString()
  };
  
  // Save to centralized learning system
  updateErrorKnowledgeBase(errorPattern);
  
  // Update resolution strategies
  if (success) {
    addToKnownFixes(errorPattern);
  } else {
    markResolutionAsIneffective(errorPattern);
  }
}
```

### **Knowledge Base Integration**
- **Error Signatures**: Unique identifiers for error patterns
- **Resolution Effectiveness**: Track success rates of different strategies
- **Context Correlation**: Link errors to specific project contexts
- **Trend Analysis**: Identify recurring error patterns across projects

## 🎯 MCP INTEGRATION FOR ERROR HANDLING

### **TaskMaster Error Integration**
```bash
# TaskMaster commands for error handling
task-master log-error --error="[error-description]" --context="[context]"
task-master get-error-history --pattern="[error-pattern]"
task-master suggest-resolution --error-id="[error-id]"
```

### **Playwright Error Integration**
```javascript
// Playwright specific error handling for UI tests
async function handlePlaywrightError(error, page) {
  // Capture screenshot for debugging
  await page.screenshot({ path: `error-${Date.now()}.png` });
  
  // Capture page state
  const pageState = await page.evaluate(() => ({
    url: window.location.href,
    title: document.title,
    errors: window.errors || []
  }));
  
  // Log comprehensive error information
  logPlaywrightError(error, pageState);
}
```

## 📈 ERROR METRICS & MONITORING

### **Key Performance Indicators**
- **Error Resolution Rate**: % of errors resolved automatically
- **Mean Time to Resolution**: Average time from error to resolution
- **Error Recurrence Rate**: % of errors that repeat
- **Escalation Rate**: % of errors requiring manual intervention

### **Monitoring Dashboard**
```javascript
// Real-time error monitoring
const errorMetrics = {
  totalErrors: 0,
  resolvedErrors: 0,
  escalatedErrors: 0,
  averageResolutionTime: 0,
  topErrorPatterns: [],
  resolutionSuccessRate: 0
};
```

## ✅ ERROR HANDLING VALIDATION

### **Pre-Task Error Preparation**
- [ ] **Error handling protocols** loaded and active
- [ ] **Known error patterns** available for reference
- [ ] **Resolution strategies** configured for project type
- [ ] **Escalation procedures** understood and ready

### **Post-Error Learning Integration**
- [ ] **Error documented** in centralized knowledge base
- [ ] **Resolution effectiveness** recorded
- [ ] **Pattern recognition** updated
- [ ] **Prevention strategies** implemented if applicable

## 🚨 CRITICAL ERROR HANDLING RULES

### **Mandatory Actions**
- **NEVER ignore errors** hoping they resolve themselves
- **ALWAYS stop execution** on critical errors
- **ALWAYS document errors** in centralized system
- **ALWAYS attempt automatic resolution** before escalation
- **ALWAYS learn from errors** to prevent recurrence

### **Forbidden Actions**
- **NEVER apply fixes** without proper diagnosis
- **NEVER skip error logging** for any error level
- **NEVER continue execution** with unresolved critical errors
- **NEVER use temporary workarounds** for recurring errors

## 🔄 INTEGRATION WITH CENTRALIZED RULES

### **Rule Update Protocol**
- **Error patterns** automatically update centralized rules
- **Resolution strategies** enhance framework-specific rules
- **Learning outcomes** improve overall system performance
- **All updates target** `@project-core/rules/` exclusively

### **Cross-Project Learning**
- **Error patterns** shared across all GRUPO US projects
- **Resolution strategies** applicable to similar contexts
- **Performance improvements** benefit entire ecosystem
- **Knowledge accumulation** enhances system reliability

---

**🎯 GRUPO US VIBECODE SYSTEM V2.0 - COMPREHENSIVE ERROR HANDLING PROTOCOL**  
**Centralized Rule Architecture - Phase 4 Implementation**
