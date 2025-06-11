/**
 * GRUPO US VIBECODE SYSTEM V2.0 - Usage Data Collector
 * Comprehensive data collection system for autonomous execution analytics
 *
 * Collects real-world usage patterns across all GRUPO US projects:
 * - Execution patterns and command effectiveness
 * - File operation success rates and user intervention frequency
 * - Protocol optimization opportunities and performance insights
 */

const fs = require("fs");
const path = require("path");
const crypto = require("crypto");

class UsageDataCollector {
  constructor() {
    this.dataPath = "monitoring/data/";
    this.sessionId = this.generateSessionId();
    this.collectionStartTime = Date.now();

    this.patterns = {
      executionPatterns: [],
      commandEffectiveness: new Map(),
      fileOperations: [],
      userInterventions: [],
      errorPatterns: [],
      optimizationOpportunities: [],
    };

    this.metrics = {
      totalDataPoints: 0,
      sessionsTracked: 0,
      patternsIdentified: 0,
      optimizationsFound: 0,
    };

    this.initializeDataCollection();
  }

  generateSessionId() {
    return `session_${Date.now()}_${crypto.randomBytes(4).toString("hex")}`;
  }

  initializeDataCollection() {
    // Create data directories
    const dirs = [
      "monitoring/data/patterns",
      "monitoring/data/commands",
      "monitoring/data/files",
      "monitoring/data/interventions",
      "monitoring/data/optimizations",
    ];

    dirs.forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });

    console.log("[AUTONOMOUS] Usage data collector initialized");
    console.log(`[AUTONOMOUS] Session ID: ${this.sessionId}`);
  }

  // Collect autonomous execution pattern data
  collectExecutionPattern(data) {
    const pattern = {
      id: this.generateId("pattern"),
      sessionId: this.sessionId,
      timestamp: Date.now(),
      project: data.project,
      taskType: data.taskType,
      complexity: data.complexity,
      duration: data.duration,
      approvalPhrase: data.approvalPhrase,
      sequentialTasks: data.sequentialTasks || 1,
      filesModified: data.filesModified || 0,
      commandsExecuted: data.commandsExecuted || 0,
      userInterventions: data.userInterventions || 0,
      success: data.success,
      errorTypes: data.errorTypes || [],
      techStack: data.techStack || [],
      autonomousDecisions: data.autonomousDecisions || [],
    };

    this.patterns.executionPatterns.push(pattern);
    this.metrics.totalDataPoints++;

    // Save pattern data
    this.saveDataPoint("patterns", pattern);

    // Analyze pattern for insights
    this.analyzeExecutionPattern(pattern);

    console.log(`[AUTONOMOUS] Execution pattern collected: ${pattern.id}`);
    return pattern.id;
  }

  // Collect command effectiveness data
  collectCommandEffectiveness(
    command,
    success,
    fallbackUsed = false,
    executionTime = 0
  ) {
    const commandData = {
      id: this.generateId("command"),
      sessionId: this.sessionId,
      timestamp: Date.now(),
      command: this.sanitizeCommand(command),
      success,
      fallbackUsed,
      executionTime,
      nonInteractiveFlags: this.extractNonInteractiveFlags(command),
      project: this.getCurrentProject(),
      context: this.getExecutionContext(),
    };

    // Update command effectiveness map
    const commandKey = this.sanitizeCommand(command);
    if (!this.patterns.commandEffectiveness.has(commandKey)) {
      this.patterns.commandEffectiveness.set(commandKey, {
        totalExecutions: 0,
        successfulExecutions: 0,
        fallbackUsage: 0,
        averageExecutionTime: 0,
        commonFlags: new Set(),
        projects: new Set(),
      });
    }

    const stats = this.patterns.commandEffectiveness.get(commandKey);
    stats.totalExecutions++;
    if (success) stats.successfulExecutions++;
    if (fallbackUsed) stats.fallbackUsage++;
    stats.averageExecutionTime =
      (stats.averageExecutionTime + executionTime) / 2;
    stats.projects.add(commandData.project);

    // Extract and track flags
    commandData.nonInteractiveFlags.forEach((flag) =>
      stats.commonFlags.add(flag)
    );

    this.saveDataPoint("commands", commandData);
    this.metrics.totalDataPoints++;

    console.log(`[AUTONOMOUS] Command effectiveness collected: ${commandKey}`);
  }

  // Collect file operation data
  collectFileOperation(
    operation,
    filePath,
    success,
    userChoice = null,
    executionTime = 0
  ) {
    const fileOp = {
      id: this.generateId("fileop"),
      sessionId: this.sessionId,
      timestamp: Date.now(),
      operation, // 'create', 'modify', 'delete'
      filePath: this.sanitizeFilePath(filePath),
      fileType: this.getFileType(filePath),
      success,
      userChoice, // 'keep changes', 'revert', null (auto-approved)
      executionTime,
      autonomous: userChoice === null,
      project: this.getCurrentProject(),
      fileSize: this.getFileSize(filePath),
    };

    this.patterns.fileOperations.push(fileOp);
    this.saveDataPoint("files", fileOp);
    this.metrics.totalDataPoints++;

    // Analyze for optimization opportunities
    this.analyzeFileOperation(fileOp);

    console.log(
      `[AUTONOMOUS] File operation collected: ${operation} ${fileOp.fileType}`
    );
  }

  // Collect user intervention data
  collectUserIntervention(
    reason,
    context,
    resolutionTime = 0,
    resolutionMethod = null
  ) {
    const intervention = {
      id: this.generateId("intervention"),
      sessionId: this.sessionId,
      timestamp: Date.now(),
      reason,
      context,
      resolutionTime,
      resolutionMethod,
      project: this.getCurrentProject(),
      taskComplexity: context.complexity || "unknown",
      preventable: this.assessPreventability(reason, context),
    };

    this.patterns.userInterventions.push(intervention);
    this.saveDataPoint("interventions", intervention);
    this.metrics.totalDataPoints++;

    // Analyze intervention for prevention strategies
    this.analyzeUserIntervention(intervention);

    console.log(`[AUTONOMOUS] User intervention collected: ${reason}`);
  }

  // Analyze execution patterns for insights
  analyzeExecutionPattern(pattern) {
    // Identify high-performing patterns
    if (
      pattern.success &&
      pattern.userInterventions === 0 &&
      pattern.duration < 300000
    ) {
      this.identifyOptimizationOpportunity({
        type: "high_performance_pattern",
        pattern: pattern,
        recommendation: "Replicate this execution pattern for similar tasks",
        impact: "high",
      });
    }

    // Identify problematic patterns
    if (!pattern.success || pattern.userInterventions > 0) {
      this.identifyOptimizationOpportunity({
        type: "problematic_pattern",
        pattern: pattern,
        recommendation: "Improve error handling and autonomous decision-making",
        impact: "medium",
      });
    }

    // Identify complexity vs performance correlation
    if (pattern.complexity > 7 && pattern.duration > 600000) {
      this.identifyOptimizationOpportunity({
        type: "complexity_optimization",
        pattern: pattern,
        recommendation:
          "Break down complex tasks into smaller autonomous units",
        impact: "high",
      });
    }
  }

  // Analyze file operations for patterns
  analyzeFileOperation(fileOp) {
    // Track autonomous vs manual file handling
    if (fileOp.autonomous && fileOp.success) {
      this.identifyOptimizationOpportunity({
        type: "successful_autonomous_file_handling",
        fileOp: fileOp,
        recommendation:
          "Autonomous file handling working well for this file type",
        impact: "low",
      });
    }

    // Identify file types requiring manual intervention
    if (!fileOp.autonomous && fileOp.userChoice === "revert") {
      this.identifyOptimizationOpportunity({
        type: "file_handling_improvement",
        fileOp: fileOp,
        recommendation: `Improve autonomous handling for ${fileOp.fileType} files`,
        impact: "medium",
      });
    }
  }

  // Analyze user interventions for prevention
  analyzeUserIntervention(intervention) {
    if (intervention.preventable) {
      this.identifyOptimizationOpportunity({
        type: "preventable_intervention",
        intervention: intervention,
        recommendation:
          "Enhance autonomous decision-making to prevent this intervention",
        impact: "high",
      });
    }
  }

  // Identify optimization opportunities
  identifyOptimizationOpportunity(opportunity) {
    opportunity.id = this.generateId("optimization");
    opportunity.timestamp = Date.now();
    opportunity.sessionId = this.sessionId;

    this.patterns.optimizationOpportunities.push(opportunity);
    this.saveDataPoint("optimizations", opportunity);
    this.metrics.optimizationsFound++;

    console.log(
      `[AUTONOMOUS] Optimization opportunity identified: ${opportunity.type}`
    );
  }

  // Generate comprehensive usage report
  generateUsageReport() {
    const report = {
      sessionId: this.sessionId,
      generatedAt: Date.now(),
      collectionPeriod: {
        start: this.collectionStartTime,
        end: Date.now(),
        duration: Date.now() - this.collectionStartTime,
      },
      summary: {
        totalDataPoints: this.metrics.totalDataPoints,
        executionPatterns: this.patterns.executionPatterns.length,
        commandsTracked: this.patterns.commandEffectiveness.size,
        fileOperations: this.patterns.fileOperations.length,
        userInterventions: this.patterns.userInterventions.length,
        optimizationOpportunities:
          this.patterns.optimizationOpportunities.length,
      },
      insights: this.generateInsights(),
      recommendations: this.generateRecommendations(),
      trends: this.analyzeTrends(),
      projectBreakdown: this.generateProjectBreakdown(),
    };

    const reportPath = path.join(
      "monitoring/reports",
      `usage_report_${Date.now()}.json`
    );
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));

    console.log(`[AUTONOMOUS] Usage report generated: ${reportPath}`);
    return report;
  }

  // Generate insights from collected data
  generateInsights() {
    const insights = [];

    // Command effectiveness insights
    const commandStats = Array.from(
      this.patterns.commandEffectiveness.entries()
    )
      .map(([cmd, stats]) => ({
        command: cmd,
        successRate: (stats.successfulExecutions / stats.totalExecutions) * 100,
        fallbackRate: (stats.fallbackUsage / stats.totalExecutions) * 100,
        avgTime: stats.averageExecutionTime,
      }))
      .sort((a, b) => b.successRate - a.successRate);

    if (commandStats.length > 0) {
      insights.push({
        type: "command_effectiveness",
        data: commandStats.slice(0, 10), // Top 10 commands
        summary: `Tracked ${
          commandStats.length
        } unique commands with average success rate of ${
          commandStats.reduce((sum, cmd) => sum + cmd.successRate, 0) /
          commandStats.length
        }%`,
      });
    }

    // File operation insights
    const fileTypeStats = this.patterns.fileOperations.reduce((acc, op) => {
      if (!acc[op.fileType]) {
        acc[op.fileType] = { total: 0, autonomous: 0, successful: 0 };
      }
      acc[op.fileType].total++;
      if (op.autonomous) acc[op.fileType].autonomous++;
      if (op.success) acc[op.fileType].successful++;
      return acc;
    }, {});

    insights.push({
      type: "file_operations",
      data: fileTypeStats,
      summary: `Processed ${
        this.patterns.fileOperations.length
      } file operations across ${Object.keys(fileTypeStats).length} file types`,
    });

    return insights;
  }

  // Generate recommendations based on data
  generateRecommendations() {
    const recommendations = [];

    // High-impact optimizations
    const highImpactOpts = this.patterns.optimizationOpportunities
      .filter((opt) => opt.impact === "high")
      .slice(0, 5);

    recommendations.push(
      ...highImpactOpts.map((opt) => ({
        priority: "high",
        type: opt.type,
        recommendation: opt.recommendation,
        expectedImpact:
          "Significant improvement in autonomous execution efficiency",
      }))
    );

    // Command optimization recommendations
    const lowSuccessCommands = Array.from(
      this.patterns.commandEffectiveness.entries()
    )
      .filter(
        ([cmd, stats]) =>
          stats.successfulExecutions / stats.totalExecutions < 0.8
      )
      .map(([cmd, stats]) => cmd);

    if (lowSuccessCommands.length > 0) {
      recommendations.push({
        priority: "medium",
        type: "command_optimization",
        recommendation: `Improve non-interactive handling for commands: ${lowSuccessCommands.join(
          ", "
        )}`,
        expectedImpact: "Reduced command failures and fallback usage",
      });
    }

    return recommendations;
  }

  // Analyze trends in the data
  analyzeTrends() {
    // Simplified trend analysis - would be more sophisticated in production
    return {
      executionSuccessRate: this.calculateSuccessRateTrend(),
      averageExecutionTime: this.calculateExecutionTimeTrend(),
      userInterventionFrequency: this.calculateInterventionTrend(),
      fileOperationAutonomy: this.calculateFileAutonomyTrend(),
    };
  }

  // Generate project-specific breakdown
  generateProjectBreakdown() {
    const projects = ["neonpro", "aegiswallet", "harmoniza-facil-agendas"];
    const breakdown = {};

    projects.forEach((project) => {
      const projectPatterns = this.patterns.executionPatterns.filter(
        (p) => p.project === project
      );
      const projectFileOps = this.patterns.fileOperations.filter(
        (f) => f.project === project
      );
      const projectInterventions = this.patterns.userInterventions.filter(
        (i) => i.project === project
      );

      breakdown[project] = {
        executions: projectPatterns.length,
        successRate:
          projectPatterns.length > 0
            ? (projectPatterns.filter((p) => p.success).length /
                projectPatterns.length) *
              100
            : 0,
        fileOperations: projectFileOps.length,
        userInterventions: projectInterventions.length,
        averageComplexity:
          projectPatterns.length > 0
            ? projectPatterns.reduce((sum, p) => sum + (p.complexity || 5), 0) /
              projectPatterns.length
            : 0,
      };
    });

    return breakdown;
  }

  // Utility methods
  generateId(prefix) {
    return `${prefix}_${Date.now()}_${crypto.randomBytes(3).toString("hex")}`;
  }

  sanitizeCommand(command) {
    // Remove sensitive information and normalize
    return command
      .replace(/--password[=\s]\S+/gi, "--password=***")
      .replace(/--token[=\s]\S+/gi, "--token=***")
      .trim();
  }

  sanitizeFilePath(filePath) {
    // Remove absolute paths and sensitive information
    return filePath.replace(/^.*[\\\/]/, "").replace(/\\/g, "/");
  }

  getFileType(filePath) {
    const ext = path.extname(filePath).toLowerCase();
    const typeMap = {
      ".js": "javascript",
      ".ts": "typescript",
      ".jsx": "react",
      ".tsx": "react-typescript",
      ".md": "markdown",
      ".json": "json",
      ".css": "css",
      ".html": "html",
      ".py": "python",
    };
    return typeMap[ext] || "other";
  }

  getFileSize(filePath) {
    try {
      return fs.statSync(filePath).size;
    } catch {
      return 0;
    }
  }

  extractNonInteractiveFlags(command) {
    const flags = [];
    const flagPatterns = [
      /--yes\b/g,
      /-y\b/g,
      /--force\b/g,
      /--assume-yes\b/g,
      /--silent\b/g,
      /--quiet\b/g,
      /--non-interactive\b/g,
    ];

    flagPatterns.forEach((pattern) => {
      const matches = command.match(pattern);
      if (matches) flags.push(...matches);
    });

    return flags;
  }

  getCurrentProject() {
    // Simplified - would detect from current working directory or context
    return "unknown";
  }

  getExecutionContext() {
    return {
      timestamp: Date.now(),
      sessionId: this.sessionId,
    };
  }

  assessPreventability(reason, context) {
    // Simplified assessment - would use ML or rule-based system
    const preventableReasons = [
      "missing dependency",
      "configuration error",
      "permission denied",
      "file not found",
    ];
    return preventableReasons.some((pr) => reason.toLowerCase().includes(pr));
  }

  calculateSuccessRateTrend() {
    // Simplified trend calculation
    const recent = this.patterns.executionPatterns.slice(-10);
    return recent.length > 0
      ? (recent.filter((p) => p.success).length / recent.length) * 100
      : 0;
  }

  calculateExecutionTimeTrend() {
    const recent = this.patterns.executionPatterns.slice(-10);
    return recent.length > 0
      ? recent.reduce((sum, p) => sum + (p.duration || 0), 0) / recent.length
      : 0;
  }

  calculateInterventionTrend() {
    const recent = this.patterns.executionPatterns.slice(-10);
    return recent.length > 0
      ? recent.reduce((sum, p) => sum + (p.userInterventions || 0), 0) /
          recent.length
      : 0;
  }

  calculateFileAutonomyTrend() {
    const recent = this.patterns.fileOperations.slice(-20);
    return recent.length > 0
      ? (recent.filter((f) => f.autonomous).length / recent.length) * 100
      : 0;
  }

  saveDataPoint(category, data) {
    const filePath = path.join("monitoring/data", category, `${data.id}.json`);
    try {
      fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
    } catch (error) {
      console.error(`[AUTONOMOUS] Failed to save data point: ${error.message}`);
    }
  }
}

// Export singleton instance
const usageDataCollector = new UsageDataCollector();

module.exports = usageDataCollector;

// CLI interface
if (require.main === module) {
  const command = process.argv[2];

  switch (command) {
    case "report":
      usageDataCollector.generateUsageReport();
      break;
    case "test":
      // Test data collection
      usageDataCollector.collectExecutionPattern({
        project: "neonpro",
        taskType: "component_creation",
        complexity: 6,
        duration: 45000,
        approvalPhrase: "YARRR!",
        success: true,
        filesModified: 3,
        commandsExecuted: 5,
      });
      break;
    default:
      console.log("Usage: node usage-data-collector.js [report|test]");
  }
}

// Export the class
module.exports = UsageDataCollector;
