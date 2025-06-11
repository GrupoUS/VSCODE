/**
 * GRUPO US - TaskMaster + Playwright Integration
 * Seguindo VIBECODE SYSTEM V2.0
 * Integração completa entre TaskMaster AI e Playwright Automation
 */

const PlaywrightAutomation = require("../automation/playwright-basic");
const fs = require("fs");
const path = require("path");

class TaskMasterPlaywrightIntegration {
  constructor(config = {}) {
    this.config = {
      taskmaster: {
        enabled: true,
        mode: "hybrid",
        integration: {
          playwright: true,
          mcp: true,
        },
      },
      playwright: {
        headless: false,
        timeout: 30000,
        screenshotsPath: "./screenshots",
        reportsPath: "./reports",
      },
      ...config,
    };

    this.automation = null;
    this.currentTask = null;
    this.taskHistory = [];
    this.metrics = {
      tasksExecuted: 0,
      automationTasks: 0,
      successRate: 0,
      averageExecutionTime: 0,
    };
  }

  async initialize() {
    try {
      console.log("🚀 Inicializando TaskMaster + Playwright Integration...");

      // Inicializar Playwright se habilitado
      if (this.config.taskmaster.integration.playwright) {
        this.automation = new PlaywrightAutomation();
        console.log("✅ Playwright Automation inicializado");
      }

      // Criar diretórios necessários
      this.ensureDirectories();

      // Verificar se TaskMaster está disponível
      await this.checkTaskMasterAvailability();

      console.log(
        "✅ TaskMaster + Playwright Integration inicializado com sucesso!"
      );
      return { success: true, message: "Integração inicializada" };
    } catch (error) {
      console.error("❌ Erro na inicialização:", error.message);
      return { success: false, error: error.message };
    }
  }

