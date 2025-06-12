const fs = require("fs").promises;
const path = require("path");
const EventEmitter = require("events");

/**
 * Sistema de Monitoramento de Performance do Shrimp Task Manager
 * GRUPO US VIBECODE SYSTEM V4.0
 *
 * Coleta, analisa e reporta métricas de performance em tempo real
 */

class PerformanceMetricsCollector extends EventEmitter {
  constructor(options = {}) {
    super();

    this.config = {
      metricsRetentionDays: options.metricsRetentionDays || 30,
      samplingInterval: options.samplingInterval || 1000, // 1 segundo
      alertThresholds: {
        taskCompletionRate: options.taskCompletionRateThreshold || 0.9,
        averageExecutionTime: options.averageExecutionTimeThreshold || 5000, // 5 segundos
        errorRate: options.errorRateThreshold || 0.05, // 5%
        resourceUtilization: options.resourceUtilizationThreshold || 0.8, // 80%
      },
      outputPath: options.outputPath || "@project-core/monitoring/metrics",
      ...options,
    };

    this.metrics = {
      tasks: {
        total: 0,
        completed: 0,
        failed: 0,
        inProgress: 0,
        executionTimes: [],
        complexityDistribution: {},
      },
      agents: {
        boomerang: { tasksRouted: 0, routingTime: [] },
        architect: { tasksHandled: 0, averageComplexity: 0 },
        manager: { tasksCoordinated: 0, coordinationTime: [] },
        coder: { tasksImplemented: 0, codeQuality: [] },
        executor: { tasksExecuted: 0, executionSpeed: [] },
      },
      shrimp: {
        invocations: 0,
        successfulInvocations: 0,
        averageResponseTime: 0,
        thoughtChainSteps: [],
        confidenceScores: [],
      },
      system: {
        memoryUsage: [],
        cpuUsage: [],
        activeConnections: 0,
        uptime: 0,
        errorLog: [],
      },
    };

    this.startTime = Date.now();
    this.isCollecting = false;
  }

  /**
   * Inicia a coleta de métricas
   */
  async startCollection() {
    if (this.isCollecting) {
      console.warn("Performance metrics collection is already running");
      return;
    }

    this.isCollecting = true;
    console.log("🚀 Starting performance metrics collection");

    // Inicia o loop de coleta
    this.collectionInterval = setInterval(() => {
      this.collectSystemMetrics();
    }, this.config.samplingInterval);

    // Configura limpeza de métricas antigas
    this.cleanupInterval = setInterval(() => {
      this.cleanupOldMetrics();
    }, 24 * 60 * 60 * 1000); // Diário

    this.emit("collectionStarted");
  }

  /**
   * Para a coleta de métricas
   */
  async stopCollection() {
    if (!this.isCollecting) {
      console.warn("Performance metrics collection is not running");
      return;
    }

    this.isCollecting = false;

    if (this.collectionInterval) {
      clearInterval(this.collectionInterval);
    }

    if (this.cleanupInterval) {
      clearInterval(this.cleanupInterval);
    }

    // Salva métricas finais
    await this.saveMetrics();

    console.log("⏹️ Stopped performance metrics collection");
    this.emit("collectionStopped");
  }

  /**
   * Registra execução de tarefa
   */
  recordTaskExecution(taskData) {
    const {
      taskId,
      agentId,
      complexity,
      startTime,
      endTime,
      success,
      shrimpInvolved = false,
      errorMessage = null,
    } = taskData;

    const executionTime = endTime - startTime;

    // Métricas gerais de tarefas
    this.metrics.tasks.total++;
    if (success) {
      this.metrics.tasks.completed++;
    } else {
      this.metrics.tasks.failed++;
      this.metrics.system.errorLog.push({
        timestamp: Date.now(),
        taskId,
        agentId,
        error: errorMessage,
      });
    }

    this.metrics.tasks.executionTimes.push(executionTime);

    // Distribuição de complexidade
    if (!this.metrics.tasks.complexityDistribution[complexity]) {
      this.metrics.tasks.complexityDistribution[complexity] = 0;
    }
    this.metrics.tasks.complexityDistribution[complexity]++;

    // Métricas específicas do agente
    if (this.metrics.agents[agentId]) {
      switch (agentId) {
        case "boomerang":
          this.metrics.agents.boomerang.tasksRouted++;
          this.metrics.agents.boomerang.routingTime.push(executionTime);
          break;
        case "architect":
          this.metrics.agents.architect.tasksHandled++;
          this.metrics.agents.architect.averageComplexity =
            (this.metrics.agents.architect.averageComplexity + complexity) / 2;
          break;
        case "manager":
          this.metrics.agents.manager.tasksCoordinated++;
          this.metrics.agents.manager.coordinationTime.push(executionTime);
          break;
        case "coder":
          this.metrics.agents.coder.tasksImplemented++;
          // Assumindo qualidade baseada no sucesso e tempo
          const quality = success ? Math.min(1.0, 5000 / executionTime) : 0;
          this.metrics.agents.coder.codeQuality.push(quality);
          break;
        case "executor":
          this.metrics.agents.executor.tasksExecuted++;
          this.metrics.agents.executor.executionSpeed.push(executionTime);
          break;
      }
    }

    // Métricas do Shrimp Task Manager
    if (shrimpInvolved) {
      this.metrics.shrimp.invocations++;
      if (success) {
        this.metrics.shrimp.successfulInvocations++;
      }
      this.metrics.shrimp.averageResponseTime =
        (this.metrics.shrimp.averageResponseTime + executionTime) / 2;
    }

    this.emit("taskRecorded", taskData);
    this.checkAlerts();
  }

