#!/usr/bin/env node

/**
 * KNOWLEDGE GRAPH FOUNDATION V1.0
 * GRUPO US VIBECODE SYSTEM - Phase 4B Implementation
 * 
 * Dynamic relationship mapping between memory entries:
 * - Entity extraction and relationship identification
 * - Graph-based knowledge representation
 * - Semantic relationship scoring
 * - Foundation for Phase 4C advanced capabilities
 */

const fs = require('fs').promises;
const path = require('path');
const crypto = require('crypto');

class KnowledgeGraphFoundation {
    constructor() {
        this.memoryDir = path.join(process.cwd(), '@project-core', 'memory');
        this.knowledgeGraphDir = path.join(this.memoryDir, 'rag-enhanced', 'knowledge-graph');
        
        // Knowledge graph configuration
        this.graphConfig = {
            entityExtractionEnabled: true,
            relationshipMappingEnabled: true,
            semanticScoringEnabled: true,
            autoUpdateEnabled: true,
            maxEntitiesPerDocument: 50,
            minRelationshipScore: 0.3,
            graphPersistenceEnabled: true,
            relationshipTypes: [
                'SIMILAR_TO',
                'DEPENDS_ON',
                'IMPLEMENTS',
                'USES',
                'CONTAINS',
                'RELATED_TO',
                'FOLLOWS',
                'PRECEDES'
            ]
        };
        
        // Graph storage
        this.entities = new Map(); // Entity ID -> Entity data
        this.relationships = new Map(); // Relationship ID -> Relationship data
        this.entityIndex = new Map(); // Entity type -> Set of entity IDs
        this.relationshipIndex = new Map(); // Relationship type -> Set of relationship IDs
        
        // Performance metrics
        this.metrics = {
            entitiesExtracted: 0,
            relationshipsCreated: 0,
            graphQueries: 0,
            averageQueryTime: 0,
            graphSize: 0,
            relationshipAccuracy: 0
        };
        
        this.initializeKnowledgeGraph();
    }

    /**
     * Initialize knowledge graph foundation
     */
    async initializeKnowledgeGraph() {
        try {
            await fs.mkdir(this.knowledgeGraphDir, { recursive: true });
            await fs.mkdir(path.join(this.knowledgeGraphDir, 'entities'), { recursive: true });
            await fs.mkdir(path.join(this.knowledgeGraphDir, 'relationships'), { recursive: true });
            await fs.mkdir(path.join(this.knowledgeGraphDir, 'graphs'), { recursive: true });
            
            // Load existing graph data
            await this.loadExistingGraph();
            
            console.log('✅ [KNOWLEDGE GRAPH] Foundation initialized');
        } catch (error) {
            console.warn(`⚠️ [KNOWLEDGE GRAPH] Initialization warning: ${error.message}`);
        }
    }

    /**
     * MAIN ENTITY EXTRACTION
     * Extract entities from memory content for graph building
     */
    async extractEntities(content, context = {}) {
        console.log('🔍 [KNOWLEDGE GRAPH] Extracting entities...');
        
        try {
            const entities = [];
            
            // Extract different types of entities
            const codeEntities = this.extractCodeEntities(content);
            const conceptEntities = this.extractConceptEntities(content);
            const technicalEntities = this.extractTechnicalEntities(content);
            const processEntities = this.extractProcessEntities(content);
            
            entities.push(...codeEntities, ...conceptEntities, ...technicalEntities, ...processEntities);
            
            // Limit entities per document
            const limitedEntities = entities.slice(0, this.graphConfig.maxEntitiesPerDocument);
            
            // Store entities in graph
            for (const entity of limitedEntities) {
                await this.addEntityToGraph(entity, context);
            }
            
            this.metrics.entitiesExtracted += limitedEntities.length;
            
            console.log(`✅ [KNOWLEDGE GRAPH] Extracted ${limitedEntities.length} entities`);
            return limitedEntities;
            
        } catch (error) {
            console.error('❌ [KNOWLEDGE GRAPH] Entity extraction failed:', error.message);
            return [];
        }
    }

