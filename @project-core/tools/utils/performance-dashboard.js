/**
 * Performance Dashboard - Real-time Monitoring System
 * GRUPO US VIBECODE SYSTEM V2.0 - AUGMENT OPTIMIZATION
 */

const APIMonitor = require('./api-monitor');
const BatchProcessor = require('./batch-processor');

class PerformanceDashboard {
  constructor() {
    this.apiMonitor = new APIMonitor();
    this.batchProcessor = new BatchProcessor();
    this.startTime = Date.now();
    this.updateInterval = null;
    this.displayMode = 'compact'; // 'compact' | 'detailed' | 'minimal'
    
    // Performance targets from .clinerules/05-performance-metrics.md
    this.targets = {
      apiCallsReduction: 60, // %
      responseTime: 2000, // ms
      costPerFeature: 0.50, // $
      successRate: 85, // %
      errorRate: 5 // %
    };
  }

  /**
   * Start real-time monitoring
   */
  start(updateIntervalMs = 5000) {
    console.log('🚀 Starting Augment Performance Dashboard...');
    this.render();
    
    this.updateInterval = setInterval(() => {
      this.render();
    }, updateIntervalMs);
  }

  /**
   * Stop monitoring
   */
  stop() {
    if (this.updateInterval) {
      clearInterval(this.updateInterval);
      this.updateInterval = null;
    }
    console.log('⏹️  Performance Dashboard stopped');
  }

  /**
   * Render dashboard based on display mode
   */
  render() {
    console.clear();
    
    switch (this.displayMode) {
      case 'minimal':
        this.renderMinimal();
        break;
      case 'detailed':
        this.renderDetailed();
        break;
      default:
        this.renderCompact();
    }
  }

  /**
   * Render minimal dashboard
   */
  renderMinimal() {
    const metrics = this.apiMonitor.getPerformanceReport();
    const batchStats = this.batchProcessor.getStats();
    
    console.log('📊 AUGMENT PERFORMANCE (Minimal)');
    console.log('================================');
    console.log(`API Calls: ${metrics.metrics.totalRequests} | Cost: $${metrics.metrics.totalCost.toFixed(2)} | Errors: ${(metrics.metrics.errorRate * 100).toFixed(1)}%`);
    console.log(`Response: ${metrics.metrics.avgResponseTime.toFixed(0)}ms | Cache: ${(metrics.metrics.cacheHitRate * 100).toFixed(1)}% | Batch: ${batchStats.efficiency.toFixed(1)}%`);
  }

