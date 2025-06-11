# 🔄 Universal AI Model Routing Caller
## GRUPO US VIBECODE SYSTEM V2.0 - Universal Integration Template

## 📋 Core Configuration Import
```markdown
# Import centralized AI model routing system
@import project-core/rules/ai-model-routing/00-master-routing-config.md
@import project-core/rules/ai-model-routing/01-model-definitions.md
@import project-core/rules/ai-model-routing/02-selection-algorithms.md
@import project-core/rules/ai-model-routing/03-cost-optimization.md
@import project-core/rules/ai-model-routing/04-performance-monitoring.md
```

## 🎯 Universal Model Selection Protocol

### Automatic Model Selection Rules
You are an AI assistant with intelligent model routing capabilities. For every interaction, automatically:

1. **Assess Task Complexity** (1-10 scale)
2. **Identify Task Type** (coding, planning, general, debugging, documentation)
3. **Check Budget Status** (current usage vs. daily limits)
4. **Select Optimal Model** based on weighted criteria
5. **Apply Cost Optimization** if budget constraints exist

### Model Selection Matrix
```json
{
  "selectionRules": {
    "complexity_1_4": {
      "primary": "google/gemini-2.5-flash-preview-05-20:thinking",
      "useCases": ["general_tasks", "simple_queries", "file_operations", "documentation"],
      "reasoning": "Fast, cost-effective for simple tasks"
    },
    "complexity_3_8_coding": {
      "primary": "anthropic/claude-sonnet-4",
      "useCases": ["code_generation", "debugging", "refactoring", "technical_implementation"],
      "reasoning": "Specialized coding capabilities"
    },
    "complexity_5_10_planning": {
      "primary": "google/gemini-2.5-pro-preview-05-06",
      "useCases": ["planning", "architecture", "complex_reasoning", "strategic_thinking"],
      "reasoning": "Advanced reasoning for complex planning"
    }
  }
}
```

### Selection Criteria Weights
```json
{
  "selectionCriteria": {
    "taskComplexity": 0.4,
    "keywordMatch": 0.3,
    "contextAnalysis": 0.2,
    "costOptimization": 0.1
  }
}
```

## 💰 Budget Management

### Daily Budget Configuration
```json
{
  "budgetManagement": {
    "dailyBudget": 10.0,
    "modelLimits": {
      "google/gemini-2.5-flash-preview-05-20:thinking": 3.0,
      "anthropic/claude-sonnet-4": 5.0,
      "google/gemini-2.5-pro-preview-05-06": 2.0
    },
    "alertThresholds": [50, 75, 90, 95],
    "autoFallback": true
  }
}
```

### Cost Optimization Rules
- **Budget < 50%**: Use optimal model selection
- **Budget 50-75%**: Prefer cost-effective models
- **Budget 75-90%**: Use cheaper alternatives when possible
- **Budget > 90%**: Force fallback to cheapest options
- **Budget exhausted**: Use local model or defer tasks

## ⚡ Performance Optimization

### Caching Configuration
```json
{
  "caching": {
    "enabled": true,
    "configCache": {
      "ttl": 3600000,
      "maxSize": 100
    },
    "selectionCache": {
      "ttl": 1800000,
      "maxSize": 1000
    },
    "patternCache": {
      "ttl": 7200000,
      "maxSize": 500
    }
  }
}
```

### Lazy Loading Settings
```json
{
  "lazyLoading": {
    "enabled": true,
    "preloadCritical": true,
    "criticalModels": [
      "google/gemini-2.5-flash-preview-05-20:thinking",
      "anthropic/claude-sonnet-4"
    ]
  }
}
```

## 🔍 Task Analysis Engine

### Keyword Detection Patterns
```javascript
const taskPatterns = {
  coding: [
    "code", "debug", "function", "class", "implement", "fix",
    "programming", "component", "react", "vue", "angular",
    "javascript", "typescript", "python", "java", "refactor"
  ],
  planning: [
    "plan", "strategy", "architecture", "design", "analyze",
    "complex", "workflow", "project", "organize", "structure",
    "roadmap", "framework", "system"
  ],
  general: [
    "help", "explain", "simple", "quick", "basic",
    "file", "read", "write", "show", "get", "list"
  ],
  documentation: [
    "document", "comment", "readme", "guide", "explain",
    "describe", "outline", "summary"
  ]
};
```

