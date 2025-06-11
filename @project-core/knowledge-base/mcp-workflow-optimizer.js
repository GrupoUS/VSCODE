/**
 * MCP Workflow Optimizer - GRUPO US VIBECODE V3.0
 * Sistema de otimização automática de workflow entre servidores MCP
 *
 * @version 3.0.0
 * @date 2025-01-09
 */

class MCPWorkflowOptimizer {
  constructor() {
    this.config = null;
    this.cache = new Map();
    this.metrics = {
      totalRequests: 0,
      successfulRequests: 0,
      failedRequests: 0,
      avgResponseTime: 0,
      tokenUsage: 0,
    };
    this.loadConfiguration();
  }

  /**
   * Carrega configuração otimizada do arquivo JSON
   */
  async loadConfiguration() {
    try {
      const fs = require("fs").promises;
      const configPath =
        "@project-core/knowledge-base/mcp-integration-optimized-config.json";
      const configData = await fs.readFile(configPath, "utf8");
      this.config = JSON.parse(configData).mcpIntegrationConfig;
      console.log("✅ Configuração MCP carregada com sucesso");
    } catch (error) {
      console.error("❌ Erro ao carregar configuração MCP:", error);
      this.loadFallbackConfig();
    }
  }

  /**
   * Configuração de fallback caso o arquivo principal falhe
   */
  loadFallbackConfig() {
    this.config = {
      servers: {
        "sequentialthinking-tools": { priority: 1, status: "active" },
        sequentialthinking: { priority: 2, status: "active" },
        context7: { priority: 1, status: "active" },
        "perplexity-search": { priority: 2, status: "active" },
        "web-search": { priority: 3, status: "active" },
      },
      workflowOptimization: {
        automaticTriggers: { enabled: true },
        cacheStrategy: { enabled: true, ttl: 3600 },
        fallbackChain: {
          search: ["context7", "perplexity-search", "web-search"],
          thinking: ["sequentialthinking-tools", "sequentialthinking"],
        },
      },
    };
  }

  /**
   * Analisa contexto da tarefa e determina servidor MCP ideal
   * @param {Object} taskContext - Contexto da tarefa
   * @returns {Object} Recomendação de servidor e estratégia
   */
  analyzeTaskContext(taskContext) {
    const {
      description = "",
      complexity = 5,
      confidence = 7,
      toolsNeeded = [],
      requiresDocumentation = false,
      requiresSearch = false,
    } = taskContext;

    // Análise de palavras-chave
    const keywords = description.toLowerCase();
    const analysis = {
      complexity,
      confidence,
      multipleTools: toolsNeeded.length > 1,
      needsDocumentation:
        requiresDocumentation || this.detectDocumentationNeed(keywords),
      needsSearch: requiresSearch || this.detectSearchNeed(keywords),
      urgency: this.calculateUrgency(taskContext),
    };

    return this.selectOptimalServer(analysis);
  }

  /**
   * Detecta necessidade de documentação baseado em palavras-chave
   */
  detectDocumentationNeed(text) {
    const docKeywords = [
      "documentation",
      "library",
      "framework",
      "api",
      "examples",
      "guide",
      "tutorial",
    ];
    return docKeywords.some((keyword) => text.includes(keyword));
  }

  /**
   * Detecta necessidade de pesquisa baseado em palavras-chave
   */
  detectSearchNeed(text) {
    const searchKeywords = [
      "search",
      "find",
      "lookup",
      "research",
      "investigate",
    ];
    return searchKeywords.some((keyword) => text.includes(keyword));
  }

  /**
   * Calcula urgência da tarefa
   */
  calculateUrgency(context) {
    const urgencyFactors = [
      context.deadline ? 2 : 0,
      context.priority === "high" ? 2 : context.priority === "medium" ? 1 : 0,
      context.blocking ? 2 : 0,
    ];
    return urgencyFactors.reduce((sum, factor) => sum + factor, 0);
  }

  /**
   * Seleciona servidor MCP ideal baseado na análise
   */
  selectOptimalServer(analysis) {
    const {
      complexity,
      confidence,
      multipleTools,
      needsDocumentation,
      needsSearch,
    } = analysis;

    // Regras de seleção automática
    if (complexity >= 9 || confidence <= 4) {
      return this.createRecommendation(
        "shrimp-task-manager",
        "maximum_structure",
        analysis
      );
    }

    if (needsDocumentation) {
      return this.createRecommendation(
        "context7",
        "documentation_search",
        analysis
      );
    }

    if (multipleTools || (complexity >= 4 && complexity <= 6)) {
      return this.createRecommendation(
        "sequentialthinking-tools",
        "tool_recommendations",
        analysis
      );
    }

    if (complexity <= 3 && confidence >= 8) {
      return this.createRecommendation(
        "sequentialthinking",
        "structured_analysis",
        analysis
      );
    }

    if (needsSearch) {
      return this.createRecommendation(
        "web-search",
        "general_search",
        analysis
      );
    }

    // Fallback para Sequential Thinking Tools (mais versátil)
    return this.createRecommendation(
      "sequentialthinking-tools",
      "general_purpose",
      analysis
    );
  }

