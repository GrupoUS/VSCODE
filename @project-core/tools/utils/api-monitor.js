/**
 * API Monitor - Performance Tracking System
 * GRUPO US VIBECODE SYSTEM V2.0 - AUGMENT OPTIMIZATION
 */

class APIMonitor {
  constructor() {
    this.requests = [];
    this.cache = new Map();
    this.metrics = {
      totalRequests: 0,
      totalCost: 0,
      totalTokens: 0,
      avgResponseTime: 0,
      errorRate: 0,
      cacheHitRate: 0,
      contextUsage: 0
    };
    this.startTime = Date.now();
    this.dailyBudget = 10.0; // $10 daily budget
    this.performanceThresholds = {
      maxResponseTime: 3000, // 3s
      maxErrorRate: 0.1, // 10%
      maxContextUsage: 0.9, // 90%
      budgetWarning: 0.8 // 80% of daily budget
    };
  }

  /**
   * Intercept and monitor API requests
   */
  async intercept(request) {
    const requestId = this.generateRequestId();
    const cacheKey = this.generateCacheKey(request);
    
    // Check cache first
    if (this.cache.has(cacheKey)) {
      this.logCacheHit(requestId, cacheKey);
      return this.cache.get(cacheKey);
    }
    
    // Execute request with monitoring
    const startTime = Date.now();
    let response, error;
    
    try {
      response = await this.executeRequest(request);
      const duration = Date.now() - startTime;
      
      this.logRequest({
        id: requestId,
        timestamp: new Date(),
        duration,
        tokens: response.usage?.total_tokens || 0,
        cost: this.calculateCost(response),
        success: true,
        operation: request.operation || 'unknown',
        model: request.model || 'unknown'
      });
      
      // Cache successful responses
      if (response && !response.error) {
        this.cache.set(cacheKey, response);
        this.scheduleCacheCleanup(cacheKey);
      }
      
      return response;
      
    } catch (err) {
      error = err;
      const duration = Date.now() - startTime;
      
      this.logRequest({
        id: requestId,
        timestamp: new Date(),
        duration,
        tokens: 0,
        cost: 0,
        success: false,
        error: err.message,
        operation: request.operation || 'unknown',
        model: request.model || 'unknown'
      });
      
      throw err;
    }
  }

