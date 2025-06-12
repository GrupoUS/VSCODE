/**
 * GRUPO US VIBECODE SYSTEM V4.5 - Knowledge Graph Query Engine
 * Fast query system for knowledge graph with < 100ms performance
 * 
 * @version 1.0.0
 * @author GRUPO US - VIBECODE SYSTEM
 * @date 2025-02-13
 */

const fs = require('fs').promises;
const path = require('path');

class KnowledgeGraphQuery {
    constructor() {
        this.knowledgeGraphPath = path.join(__dirname, 'knowledge_graph.json');
        this.cache = null;
        this.lastLoaded = null;
        this.cacheTimeout = 5 * 60 * 1000; // 5 minutes
    }

    /**
     * Load knowledge graph with caching
     */
    async loadKnowledgeGraph() {
        const now = Date.now();
        
        // Use cache if available and not expired
        if (this.cache && this.lastLoaded && (now - this.lastLoaded) < this.cacheTimeout) {
            return this.cache;
        }
        
        try {
            const data = await fs.readFile(this.knowledgeGraphPath, 'utf8');
            this.cache = JSON.parse(data);
            this.lastLoaded = now;
            return this.cache;
        } catch (error) {
            console.error('❌ Failed to load knowledge graph:', error.message);
            return { solutions: [], contexts: [], patterns: { success: [], error: [] } };
        }
    }

    /**
     * Query solutions by context or type
     * @param {string} context - Context to search for
     * @param {string} type - Solution type to filter by
     * @returns {array} Matching solutions
     */
    async querySolutions(context = null, type = null) {
        const startTime = Date.now();
        
        try {
            const kg = await this.loadKnowledgeGraph();
            let results = kg.solutions || [];
            
            if (context) {
                results = results.filter(sol => 
                    sol.context === context || 
                    sol.solution?.approach?.toLowerCase().includes(context.toLowerCase())
                );
            }
            
            if (type) {
                results = results.filter(sol => sol.type === type);
            }
            
            // Sort by confidence and recency
            results.sort((a, b) => {
                const confidenceDiff = (b.confidence || 0) - (a.confidence || 0);
                if (Math.abs(confidenceDiff) > 0.1) return confidenceDiff;
                return new Date(b.timestamp) - new Date(a.timestamp);
            });
            
            const queryTime = Date.now() - startTime;
            console.log(`🔍 [KNOWLEDGE GRAPH] Query completed in ${queryTime}ms - Found ${results.length} solutions`);
            
            return results;
        } catch (error) {
            console.error('❌ Solution query failed:', error.message);
            return [];
        }
    }

    /**
     * Query success patterns
     * @param {string} domain - Domain to search in
     * @returns {array} Matching success patterns
     */
    async querySuccessPatterns(domain = null) {
        const startTime = Date.now();
        
        try {
            const kg = await this.loadKnowledgeGraph();
            let patterns = kg.patterns?.success || [];
            
            if (domain) {
                patterns = patterns.filter(pattern => 
                    pattern.contexts?.includes(domain) ||
                    pattern.description?.toLowerCase().includes(domain.toLowerCase())
                );
            }
            
            // Sort by confidence and occurrences
            patterns.sort((a, b) => {
                const confidenceDiff = (b.confidence || 0) - (a.confidence || 0);
                if (Math.abs(confidenceDiff) > 0.1) return confidenceDiff;
                return (b.occurrences || 0) - (a.occurrences || 0);
            });
            
            const queryTime = Date.now() - startTime;
            console.log(`✅ [KNOWLEDGE GRAPH] Success patterns query completed in ${queryTime}ms - Found ${patterns.length} patterns`);
            
            return patterns;
        } catch (error) {
            console.error('❌ Success patterns query failed:', error.message);
            return [];
        }
    }

    /**
     * Query error patterns for prevention
     * @param {string} context - Context to search for errors
     * @returns {array} Matching error patterns
     */
    async queryErrorPatterns(context = null) {
        const startTime = Date.now();
        
        try {
            const kg = await this.loadKnowledgeGraph();
            let patterns = kg.patterns?.error || [];
            
            if (context) {
                patterns = patterns.filter(pattern => 
                    pattern.contexts?.includes(context) ||
                    pattern.description?.toLowerCase().includes(context.toLowerCase())
                );
            }
            
            // Sort by confidence and occurrences (most critical first)
            patterns.sort((a, b) => {
                const confidenceDiff = (b.confidence || 0) - (a.confidence || 0);
                if (Math.abs(confidenceDiff) > 0.1) return confidenceDiff;
                return (b.occurrences || 0) - (a.occurrences || 0);
            });
            
            const queryTime = Date.now() - startTime;
            console.log(`⚠️ [KNOWLEDGE GRAPH] Error patterns query completed in ${queryTime}ms - Found ${patterns.length} patterns`);
            
            return patterns;
        } catch (error) {
            console.error('❌ Error patterns query failed:', error.message);
            return [];
        }
    }

