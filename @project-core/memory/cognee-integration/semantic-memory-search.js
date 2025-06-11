/**
 * SEMANTIC MEMORY SEARCH ENGINE V5.0
 * GRUPO US VIBECODE SYSTEM - Enhanced Memory Consultation
 *
 * Integrates Cognee-style semantic search with existing memory consultation protocols
 * Provides context-aware memory retrieval and relationship-based search
 */

const fs = require("fs").promises;
const path = require("path");
const CogneeKnowledgeGraphEngine = require("./knowledge-graph-engine");

class SemanticMemorySearch {
  constructor() {
    this.memoryPath = path.resolve("@project-core/memory");
    this.knowledgeGraph = new CogneeKnowledgeGraphEngine();
    this.searchCache = new Map();
    this.searchHistory = [];
    this.initialized = false;
  }

  /**
   * Initialize semantic search engine
   */
  async initialize() {
    try {
      await this.knowledgeGraph.initialize();
      await this.loadSearchCache();
      this.initialized = true;
      console.log("🔍 Semantic Memory Search Engine initialized");
      return { success: true, message: "Semantic search ready" };
    } catch (error) {
      console.error("❌ Failed to initialize semantic search:", error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Enhanced memory search with semantic capabilities
   */
  async searchMemory(query, options = {}) {
    if (!this.initialized) {
      await this.initialize();
    }

    const searchId = this.generateSearchId(query);
    const startTime = Date.now();

    try {
      // Check cache first
      if (this.searchCache.has(searchId) && !options.forceRefresh) {
        const cached = this.searchCache.get(searchId);
        console.log(`💾 Cache hit for query: "${query}"`);
        return this.enhanceResults(cached, query);
      }

      // Perform multi-layered search
      const results = await this.performSemanticSearch(query, options);

      // Cache results
      this.cacheSearchResults(searchId, results);

      // Record search history
      this.recordSearch(query, results, Date.now() - startTime);

      console.log(
        `🔍 Semantic search completed in ${Date.now() - startTime}ms`
      );
      return this.enhanceResults(results, query);
    } catch (error) {
      console.error("❌ Semantic search error:", error);
      return {
        success: false,
        error: error.message,
        fallback: await this.fallbackSearch(query),
      };
    }
  }

  /**
   * Perform multi-layered semantic search
   */
  async performSemanticSearch(query, options) {
    const results = {
      query: query,
      timestamp: new Date().toISOString(),
      layers: {
        knowledge_graph: await this.searchKnowledgeGraph(query, options),
        memory_files: await this.searchMemoryFiles(query, options),
        cached_patterns: await this.searchCachedPatterns(query, options),
        learning_history: await this.searchLearningHistory(query, options),
      },
      insights: [],
      recommendations: [],
      confidence: 0,
    };

    // Generate insights from combined results
    results.insights = this.generateSearchInsights(results);
    results.recommendations = this.generateRecommendations(results);
    results.confidence = this.calculateSearchConfidence(results);

    return results;
  }

  /**
   * Search knowledge graph for entities and relationships
   */
  async searchKnowledgeGraph(query, options) {
    try {
      const graphResults = await this.knowledgeGraph.semanticSearch(query, {
        threshold: options.threshold || 0.3,
        maxResults: options.maxResults || 10,
      });

      return {
        entities: graphResults.entities.map((entity) => ({
          ...entity,
          source: "knowledge_graph",
          type: "entity",
        })),
        relationships: graphResults.relationships.map((rel) => ({
          ...rel,
          source: "knowledge_graph",
          type: "relationship",
        })),
        insights: graphResults.insights,
        count: graphResults.entities.length + graphResults.relationships.length,
      };
    } catch (error) {
      console.error("❌ Knowledge graph search error:", error);
      return { entities: [], relationships: [], insights: [], count: 0 };
    }
  }

  /**
   * Search memory files with enhanced context awareness
   */
  async searchMemoryFiles(query, options) {
    const results = [];
    const searchTerms = this.extractSearchTerms(query);

    try {
      const memoryFiles = await this.getMemoryFiles();

      for (const filePath of memoryFiles) {
        const fileResults = await this.searchInFile(
          filePath,
          searchTerms,
          options
        );
        if (fileResults.matches.length > 0) {
          results.push({
            file: path.basename(filePath),
            path: filePath,
            matches: fileResults.matches,
            relevance: fileResults.relevance,
            context: fileResults.context,
            source: "memory_files",
            type: "file_content",
          });
        }
      }

      // Sort by relevance
      results.sort((a, b) => b.relevance - a.relevance);

      return {
        files: results,
        count: results.length,
        totalMatches: results.reduce(
          (sum, file) => sum + file.matches.length,
          0
        ),
      };
    } catch (error) {
      console.error("❌ Memory files search error:", error);
      return { files: [], count: 0, totalMatches: 0 };
    }
  }

  /**
   * Search cached patterns and solutions
   */
  async searchCachedPatterns(query, options) {
    const results = [];

    try {
      const cacheDir = `${this.memoryPath}/cache`;
      const cacheFiles = [
        "pattern_analysis",
        "similar_solutions",
        "task_contexts",
      ];

      for (const cacheType of cacheFiles) {
        const cachePath = `${cacheDir}/${cacheType}`;
        try {
          const files = await fs.readdir(cachePath);
          for (const file of files) {
            if (file.endsWith(".json")) {
              const content = await fs.readFile(`${cachePath}/${file}`, "utf8");
              const data = JSON.parse(content);

              const relevance = this.calculateCacheRelevance(query, data);
              if (relevance > 0.3) {
                results.push({
                  type: cacheType,
                  file: file,
                  data: data,
                  relevance: relevance,
                  source: "cached_patterns",
                });
              }
            }
          }
        } catch (error) {
          // Cache directory doesn't exist or is empty
        }
      }

      results.sort((a, b) => b.relevance - a.relevance);

      return {
        patterns: results,
        count: results.length,
      };
    } catch (error) {
      console.error("❌ Cached patterns search error:", error);
      return { patterns: [], count: 0 };
    }
  }

  /**
   * Search learning history and self-correction logs
   */
  async searchLearningHistory(query, options) {
    const results = [];

    try {
      // Search self-correction log
      const selfCorrectionPath = `${this.memoryPath}/self_correction_log.md`;
      const correctionResults = await this.searchInFile(
        selfCorrectionPath,
        [query],
        options
      );

      if (correctionResults.matches.length > 0) {
        results.push({
          type: "self_correction",
          file: "self_correction_log.md",
          matches: correctionResults.matches,
          relevance: correctionResults.relevance,
          context: correctionResults.context,
          source: "learning_history",
        });
      }

      // Search learning patterns
      const learningPath = `${this.memoryPath}/learning`;
      try {
        const learningFiles = await fs.readdir(learningPath);
        for (const file of learningFiles) {
          if (file.endsWith(".json")) {
            const content = await fs.readFile(
              `${learningPath}/${file}`,
              "utf8"
            );
            const data = JSON.parse(content);

            const relevance = this.calculateLearningRelevance(query, data);
            if (relevance > 0.3) {
              results.push({
                type: "learning_pattern",
                file: file,
                data: data,
                relevance: relevance,
                source: "learning_history",
              });
            }
          }
        }
      } catch (error) {
        // Learning directory doesn't exist
      }

      return {
        history: results,
        count: results.length,
      };
    } catch (error) {
      console.error("❌ Learning history search error:", error);
      return { history: [], count: 0 };
    }
  }

  /**
   * Search within a specific file
   */
  async searchInFile(filePath, searchTerms, options) {
    try {
      const content = await fs.readFile(filePath, "utf8");
      const lines = content.split("\n");
      const matches = [];
      let relevance = 0;

      for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        const lineMatches = [];

        for (const term of searchTerms) {
          if (line.toLowerCase().includes(term.toLowerCase())) {
            lineMatches.push({
              term: term,
              line: i + 1,
              content: line.trim(),
              context: this.getLineContext(lines, i, 2),
            });
            relevance += this.calculateTermRelevance(term, line, content);
          }
        }

        if (lineMatches.length > 0) {
          matches.push(...lineMatches);
        }
      }

      return {
        matches: matches,
        relevance: Math.min(1.0, relevance),
        context: this.extractFileContext(content, searchTerms),
      };
    } catch (error) {
      return { matches: [], relevance: 0, context: "" };
    }
  }

  /**
   * Generate search insights from combined results
   */
  generateSearchInsights(results) {
    const insights = [];

    // Knowledge graph insights
    if (results.layers.knowledge_graph.count > 0) {
      insights.push({
        type: "knowledge_graph",
        message: `Found ${results.layers.knowledge_graph.count} related concepts in knowledge graph`,
        entities: results.layers.knowledge_graph.entities.slice(0, 3),
        relationships: results.layers.knowledge_graph.relationships.slice(0, 2),
      });
    }

    // Memory file insights
    if (results.layers.memory_files.count > 0) {
      const topFile = results.layers.memory_files.files[0];
      insights.push({
        type: "memory_files",
        message: `Most relevant file: ${topFile.file} (${topFile.matches.length} matches)`,
        file: topFile.file,
        relevance: topFile.relevance,
      });
    }

    // Pattern insights
    if (results.layers.cached_patterns.count > 0) {
      insights.push({
        type: "cached_patterns",
        message: `Found ${results.layers.cached_patterns.count} related patterns in cache`,
        patterns: results.layers.cached_patterns.patterns.slice(0, 2),
      });
    }

    // Learning insights
    if (results.layers.learning_history.count > 0) {
      insights.push({
        type: "learning_history",
        message: `Found relevant learning history and corrections`,
        history: results.layers.learning_history.history.slice(0, 2),
      });
    }

    return insights;
  }

  /**
   * Generate recommendations based on search results
   */
  generateRecommendations(results) {
    const recommendations = [];

    // Recommend related concepts
    const entities = results.layers.knowledge_graph.entities;
    if (entities.length > 0) {
      recommendations.push({
        type: "explore_concepts",
        message: "Explore related concepts",
        concepts: entities.slice(0, 3).map((e) => e.name),
      });
    }

    // Recommend relevant files
    const files = results.layers.memory_files.files;
    if (files.length > 1) {
      recommendations.push({
        type: "review_files",
        message: "Review related memory files",
        files: files.slice(0, 3).map((f) => f.file),
      });
    }

    // Recommend learning from history
    const history = results.layers.learning_history.history;
    if (history.length > 0) {
      recommendations.push({
        type: "learn_from_history",
        message: "Consider previous solutions and corrections",
        references: history.slice(0, 2).map((h) => h.type),
      });
    }

    return recommendations;
  }

  /**
   * Calculate overall search confidence
   */
  calculateSearchConfidence(results) {
    let confidence = 0;
    let factors = 0;

    // Knowledge graph factor
    if (results.layers.knowledge_graph.count > 0) {
      confidence += 0.3;
      factors++;
    }

    // Memory files factor
    if (results.layers.memory_files.count > 0) {
      const avgRelevance =
        results.layers.memory_files.files.reduce(
          (sum, f) => sum + f.relevance,
          0
        ) / results.layers.memory_files.files.length;
      confidence += avgRelevance * 0.4;
      factors++;
    }

    // Cached patterns factor
    if (results.layers.cached_patterns.count > 0) {
      confidence += 0.2;
      factors++;
    }

    // Learning history factor
    if (results.layers.learning_history.count > 0) {
      confidence += 0.1;
      factors++;
    }

    return factors > 0 ? Math.min(1.0, confidence) : 0;
  }

  // Utility methods
  generateSearchId(query) {
    return Buffer.from(query.toLowerCase().trim())
      .toString("base64")
      .substring(0, 16);
  }

  extractSearchTerms(query) {
    return query
      .toLowerCase()
      .split(/\s+/)
      .filter((term) => term.length > 2)
      .filter(
        (term) =>
          ![
            "the",
            "and",
            "or",
            "but",
            "in",
            "on",
            "at",
            "to",
            "for",
            "of",
            "with",
            "by",
          ].includes(term)
      );
  }

  async getMemoryFiles() {
    const files = [];
    const coreFiles = [
      "master_rule.md",
      "global-standards.md",
      "self_correction_log.md",
      "core/product-context.md",
      "core/active-context.md",
      "core/decision-log.md",
      "core/system-patterns.md",
      "protocols/proactive_error_correction_protocol.md",
      "protocols/mandatory_pre_execution_verification.md",
    ];

    for (const file of coreFiles) {
      const filePath = path.join(this.memoryPath, file);
      try {
        await fs.access(filePath);
        files.push(filePath);
      } catch (error) {
        // File doesn't exist, skip
      }
    }

    return files;
  }

  getLineContext(lines, lineIndex, contextSize) {
    const start = Math.max(0, lineIndex - contextSize);
    const end = Math.min(lines.length, lineIndex + contextSize + 1);
    return lines.slice(start, end).join("\n");
  }

  extractFileContext(content, searchTerms) {
    for (const term of searchTerms) {
      const index = content.toLowerCase().indexOf(term.toLowerCase());
      if (index !== -1) {
        const start = Math.max(0, index - 200);
        const end = Math.min(content.length, index + term.length + 200);
        return content.substring(start, end).trim();
      }
    }
    return "";
  }

  calculateTermRelevance(term, line, content) {
    let relevance = 0;

    // Exact match bonus
    if (line.toLowerCase().includes(term.toLowerCase())) {
      relevance += 0.5;
    }

    // Frequency bonus
    const frequency = (
      content.toLowerCase().match(new RegExp(term.toLowerCase(), "g")) || []
    ).length;
    relevance += Math.min(0.3, frequency * 0.05);

    // Position bonus (earlier in content = more relevant)
    const position =
      content.toLowerCase().indexOf(term.toLowerCase()) / content.length;
    relevance += (1 - position) * 0.2;

    return relevance;
  }

  calculateCacheRelevance(query, data) {
    const queryLower = query.toLowerCase();
    const dataStr = JSON.stringify(data).toLowerCase();

    let relevance = 0;
    const queryTerms = this.extractSearchTerms(query);

    for (const term of queryTerms) {
      if (dataStr.includes(term)) {
        relevance += 0.2;
      }
    }

    return Math.min(1.0, relevance);
  }

  calculateLearningRelevance(query, data) {
    return this.calculateCacheRelevance(query, data);
  }

  enhanceResults(results, query) {
    return {
      ...results,
      enhanced: true,
      searchMetadata: {
        query: query,
        timestamp: new Date().toISOString(),
        totalResults: this.countTotalResults(results),
        searchTime: results.searchTime || 0,
      },
    };
  }

  countTotalResults(results) {
    let total = 0;
    if (results.layers) {
      total += results.layers.knowledge_graph?.count || 0;
      total += results.layers.memory_files?.count || 0;
      total += results.layers.cached_patterns?.count || 0;
      total += results.layers.learning_history?.count || 0;
    }
    return total;
  }

  async fallbackSearch(query) {
    // Simple fallback search in master_rule.md
    try {
      const masterRulePath = `${this.memoryPath}/master_rule.md`;
      const content = await fs.readFile(masterRulePath, "utf8");
      const lines = content.split("\n");
      const matches = [];

      for (let i = 0; i < lines.length; i++) {
        if (lines[i].toLowerCase().includes(query.toLowerCase())) {
          matches.push({
            line: i + 1,
            content: lines[i].trim(),
            context: this.getLineContext(lines, i, 1),
          });
        }
      }

      return {
        source: "fallback",
        file: "master_rule.md",
        matches: matches,
        message: "Fallback search in master rule",
      };
    } catch (error) {
      return {
        source: "fallback",
        error: "Fallback search failed",
        message: "Unable to perform fallback search",
      };
    }
  }

  cacheSearchResults(searchId, results) {
    this.searchCache.set(searchId, {
      ...results,
      cached_at: new Date().toISOString(),
    });

    // Limit cache size
    if (this.searchCache.size > 100) {
      const firstKey = this.searchCache.keys().next().value;
      this.searchCache.delete(firstKey);
    }
  }

  recordSearch(query, results, duration) {
    this.searchHistory.push({
      query: query,
      timestamp: new Date().toISOString(),
      duration: duration,
      confidence: results.confidence,
      totalResults: this.countTotalResults(results),
    });

    // Limit history size
    if (this.searchHistory.length > 1000) {
      this.searchHistory = this.searchHistory.slice(-500);
    }
  }

  async loadSearchCache() {
    // Load search cache from file if exists
    try {
      const cachePath = `${this.memoryPath}/cache/semantic-search-cache.json`;
      const cacheData = await fs.readFile(cachePath, "utf8");
      const cache = JSON.parse(cacheData);

      Object.entries(cache).forEach(([key, value]) => {
        this.searchCache.set(key, value);
      });

      console.log(`📦 Loaded ${this.searchCache.size} cached search results`);
    } catch (error) {
      // No cache file exists, start fresh
    }
  }

  async saveSearchCache() {
    try {
      const cachePath = `${this.memoryPath}/cache/semantic-search-cache.json`;
      const cacheData = Object.fromEntries(this.searchCache);
      await fs.writeFile(cachePath, JSON.stringify(cacheData, null, 2));
      console.log("💾 Search cache saved");
    } catch (error) {
      console.error("❌ Error saving search cache:", error);
    }
  }

  getSearchStats() {
    return {
      cacheSize: this.searchCache.size,
      historySize: this.searchHistory.length,
      recentSearches: this.searchHistory.slice(-5),
      averageConfidence:
        this.searchHistory.length > 0
          ? this.searchHistory.reduce((sum, s) => sum + s.confidence, 0) /
            this.searchHistory.length
          : 0,
    };
  }
}

/**
 * MEMORY CONSOLIDATION ENGINE V1.0
 * Extends SemanticMemorySearch for intelligent memory consolidation
 * Addresses critical memory bloat in self_correction_log.md (6,094 lines)
 */
class MemoryConsolidationEngine extends SemanticMemorySearch {
  constructor() {
    super();
    this.consolidationConfig = {
      targetReduction: 0.65, // 65% reduction target
      similarityThreshold: 0.8, // High similarity for consolidation
      minPatternOccurrences: 3, // Minimum occurrences to consider pattern
      preserveEssentialThreshold: 0.9, // Preserve high-value entries
      maxConsolidatedEntries: 1000, // Maximum entries after consolidation
    };
    this.patternAnalyzer = null;
    this.consolidationMetrics = {
      originalSize: 0,
      consolidatedSize: 0,
      patternsIdentified: 0,
      redundantEntriesRemoved: 0,
      essentialEntriesPreserved: 0,
      consolidationRatio: 0,
    };
  }

  /**
   * MAIN CONSOLIDATION METHOD
   * Analyzes and consolidates self_correction_log.md
   */
  async consolidateSelfCorrectionLog() {
    console.log('🧠 [MEMORY CONSOLIDATION] Starting intelligent consolidation...');

    try {
      // Initialize pattern analyzer from existing self-improvement engine
      await this.initializePatternAnalyzer();

      // 1. Load existing self_correction_log.md (6,094 lines)
      const logContent = await this.loadSelfCorrectionLog();
      this.consolidationMetrics.originalSize = logContent.entries.length;

      // 2. Use existing semantic search to identify similar patterns
      const patterns = await this.identifyRedundantPatterns(logContent);
      this.consolidationMetrics.patternsIdentified = patterns.length;

      // 3. Leverage existing pattern recognition from self-improvement engine
      const consolidatedEntries = await this.consolidateByPattern(patterns);

      // 4. Create actionable learning templates
      const templates = await this.createLearningTemplates(consolidatedEntries);

      // 5. Generate optimized self_correction_log.md
      const optimizedLog = await this.generateOptimizedLog(templates);

      // 6. Validate consolidation quality
      const validation = await this.validateConsolidation(logContent, optimizedLog);

      if (validation.success) {
        // 7. Backup original and save optimized version
        await this.backupAndSaveOptimizedLog(optimizedLog);

        // 8. Update consolidation metrics
        this.updateConsolidationMetrics(optimizedLog);

        console.log('✅ [MEMORY CONSOLIDATION] Consolidation completed successfully');
        return {
          success: true,
          metrics: this.consolidationMetrics,
          validation: validation,
          optimizedLog: optimizedLog
        };
      } else {
        throw new Error(`Consolidation validation failed: ${validation.error}`);
      }

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Consolidation failed:', error.message);
      return {
        success: false,
        error: error.message,
        metrics: this.consolidationMetrics
      };
    }
  }

  /**
   * Initialize pattern analyzer using existing self-improvement engine
   */
  async initializePatternAnalyzer() {
    try {
      const SelfImprovementEngine = require('../learning/self-improvement-engine');
      this.patternAnalyzer = new SelfImprovementEngine();
      // The SelfImprovementEngine initializes itself in the constructor
      console.log('🔧 [MEMORY CONSOLIDATION] Pattern analyzer initialized');
    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Pattern analyzer initialization failed:', error.message);
      throw error;
    }
  }

  /**
   * Load and parse self_correction_log.md
   */
  async loadSelfCorrectionLog() {
    try {
      // Handle path resolution based on current working directory
      let logPath;
      if (process.cwd().includes('@project-core/memory')) {
        logPath = path.join(process.cwd(), 'self_correction_log.md');
      } else {
        logPath = path.join(process.cwd(), '@project-core', 'memory', 'self_correction_log.md');
      }
      const content = await fs.readFile(logPath, 'utf8');

      // Parse markdown entries
      const entries = this.parseLogEntries(content);

      console.log(`📖 [MEMORY CONSOLIDATION] Loaded ${entries.length} log entries`);

      return {
        originalContent: content,
        entries: entries,
        totalLines: content.split('\n').length,
        filePath: logPath
      };

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Failed to load self_correction_log.md:', error.message);
      throw error;
    }
  }

  /**
   * Parse markdown log entries into structured data
   */
  parseLogEntries(content) {
    const entries = [];
    const sections = content.split(/^#{1,3}\s+/m).filter(section => section.trim());

    for (let i = 0; i < sections.length; i++) {
      const section = sections[i];
      if (section.length < 50) continue; // Skip very short sections

      const entry = this.parseLogEntry(section, i);
      if (entry) {
        entries.push(entry);
      }
    }

    return entries;
  }

  /**
   * Parse individual log entry
   */
  parseLogEntry(section, index) {
    try {
      // Extract title (first line)
      const lines = section.split('\n');
      const title = lines[0].trim();

      // Extract content
      const content = lines.slice(1).join('\n').trim();

      // Extract metadata
      const metadata = this.extractEntryMetadata(content);

      // Generate keywords for similarity analysis
      const keywords = this.extractSearchTerms(content + ' ' + title);

      // Calculate entry importance
      const importance = this.calculateEntryImportance(content, metadata);

      return {
        id: `entry_${index}`,
        title: title,
        content: content,
        metadata: metadata,
        keywords: keywords,
        importance: importance,
        originalIndex: index,
        lineCount: content.split('\n').length,
        characterCount: content.length
      };

    } catch (error) {
      console.warn(`⚠️ [MEMORY CONSOLIDATION] Failed to parse entry ${index}:`, error.message);
      return null;
    }
  }

  /**
   * Extract metadata from log entry content
   */
  extractEntryMetadata(content) {
    const metadata = {
      timestamp: null,
      status: null,
      complexity: null,
      confidence: null,
      technology: [],
      errorTypes: [],
      solutionTypes: [],
      hasCommands: false,
      hasMetrics: false
    };

    // Extract timestamp
    const timestampMatch = content.match(/\[(\d{4}-\d{2}-\d{2}[T\s]\d{2}:\d{2}:\d{2}[Z]?)\]/);
    if (timestampMatch) {
      metadata.timestamp = timestampMatch[1];
    }

    // Extract status indicators
    if (content.includes('✅') || content.includes('SUCCESS')) {
      metadata.status = 'success';
    } else if (content.includes('❌') || content.includes('ERROR')) {
      metadata.status = 'error';
    } else if (content.includes('⚠️') || content.includes('WARNING')) {
      metadata.status = 'warning';
    }

    // Extract complexity indicators
    const complexityMatch = content.match(/complexity[:\s]*(\d+)/i);
    if (complexityMatch) {
      metadata.complexity = parseInt(complexityMatch[1]);
    }

    // Extract confidence indicators
    const confidenceMatch = content.match(/confidence[:\s]*(\d+)/i);
    if (confidenceMatch) {
      metadata.confidence = parseInt(confidenceMatch[1]);
    }

    // Extract technologies
    const techPatterns = [
      /react/i, /next\.?js/i, /typescript/i, /javascript/i, /node\.?js/i,
      /mcp/i, /sequential.thinking/i, /supabase/i, /playwright/i, /figma/i,
      /taskmaster/i, /cognee/i, /rag/i, /memory/i, /cache/i
    ];

    for (const pattern of techPatterns) {
      if (pattern.test(content)) {
        metadata.technology.push(pattern.source.replace(/[\/\\]/g, ''));
      }
    }

    // Check for commands
    metadata.hasCommands = /```[\s\S]*?```/.test(content) || /`[^`]+`/.test(content);

    // Check for metrics
    metadata.hasMetrics = /\d+%|\d+\/\d+|\d+ms|\d+MB/.test(content);

    return metadata;
  }

  /**
   * Calculate entry importance for preservation decisions
   */
  calculateEntryImportance(content, metadata) {
    let importance = 0.5; // Base importance

    // Status-based importance
    if (metadata.status === 'success') importance += 0.2;
    if (metadata.status === 'error') importance += 0.1;

    // Complexity-based importance
    if (metadata.complexity >= 8) importance += 0.3;
    else if (metadata.complexity >= 6) importance += 0.2;

    // Confidence-based importance
    if (metadata.confidence >= 9) importance += 0.2;
    else if (metadata.confidence >= 8) importance += 0.1;

    // Content quality indicators
    if (metadata.hasCommands) importance += 0.1;
    if (metadata.hasMetrics) importance += 0.1;
    if (content.length > 1000) importance += 0.1;

    // Technology diversity
    if (metadata.technology.length >= 3) importance += 0.1;

    // Recency (if timestamp available)
    if (metadata.timestamp) {
      const entryDate = new Date(metadata.timestamp);
      const now = new Date();
      const daysDiff = (now - entryDate) / (1000 * 60 * 60 * 24);

      if (daysDiff <= 30) importance += 0.2; // Recent entries more important
      else if (daysDiff <= 90) importance += 0.1;
    }

    return Math.min(importance, 1.0);
  }

  /**
   * Identify redundant patterns using semantic similarity
   */
  async identifyRedundantPatterns(logContent) {
    console.log('🔍 [MEMORY CONSOLIDATION] Identifying redundant patterns...');

    try {
      const patterns = [];
      const entries = logContent.entries;
      const processedEntries = new Set();

      for (let i = 0; i < entries.length; i++) {
        if (processedEntries.has(i)) continue;

        const currentEntry = entries[i];
        const similarEntries = [currentEntry];
        processedEntries.add(i);

        // Find similar entries using keyword similarity
        for (let j = i + 1; j < entries.length; j++) {
          if (processedEntries.has(j)) continue;

          const otherEntry = entries[j];
          const similarity = this.calculateKeywordSimilarity(currentEntry.keywords, otherEntry.keywords);

          if (similarity >= this.consolidationConfig.similarityThreshold) {
            similarEntries.push(otherEntry);
            processedEntries.add(j);
          }
        }

        // Create pattern if we have enough similar entries
        if (similarEntries.length >= this.consolidationConfig.minPatternOccurrences) {
          const pattern = await this.createPattern(similarEntries);
          patterns.push(pattern);
        } else {
          // Single entries that don't form patterns
          const singlePattern = await this.createSingleEntryPattern(currentEntry);
          patterns.push(singlePattern);
        }
      }

      console.log(`📊 [MEMORY CONSOLIDATION] Identified ${patterns.length} patterns`);
      return patterns;

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Pattern identification failed:', error.message);
      throw error;
    }
  }

  /**
   * Create pattern from similar entries
   */
  async createPattern(similarEntries) {
    // Sort by importance (highest first)
    similarEntries.sort((a, b) => b.importance - a.importance);

    const primaryEntry = similarEntries[0];
    const secondaryEntries = similarEntries.slice(1);

    // Extract common themes
    const commonKeywords = this.extractCommonKeywords(similarEntries);
    const commonTechnologies = this.extractCommonTechnologies(similarEntries);
    const consolidatedMetadata = this.consolidateMetadata(similarEntries);

    return {
      id: `pattern_${primaryEntry.id}`,
      type: 'consolidated_pattern',
      primaryEntry: primaryEntry,
      secondaryEntries: secondaryEntries,
      commonKeywords: commonKeywords,
      commonTechnologies: commonTechnologies,
      metadata: consolidatedMetadata,
      consolidationRatio: secondaryEntries.length / similarEntries.length,
      totalEntries: similarEntries.length,
      preservedImportance: primaryEntry.importance,
      consolidatedContent: await this.generateConsolidatedContent(primaryEntry, secondaryEntries)
    };
  }

  /**
   * Create pattern for single entry (no consolidation needed)
   */
  async createSingleEntryPattern(entry) {
    return {
      id: `single_${entry.id}`,
      type: 'single_entry',
      primaryEntry: entry,
      secondaryEntries: [],
      commonKeywords: entry.keywords,
      commonTechnologies: entry.metadata.technology,
      metadata: entry.metadata,
      consolidationRatio: 0,
      totalEntries: 1,
      preservedImportance: entry.importance,
      consolidatedContent: entry.content
    };
  }

  /**
   * Extract common keywords from similar entries
   */
  extractCommonKeywords(entries) {
    const keywordCounts = {};
    const totalEntries = entries.length;

    for (const entry of entries) {
      for (const keyword of entry.keywords) {
        keywordCounts[keyword] = (keywordCounts[keyword] || 0) + 1;
      }
    }

    // Return keywords that appear in at least 50% of entries
    const threshold = Math.ceil(totalEntries * 0.5);
    return Object.keys(keywordCounts).filter(keyword => keywordCounts[keyword] >= threshold);
  }

  /**
   * Extract common technologies from similar entries
   */
  extractCommonTechnologies(entries) {
    const techCounts = {};
    const totalEntries = entries.length;

    for (const entry of entries) {
      for (const tech of entry.metadata.technology) {
        techCounts[tech] = (techCounts[tech] || 0) + 1;
      }
    }

    // Return technologies that appear in at least 30% of entries
    const threshold = Math.ceil(totalEntries * 0.3);
    return Object.keys(techCounts).filter(tech => techCounts[tech] >= threshold);
  }

  /**
   * Consolidate metadata from similar entries
   */
  consolidateMetadata(entries) {
    const consolidated = {
      timestamps: [],
      statuses: [],
      complexities: [],
      confidences: [],
      technologies: [],
      errorTypes: [],
      solutionTypes: [],
      hasCommands: false,
      hasMetrics: false
    };

    for (const entry of entries) {
      if (entry.metadata.timestamp) consolidated.timestamps.push(entry.metadata.timestamp);
      if (entry.metadata.status) consolidated.statuses.push(entry.metadata.status);
      if (entry.metadata.complexity) consolidated.complexities.push(entry.metadata.complexity);
      if (entry.metadata.confidence) consolidated.confidences.push(entry.metadata.confidence);

      consolidated.technologies.push(...entry.metadata.technology);
      consolidated.errorTypes.push(...entry.metadata.errorTypes);
      consolidated.solutionTypes.push(...entry.metadata.solutionTypes);

      if (entry.metadata.hasCommands) consolidated.hasCommands = true;
      if (entry.metadata.hasMetrics) consolidated.hasMetrics = true;
    }

    // Calculate averages and most common values
    return {
      ...consolidated,
      avgComplexity: consolidated.complexities.length > 0 ?
        Math.round(consolidated.complexities.reduce((a, b) => a + b, 0) / consolidated.complexities.length) : null,
      avgConfidence: consolidated.confidences.length > 0 ?
        Math.round(consolidated.confidences.reduce((a, b) => a + b, 0) / consolidated.confidences.length) : null,
      mostCommonStatus: this.getMostCommon(consolidated.statuses),
      dateRange: consolidated.timestamps.length > 0 ? {
        earliest: Math.min(...consolidated.timestamps.map(t => new Date(t).getTime())),
        latest: Math.max(...consolidated.timestamps.map(t => new Date(t).getTime()))
      } : null
    };
  }

  /**
   * Generate consolidated content from primary and secondary entries
   */
  async generateConsolidatedContent(primaryEntry, secondaryEntries) {
    if (secondaryEntries.length === 0) {
      return primaryEntry.content;
    }

    // Start with primary entry content
    let consolidatedContent = `## ${primaryEntry.title}\n\n${primaryEntry.content}`;

    // Add consolidated insights from secondary entries
    if (secondaryEntries.length > 0) {
      consolidatedContent += '\n\n### 📚 Consolidated Learnings from Similar Cases:\n\n';

      const uniqueInsights = this.extractUniqueInsights(secondaryEntries);
      for (const insight of uniqueInsights.slice(0, 5)) { // Limit to top 5 insights
        consolidatedContent += `- ${insight}\n`;
      }

      consolidatedContent += `\n**Note**: This entry consolidates ${secondaryEntries.length + 1} similar cases for memory efficiency.\n`;
    }

    return consolidatedContent;
  }

  /**
   * Extract unique insights from secondary entries
   */
  extractUniqueInsights(entries) {
    const insights = new Set();

    for (const entry of entries) {
      // Extract key learnings, solutions, and patterns
      const content = entry.content;

      // Look for bullet points with learnings
      const bulletMatches = content.match(/^[\s]*[-*•]\s*(.+)$/gm);
      if (bulletMatches) {
        for (const match of bulletMatches) {
          const insight = match.replace(/^[\s]*[-*•]\s*/, '').trim();
          if (insight.length > 20 && insight.length < 200) {
            insights.add(insight);
          }
        }
      }

      // Look for numbered learnings
      const numberedMatches = content.match(/^\d+\.\s*(.+)$/gm);
      if (numberedMatches) {
        for (const match of numberedMatches) {
          const insight = match.replace(/^\d+\.\s*/, '').trim();
          if (insight.length > 20 && insight.length < 200) {
            insights.add(insight);
          }
        }
      }

      // Extract solution patterns
      const solutionMatches = content.match(/(?:solução|solution|fix|correção)[:\s]*(.+?)(?:\n|$)/gi);
      if (solutionMatches) {
        for (const match of solutionMatches) {
          const solution = match.replace(/(?:solução|solution|fix|correção)[:\s]*/gi, '').trim();
          if (solution.length > 20 && solution.length < 200) {
            insights.add(solution);
          }
        }
      }
    }

    return Array.from(insights);
  }

  /**
   * Get most common value from array
   */
  getMostCommon(arr) {
    if (arr.length === 0) return null;

    const counts = {};
    for (const item of arr) {
      counts[item] = (counts[item] || 0) + 1;
    }

    return Object.keys(counts).reduce((a, b) => counts[a] > counts[b] ? a : b);
  }

  /**
   * Consolidate patterns by merging similar ones
   */
  async consolidateByPattern(patterns) {
    console.log('🔄 [MEMORY CONSOLIDATION] Consolidating by pattern...');

    try {
      const consolidatedEntries = [];

      for (const pattern of patterns) {
        // Apply consolidation rules based on pattern type and importance
        if (pattern.type === 'consolidated_pattern') {
          // Keep consolidated patterns as they already reduce redundancy
          consolidatedEntries.push(pattern);
        } else if (pattern.type === 'single_entry') {
          // Evaluate single entries for preservation
          if (pattern.preservedImportance >= this.consolidationConfig.preserveEssentialThreshold) {
            // High-importance entries are always preserved
            consolidatedEntries.push(pattern);
          } else if (pattern.primaryEntry.metadata.hasCommands || pattern.primaryEntry.metadata.hasMetrics) {
            // Entries with commands or metrics are valuable
            consolidatedEntries.push(pattern);
          } else if (pattern.primaryEntry.characterCount > 500) {
            // Substantial entries are likely valuable
            consolidatedEntries.push(pattern);
          }
          // Low-importance, short entries without commands/metrics are filtered out
        }
      }

      // Sort by importance and limit total entries
      consolidatedEntries.sort((a, b) => b.preservedImportance - a.preservedImportance);
      const finalEntries = consolidatedEntries.slice(0, this.consolidationConfig.maxConsolidatedEntries);

      console.log(`📊 [MEMORY CONSOLIDATION] Consolidated to ${finalEntries.length} entries`);
      return finalEntries;

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Pattern consolidation failed:', error.message);
      throw error;
    }
  }

  /**
   * Create actionable learning templates
   */
  async createLearningTemplates(consolidatedEntries) {
    console.log('📝 [MEMORY CONSOLIDATION] Creating learning templates...');

    try {
      const templates = {
        header: this.generateLogHeader(),
        sections: [],
        footer: this.generateLogFooter(),
        metadata: {
          originalEntries: this.consolidationMetrics.originalSize,
          consolidatedEntries: consolidatedEntries.length,
          consolidationRatio: (1 - consolidatedEntries.length / this.consolidationMetrics.originalSize) * 100,
          generatedAt: new Date().toISOString()
        }
      };

      // Group entries by technology/category for better organization
      const groupedEntries = this.groupEntriesByCategory(consolidatedEntries);

      for (const [category, entries] of Object.entries(groupedEntries)) {
        const section = {
          category: category,
          entries: entries.map(entry => this.formatEntryForTemplate(entry)),
          entryCount: entries.length
        };
        templates.sections.push(section);
      }

      console.log(`📚 [MEMORY CONSOLIDATION] Created ${templates.sections.length} learning sections`);
      return templates;

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Template creation failed:', error.message);
      throw error;
    }
  }

  /**
   * Generate optimized log header
   */
  generateLogHeader() {
    return `# Log de Auto-Correção e Aprendizado - Versão Consolidada

Este arquivo foi otimizado através do Memory Consolidation Engine V1.0 para reduzir redundância
e preservar apenas os aprendizados essenciais para evolução contínua.

**Consolidação realizada em**: ${new Date().toISOString()}
**Redução de tamanho**: ${Math.round(this.consolidationConfig.targetReduction * 100)}% (target)
**Algoritmo**: Semantic Pattern Recognition + Importance-Based Filtering

---

`;
  }

  /**
   * Generate optimized log footer
   */
  generateLogFooter() {
    return `

---

## 📊 Métricas de Consolidação

- **Entradas originais**: ${this.consolidationMetrics.originalSize}
- **Entradas consolidadas**: ${this.consolidationMetrics.consolidatedSize}
- **Padrões identificados**: ${this.consolidationMetrics.patternsIdentified}
- **Entradas redundantes removidas**: ${this.consolidationMetrics.redundantEntriesRemoved}
- **Entradas essenciais preservadas**: ${this.consolidationMetrics.essentialEntriesPreserved}
- **Taxa de consolidação**: ${this.consolidationMetrics.consolidationRatio.toFixed(1)}%

## 🧠 Memory Consolidation Engine V1.0

Este sistema de consolidação inteligente:
- ✅ Identifica padrões redundantes usando análise semântica
- ✅ Preserva aprendizados essenciais baseado em importância
- ✅ Consolida entradas similares mantendo valor informacional
- ✅ Reduz bloat de memória sem perda de conhecimento crítico
- ✅ Integra com Enhanced Memory System V4.0

**Próxima consolidação recomendada**: ${new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]}

`;
  }

  /**
   * Group entries by category for better organization
   */
  groupEntriesByCategory(entries) {
    const groups = {
      'MCP Integration': [],
      'Sequential Thinking': [],
      'Memory System': [],
      'Performance Optimization': [],
      'Error Resolution': [],
      'System Architecture': [],
      'General Learning': []
    };

    for (const entry of entries) {
      let category = 'General Learning';

      const keywords = entry.commonKeywords.join(' ').toLowerCase();
      const technologies = entry.commonTechnologies.join(' ').toLowerCase();
      const content = entry.consolidatedContent.toLowerCase();

      if (keywords.includes('mcp') || technologies.includes('mcp') || content.includes('mcp')) {
        category = 'MCP Integration';
      } else if (keywords.includes('sequential') || content.includes('sequential thinking')) {
        category = 'Sequential Thinking';
      } else if (keywords.includes('memory') || keywords.includes('cache') || content.includes('memory system')) {
        category = 'Memory System';
      } else if (keywords.includes('performance') || keywords.includes('optimization') || content.includes('api reduction')) {
        category = 'Performance Optimization';
      } else if (entry.metadata.mostCommonStatus === 'error' || content.includes('erro') || content.includes('fix')) {
        category = 'Error Resolution';
      } else if (keywords.includes('architecture') || content.includes('system') || content.includes('integration')) {
        category = 'System Architecture';
      }

      groups[category].push(entry);
    }

    // Remove empty categories
    return Object.fromEntries(Object.entries(groups).filter(([_, entries]) => entries.length > 0));
  }

  /**
   * Format entry for template output
   */
  formatEntryForTemplate(entry) {
    const timestamp = entry.metadata.dateRange ?
      new Date(entry.metadata.dateRange.latest).toISOString() :
      new Date().toISOString();

    let formattedEntry = `### ${entry.primaryEntry.title} - [${timestamp.split('T')[0]}]\n\n`;
    formattedEntry += entry.consolidatedContent;

    // Add consolidation metadata if applicable
    if (entry.type === 'consolidated_pattern' && entry.secondaryEntries.length > 0) {
      formattedEntry += `\n\n**📊 Consolidation Info**: This entry represents ${entry.totalEntries} similar cases `;
      formattedEntry += `(${entry.secondaryEntries.length} consolidated, 1 primary).\n`;
    }

    // Add importance and metadata
    if (entry.preservedImportance >= 0.8) {
      formattedEntry += `**🔥 High Importance**: ${(entry.preservedImportance * 100).toFixed(0)}% relevance score.\n`;
    }

    return formattedEntry;
  }

  /**
   * Generate optimized self_correction_log.md
   */
  async generateOptimizedLog(templates) {
    console.log('📄 [MEMORY CONSOLIDATION] Generating optimized log...');

    try {
      let optimizedContent = templates.header;

      // Add sections
      for (const section of templates.sections) {
        optimizedContent += `## 📂 ${section.category} (${section.entryCount} entries)\n\n`;

        for (const entry of section.entries) {
          optimizedContent += entry + '\n\n---\n\n';
        }
      }

      optimizedContent += templates.footer;

      const optimizedLog = {
        content: optimizedContent,
        lineCount: optimizedContent.split('\n').length,
        characterCount: optimizedContent.length,
        sectionCount: templates.sections.length,
        totalEntries: templates.sections.reduce((sum, section) => sum + section.entryCount, 0),
        metadata: templates.metadata
      };

      console.log(`📊 [MEMORY CONSOLIDATION] Generated optimized log: ${optimizedLog.lineCount} lines`);
      return optimizedLog;

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Log generation failed:', error.message);
      throw error;
    }
  }

  /**
   * Validate consolidation quality
   */
  async validateConsolidation(originalLog, optimizedLog) {
    console.log('✅ [MEMORY CONSOLIDATION] Validating consolidation quality...');

    try {
      const validation = {
        success: true,
        checks: {},
        warnings: [],
        errors: [],
        metrics: {}
      };

      // Check size reduction
      const sizeReduction = (originalLog.totalLines - optimizedLog.lineCount) / originalLog.totalLines;
      validation.checks.sizeReduction = sizeReduction >= (this.consolidationConfig.targetReduction - 0.1);
      validation.metrics.sizeReduction = sizeReduction;

      if (!validation.checks.sizeReduction) {
        validation.warnings.push(`Size reduction ${(sizeReduction * 100).toFixed(1)}% below target ${(this.consolidationConfig.targetReduction * 100)}%`);
      }

      // Check essential content preservation
      const essentialKeywords = ['error', 'solution', 'fix', 'success', 'learning', 'pattern'];
      let preservedKeywords = 0;

      for (const keyword of essentialKeywords) {
        if (optimizedLog.content.toLowerCase().includes(keyword)) {
          preservedKeywords++;
        }
      }

      validation.checks.contentPreservation = preservedKeywords >= essentialKeywords.length * 0.8;
      validation.metrics.keywordPreservation = preservedKeywords / essentialKeywords.length;

      // Check structure integrity
      validation.checks.structureIntegrity = optimizedLog.sectionCount >= 3 && optimizedLog.totalEntries >= 10;

      // Check for critical information loss
      const criticalPatterns = [
        /command[s]?\s*:/i,
        /solution[s]?\s*:/i,
        /fix[es]?\s*:/i,
        /error[s]?\s*:/i,
        /✅|❌|⚠️/
      ];

      let preservedPatterns = 0;
      for (const pattern of criticalPatterns) {
        if (pattern.test(optimizedLog.content)) {
          preservedPatterns++;
        }
      }

      validation.checks.criticalInfoPreservation = preservedPatterns >= criticalPatterns.length * 0.7;
      validation.metrics.patternPreservation = preservedPatterns / criticalPatterns.length;

      // Overall validation
      const allChecks = Object.values(validation.checks);
      validation.success = allChecks.every(check => check === true);

      if (!validation.success) {
        validation.errors.push('Consolidation validation failed - quality thresholds not met');
      }

      console.log(`✅ [MEMORY CONSOLIDATION] Validation ${validation.success ? 'PASSED' : 'FAILED'}`);
      return validation;

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Validation failed:', error.message);
      return {
        success: false,
        error: error.message,
        checks: {},
        warnings: [],
        errors: [error.message],
        metrics: {}
      };
    }
  }

  /**
   * Backup original and save optimized log
   */
  async backupAndSaveOptimizedLog(optimizedLog) {
    console.log('💾 [MEMORY CONSOLIDATION] Backing up and saving optimized log...');

    try {
      // Handle path resolution based on current working directory
      let originalPath, backupPath;
      if (process.cwd().includes('@project-core/memory')) {
        originalPath = path.join(process.cwd(), 'self_correction_log.md');
        backupPath = path.join(process.cwd(), 'backups', `self_correction_log_backup_${Date.now()}.md`);
      } else {
        originalPath = path.join(process.cwd(), '@project-core', 'memory', 'self_correction_log.md');
        backupPath = path.join(process.cwd(), '@project-core', 'memory', 'backups', `self_correction_log_backup_${Date.now()}.md`);
      }

      // Ensure backup directory exists
      const backupDir = path.dirname(backupPath);
      await fs.mkdir(backupDir, { recursive: true });

      // Create backup of original
      const originalContent = await fs.readFile(originalPath, 'utf8');
      await fs.writeFile(backupPath, originalContent);

      // Save optimized version
      await fs.writeFile(originalPath, optimizedLog.content);

      console.log(`✅ [MEMORY CONSOLIDATION] Backup created: ${backupPath}`);
      console.log(`✅ [MEMORY CONSOLIDATION] Optimized log saved: ${originalPath}`);

      return {
        success: true,
        backupPath: backupPath,
        optimizedPath: originalPath
      };

    } catch (error) {
      console.error('❌ [MEMORY CONSOLIDATION] Backup and save failed:', error.message);
      throw error;
    }
  }

  /**
   * Update consolidation metrics
   */
  updateConsolidationMetrics(optimizedLog) {
    this.consolidationMetrics.consolidatedSize = optimizedLog.totalEntries;
    this.consolidationMetrics.redundantEntriesRemoved = this.consolidationMetrics.originalSize - optimizedLog.totalEntries;
    this.consolidationMetrics.essentialEntriesPreserved = optimizedLog.totalEntries;
    this.consolidationMetrics.consolidationRatio = ((this.consolidationMetrics.originalSize - optimizedLog.totalEntries) / this.consolidationMetrics.originalSize) * 100;

    console.log('📊 [MEMORY CONSOLIDATION] Final metrics:', this.consolidationMetrics);
  }

  /**
   * Calculate similarity between keyword arrays
   */
  calculateKeywordSimilarity(keywords1, keywords2) {
    if (!keywords1 || !keywords2 || keywords1.length === 0 || keywords2.length === 0) return 0;

    const set1 = new Set(keywords1);
    const set2 = new Set(keywords2);
    const intersection = new Set([...set1].filter(x => set2.has(x)));
    const union = new Set([...set1, ...set2]);

    return union.size > 0 ? intersection.size / union.size : 0;
  }
}

// Export both classes
module.exports = { SemanticMemorySearch, MemoryConsolidationEngine };