  /**
   * Generate unique request ID
   */
  generateRequestId() {
    return `req_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Generate cache key for request
   */
  generateCacheKey(request) {
    const keyData = {
      operation: request.operation,
      params: request.params,
      model: request.model
    };
    return `cache_${JSON.stringify(keyData).hashCode()}`;
  }

  /**
   * Execute the actual API request
   */
  async executeRequest(request) {
    // This would be implemented based on the actual API client
    // For now, return a mock response
    return {
      data: request.data,
      usage: { total_tokens: 100 },
      model: request.model || 'claude-3-sonnet'
    };
  }

  /**
   * Calculate cost based on model and tokens
   */
  calculateCost(response) {
    const model = response.model || 'claude-3-sonnet';
    const tokens = response.usage?.total_tokens || 0;
    
    const pricing = {
      'claude-3-haiku': 0.00025,
      'claude-3-sonnet': 0.003,
      'gpt-4': 0.03,
      'gpt-4-turbo': 0.01
    };
    
    return (pricing[model] || 0.003) * (tokens / 1000);
  }

  /**
   * Log request data
   */
  logRequest(requestData) {
    this.requests.push(requestData);
    this.updateMetrics();
    this.checkThresholds();
    
    // Keep only last 1000 requests in memory
    if (this.requests.length > 1000) {
      this.requests = this.requests.slice(-1000);
    }
  }

  /**
   * Log cache hit
   */
  logCacheHit(requestId, cacheKey) {
    console.log(`🎯 Cache HIT: ${requestId} -> ${cacheKey}`);
    this.metrics.totalRequests++;
    this.updateMetrics();
  }

  /**
   * Update performance metrics
   */
  updateMetrics() {
    const successfulRequests = this.requests.filter(r => r.success);
    const totalRequests = this.requests.length;
    
    this.metrics.totalRequests = totalRequests;
    this.metrics.totalCost = this.requests.reduce((sum, r) => sum + r.cost, 0);
    this.metrics.totalTokens = this.requests.reduce((sum, r) => sum + r.tokens, 0);
    this.metrics.avgResponseTime = totalRequests > 0 
      ? this.requests.reduce((sum, r) => sum + r.duration, 0) / totalRequests 
      : 0;
    this.metrics.errorRate = totalRequests > 0 
      ? (totalRequests - successfulRequests.length) / totalRequests 
      : 0;
    this.metrics.cacheHitRate = this.calculateCacheHitRate();
  }

  /**
   * Calculate cache hit rate
   */
  calculateCacheHitRate() {
    const cacheHits = this.cache.size;
    const totalRequests = this.metrics.totalRequests;
    return totalRequests > 0 ? cacheHits / totalRequests : 0;
  }

  /**
   * Check performance thresholds and trigger alerts
   */
  checkThresholds() {
    const alerts = [];
    
    if (this.metrics.avgResponseTime > this.performanceThresholds.maxResponseTime) {
      alerts.push({
        level: 'warning',
        message: `Response time degraded: ${this.metrics.avgResponseTime}ms`,
        action: 'Switch to faster models'
      });
    }
    
    if (this.metrics.errorRate > this.performanceThresholds.maxErrorRate) {
      alerts.push({
        level: 'critical',
        message: `Error rate too high: ${(this.metrics.errorRate * 100).toFixed(1)}%`,
        action: 'Review error logs and enable enhanced validation'
      });
    }
    
    if (this.metrics.totalCost > this.dailyBudget * this.performanceThresholds.budgetWarning) {
      alerts.push({
        level: 'warning',
        message: `Approaching daily budget: $${this.metrics.totalCost.toFixed(2)}`,
        action: 'Switch to cheaper models'
      });
    }
    
    if (alerts.length > 0) {
      this.triggerAlerts(alerts);
    }
  }

  /**
   * Trigger performance alerts
   */
  triggerAlerts(alerts) {
    alerts.forEach(alert => {
      console.log(`🚨 ${alert.level.toUpperCase()}: ${alert.message}`);
      console.log(`   Action: ${alert.action}`);
    });
  }

  /**
   * Schedule cache cleanup
   */
  scheduleCacheCleanup(cacheKey) {
    setTimeout(() => {
      this.cache.delete(cacheKey);
    }, 5 * 60 * 1000); // 5 minutes default
  }

  /**
   * Get current performance report
   */
  getPerformanceReport() {
    const uptime = Date.now() - this.startTime;
    
    return {
      uptime: uptime,
      metrics: this.metrics,
      recentRequests: this.requests.slice(-10),
      cacheSize: this.cache.size,
      budgetUsage: (this.metrics.totalCost / this.dailyBudget * 100).toFixed(1),
      recommendations: this.generateRecommendations()
    };
  }

  /**
   * Generate optimization recommendations
   */
  generateRecommendations() {
    const recommendations = [];
    
    if (this.metrics.cacheHitRate < 0.3) {
      recommendations.push('Increase cache duration for frequently accessed data');
    }
    
    if (this.metrics.avgResponseTime > 2000) {
      recommendations.push('Consider using faster models for simple operations');
    }
    
    if (this.metrics.errorRate > 0.05) {
      recommendations.push('Implement better error prevention and validation');
    }
    
    return recommendations;
  }

  /**
   * Reset metrics (for testing)
   */
  reset() {
    this.requests = [];
    this.cache.clear();
    this.metrics = {
      totalRequests: 0,
      totalCost: 0,
      totalTokens: 0,
      avgResponseTime: 0,
      errorRate: 0,
      cacheHitRate: 0,
      contextUsage: 0
    };
    this.startTime = Date.now();
  }
}

// Add hashCode method to String prototype for cache key generation
String.prototype.hashCode = function() {
  let hash = 0;
  if (this.length === 0) return hash;
  for (let i = 0; i < this.length; i++) {
    const char = this.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash; // Convert to 32bit integer
  }
  return hash;
};

module.exports = APIMonitor;
