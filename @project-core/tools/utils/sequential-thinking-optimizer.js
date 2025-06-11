/**
 * Sequential Thinking AUGMENT Optimizer Integration
 * GRUPO US VIBECODE SYSTEM V2.0 - Automatic Performance Optimization
 */

const AugmentOptimizationSystem = require('../scripts/init-optimization');
const APIMonitor = require('./api-monitor');
const ContextManager = require('./context-manager');
const ModelRouter = require('./model-router');

class SequentialThinkingOptimizer {
  constructor() {
    this.optimizationSystem = null;
    this.isOptimizationActive = false;
    this.complexityThreshold = 7;
    this.thoughtsThreshold = 15;
    this.performanceMetrics = {
      tasksOptimized: 0,
      averageComplexity: 0,
      optimizationSuccessRate: 0,
      performanceGains: []
    };
    
    console.log('🧠 Sequential Thinking Optimizer initialized');
  }

  /**
   * Assess task complexity based on multiple factors
   */
  assessTaskComplexity(taskData) {
    let complexity = 1;
    const factors = {
      description: this.analyzeDescriptionComplexity(taskData.description || ''),
      estimatedThoughts: taskData.totalThoughts || 5,
      keywords: this.detectComplexityKeywords(taskData.description || ''),
      dependencies: this.analyzeDependencies(taskData),
      scope: this.analyzeScope(taskData)
    };

    // Base complexity from description analysis
    complexity += factors.description;

    // Thoughts-based complexity
    if (factors.estimatedThoughts > this.thoughtsThreshold) {
      complexity += 3;
    } else if (factors.estimatedThoughts > 10) {
      complexity += 2;
    } else if (factors.estimatedThoughts > 7) {
      complexity += 1;
    }

    // Keyword-based complexity
    complexity += factors.keywords;

    // Dependencies complexity
    complexity += factors.dependencies;

    // Scope complexity
    complexity += factors.scope;

    // Normalize to 1-10 scale
    const normalizedComplexity = Math.min(10, Math.max(1, Math.round(complexity)));

    console.log(`🔍 Task complexity assessment: ${normalizedComplexity}/10`);
    console.log(`   Factors: description=${factors.description}, thoughts=${factors.estimatedThoughts}, keywords=${factors.keywords}, deps=${factors.dependencies}, scope=${factors.scope}`);

    return {
      complexity: normalizedComplexity,
      factors,
      shouldOptimize: normalizedComplexity >= this.complexityThreshold || factors.estimatedThoughts > this.thoughtsThreshold
    };
  }

  /**
   * Analyze description complexity using NLP-like techniques
   */
  analyzeDescriptionComplexity(description) {
    const complexWords = [
      'arquitetar', 'planejar', 'analisar', 'complexo', 'integrar',
      'otimizar', 'refatorar', 'migrar', 'escalar', 'debug',
      'performance', 'segurança', 'compliance', 'multi',
      'sistema', 'framework', 'algoritmo', 'machine learning'
    ];

    const sentences = description.split(/[.!?]+/).filter(s => s.trim().length > 0);
    const words = description.toLowerCase().split(/\s+/);
    
    let complexity = 0;

    // Sentence count factor
    if (sentences.length > 5) complexity += 2;
    else if (sentences.length > 3) complexity += 1;

    // Word count factor
    if (words.length > 100) complexity += 2;
    else if (words.length > 50) complexity += 1;

    // Complex words factor
    const complexWordCount = words.filter(word => 
      complexWords.some(cw => word.includes(cw))
    ).length;
    
    complexity += Math.min(3, complexWordCount);

    return complexity;
  }

  /**
   * Detect complexity keywords in task description
   */
  detectComplexityKeywords(description) {
    const highComplexityKeywords = [
      'arquitetura', 'microserviços', 'performance', 'escalabilidade',
      'machine learning', 'ai', 'integração', 'migração', 'refatoração'
    ];

    const mediumComplexityKeywords = [
      'api', 'database', 'frontend', 'backend', 'testing',
      'deployment', 'monitoring', 'security', 'optimization'
    ];

    const text = description.toLowerCase();
    let complexity = 0;

    highComplexityKeywords.forEach(keyword => {
      if (text.includes(keyword)) complexity += 2;
    });

    mediumComplexityKeywords.forEach(keyword => {
      if (text.includes(keyword)) complexity += 1;
    });

    return Math.min(4, complexity);
  }

