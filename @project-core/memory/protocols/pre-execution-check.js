#!/usr/bin/env node

/**
 * RAG-ENHANCED PRE-EXECUTION CHECK SYSTEM V4.1
 * GRUPO US VIBECODE SYSTEM - Phase 4A Implementation
 *
 * Enhanced memory consultation with hybrid search integration:
 * - Semantic search using embeddings
 * - Keyword-based pattern matching (existing)
 * - 100% backward compatibility with fallback mechanisms
 * - Target: +30% consultation accuracy improvement
 */

const fs = require("fs").promises;
const path = require("path");
const crypto = require("crypto");

// Import existing consultation system for backward compatibility
const MandatoryMemoryConsultation = require("./mandatory-memory-consultation.js");
const ConsultationOptimization = require("./consultation-optimization.js");

class RAGEnhancedPreExecutionCheck extends MandatoryMemoryConsultation {
  constructor() {
    super();

    // Fix path resolution - ensure we're using the correct base directory
    this.memoryDir = path.join(process.cwd(), "@project-core", "memory");
    this.cacheDir = path.join(this.memoryDir, "cache");

    // RAG Enhancement Configuration
    this.ragConfig = {
      hybridSearchEnabled: true,
      semanticSearchWeight: 0.7,
      keywordSearchWeight: 0.3,
      embeddingModel: "text-embedding-3-small", // Cost-effective option
      fallbackToLegacy: true,
      maxRetries: 3,
    };

    // Enhanced directories
    this.ragEnhancedDir = path.join(this.memoryDir, "rag-enhanced");
    this.semanticCacheDir = path.join(this.cacheDir, "semantic-cache");
    this.hybridSearchCacheDir = path.join(this.cacheDir, "hybrid-search-cache");

    // Initialize consultation optimization
    this.consultationOptimizer = new ConsultationOptimization();

    // Performance metrics
    this.performanceMetrics = {
      hybridSearchQueries: 0,
      semanticSearchHits: 0,
      fallbackToLegacy: 0,
      averageResponseTime: 0,
    };

    this.initializeRAGDirectories();
  }

  /**
   * Initialize RAG-enhanced directories
   */
  async initializeRAGDirectories() {
    const ragDirs = [
      this.ragEnhancedDir,
      this.semanticCacheDir,
      this.hybridSearchCacheDir,
      path.join(this.ragEnhancedDir, "contextual-embeddings"),
      path.join(this.ragEnhancedDir, "semantic-search"),
    ];

    for (const dir of ragDirs) {
      try {
        await fs.mkdir(dir, { recursive: true });
      } catch (error) {
        console.warn(`RAG directory creation warning: ${error.message}`);
      }
    }
  }

  /**
   * ENHANCED MANDATORY PRE-EXECUTION CONSULTATION
   * Extends parent class with hybrid search capabilities
   */
  async mandatoryPreExecutionConsultation(taskContext) {
    console.log(
      "🧠 [RAG-ENHANCED] Starting enhanced pre-execution consultation..."
    );

    const consultationId = this.generateConsultationId(taskContext);
    const startTime = Date.now();

    try {
      // Try RAG-enhanced consultation first
      if (this.ragConfig.hybridSearchEnabled) {
        const enhancedResult = await this.ragEnhancedConsultation(
          taskContext,
          consultationId
        );

        if (enhancedResult) {
          const duration = Date.now() - startTime;
          this.updatePerformanceMetrics("hybrid_success", duration);
          console.log(`✅ [RAG-ENHANCED] Completed in ${duration}ms`);
          return enhancedResult;
        }
      }

      // Fallback to legacy consultation
      console.log("⚠️ [RAG-ENHANCED] Falling back to legacy consultation...");
      this.performanceMetrics.fallbackToLegacy++;
      return await super.mandatoryPreExecutionConsultation(taskContext);
    } catch (error) {
      console.error(
        "❌ [RAG-ENHANCED] Enhanced consultation failed:",
        error.message
      );

      // Ensure fallback to legacy system
      if (this.ragConfig.fallbackToLegacy) {
        console.log("🔄 [RAG-ENHANCED] Executing fallback to legacy system...");
        this.performanceMetrics.fallbackToLegacy++;
        return await super.mandatoryPreExecutionConsultation(taskContext);
      }

      throw error;
    }
  }

