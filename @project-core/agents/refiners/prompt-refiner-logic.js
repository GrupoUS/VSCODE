/**
 * GRUPO US VIBECODE SYSTEM V4.5 - Prompt Refiner Logic
 * Agente especializado em otimização de prompts e instruções (Archon-inspired)
 *
 * @version 1.0.0
 * @author GRUPO US - VIBECODE SYSTEM
 * @date 2025-02-13
 */

const fs = require("fs").promises;
const path = require("path");
const crypto = require("crypto");

class PromptRefinerLogic {
  constructor() {
    this.configPath = path.join(__dirname, "prompt-refiner-config.json");
    this.knowledgeGraphPath = path.join(
      __dirname,
      "../../memory/knowledge_graph.json"
    );
    this.masterRulePath = path.join(__dirname, "../../memory/master_rule.md");
    this.config = null;
    this.knowledgeGraph = null;

    // Optimization patterns from config
    this.optimizationRules = [
      "use_active_voice",
      "be_specific_not_vague",
      "provide_clear_examples",
      "define_success_criteria",
      "minimize_ambiguity",
      "structure_information_hierarchically",
    ];

    // Performance metrics
    this.metrics = {
      optimizationsPerformed: 0,
      averageImprovementScore: 0,
      successRate: 0,
      processingTime: 0,
    };
  }

  /**
   * Initialize the prompt refiner with configuration
   */
  async initialize() {
    try {
      // Load configuration
      const configData = await fs.readFile(this.configPath, "utf8");
      this.config = JSON.parse(configData);

      // Load knowledge graph
      try {
        const kgData = await fs.readFile(this.knowledgeGraphPath, "utf8");
        this.knowledgeGraph = JSON.parse(kgData);
      } catch (error) {
        console.warn("⚠️ Knowledge graph not found, initializing empty...");
        this.knowledgeGraph = [];
      }

      console.log("✅ [PROMPT REFINER] Initialized successfully");
      return true;
    } catch (error) {
      console.error(
        "❌ [PROMPT REFINER] Initialization failed:",
        error.message
      );
      return false;
    }
  }

  /**
   * Analyze prompt for optimization opportunities
   * @param {string} prompt - The prompt to analyze
   * @param {object} context - Additional context for analysis
   * @returns {object} Analysis results with improvement suggestions
   */
  async analyzePrompt(prompt, context = {}) {
    const startTime = Date.now();

    try {
      const analysis = {
        originalPrompt: prompt,
        context: context,
        timestamp: new Date().toISOString(),
        analysisId: this.generateAnalysisId(prompt),
        scores: {},
        issues: [],
        suggestions: [],
        optimizationPotential: 0,
      };

      // Clarity and Specificity Analysis
      analysis.scores.clarity = this.assessClarity(prompt);
      analysis.scores.specificity = this.assessSpecificity(prompt);

      // Context Completeness Analysis
      analysis.scores.contextCompleteness = this.assessContextCompleteness(
        prompt,
        context
      );

      // Instruction Coherence Analysis
      analysis.scores.instructionCoherence =
        this.assessInstructionCoherence(prompt);

      // Bias Detection
      analysis.scores.biasScore = this.detectBias(prompt);

      // Performance Efficiency
      analysis.scores.efficiency = this.assessEfficiency(prompt);

      // Calculate overall optimization potential
      const avgScore =
        Object.values(analysis.scores).reduce((a, b) => a + b, 0) /
        Object.keys(analysis.scores).length;
      analysis.optimizationPotential = Math.max(0, 1 - avgScore);

      // Generate improvement suggestions
      analysis.suggestions = this.generateSuggestions(analysis.scores, prompt);

      // Identify specific issues
      analysis.issues = this.identifyIssues(analysis.scores, prompt);

      const processingTime = Date.now() - startTime;
      this.updateMetrics(processingTime, analysis.optimizationPotential);

      console.log(
        `🔍 [PROMPT REFINER] Analysis completed in ${processingTime}ms`
      );
      return analysis;
    } catch (error) {
      console.error("❌ [PROMPT REFINER] Analysis failed:", error.message);
      throw error;
    }
  }