  /**
   * Analyze task dependencies
   */
  analyzeDependencies(taskData) {
    let complexity = 0;

    // Multiple files/components
    if (taskData.involves_multiple_files) complexity += 1;
    if (taskData.has_dependencies) complexity += 1;
    if (taskData.affects_multiple_modules) complexity += 2;

    // Integration requirements
    if (taskData.requires_integration) complexity += 2;
    if (taskData.requires_testing) complexity += 1;

    return complexity;
  }

  /**
   * Analyze task scope
   */
  analyzeScope(taskData) {
    let complexity = 0;

    // Time estimates
    if (taskData.estimated_hours > 8) complexity += 2;
    else if (taskData.estimated_hours > 4) complexity += 1;

    // Team involvement
    if (taskData.requires_team_coordination) complexity += 1;
    if (taskData.affects_production) complexity += 2;

    return complexity;
  }

  /**
   * Automatically activate optimization system for complex tasks
   */
  async activateOptimizationIfNeeded(taskData) {
    const assessment = this.assessTaskComplexity(taskData);

    if (assessment.shouldOptimize && !this.isOptimizationActive) {
      console.log('🚀 Activating AUGMENT Performance Optimization System...');
      
      try {
        await this.initializeOptimizationSystem();
        this.isOptimizationActive = true;
        this.performanceMetrics.tasksOptimized++;
        
        console.log('✅ AUGMENT Optimization System activated successfully');
        
        // Update average complexity
        this.updateAverageComplexity(assessment.complexity);
        
        return {
          activated: true,
          complexity: assessment.complexity,
          factors: assessment.factors
        };
        
      } catch (error) {
        console.warn('⚠️ Failed to activate optimization system:', error.message);
        console.log('📝 Continuing with normal Sequential Thinking processing...');
        
        return {
          activated: false,
          error: error.message,
          fallback: true,
          complexity: assessment.complexity
        };
      }
    }

    return {
      activated: false,
      complexity: assessment.complexity,
      reason: assessment.shouldOptimize ? 'Already active' : 'Below threshold'
    };
  }

  /**
   * Initialize the optimization system programmatically
   */
  async initializeOptimizationSystem() {
    if (this.optimizationSystem) {
      return this.optimizationSystem;
    }

    this.optimizationSystem = new AugmentOptimizationSystem();
    await this.optimizationSystem.initialize();
    
    return this.optimizationSystem;
  }

  /**
   * Monitor performance during Sequential Thinking process
   */
  async monitorThinkingProcess(thoughtData) {
    if (!this.isOptimizationActive || !this.optimizationSystem) {
      return null;
    }

    try {
      // Get current performance metrics
      const performanceReport = this.optimizationSystem.getPerformanceReport();
      
      // Track thinking process metrics
      const thinkingMetrics = {
        thoughtNumber: thoughtData.thoughtNumber,
        totalThoughts: thoughtData.totalThoughts,
        timestamp: Date.now(),
        contextUsage: performanceReport.components?.contextManager?.usage || 0,
        apiCalls: performanceReport.components?.apiMonitor?.totalRequests || 0,
        cost: performanceReport.components?.modelRouter?.totalCost || 0
      };

      // Log performance insights
      if (thoughtData.thoughtNumber % 5 === 0) {
        console.log(`📊 Performance checkpoint (thought ${thoughtData.thoughtNumber}/${thoughtData.totalThoughts}):`);
        console.log(`   Context usage: ${(thinkingMetrics.contextUsage * 100).toFixed(1)}%`);
        console.log(`   API calls: ${thinkingMetrics.apiCalls}`);
        console.log(`   Cost: $${thinkingMetrics.cost.toFixed(4)}`);
      }

      // Check for optimization opportunities
      await this.checkOptimizationOpportunities(thinkingMetrics);

      return thinkingMetrics;

    } catch (error) {
      console.warn('⚠️ Performance monitoring error:', error.message);
      return null;
    }
  }

