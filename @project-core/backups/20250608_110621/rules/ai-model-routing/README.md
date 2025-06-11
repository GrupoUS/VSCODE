# 🧠 AI Model Routing System - GRUPO US VIBECODE SYSTEM V2.0

## 📋 Overview

This directory contains the centralized AI model routing system for GRUPO US VIBECODE SYSTEM V2.0. It provides intelligent, performance-optimized model selection with universal portability across AI extensions.

## 🏗️ Architecture

### Core Components

```
ai-model-routing/
├── README.md                        # This documentation
├── 00-master-routing-config.md      # Unified configuration system
├── 01-model-definitions.md          # Model specifications & capabilities
├── 02-selection-algorithms.md       # Intelligence logic & algorithms
├── 03-cost-optimization.md          # Budget management & optimization
├── 04-performance-monitoring.md     # Metrics, analytics & monitoring
├── 05-universal-templates.md        # Portability templates
├── cache/                           # Performance cache directory
│   ├── model-cache.json            # Cached model configurations
│   └── selection-cache.json        # Cached selection patterns
├── templates/                       # Universal integration templates
│   ├── cline-integration.md        # Cline-specific implementation
│   ├── copilot-integration.md      # GitHub Copilot integration
│   ├── cursor-integration.md       # Cursor-specific implementation
│   └── universal-caller.md         # Generic caller template
└── validation/                     # Testing & validation scripts
    ├── config-validator.js         # Configuration integrity tests
    ├── performance-tests.js        # Performance benchmarks
    └── integration-tests.js        # Integration validation
```

## 🎯 Key Features

### 1. **Performance Optimization**
- **Lazy Loading**: Configurations loaded only when needed
- **Intelligent Caching**: Parsed rules cached for fast access
- **Memory Efficiency**: Optimized data structures
- **Fast Lookups**: O(1) model selection algorithms

### 2. **Universal Portability**
- **Modular Design**: Easy replication across extensions
- **Template System**: Pre-built integration patterns
- **Standardized APIs**: Consistent interfaces
- **Documentation**: Clear integration guides

### 3. **Intelligent Routing**
- **Context Analysis**: Real-time task complexity assessment
- **Cost Optimization**: Budget-aware model selection
- **Fallback Chains**: Robust error handling
- **Learning System**: Adaptive improvement

## 🚀 Quick Start

### For Extension Developers

1. **Copy Template Structure**:
   ```bash
   cp -r project-core/rules/ai-model-routing/templates/universal-caller.md your-extension/
   ```

2. **Customize Configuration**:
   - Modify model definitions for your use case
   - Adjust selection criteria weights
   - Configure cost limits and budgets

3. **Integrate with Extension**:
   - Follow template-specific integration guide
   - Implement performance monitoring
   - Test with validation scripts

### For GRUPO US Projects

1. **Reference Centralized Rules**:
   ```markdown
   # In your .clinerules or configuration
   @import project-core/rules/ai-model-routing/00-master-routing-config.md
   ```

2. **Use Caller Rules**:
   - Implement lightweight caller rules
   - Reference centralized system
   - Maintain project-specific overrides

## 📊 Performance Metrics

### Target Performance
- **Configuration Load**: < 50ms
- **Model Selection**: < 10ms
- **Memory Usage**: < 5MB
- **Cache Hit Rate**: > 90%

### Monitoring
- Real-time performance tracking
- Automated alerts for degradation
- Usage analytics and optimization
- Cost tracking and budgeting

## 🔧 Configuration

### Model Selection Criteria
```json
{
  "taskComplexity": 0.4,    // 40% weight
  "keywordMatch": 0.3,      // 30% weight
  "contextAnalysis": 0.2,   // 20% weight
  "costOptimization": 0.1   // 10% weight
}
```

### Supported Models
- **Primary**: `google/gemini-2.5-flash-preview-05-20:thinking`
- **Coding**: `anthropic/claude-sonnet-4`
- **Strategic**: `google/gemini-2.5-pro-preview-05-06`

## 🛠️ Integration Examples

### Cline Integration
```markdown
# .clinerules/ai-routing-caller.md
@import project-core/rules/ai-model-routing/templates/cline-integration.md
```

### GitHub Copilot Integration
```markdown
# copilot-prompts/ai-routing.md
@import project-core/rules/ai-model-routing/templates/copilot-integration.md
```

## 📚 Documentation

- **[Master Configuration](00-master-routing-config.md)**: Core system setup
- **[Model Definitions](01-model-definitions.md)**: Available models & capabilities
- **[Selection Algorithms](02-selection-algorithms.md)**: Intelligence logic
- **[Cost Optimization](03-cost-optimization.md)**: Budget management
- **[Performance Monitoring](04-performance-monitoring.md)**: Metrics & analytics
- **[Universal Templates](05-universal-templates.md)**: Portability framework

## 🔄 Maintenance

### Regular Tasks
- Monitor performance metrics
- Update model definitions
- Optimize selection algorithms
- Review cost efficiency

### Updates
- Follow semantic versioning
- Maintain backward compatibility
- Document breaking changes
- Test across all integrations

---

**GRUPO US VIBECODE SYSTEM V2.0** - Intelligent AI Model Routing with Universal Portability! 🚀