  ensureDirectories() {
    const dirs = [
      this.config.playwright.screenshotsPath,
      this.config.playwright.reportsPath,
      ".taskmaster/tasks",
      ".taskmaster/docs",
      ".taskmaster/templates",
    ];

    dirs.forEach((dir) => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
        console.log(`📁 Diretório criado: ${dir}`);
      }
    });
  }

  async checkTaskMasterAvailability() {
    try {
      // Verificar se TaskMaster está disponível globalmente
      const { execSync } = require("child_process");
      execSync("task-master-ai --version", { stdio: "pipe" });
      console.log("✅ TaskMaster AI disponível globalmente");
      return true;
    } catch (error) {
      console.log(
        "⚠️ TaskMaster AI não disponível via CLI, usando integração MCP"
      );
      return false;
    }
  }

  async executeAutomationTask(taskDescription, options = {}) {
    const startTime = Date.now();

    try {
      console.log(`🎯 Executando tarefa de automação: ${taskDescription}`);

      const task = {
        id: `automation_${Date.now()}`,
        description: taskDescription,
        type: "automation",
        status: "executing",
        startTime,
        options,
      };

      this.currentTask = task;
      this.metrics.tasksExecuted++;
      this.metrics.automationTasks++;

      // Inicializar browser se necessário
      if (!this.automation.browser) {
        await this.automation.init(options.browser || "chromium");
      }

      // Executar automação baseada no tipo de tarefa
      const result = await this.executeAutomationSteps(task);

      // Finalizar tarefa
      task.status = "completed";
      task.endTime = Date.now();
      task.executionTime = task.endTime - task.startTime;
      task.result = result;

      this.taskHistory.push(task);
      this.updateMetrics();

      console.log(
        `✅ Tarefa de automação concluída em ${task.executionTime}ms`
      );
      return { success: true, task, result };
    } catch (error) {
      console.error(`❌ Erro na automação: ${error.message}`);

      if (this.currentTask) {
        this.currentTask.status = "failed";
        this.currentTask.error = error.message;
        this.currentTask.endTime = Date.now();
        this.taskHistory.push(this.currentTask);
      }

      // Capturar screenshot de erro
      if (this.automation && this.automation.page) {
        await this.automation.screenshot("automation-error");
      }

      return { success: false, error: error.message };
    }
  }

  async executeAutomationSteps(task) {
    const { description, options } = task;
    const steps = this.parseTaskDescription(description);
    const results = [];

    for (const step of steps) {
      console.log(`🔄 Executando step: ${step.action}`);

      const stepResult = await this.executeStep(step, options);
      results.push(stepResult);

      // Aguardar entre steps se configurado
      if (options.stepDelay) {
        await new Promise((resolve) => setTimeout(resolve, options.stepDelay));
      }
    }

    return results;
  }

  parseTaskDescription(description) {
    // Parser simples para extrair ações da descrição
    const steps = [];

    // Detectar padrões comuns (case insensitive)
    const descLower = description.toLowerCase();
    if (descLower.includes("navegar") || descLower.includes("navigate")) {
      // Try to extract URL with or without protocol
      let urlMatch = description.match(/https?:\/\/[^\s,]+/);
      if (!urlMatch) {
        // Look for domain patterns without protocol
        urlMatch = description.match(/([a-zA-Z0-9.-]+\.[a-zA-Z]{2,}[^\s,]*)/);
        if (urlMatch) {
          urlMatch[0] = "https://" + urlMatch[0];
        }
      }
      const finalUrl = urlMatch ? urlMatch[0] : "https://example.com";
      steps.push({
        action: "navigate",
        url: finalUrl,
      });
    }

    if (descLower.includes("preencher") || descLower.includes("fill")) {
      steps.push({
        action: "fill_form_specific",
        // Use specific name-based selectors based on diagnostic results
        selectors: [
          'input[name="custname"]', // Customer name field (no type attribute)
          'input[name="custemail"]', // Customer email field (type="email")
        ],
        value: "GRUPO US Test",
      });
    }

    if (descLower.includes("clicar") || descLower.includes("click")) {
      steps.push({
        action: "click",
        selector: 'button, a, input[type="submit"]',
      });
    }

    if (descLower.includes("screenshot") || descLower.includes("capturar")) {
      steps.push({
        action: "screenshot",
        name: "task-screenshot",
      });
    }

    // Se não encontrou steps específicos, adicionar steps padrão
    if (steps.length === 0) {
      steps.push(
        { action: "navigate", url: "https://example.com" },
        { action: "screenshot", name: "default-task" }
      );
    }

    return steps;
  }

  async executeStep(step, options) {
    try {
      switch (step.action) {
        case "navigate":
          await this.automation.navigate(step.url);
          return { action: "navigate", url: step.url, success: true };

        case "fill_form":
          await this.automation.fill(step.selector, step.value);
          return {
            action: "fill_form",
            selector: step.selector,
            success: true,
          };

        case "fill_form_specific":
          const results = [];
          for (const selector of step.selectors) {
            try {
              await this.automation.fill(selector, step.value);
              results.push({ selector, success: true });
              console.log(`✅ Preenchido com sucesso: ${selector}`);
            } catch (error) {
              results.push({ selector, success: false, error: error.message });
              console.log(
                `⚠️ Falha ao preencher ${selector}: ${error.message}`
              );
            }
          }
          return {
            action: "fill_form_specific",
            results,
            success: results.some((r) => r.success),
          };

        case "click":
          await this.automation.click(step.selector);
          return { action: "click", selector: step.selector, success: true };

        case "screenshot":
          const filename = await this.automation.screenshot(step.name);
          return { action: "screenshot", filename, success: true };

        case "wait":
          await this.automation.waitForElement(step.selector);
          return { action: "wait", selector: step.selector, success: true };

        case "get_text":
          const text = await this.automation.getText(step.selector);
          return {
            action: "get_text",
            selector: step.selector,
            text,
            success: true,
          };

        default:
          console.log(`⚠️ Step não implementado: ${step.action}`);
          return {
            action: step.action,
            success: false,
            error: "Not implemented",
          };
      }
    } catch (error) {
      console.error(`❌ Erro no step ${step.action}:`, error.message);
      return { action: step.action, success: false, error: error.message };
    }
  }

  updateMetrics() {
    const completedTasks = this.taskHistory.filter(
      (t) => t.status === "completed"
    );
    const totalExecutionTime = completedTasks.reduce(
      (sum, task) => sum + (task.executionTime || 0),
      0
    );

    this.metrics.successRate =
      this.taskHistory.length > 0
        ? ((completedTasks.length / this.taskHistory.length) * 100).toFixed(2)
        : 0;

    this.metrics.averageExecutionTime =
      completedTasks.length > 0
        ? Math.round(totalExecutionTime / completedTasks.length)
        : 0;
  }

  async generateTaskMasterReport() {
    const report = {
      timestamp: new Date().toISOString(),
      project: "GRUPO US VSCODE Workspace",
      integration: "TaskMaster + Playwright",
      metrics: this.metrics,
      taskHistory: this.taskHistory.map((task) => ({
        id: task.id,
        description: task.description,
        type: task.type,
        status: task.status,
        executionTime: task.executionTime,
        startTime: task.startTime,
        endTime: task.endTime,
      })),
      recommendations: this.generateRecommendations(),
    };

    // Salvar relatório
    const reportPath = path.join(
      this.config.playwright.reportsPath,
      `taskmaster-integration-${Date.now()}.json`
    );
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));

    console.log(`📊 Relatório TaskMaster + Playwright gerado: ${reportPath}`);
    return report;
  }

  generateRecommendations() {
    const recommendations = [];

    if (this.metrics.successRate < 80) {
      recommendations.push(
        "Considere revisar os seletores CSS para melhorar a taxa de sucesso"
      );
    }

    if (this.metrics.averageExecutionTime > 30000) {
      recommendations.push(
        "Otimize os timeouts e aguardas para melhorar a performance"
      );
    }

    if (this.metrics.automationTasks < 5) {
      recommendations.push(
        "Explore mais casos de uso para automação com TaskMaster"
      );
    }

    return recommendations;
  }

  async cleanup() {
    if (this.automation) {
      await this.automation.close();
    }
    console.log("🧹 Cleanup TaskMaster + Playwright concluído");
  }

  getStatus() {
    return {
      initialized: !!this.automation,
      currentTask: this.currentTask,
      metrics: this.metrics,
      taskHistory: this.taskHistory.length,
      config: this.config,
    };
  }
}

module.exports = TaskMasterPlaywrightIntegration;