  /**
   * Render compact dashboard
   */
  renderCompact() {
    const metrics = this.apiMonitor.getPerformanceReport();
    const batchStats = this.batchProcessor.getStats();
    const uptime = this.formatUptime(metrics.uptime);
    
    console.log('📊 AUGMENT PERFORMANCE DASHBOARD V2.0');
    console.log('=====================================');
    console.log(`⏱️  Uptime: ${uptime}`);
    console.log('');
    
    // Core Metrics
    console.log('🎯 CORE METRICS');
    console.log(`   API Calls: ${metrics.metrics.totalRequests.toString().padEnd(8)} Target: Reduce 60%`);
    console.log(`   Total Cost: $${metrics.metrics.totalCost.toFixed(2).padEnd(7)} Target: <$0.50/feature`);
    console.log(`   Avg Response: ${metrics.metrics.avgResponseTime.toFixed(0)}ms${this.getStatusIcon(metrics.metrics.avgResponseTime, this.targets.responseTime, true)} Target: <2000ms`);
    console.log(`   Error Rate: ${(metrics.metrics.errorRate * 100).toFixed(1)}%${this.getStatusIcon(metrics.metrics.errorRate * 100, this.targets.errorRate, true)} Target: <5%`);
    console.log(`   Cache Hit: ${(metrics.metrics.cacheHitRate * 100).toFixed(1)}%${this.getStatusIcon(metrics.metrics.cacheHitRate * 100, 30, false)}`);
    console.log('');
    
    // Batch Processing
    console.log('📦 BATCH PROCESSING');
    console.log(`   Efficiency: ${batchStats.efficiency.toFixed(1)}%${this.getStatusIcon(batchStats.efficiency, 70, false)}`);
    console.log(`   Queue: ${batchStats.queueLength} operations`);
    console.log(`   Avg Batch Size: ${batchStats.avgBatchSize.toFixed(1)}`);
    console.log(`   Processing: ${batchStats.processing ? '🔄 Active' : '⏸️  Idle'}`);
    console.log('');
    
    // Budget Status
    const budgetUsage = parseFloat(metrics.budgetUsage);
    console.log('💰 BUDGET STATUS');
    console.log(`   Daily Usage: ${budgetUsage.toFixed(1)}%${this.getBudgetIcon(budgetUsage)}`);
    console.log(`   Remaining: $${(10 - metrics.metrics.totalCost).toFixed(2)}`);
    console.log('');
    
    // Recent Activity
    if (metrics.recentRequests.length > 0) {
      console.log('📈 RECENT ACTIVITY (Last 5)');
      metrics.recentRequests.slice(-5).forEach(req => {
        const status = req.success ? '✅' : '❌';
        const time = new Date(req.timestamp).toLocaleTimeString();
        console.log(`   ${status} ${time} ${req.operation} (${req.duration}ms)`);
      });
      console.log('');
    }
    
    // Alerts
    this.renderAlerts(metrics);
    
    // Quick Stats
    console.log('⚡ QUICK STATS');
    console.log(`   Tokens Used: ${metrics.metrics.totalTokens.toLocaleString()}`);
    console.log(`   Cache Size: ${metrics.cacheSize} entries`);
    console.log(`   Batches Processed: ${batchStats.totalBatches}`);
    console.log('');
    
    // Controls
    console.log('🎛️  CONTROLS: [M]inimal | [D]etailed | [R]eset | [Q]uit');
  }

  /**
   * Render detailed dashboard
   */
  renderDetailed() {
    const metrics = this.apiMonitor.getPerformanceReport();
    const batchStats = this.batchProcessor.getStats();
    
    console.log('📊 AUGMENT PERFORMANCE DASHBOARD V2.0 (DETAILED)');
    console.log('================================================');
    
    // All metrics from compact view
    this.renderCompact();
    
    // Additional detailed information
    console.log('🔍 DETAILED ANALYSIS');
    console.log('');
    
    // Performance Trends
    console.log('📈 PERFORMANCE TRENDS');
    if (metrics.recentRequests.length >= 10) {
      const recent10 = metrics.recentRequests.slice(-10);
      const avgLast10 = recent10.reduce((sum, r) => sum + r.duration, 0) / recent10.length;
      const trend = avgLast10 < metrics.metrics.avgResponseTime ? '📈 Improving' : '📉 Degrading';
      console.log(`   Response Time Trend: ${trend}`);
      console.log(`   Last 10 Avg: ${avgLast10.toFixed(0)}ms vs Overall: ${metrics.metrics.avgResponseTime.toFixed(0)}ms`);
    }
    console.log('');
    
    // Recommendations
    if (metrics.recommendations.length > 0) {
      console.log('💡 RECOMMENDATIONS');
      metrics.recommendations.forEach((rec, index) => {
        console.log(`   ${index + 1}. ${rec}`);
      });
      console.log('');
    }
    
    // System Health
    console.log('🏥 SYSTEM HEALTH');
    console.log(`   Memory Usage: ${this.getMemoryUsage()}`);
    console.log(`   CPU Usage: ${this.getCPUUsage()}`);
    console.log(`   Disk Space: ${this.getDiskSpace()}`);
  }

  /**
   * Render alerts section
   */
  renderAlerts(metrics) {
    const alerts = this.generateAlerts(metrics);
    
    if (alerts.length > 0) {
      console.log('🚨 ALERTS');
      alerts.forEach(alert => {
        const icon = alert.level === 'critical' ? '🔴' : alert.level === 'warning' ? '🟡' : '🔵';
        console.log(`   ${icon} ${alert.message}`);
        if (alert.action) {
          console.log(`      → ${alert.action}`);
        }
      });
      console.log('');
    }
  }

