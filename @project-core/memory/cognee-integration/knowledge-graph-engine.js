/**
 * COGNEE-ENHANCED KNOWLEDGE GRAPH ENGINE V5.0
 * GRUPO US VIBECODE SYSTEM - Knowledge Graph Management
 *
 * Integrates Cognee-style knowledge graph patterns with Enhanced Memory System V4.0
 * Provides entity resolution, relationship mapping, and semantic search capabilities
 */

const fs = require("fs").promises;
const path = require("path");

class CogneeKnowledgeGraphEngine {
  constructor() {
    this.memoryPath = path.resolve("@project-core/memory");
    this.graphPath = path.resolve("./knowledge-graph");
    this.entities = new Map();
    this.relationships = new Map();
    this.graphState = {
      nodes: 0,
      edges: 0,
      lastUpdated: new Date().toISOString(),
    };
    this.initialized = false;
  }

  /**
   * Initialize the knowledge graph engine
   */
  async initialize() {
    try {
      await this.loadExistingGraph();
      await this.analyzeExistingMemory();
      this.initialized = true;
      console.log("🧠 Cognee Knowledge Graph Engine initialized successfully");
      return { success: true, message: "Knowledge graph engine ready" };
    } catch (error) {
      console.error("❌ Failed to initialize knowledge graph engine:", error);
      return { success: false, error: error.message };
    }
  }

  /**
   * Load existing knowledge graph data
   */
  async loadExistingGraph() {
    try {
      // Load entities
      const entitiesPath = `${this.graphPath}/entities.json`;
      const entitiesData = await fs.readFile(entitiesPath, "utf8");
      const entitiesJson = JSON.parse(entitiesData);

      Object.entries(entitiesJson.entities || {}).forEach(([id, entity]) => {
        this.entities.set(id, entity);
      });

      // Load relationships
      const relationshipsPath = `${this.graphPath}/relationships.json`;
      const relationshipsData = await fs.readFile(relationshipsPath, "utf8");
      const relationshipsJson = JSON.parse(relationshipsData);

      Object.entries(relationshipsJson.relationships || {}).forEach(
        ([id, relationship]) => {
          this.relationships.set(id, relationship);
        }
      );

      // Load graph state
      const statePath = `${this.graphPath}/graph-state.json`;
      const stateData = await fs.readFile(statePath, "utf8");
      this.graphState = JSON.parse(stateData);

      console.log(
        `📊 Loaded ${this.entities.size} entities and ${this.relationships.size} relationships`
      );
    } catch (error) {
      console.log("📝 No existing graph data found, starting fresh");
    }
  }

  /**
   * Analyze existing memory bank content to extract entities and relationships
   */
  async analyzeExistingMemory() {
    try {
      const memoryFiles = await this.getMemoryFiles();

      for (const file of memoryFiles) {
        await this.extractEntitiesFromFile(file);
      }

      await this.saveGraph();
      console.log(`🔍 Analyzed ${memoryFiles.length} memory files`);
    } catch (error) {
      console.error("❌ Error analyzing existing memory:", error);
    }
  }

  /**
   * Get all memory files for analysis
   */
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

  /**
   * Extract entities and relationships from a memory file
   */
  async extractEntitiesFromFile(filePath) {
    try {
      const content = await fs.readFile(filePath, "utf8");
      const fileName = path.basename(filePath, ".md");

      // Extract entities using Cognee-style patterns
      const entities = this.extractEntities(content, fileName);
      const relationships = this.extractRelationships(content, entities);

      // Add entities to graph
      entities.forEach((entity) => {
        this.addEntity(entity);
      });

      // Add relationships to graph
      relationships.forEach((relationship) => {
        this.addRelationship(relationship);
      });
    } catch (error) {
      console.error(`❌ Error extracting from ${filePath}:`, error);
    }
  }

  /**
   * Extract entities from content using Cognee patterns
   */
  extractEntities(content, source) {
    const entities = [];

    // Extract concepts (headings, important terms)
    const conceptRegex = /#{1,6}\s+(.+)/g;
    let match;
    while ((match = conceptRegex.exec(content)) !== null) {
      const concept = match[1].trim();
      entities.push({
        id: this.generateEntityId(concept),
        name: concept,
        type: "CONCEPT",
        description: `Concept from ${source}`,
        source: source,
        properties: {
          importance: this.calculateImportance(concept, content),
          context: this.extractContext(concept, content),
        },
      });
    }

    // Extract technologies and tools
    const techRegex =
      /\b(React|Next\.js|TypeScript|Supabase|Tailwind|MCP|Sequential Thinking|TaskMaster|Playwright|Figma)\b/gi;
    const technologies = new Set();
    while ((match = techRegex.exec(content)) !== null) {
      technologies.add(match[1]);
    }

    technologies.forEach((tech) => {
      entities.push({
        id: this.generateEntityId(tech),
        name: tech,
        type: "TECHNOLOGY",
        description: `Technology mentioned in ${source}`,
        source: source,
        properties: {
          category: this.categorizeTechnology(tech),
          usage_frequency: this.countOccurrences(tech, content),
        },
      });
    });

    return entities;
  }

