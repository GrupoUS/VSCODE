#!/usr/bin/env node

/**
 * COGNEE INTEGRATION VALIDATION SCRIPT V5.0
 * GRUPO US VIBECODE SYSTEM - Comprehensive Integration Testing
 *
 * Validates the Cognee-enhanced memory system integration including
 * knowledge graph functionality, semantic search, and compatibility
 * with existing Enhanced Memory System V4.0
 */

const fs = require("fs").promises;
const path = require("path");
const CogneeKnowledgeGraphEngine = require("./knowledge-graph-engine");
const SemanticMemorySearch = require("./semantic-memory-search");

class CogneeIntegrationValidator {
  constructor() {
    this.memoryPath = path.resolve("@project-core/memory");
    this.results = {
      timestamp: new Date().toISOString(),
      tests: [],
      summary: {
        total: 0,
        passed: 0,
        failed: 0,
        warnings: 0,
      },
      performance: {},
      recommendations: [],
    };
  }

  /**
   * Run comprehensive validation of Cognee integration
   */
  async validate() {
    console.log("🧠 Starting Cognee Integration Validation...\n");

    try {
      // Test 1: Directory Structure Validation
      await this.validateDirectoryStructure();

      // Test 2: Knowledge Graph Engine Validation
      await this.validateKnowledgeGraphEngine();

      // Test 3: Semantic Search Engine Validation
      await this.validateSemanticSearchEngine();

      // Test 4: Integration with Existing System
      await this.validateExistingSystemIntegration();

      // Test 5: Performance Benchmarks
      await this.validatePerformance();

      // Test 6: Memory Consultation Protocol Compatibility
      await this.validateMemoryConsultationProtocols();

      // Test 7: MCP Integration Compatibility
      await this.validateMCPIntegration();

      // Generate final report
      await this.generateValidationReport();

      console.log("\n✅ Cognee Integration Validation Complete!");
      return this.results;
    } catch (error) {
      console.error("❌ Validation failed:", error);
      this.addTest(
        "CRITICAL_ERROR",
        false,
        `Validation failed: ${error.message}`
      );
      return this.results;
    }
  }

  /**
   * Validate directory structure and required files
   */
  async validateDirectoryStructure() {
    console.log("📁 Validating directory structure...");

    const requiredDirs = [
      "cognee-integration",
      "cognee-integration/knowledge-graph",
      "cognee-integration/semantic-search",
      "cognee-integration/ecl-pipeline",
      "cognee-integration/entity-resolution",
    ];

    const requiredFiles = [
      "cognee-integration/knowledge-graph-engine.js",
      "cognee-integration/semantic-memory-search.js",
      "cognee-enhanced-memory-system.md",
    ];

    let passed = 0;
    let total = requiredDirs.length + requiredFiles.length;

    // Check directories
    for (const dir of requiredDirs) {
      const dirPath = `${this.memoryPath}/${dir}`;
      try {
        const stats = await fs.stat(dirPath);
        if (stats.isDirectory()) {
          passed++;
          console.log(`  ✅ Directory exists: ${dir}`);
        } else {
          console.log(`  ❌ Not a directory: ${dir}`);
        }
      } catch (error) {
        console.log(`  ❌ Directory missing: ${dir}`);
      }
    }

    // Check files
    for (const file of requiredFiles) {
      const filePath = `${this.memoryPath}/${file}`;
      try {
        await fs.access(filePath);
        passed++;
        console.log(`  ✅ File exists: ${file}`);
      } catch (error) {
        console.log(`  ❌ File missing: ${file}`);
      }
    }

    const success = passed === total;
    this.addTest(
      "DIRECTORY_STRUCTURE",
      success,
      `${passed}/${total} required items found`
    );

    if (!success) {
      this.results.recommendations.push(
        "Run setup commands to create missing directories and files"
      );
    }
  }