  /**
   * Optimize prompt structure based on analysis
   * @param {string} prompt - Original prompt
   * @param {object} analysis - Analysis results from analyzePrompt
   * @returns {object} Optimized prompt with improvements
   */
  async optimizeStructure(prompt, analysis) {
    try {
      let optimizedPrompt = prompt;
      const improvements = [];

      // Apply optimization rules based on analysis
      if (analysis.scores.clarity < 0.7) {
        optimizedPrompt = this.improveClarityAndSpecificity(optimizedPrompt);
        improvements.push("clarity_enhancement");
      }

      if (analysis.scores.contextCompleteness < 0.8) {
        optimizedPrompt = this.enhanceContext(
          optimizedPrompt,
          analysis.context
        );
        improvements.push("context_enhancement");
      }

      if (analysis.scores.instructionCoherence < 0.7) {
        optimizedPrompt = this.improveInstructionCoherence(optimizedPrompt);
        improvements.push("instruction_coherence");
      }

      if (analysis.scores.efficiency < 0.6) {
        optimizedPrompt = this.optimizeForEfficiency(optimizedPrompt);
        improvements.push("efficiency_optimization");
      }

      // Structure information hierarchically
      optimizedPrompt = this.structureHierarchically(optimizedPrompt);
      improvements.push("hierarchical_structure");

      const optimization = {
        originalPrompt: prompt,
        optimizedPrompt: optimizedPrompt,
        improvements: improvements,
        analysisId: analysis.analysisId,
        optimizationId: this.generateOptimizationId(prompt, optimizedPrompt),
        timestamp: new Date().toISOString(),
        metrics: {
          improvementScore: this.calculateImprovementScore(
            analysis,
            optimizedPrompt
          ),
          tokenReduction: this.calculateTokenReduction(prompt, optimizedPrompt),
          clarityImprovement: this.calculateClarityImprovement(
            prompt,
            optimizedPrompt
          ),
        },
      };

      // Store optimization in knowledge graph
      await this.storeOptimizationInKnowledgeGraph(optimization);

      console.log(
        `✨ [PROMPT REFINER] Optimization completed with ${improvements.length} improvements`
      );
      return optimization;
    } catch (error) {
      console.error("❌ [PROMPT REFINER] Optimization failed:", error.message);
      throw error;
    }
  }

  /**
   * Validate compliance with GRUPO US standards
   * @param {string} prompt - Prompt to validate
   * @returns {object} Compliance validation results
   */
  async validateCompliance(prompt) {
    try {
      const validation = {
        prompt: prompt,
        timestamp: new Date().toISOString(),
        validationId: this.generateValidationId(prompt),
        compliance: {
          masterRuleCompliance: false,
          structureCompliance: false,
          qualityStandards: false,
          performanceStandards: false,
        },
        violations: [],
        recommendations: [],
        overallScore: 0,
      };

      // Check master rule compliance
      validation.compliance.masterRuleCompliance =
        await this.checkMasterRuleCompliance(prompt);

      // Check structure compliance
      validation.compliance.structureCompliance =
        this.checkStructureCompliance(prompt);

      // Check quality standards
      validation.compliance.qualityStandards =
        this.checkQualityStandards(prompt);

      // Check performance standards
      validation.compliance.performanceStandards =
        this.checkPerformanceStandards(prompt);

      // Calculate overall compliance score
      const complianceValues = Object.values(validation.compliance);
      validation.overallScore =
        complianceValues.filter(Boolean).length / complianceValues.length;

      // Generate violations and recommendations
      if (!validation.compliance.masterRuleCompliance) {
        validation.violations.push("master_rule_violation");
        validation.recommendations.push("Align with master_rule.md protocols");
      }

      if (!validation.compliance.structureCompliance) {
        validation.violations.push("structure_violation");
        validation.recommendations.push(
          "Follow hierarchical information structure"
        );
      }

      if (!validation.compliance.qualityStandards) {
        validation.violations.push("quality_violation");
        validation.recommendations.push("Improve clarity and specificity");
      }

      if (!validation.compliance.performanceStandards) {
        validation.violations.push("performance_violation");
        validation.recommendations.push("Optimize for token efficiency");
      }

      console.log(
        `✅ [PROMPT REFINER] Compliance validation completed (Score: ${(
          validation.overallScore * 100
        ).toFixed(1)}%)`
      );
      return validation;
    } catch (error) {
      console.error(
        "❌ [PROMPT REFINER] Compliance validation failed:",
        error.message
      );
      throw error;
    }
  }

