# 🤖 AI Model Definitions & Specifications
## GRUPO US VIBECODE SYSTEM V2.0 - Model Catalog

## 📋 Primary Models Configuration

### 1. Google Gemini 2.5 Flash Thinking (Primary)
```json
{
  "id": "google/gemini-2.5-flash-preview-05-20:thinking",
  "name": "Gemini 2.5 Flash Thinking",
  "provider": "openrouter",
  "category": "primary",
  "capabilities": {
    "reasoning": "advanced",
    "speed": "fast",
    "cost": "low",
    "contextWindow": 32000,
    "multimodal": true
  },
  "useCases": [
    "general_tasks",
    "simple_queries", 
    "basic_analysis",
    "file_operations",
    "quick_responses",
    "routine_assistance"
  ],
  "complexityRange": [1, 4],
  "keywords": [
    "help", "explain", "simple", "quick", "basic", 
    "file", "read", "write", "list", "show", "get"
  ],
  "performance": {
    "avgResponseTime": 1200,
    "tokensPerSecond": 150,
    "reliability": 0.98
  },
  "pricing": {
    "inputCost": 0.000125,
    "outputCost": 0.000375,
    "currency": "USD",
    "per": "1K tokens"
  }
}
```

### 2. Anthropic Claude Sonnet 4 (Coding Specialist)
```json
{
  "id": "anthropic/claude-sonnet-4",
  "name": "Claude Sonnet 4",
  "provider": "openrouter",
  "category": "coding",
  "capabilities": {
    "reasoning": "superior",
    "speed": "medium",
    "cost": "medium",
    "contextWindow": 200000,
    "codeGeneration": "excellent"
  },
  "useCases": [
    "code_generation",
    "debugging",
    "programming",
    "technical_implementation",
    "refactoring",
    "code_review",
    "algorithm_design"
  ],
  "complexityRange": [3, 8],
  "keywords": [
    "code", "debug", "function", "class", "implement", "fix",
    "programming", "technical", "algorithm", "refactor", "optimize",
    "component", "react", "vue", "angular", "javascript", "typescript",
    "python", "java", "create", "build", "develop"
  ],
  "performance": {
    "avgResponseTime": 2500,
    "tokensPerSecond": 80,
    "reliability": 0.99
  },
  "pricing": {
    "inputCost": 0.003,
    "outputCost": 0.015,
    "currency": "USD",
    "per": "1K tokens"
  }
}
```

### 3. Google Gemini 2.5 Pro (Strategic Planner)
```json
{
  "id": "google/gemini-2.5-pro-preview-05-06",
  "name": "Gemini 2.5 Pro",
  "provider": "openrouter",
  "category": "strategic",
  "capabilities": {
    "reasoning": "exceptional",
    "speed": "slow",
    "cost": "high",
    "contextWindow": 2000000,
    "strategicThinking": "superior"
  },
  "useCases": [
    "planning",
    "complex_reasoning",
    "strategic_thinking",
    "architecture_design",
    "project_management",
    "system_analysis",
    "decision_making"
  ],
  "complexityRange": [5, 10],
  "keywords": [
    "plan", "strategy", "architecture", "design", "analyze",
    "complex", "workflow", "project", "organize", "structure",
    "roadmap", "framework", "system", "enterprise", "scale"
  ],
  "performance": {
    "avgResponseTime": 4000,
    "tokensPerSecond": 50,
    "reliability": 0.97
  },
  "pricing": {
    "inputCost": 0.00125,
    "outputCost": 0.005,
    "currency": "USD",
    "per": "1K tokens"
  }
}
```

## 🔄 Fallback Models

### 4. Claude 3 Sonnet (Fallback)
```json
{
  "id": "claude-3-sonnet",
  "name": "Claude 3 Sonnet",
  "provider": "anthropic",
  "category": "fallback",
  "capabilities": {
    "reasoning": "good",
    "speed": "medium",
    "cost": "medium",
    "contextWindow": 200000
  },
  "useCases": ["general_fallback", "backup_coding", "alternative_reasoning"],
  "complexityRange": [2, 7],
  "performance": {
    "avgResponseTime": 2800,
    "tokensPerSecond": 75,
    "reliability": 0.96
  }
}
```