  /**
   * Cria recomendação estruturada
   */
  createRecommendation(primaryServer, strategy, analysis) {
    const fallbacks = this.config.workflowOptimization.fallbackChain;

    return {
      primary: primaryServer,
      strategy,
      fallbacks: this.getFallbackChain(primaryServer),
      confidence: this.calculateRecommendationConfidence(
        primaryServer,
        analysis
      ),
      estimatedTokens: this.estimateTokenUsage(primaryServer, analysis),
      estimatedTime: this.estimateResponseTime(primaryServer),
      reasoning: this.generateReasoning(primaryServer, strategy, analysis),
    };
  }

  /**
   * Obtém cadeia de fallback para servidor
   */
  getFallbackChain(primaryServer) {
    const fallbacks = this.config.workflowOptimization.fallbackChain;

    if (primaryServer.includes("thinking")) {
      return (
        fallbacks.thinking || ["sequentialthinking-tools", "sequentialthinking"]
      );
    }
    if (
      primaryServer === "context7" ||
      primaryServer === "perplexity-search" ||
      primaryServer === "web-search"
    ) {
      return (
        fallbacks.search || ["context7", "perplexity-search", "web-search"]
      );
    }
    if (primaryServer === "shrimp-task-manager") {
      return fallbacks.taskManagement || ["shrimp-task-manager"];
    }

    return ["sequentialthinking-tools", "sequentialthinking"];
  }

  /**
   * Calcula confiança da recomendação
   */
  calculateRecommendationConfidence(server, analysis) {
    const serverConfig = this.config.servers[server];
    if (!serverConfig) return 0.5;

    let confidence = serverConfig.performance?.successRate || 0.8;

    // Ajustes baseados no contexto
    if (analysis.complexity >= 8 && server === "shrimp-task-manager")
      confidence += 0.1;
    if (analysis.needsDocumentation && server === "context7")
      confidence += 0.15;
    if (analysis.multipleTools && server === "sequentialthinking-tools")
      confidence += 0.1;

    return Math.min(confidence, 1.0);
  }

  /**
   * Estima uso de tokens
   */
  estimateTokenUsage(server, analysis) {
    const baseTokens =
      this.config.servers[server]?.performance?.avgTokens || 2000;
    const complexityMultiplier = 1 + analysis.complexity / 10;
    return Math.round(baseTokens * complexityMultiplier);
  }

  /**
   * Estima tempo de resposta
   */
  estimateResponseTime(server) {
    return this.config.servers[server]?.performance?.avgResponseTime || 60;
  }

  /**
   * Gera justificativa da recomendação
   */
  generateReasoning(server, strategy, analysis) {
    const reasons = [];

    switch (server) {
      case "sequentialthinking-tools":
        reasons.push("Recomenda ferramentas automaticamente");
        if (analysis.multipleTools)
          reasons.push("Múltiplas ferramentas necessárias");
        break;
      case "context7":
        reasons.push("Melhor para busca de documentação");
        if (analysis.needsDocumentation)
          reasons.push("Documentação necessária detectada");
        break;
      case "shrimp-task-manager":
        reasons.push("Máxima estruturação para tarefas complexas");
        if (analysis.complexity >= 9) reasons.push("Complexidade muito alta");
        break;
      case "sequentialthinking":
        reasons.push("Análise estruturada simples");
        if (analysis.confidence >= 8)
          reasons.push("Alta confiança na abordagem");
        break;
    }

    return reasons.join("; ");
  }

  /**
   * Implementa cache inteligente
   */
  getCachedResult(cacheKey) {
    if (!this.config.workflowOptimization.cacheStrategy.enabled) return null;

    const cached = this.cache.get(cacheKey);
    if (!cached) return null;

    const ttl = this.config.workflowOptimization.cacheStrategy.ttl * 1000;
    if (Date.now() - cached.timestamp > ttl) {
      this.cache.delete(cacheKey);
      return null;
    }

    return cached.data;
  }

  /**
   * Armazena resultado no cache
   */
  setCachedResult(cacheKey, data) {
    if (!this.config.workflowOptimization.cacheStrategy.enabled) return;

    this.cache.set(cacheKey, {
      data,
      timestamp: Date.now(),
    });
  }

