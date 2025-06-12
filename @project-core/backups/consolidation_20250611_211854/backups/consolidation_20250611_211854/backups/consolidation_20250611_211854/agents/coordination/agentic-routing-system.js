#!/usr/bin/env node

/**
 * AGENTIC ROUTING SYSTEM V2.0 - PRAISONAI INSPIRED
 * GRUPO US VIBECODE SYSTEM - Enhanced with PraisonAI & Archon patterns
 *
 * Implements intelligent task routing to specialized agents:
 * - Dynamic decision-making in workflows
 * - Conditional task execution paths
 * - Automated process branching
 * - Intelligent workflow management
 * - Integration with BOOMERANG coordination
 */

const fs = require("fs").promises;
const path = require("path");
const crypto = require("crypto");

class AgenticRoutingSystem {
  constructor() {
    this.agentsDir = path.join(process.cwd(), "@project-core", "agents");
    this.coordinationDir = path.join(this.agentsDir, "coordination");
    this.memoryDir = path.join(process.cwd(), "@project-core", "memory");

    // Routing configuration (PraisonAI-inspired)
    this.routingConfig = {
      routingStrategies: {
        complexity_based: {
          enabled: true,
          weight: 0.4,
          thresholds: {
            simple: { min: 1, max: 2, agent: "executor" },
            medium: { min: 3, max: 4, agent: "manager" },
            complex: { min: 5, max: 6, agent: "coder" },
            advanced: { min: 7, max: 8, agent: "architect" },
            critical: { min: 9, max: 10, agent: "boomerang" },
          },
        },
        domain_expertise: {
          enabled: true,
          weight: 0.3,
          mappings: {
            frontend: ["coder", "executor"],
            backend: ["coder", "architect"],
            architecture: ["architect", "researcher"],
            research: ["researcher", "advisor"],
            management: ["manager", "boomerang"],
            optimization: ["tools_refiner", "prompt_refiner"],
            reflection: ["self_reflection", "advisor"],
          },
        },
        performance_history: {
          enabled: true,
          weight: 0.2,
          considerLastN: 10,
        },
        load_balancing: {
          enabled: true,
          weight: 0.1,
          maxConcurrentTasks: 3,
        },
      },
      workflowPatterns: {
        sequential: {
          description: "Tasks executed one after another",
          suitable_for: ["simple_tasks", "linear_workflows"],
        },
        hierarchical: {
          description: "Manager coordinates worker agents",
          suitable_for: ["complex_projects", "multi_domain_tasks"],
        },
        workflow: {
          description: "Conditional routing with decision points",
          suitable_for: ["dynamic_requirements", "adaptive_processes"],
        },
        agentic_routing: {
          description: "Dynamic LLM instance selection",
          suitable_for: ["specialized_tasks", "optimization_focused"],
        },
      },
    };

    // Agent registry with enhanced capabilities
    this.agentRegistry = {};
    this.routingHistory = [];
    this.performanceMetrics = {};

    this.initializeRoutingSystem();
  }

  async initializeRoutingSystem() {
    try {
      // Load agent registry
      await this.loadAgentRegistry();

      // Load routing history
      await this.loadRoutingHistory();

      // Load performance metrics
      await this.loadPerformanceMetrics();

      console.log("✅ Agentic Routing System V2.0 initialized successfully");
    } catch (error) {
      console.error("❌ Failed to initialize Agentic Routing System:", error);
    }
  }