    /**
     * Extract code-related entities
     */
    extractCodeEntities(content) {
        const entities = [];
        
        // Extract function names
        const functionMatches = content.match(/(?:function|const|let|var)\s+([a-zA-Z_$][a-zA-Z0-9_$]*)/g);
        if (functionMatches) {
            functionMatches.forEach(match => {
                const name = match.split(/\s+/).pop();
                entities.push({
                    id: this.generateEntityId('function', name),
                    type: 'FUNCTION',
                    name,
                    content: match,
                    confidence: 0.9
                });
            });
        }
        
        // Extract class names
        const classMatches = content.match(/class\s+([a-zA-Z_$][a-zA-Z0-9_$]*)/g);
        if (classMatches) {
            classMatches.forEach(match => {
                const name = match.split(/\s+/).pop();
                entities.push({
                    id: this.generateEntityId('class', name),
                    type: 'CLASS',
                    name,
                    content: match,
                    confidence: 0.95
                });
            });
        }
        
        // Extract component names (React/Vue)
        const componentMatches = content.match(/(?:const|function)\s+([A-Z][a-zA-Z0-9]*)\s*(?:=|\()/g);
        if (componentMatches) {
            componentMatches.forEach(match => {
                const name = match.match(/([A-Z][a-zA-Z0-9]*)/)[1];
                entities.push({
                    id: this.generateEntityId('component', name),
                    type: 'COMPONENT',
                    name,
                    content: match,
                    confidence: 0.85
                });
            });
        }
        
        return entities;
    }

    /**
     * Extract concept entities
     */
    extractConceptEntities(content) {
        const entities = [];
        
        // Common technical concepts
        const concepts = [
            'authentication', 'authorization', 'validation', 'optimization',
            'caching', 'database', 'api', 'component', 'service', 'middleware',
            'routing', 'state management', 'error handling', 'testing',
            'deployment', 'security', 'performance', 'scalability'
        ];
        
        concepts.forEach(concept => {
            const regex = new RegExp(`\\b${concept}\\b`, 'gi');
            const matches = content.match(regex);
            if (matches && matches.length > 0) {
                entities.push({
                    id: this.generateEntityId('concept', concept),
                    type: 'CONCEPT',
                    name: concept,
                    content: `Concept: ${concept}`,
                    confidence: 0.7,
                    frequency: matches.length
                });
            }
        });
        
        return entities;
    }

    /**
     * Extract technical entities
     */
    extractTechnicalEntities(content) {
        const entities = [];
        
        // Technologies and frameworks
        const technologies = [
            'React', 'Vue', 'Angular', 'Node.js', 'Express', 'Next.js',
            'TypeScript', 'JavaScript', 'Python', 'Java', 'C#',
            'PostgreSQL', 'MongoDB', 'Redis', 'Docker', 'Kubernetes',
            'AWS', 'Azure', 'GCP', 'Vercel', 'Netlify'
        ];
        
        technologies.forEach(tech => {
            const regex = new RegExp(`\\b${tech}\\b`, 'gi');
            const matches = content.match(regex);
            if (matches && matches.length > 0) {
                entities.push({
                    id: this.generateEntityId('technology', tech),
                    type: 'TECHNOLOGY',
                    name: tech,
                    content: `Technology: ${tech}`,
                    confidence: 0.9,
                    frequency: matches.length
                });
            }
        });
        
        return entities;
    }

    /**
     * Extract process entities
     */
    extractProcessEntities(content) {
        const entities = [];
        
        // Process indicators
        const processPatterns = [
            /step\s+\d+[:\-\s]([^\.]+)/gi,
            /phase\s+\d+[:\-\s]([^\.]+)/gi,
            /\d+\.\s*([^\.]+)/gi
        ];
        
        processPatterns.forEach(pattern => {
            const matches = content.match(pattern);
            if (matches) {
                matches.forEach((match, index) => {
                    const processName = match.replace(/^(step|phase|\d+\.)\s*/i, '').trim();
                    if (processName.length > 5 && processName.length < 100) {
                        entities.push({
                            id: this.generateEntityId('process', processName),
                            type: 'PROCESS',
                            name: processName,
                            content: match,
                            confidence: 0.6,
                            order: index
                        });
                    }
                });
            }
        });
        
        return entities;
    }

    /**
     * RELATIONSHIP MAPPING
     * Create relationships between entities
     */
    async createRelationships(entities, context = {}) {
        console.log('🔗 [KNOWLEDGE GRAPH] Creating relationships...');
        
        try {
            const relationships = [];
            
            // Create relationships between entities
            for (let i = 0; i < entities.length; i++) {
                for (let j = i + 1; j < entities.length; j++) {
                    const entity1 = entities[i];
                    const entity2 = entities[j];
                    
                    const relationship = await this.analyzeRelationship(entity1, entity2, context);
                    if (relationship && relationship.score >= this.graphConfig.minRelationshipScore) {
                        relationships.push(relationship);
                        await this.addRelationshipToGraph(relationship);
                    }
                }
            }
            
            this.metrics.relationshipsCreated += relationships.length;
            
            console.log(`✅ [KNOWLEDGE GRAPH] Created ${relationships.length} relationships`);
            return relationships;
            
        } catch (error) {
            console.error('❌ [KNOWLEDGE GRAPH] Relationship creation failed:', error.message);
            return [];
        }
    }

    /**
     * Analyze relationship between two entities
     */
    async analyzeRelationship(entity1, entity2, context) {
        try {
            // Determine relationship type and score
            const relationshipType = this.determineRelationshipType(entity1, entity2);
            const score = this.calculateRelationshipScore(entity1, entity2, relationshipType);
            
            if (score < this.graphConfig.minRelationshipScore) {
                return null;
            }
            
            return {
                id: this.generateRelationshipId(entity1.id, entity2.id, relationshipType),
                type: relationshipType,
                source: entity1.id,
                target: entity2.id,
                score,
                context: context.source || 'unknown',
                timestamp: new Date().toISOString(),
                metadata: {
                    sourceEntity: entity1.name,
                    targetEntity: entity2.name,
                    sourceType: entity1.type,
                    targetType: entity2.type
                }
            };
            
        } catch (error) {
            console.warn('⚠️ [KNOWLEDGE GRAPH] Relationship analysis failed:', error.message);
            return null;
        }
    }

    /**
     * Determine relationship type between entities
     */
    determineRelationshipType(entity1, entity2) {
        // Type-based relationship determination
        if (entity1.type === 'FUNCTION' && entity2.type === 'CLASS') {
            return 'BELONGS_TO';
        }
        
        if (entity1.type === 'COMPONENT' && entity2.type === 'TECHNOLOGY') {
            return 'USES';
        }
        
        if (entity1.type === 'PROCESS' && entity2.type === 'PROCESS') {
            if (entity1.order !== undefined && entity2.order !== undefined) {
                return entity1.order < entity2.order ? 'PRECEDES' : 'FOLLOWS';
            }
        }
        
        if (entity1.type === entity2.type) {
            return 'SIMILAR_TO';
        }
        
        if (entity1.type === 'CONCEPT' || entity2.type === 'CONCEPT') {
            return 'RELATED_TO';
        }
        
        return 'RELATED_TO';
    }

    /**
     * Calculate relationship score
     */
    calculateRelationshipScore(entity1, entity2, relationshipType) {
        let score = 0;
        
        // Base score by relationship type
        const typeScores = {
            'BELONGS_TO': 0.8,
            'USES': 0.7,
            'IMPLEMENTS': 0.9,
            'SIMILAR_TO': 0.6,
            'DEPENDS_ON': 0.8,
            'CONTAINS': 0.7,
            'RELATED_TO': 0.5,
            'PRECEDES': 0.8,
            'FOLLOWS': 0.8
        };
        
        score += typeScores[relationshipType] || 0.5;
        
        // Name similarity bonus
        const nameSimilarity = this.calculateStringSimilarity(entity1.name, entity2.name);
        score += nameSimilarity * 0.2;
        
        // Content similarity bonus
        const contentSimilarity = this.calculateStringSimilarity(entity1.content, entity2.content);
        score += contentSimilarity * 0.1;
        
        // Confidence bonus
        const avgConfidence = (entity1.confidence + entity2.confidence) / 2;
        score *= avgConfidence;
        
        return Math.min(score, 1.0);
    }

    /**
     * Calculate string similarity (simplified)
     */
    calculateStringSimilarity(str1, str2) {
        const words1 = str1.toLowerCase().split(/\s+/);
        const words2 = str2.toLowerCase().split(/\s+/);
        
        const intersection = words1.filter(word => words2.includes(word));
        const union = [...new Set([...words1, ...words2])];
        
        return union.length > 0 ? intersection.length / union.length : 0;
    }

    /**
     * Add entity to graph
     */
    async addEntityToGraph(entity, context) {
        try {
            // Store entity
            this.entities.set(entity.id, {
                ...entity,
                addedAt: new Date().toISOString(),
                context: context.source || 'unknown'
            });
            
            // Update entity index
            if (!this.entityIndex.has(entity.type)) {
                this.entityIndex.set(entity.type, new Set());
            }
            this.entityIndex.get(entity.type).add(entity.id);
            
            // Persist if enabled
            if (this.graphConfig.graphPersistenceEnabled) {
                await this.persistEntity(entity);
            }
            
        } catch (error) {
            console.warn('⚠️ [KNOWLEDGE GRAPH] Entity addition failed:', error.message);
        }
    }

    /**
     * Add relationship to graph
     */
    async addRelationshipToGraph(relationship) {
        try {
            // Store relationship
            this.relationships.set(relationship.id, relationship);
            
            // Update relationship index
            if (!this.relationshipIndex.has(relationship.type)) {
                this.relationshipIndex.set(relationship.type, new Set());
            }
            this.relationshipIndex.get(relationship.type).add(relationship.id);
            
            // Persist if enabled
            if (this.graphConfig.graphPersistenceEnabled) {
                await this.persistRelationship(relationship);
            }
            
        } catch (error) {
            console.warn('⚠️ [KNOWLEDGE GRAPH] Relationship addition failed:', error.message);
        }
    }

    /**
     * Query knowledge graph
     */
    async queryGraph(query, options = {}) {
        console.log('🔍 [KNOWLEDGE GRAPH] Querying graph...');
        
        const startTime = Date.now();
        this.metrics.graphQueries++;
        
        try {
            const results = {
                entities: [],
                relationships: [],
                paths: []
            };
            
            // Entity search
            if (query.entityType || query.entityName) {
                results.entities = this.searchEntities(query);
            }
            
            // Relationship search
            if (query.relationshipType || query.sourceEntity || query.targetEntity) {
                results.relationships = this.searchRelationships(query);
            }
            
            // Path finding
            if (query.findPath && query.sourceEntity && query.targetEntity) {
                results.paths = this.findPaths(query.sourceEntity, query.targetEntity, options.maxDepth || 3);
            }
            
            const queryTime = Date.now() - startTime;
            this.updateQueryMetrics(queryTime);
            
            console.log(`✅ [KNOWLEDGE GRAPH] Query completed in ${queryTime}ms`);
            return results;
            
        } catch (error) {
            console.error('❌ [KNOWLEDGE GRAPH] Query failed:', error.message);
            return { entities: [], relationships: [], paths: [] };
        }
    }

    /**
     * Search entities in graph
     */
    searchEntities(query) {
        const results = [];
        
        for (const [id, entity] of this.entities) {
            let matches = true;
            
            if (query.entityType && entity.type !== query.entityType) {
                matches = false;
            }
            
            if (query.entityName && !entity.name.toLowerCase().includes(query.entityName.toLowerCase())) {
                matches = false;
            }
            
            if (matches) {
                results.push(entity);
            }
        }
        
        return results.sort((a, b) => (b.confidence || 0) - (a.confidence || 0));
    }

    /**
     * Search relationships in graph
     */
    searchRelationships(query) {
        const results = [];
        
        for (const [id, relationship] of this.relationships) {
            let matches = true;
            
            if (query.relationshipType && relationship.type !== query.relationshipType) {
                matches = false;
            }
            
            if (query.sourceEntity && relationship.source !== query.sourceEntity) {
                matches = false;
            }
            
            if (query.targetEntity && relationship.target !== query.targetEntity) {
                matches = false;
            }
            
            if (matches) {
                results.push(relationship);
            }
        }
        
        return results.sort((a, b) => b.score - a.score);
    }

    /**
     * Find paths between entities
     */
    findPaths(sourceId, targetId, maxDepth) {
        // Simplified path finding implementation
        const paths = [];
        const visited = new Set();
        
        const findPathsRecursive = (currentId, targetId, currentPath, depth) => {
            if (depth > maxDepth || visited.has(currentId)) {
                return;
            }
            
            visited.add(currentId);
            
            if (currentId === targetId) {
                paths.push([...currentPath, currentId]);
                return;
            }
            
            // Find connected entities
            for (const [id, relationship] of this.relationships) {
                if (relationship.source === currentId) {
                    findPathsRecursive(relationship.target, targetId, [...currentPath, currentId], depth + 1);
                }
            }
            
            visited.delete(currentId);
        };
        
        findPathsRecursive(sourceId, targetId, [], 0);
        return paths;
    }

    /**
     * Generate entity ID
     */
    generateEntityId(type, name) {
        const normalizedName = name.toLowerCase().replace(/[^a-z0-9]/g, '_');
        return `${type}_${normalizedName}_${crypto.createHash('md5').update(name).digest('hex').substring(0, 8)}`;
    }

    /**
     * Generate relationship ID
     */
    generateRelationshipId(sourceId, targetId, type) {
        const combined = `${sourceId}_${type}_${targetId}`;
        return `rel_${crypto.createHash('md5').update(combined).digest('hex').substring(0, 12)}`;
    }

    /**
     * Persist entity to disk
     */
    async persistEntity(entity) {
        try {
            const entityFile = path.join(this.knowledgeGraphDir, 'entities', `${entity.id}.json`);
            await fs.writeFile(entityFile, JSON.stringify(entity, null, 2));
        } catch (error) {
            console.warn('⚠️ [KNOWLEDGE GRAPH] Entity persistence failed:', error.message);
        }
    }

    /**
     * Persist relationship to disk
     */
    async persistRelationship(relationship) {
        try {
            const relationshipFile = path.join(this.knowledgeGraphDir, 'relationships', `${relationship.id}.json`);
            await fs.writeFile(relationshipFile, JSON.stringify(relationship, null, 2));
        } catch (error) {
            console.warn('⚠️ [KNOWLEDGE GRAPH] Relationship persistence failed:', error.message);
        }
    }

    /**
     * Load existing graph data
     */
    async loadExistingGraph() {
        try {
            // Load entities
            const entityFiles = await fs.readdir(path.join(this.knowledgeGraphDir, 'entities'));
            for (const file of entityFiles) {
                if (file.endsWith('.json')) {
                    const entityData = JSON.parse(await fs.readFile(path.join(this.knowledgeGraphDir, 'entities', file), 'utf8'));
                    this.entities.set(entityData.id, entityData);
                    
                    if (!this.entityIndex.has(entityData.type)) {
                        this.entityIndex.set(entityData.type, new Set());
                    }
                    this.entityIndex.get(entityData.type).add(entityData.id);
                }
            }
            
            // Load relationships
            const relationshipFiles = await fs.readdir(path.join(this.knowledgeGraphDir, 'relationships'));
            for (const file of relationshipFiles) {
                if (file.endsWith('.json')) {
                    const relationshipData = JSON.parse(await fs.readFile(path.join(this.knowledgeGraphDir, 'relationships', file), 'utf8'));
                    this.relationships.set(relationshipData.id, relationshipData);
                    
                    if (!this.relationshipIndex.has(relationshipData.type)) {
                        this.relationshipIndex.set(relationshipData.type, new Set());
                    }
                    this.relationshipIndex.get(relationshipData.type).add(relationshipData.id);
                }
            }
            
            console.log(`📚 [KNOWLEDGE GRAPH] Loaded ${this.entities.size} entities and ${this.relationships.size} relationships`);
        } catch (error) {
            console.warn('⚠️ [KNOWLEDGE GRAPH] Graph loading failed:', error.message);
        }
    }

    /**
     * Update query metrics
     */
    updateQueryMetrics(queryTime) {
        this.metrics.averageQueryTime = (this.metrics.averageQueryTime + queryTime) / 2;
        this.metrics.graphSize = this.entities.size + this.relationships.size;
    }

    /**
     * Get performance metrics
     */
    getPerformanceMetrics() {
        return {
            ...this.metrics,
            entitiesCount: this.entities.size,
            relationshipsCount: this.relationships.size,
            entityTypes: this.entityIndex.size,
            relationshipTypes: this.relationshipIndex.size
        };
    }
}

module.exports = KnowledgeGraphFoundation;

// Export for direct usage
if (require.main === module) {
    const knowledgeGraph = new KnowledgeGraphFoundation();
    
    // Example usage
    const exampleContent = `
    function authenticateUser(credentials) {
        // Authentication logic using JWT
        return validateCredentials(credentials);
    }
    
    class UserService {
        constructor() {
            this.database = new PostgreSQL();
        }
    }
    `;
    
    knowledgeGraph.extractEntities(exampleContent, { source: 'example' })
        .then(entities => {
            console.log('\n🔍 EXTRACTED ENTITIES:');
            entities.forEach(entity => {
                console.log(`- ${entity.type}: ${entity.name} (confidence: ${entity.confidence})`);
            });
            
            return knowledgeGraph.createRelationships(entities, { source: 'example' });
        })
        .then(relationships => {
            console.log('\n🔗 CREATED RELATIONSHIPS:');
            relationships.forEach(rel => {
                console.log(`- ${rel.metadata.sourceEntity} ${rel.type} ${rel.metadata.targetEntity} (score: ${rel.score.toFixed(2)})`);
            });
            
            console.log('\n📊 PERFORMANCE METRICS:');
            console.log(JSON.stringify(knowledgeGraph.getPerformanceMetrics(), null, 2));
        })
        .catch(error => {
            console.error('Knowledge graph example failed:', error.message);
        });
}
