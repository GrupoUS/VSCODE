# 🔄 Universal Templates & Portability Framework
## GRUPO US VIBECODE SYSTEM V2.0 - Cross-Platform Integration

## 📋 Universal Template Architecture

### Template Structure Overview
```
templates/
├── universal-caller.md              # Generic integration template
├── cline-integration.md             # Cline-specific implementation
├── copilot-integration.md           # GitHub Copilot integration
├── cursor-integration.md            # Cursor-specific implementation
├── augment-integration.md           # Augment Agent integration
└── extension-template.md            # Template for new extensions
```

### Core Template Components
```json
{
  "templateComponents": {
    "configuration": {
      "required": true,
      "description": "Core AI model routing configuration",
      "customizable": true
    },
    "selectionLogic": {
      "required": true,
      "description": "Model selection algorithms",
      "customizable": false
    },
    "costManagement": {
      "required": true,
      "description": "Budget and cost optimization",
      "customizable": true
    },
    "performanceMonitoring": {
      "required": false,
      "description": "Performance tracking and analytics",
      "customizable": true
    },
    "caching": {
      "required": false,
      "description": "Performance optimization caching",
      "customizable": true
    }
  }
}
```

## 🎯 Universal Caller Template

### Generic Integration Pattern
```markdown
# AI Model Routing - Universal Caller Template
# GRUPO US VIBECODE SYSTEM V2.0

## Configuration Import
@import project-core/rules/ai-model-routing/00-master-routing-config.md
@import project-core/rules/ai-model-routing/01-model-definitions.md
@import project-core/rules/ai-model-routing/02-selection-algorithms.md

## Extension-Specific Customizations
# Override these sections for your specific extension

### Model Selection Criteria (Customizable)
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

### Budget Configuration (Customizable)
```json
{
  "budgetManagement": {
    "dailyBudget": 10.0,
    "alertThresholds": [50, 75, 90, 95]
  }
}
```

### Performance Settings (Optional)
```json
{
  "performance": {
    "caching": true,
    "monitoring": true,
    "optimization": true
  }
}
```

## Implementation Guidelines

### 1. Copy Template
```bash
cp project-core/rules/ai-model-routing/templates/universal-caller.md your-extension/ai-routing.md
```

### 2. Customize Configuration
- Adjust model selection criteria weights
- Set appropriate budget limits
- Configure performance monitoring

### 3. Integrate with Extension
- Follow extension-specific integration patterns
- Implement required interfaces
- Test with validation scripts

### 4. Validate Integration
```bash
node project-core/rules/ai-model-routing/validation/integration-tests.js
```
```

## 🛠️ Extension-Specific Templates

### Cline Integration Template
```markdown
# AI Model Routing for Cline
# GRUPO US VIBECODE SYSTEM V2.0 - Cline Integration

## Core Configuration
@import project-core/rules/ai-model-routing/00-master-routing-config.md

## Cline-Specific Settings
```json
{
  "clineIntegration": {
    "enabled": true,
    "autoModelSwitching": true,
    "contextAware": true,
    "taskComplexityDetection": true,
    "budgetTracking": true
  }
}
```

## Model Selection Rules for Cline

### File Operations
- **Reading files**: google/gemini-2.5-flash-preview-05-20:thinking
- **Writing files**: google/gemini-2.5-flash-preview-05-20:thinking
- **Complex file analysis**: anthropic/claude-sonnet-4

### Code Generation
- **Simple functions**: google/gemini-2.5-flash-preview-05-20:thinking
- **Complex components**: anthropic/claude-sonnet-4
- **Architecture design**: google/gemini-2.5-pro-preview-05-06

### Project Management
- **Task planning**: google/gemini-2.5-pro-preview-05-06
- **Workflow design**: google/gemini-2.5-pro-preview-05-06
- **Simple organization**: google/gemini-2.5-flash-preview-05-20:thinking

## Implementation in .clinerules
```markdown
# Add to your .clinerules file:
@import project-core/rules/ai-model-routing/templates/cline-integration.md

# Project-specific overrides (optional):
- Adjust budget limits for project scope
- Customize complexity thresholds
- Set project-specific model preferences
```
```