  /**
   * Main routing entry point - determines optimal agent for task
   */
  async routeTask(taskContext) {
    const routingId = this.generateRoutingId();
    const timestamp = new Date().toISOString();

    console.log(`🎯 [AGENTIC ROUTING] Starting routing analysis ${routingId}`);

    try {
      // Step 1: Analyze task requirements
      const taskAnalysis = await this.analyzeTaskRequirements(taskContext);

      // Step 2: Evaluate available agents
      const agentEvaluation = await this.evaluateAvailableAgents(taskAnalysis);

      // Step 3: Apply routing strategies
      const routingDecision = await this.applyRoutingStrategies(
        taskAnalysis,
        agentEvaluation
      );

      // Step 4: Validate routing decision
      const validatedRouting = await this.validateRoutingDecision(
        routingDecision,
        taskAnalysis
      );

      // Step 5: Determine workflow pattern
      const workflowPattern = await this.determineWorkflowPattern(
        validatedRouting,
        taskAnalysis
      );

      // Step 6: Create execution plan
      const executionPlan = await this.createExecutionPlan(
        validatedRouting,
        workflowPattern,
        taskAnalysis
      );

      // Step 7: Log routing decision
      await this.logRoutingDecision({
        routingId,
        timestamp,
        taskContext,
        taskAnalysis,
        routingDecision: validatedRouting,
        workflowPattern,
        executionPlan,
      });

      console.log(
        `✅ [AGENTIC ROUTING] Routing ${routingId} completed - Agent: ${validatedRouting.primaryAgent}`
      );

      return {
        routingId,
        primaryAgent: validatedRouting.primaryAgent,
        supportingAgents: validatedRouting.supportingAgents,
        workflowPattern,
        executionPlan,
        confidence: validatedRouting.confidence,
      };
    } catch (error) {
      console.error(
        `❌ [AGENTIC ROUTING] Failed to route task ${routingId}:`,
        error
      );
      throw error;
    }
  }

  /**
   * Analyze task requirements and characteristics
   */
  async analyzeTaskRequirements(taskContext) {
    const analysis = {
      complexity: this.assessComplexity(taskContext),
      domains: this.identifyDomains(taskContext),
      requirements: this.extractRequirements(taskContext),
      constraints: this.identifyConstraints(taskContext),
      expectedDuration: this.estimateDuration(taskContext),
      resourceNeeds: this.assessResourceNeeds(taskContext),
    };

    // Enhanced analysis with pattern matching
    analysis.similarTasks = await this.findSimilarTasks(taskContext);
    analysis.riskFactors = this.identifyRiskFactors(taskContext);
    analysis.successCriteria = this.defineSuccessCriteria(taskContext);

    return analysis;
  }

  /**
   * Evaluate available agents for the task
   */
  async evaluateAvailableAgents(taskAnalysis) {
    const evaluation = {};

    for (const [agentId, agentConfig] of Object.entries(this.agentRegistry)) {
      const agentScore = await this.scoreAgentForTask(
        agentId,
        agentConfig,
        taskAnalysis
      );

      evaluation[agentId] = {
        config: agentConfig,
        suitabilityScore: agentScore.suitability,
        availabilityScore: agentScore.availability,
        performanceScore: agentScore.performance,
        overallScore: agentScore.overall,
        reasoning: agentScore.reasoning,
      };
    }

    return evaluation;
  }

  /**
   * Apply routing strategies to determine best agent
   */
  async applyRoutingStrategies(taskAnalysis, agentEvaluation) {
    const strategyResults = {};
    let totalWeight = 0;

    // Apply each enabled routing strategy
    for (const [strategyName, strategyConfig] of Object.entries(
      this.routingConfig.routingStrategies
    )) {
      if (strategyConfig.enabled) {
        const result = await this.applyStrategy(
          strategyName,
          strategyConfig,
          taskAnalysis,
          agentEvaluation
        );
        strategyResults[strategyName] = result;
        totalWeight += strategyConfig.weight;
      }
    }

    // Combine strategy results with weighted scoring
    const finalScores = {};
    for (const agentId of Object.keys(agentEvaluation)) {
      let weightedScore = 0;

      for (const [strategyName, result] of Object.entries(strategyResults)) {
        const strategyWeight =
          this.routingConfig.routingStrategies[strategyName].weight;
        const agentScore = result.agentScores[agentId] || 0;
        weightedScore += agentScore * strategyWeight;
      }

      finalScores[agentId] = weightedScore / totalWeight;
    }

    // Select primary agent and supporting agents
    const sortedAgents = Object.entries(finalScores).sort(
      ([, a], [, b]) => b - a
    );

    const primaryAgent = sortedAgents[0][0];
    const supportingAgents = sortedAgents
      .slice(1, 3)
      .map(([agentId]) => agentId);

    return {
      primaryAgent,
      supportingAgents,
      confidence: sortedAgents[0][1],
      allScores: finalScores,
      strategyResults,
    };
  }

