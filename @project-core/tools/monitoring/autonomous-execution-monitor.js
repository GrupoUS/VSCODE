/**
 * GRUPO US VIBECODE SYSTEM V2.0 - Autonomous Execution Monitor
 * Real-time monitoring system for Unattended Execution Protocol V1.0.0
 *
 * Tracks performance metrics across all GRUPO US projects:
 * - neonpro (Next.js)
 * - aegiswallet (Vite + React)
 * - harmoniza-facil-agendas (Next.js + Prisma)
 */

const fs = require("fs");
const path = require("path");

class AutonomousExecutionMonitor {
  constructor() {
    this.metrics = {
      global: {
        totalExecutions: 0,
        successfulExecutions: 0,
        failedExecutions: 0,
        averageExecutionTime: 0,
        userInterventions: 0,
        emergencyOverrides: 0,
        lastUpdated: new Date().toISOString(),
      },
      projects: {
        neonpro: this.initializeProjectMetrics("neonpro"),
        aegiswallet: this.initializeProjectMetrics("aegiswallet"),
        harmoniza: this.initializeProjectMetrics("harmoniza-facil-agendas"),
      },
      quality: {
        completionRate: 0,
        tokenUsage: 0,
        errorRate: 0,
        userSatisfaction: 0,
        codeQuality: 0,
      },
      performance: {
        tasksPerHour: 0,
        timeToCompletion: 0,
        efficiencyGain: 0,
        resourceUtilization: 0,
      },
    };

    this.targets = {
      completionRate: 95, // >95%
      executionTimeImprovement: 50, // >50% improvement
      errorRate: 5, // <5%
      userSatisfaction: 9, // >9/10
    };

    this.logPath = "monitoring/logs/autonomous-execution.log";
    this.reportPath = "monitoring/reports/";
    this.alertsEnabled = true;

    this.initializeMonitoring();
  }

  initializeProjectMetrics(projectName) {
    return {
      name: projectName,
      executions: 0,
      successRate: 0,
      averageTime: 0,
      lastExecution: null,
      techStack: this.getTechStack(projectName),
      specificMetrics: this.getProjectSpecificMetrics(projectName),
    };
  }

  getTechStack(projectName) {
    const techStacks = {
      neonpro: [
        "Next.js 14",
        "TypeScript",
        "Tailwind CSS",
        "Supabase",
        "Vercel",
      ],
      aegiswallet: ["Vite", "React", "TypeScript", "Tailwind CSS", "Supabase"],
      "harmoniza-facil-agendas": [
        "Next.js 14",
        "TypeScript",
        "Prisma",
        "PostgreSQL",
        "Vercel",
      ],
    };
    return techStacks[projectName] || [];
  }

  getProjectSpecificMetrics(projectName) {
    const specificMetrics = {
      neonpro: {
        buildTime: { target: 60000, current: 0 },
        componentGeneration: { target: 5000, current: 0 },
        apiRouteImplementation: { target: 10000, current: 0 },
        deploymentTime: { target: 180000, current: 0 },
      },
      aegiswallet: {
        buildTime: { target: 45000, current: 0 },
        componentGeneration: { target: 3000, current: 0 },
        securityScanTime: { target: 30000, current: 0 },
        testExecution: { target: 60000, current: 0 },
      },
      "harmoniza-facil-agendas": {
        appointmentBookingTime: { target: 2000, current: 0 },
        calendarLoadTime: { target: 1500, current: 0 },
        databaseQueryTime: { target: 500, current: 0 },
        buildTime: { target: 90000, current: 0 },
      },
    };
    return specificMetrics[projectName] || {};
  }