  /**
   * Extract relationships between entities
   */
  extractRelationships(content, entities) {
    const relationships = [];

    // Simple relationship extraction based on proximity and context
    for (let i = 0; i < entities.length; i++) {
      for (let j = i + 1; j < entities.length; j++) {
        const entity1 = entities[i];
        const entity2 = entities[j];

        // Check if entities appear in similar contexts
        if (this.areEntitiesRelated(entity1, entity2, content)) {
          relationships.push({
            id: this.generateRelationshipId(entity1.id, entity2.id),
            source: entity1.id,
            target: entity2.id,
            type: this.determineRelationshipType(entity1, entity2, content),
            strength: this.calculateRelationshipStrength(
              entity1,
              entity2,
              content
            ),
            properties: {
              context: this.extractRelationshipContext(
                entity1,
                entity2,
                content
              ),
              source_file: entity1.source,
            },
          });
        }
      }
    }

    return relationships;
  }

  /**
   * Add entity to knowledge graph
   */
  addEntity(entity) {
    if (!this.entities.has(entity.id)) {
      this.entities.set(entity.id, {
        ...entity,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      });
      this.graphState.nodes++;
    } else {
      // Update existing entity
      const existing = this.entities.get(entity.id);
      this.entities.set(entity.id, {
        ...existing,
        ...entity,
        updated_at: new Date().toISOString(),
      });
    }
  }

  /**
   * Add relationship to knowledge graph
   */
  addRelationship(relationship) {
    if (!this.relationships.has(relationship.id)) {
      this.relationships.set(relationship.id, {
        ...relationship,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      });
      this.graphState.edges++;
    }
  }

  /**
   * Search entities and relationships using semantic patterns
   */
  async semanticSearch(query, options = {}) {
    const results = {
      entities: [],
      relationships: [],
      insights: [],
    };

    // Search entities
    this.entities.forEach((entity, id) => {
      const relevance = this.calculateRelevance(query, entity);
      if (relevance > (options.threshold || 0.3)) {
        results.entities.push({
          ...entity,
          relevance: relevance,
        });
      }
    });

    // Search relationships
    this.relationships.forEach((relationship, id) => {
      const relevance = this.calculateRelationshipRelevance(
        query,
        relationship
      );
      if (relevance > (options.threshold || 0.3)) {
        results.relationships.push({
          ...relationship,
          relevance: relevance,
        });
      }
    });

    // Generate insights
    results.insights = this.generateInsights(query, results);

    // Sort by relevance
    results.entities.sort((a, b) => b.relevance - a.relevance);
    results.relationships.sort((a, b) => b.relevance - a.relevance);

    return results;
  }

  /**
   * Save knowledge graph to files
   */
  async saveGraph() {
    try {
      // Save entities
      const entitiesData = {
        entities: Object.fromEntries(this.entities),
        lastUpdated: new Date().toISOString(),
      };
      await fs.writeFile(
        `${this.graphPath}/entities.json`,
        JSON.stringify(entitiesData, null, 2)
      );

      // Save relationships
      const relationshipsData = {
        relationships: Object.fromEntries(this.relationships),
        lastUpdated: new Date().toISOString(),
      };
      await fs.writeFile(
        `${this.graphPath}/relationships.json`,
        JSON.stringify(relationshipsData, null, 2)
      );

      // Save graph state
      this.graphState.lastUpdated = new Date().toISOString();
      await fs.writeFile(
        `${this.graphPath}/graph-state.json`,
        JSON.stringify(this.graphState, null, 2)
      );

      console.log("💾 Knowledge graph saved successfully");
    } catch (error) {
      console.error("❌ Error saving knowledge graph:", error);
    }
  }

  // Utility methods
  generateEntityId(name) {
    return name.toLowerCase().replace(/[^a-z0-9]/g, "_");
  }

  generateRelationshipId(source, target) {
    return `${source}_to_${target}`;
  }

  calculateImportance(concept, content) {
    const occurrences = this.countOccurrences(concept, content);
    const position = content.indexOf(concept) / content.length;
    return Math.min(1.0, occurrences * 0.1 + (1 - position) * 0.5);
  }

  countOccurrences(term, content) {
    const regex = new RegExp(term, "gi");
    return (content.match(regex) || []).length;
  }

  extractContext(term, content) {
    const index = content.toLowerCase().indexOf(term.toLowerCase());
    if (index === -1) return "";

    const start = Math.max(0, index - 100);
    const end = Math.min(content.length, index + term.length + 100);
    return content.substring(start, end).trim();
  }