  /**
   * Assess clarity of prompt
   */
  assessClarity(prompt) {
    let score = 0.5; // Base score

    // Check for clear instructions
    if (
      prompt.includes("MUST") ||
      prompt.includes("SHOULD") ||
      prompt.includes("REQUIRED")
    ) {
      score += 0.2;
    }

    // Check for specific action words
    const actionWords = [
      "analyze",
      "create",
      "implement",
      "optimize",
      "validate",
      "execute",
    ];
    if (actionWords.some((word) => prompt.toLowerCase().includes(word))) {
      score += 0.2;
    }

    // Penalize vague language
    const vaguePhrases = ["somehow", "maybe", "perhaps", "might", "could be"];
    if (vaguePhrases.some((phrase) => prompt.toLowerCase().includes(phrase))) {
      score -= 0.3;
    }

    return Math.max(0, Math.min(1, score));
  }

  /**
   * Assess specificity of prompt
   */
  assessSpecificity(prompt) {
    let score = 0.4; // Base score

    // Check for specific numbers, paths, or technical terms
    if (/\d+/.test(prompt)) score += 0.2;
    if (/@project-core/.test(prompt)) score += 0.2;
    if (/\.(js|py|md|json)/.test(prompt)) score += 0.2;

    return Math.max(0, Math.min(1, score));
  }

  /**
   * Generate analysis ID
   */
  generateAnalysisId(prompt) {
    return `analysis_${crypto
      .createHash("md5")
      .update(prompt)
      .digest("hex")
      .substring(0, 8)}_${Date.now()}`;
  }

  /**
   * Generate optimization ID
   */
  generateOptimizationId(original, optimized) {
    const combined = original + optimized;
    return `opt_${crypto
      .createHash("md5")
      .update(combined)
      .digest("hex")
      .substring(0, 8)}_${Date.now()}`;
  }

  /**
   * Generate validation ID
   */
  generateValidationId(prompt) {
    return `val_${crypto
      .createHash("md5")
      .update(prompt)
      .digest("hex")
      .substring(0, 8)}_${Date.now()}`;
  }

  /**
   * Update performance metrics
   */
  updateMetrics(processingTime, improvementScore) {
    this.metrics.optimizationsPerformed++;
    this.metrics.averageImprovementScore =
      (this.metrics.averageImprovementScore + improvementScore) / 2;
    this.metrics.processingTime =
      (this.metrics.processingTime + processingTime) / 2;
    this.metrics.successRate = Math.min(1, this.metrics.successRate + 0.01);
  }

  /**
   * Get performance metrics
   */
  getPerformanceMetrics() {
    return {
      ...this.metrics,
      timestamp: new Date().toISOString(),
      knowledgeGraphSize: this.knowledgeGraph ? this.knowledgeGraph.length : 0,
    };
  }

  // Additional helper methods
  assessContextCompleteness(prompt, context) {
    let score = 0.5;
    if (context && Object.keys(context).length > 0) score += 0.3;
    if (prompt.includes("@project-core")) score += 0.2;
    return Math.max(0, Math.min(1, score));
  }

  assessInstructionCoherence(prompt) {
    let score = 0.6;
    const sentences = prompt.split(/[.!?]+/).filter((s) => s.trim().length > 0);
    if (sentences.length > 1 && sentences.length < 10) score += 0.2;
    if (prompt.includes("1.") || prompt.includes("- ")) score += 0.2;
    return Math.max(0, Math.min(1, score));
  }

  detectBias(prompt) {
    let score = 0.8; // Start with good score
    const biasWords = ["always", "never", "all", "none", "everyone", "nobody"];
    if (biasWords.some((word) => prompt.toLowerCase().includes(word)))
      score -= 0.3;
    return Math.max(0, Math.min(1, score));
  }

  assessEfficiency(prompt) {
    let score = 0.7;
    const wordCount = prompt.split(/\s+/).length;
    if (wordCount < 50) score += 0.2;
    if (wordCount > 200) score -= 0.3;
    return Math.max(0, Math.min(1, score));
  }

  generateSuggestions(scores, prompt) {
    const suggestions = [];
    if (scores.clarity < 0.7)
      suggestions.push("Add more specific action verbs and clear instructions");
    if (scores.specificity < 0.7)
      suggestions.push(
        "Include specific file paths, numbers, or technical details"
      );
    if (scores.contextCompleteness < 0.8)
      suggestions.push("Provide more context about the task environment");
    if (scores.efficiency < 0.6)
      suggestions.push("Reduce word count while maintaining clarity");
    return suggestions;
  }