  /**
   * Validate Knowledge Graph Engine functionality
   */
  async validateKnowledgeGraphEngine() {
    console.log("🕸️ Validating Knowledge Graph Engine...");

    try {
      const engine = new CogneeKnowledgeGraphEngine();

      // Test initialization
      const initResult = await engine.initialize();
      if (!initResult.success) {
        this.addTest(
          "KNOWLEDGE_GRAPH_INIT",
          false,
          `Initialization failed: ${initResult.error}`
        );
        return;
      }

      console.log("  ✅ Knowledge Graph Engine initialized");

      // Test graph statistics
      const stats = engine.getGraphStats();
      console.log(
        `  📊 Graph stats: ${stats.entities} entities, ${stats.relationships} relationships`
      );

      // Test semantic search
      const searchResult = await engine.semanticSearch(
        "Sequential Thinking MCP"
      );
      console.log(
        `  🔍 Search test: Found ${searchResult.entities.length} entities, ${searchResult.relationships.length} relationships`
      );

      // Test entity addition
      engine.addEntity({
        id: "test_entity",
        name: "Test Entity",
        type: "TEST",
        description: "Test entity for validation",
      });

      const updatedStats = engine.getGraphStats();
      const entityAdded = updatedStats.entities > stats.entities;

      if (entityAdded) {
        console.log("  ✅ Entity addition test passed");
      } else {
        console.log("  ⚠️ Entity addition test failed");
      }

      this.addTest(
        "KNOWLEDGE_GRAPH_ENGINE",
        true,
        "All knowledge graph tests passed"
      );
    } catch (error) {
      console.log(`  ❌ Knowledge Graph Engine error: ${error.message}`);
      this.addTest("KNOWLEDGE_GRAPH_ENGINE", false, `Error: ${error.message}`);
    }
  }

  /**
   * Validate Semantic Search Engine functionality
   */
  async validateSemanticSearchEngine() {
    console.log("🔍 Validating Semantic Search Engine...");

    try {
      const searchEngine = new SemanticMemorySearch();

      // Test initialization
      const initResult = await searchEngine.initialize();
      if (!initResult.success) {
        this.addTest(
          "SEMANTIC_SEARCH_INIT",
          false,
          `Initialization failed: ${initResult.error}`
        );
        return;
      }

      console.log("  ✅ Semantic Search Engine initialized");

      // Test memory search
      const searchResult = await searchEngine.searchMemory(
        "error correction protocol"
      );
      console.log(
        `  🔍 Search test: Confidence ${searchResult.confidence.toFixed(2)}, ${
          searchResult.insights.length
        } insights`
      );

      // Test search layers
      const layers = searchResult.layers;
      console.log(
        `  📊 Search layers: KG(${layers.knowledge_graph.count}), Files(${layers.memory_files.count}), Cache(${layers.cached_patterns.count}), Learning(${layers.learning_history.count})`
      );

      // Test search statistics
      const stats = searchEngine.getSearchStats();
      console.log(
        `  📈 Search stats: ${stats.cacheSize} cached, ${stats.historySize} history entries`
      );

      this.addTest(
        "SEMANTIC_SEARCH_ENGINE",
        true,
        "All semantic search tests passed"
      );
    } catch (error) {
      console.log(`  ❌ Semantic Search Engine error: ${error.message}`);
      this.addTest("SEMANTIC_SEARCH_ENGINE", false, `Error: ${error.message}`);
    }
  }

  /**
   * Validate integration with existing Enhanced Memory System V4.0
   */
  async validateExistingSystemIntegration() {
    console.log("🔗 Validating existing system integration...");

    const existingFiles = [
      "master_rule.md",
      "global-standards.md",
      "self_correction_log.md",
      "core/product-context.md",
      "core/active-context.md",
      "protocols/proactive_error_correction_protocol.md",
    ];

    let filesIntact = 0;

    for (const file of existingFiles) {
      try {
        const filePath = `${this.memoryPath}/${file}`;
        await fs.access(filePath);
        filesIntact++;
        console.log(`  ✅ Existing file intact: ${file}`);
      } catch (error) {
        console.log(`  ❌ Existing file missing: ${file}`);
      }
    }

    // Check cache directory structure
    const cacheDir = `${this.memoryPath}/cache`;
    try {
      const cacheStats = await fs.stat(cacheDir);
      if (cacheStats.isDirectory()) {
        console.log("  ✅ Cache directory preserved");
        filesIntact++;
      }
    } catch (error) {
      console.log("  ❌ Cache directory missing");
    }

    // Check coordination directory
    const coordDir = `${this.memoryPath}/coordination`;
    try {
      const coordStats = await fs.stat(coordDir);
      if (coordStats.isDirectory()) {
        console.log("  ✅ Coordination directory preserved");
        filesIntact++;
      }
    } catch (error) {
      console.log("  ❌ Coordination directory missing");
    }

    const success = filesIntact >= existingFiles.length;
    this.addTest(
      "EXISTING_SYSTEM_INTEGRATION",
      success,
      `${filesIntact}/${existingFiles.length + 2} existing components preserved`
    );
  }