  /**
   * RAG-Enhanced consultation with hybrid search
   */
  async ragEnhancedConsultation(taskContext, consultationId) {
    try {
      // 1. Load Memory Bank Context (inherited)
      const memoryContext = await this.loadMemoryBankContext();

      // 2. Enhanced Hybrid Search
      const hybridSearchResults = await this.performHybridSearch(taskContext);

      // 3. Load cached solutions (inherited)
      const cachedSolutions = await this.checkCacheForSimilarTasks(taskContext);

      // 4. Enhanced pattern matching with semantic similarity
      const enhancedPatterns = await this.enhancedPatternMatching(taskContext);

      // 5. Load relevant decisions (inherited)
      const relevantDecisions = await this.loadRelevantDecisions(taskContext);

      // 6. Apply result reranking optimization
      const rerankedResults =
        await this.consultationOptimizer.rerankedConsultation(
          taskContext,
          hybridSearchResults
        );

      // 7. Generate enhanced consultation report
      const consultationReport = await this.generateEnhancedConsultationReport({
        consultationId,
        taskContext,
        memoryContext,
        hybridSearchResults,
        rerankedResults,
        cachedSolutions,
        patternMatches: enhancedPatterns, // Fix: use correct property name for parent class
        enhancedPatterns,
        relevantDecisions,
        timestamp: new Date().toISOString(),
      });

      // 7. Log consultation
      await this.logConsultation(consultationReport);

      return consultationReport;
    } catch (error) {
      console.error(
        "❌ [RAG-ENHANCED] Hybrid search consultation failed:",
        error.message
      );
      return null; // Trigger fallback
    }
  }

  /**
   * Perform hybrid search (semantic + keyword)
   */
  async performHybridSearch(taskContext) {
    this.performanceMetrics.hybridSearchQueries++;

    try {
      // Check hybrid search cache first
      const cacheKey = this.generateHybridSearchCacheKey(taskContext);
      const cachedResult = await this.getHybridSearchCache(cacheKey);

      if (cachedResult) {
        console.log("💾 [HYBRID SEARCH] Cache hit");
        return cachedResult;
      }

      // Perform semantic search
      const semanticResults = await this.performSemanticSearch(taskContext);

      // Perform keyword search (existing method)
      const keywordResults = await this.findPatternMatches(taskContext);

      // Merge results with weighted scoring
      const hybridResults = this.mergeHybridResults(
        semanticResults,
        keywordResults
      );

      // Cache the results
      await this.cacheHybridSearchResults(cacheKey, hybridResults);

      return hybridResults;
    } catch (error) {
      console.warn(
        "⚠️ [HYBRID SEARCH] Failed, using keyword search only:",
        error.message
      );
      // Fallback to keyword search only
      return await this.findPatternMatches(taskContext);
    }
  }

  /**
   * Perform semantic search using embeddings
   */
  async performSemanticSearch(taskContext) {
    try {
      // For Phase 4A, we'll implement a simplified semantic search
      // In production, this would use actual embedding models

      const queryText = this.extractQueryText(taskContext);
      const queryEmbedding = await this.generateSimulatedEmbedding(queryText);

      // Load memory bank content for semantic comparison
      const memoryContent = await this.loadMemoryContentForSemanticSearch();

      // Calculate semantic similarities
      const semanticMatches = [];
      for (const content of memoryContent) {
        const contentEmbedding = await this.generateSimulatedEmbedding(
          content.text
        );
        const similarity = this.calculateCosineSimilarity(
          queryEmbedding,
          contentEmbedding
        );

        if (similarity > 0.6) {
          // 60% similarity threshold
          semanticMatches.push({
            content: content.text,
            source: content.source,
            similarity,
            type: "semantic",
            confidence: similarity * 0.9, // Slightly lower confidence for simulated embeddings
          });
        }
      }

      this.performanceMetrics.semanticSearchHits += semanticMatches.length;
      return semanticMatches.sort((a, b) => b.similarity - a.similarity);
    } catch (error) {
      console.warn("⚠️ [SEMANTIC SEARCH] Failed:", error.message);
      return [];
    }
  }