  /**
   * Registra invocação do Shrimp Task Manager
   */
  recordShrimpInvocation(shrimpData) {
    const {
      taskId,
      thoughtChainSteps,
      confidenceScore,
      responseTime,
      success,
    } = shrimpData;

    this.metrics.shrimp.thoughtChainSteps.push(thoughtChainSteps);
    this.metrics.shrimp.confidenceScores.push(confidenceScore);

    this.emit("shrimpInvocationRecorded", shrimpData);
  }

  /**
   * Coleta métricas do sistema
   */
  collectSystemMetrics() {
    const memUsage = process.memoryUsage();
    const cpuUsage = process.cpuUsage();

    this.metrics.system.memoryUsage.push({
      timestamp: Date.now(),
      rss: memUsage.rss,
      heapUsed: memUsage.heapUsed,
      heapTotal: memUsage.heapTotal,
      external: memUsage.external,
    });

    this.metrics.system.cpuUsage.push({
      timestamp: Date.now(),
      user: cpuUsage.user,
      system: cpuUsage.system,
    });

    this.metrics.system.uptime = Date.now() - this.startTime;

    // Limita o tamanho dos arrays de métricas
    this.limitArraySize(this.metrics.system.memoryUsage, 1000);
    this.limitArraySize(this.metrics.system.cpuUsage, 1000);
  }

  /**
   * Verifica alertas de performance
   */
  checkAlerts() {
    const current = this.getCurrentMetrics();

    // Alert: Taxa de conclusão baixa
    if (
      current.taskCompletionRate <
      this.config.alertThresholds.taskCompletionRate
    ) {
      this.emit("alert", {
        type: "LOW_COMPLETION_RATE",
        message: `Task completion rate is ${(
          current.taskCompletionRate * 100
        ).toFixed(1)}% (threshold: ${(
          this.config.alertThresholds.taskCompletionRate * 100
        ).toFixed(1)}%)`,
        severity: "warning",
        value: current.taskCompletionRate,
        threshold: this.config.alertThresholds.taskCompletionRate,
      });
    }

    // Alert: Tempo de execução alto
    if (
      current.averageExecutionTime >
      this.config.alertThresholds.averageExecutionTime
    ) {
      this.emit("alert", {
        type: "HIGH_EXECUTION_TIME",
        message: `Average execution time is ${current.averageExecutionTime}ms (threshold: ${this.config.alertThresholds.averageExecutionTime}ms)`,
        severity: "warning",
        value: current.averageExecutionTime,
        threshold: this.config.alertThresholds.averageExecutionTime,
      });
    }

    // Alert: Taxa de erro alta
    if (current.errorRate > this.config.alertThresholds.errorRate) {
      this.emit("alert", {
        type: "HIGH_ERROR_RATE",
        message: `Error rate is ${(current.errorRate * 100).toFixed(
          1
        )}% (threshold: ${(this.config.alertThresholds.errorRate * 100).toFixed(
          1
        )}%)`,
        severity: "error",
        value: current.errorRate,
        threshold: this.config.alertThresholds.errorRate,
      });
    }
  }

  /**
   * Obtém métricas atuais calculadas
   */
  getCurrentMetrics() {
    const totalTasks = this.metrics.tasks.total;
    const completedTasks = this.metrics.tasks.completed;
    const failedTasks = this.metrics.tasks.failed;

    const taskCompletionRate = totalTasks > 0 ? completedTasks / totalTasks : 1;
    const errorRate = totalTasks > 0 ? failedTasks / totalTasks : 0;

    const executionTimes = this.metrics.tasks.executionTimes;
    const averageExecutionTime =
      executionTimes.length > 0
        ? executionTimes.reduce((sum, time) => sum + time, 0) /
          executionTimes.length
        : 0;

    const shrimpSuccessRate =
      this.metrics.shrimp.invocations > 0
        ? this.metrics.shrimp.successfulInvocations /
          this.metrics.shrimp.invocations
        : 1;

    return {
      taskCompletionRate,
      errorRate,
      averageExecutionTime,
      shrimpSuccessRate,
      totalTasks,
      completedTasks,
      failedTasks,
      uptime: this.metrics.system.uptime,
      shrimpInvocations: this.metrics.shrimp.invocations,
      timestamp: Date.now(),
    };
  }

