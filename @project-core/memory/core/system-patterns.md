# System Patterns - Enhanced Memory System Architecture and Code Standards

**Project:** GRUPO US VIBECODE SYSTEM V4.0 - Enhanced Memory Integration  
**Maintained:** 2025-01-27 onwards  
**Status:** [MEMORY BANK: ACTIVE] - Active Pattern Library

---

## Architecture Patterns

### Memory Bank MCP Pattern

**Description:** Structured memory management following Model Context Protocol standards with enhanced integration capabilities.

**Usage:** Core memory management for all AI development workflows

**Implementation:**
```
@project-core/memory/
├── core/                    # Memory Bank MCP core files
│   ├── product-context.md   # Project overview and objectives
│   ├── active-context.md    # Current state and ongoing tasks
│   ├── progress.md          # History and milestones
│   ├── decision-log.md      # Important decisions with rationale
│   └── system-patterns.md   # This file - architecture patterns
├── cache/                   # Intelligent caching layer
├── coordination/            # Task coordination with Shrimp Task Manager
├── learning/                # Self-improvement engine
└── protocols/               # Memory consultation protocols
```

**Key Components:**
- Status transparency with prefix indicators
- Mode-specific operations (architect, code, ask, debug, test)
- UMB (Update Memory Bank) command for temporary updates
- Structured templates for consistent documentation

### Mandatory Consultation Pattern

**Description:** Enforced memory consultation before any task execution to ensure consistency and optimization.

**Usage:** All task execution workflows must implement this pattern

**Implementation:**
```javascript
// Pre-execution consultation (MANDATORY)
const consultation = await memoryConsultation.mandatoryPreExecutionConsultation(taskContext);

// Apply consultation recommendations
const recommendations = consultation.recommendations;
const cachedSolutions = consultation.cacheAnalysis.solutions;

// Execute with memory guidance
const result = await executeTaskWithMemoryGuidance(taskContext, recommendations);

// Post-execution update (AUTOMATIC)
await memoryConsultation.automaticPostExecutionUpdate(result);
```

**Key Features:**
- 100% compliance enforcement
- Comprehensive consultation reporting
- Automatic post-execution updates
- Pattern recognition and application

### Tiered Caching Pattern

**Description:** Multi-strategy caching system with different TTL and priority settings for optimal performance.

**Usage:** All API requests and data retrieval operations

**Implementation:**
```javascript
// Cache configuration by data type
const cacheStrategies = {
    "documentation_queries": { ttl: 7200000, priority: "high", compression: true },
    "api_responses": { ttl: 1800000, priority: "medium", compression: false },
    "pattern_analysis": { ttl: 86400000, priority: "high", compression: true },
    "similar_solutions": { ttl: 3600000, priority: "high", compression: true }
};

// Intelligent cache retrieval
const cacheKey = cache.generateCacheKey(query, type);
let result = await cache.getCachedResponse(cacheKey, type);

if (!result) {
    result = await performAPICall(query);
    await cache.cacheResponse(cacheKey, result, type);
}
```

**Key Features:**
- Type-specific caching strategies
- TTL-based expiration management
- Priority-based cleanup
- Compression for large data
- Performance monitoring

### Self-Improvement Pattern

**Description:** Continuous learning and optimization through pattern recognition and automatic improvement.

**Usage:** All execution workflows contribute to learning and optimization

**Implementation:**
```javascript
// Pattern extraction from execution
const patterns = await learningEngine.extractPatterns(executionData);

// Optimization identification
const optimizations = await learningEngine.identifyOptimizations(executionData);

// Pattern library update
await learningEngine.updatePatternLibrary(patterns);

// Automatic improvement recommendations
const recommendations = await learningEngine.generateImprovementRecommendations();
```

**Key Features:**
- Automatic pattern recognition
- Confidence-based pattern scoring
- Optimization opportunity identification
- Continuous improvement cycles
- Error pattern learning

---

## Design Patterns

### MCP Server Integration Pattern

**Description:** Standardized integration with Model Context Protocol servers for enhanced capabilities.

**Usage:** Integration with Context7, Perplexity, Playwright, and other MCP servers

