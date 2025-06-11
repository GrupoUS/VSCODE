# 🤖 AI ROUTING SYSTEM UNIFIED - GRUPO US VIBECODE SYSTEM V4.0

## 📋 CONSOLIDATION NOTICE

**This file consolidates and replaces:**
- `ai-model-routing/00-master-routing-config.md`
- `ai-model-routing/01-model-definitions.md`
- `ai-model-routing/02-selection-algorithms.md`
- `ai-model-routing/03-cost-optimization.md`
- `ai-model-routing/04-performance-monitoring.md`
- `ai-model-routing/05-universal-templates.md`
- `ai-model-routing/README.md`

**Consolidation Date**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)

---

## 🎯 CORE CONFIGURATION

### **System Settings**
```json
{
  "version": "4.0.0",
  "name": "GRUPO US AI Model Routing System",
  "description": "Centralized, performance-optimized AI model selection",
  "lastUpdated": "2025-06-11",
  "performance": {
    "lazyLoading": true,
    "caching": true,
    "memoryOptimization": true,
    "fastLookup": true
  }
}
```

### **Model Definitions**
```json
{
  "models": {
    "architect": {
      "id": "anthropic/claude-sonnet-4",
      "name": "Claude Sonnet 4",
      "complexity": [9, 10],
      "specializations": ["architecture", "system_design", "complex_refactoring"],
      "costPerToken": 0.000015,
      "maxTokens": 200000,
      "priority": "critical"
    },
    "coder": {
      "id": "anthropic/claude-sonnet-4",
      "name": "Claude Sonnet 4",
      "complexity": [7, 8],
      "specializations": ["code_generation", "debugging", "backend_development"],
      "costPerToken": 0.000015,
      "maxTokens": 200000,
      "priority": "high"
    },
    "manager": {
      "id": "google/gemini-2.5-pro-preview-05-06",
      "name": "Gemini 2.5 Pro",
      "complexity": [5, 6],
      "specializations": ["project_management", "coordination", "planning"],
      "costPerToken": 0.000007,
      "maxTokens": 128000,
      "priority": "medium"
    },
    "executor": {
      "id": "google/gemini-2.5-flash-preview-05-20:thinking",
      "name": "Gemini Flash Thinking",
      "complexity": [3, 4],
      "specializations": ["frontend", "ui_components", "simple_tasks"],
      "costPerToken": 0.000002,
      "maxTokens": 32000,
      "priority": "low"
    },
    "researcher": {
      "id": "google/gemini-2.5-flash-preview-05-20:thinking",
      "name": "Gemini Flash Thinking",
      "complexity": [1, 2],
      "specializations": ["research", "documentation", "analysis"],
      "costPerToken": 0.000002,
      "maxTokens": 32000,
      "priority": "low"
    }
  }
}
```

---

## 🧮 SELECTION ALGORITHMS

