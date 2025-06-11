/**
 * Model Router - Intelligent Model Selection System
 * GRUPO US VIBECODE SYSTEM V2.0 - AUGMENT OPTIMIZATION
 */

class ModelRouter {
  constructor(options = {}) {
    this.dailyBudget = options.dailyBudget || 10.0; // $10 daily budget
    this.currentSpent = 0;
    this.requestHistory = [];
    
    // Model configurations with pricing and capabilities
    this.models = {
      'claude-3-haiku': {
        cost: 0.00025,        // per 1K tokens
        speed: 'fast',        // fast, medium, slow
        capability: 'basic',  // basic, intermediate, advanced
        maxTokens: 4000,
        strengths: ['speed', 'simple_tasks', 'cost_efficiency'],
        weaknesses: ['complex_analysis', 'deep_reasoning']
      },
      'claude-3-sonnet': {
        cost: 0.003,
        speed: 'medium',
        capability: 'intermediate',
        maxTokens: 8000,
        strengths: ['balanced_performance', 'code_generation', 'analysis'],
        weaknesses: ['very_complex_tasks', 'specialized_domains']
      },
      'gpt-4': {
        cost: 0.03,
        speed: 'slow',
        capability: 'advanced',
        maxTokens: 8000,
        strengths: ['complex_reasoning', 'specialized_knowledge', 'accuracy'],
        weaknesses: ['cost', 'speed']
      },
      'gpt-4-turbo': {
        cost: 0.01,
        speed: 'medium',
        capability: 'advanced',
        maxTokens: 128000,
        strengths: ['large_context', 'complex_tasks', 'speed'],
        weaknesses: ['cost']
      },
      'local-model': {
        cost: 0,
        speed: 'variable',
        capability: 'basic',
        maxTokens: 2000,
        strengths: ['no_cost', 'privacy', 'availability'],
        weaknesses: ['limited_capability', 'setup_required']
      }
    };

    // Task complexity mapping
    this.complexityFactors = {
      operation_type: {
        'file_read': 1,
        'simple_edit': 2,
        'code_generation': 5,
        'debugging': 6,
        'architecture_design': 8,
        'complex_analysis': 9,
        'research': 7
      },
      context_size: {
        'small': 1,    // < 1000 tokens
        'medium': 2,   // 1000-5000 tokens
        'large': 4,    // 5000-15000 tokens
        'xlarge': 6    // > 15000 tokens
      },
      urgency: {
        'low': 1,
        'medium': 1.5,
        'high': 2,
        'critical': 3
      }
    };
  }

  /**
   * Select optimal model for a task
   */
  selectModel(task) {
    const complexity = this.assessComplexity(task);
    const budget = this.getRemainingBudget();
    const urgency = task.urgency || 'medium';
    const contextSize = this.getContextSize(task);
    
    console.log(`🧠 Model selection: complexity=${complexity}, budget=$${budget.toFixed(2)}, urgency=${urgency}`);
    
    // Get candidate models based on complexity
    const candidates = this.getCandidateModels(complexity, contextSize);
    
    // Score each candidate
    const scoredCandidates = candidates.map(modelName => ({
      model: modelName,
      score: this.scoreModel(modelName, task, complexity, budget, urgency)
    }));
    
    // Sort by score (highest first)
    scoredCandidates.sort((a, b) => b.score - a.score);
    
    const selectedModel = scoredCandidates[0].model;
    
    console.log(`✅ Selected model: ${selectedModel} (score: ${scoredCandidates[0].score.toFixed(2)})`);
    
    // Log selection reasoning
    this.logSelection(selectedModel, task, complexity, scoredCandidates);
    
    return selectedModel;
  }

  /**
   * Assess task complexity
   */
  assessComplexity(task) {
    let complexity = 1;
    
    // Base complexity from operation type
    const operationType = task.operation || 'simple_edit';
    complexity *= this.complexityFactors.operation_type[operationType] || 3;
    
    // Context size factor
    const contextSize = this.getContextSize(task);
    complexity *= this.complexityFactors.context_size[contextSize] || 2;
    
    // Additional factors
    if (task.requires_research) complexity *= 1.5;
    if (task.involves_multiple_files) complexity *= 1.3;
    if (task.needs_testing) complexity *= 1.2;
    if (task.has_dependencies) complexity *= 1.4;
    
    // Normalize to 1-10 scale
    return Math.min(10, Math.max(1, Math.round(complexity)));
  }