  /**
   * Apply individual routing strategy
   */
  async applyStrategy(
    strategyName,
    strategyConfig,
    taskAnalysis,
    agentEvaluation
  ) {
    switch (strategyName) {
      case "complexity_based":
        return this.applyComplexityBasedRouting(
          strategyConfig,
          taskAnalysis,
          agentEvaluation
        );
      case "domain_expertise":
        return this.applyDomainExpertiseRouting(
          strategyConfig,
          taskAnalysis,
          agentEvaluation
        );
      case "performance_history":
        return this.applyPerformanceHistoryRouting(
          strategyConfig,
          taskAnalysis,
          agentEvaluation
        );
      case "load_balancing":
        return this.applyLoadBalancingRouting(
          strategyConfig,
          taskAnalysis,
          agentEvaluation
        );
      default:
        return {
          agentScores: {},
          reasoning: `Unknown strategy: ${strategyName}`,
        };
    }
  }

  /**
   * Complexity-based routing strategy
   */
  applyComplexityBasedRouting(strategyConfig, taskAnalysis, agentEvaluation) {
    const agentScores = {};
    const complexity = taskAnalysis.complexity;

    // Find matching complexity threshold
    let bestMatch = null;
    for (const [level, threshold] of Object.entries(
      strategyConfig.thresholds
    )) {
      if (complexity >= threshold.min && complexity <= threshold.max) {
        bestMatch = threshold;
        break;
      }
    }

    // Score agents based on complexity match
    for (const agentId of Object.keys(agentEvaluation)) {
      if (bestMatch && agentId === bestMatch.agent) {
        agentScores[agentId] = 1.0; // Perfect match
      } else {
        // Check if agent can handle this complexity
        const agentConfig = agentEvaluation[agentId].config;
        const complexityRange = agentConfig.complexity_range || [1, 10];

        if (
          complexity >= complexityRange[0] &&
          complexity <= complexityRange[1]
        ) {
          // Agent can handle it, but not optimal
          agentScores[agentId] = 0.7;
        } else {
          // Agent cannot handle this complexity
          agentScores[agentId] = 0.1;
        }
      }
    }

    return {
      agentScores,
      reasoning: `Complexity-based routing for complexity level ${complexity}`,
      bestMatch: bestMatch?.agent,
    };
  }

  /**
   * Domain expertise routing strategy
   */
  applyDomainExpertiseRouting(strategyConfig, taskAnalysis, agentEvaluation) {
    const agentScores = {};

    // Initialize all agents with base score
    for (const agentId of Object.keys(agentEvaluation)) {
      agentScores[agentId] = 0.1;
    }

    // Score based on domain expertise
    for (const domain of taskAnalysis.domains) {
      const expertAgents = strategyConfig.mappings[domain] || [];

      for (const agentId of expertAgents) {
        if (agentScores[agentId] !== undefined) {
          agentScores[agentId] += 0.8 / taskAnalysis.domains.length;
        }
      }
    }

    // Normalize scores
    const maxScore = Math.max(...Object.values(agentScores));
    if (maxScore > 0) {
      for (const agentId of Object.keys(agentScores)) {
        agentScores[agentId] = agentScores[agentId] / maxScore;
      }
    }

    return {
      agentScores,
      reasoning: `Domain expertise routing for domains: ${taskAnalysis.domains.join(
        ", "
      )}`,
      expertAgents: taskAnalysis.domains.flatMap(
        (domain) => strategyConfig.mappings[domain] || []
      ),
    };
  }