### GitHub Copilot Integration Template
```markdown
# AI Model Routing for GitHub Copilot
# GRUPO US VIBECODE SYSTEM V2.0 - Copilot Integration

## Core Configuration
@import project-core/rules/ai-model-routing/00-master-routing-config.md

## Copilot Chat Integration
You are an AI assistant with intelligent model routing capabilities. Follow these guidelines:

### Model Selection Protocol
1. **Assess task complexity** (1-10 scale)
2. **Identify task type** (coding, planning, general)
3. **Check budget constraints**
4. **Select optimal model** based on criteria

### Selection Rules
- **Complexity 1-4**: Use google/gemini-2.5-flash-preview-05-20:thinking
- **Complexity 5-8 + Coding**: Use anthropic/claude-sonnet-4
- **Complexity 7-10 + Planning**: Use google/gemini-2.5-pro-preview-05-06

### Budget Management
- Daily budget: $10.00
- Alert at 75% usage
- Auto-fallback when budget exceeded

### Implementation
```json
{
  "copilotIntegration": {
    "modelRouting": true,
    "costTracking": true,
    "performanceMonitoring": true,
    "intelligentFallback": true
  }
}
```

## Usage in Copilot Chat
```
@workspace /explain How do I implement intelligent model routing?

# Copilot will automatically:
1. Assess the complexity of your question
2. Select the appropriate model
3. Track costs and performance
4. Provide optimized responses
```
```

## 🔧 Customization Framework

### Configuration Override System
```javascript
/**
 * Universal configuration override system
 */
class ConfigurationManager {
  constructor(baseConfig, overrides = {}) {
    this.baseConfig = baseConfig;
    this.overrides = overrides;
    this.mergedConfig = this.mergeConfigurations();
  }

  /**
   * Deep merge configurations with override priority
   */
  mergeConfigurations() {
    return {
      ...this.baseConfig,
      ...this.overrides,
      selectionCriteria: {
        ...this.baseConfig.selectionCriteria,
        ...this.overrides.selectionCriteria
      },
      budgetManagement: {
        ...this.baseConfig.budgetManagement,
        ...this.overrides.budgetManagement
      },
      performance: {
        ...this.baseConfig.performance,
        ...this.overrides.performance
      }
    };
  }

  /**
   * Get configuration for specific extension
   */
  getExtensionConfig(extensionName) {
    const extensionOverrides = this.overrides[extensionName] || {};
    return this.mergeConfigurations(this.baseConfig, extensionOverrides);
  }
}
```

### Template Generation System
```javascript
/**
 * Automatic template generation for new extensions
 */
class TemplateGenerator {
  constructor(baseTemplates) {
    this.baseTemplates = baseTemplates;
  }

  /**
   * Generate extension-specific template
   */
  generateTemplate(extensionName, customizations = {}) {
    const baseTemplate = this.baseTemplates.universal;
    
    return {
      name: `${extensionName}-integration.md`,
      content: this.buildTemplateContent(extensionName, customizations),
      configuration: this.buildConfiguration(extensionName, customizations),
      validation: this.buildValidationRules(extensionName)
    };
  }

  buildTemplateContent(extensionName, customizations) {
    return `
# AI Model Routing for ${extensionName}
# GRUPO US VIBECODE SYSTEM V2.0 - ${extensionName} Integration

## Core Configuration
@import project-core/rules/ai-model-routing/00-master-routing-config.md

## ${extensionName}-Specific Settings
${JSON.stringify(customizations, null, 2)}

## Implementation Guidelines
${this.generateImplementationGuide(extensionName)}

## Validation
${this.generateValidationSteps(extensionName)}
    `;
  }
}
```

## 📊 Portability Metrics

### Cross-Platform Compatibility
```json
{
  "portabilityMetrics": {
    "supportedExtensions": [
      "cline",
      "github-copilot",
      "cursor", 
      "augment-agent",
      "roo-code",
      "claude-dev"
    ],
    "compatibilityMatrix": {
      "cline": {
        "configurationSupport": "full",
        "performanceOptimization": "full",
        "costTracking": "full",
        "realTimeMonitoring": "partial"
      },
      "github-copilot": {
        "configurationSupport": "full",
        "performanceOptimization": "partial",
        "costTracking": "full",
        "realTimeMonitoring": "limited"
      },
      "cursor": {
        "configurationSupport": "full",
        "performanceOptimization": "full",
        "costTracking": "full",
        "realTimeMonitoring": "full"
      }
    }
  }
}
```

### Integration Complexity
```json
{
  "integrationComplexity": {
    "simple": {
      "timeToImplement": "< 30 minutes",
      "requiredChanges": "configuration only",
      "extensions": ["cline", "cursor"]
    },
    "moderate": {
      "timeToImplement": "1-2 hours",
      "requiredChanges": "configuration + custom logic",
      "extensions": ["github-copilot", "augment-agent"]
    },
    "complex": {
      "timeToImplement": "4-8 hours",
      "requiredChanges": "full integration development",
      "extensions": ["custom-extensions"]
    }
  }
}
```

---

**These universal templates enable rapid deployment of intelligent AI model routing across any AI extension with minimal customization effort.**