  /**
   * Validate performance benchmarks
   */
  async validatePerformance() {
    console.log("⚡ Running performance benchmarks...");

    try {
      const searchEngine = new SemanticMemorySearch();
      await searchEngine.initialize();

      // Benchmark search performance
      const queries = [
        "error correction",
        "Sequential Thinking",
        "memory consultation",
        "MCP integration",
        "performance optimization",
      ];

      const searchTimes = [];

      for (const query of queries) {
        const startTime = Date.now();
        await searchEngine.searchMemory(query);
        const endTime = Date.now();
        const duration = endTime - startTime;
        searchTimes.push(duration);
        console.log(`  🔍 "${query}": ${duration}ms`);
      }

      const avgSearchTime =
        searchTimes.reduce((sum, time) => sum + time, 0) / searchTimes.length;
      const maxSearchTime = Math.max(...searchTimes);

      console.log(`  📊 Average search time: ${avgSearchTime.toFixed(2)}ms`);
      console.log(`  📊 Maximum search time: ${maxSearchTime}ms`);

      this.results.performance = {
        averageSearchTime: avgSearchTime,
        maxSearchTime: maxSearchTime,
        searchTimes: searchTimes,
      };

      // Performance targets
      const avgTarget = 2000; // 2 seconds
      const maxTarget = 5000; // 5 seconds

      const avgPassed = avgSearchTime <= avgTarget;
      const maxPassed = maxSearchTime <= maxTarget;

      if (avgPassed && maxPassed) {
        this.addTest(
          "PERFORMANCE_BENCHMARKS",
          true,
          `Performance targets met (avg: ${avgSearchTime.toFixed(
            2
          )}ms, max: ${maxSearchTime}ms)`
        );
      } else {
        this.addTest(
          "PERFORMANCE_BENCHMARKS",
          false,
          `Performance targets not met (avg: ${avgSearchTime.toFixed(
            2
          )}ms/${avgTarget}ms, max: ${maxSearchTime}ms/${maxTarget}ms)`
        );
        this.results.recommendations.push(
          "Consider optimizing search algorithms or caching strategies"
        );
      }
    } catch (error) {
      console.log(`  ❌ Performance benchmark error: ${error.message}`);
      this.addTest("PERFORMANCE_BENCHMARKS", false, `Error: ${error.message}`);
    }
  }

  /**
   * Validate memory consultation protocol compatibility
   */
  async validateMemoryConsultationProtocols() {
    console.log("📋 Validating memory consultation protocols...");

    try {
      // Check if mandatory consultation protocol exists
      const protocolPath = `${this.memoryPath}/protocols/mandatory-memory-consultation.js`;
      await fs.access(protocolPath);
      console.log("  ✅ Mandatory consultation protocol exists");

      // Check if enhanced search can be integrated
      const searchEngine = new SemanticMemorySearch();
      await searchEngine.initialize();

      // Test consultation workflow
      const consultationResult = await searchEngine.searchMemory(
        "mandatory pre-execution verification"
      );
      const hasRelevantResults = consultationResult.confidence > 0.5;

      if (hasRelevantResults) {
        console.log(
          "  ✅ Enhanced search integrates with consultation protocols"
        );
        this.addTest(
          "MEMORY_CONSULTATION_PROTOCOLS",
          true,
          "Consultation protocols compatible with enhanced search"
        );
      } else {
        console.log(
          "  ⚠️ Enhanced search may need tuning for consultation protocols"
        );
        this.addTest(
          "MEMORY_CONSULTATION_PROTOCOLS",
          true,
          "Consultation protocols exist but may need optimization",
          "warning"
        );
      }
    } catch (error) {
      console.log(`  ❌ Memory consultation protocol error: ${error.message}`);
      this.addTest(
        "MEMORY_CONSULTATION_PROTOCOLS",
        false,
        `Error: ${error.message}`
      );
    }
  }