  /**
   * Enhanced pattern matching with semantic awareness
   */
  async enhancedPatternMatching(taskContext) {
    try {
      // Get traditional pattern matches
      const traditionalMatches = await this.findPatternMatches(taskContext);

      // Enhance with semantic context
      const enhancedMatches = traditionalMatches.map((match) => ({
        ...match,
        enhancedConfidence: this.calculateEnhancedConfidence(
          match,
          taskContext
        ),
        searchType: "hybrid",
      }));

      return enhancedMatches;
    } catch (error) {
      console.warn(
        "⚠️ [ENHANCED PATTERN MATCHING] Failed, using traditional:",
        error.message
      );
      return await this.findPatternMatches(taskContext);
    }
  }

  /**
   * Merge hybrid search results with weighted scoring
   */
  mergeHybridResults(semanticResults, keywordResults) {
    const mergedResults = [];
    const seenContent = new Set();

    // Add semantic results with weight
    for (const result of semanticResults) {
      const weightedScore =
        result.similarity * this.ragConfig.semanticSearchWeight;
      mergedResults.push({
        ...result,
        hybridScore: weightedScore,
        searchTypes: ["semantic"],
      });
      seenContent.add(result.content);
    }

    // Add keyword results with weight (avoid duplicates)
    for (const result of keywordResults) {
      const contentKey =
        result.solution || result.pattern || JSON.stringify(result);

      if (!seenContent.has(contentKey)) {
        const weightedScore =
          result.similarity * this.ragConfig.keywordSearchWeight;
        mergedResults.push({
          ...result,
          hybridScore: weightedScore,
          searchTypes: ["keyword"],
        });
      } else {
        // Boost existing result if found in both searches
        const existingResult = mergedResults.find(
          (r) => r.content === contentKey
        );
        if (existingResult) {
          existingResult.hybridScore +=
            result.similarity * this.ragConfig.keywordSearchWeight;
          existingResult.searchTypes.push("keyword");
          existingResult.boosted = true;
        }
      }
    }

    // Sort by hybrid score
    return mergedResults.sort((a, b) => b.hybridScore - a.hybridScore);
  }

  /**
   * Generate enhanced consultation report
   */
  async generateEnhancedConsultationReport(data) {
    const baseReport = await this.generateConsultationReport(data);

    // Add RAG-specific enhancements
    const enhancedReport = {
      ...baseReport,

      // RAG Enhancement Status
      ragEnhancements: {
        hybridSearchEnabled: this.ragConfig.hybridSearchEnabled,
        semanticSearchResults: data.hybridSearchResults.filter((r) =>
          r.searchTypes.includes("semantic")
        ).length,
        keywordSearchResults: data.hybridSearchResults.filter((r) =>
          r.searchTypes.includes("keyword")
        ).length,
        boostedResults: data.hybridSearchResults.filter((r) => r.boosted)
          .length,
        averageHybridScore: this.calculateAverageHybridScore(
          data.hybridSearchResults
        ),
        rerankedResults: data.rerankedResults ? data.rerankedResults.length : 0,
        rerankingMetrics: this.consultationOptimizer.getPerformanceMetrics(),
      },

      // Enhanced Pattern Matching
      enhancedPatternMatching: {
        traditionalMatches: data.enhancedPatterns.length,
        enhancedConfidenceAverage: this.calculateAverageEnhancedConfidence(
          data.enhancedPatterns
        ),
        hybridSearchIntegration: true,
      },

      // Performance Metrics
      performanceMetrics: {
        ...this.performanceMetrics,
        consultationId: data.consultationId,
      },

      // Enhanced Recommendations
      enhancedRecommendations: this.generateEnhancedRecommendations(data),
    };

    return enhancedReport;
  }