  initializeMonitoring() {
    // Create monitoring directories
    const dirs = ["monitoring/logs", "monitoring/reports", "monitoring/alerts"];
    dirs.forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });

    // Initialize log file
    this.log(
      "AUTONOMOUS_MONITOR_INIT",
      "Autonomous Execution Monitor initialized",
      {
        timestamp: new Date().toISOString(),
        version: "1.0.0",
        projects: Object.keys(this.metrics.projects),
      }
    );

    console.log(
      "[AUTONOMOUS] Monitoring system initialized for GRUPO US VIBECODE SYSTEM V2.0"
    );
  }

  // Record autonomous execution start
  startExecution(projectName, taskDescription, approvalPhrase) {
    const executionId = `exec_${Date.now()}_${Math.random()
      .toString(36)
      .substr(2, 9)}`;
    const execution = {
      id: executionId,
      project: projectName,
      task: taskDescription,
      approvalPhrase,
      startTime: Date.now(),
      endTime: null,
      duration: null,
      status: "running",
      autonomous: true,
      userInterventions: 0,
      filesModified: 0,
      commandsExecuted: 0,
      errors: [],
    };

    this.metrics.global.totalExecutions++;

    // Handle project name mapping
    const mappedProjectName = this.mapProjectName(projectName);
    if (this.metrics.projects[mappedProjectName]) {
      this.metrics.projects[mappedProjectName].executions++;
    }

    this.log("EXECUTION_START", "Autonomous execution started", execution);

    return executionId;
  }

  // Record autonomous execution completion
  completeExecution(executionId, success, metrics = {}) {
    const endTime = Date.now();
    const execution = this.getExecutionById(executionId);

    if (!execution) {
      this.log("ERROR", "Execution not found for completion", { executionId });
      return;
    }

    execution.endTime = endTime;
    execution.duration = endTime - execution.startTime;
    execution.status = success ? "completed" : "failed";

    // Update global metrics
    if (success) {
      this.metrics.global.successfulExecutions++;
    } else {
      this.metrics.global.failedExecutions++;
    }

    // Update project metrics
    const project = this.metrics.projects[execution.project];
    if (project) {
      project.lastExecution = new Date().toISOString();
      project.successRate =
        (this.metrics.global.successfulExecutions /
          this.metrics.global.totalExecutions) *
        100;

      // Update project-specific metrics
      if (metrics.buildTime && project.specificMetrics.buildTime) {
        project.specificMetrics.buildTime.current = metrics.buildTime;
      }
    }

    // Calculate performance metrics
    this.updatePerformanceMetrics();

    this.log("EXECUTION_COMPLETE", "Autonomous execution completed", {
      ...execution,
      metrics,
    });

    // Check for alerts
    this.checkAlerts();

    console.log(
      `[AUTONOMOUS] Execution ${executionId} completed: ${
        success ? "SUCCESS" : "FAILED"
      }`
    );
  }

  // Record user intervention
  recordUserIntervention(executionId, reason, timestamp = Date.now()) {
    this.metrics.global.userInterventions++;

    this.log("USER_INTERVENTION", "User intervention required", {
      executionId,
      reason,
      timestamp: new Date(timestamp).toISOString(),
    });

    console.log(`[AUTONOMOUS] User intervention recorded: ${reason}`);
  }

  // Record emergency override
  recordEmergencyOverride(executionId, reason, timestamp = Date.now()) {
    this.metrics.global.emergencyOverrides++;

    this.log("EMERGENCY_OVERRIDE", "Emergency override activated", {
      executionId,
      reason,
      timestamp: new Date(timestamp).toISOString(),
    });

    console.log(`[AUTONOMOUS] Emergency override recorded: ${reason}`);
  }

  // Update performance metrics
  updatePerformanceMetrics() {
    const total = this.metrics.global.totalExecutions;
    const successful = this.metrics.global.successfulExecutions;

    // Completion rate
    this.metrics.quality.completionRate =
      total > 0 ? (successful / total) * 100 : 0;

    // Error rate
    this.metrics.quality.errorRate =
      total > 0 ? (this.metrics.global.failedExecutions / total) * 100 : 0;

    // Tasks per hour (estimated based on recent executions)
    this.metrics.performance.tasksPerHour = this.calculateTasksPerHour();

    // Efficiency gain (compared to manual execution baseline)
    this.metrics.performance.efficiencyGain = this.calculateEfficiencyGain();

    this.metrics.global.lastUpdated = new Date().toISOString();
  }

  calculateTasksPerHour() {
    // Simplified calculation - would use actual execution times in production
    const avgExecutionTime = 300000; // 5 minutes average
    return Math.round(3600000 / avgExecutionTime); // Tasks per hour
  }

  calculateEfficiencyGain() {
    // Simplified calculation - would compare with manual execution baseline
    const manualExecutionTime = 1800000; // 30 minutes manual average
    const autonomousExecutionTime = 300000; // 5 minutes autonomous average
    return Math.round(
      ((manualExecutionTime - autonomousExecutionTime) / manualExecutionTime) *
        100
    );
  }

  // Check for performance alerts
  checkAlerts() {
    const alerts = [];

    // Completion rate alert
    if (this.metrics.quality.completionRate < this.targets.completionRate) {
      alerts.push({
        type: "COMPLETION_RATE_LOW",
        message: `Completion rate ${this.metrics.quality.completionRate.toFixed(
          1
        )}% below target ${this.targets.completionRate}%`,
        severity: "warning",
      });
    }

    // Error rate alert
    if (this.metrics.quality.errorRate > this.targets.errorRate) {
      alerts.push({
        type: "ERROR_RATE_HIGH",
        message: `Error rate ${this.metrics.quality.errorRate.toFixed(
          1
        )}% above target ${this.targets.errorRate}%`,
        severity: "critical",
      });
    }

    // Process alerts
    alerts.forEach((alert) => {
      this.processAlert(alert);
    });
  }

  processAlert(alert) {
    this.log("ALERT", alert.message, alert);

    if (this.alertsEnabled) {
      console.warn(`[AUTONOMOUS ALERT] ${alert.type}: ${alert.message}`);

      // Save alert to file
      const alertFile = path.join(
        "monitoring/alerts",
        `alert_${Date.now()}.json`
      );
      fs.writeFileSync(
        alertFile,
        JSON.stringify(
          {
            ...alert,
            timestamp: new Date().toISOString(),
          },
          null,
          2
        )
      );
    }
  }

  // Generate performance report
  generateReport() {
    const report = {
      timestamp: new Date().toISOString(),
      summary: {
        totalExecutions: this.metrics.global.totalExecutions,
        successRate: this.metrics.quality.completionRate,
        errorRate: this.metrics.quality.errorRate,
        efficiencyGain: this.metrics.performance.efficiencyGain,
      },
      projects: this.metrics.projects,
      targets: this.targets,
      recommendations: this.generateRecommendations(),
    };

    const reportFile = path.join(
      this.reportPath,
      `autonomous_execution_report_${Date.now()}.json`
    );
    fs.writeFileSync(reportFile, JSON.stringify(report, null, 2));

    console.log(`[AUTONOMOUS] Performance report generated: ${reportFile}`);
    return report;
  }

  generateRecommendations() {
    const recommendations = [];

    if (this.metrics.quality.completionRate < this.targets.completionRate) {
      recommendations.push("Improve error handling and fallback strategies");
    }

    if (this.metrics.quality.errorRate > this.targets.errorRate) {
      recommendations.push("Enhance pre-execution validation and testing");
    }

    if (this.metrics.global.userInterventions > 0) {
      recommendations.push(
        "Analyze intervention patterns to improve autonomous decision-making"
      );
    }

    return recommendations;
  }

  // Logging utility
  log(type, message, data = {}) {
    const logEntry = {
      timestamp: new Date().toISOString(),
      type,
      message,
      data,
    };

    const logLine = JSON.stringify(logEntry) + "\n";

    try {
      fs.appendFileSync(this.logPath, logLine);
    } catch (error) {
      console.error("[AUTONOMOUS] Failed to write log:", error);
    }
  }

  // Get current metrics
  getMetrics() {
    return {
      ...this.metrics,
      targets: this.targets,
      lastUpdated: new Date().toISOString(),
    };
  }

  // Get execution by ID (simplified - would use proper storage in production)
  getExecutionById(executionId) {
    // Simplified implementation - would use database or proper storage
    return {
      id: executionId,
      project: "unknown",
      startTime: Date.now() - 300000, // 5 minutes ago
    };
  }

  // Map project names to internal keys
  mapProjectName(projectName) {
    const mapping = {
      "harmoniza-facil-agendas": "harmoniza",
      "cross-project": "neonpro", // Default to neonpro for cross-project tasks
    };
    return mapping[projectName] || projectName;
  }
}

// Export singleton instance
const autonomousMonitor = new AutonomousExecutionMonitor();

module.exports = autonomousMonitor;

// CLI interface for monitoring
if (require.main === module) {
  const command = process.argv[2];

  switch (command) {
    case "status":
      console.log(JSON.stringify(autonomousMonitor.getMetrics(), null, 2));
      break;
    case "report":
      autonomousMonitor.generateReport();
      break;
    case "test":
      // Test execution
      const execId = autonomousMonitor.startExecution(
        "neonpro",
        "Test autonomous execution",
        "YARRR!"
      );
      setTimeout(() => {
        autonomousMonitor.completeExecution(execId, true, { buildTime: 45000 });
      }, 1000);
      break;
    default:
      console.log(
        "Usage: node autonomous-execution-monitor.js [status|report|test]"
      );
  }
}