**Implementation:**
```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "mcp-server-package"],
      "env": {
        "DATA_DIR": "@project-core/memory/coordination",
        "ENABLE_MEMORY_INTEGRATION": "true",
        "MCP_PROMPT_CUSTOM": "Memory-integrated custom prompt..."
      }
    }
  }
}
```

**Key Features:**
- Standardized configuration format
- Memory integration environment variables
- Custom prompt injection for memory awareness
- Performance monitoring integration

### Task Coordination Pattern

**Description:** Intelligent task management with dependency tracking and context preservation.

**Usage:** Complex task workflows requiring coordination and memory integration

**Implementation:**
```javascript
// Task planning with memory integration
const taskPlan = await shrimpTaskManager.planTask({
    description: taskDescription,
    requirements: requirements,
    memoryConsultation: true,
    patternApplication: true
});

// Dependency-aware execution
const executionOrder = await shrimpTaskManager.resolveDependencies(taskPlan);

// Context-preserving execution
for (const task of executionOrder) {
    const context = await shrimpTaskManager.loadTaskContext(task);
    const result = await executeTaskWithContext(task, context);
    await shrimpTaskManager.updateTaskStatus(task, result);
}
```

**Key Features:**
- Automatic dependency resolution
- Context preservation across tasks
- Progress tracking and monitoring
- Automatic summarization
- Memory integration throughout workflow

### Status Transparency Pattern

**Description:** Consistent status indication for memory system operational state.

**Usage:** All AI responses and system interactions

**Implementation:**
```javascript
// Status prefix generation
function generateStatusPrefix(memoryBankState) {
    switch (memoryBankState) {
        case 'active': return '[MEMORY BANK: ACTIVE]';
        case 'updating': return '[MEMORY BANK: UPDATING]';
        case 'inactive': return '[MEMORY BANK: INACTIVE]';
        default: return '[MEMORY BANK: UNKNOWN]';
    }
}

// Response formatting
const response = `${generateStatusPrefix(memoryState)} ${actualResponse}`;
```

**Key Features:**
- Immediate operational visibility
- Standardized status indicators
- Debugging and troubleshooting support
- Compliance monitoring capability

---

## Code Patterns

### Memory-Aware Function Pattern

**Description:** Functions that automatically consult memory and apply learned patterns.

**Usage:** All development functions should follow this pattern

**Implementation:**
```javascript
async function memoryAwareFunction(params) {
    // 1. Mandatory memory consultation
    const consultation = await consultMemory(params);
    
    // 2. Apply cached solutions if available
    if (consultation.cachedSolutions.length > 0) {
        return adaptCachedSolution(consultation.cachedSolutions[0], params);
    }
    
    // 3. Apply learned patterns
    const applicablePatterns = consultation.patternMatches;
    const implementation = await implementWithPatterns(params, applicablePatterns);
    
    // 4. Automatic memory update
    await updateMemoryWithResult(implementation);
    
    return implementation;
}
```

**Key Features:**
- Mandatory memory consultation
- Cached solution prioritization
- Pattern application
- Automatic learning contribution

### Error Handling with Learning Pattern

**Description:** Error handling that contributes to learning and pattern recognition.

**Usage:** All error-prone operations should implement learning-enhanced error handling

**Implementation:**
```javascript
async function executeWithLearning(operation) {
    try {
        const result = await operation();
        
        // Log successful pattern for learning
        await learningEngine.logSuccessPattern({
            operation: operation.name,
            context: operation.context,
            result: result,
            performance: operation.performance
        });
        
        return result;
        
    } catch (error) {
        // Log error pattern for learning
        await learningEngine.logErrorPattern({
            operation: operation.name,
            error: error,
            context: operation.context,
            resolution: await findErrorResolution(error)
        });
        
        // Apply learned error resolution if available
        const knownResolution = await learningEngine.getErrorResolution(error);
        if (knownResolution) {
            return await applyErrorResolution(knownResolution, operation);
        }
        
        throw error;
    }
}
```

**Key Features:**
- Success pattern logging
- Error pattern recognition
- Automatic resolution application
- Continuous learning from errors

### Performance Monitoring Pattern

**Description:** Consistent performance monitoring and optimization across all operations.

**Usage:** All performance-critical operations should implement monitoring