  /**
   * Performance history routing strategy
   */
  async applyPerformanceHistoryRouting(
    strategyConfig,
    taskAnalysis,
    agentEvaluation
  ) {
    const agentScores = {};

    for (const agentId of Object.keys(agentEvaluation)) {
      const performanceHistory = this.performanceMetrics[agentId] || {
        successRate: 0.5,
        averageQuality: 0.5,
        averageDuration: 1.0,
      };

      // Calculate performance score
      const performanceScore =
        performanceHistory.successRate * 0.5 +
        performanceHistory.averageQuality * 0.3 +
        (1 / performanceHistory.averageDuration) * 0.2;

      agentScores[agentId] = Math.min(performanceScore, 1.0);
    }

    return {
      agentScores,
      reasoning: `Performance history routing based on last ${strategyConfig.considerLastN} tasks`,
      metrics: this.performanceMetrics,
    };
  }

  /**
   * Load balancing routing strategy
   */
  applyLoadBalancingRouting(strategyConfig, taskAnalysis, agentEvaluation) {
    const agentScores = {};

    for (const agentId of Object.keys(agentEvaluation)) {
      // Simulate current load (in production, this would check actual agent status)
      const currentLoad = Math.random() * strategyConfig.maxConcurrentTasks;
      const loadScore = Math.max(
        0,
        (strategyConfig.maxConcurrentTasks - currentLoad) /
          strategyConfig.maxConcurrentTasks
      );

      agentScores[agentId] = loadScore;
    }

    return {
      agentScores,
      reasoning: `Load balancing routing with max ${strategyConfig.maxConcurrentTasks} concurrent tasks`,
      loadInfo: agentScores,
    };
  }

  // Helper methods
  assessComplexity(taskContext) {
    // Simplified complexity assessment
    const description = taskContext.description || "";
    const requirements = taskContext.requirements || [];

    let complexity = 5; // Base complexity

    // Adjust based on description keywords
    const complexKeywords = [
      "architecture",
      "system",
      "integration",
      "optimization",
      "refactor",
    ];
    const simpleKeywords = ["fix", "update", "simple", "quick", "basic"];

    for (const keyword of complexKeywords) {
      if (description.toLowerCase().includes(keyword)) {
        complexity += 1;
      }
    }

    for (const keyword of simpleKeywords) {
      if (description.toLowerCase().includes(keyword)) {
        complexity -= 1;
      }
    }

    // Adjust based on requirements count
    complexity += Math.min(requirements.length * 0.5, 3);

    return Math.max(1, Math.min(10, complexity));
  }

  identifyDomains(taskContext) {
    const description = taskContext.description || "";
    const domains = [];

    const domainKeywords = {
      frontend: ["ui", "component", "react", "vue", "angular", "css", "html"],
      backend: ["api", "server", "database", "auth", "middleware"],
      architecture: ["design", "pattern", "structure", "system"],
      research: ["analyze", "investigate", "study", "research"],
      management: ["plan", "coordinate", "manage", "organize"],
      optimization: ["optimize", "improve", "performance", "speed"],
      reflection: ["review", "assess", "evaluate", "reflect"],
    };

    for (const [domain, keywords] of Object.entries(domainKeywords)) {
      for (const keyword of keywords) {
        if (description.toLowerCase().includes(keyword)) {
          domains.push(domain);
          break;
        }
      }
    }

    return domains.length > 0 ? domains : ["general"];
  }

  extractRequirements(taskContext) {
    return taskContext.requirements || [];
  }

  identifyConstraints(taskContext) {
    return taskContext.constraints || [];
  }

  estimateDuration(taskContext) {
    const complexity = this.assessComplexity(taskContext);
    return complexity * 10; // minutes (simplified)
  }

  assessResourceNeeds(taskContext) {
    return {
      computational: "medium",
      memory: "medium",
      network: "low",
    };
  }

  async findSimilarTasks(taskContext) {
    // Simplified similar task finding
    return [];
  }

  identifyRiskFactors(taskContext) {
    return [];
  }

  defineSuccessCriteria(taskContext) {
    return ["task_completed", "quality_acceptable", "no_errors"];
  }

  async scoreAgentForTask(agentId, agentConfig, taskAnalysis) {
    // Simplified agent scoring
    const suitability = Math.random() * 0.5 + 0.5; // 0.5-1.0
    const availability = Math.random() * 0.3 + 0.7; // 0.7-1.0
    const performance = Math.random() * 0.4 + 0.6; // 0.6-1.0

    const overall = suitability * 0.5 + availability * 0.3 + performance * 0.2;

    return {
      suitability,
      availability,
      performance,
      overall,
      reasoning: `Agent ${agentId} scored ${overall.toFixed(3)} overall`,
    };
  }