### 5. Local Model (Emergency Fallback)
```json
{
  "id": "local-model",
  "name": "Local Model",
  "provider": "local",
  "category": "emergency",
  "capabilities": {
    "reasoning": "basic",
    "speed": "variable",
    "cost": "free",
    "contextWindow": 4000
  },
  "useCases": ["emergency_fallback", "offline_mode", "cost_saving"],
  "complexityRange": [1, 3],
  "performance": {
    "avgResponseTime": 5000,
    "tokensPerSecond": 20,
    "reliability": 0.85
  }
}
```

## 🎯 Model Selection Matrix

### Complexity-Based Selection
```json
{
  "selectionMatrix": {
    "complexity_1_2": {
      "primary": "google/gemini-2.5-flash-preview-05-20:thinking",
      "fallback": "local-model",
      "reasoning": "Simple tasks require fast, cost-effective responses"
    },
    "complexity_3_4": {
      "primary": "google/gemini-2.5-flash-preview-05-20:thinking",
      "secondary": "anthropic/claude-sonnet-4",
      "fallback": "claude-3-sonnet",
      "reasoning": "Moderate complexity benefits from thinking model"
    },
    "complexity_5_6": {
      "primary": "anthropic/claude-sonnet-4",
      "secondary": "google/gemini-2.5-pro-preview-05-06",
      "fallback": "google/gemini-2.5-flash-preview-05-20:thinking",
      "reasoning": "Technical tasks need specialized coding capabilities"
    },
    "complexity_7_8": {
      "primary": "google/gemini-2.5-pro-preview-05-06",
      "secondary": "anthropic/claude-sonnet-4",
      "fallback": "claude-3-sonnet",
      "reasoning": "Complex planning requires strategic thinking"
    },
    "complexity_9_10": {
      "primary": "google/gemini-2.5-pro-preview-05-06",
      "fallback": "anthropic/claude-sonnet-4",
      "reasoning": "Highest complexity demands premium capabilities"
    }
  }
}
```

### Use Case Mapping
```json
{
  "useCaseMapping": {
    "file_operations": "google/gemini-2.5-flash-preview-05-20:thinking",
    "code_generation": "anthropic/claude-sonnet-4",
    "debugging": "anthropic/claude-sonnet-4",
    "planning": "google/gemini-2.5-pro-preview-05-06",
    "architecture": "google/gemini-2.5-pro-preview-05-06",
    "simple_queries": "google/gemini-2.5-flash-preview-05-20:thinking",
    "complex_analysis": "google/gemini-2.5-pro-preview-05-06",
    "refactoring": "anthropic/claude-sonnet-4",
    "documentation": "google/gemini-2.5-flash-preview-05-20:thinking",
    "testing": "anthropic/claude-sonnet-4"
  }
}
```

## 📊 Performance Characteristics

### Response Time Targets
```json
{
  "responseTimeTargets": {
    "google/gemini-2.5-flash-preview-05-20:thinking": 1500,
    "anthropic/claude-sonnet-4": 3000,
    "google/gemini-2.5-pro-preview-05-06": 5000,
    "claude-3-sonnet": 3500,
    "local-model": 8000
  }
}
```

### Quality Metrics
```json
{
  "qualityMetrics": {
    "accuracy": {
      "google/gemini-2.5-flash-preview-05-20:thinking": 0.92,
      "anthropic/claude-sonnet-4": 0.96,
      "google/gemini-2.5-pro-preview-05-06": 0.98
    },
    "consistency": {
      "google/gemini-2.5-flash-preview-05-20:thinking": 0.89,
      "anthropic/claude-sonnet-4": 0.94,
      "google/gemini-2.5-pro-preview-05-06": 0.96
    },
    "relevance": {
      "google/gemini-2.5-flash-preview-05-20:thinking": 0.91,
      "anthropic/claude-sonnet-4": 0.95,
      "google/gemini-2.5-pro-preview-05-06": 0.97
    }
  }
}
```

---

**These model definitions provide the foundation for intelligent, performance-optimized AI model selection across all GRUPO US projects.**