  /**
   * Generate alerts based on current metrics
   */
  generateAlerts(metrics) {
    const alerts = [];
    
    // Response time alert
    if (metrics.metrics.avgResponseTime > this.targets.responseTime) {
      alerts.push({
        level: 'warning',
        message: `Response time above target: ${metrics.metrics.avgResponseTime.toFixed(0)}ms`,
        action: 'Consider switching to faster models'
      });
    }
    
    // Error rate alert
    if (metrics.metrics.errorRate * 100 > this.targets.errorRate) {
      alerts.push({
        level: 'critical',
        message: `Error rate above target: ${(metrics.metrics.errorRate * 100).toFixed(1)}%`,
        action: 'Review error logs and implement better validation'
      });
    }
    
    // Budget alert
    const budgetUsage = parseFloat(metrics.budgetUsage);
    if (budgetUsage > 80) {
      alerts.push({
        level: budgetUsage > 95 ? 'critical' : 'warning',
        message: `Budget usage high: ${budgetUsage.toFixed(1)}%`,
        action: 'Switch to cheaper models or optimize operations'
      });
    }
    
    // Cache efficiency alert
    if (metrics.metrics.cacheHitRate < 0.2 && metrics.metrics.totalRequests > 10) {
      alerts.push({
        level: 'info',
        message: `Low cache hit rate: ${(metrics.metrics.cacheHitRate * 100).toFixed(1)}%`,
        action: 'Review caching strategy'
      });
    }
    
    return alerts;
  }

  /**
   * Get status icon based on value and target
   */
  getStatusIcon(value, target, lowerIsBetter = true) {
    const isGood = lowerIsBetter ? value <= target : value >= target;
    return isGood ? ' ✅' : ' ⚠️';
  }

  /**
   * Get budget status icon
   */
  getBudgetIcon(budgetUsage) {
    if (budgetUsage < 50) return ' 🟢';
    if (budgetUsage < 80) return ' 🟡';
    return ' 🔴';
  }

  /**
   * Format uptime duration
   */
  formatUptime(ms) {
    const seconds = Math.floor(ms / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    
    if (hours > 0) {
      return `${hours}h ${minutes % 60}m ${seconds % 60}s`;
    } else if (minutes > 0) {
      return `${minutes}m ${seconds % 60}s`;
    } else {
      return `${seconds}s`;
    }
  }

  /**
   * Get memory usage (mock implementation)
   */
  getMemoryUsage() {
    const used = process.memoryUsage();
    return `${Math.round(used.rss / 1024 / 1024 * 100) / 100} MB`;
  }

  /**
   * Get CPU usage (mock implementation)
   */
  getCPUUsage() {
    return 'N/A'; // Would require additional monitoring
  }

  /**
   * Get disk space (mock implementation)
   */
  getDiskSpace() {
    return 'N/A'; // Would require additional monitoring
  }

  /**
   * Set display mode
   */
  setDisplayMode(mode) {
    if (['minimal', 'compact', 'detailed'].includes(mode)) {
      this.displayMode = mode;
      this.render();
    }
  }

  /**
   * Reset all metrics
   */
  reset() {
    this.apiMonitor.reset();
    this.batchProcessor.clear();
    console.log('🔄 Performance metrics reset');
  }

  /**
   * Export performance report
   */
  exportReport() {
    const report = {
      timestamp: new Date().toISOString(),
      uptime: Date.now() - this.startTime,
      apiMetrics: this.apiMonitor.getPerformanceReport(),
      batchStats: this.batchProcessor.getStats(),
      targets: this.targets
    };
    
    const fs = require('fs');
    const filename = `performance-report-${Date.now()}.json`;
    fs.writeFileSync(filename, JSON.stringify(report, null, 2));
    
    console.log(`📄 Report exported: ${filename}`);
    return filename;
  }
}

module.exports = PerformanceDashboard;