  /**
   * Check for optimization opportunities during thinking process
   */
  async checkOptimizationOpportunities(metrics) {
    const recommendations = [];

    // Context usage optimization
    if (metrics.contextUsage > 0.8) {
      recommendations.push('Consider summarizing older thoughts to reduce context usage');
    }

    // Cost optimization
    if (metrics.cost > 0.1) {
      recommendations.push('Consider using cheaper models for simpler thoughts');
    }

    // Efficiency optimization
    if (metrics.thoughtNumber > metrics.totalThoughts * 1.5) {
      recommendations.push('Task complexity may be higher than estimated - consider breaking down');
    }

    if (recommendations.length > 0) {
      console.log('💡 Optimization recommendations:');
      recommendations.forEach((rec, index) => {
        console.log(`   ${index + 1}. ${rec}`);
      });
    }
  }

  /**
   * Update average complexity metric
   */
  updateAverageComplexity(newComplexity) {
    const totalTasks = this.performanceMetrics.tasksOptimized;
    const currentAvg = this.performanceMetrics.averageComplexity;
    
    this.performanceMetrics.averageComplexity = 
      ((currentAvg * (totalTasks - 1)) + newComplexity) / totalTasks;
  }

  /**
   * Get optimization statistics
   */
  getOptimizationStats() {
    return {
      ...this.performanceMetrics,
      isActive: this.isOptimizationActive,
      thresholds: {
        complexity: this.complexityThreshold,
        thoughts: this.thoughtsThreshold
      },
      systemStatus: this.optimizationSystem ? 'initialized' : 'not_initialized'
    };
  }

  /**
   * Deactivate optimization system
   */
  async deactivateOptimization() {
    if (this.isOptimizationActive && this.optimizationSystem) {
      console.log('🛑 Deactivating AUGMENT Optimization System...');
      
      try {
        // Save final performance report
        const finalReport = this.optimizationSystem.getPerformanceReport();
        this.performanceMetrics.performanceGains.push({
          timestamp: Date.now(),
          report: finalReport
        });

        // Shutdown optimization system
        this.optimizationSystem.shutdown();
        this.optimizationSystem = null;
        this.isOptimizationActive = false;

        console.log('✅ Optimization system deactivated');
        
      } catch (error) {
        console.warn('⚠️ Error during optimization deactivation:', error.message);
      }
    }
  }

  /**
   * Create enhanced task data for Sequential Thinking
   */
  enhanceTaskData(originalTaskData, optimizationResult) {
    return {
      ...originalTaskData,
      optimization: {
        activated: optimizationResult.activated,
        complexity: optimizationResult.complexity,
        factors: optimizationResult.factors,
        timestamp: Date.now()
      },
      performance: {
        monitoring: this.isOptimizationActive,
        thresholds: {
          complexity: this.complexityThreshold,
          thoughts: this.thoughtsThreshold
        }
      }
    };
  }

  /**
   * Generate optimization report for memory bank
   */
  generateOptimizationReport() {
    const stats = this.getOptimizationStats();
    
    return {
      timestamp: new Date().toISOString(),
      summary: {
        tasksOptimized: stats.tasksOptimized,
        averageComplexity: stats.averageComplexity.toFixed(2),
        successRate: `${(stats.optimizationSuccessRate * 100).toFixed(1)}%`,
        isCurrentlyActive: stats.isActive
      },
      thresholds: stats.thresholds,
      recommendations: this.generateRecommendations(stats),
      performanceGains: stats.performanceGains.slice(-5) // Last 5 reports
    };
  }

  /**
   * Generate recommendations based on usage patterns
   */
  generateRecommendations(stats) {
    const recommendations = [];

    if (stats.averageComplexity > 8) {
      recommendations.push('Consider breaking down complex tasks into smaller subtasks');
    }

    if (stats.tasksOptimized > 10 && stats.optimizationSuccessRate < 0.8) {
      recommendations.push('Review optimization activation criteria - may be too aggressive');
    }

    if (stats.performanceGains.length > 0) {
      recommendations.push('Analyze performance gains to identify optimization patterns');
    }

    return recommendations;
  }
}

module.exports = SequentialThinkingOptimizer;