  /**
   * Gera relatório de performance
   */
  generateReport() {
    const current = this.getCurrentMetrics();
    const agentMetrics = this.getAgentMetrics();

    return {
      summary: current,
      agents: agentMetrics,
      shrimp: {
        totalInvocations: this.metrics.shrimp.invocations,
        successfulInvocations: this.metrics.shrimp.successfulInvocations,
        averageResponseTime: this.metrics.shrimp.averageResponseTime,
        averageThoughtChainSteps: this.getAverage(
          this.metrics.shrimp.thoughtChainSteps
        ),
        averageConfidenceScore: this.getAverage(
          this.metrics.shrimp.confidenceScores
        ),
      },
      system: {
        uptime: this.metrics.system.uptime,
        recentErrors: this.metrics.system.errorLog.slice(-10),
        memoryUsage: this.getLatestSystemMetric("memoryUsage"),
        cpuUsage: this.getLatestSystemMetric("cpuUsage"),
      },
      complexityDistribution: this.metrics.tasks.complexityDistribution,
      generatedAt: new Date().toISOString(),
    };
  }

  /**
   * Obtém métricas dos agentes
   */
  getAgentMetrics() {
    return {
      boomerang: {
        tasksRouted: this.metrics.agents.boomerang.tasksRouted,
        averageRoutingTime: this.getAverage(
          this.metrics.agents.boomerang.routingTime
        ),
      },
      architect: {
        tasksHandled: this.metrics.agents.architect.tasksHandled,
        averageComplexity: this.metrics.agents.architect.averageComplexity,
      },
      manager: {
        tasksCoordinated: this.metrics.agents.manager.tasksCoordinated,
        averageCoordinationTime: this.getAverage(
          this.metrics.agents.manager.coordinationTime
        ),
      },
      coder: {
        tasksImplemented: this.metrics.agents.coder.tasksImplemented,
        averageCodeQuality: this.getAverage(
          this.metrics.agents.coder.codeQuality
        ),
      },
      executor: {
        tasksExecuted: this.metrics.agents.executor.tasksExecuted,
        averageExecutionSpeed: this.getAverage(
          this.metrics.agents.executor.executionSpeed
        ),
      },
    };
  }

  /**
   * Salva métricas em arquivo
   */
  async saveMetrics() {
    try {
      const report = this.generateReport();
      const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
      const filename = `metrics-${timestamp}.json`;
      const filepath = path.join(this.config.outputPath, filename);

      // Cria diretório se não existir
      await fs.mkdir(this.config.outputPath, { recursive: true });

      await fs.writeFile(filepath, JSON.stringify(report, null, 2));

      console.log(`📊 Metrics saved to ${filepath}`);
      this.emit("metricsSaved", { filepath, report });
    } catch (error) {
      console.error("❌ Error saving metrics:", error);
      this.emit("error", error);
    }
  }

  /**
   * Remove métricas antigas
   */
  async cleanupOldMetrics() {
    try {
      const files = await fs.readdir(this.config.outputPath);
      const cutoffDate =
        Date.now() - this.config.metricsRetentionDays * 24 * 60 * 60 * 1000;

      for (const file of files) {
        if (file.startsWith("metrics-") && file.endsWith(".json")) {
          const filepath = path.join(this.config.outputPath, file);
          const stats = await fs.stat(filepath);

          if (stats.mtime.getTime() < cutoffDate) {
            await fs.unlink(filepath);
            console.log(`🗑️ Removed old metrics file: ${file}`);
          }
        }
      }
    } catch (error) {
      console.error("❌ Error cleaning up old metrics:", error);
    }
  }

  /**
   * Utilitários
   */
  getAverage(array) {
    return array.length > 0
      ? array.reduce((sum, val) => sum + val, 0) / array.length
      : 0;
  }

  limitArraySize(array, maxSize) {
    if (array.length > maxSize) {
      array.splice(0, array.length - maxSize);
    }
  }

  getLatestSystemMetric(type) {
    const metrics = this.metrics.system[type];
    return metrics.length > 0 ? metrics[metrics.length - 1] : null;
  }
}

module.exports = PerformanceMetricsCollector;