  /**
   * Get context size category
   */
  getContextSize(task) {
    const tokens = task.context_tokens || 2000;
    
    if (tokens < 1000) return 'small';
    if (tokens < 5000) return 'medium';
    if (tokens < 15000) return 'large';
    return 'xlarge';
  }

  /**
   * Get candidate models based on complexity and context
   */
  getCandidateModels(complexity, contextSize) {
    const candidates = [];
    
    // Always include local model as fallback
    candidates.push('local-model');
    
    // Add models based on complexity
    if (complexity <= 3) {
      candidates.push('claude-3-haiku');
    }
    
    if (complexity <= 7) {
      candidates.push('claude-3-sonnet');
    }
    
    if (complexity >= 5) {
      candidates.push('gpt-4-turbo');
    }
    
    if (complexity >= 8) {
      candidates.push('gpt-4');
    }
    
    // Filter by context size requirements
    return candidates.filter(modelName => {
      const model = this.models[modelName];
      const requiredTokens = this.getRequiredTokens(contextSize);
      return model.maxTokens >= requiredTokens;
    });
  }

  /**
   * Get required tokens for context size
   */
  getRequiredTokens(contextSize) {
    const requirements = {
      'small': 2000,
      'medium': 4000,
      'large': 8000,
      'xlarge': 16000
    };
    return requirements[contextSize] || 4000;
  }

  /**
   * Score a model for the given task
   */
  scoreModel(modelName, task, complexity, budget, urgency) {
    const model = this.models[modelName];
    let score = 0;
    
    // Capability score (0-40 points)
    const capabilityMatch = this.getCapabilityMatch(model.capability, complexity);
    score += capabilityMatch * 40;
    
    // Cost efficiency score (0-30 points)
    const costEfficiency = this.getCostEfficiency(model, budget, task);
    score += costEfficiency * 30;
    
    // Speed score (0-20 points)
    const speedScore = this.getSpeedScore(model.speed, urgency);
    score += speedScore * 20;
    
    // Availability score (0-10 points)
    const availabilityScore = this.getAvailabilityScore(modelName, budget);
    score += availabilityScore * 10;
    
    return score;
  }

  /**
   * Get capability match score (0-1)
   */
  getCapabilityMatch(modelCapability, complexity) {
    const capabilityLevels = {
      'basic': [1, 2, 3],
      'intermediate': [3, 4, 5, 6, 7],
      'advanced': [6, 7, 8, 9, 10]
    };
    
    const supportedComplexities = capabilityLevels[modelCapability] || [];
    
    if (supportedComplexities.includes(complexity)) {
      return 1.0;
    } else if (modelCapability === 'advanced' && complexity > 7) {
      return 0.9;
    } else if (modelCapability === 'basic' && complexity <= 4) {
      return 0.8;
    } else {
      return Math.max(0, 1 - Math.abs(complexity - 5) * 0.2);
    }
  }

  /**
   * Get cost efficiency score (0-1)
   */
  getCostEfficiency(model, budget, task) {
    const estimatedCost = this.estimateTaskCost(model, task);
    
    if (model.cost === 0) return 1.0; // Local model
    if (estimatedCost > budget) return 0; // Can't afford
    
    // Higher score for lower cost relative to budget
    return Math.max(0, 1 - (estimatedCost / budget));
  }

  /**
   * Get speed score (0-1)
   */
  getSpeedScore(modelSpeed, urgency) {
    const speedValues = {
      'fast': 1.0,
      'medium': 0.7,
      'slow': 0.4,
      'variable': 0.5
    };
    
    const urgencyMultipliers = {
      'low': 0.5,
      'medium': 1.0,
      'high': 1.5,
      'critical': 2.0
    };
    
    const baseScore = speedValues[modelSpeed] || 0.5;
    const urgencyMultiplier = urgencyMultipliers[urgency] || 1.0;
    
    return Math.min(1.0, baseScore * urgencyMultiplier);
  }