  identifyIssues(scores, prompt) {
    const issues = [];
    if (scores.clarity < 0.5)
      issues.push("Low clarity - instructions are vague");
    if (scores.biasScore < 0.6)
      issues.push("Potential bias detected in language");
    if (scores.efficiency < 0.4)
      issues.push("Prompt is too verbose or too brief");
    return issues;
  }

  improveClarityAndSpecificity(prompt) {
    return prompt
      .replace(/maybe|perhaps|might/gi, "MUST")
      .replace(/could be/gi, "IS")
      .replace(/somehow/gi, "by following these steps:");
  }

  enhanceContext(prompt, context) {
    if (!context || Object.keys(context).length === 0) {
      return `Context: Working in GRUPO US VIBECODE SYSTEM V4.5\n\n${prompt}`;
    }
    return prompt;
  }

  improveInstructionCoherence(prompt) {
    if (!prompt.includes("1.") && !prompt.includes("- ")) {
      const sentences = prompt
        .split(/[.!?]+/)
        .filter((s) => s.trim().length > 0);
      if (sentences.length > 2) {
        return sentences.map((s, i) => `${i + 1}. ${s.trim()}`).join("\n");
      }
    }
    return prompt;
  }

  optimizeForEfficiency(prompt) {
    return prompt
      .replace(/\s+/g, " ")
      .replace(/very\s+/gi, "")
      .replace(/really\s+/gi, "")
      .trim();
  }

  structureHierarchically(prompt) {
    if (!prompt.includes("#") && !prompt.includes("**")) {
      return `## Task\n\n${prompt}\n\n## Expected Output\n\nProvide structured results following GRUPO US standards.`;
    }
    return prompt;
  }

  calculateImprovementScore(analysis, optimizedPrompt) {
    return Math.min(1, analysis.optimizationPotential + 0.2);
  }

  calculateTokenReduction(original, optimized) {
    return Math.max(0, (original.length - optimized.length) / original.length);
  }

  calculateClarityImprovement(original, optimized) {
    return this.assessClarity(optimized) - this.assessClarity(original);
  }

  async storeOptimizationInKnowledgeGraph(optimization) {
    try {
      if (!this.knowledgeGraph) this.knowledgeGraph = [];

      const entry = {
        id: optimization.optimizationId,
        type: "prompt_optimization",
        timestamp: optimization.timestamp,
        context: optimization.analysisId,
        solution: {
          original: optimization.originalPrompt.substring(0, 100) + "...",
          optimized: optimization.optimizedPrompt.substring(0, 100) + "...",
          improvements: optimization.improvements,
          metrics: optimization.metrics,
        },
        confidence: optimization.metrics.improvementScore,
      };

      this.knowledgeGraph.push(entry);

      // Keep only last 100 entries to prevent bloat
      if (this.knowledgeGraph.length > 100) {
        this.knowledgeGraph = this.knowledgeGraph.slice(-100);
      }

      await fs.writeFile(
        this.knowledgeGraphPath,
        JSON.stringify(this.knowledgeGraph, null, 2)
      );
      console.log("📚 [PROMPT REFINER] Optimization stored in knowledge graph");
    } catch (error) {
      console.warn(
        "⚠️ [PROMPT REFINER] Failed to store in knowledge graph:",
        error.message
      );
    }
  }

  async checkMasterRuleCompliance(prompt) {
    try {
      const masterRule = await fs.readFile(this.masterRulePath, "utf8");
      return (
        prompt.includes("GRUPO US") ||
        prompt.includes("@project-core") ||
        masterRule.toLowerCase().includes(prompt.toLowerCase().substring(0, 50))
      );
    } catch (error) {
      return false;
    }
  }

  checkStructureCompliance(prompt) {
    return (
      prompt.includes("#") ||
      prompt.includes("**") ||
      prompt.includes("1.") ||
      prompt.includes("- ")
    );
  }

  checkQualityStandards(prompt) {
    return (
      this.assessClarity(prompt) >= 0.7 && this.assessSpecificity(prompt) >= 0.6
    );
  }

  checkPerformanceStandards(prompt) {
    return this.assessEfficiency(prompt) >= 0.6;
  }
}

module.exports = PromptRefinerLogic;