**Implementation:**
```javascript
async function monitoredOperation(operation) {
    const startTime = Date.now();
    const startMemory = process.memoryUsage();
    
    try {
        const result = await operation();
        
        // Record performance metrics
        const metrics = {
            duration: Date.now() - startTime,
            memoryUsage: process.memoryUsage().heapUsed - startMemory.heapUsed,
            success: true,
            operation: operation.name
        };
        
        await performanceMonitor.recordMetrics(metrics);
        
        // Trigger optimization if needed
        if (metrics.duration > PERFORMANCE_THRESHOLD) {
            await optimizationEngine.analyzePerformance(metrics);
        }
        
        return result;
        
    } catch (error) {
        await performanceMonitor.recordError({
            operation: operation.name,
            error: error,
            duration: Date.now() - startTime
        });
        
        throw error;
    }
}
```

**Key Features:**
- Automatic performance tracking
- Memory usage monitoring
- Optimization trigger points
- Error performance analysis

---

## Integration Patterns

### MCP Sequential Thinking Integration

**Description:** Integration with Sequential Thinking MCP for complex reasoning tasks.

**Usage:** Complex analysis and multi-step reasoning workflows

**Implementation:**
```javascript
// Trigger Sequential Thinking for complex tasks
if (taskComplexity >= 7) {
    const thinkingResult = await sequentialThinking.processThought({
        thought: taskDescription,
        thoughtNumber: 1,
        totalThoughts: estimatedThoughts,
        nextThoughtNeeded: true
    });
    
    // Apply thinking results to task execution
    const enhancedTask = await enhanceTaskWithThinking(task, thinkingResult);
    return await executeEnhancedTask(enhancedTask);
}
```

### Context7 Documentation Integration

**Description:** Integration with Context7 MCP for documentation and library information.

**Usage:** Documentation queries and library resolution

**Implementation:**
```javascript
// Resolve library documentation
const libraryId = await context7.resolveLibraryId(libraryName);
const documentation = await context7.getLibraryDocs(libraryId, {
    tokens: 8000,
    topic: 'architecture memory management'
});

// Cache documentation for future use
await cache.cacheResponse(
    cache.generateCacheKey(libraryName, 'documentation_queries'),
    documentation,
    'documentation_queries'
);
```

### Perplexity Research Integration

**Description:** Integration with Perplexity search for real-time research and best practices.

**Usage:** Research tasks and best practice discovery

**Implementation:**
```javascript
// Research best practices with caching
const researchQuery = `${technology} ${taskType} best practices optimization`;
const cacheKey = cache.generateCacheKey(researchQuery, 'research_results');

let researchResults = await cache.getCachedResponse(cacheKey, 'research_results');

if (!researchResults) {
    researchResults = await perplexity.search(researchQuery);
    await cache.cacheResponse(cacheKey, researchResults, 'research_results');
}

// Apply research insights to task
const insights = await extractInsights(researchResults);
return await applyInsightsToTask(task, insights);
```

---

## Quality Assurance Patterns

### Comprehensive Validation Pattern

**Description:** Multi-level validation ensuring quality, consistency, and performance.

**Usage:** All deliverables should pass comprehensive validation

**Implementation:**
```javascript
async function comprehensiveValidation(deliverable) {
    const validationResults = {
        memoryConsultation: await validateMemoryConsultation(deliverable),
        patternCompliance: await validatePatternCompliance(deliverable),
        performanceMetrics: await validatePerformanceMetrics(deliverable),
        qualityStandards: await validateQualityStandards(deliverable),
        learningContribution: await validateLearningContribution(deliverable)
    };
    
    const overallScore = calculateValidationScore(validationResults);
    
    if (overallScore >= 80) {
        await markDeliverableComplete(deliverable, validationResults);
        return { passed: true, score: overallScore, results: validationResults };
    } else {
        return { passed: false, score: overallScore, improvements: generateImprovements(validationResults) };
    }
}
```

**Validation Criteria:**
- Memory consultation compliance (30%)
- Pattern application accuracy (25%)
- Performance optimization (20%)
- Quality standards adherence (15%)
- Learning contribution value (10%)

These system patterns ensure consistent, high-quality development workflows while maximizing the benefits of the enhanced memory system through intelligent caching, pattern recognition, and continuous improvement.