    /**
     * Find similar contexts
     * @param {string} currentContext - Current context to find similarities for
     * @param {number} limit - Maximum number of results
     * @returns {array} Similar contexts
     */
    async findSimilarContexts(currentContext, limit = 5) {
        const startTime = Date.now();
        
        try {
            const kg = await this.loadKnowledgeGraph();
            const contexts = kg.contexts || [];
            
            // Simple similarity scoring based on tags and domain
            const scored = contexts.map(ctx => {
                let score = 0;
                
                // Domain similarity
                if (ctx.domain && currentContext.includes(ctx.domain)) score += 0.5;
                
                // Tag similarity
                if (ctx.tags) {
                    const matchingTags = ctx.tags.filter(tag => 
                        currentContext.toLowerCase().includes(tag.toLowerCase())
                    );
                    score += matchingTags.length * 0.2;
                }
                
                // Name similarity
                if (ctx.name && currentContext.toLowerCase().includes(ctx.name.toLowerCase())) {
                    score += 0.3;
                }
                
                return { ...ctx, similarity: score };
            });
            
            // Filter and sort by similarity
            const results = scored
                .filter(ctx => ctx.similarity > 0)
                .sort((a, b) => b.similarity - a.similarity)
                .slice(0, limit);
            
            const queryTime = Date.now() - startTime;
            console.log(`🔗 [KNOWLEDGE GRAPH] Similar contexts query completed in ${queryTime}ms - Found ${results.length} contexts`);
            
            return results;
        } catch (error) {
            console.error('❌ Similar contexts query failed:', error.message);
            return [];
        }
    }

    /**
     * Get quick recommendations for a given context
     * @param {string} context - Context to get recommendations for
     * @returns {object} Recommendations object
     */
    async getRecommendations(context) {
        const startTime = Date.now();
        
        try {
            const [solutions, successPatterns, errorPatterns, similarContexts] = await Promise.all([
                this.querySolutions(context),
                this.querySuccessPatterns(context),
                this.queryErrorPatterns(context),
                this.findSimilarContexts(context, 3)
            ]);
            
            const recommendations = {
                context: context,
                timestamp: new Date().toISOString(),
                solutions: solutions.slice(0, 3), // Top 3 solutions
                successPatterns: successPatterns.slice(0, 3), // Top 3 success patterns
                errorPatterns: errorPatterns.slice(0, 2), // Top 2 error patterns to avoid
                similarContexts: similarContexts,
                confidence: this.calculateOverallConfidence(solutions, successPatterns),
                queryTime: Date.now() - startTime
            };
            
            console.log(`💡 [KNOWLEDGE GRAPH] Recommendations generated in ${recommendations.queryTime}ms`);
            return recommendations;
            
        } catch (error) {
            console.error('❌ Recommendations generation failed:', error.message);
            return {
                context: context,
                timestamp: new Date().toISOString(),
                solutions: [],
                successPatterns: [],
                errorPatterns: [],
                similarContexts: [],
                confidence: 0,
                queryTime: Date.now() - startTime,
                error: error.message
            };
        }
    }

    /**
     * Calculate overall confidence based on available data
     */
    calculateOverallConfidence(solutions, patterns) {
        if (solutions.length === 0 && patterns.length === 0) return 0;
        
        const solutionConfidence = solutions.length > 0 ? 
            solutions.reduce((sum, sol) => sum + (sol.confidence || 0), 0) / solutions.length : 0;
        
        const patternConfidence = patterns.length > 0 ? 
            patterns.reduce((sum, pat) => sum + (pat.confidence || 0), 0) / patterns.length : 0;
        
        return (solutionConfidence + patternConfidence) / 2;
    }

    /**
     * Add new solution to knowledge graph
     * @param {object} solution - Solution object to add
     */
    async addSolution(solution) {
        try {
            const kg = await this.loadKnowledgeGraph();
            
            solution.id = solution.id || `sol_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
            solution.timestamp = solution.timestamp || new Date().toISOString();
            
            kg.solutions.push(solution);
            kg.metadata.totalSolutions = kg.solutions.length;
            kg.metadata.lastUpdated = new Date().toISOString();
            
            await fs.writeFile(this.knowledgeGraphPath, JSON.stringify(kg, null, 2));
            
            // Clear cache to force reload
            this.cache = null;
            
            console.log(`📚 [KNOWLEDGE GRAPH] Solution added: ${solution.id}`);
            return solution.id;
            
        } catch (error) {
            console.error('❌ Failed to add solution:', error.message);
            throw error;
        }
    }

    /**
     * Get performance metrics
     */
    getPerformanceMetrics() {
        return {
            cacheEnabled: this.cache !== null,
            lastLoaded: this.lastLoaded,
            cacheAge: this.lastLoaded ? Date.now() - this.lastLoaded : null,
            cacheTimeout: this.cacheTimeout
        };
    }
}

module.exports = KnowledgeGraphQuery;

// CLI usage
if (require.main === module) {
    const query = new KnowledgeGraphQuery();
    const context = process.argv[2] || 'vibecode_system';
    
    query.getRecommendations(context)
        .then(recommendations => {
            console.log('\n📋 KNOWLEDGE GRAPH RECOMMENDATIONS:');
            console.log('=====================================');
            console.log(`Context: ${recommendations.context}`);
            console.log(`Confidence: ${(recommendations.confidence * 100).toFixed(1)}%`);
            console.log(`Query Time: ${recommendations.queryTime}ms`);
            console.log(`\nSolutions Found: ${recommendations.solutions.length}`);
            console.log(`Success Patterns: ${recommendations.successPatterns.length}`);
            console.log(`Error Patterns: ${recommendations.errorPatterns.length}`);
            console.log(`Similar Contexts: ${recommendations.similarContexts.length}`);
        })
        .catch(error => {
            console.error('Query failed:', error.message);
            process.exit(1);
        });
}