  // Utility methods for RAG enhancements
  extractQueryText(taskContext) {
    return [
      taskContext.description || "",
      taskContext.type || "",
      taskContext.technology || "",
      taskContext.requirements || "",
    ]
      .filter(Boolean)
      .join(" ");
  }

  async generateSimulatedEmbedding(text) {
    // Simplified embedding simulation for Phase 4A
    // In production, this would call actual embedding APIs
    const words = this.extractKeywords(text);
    const embedding = new Array(384).fill(0); // Simulate 384-dimensional embedding

    for (let i = 0; i < words.length && i < 384; i++) {
      const hash = crypto.createHash("md5").update(words[i]).digest("hex");
      embedding[i] = parseInt(hash.substring(0, 8), 16) / 0xffffffff;
    }

    return embedding;
  }

  calculateCosineSimilarity(embedding1, embedding2) {
    let dotProduct = 0;
    let norm1 = 0;
    let norm2 = 0;

    for (let i = 0; i < embedding1.length; i++) {
      dotProduct += embedding1[i] * embedding2[i];
      norm1 += embedding1[i] * embedding1[i];
      norm2 += embedding2[i] * embedding2[i];
    }

    return dotProduct / (Math.sqrt(norm1) * Math.sqrt(norm2));
  }

  async loadMemoryContentForSemanticSearch() {
    // Load content from memory bank for semantic search
    const content = [];

    try {
      const memoryFiles = [
        "master_rule.md",
        "self_correction_log.md",
        "global-standards.md",
        "enhanced-memory-system-architecture.md",
        "rag-enhanced-memory-system-analysis.md",
      ];

      for (const file of memoryFiles) {
        try {
          const filePath = path.join(this.memoryDir, file);
          const fileContent = await fs.readFile(filePath, "utf8");

          // Split into chunks for better semantic matching
          const chunks = this.chunkContent(fileContent, 500);
          for (const chunk of chunks) {
            content.push({
              text: chunk,
              source: file,
              type: "memory_bank",
            });
          }
        } catch (error) {
          console.warn(`⚠️ Could not load ${file} for semantic search`);
        }
      }
    } catch (error) {
      console.warn(
        "⚠️ Failed to load memory content for semantic search:",
        error.message
      );
    }

    return content;
  }

  chunkContent(content, maxLength) {
    const chunks = [];
    const paragraphs = content.split("\n\n");
    let currentChunk = "";

    for (const paragraph of paragraphs) {
      if (currentChunk.length + paragraph.length > maxLength && currentChunk) {
        chunks.push(currentChunk.trim());
        currentChunk = paragraph;
      } else {
        currentChunk += (currentChunk ? "\n\n" : "") + paragraph;
      }
    }

    if (currentChunk) {
      chunks.push(currentChunk.trim());
    }

    return chunks;
  }

  calculateEnhancedConfidence(match, taskContext) {
    // Enhance confidence based on multiple factors
    const baseConfidence = match.confidence || match.similarity || 0;
    const contextRelevance = this.calculateContextRelevance(match, taskContext);

    return baseConfidence * 0.7 + contextRelevance * 0.3;
  }

  calculateContextRelevance(match, taskContext) {
    // Simple context relevance calculation
    const matchKeywords = this.extractKeywords(
      match.solution || match.pattern || ""
    );
    const taskKeywords = this.extractKeywords(taskContext.description || "");

    return this.calculateSimilarity(matchKeywords, taskKeywords);
  }