  /**
   * Get availability score (0-1)
   */
  getAvailabilityScore(modelName, budget) {
    if (modelName === 'local-model') return 1.0;
    
    const model = this.models[modelName];
    const estimatedCost = model.cost * 1000; // Estimate for 1K tokens
    
    if (estimatedCost > budget) return 0;
    return 1.0;
  }

  /**
   * Estimate task cost
   */
  estimateTaskCost(model, task) {
    const estimatedTokens = task.estimated_tokens || 2000;
    return model.cost * (estimatedTokens / 1000);
  }

  /**
   * Get remaining budget
   */
  getRemainingBudget() {
    return Math.max(0, this.dailyBudget - this.currentSpent);
  }

  /**
   * Log model selection reasoning
   */
  logSelection(selectedModel, task, complexity, candidates) {
    console.log(`📊 Model Selection Analysis:`);
    console.log(`   Task: ${task.operation || 'unknown'} (complexity: ${complexity})`);
    console.log(`   Budget remaining: $${this.getRemainingBudget().toFixed(2)}`);
    console.log(`   Candidates evaluated: ${candidates.length}`);
    
    candidates.slice(0, 3).forEach((candidate, index) => {
      const icon = index === 0 ? '🥇' : index === 1 ? '🥈' : '🥉';
      console.log(`   ${icon} ${candidate.model}: ${candidate.score.toFixed(2)} points`);
    });
  }

  /**
   * Record model usage and cost
   */
  recordUsage(modelName, tokens, actualCost) {
    this.currentSpent += actualCost;
    
    this.requestHistory.push({
      timestamp: Date.now(),
      model: modelName,
      tokens,
      cost: actualCost
    });
    
    // Keep only last 100 requests
    if (this.requestHistory.length > 100) {
      this.requestHistory = this.requestHistory.slice(-100);
    }
    
    console.log(`💰 Usage recorded: ${modelName}, ${tokens} tokens, $${actualCost.toFixed(4)}`);
  }

  /**
   * Get usage statistics
   */
  getUsageStats() {
    const modelUsage = {};
    let totalCost = 0;
    let totalTokens = 0;
    
    this.requestHistory.forEach(request => {
      if (!modelUsage[request.model]) {
        modelUsage[request.model] = { requests: 0, tokens: 0, cost: 0 };
      }
      
      modelUsage[request.model].requests++;
      modelUsage[request.model].tokens += request.tokens;
      modelUsage[request.model].cost += request.cost;
      
      totalCost += request.cost;
      totalTokens += request.tokens;
    });
    
    return {
      totalRequests: this.requestHistory.length,
      totalCost,
      totalTokens,
      currentSpent: this.currentSpent,
      remainingBudget: this.getRemainingBudget(),
      budgetUsage: (this.currentSpent / this.dailyBudget * 100).toFixed(1),
      modelUsage,
      averageCostPerRequest: totalCost / Math.max(1, this.requestHistory.length),
      averageTokensPerRequest: totalTokens / Math.max(1, this.requestHistory.length)
    };
  }

  /**
   * Reset daily usage (call at start of new day)
   */
  resetDailyUsage() {
    this.currentSpent = 0;
    this.requestHistory = [];
    console.log('🔄 Daily usage reset');
  }

  /**
   * Get model recommendations for optimization
   */
  getOptimizationRecommendations() {
    const stats = this.getUsageStats();
    const recommendations = [];
    
    if (stats.budgetUsage > 80) {
      recommendations.push('Consider using cheaper models for simple tasks');
    }
    
    if (stats.averageCostPerRequest > 0.01) {
      recommendations.push('Average cost per request is high - review model selection');
    }
    
    // Analyze model usage patterns
    const mostUsedModel = Object.keys(stats.modelUsage).reduce((a, b) => 
      stats.modelUsage[a].requests > stats.modelUsage[b].requests ? a : b
    );
    
    if (mostUsedModel === 'gpt-4' && stats.modelUsage[mostUsedModel].requests > 10) {
      recommendations.push('High usage of expensive model - consider alternatives');
    }
    
    return recommendations;
  }
}

module.exports = ModelRouter;