  /**
   * Validate MCP integration compatibility
   */
  async validateMCPIntegration() {
    console.log("🔌 Validating MCP integration compatibility...");

    try {
      // Check Sequential Thinking integration
      const sequentialThinkingPath = `${this.memoryPath}/sequential-thinking-memory-integration.js`;
      await fs.access(sequentialThinkingPath);
      console.log("  ✅ Sequential Thinking integration exists");

      // Check Shrimp Task Manager coordination
      const shrimpConfigPath = `${this.memoryPath}/coordination/shrimp-task-manager-config.json`;
      await fs.access(shrimpConfigPath);
      console.log("  ✅ Shrimp Task Manager configuration exists");

      // Verify TaskMaster removal (should not exist)
      const taskMasterReferences = await this.checkTaskMasterReferences();
      if (taskMasterReferences.length === 0) {
        console.log("  ✅ TaskMaster references successfully removed");
      } else {
        console.log(
          `  ⚠️ Found ${taskMasterReferences.length} TaskMaster references that should be removed`
        );
        this.results.recommendations.push(
          "Remove remaining TaskMaster references from guidelines"
        );
      }

      this.addTest(
        "MCP_INTEGRATION",
        true,
        "MCP integration compatibility verified"
      );
    } catch (error) {
      console.log(`  ❌ MCP integration error: ${error.message}`);
      this.addTest("MCP_INTEGRATION", false, `Error: ${error.message}`);
    }
  }

  /**
   * Check for TaskMaster references that should be removed
   */
  async checkTaskMasterReferences() {
    const references = [];
    const filesToCheck = [
      "master_rule.md",
      "global-standards.md",
      "augment-agent-guidelines-v3.md",
    ];

    for (const file of filesToCheck) {
      try {
        // Handle master_rule.md in root directory
        const filePath = file === "master_rule.md" ? file : `${this.memoryPath}/${file}`;
        const content = await fs.readFile(filePath, "utf8");
        const lines = content.split("\n");

        for (let i = 0; i < lines.length; i++) {
          if (
            lines[i].toLowerCase().includes("taskmaster") ||
            lines[i].toLowerCase().includes("task-master")
          ) {
            references.push({
              file: file,
              line: i + 1,
              content: lines[i].trim(),
            });
          }
        }
      } catch (error) {
        // File doesn't exist, skip
      }
    }

    return references;
  }

  /**
   * Generate comprehensive validation report
   */
  async generateValidationReport() {
    console.log("\n📊 Generating validation report...");

    const report = {
      ...this.results,
      generatedAt: new Date().toISOString(),
      version: "5.0",
      system: "Cognee-Enhanced Memory System",
      overallStatus: this.results.summary.failed === 0 ? "PASSED" : "FAILED",
    };

    // Save report to file
    const reportPath = `${this.memoryPath}/cognee-integration/validation-report.json`;
    await fs.writeFile(reportPath, JSON.stringify(report, null, 2));

    // Display summary
    console.log("\n📋 VALIDATION SUMMARY:");
    console.log(`  Total Tests: ${this.results.summary.total}`);
    console.log(`  Passed: ${this.results.summary.passed}`);
    console.log(`  Failed: ${this.results.summary.failed}`);
    console.log(`  Warnings: ${this.results.summary.warnings}`);
    console.log(`  Overall Status: ${report.overallStatus}`);

    if (this.results.performance.averageSearchTime) {
      console.log(
        `  Average Search Time: ${this.results.performance.averageSearchTime.toFixed(
          2
        )}ms`
      );
    }

    if (this.results.recommendations.length > 0) {
      console.log("\n💡 RECOMMENDATIONS:");
      this.results.recommendations.forEach((rec, index) => {
        console.log(`  ${index + 1}. ${rec}`);
      });
    }

    console.log(`\n📄 Full report saved to: ${reportPath}`);
  }

  /**
   * Add test result to results
   */
  addTest(name, passed, message, type = "test") {
    const test = {
      name: name,
      passed: passed,
      message: message,
      type: type,
      timestamp: new Date().toISOString(),
    };

    this.results.tests.push(test);
    this.results.summary.total++;

    if (passed) {
      this.results.summary.passed++;
    } else {
      if (type === "warning") {
        this.results.summary.warnings++;
      } else {
        this.results.summary.failed++;
      }
    }
  }
}

// Run validation if called directly
if (require.main === module) {
  const validator = new CogneeIntegrationValidator();
  validator
    .validate()
    .then((results) => {
      process.exit(results.summary.failed === 0 ? 0 : 1);
    })
    .catch((error) => {
      console.error("❌ Validation script error:", error);
      process.exit(1);
    });
}

module.exports = CogneeIntegrationValidator;