  async validateRoutingDecision(routingDecision, taskAnalysis) {
    // Add validation logic here
    return routingDecision;
  }

  async determineWorkflowPattern(routingDecision, taskAnalysis) {
    // Determine optimal workflow pattern based on task and routing
    if (taskAnalysis.complexity <= 4) {
      return "sequential";
    } else if (taskAnalysis.domains.length > 2) {
      return "hierarchical";
    } else if (taskAnalysis.complexity >= 8) {
      return "workflow";
    } else {
      return "agentic_routing";
    }
  }

  async createExecutionPlan(routingDecision, workflowPattern, taskAnalysis) {
    return {
      pattern: workflowPattern,
      primaryAgent: routingDecision.primaryAgent,
      supportingAgents: routingDecision.supportingAgents,
      estimatedDuration: taskAnalysis.expectedDuration,
      steps: [
        { agent: routingDecision.primaryAgent, action: "analyze_and_plan" },
        { agent: routingDecision.primaryAgent, action: "execute_task" },
        { agent: "self_reflection", action: "evaluate_results" },
      ],
    };
  }

  generateRoutingId() {
    return crypto.randomBytes(6).toString("hex");
  }

  async loadAgentRegistry() {
    try {
      const registryFile = path.join(
        this.coordinationDir,
        "agent-registry.json"
      );
      const registryData = await fs.readFile(registryFile, "utf8");
      const registry = JSON.parse(registryData);
      this.agentRegistry = registry.agents || {};
    } catch (error) {
      console.warn("⚠️ Could not load agent registry, using defaults");
      this.agentRegistry = {};
    }
  }

  async loadRoutingHistory() {
    try {
      const historyFile = path.join(
        this.coordinationDir,
        "routing-history.json"
      );
      const historyData = await fs.readFile(historyFile, "utf8");
      this.routingHistory = JSON.parse(historyData);
    } catch (error) {
      this.routingHistory = [];
    }
  }

  async loadPerformanceMetrics() {
    try {
      const metricsFile = path.join(
        this.coordinationDir,
        "performance-metrics.json"
      );
      const metricsData = await fs.readFile(metricsFile, "utf8");
      this.performanceMetrics = JSON.parse(metricsData);
    } catch (error) {
      this.performanceMetrics = {};
    }
  }

  async logRoutingDecision(routingData) {
    // Add to routing history
    this.routingHistory.push(routingData);

    // Keep only last 1000 routing decisions
    if (this.routingHistory.length > 1000) {
      this.routingHistory = this.routingHistory.slice(-1000);
    }

    // Save routing history
    const historyFile = path.join(this.coordinationDir, "routing-history.json");
    await fs.writeFile(
      historyFile,
      JSON.stringify(this.routingHistory, null, 2)
    );

    // Log to console
    console.log(
      `📝 [AGENTIC ROUTING] Logged routing decision ${routingData.routingId}`
    );
  }
}

// Export for use in other modules
module.exports = AgenticRoutingSystem;

// CLI usage
if (require.main === module) {
  const routingSystem = new AgenticRoutingSystem();

  // Example usage
  const exampleTask = {
    description:
      "Create a React component with TypeScript for user authentication",
    requirements: ["TypeScript support", "Form validation", "Error handling"],
    constraints: ["Must use existing design system"],
    priority: "high",
  };

  routingSystem
    .routeTask(exampleTask)
    .then((routing) => {
      console.log("\n🎉 Routing Decision:");
      console.log(`🎯 Primary Agent: ${routing.primaryAgent}`);
      console.log(
        `🤝 Supporting Agents: ${routing.supportingAgents.join(", ")}`
      );
      console.log(`📋 Workflow Pattern: ${routing.workflowPattern}`);
      console.log(`📊 Confidence: ${(routing.confidence * 100).toFixed(1)}%`);
    })
    .catch((error) => {
      console.error("❌ Routing failed:", error);
    });
}
