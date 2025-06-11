#!/usr/bin/env node

/**
 * NEW TASK AUTOMATION PROTOCOL - MONITORING SCRIPT
 * 
 * Automated monitoring and data collection for the New Task Automation Protocol
 * Tracks handoff triggers, context preservation, and user satisfaction metrics
 * 
 * Usage: node scripts/monitor-new-task-automation.js [command]
 * Commands: log, report, analyze, dashboard
 */

const fs = require('fs');
const path = require('path');

class NewTaskAutomationMonitor {
  constructor() {
    this.monitoringFile = path.join(__dirname, '../memory-bank/new-task-automation-monitoring.md');
    this.logFile = path.join(__dirname, '../memory-bank/self_correction_log.md');
    this.sessionCount = 0;
    this.metrics = {
      totalSessions: 0,
      handoffsTriggered: 0,
      handoffsSuccessful: 0,
      averageContextUsage: 0,
      averageUserSatisfaction: 0,
      reworkIncidents: 0,
      contextLossIncidents: 0
    };
  }

  /**
   * Log a new session with monitoring data
   */
  logSession(sessionData) {
    const {
      sessionNumber,
      date = new Date().toISOString().split('T')[0],
      taskType,
      complexity,
      duration,
      contextUsage,
      handoffTriggered = false,
      handoffSuccessful = null,
      userResponse = null,
      userSatisfaction,
      reworkPercentage = 0,
      contextLossIncidents = 0,
      notes = ''
    } = sessionData;

    const sessionEntry = this.formatSessionEntry({
      sessionNumber,
      date,
      taskType,
      complexity,
      duration,
      contextUsage,
      handoffTriggered,
      handoffSuccessful,
      userResponse,
      userSatisfaction,
      reworkPercentage,
      contextLossIncidents,
      notes
    });

    this.appendToMonitoringFile(sessionEntry);
    this.updateRunningStatistics(sessionData);
    
    console.log(`📊 Session ${sessionNumber} logged successfully`);
    console.log(`📈 Context Usage: ${contextUsage}%`);
    console.log(`🎯 User Satisfaction: ${userSatisfaction}/10`);
    
    if (handoffTriggered) {
      console.log(`🔄 Handoff Triggered: ${handoffSuccessful ? 'SUCCESS' : 'FAILED'}`);
    }
  }

  /**
   * Format session entry for monitoring file
   */
  formatSessionEntry(data) {
    return `
### **SESSION ${data.sessionNumber} - [${data.date}] - ${data.taskType.toUpperCase()}**

**Session Context:**
- **Task Type**: ${data.taskType}
- **Complexity**: ${data.complexity}/10
- **Duration**: ${data.duration}
- **Context Growth**: ${this.getContextGrowthDescription(data.contextUsage)}

**Handoff Trigger Analysis:**
- **Context Usage at Completion**: ${data.contextUsage}%
- **Handoff Triggered**: ${data.handoffTriggered ? 'YES' : 'NO'}${data.handoffTriggered ? ` (${data.contextUsage >= 90 ? 'CORRECT' : 'EARLY'})` : ''}
- **User Response**: ${data.userResponse || 'N/A'}
- **Handoff Success**: ${data.handoffSuccessful !== null ? (data.handoffSuccessful ? 'SUCCESS' : 'FAILED') : 'N/A'}

**Context Preservation Quality:**
- **8-Section Package**: ${data.handoffTriggered ? 'Generated' : 'N/A'}
- **Information Completeness**: ${data.handoffTriggered ? 'Validated' : 'N/A'}
- **Context Loss Incidents**: ${data.contextLossIncidents}

**Session Continuity Metrics:**
- **Rework Percentage**: ${data.reworkPercentage}%
- **User Satisfaction**: ${data.userSatisfaction}/10
- **Workflow Disruption**: ${data.reworkPercentage > 0 ? 'Detected' : 'None'}

**Pattern Documentation:**
- **Task Complexity vs Context**: ${data.complexity}/10 complexity → ${data.contextUsage}% usage
- **Threshold Effectiveness**: ${data.contextUsage >= 90 ? 'Threshold reached' : 'Below threshold'}
- **User Experience**: ${data.userSatisfaction >= 9 ? 'Excellent' : data.userSatisfaction >= 7 ? 'Good' : 'Needs improvement'}

**Key Insights:**
${data.notes || 'Standard session completion without issues'}

---
`;
  }

  /**
   * Get context growth description based on usage
   */
  getContextGrowthDescription(usage) {
    if (usage >= 90) return 'High (threshold reached)';
    if (usage >= 75) return 'Moderate-High';
    if (usage >= 50) return 'Moderate';
    if (usage >= 25) return 'Low-Moderate';
    return 'Low';
  }