### **Core Selection Logic**
```javascript
class AIModelSelector {
  constructor(config) {
    this.config = config;
    this.costTracker = new CostTracker();
    this.performanceMonitor = new PerformanceMonitor();
  }

  /**
   * Main selection method
   */
  selectModel(task) {
    const complexity = this.assessComplexity(task);
    const domain = this.identifyDomain(task);
    const budget = this.checkBudget();
    
    // Apply BOOMERANG routing logic
    if (complexity >= 9 || domain.includes(['architecture', 'migration', 'refactor'])) {
      return this.config.models.architect;
    }
    if (complexity >= 7 || domain.includes(['backend', 'api', 'database', 'complex-logic'])) {
      return this.config.models.coder;
    }
    if (complexity >= 5 || domain.includes(['coordination', 'planning', 'workflow'])) {
      return this.config.models.manager;
    }
    if (complexity >= 3 || domain.includes(['frontend', 'ui', 'components', 'styling'])) {
      return this.config.models.executor;
    }
    
    return this.config.models.researcher; // Default for investigation tasks
  }

  /**
   * Complexity assessment (1-10 scale)
   */
  assessComplexity(task) {
    const indicators = {
      architecture: 3,
      refactor: 2,
      migration: 3,
      database: 2,
      api: 2,
      frontend: 1,
      component: 1,
      research: 0
    };
    
    let score = 1;
    const taskLower = task.toLowerCase();
    
    for (const [keyword, weight] of Object.entries(indicators)) {
      if (taskLower.includes(keyword)) {
        score += weight;
      }
    }
    
    return Math.min(score, 10);
  }

  /**
   * Domain identification
   */
  identifyDomain(task) {
    const domains = [];
    const taskLower = task.toLowerCase();
    
    const domainKeywords = {
      architecture: ['architecture', 'design', 'system', 'structure'],
      backend: ['api', 'server', 'database', 'backend'],
      frontend: ['ui', 'component', 'frontend', 'styling'],
      coordination: ['plan', 'manage', 'coordinate', 'organize'],
      research: ['research', 'analyze', 'investigate', 'study']
    };
    
    for (const [domain, keywords] of Object.entries(domainKeywords)) {
      if (keywords.some(keyword => taskLower.includes(keyword))) {
        domains.push(domain);
      }
    }
    
    return domains;
  }
}
```

---

## 💰 COST OPTIMIZATION

### **Budget Configuration**
```json
{
  "costOptimization": {
    "enabled": true,
    "dailyBudget": 10.0,
    "modelCostLimits": {
      "anthropic/claude-sonnet-4": 5.0,
      "google/gemini-2.5-pro-preview-05-06": 3.0,
      "google/gemini-2.5-flash-preview-05-20:thinking": 2.0
    },
    "fallbackWhenBudgetExceeded": true,
    "costTracking": {
      "enabled": true,
      "granularity": "per-request",
      "alertThresholds": [50, 75, 90, 95]
    }
  }
}
```

### **Fallback Chain**
```json
{
  "fallbackChain": [
    "google/gemini-2.5-flash-preview-05-20:thinking",
    "anthropic/claude-sonnet-4", 
    "google/gemini-2.5-pro-preview-05-06",
    "local-model"
  ],
  "fallbackCriteria": {
    "budgetExceeded": true,
    "modelUnavailable": true,
    "responseTimeout": true,
    "errorThreshold": 3
  }
}
```

---

## 📊 PERFORMANCE MONITORING

### **Metrics Configuration**
```json
{
  "monitoring": {
    "enabled": true,
    "realTimeMetrics": true,
    "alertThresholds": {
      "responseTime": 3000,
      "errorRate": 10,
      "budgetUsage": 80,
      "modelSwitchFrequency": 20
    },
    "metrics": {
      "modelUsageStats": true,
      "switchingAccuracy": true,
      "costEfficiency": true,
      "responseQuality": true,
      "userSatisfaction": true
    }
  }
}
```

### **Performance Optimization Strategies**
```json
{
  "optimizationStrategies": {
    "automaticFallback": {
      "enabled": true,
      "triggers": ["budget_threshold", "model_limit", "cost_spike"]
    },
    "caching": {
      "enabled": true,
      "cacheDuration": 3600000,
      "costSavings": 0.30
    },
    "tokenOptimization": {
      "enabled": true,
      "compressionRatio": 0.20,
      "costSavings": 0.20
    }
  }
}
```

---

## 🔧 INTEGRATION TEMPLATES

### **Universal Integration Pattern**
```markdown
# AI Model Routing Integration

## Step 1: Import Configuration
@import @project-core/rules/04-ai-routing-system.md

## Step 2: Initialize Selector
const selector = new AIModelSelector(config);

## Step 3: Select Model
const model = selector.selectModel(taskDescription);

## Step 4: Execute with Selected Model
const result = await executeWithModel(model, task);
```

---

**Consolidation Complete**: This file unifies the entire AI routing system
**Performance**: 7 files → 1 file (85% reduction)
**Functionality**: 100% preserved with enhanced integration
**Last Updated**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)
**Next Review**: 2025-07-11