### Complexity Assessment Algorithm
```javascript
function assessTaskComplexity(task) {
  let complexity = 1;
  const description = task.description.toLowerCase();
  
  // Base complexity from keywords
  if (hasKeywords(description, taskPatterns.coding)) complexity += 3;
  if (hasKeywords(description, taskPatterns.planning)) complexity += 4;
  if (hasKeywords(description, ["complex", "advanced", "sophisticated"])) complexity += 2;
  
  // Context factors
  if (task.multipleFiles) complexity += 2;
  if (task.hasDependencies) complexity += 1;
  if (task.requiresTesting) complexity += 1;
  if (task.needsResearch) complexity += 2;
  
  return Math.min(10, Math.max(1, complexity));
}
```

## 📊 Response Format

### Standard Response Template
```markdown
🧠 **Model Selection**: [Selected Model Name]
📊 **Analysis**: Complexity [X/10] | Type: [Task Type] | Budget: [X]% used
💡 **Reasoning**: [Brief explanation of why this model was selected]
💰 **Cost**: $[Estimated cost] | Remaining: $[Budget remaining]

---

[Your actual response content here]

---

📈 **Performance**: Response time [X]ms | Cache: [Hit/Miss] | Efficiency: [X]%
```

## 🔧 Extension-Specific Customization

### Override Configuration (Optional)
```json
{
  "extensionOverrides": {
    "selectionCriteria": {
      "taskComplexity": 0.5,
      "keywordMatch": 0.25,
      "contextAnalysis": 0.15,
      "costOptimization": 0.1
    },
    "budgetManagement": {
      "dailyBudget": 15.0
    },
    "performance": {
      "prioritizeSpeed": true,
      "prioritizeCost": false,
      "prioritizeQuality": true
    }
  }
}
```

### Custom Keywords (Optional)
```json
{
  "customKeywords": {
    "projectSpecific": ["custom", "domain", "specific", "keywords"],
    "technicalStack": ["nextjs", "prisma", "supabase", "tailwind"],
    "businessLogic": ["user", "payment", "subscription", "analytics"]
  }
}
```

## 🚀 Implementation Guide

### Step 1: Copy Template
```bash
# Copy this template to your extension
cp project-core/rules/ai-model-routing/templates/universal-caller.md your-extension/ai-routing.md
```

### Step 2: Customize Configuration
```markdown
# In your extension's configuration file:
@import your-extension/ai-routing.md

# Add any extension-specific overrides:
- Adjust budget limits for your use case
- Customize complexity thresholds
- Add domain-specific keywords
- Configure performance preferences
```

### Step 3: Integrate with Extension
- Follow your extension's configuration patterns
- Implement the model selection logic
- Add performance monitoring hooks
- Test with validation scripts

### Step 4: Validate Integration
```bash
# Run validation tests
node project-core/rules/ai-model-routing/validation/config-validator.js --extension=your-extension

# Test performance
node project-core/rules/ai-model-routing/validation/performance-tests.js --target=your-extension

# Integration test
node project-core/rules/ai-model-routing/validation/integration-tests.js --extension=your-extension
```

## 📋 Validation Checklist

### ✅ Configuration Validation
- [ ] Core routing configuration imported
- [ ] Model definitions loaded correctly
- [ ] Selection algorithms functioning
- [ ] Cost optimization active
- [ ] Performance monitoring enabled

### ✅ Functionality Validation
- [ ] Task complexity assessment working
- [ ] Model selection logic correct
- [ ] Budget tracking functional
- [ ] Fallback mechanisms active
- [ ] Cache performance optimized

### ✅ Integration Validation
- [ ] Compatible with extension architecture
- [ ] Performance targets met
- [ ] Error handling robust
- [ ] Monitoring data accurate
- [ ] User experience smooth

---

**This universal caller template provides a complete, performance-optimized AI model routing system that can be easily integrated into any AI extension with minimal customization.**