  categorizeTechnology(tech) {
    const categories = {
      React: "Frontend Framework",
      "Next.js": "Full-stack Framework",
      TypeScript: "Programming Language",
      Supabase: "Backend Service",
      Tailwind: "CSS Framework",
      MCP: "Protocol",
      "Sequential Thinking": "AI Tool",
      TaskMaster: "Task Management",
      Playwright: "Testing Framework",
      Figma: "Design Tool",
    };
    return categories[tech] || "Technology";
  }

  areEntitiesRelated(entity1, entity2, content) {
    // Simple proximity-based relationship detection
    const pos1 = content.toLowerCase().indexOf(entity1.name.toLowerCase());
    const pos2 = content.toLowerCase().indexOf(entity2.name.toLowerCase());

    if (pos1 === -1 || pos2 === -1) return false;

    const distance = Math.abs(pos1 - pos2);
    return distance < 500; // Characters proximity threshold
  }

  determineRelationshipType(entity1, entity2, content) {
    // Simple relationship type determination
    if (entity1.type === "TECHNOLOGY" && entity2.type === "TECHNOLOGY") {
      return "integrates_with";
    }
    if (entity1.type === "CONCEPT" && entity2.type === "TECHNOLOGY") {
      return "implemented_using";
    }
    return "related_to";
  }

  calculateRelationshipStrength(entity1, entity2, content) {
    const coOccurrences = this.countCoOccurrences(
      entity1.name,
      entity2.name,
      content
    );
    return Math.min(1.0, coOccurrences * 0.2);
  }

  countCoOccurrences(term1, term2, content) {
    const sentences = content.split(/[.!?]+/);
    let count = 0;

    sentences.forEach((sentence) => {
      if (
        sentence.toLowerCase().includes(term1.toLowerCase()) &&
        sentence.toLowerCase().includes(term2.toLowerCase())
      ) {
        count++;
      }
    });

    return count;
  }

  extractRelationshipContext(entity1, entity2, content) {
    const sentences = content.split(/[.!?]+/);

    for (const sentence of sentences) {
      if (
        sentence.toLowerCase().includes(entity1.name.toLowerCase()) &&
        sentence.toLowerCase().includes(entity2.name.toLowerCase())
      ) {
        return sentence.trim();
      }
    }

    return "";
  }

  calculateRelevance(query, entity) {
    const queryLower = query.toLowerCase();
    const nameLower = entity.name.toLowerCase();
    const descLower = entity.description.toLowerCase();

    let score = 0;

    // Exact name match
    if (nameLower.includes(queryLower)) score += 0.8;

    // Description match
    if (descLower.includes(queryLower)) score += 0.4;

    // Type relevance
    if (entity.type.toLowerCase().includes(queryLower)) score += 0.3;

    return Math.min(1.0, score);
  }

  calculateRelationshipRelevance(query, relationship) {
    const queryLower = query.toLowerCase();
    const typeLower = relationship.type.toLowerCase();
    const contextLower = (relationship.properties?.context || "").toLowerCase();

    let score = 0;

    if (typeLower.includes(queryLower)) score += 0.6;
    if (contextLower.includes(queryLower)) score += 0.4;

    return Math.min(1.0, score);
  }

  generateInsights(query, results) {
    const insights = [];

    // Generate insights based on search results
    if (results.entities.length > 0) {
      const topEntity = results.entities[0];
      insights.push(
        `Most relevant concept: ${topEntity.name} (${topEntity.type})`
      );
    }

    if (results.relationships.length > 0) {
      const topRelationship = results.relationships[0];
      const sourceEntity = this.entities.get(topRelationship.source);
      const targetEntity = this.entities.get(topRelationship.target);

      if (sourceEntity && targetEntity) {
        insights.push(
          `Key relationship: ${sourceEntity.name} ${topRelationship.type} ${targetEntity.name}`
        );
      }
    }

    return insights;
  }

  /**
   * Get graph statistics
   */
  getGraphStats() {
    return {
      entities: this.entities.size,
      relationships: this.relationships.size,
      lastUpdated: this.graphState.lastUpdated,
      entityTypes: this.getEntityTypeDistribution(),
      relationshipTypes: this.getRelationshipTypeDistribution(),
    };
  }

  getEntityTypeDistribution() {
    const distribution = {};
    this.entities.forEach((entity) => {
      distribution[entity.type] = (distribution[entity.type] || 0) + 1;
    });
    return distribution;
  }

  getRelationshipTypeDistribution() {
    const distribution = {};
    this.relationships.forEach((relationship) => {
      distribution[relationship.type] =
        (distribution[relationship.type] || 0) + 1;
    });
    return distribution;
  }
}

module.exports = CogneeKnowledgeGraphEngine;