  /**
   * Executa workflow otimizado
   */
  async executeOptimizedWorkflow(taskContext) {
    const startTime = Date.now();
    this.metrics.totalRequests++;

    try {
      // 1. Análise de contexto
      const recommendation = this.analyzeTaskContext(taskContext);

      // 2. Verificar cache
      const cacheKey = this.generateCacheKey(taskContext);
      const cachedResult = this.getCachedResult(cacheKey);
      if (cachedResult) {
        console.log("📦 Resultado obtido do cache");
        return cachedResult;
      }

      // 3. Executar com servidor primário
      let result = await this.executeWithServer(
        recommendation.primary,
        taskContext
      );

      // 4. Fallback se necessário
      if (!result.success && recommendation.fallbacks.length > 0) {
        console.log(`⚠️ Fallback ativado para ${recommendation.primary}`);
        for (const fallbackServer of recommendation.fallbacks) {
          result = await this.executeWithServer(fallbackServer, taskContext);
          if (result.success) break;
        }
      }

      // 5. Cache do resultado
      if (result.success) {
        this.setCachedResult(cacheKey, result);
      }

      // 6. Métricas
      const responseTime = Date.now() - startTime;
      this.updateMetrics(
        result.success,
        responseTime,
        recommendation.estimatedTokens
      );

      return {
        ...result,
        recommendation,
        responseTime,
        fromCache: false,
      };
    } catch (error) {
      this.metrics.failedRequests++;
      console.error("❌ Erro no workflow otimizado:", error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Simula execução com servidor específico
   */
  async executeWithServer(server, taskContext) {
    // Esta é uma simulação - na implementação real,
    // aqui seria feita a chamada para o servidor MCP específico
    console.log(`🚀 Executando com servidor: ${server}`);

    const serverConfig = this.config.servers[server];
    if (!serverConfig || serverConfig.status !== "active") {
      return { success: false, error: `Servidor ${server} não disponível` };
    }

    // Simular tempo de resposta
    await new Promise((resolve) =>
      setTimeout(resolve, serverConfig.performance?.avgResponseTime || 1000)
    );

    // Simular taxa de sucesso
    const successRate = serverConfig.performance?.successRate || 0.8;
    const success = Math.random() < successRate;

    return {
      success,
      server,
      data: success ? `Resultado de ${server}` : null,
      error: success ? null : `Falha simulada em ${server}`,
    };
  }

  /**
   * Gera chave de cache baseada no contexto
   */
  generateCacheKey(taskContext) {
    const keyData = {
      description: taskContext.description?.substring(0, 100),
      complexity: taskContext.complexity,
      toolsNeeded: taskContext.toolsNeeded?.sort(),
    };
    return Buffer.from(JSON.stringify(keyData)).toString("base64");
  }

  /**
   * Atualiza métricas de performance
   */
  updateMetrics(success, responseTime, estimatedTokens) {
    if (success) {
      this.metrics.successfulRequests++;
    } else {
      this.metrics.failedRequests++;
    }

    // Atualizar média de tempo de resposta
    const totalRequests =
      this.metrics.successfulRequests + this.metrics.failedRequests;
    this.metrics.avgResponseTime =
      (this.metrics.avgResponseTime * (totalRequests - 1) + responseTime) /
      totalRequests;

    this.metrics.tokenUsage += estimatedTokens || 0;
  }

  /**
   * Retorna métricas atuais
   */
  getMetrics() {
    const successRate =
      this.metrics.totalRequests > 0
        ? this.metrics.successfulRequests / this.metrics.totalRequests
        : 0;

    return {
      ...this.metrics,
      successRate: Math.round(successRate * 100) / 100,
      avgTokensPerRequest:
        this.metrics.totalRequests > 0
          ? Math.round(this.metrics.tokenUsage / this.metrics.totalRequests)
          : 0,
    };
  }

  /**
   * Gera relatório de performance
   */
  generatePerformanceReport() {
    const metrics = this.getMetrics();

    return {
      timestamp: new Date().toISOString(),
      metrics,
      recommendations: this.generateOptimizationRecommendations(metrics),
      serverStatus: this.getServerHealthStatus(),
    };
  }

  /**
   * Gera recomendações de otimização
   */
  generateOptimizationRecommendations(metrics) {
    const recommendations = [];

    if (metrics.successRate < 0.85) {
      recommendations.push("Considerar ajuste nos fallbacks ou health checks");
    }

    if (metrics.avgResponseTime > 60000) {
      recommendations.push(
        "Otimizar timeouts ou considerar servidores mais rápidos"
      );
    }

    if (metrics.avgTokensPerRequest > 5000) {
      recommendations.push("Implementar otimizações de token usage");
    }

    return recommendations;
  }

  /**
   * Verifica status de saúde dos servidores
   */
  getServerHealthStatus() {
    const status = {};

    for (const [serverName, config] of Object.entries(this.config.servers)) {
      status[serverName] = {
        status: config.status,
        priority: config.priority,
        lastCheck: new Date().toISOString(),
        healthy: config.status === "active",
      };
    }

    return status;
  }
}

// Exportar para uso
if (typeof module !== "undefined" && module.exports) {
  module.exports = MCPWorkflowOptimizer;
}

// Exemplo de uso
if (require.main === module) {
  const optimizer = new MCPWorkflowOptimizer();

  // Exemplo de tarefa
  const taskExample = {
    description: "Implementar autenticação Next.js 15 com Supabase",
    complexity: 6,
    confidence: 7,
    toolsNeeded: ["documentation", "examples"],
    requiresDocumentation: true,
  };

  console.log("🔍 Analisando tarefa exemplo...");
  const recommendation = optimizer.analyzeTaskContext(taskExample);
  console.log("📊 Recomendação:", JSON.stringify(recommendation, null, 2));
}
