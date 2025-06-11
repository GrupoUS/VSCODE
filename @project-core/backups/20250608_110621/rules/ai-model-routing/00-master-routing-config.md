# 🎯 Master AI Model Routing Configuration
## GRUPO US VIBECODE SYSTEM V2.0 - Centralized Intelligence

## 📋 Core Configuration

### System Settings
```json
{
  "version": "2.0.0",
  "name": "GRUPO US AI Model Routing System",
  "description": "Centralized, performance-optimized AI model selection",
  "lastUpdated": "2025-06-08",
  "performance": {
    "lazyLoading": true,
    "caching": true,
    "memoryOptimization": true,
    "fastLookup": true
  }
}
```

### OpenRouter Integration
```json
{
  "openRouter": {
    "enabled": true,
    "apiKey": "${OPENROUTER_API_KEY}",
    "baseUrl": "https://openrouter.ai/api/v1",
    "intelligentRouting": true,
    "costOptimization": true,
    "fallbackEnabled": true,
    "usageTracking": true,
    "maxRetries": 3,
    "timeout": 30000,
    "rateLimiting": {
      "enabled": true,
      "requestsPerMinute": 60,
      "burstLimit": 10
    }
  }
}
```

## 🧠 Intelligent Model Selection

### Selection Criteria Weights
```json
{
  "selectionCriteria": {
    "taskComplexity": 0.4,
    "keywordMatch": 0.3,
    "contextAnalysis": 0.2,
    "costOptimization": 0.1
  },
  "adaptiveWeights": {
    "enabled": true,
    "learningRate": 0.1,
    "minSamples": 10
  }
}
```

### Task Analysis Configuration
```json
{
  "taskAnalysis": {
    "enabled": true,
    "realTimeAnalysis": true,
    "contextWindow": 5,
    "complexityFactors": {
      "codeKeywords": ["function", "class", "import", "export", "async", "await"],
      "planningKeywords": ["plan", "strategy", "architecture", "design", "workflow"],
      "technicalKeywords": ["debug", "fix", "optimize", "refactor", "implement"],
      "complexityIndicators": ["complex", "advanced", "sophisticated", "comprehensive"]
    },
    "learningEnabled": true,
    "userFeedbackIntegration": true,
    "adaptiveThresholds": true
  }
}
```

## 💰 Cost Management

### Budget Configuration
```json
{
  "costOptimization": {
    "enabled": true,
    "dailyBudget": 10.0,
    "modelCostLimits": {
      "google/gemini-2.5-flash-preview-05-20:thinking": 3.0,
      "anthropic/claude-sonnet-4": 5.0,
      "google/gemini-2.5-pro-preview-05-06": 2.0
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

### Fallback Chain
```json
{
  "fallbackChain": [
    "google/gemini-2.5-flash-preview-05-20:thinking",
    "anthropic/claude-sonnet-4", 
    "google/gemini-2.5-pro-preview-05-06",
    "claude-3-sonnet",
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

## ⚡ Performance Optimization

### Caching Strategy
```json
{
  "caching": {
    "enabled": true,
    "configCache": {
      "ttl": 3600000,
      "maxSize": 100,
      "strategy": "LRU"
    },
    "selectionCache": {
      "ttl": 1800000,
      "maxSize": 1000,
      "strategy": "LFU"
    },
    "modelCache": {
      "ttl": 7200000,
      "maxSize": 50,
      "strategy": "FIFO"
    }
  }
}
```

### Lazy Loading Configuration
```json
{
  "lazyLoading": {
    "enabled": true,
    "loadOnDemand": true,
    "preloadCritical": true,
    "criticalModels": [
      "google/gemini-2.5-flash-preview-05-20:thinking",
      "anthropic/claude-sonnet-4"
    ],
    "loadingStrategy": "progressive",
    "maxConcurrentLoads": 3
  }
}
```

## 🔄 Agent-Specific Configurations

### Agent Model Mapping
```json
{
  "agentModelMapping": {
    "augment-agent": {
      "preferredModel": "google/gemini-2.5-flash-preview-05-20:thinking",
      "fallbackModel": "anthropic/claude-sonnet-4",
      "complexityThreshold": 5,
      "specializations": ["general_tasks", "file_operations", "basic_analysis"]
    },
    "taskmaster": {
      "preferredModel": "google/gemini-2.5-pro-preview-05-06",
      "fallbackModel": "anthropic/claude-sonnet-4",
      "complexityThreshold": 7,
      "autoActivateComplexity": 7,
      "specializations": ["planning", "complex_reasoning", "project_management"]
    },
    "coding-agent": {
      "preferredModel": "anthropic/claude-sonnet-4",
      "fallbackModel": "google/gemini-2.5-flash-preview-05-20:thinking",
      "complexityThreshold": 4,
      "specializations": ["code_generation", "debugging", "refactoring"]
    }
  }
}
```

## 📊 Monitoring & Analytics

### Performance Metrics
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

## 🔧 Integration Settings

### Universal Portability
```json
{
  "portability": {
    "enabled": true,
    "templateGeneration": true,
    "crossPlatformSupport": true,
    "standardizedAPIs": true,
    "configurationExport": true,
    "supportedExtensions": [
      "cline",
      "github-copilot", 
      "cursor",
      "augment-agent",
      "roo-code"
    ]
  }
}
```

### Validation Rules
```json
{
  "validation": {
    "enabled": true,
    "strictMode": true,
    "configIntegrity": true,
    "modelAvailability": true,
    "budgetValidation": true,
    "performanceThresholds": true,
    "automaticTesting": true
  }
}
```

---

**This configuration serves as the single source of truth for AI model routing across all GRUPO US projects and extensions.**