  generateHybridSearchCacheKey(taskContext) {
    const normalizedTask = {
      description: (taskContext.description || "").toLowerCase().trim(),
      type: taskContext.type || "general",
      technology: taskContext.technology || "general",
    };
    return crypto
      .createHash("md5")
      .update(JSON.stringify(normalizedTask))
      .digest("hex");
  }

  async getHybridSearchCache(cacheKey) {
    try {
      const cacheFile = path.join(
        this.hybridSearchCacheDir,
        `${cacheKey}.json`
      );
      const cached = await fs.readFile(cacheFile, "utf8");
      const cachedData = JSON.parse(cached);

      if (this.isCacheValid(cachedData)) {
        return cachedData.results;
      }
    } catch (error) {
      // Cache miss - normal behavior
    }
    return null;
  }

  async cacheHybridSearchResults(cacheKey, results) {
    try {
      const cacheData = {
        timestamp: new Date().toISOString(),
        ttl: 1800000, // 30 minutes
        results,
      };

      const cacheFile = path.join(
        this.hybridSearchCacheDir,
        `${cacheKey}.json`
      );
      await fs.writeFile(cacheFile, JSON.stringify(cacheData, null, 2));
    } catch (error) {
      console.warn("⚠️ Failed to cache hybrid search results:", error.message);
    }
  }

  calculateAverageHybridScore(results) {
    if (results.length === 0) return 0;
    const totalScore = results.reduce(
      (sum, result) => sum + (result.hybridScore || 0),
      0
    );
    return totalScore / results.length;
  }

  calculateAverageEnhancedConfidence(patterns) {
    if (patterns.length === 0) return 0;
    const totalConfidence = patterns.reduce(
      (sum, pattern) => sum + (pattern.enhancedConfidence || 0),
      0
    );
    return totalConfidence / patterns.length;
  }

  generateEnhancedRecommendations(data) {
    const recommendations = this.generateRecommendations(data);

    // Add reranked results recommendations (highest priority)
    if (data.rerankedResults && data.rerankedResults.length > 0) {
      const topRerankedResult = data.rerankedResults[0];
      if (topRerankedResult.combinedScore > 0.8) {
        recommendations.unshift({
          type: "reranked_result",
          priority: "highest",
          message: `Top reranked result with ${Math.round(
            topRerankedResult.combinedScore * 100
          )}% combined score (cross-encoder optimized)`,
          result: topRerankedResult,
          originalScore: topRerankedResult.originalScore,
          crossEncoderScore: topRerankedResult.crossEncoderScore,
        });
      }
    }

    // Add RAG-specific recommendations
    if (data.hybridSearchResults.length > 0) {
      const topHybridResult = data.hybridSearchResults[0];
      if (topHybridResult.hybridScore > 0.8) {
        recommendations.unshift({
          type: "hybrid_search",
          priority: "high",
          message: `High-confidence hybrid search result found (${Math.round(
            topHybridResult.hybridScore * 100
          )}% score)`,
          result: topHybridResult,
          searchTypes: topHybridResult.searchTypes,
        });
      }
    }

    return recommendations;
  }

  updatePerformanceMetrics(type, duration) {
    if (type === "hybrid_success") {
      this.performanceMetrics.averageResponseTime =
        (this.performanceMetrics.averageResponseTime + duration) / 2;
    }
  }
}

module.exports = RAGEnhancedPreExecutionCheck;

// Export for direct usage
if (require.main === module) {
  const ragConsultation = new RAGEnhancedPreExecutionCheck();

  // Example usage
  const exampleTask = {
    type: "implementation",
    description:
      "Create a new React component for user authentication with enhanced security",
    technology: "React",
    complexity: "high",
    requirements: "TypeScript, Supabase integration, form validation",
  };

  ragConsultation
    .mandatoryPreExecutionConsultation(exampleTask)
    .then((report) => {
      console.log("\n📋 RAG-ENHANCED CONSULTATION REPORT:");
      console.log(JSON.stringify(report, null, 2));
    })
    .catch((error) => {
      console.error("RAG-Enhanced consultation failed:", error.message);
    });
}