  /**
   * Update running statistics
   */
  updateRunningStatistics(sessionData) {
    this.metrics.totalSessions++;
    
    if (sessionData.handoffTriggered) {
      this.metrics.handoffsTriggered++;
      if (sessionData.handoffSuccessful) {
        this.metrics.handoffsSuccessful++;
      }
    }
    
    // Update averages
    this.metrics.averageContextUsage = this.calculateRunningAverage(
      this.metrics.averageContextUsage,
      sessionData.contextUsage,
      this.metrics.totalSessions
    );
    
    this.metrics.averageUserSatisfaction = this.calculateRunningAverage(
      this.metrics.averageUserSatisfaction,
      sessionData.userSatisfaction,
      this.metrics.totalSessions
    );
    
    if (sessionData.reworkPercentage > 0) {
      this.metrics.reworkIncidents++;
    }
    
    this.metrics.contextLossIncidents += sessionData.contextLossIncidents || 0;
  }

  /**
   * Calculate running average
   */
  calculateRunningAverage(currentAvg, newValue, count) {
    return ((currentAvg * (count - 1)) + newValue) / count;
  }

  /**
   * Generate comprehensive report
   */
  generateReport() {
    const handoffSuccessRate = this.metrics.handoffsTriggered > 0 
      ? (this.metrics.handoffsSuccessful / this.metrics.handoffsTriggered * 100).toFixed(1)
      : 'N/A';
    
    const reworkRate = this.metrics.totalSessions > 0
      ? (this.metrics.reworkIncidents / this.metrics.totalSessions * 100).toFixed(1)
      : '0.0';

    return `
📊 NEW TASK AUTOMATION PROTOCOL - MONITORING REPORT
==================================================

📈 OVERALL METRICS (${this.metrics.totalSessions} sessions):
- Handoff Success Rate: ${handoffSuccessRate}% (Target: >95%)
- Average Context Usage: ${this.metrics.averageContextUsage.toFixed(1)}%
- Average User Satisfaction: ${this.metrics.averageUserSatisfaction.toFixed(1)}/10 (Target: >9/10)
- Rework Rate: ${reworkRate}% (Target: <5%)
- Context Loss Incidents: ${this.metrics.contextLossIncidents}

🎯 TARGET ACHIEVEMENT:
- Handoff Success: ${handoffSuccessRate !== 'N/A' && parseFloat(handoffSuccessRate) >= 95 ? '✅ ACHIEVED' : '⚠️ MONITORING'}
- User Satisfaction: ${this.metrics.averageUserSatisfaction >= 9 ? '✅ ACHIEVED' : '⚠️ NEEDS IMPROVEMENT'}
- Session Continuity: ${parseFloat(reworkRate) < 5 ? '✅ ACHIEVED' : '⚠️ NEEDS IMPROVEMENT'}

🔄 HANDOFF ANALYSIS:
- Total Handoffs Triggered: ${this.metrics.handoffsTriggered}
- Successful Handoffs: ${this.metrics.handoffsSuccessful}
- Failed Handoffs: ${this.metrics.handoffsTriggered - this.metrics.handoffsSuccessful}

📋 RECOMMENDATIONS:
${this.generateRecommendations()}
`;
  }

  /**
   * Generate recommendations based on metrics
   */
  generateRecommendations() {
    const recommendations = [];
    
    if (this.metrics.averageUserSatisfaction < 9) {
      recommendations.push('- Improve user experience in handoff process');
    }
    
    if (this.metrics.handoffsTriggered === 0 && this.metrics.totalSessions >= 5) {
      recommendations.push('- Test higher complexity tasks to validate 90% threshold');
    }
    
    if (this.metrics.reworkIncidents > 0) {
      recommendations.push('- Investigate context preservation quality');
    }
    
    if (this.metrics.contextLossIncidents > 0) {
      recommendations.push('- Enhance context transfer mechanisms');
    }
    
    if (recommendations.length === 0) {
      recommendations.push('- Continue monitoring - system performing well');
    }
    
    return recommendations.join('\n');
  }

  /**
   * Append content to monitoring file
   */
  appendToMonitoringFile(content) {
    try {
      fs.appendFileSync(this.monitoringFile, content);
    } catch (error) {
      console.error('Error writing to monitoring file:', error);
    }
  }

  /**
   * Display monitoring dashboard
   */
  displayDashboard() {
    console.log(this.generateReport());
  }
}

// CLI Interface
if (require.main === module) {
  const monitor = new NewTaskAutomationMonitor();
  const command = process.argv[2];
  
  switch (command) {
    case 'log':
      // Example usage: node scripts/monitor-new-task-automation.js log
      console.log('📊 Use monitor.logSession(sessionData) to log session data');
      console.log('📋 Required fields: sessionNumber, taskType, complexity, contextUsage, userSatisfaction');
      break;
      
    case 'report':
      monitor.displayDashboard();
      break;
      
    case 'analyze':
      console.log('📈 Analysis features coming in Phase 2');
      break;
      
    case 'dashboard':
      monitor.displayDashboard();
      break;
      
    default:
      console.log(`
🔍 NEW TASK AUTOMATION MONITORING TOOL

Usage: node scripts/monitor-new-task-automation.js [command]

Commands:
  log       - Log session data (use programmatically)
  report    - Generate monitoring report
  analyze   - Analyze patterns (Phase 2)
  dashboard - Display monitoring dashboard

Example:
  node scripts/monitor-new-task-automation.js report
      `);
  }
}

module.exports = NewTaskAutomationMonitor;
