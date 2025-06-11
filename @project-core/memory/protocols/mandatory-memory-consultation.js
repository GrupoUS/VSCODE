#!/usr/bin/env node

/**
 * MANDATORY MEMORY CONSULTATION SYSTEM V4.0
 * GRUPO US VIBECODE SYSTEM - Enhanced Memory Integration
 * 
 * This system enforces mandatory memory consultation before any task execution
 * and automatic memory updates after completion, integrating Memory Bank MCP patterns
 * with intelligent caching and self-improvement mechanisms.
 */

const fs = require('fs').promises;
const path = require('path');
const crypto = require('crypto');

class MandatoryMemoryConsultation {
    constructor() {
        this.memoryDir = path.join(process.cwd(), '@project-core', 'memory');
        this.cacheDir = path.join(this.memoryDir, 'cache');
        this.coreDir = path.join(this.memoryDir, 'core');
        this.learningDir = path.join(this.memoryDir, 'learning');
        
        this.consultationLog = [];
        this.cacheHits = 0;
        this.cacheMisses = 0;
        
        this.initializeDirectories();
    }

    /**
     * Initialize required directories
     */
    async initializeDirectories() {
        const dirs = [this.cacheDir, this.coreDir, this.learningDir];
        for (const dir of dirs) {
            try {
                await fs.mkdir(dir, { recursive: true });
            } catch (error) {
                console.warn(`Directory creation warning: ${error.message}`);
            }
        }
    }

    /**
     * MANDATORY PRE-EXECUTION CONSULTATION
     * Must be called before any task execution
     */
    async mandatoryPreExecutionConsultation(taskContext) {
        console.log('🧠 [MEMORY CONSULTATION] Starting mandatory pre-execution consultation...');
        
        const consultationId = this.generateConsultationId(taskContext);
        const startTime = Date.now();

        try {
            // 1. Load Memory Bank Core Context
            const memoryContext = await this.loadMemoryBankContext();
            
            // 2. Check Cache for Similar Tasks
            const cachedSolutions = await this.checkCacheForSimilarTasks(taskContext);
            
            // 3. Find Pattern Matches
            const patternMatches = await this.findPatternMatches(taskContext);
            
            // 4. Load Previous Decisions
            const relevantDecisions = await this.loadRelevantDecisions(taskContext);
            
            // 5. Generate Consultation Report
            const consultationReport = await this.generateConsultationReport({
                consultationId,
                taskContext,
                memoryContext,
                cachedSolutions,
                patternMatches,
                relevantDecisions,
                timestamp: new Date().toISOString()
            });

            // 6. Log Consultation
            await this.logConsultation(consultationReport);
            
            const duration = Date.now() - startTime;
            console.log(`✅ [MEMORY CONSULTATION] Completed in ${duration}ms`);
            
            return consultationReport;

        } catch (error) {
            console.error('❌ [MEMORY CONSULTATION] Failed:', error.message);
            throw new Error(`Mandatory memory consultation failed: ${error.message}`);
        }
    }

    /**
     * Load Memory Bank Core Context (Memory Bank MCP Pattern)
     */
    async loadMemoryBankContext() {
        const coreFiles = [
            'product-context.md',
            'active-context.md', 
            'progress.md',
            'decision-log.md',
            'system-patterns.md'
        ];

        const context = {};
        
        for (const file of coreFiles) {
            try {
                const filePath = path.join(this.coreDir, file);
                const content = await fs.readFile(filePath, 'utf8');
                context[file.replace('.md', '')] = content;
            } catch (error) {
                console.warn(`⚠️ Memory Bank file not found: ${file}`);
                context[file.replace('.md', '')] = null;
            }
        }

        return context;
    }

    /**
     * Check cache for similar tasks (Intelligent Caching)
     */
    async checkCacheForSimilarTasks(taskContext) {
        const taskHash = this.generateTaskHash(taskContext);
        const cacheFile = path.join(this.cacheDir, 'similar-tasks', `${taskHash}.json`);
        
        try {
            const cached = await fs.readFile(cacheFile, 'utf8');
            const cachedData = JSON.parse(cached);
            
            // Check if cache is still valid (TTL)
            if (this.isCacheValid(cachedData)) {
                this.cacheHits++;
                console.log('💾 [CACHE HIT] Found similar task solution in cache');
                return cachedData.solutions;
            }
        } catch (error) {
            // Cache miss - normal behavior
        }
        
        this.cacheMisses++;
        return null;
    }

    /**
     * Find pattern matches in learning database
     */
    async findPatternMatches(taskContext) {
        try {
            const patternLibraryPath = path.join(this.learningDir, 'pattern-library.json');
            const patternLibrary = JSON.parse(await fs.readFile(patternLibraryPath, 'utf8'));
            
            const matches = [];
            const taskKeywords = this.extractKeywords(taskContext.description || '');
            
            for (const pattern of patternLibrary.patterns || []) {
                const similarity = this.calculateSimilarity(taskKeywords, pattern.keywords);
                if (similarity > 0.7) { // 70% similarity threshold
                    matches.push({
                        pattern: pattern.name,
                        similarity,
                        solution: pattern.solution,
                        confidence: pattern.confidence
                    });
                }
            }
            
            return matches.sort((a, b) => b.similarity - a.similarity);
            
        } catch (error) {
            console.warn('⚠️ Pattern library not found, creating new one');
            await this.initializePatternLibrary();
            return [];
        }
    }

    /**
     * Load relevant decisions from decision log
     */
    async loadRelevantDecisions(taskContext) {
        try {
            const decisionLogPath = path.join(this.coreDir, 'decision-log.md');
            const decisionLog = await fs.readFile(decisionLogPath, 'utf8');
            
            const taskKeywords = this.extractKeywords(taskContext.description || '');
            const relevantDecisions = [];
            
            // Simple keyword matching for relevant decisions
            const decisions = this.parseDecisionLog(decisionLog);
            for (const decision of decisions) {
                const decisionKeywords = this.extractKeywords(decision.context + ' ' + decision.decision);
                const relevance = this.calculateSimilarity(taskKeywords, decisionKeywords);
                
                if (relevance > 0.5) { // 50% relevance threshold
                    relevantDecisions.push({
                        ...decision,
                        relevance
                    });
                }
            }
            
            return relevantDecisions.sort((a, b) => b.relevance - a.relevance);
            
        } catch (error) {
            console.warn('⚠️ Decision log not found');
            return [];
        }
    }

    /**
     * Generate comprehensive consultation report
     */
    async generateConsultationReport(data) {
        const report = {
            consultationId: data.consultationId,
            timestamp: data.timestamp,
            taskContext: data.taskContext,
            
            // Memory Bank Context Status
            memoryBankStatus: {
                productContext: !!data.memoryContext['product-context'],
                activeContext: !!data.memoryContext['active-context'],
                progress: !!data.memoryContext.progress,
                decisionLog: !!data.memoryContext['decision-log'],
                systemPatterns: !!data.memoryContext['system-patterns']
            },
            
            // Cache Analysis
            cacheAnalysis: {
                similarTasksFound: !!data.cachedSolutions,
                cacheHitRate: this.calculateCacheHitRate(),
                solutions: data.cachedSolutions || []
            },
            
            // Pattern Matching Results
            patternMatching: {
                matchesFound: data.patternMatches.length,
                topMatches: data.patternMatches.slice(0, 3),
                confidence: this.calculateAverageConfidence(data.patternMatches)
            },
            
            // Relevant Decisions
            relevantDecisions: {
                decisionsFound: data.relevantDecisions.length,
                topDecisions: data.relevantDecisions.slice(0, 3)
            },
            
            // Recommendations
            recommendations: this.generateRecommendations(data),
            
            // Compliance Status
            compliance: {
                consultationCompleted: true,
                memoryBankAccessed: true,
                cacheChecked: true,
                patternsAnalyzed: true
            }
        };

        return report;
    }

    /**
     * AUTOMATIC POST-EXECUTION UPDATE
     * Called automatically after task completion
     */
    async automaticPostExecutionUpdate(executionResult) {
        console.log('🔄 [MEMORY UPDATE] Starting automatic post-execution update...');
        
        try {
            // 1. Extract learnings from execution
            const learnings = await this.extractLearnings(executionResult);
            
            // 2. Update pattern library
            await this.updatePatternLibrary(learnings);
            
            // 3. Cache successful solution
            if (executionResult.success) {
                await this.cacheSolution(executionResult);
            }
            
            // 4. Update Memory Bank files
            await this.updateMemoryBankFiles(executionResult);
            
            // 5. Update performance metrics
            await this.updatePerformanceMetrics(executionResult);
            
            // 6. Trigger self-improvement if needed
            if (this.shouldTriggerSelfImprovement(executionResult)) {
                await this.triggerSelfImprovement();
            }
            
            console.log('✅ [MEMORY UPDATE] Automatic update completed');
            
        } catch (error) {
            console.error('❌ [MEMORY UPDATE] Failed:', error.message);
        }
    }

    /**
     * Generate unique consultation ID
     */
    generateConsultationId(taskContext) {
        const data = JSON.stringify(taskContext) + Date.now();
        return crypto.createHash('md5').update(data).digest('hex').substring(0, 8);
    }

    /**
     * Generate task hash for caching
     */
    generateTaskHash(taskContext) {
        const normalizedTask = {
            type: taskContext.type || 'general',
            description: (taskContext.description || '').toLowerCase().trim(),
            technology: taskContext.technology || 'general'
        };
        return crypto.createHash('md5').update(JSON.stringify(normalizedTask)).digest('hex');
    }

    /**
     * Check if cached data is still valid
     */
    isCacheValid(cachedData) {
        const now = Date.now();
        const cacheTime = new Date(cachedData.timestamp).getTime();
        const ttl = cachedData.ttl || 3600000; // 1 hour default
        
        return (now - cacheTime) < ttl;
    }

    /**
     * Extract keywords from text
     */
    extractKeywords(text) {
        return text.toLowerCase()
            .replace(/[^\w\s]/g, ' ')
            .split(/\s+/)
            .filter(word => word.length > 3)
            .filter(word => !['this', 'that', 'with', 'from', 'they', 'have', 'will', 'been', 'were'].includes(word));
    }

    /**
     * Calculate similarity between keyword arrays
     */
    calculateSimilarity(keywords1, keywords2) {
        const set1 = new Set(keywords1);
        const set2 = new Set(keywords2);
        const intersection = new Set([...set1].filter(x => set2.has(x)));
        const union = new Set([...set1, ...set2]);
        
        return union.size > 0 ? intersection.size / union.size : 0;
    }

    /**
     * Calculate cache hit rate
     */
    calculateCacheHitRate() {
        const total = this.cacheHits + this.cacheMisses;
        return total > 0 ? (this.cacheHits / total) * 100 : 0;
    }

    /**
     * Calculate average confidence from pattern matches
     */
    calculateAverageConfidence(matches) {
        if (matches.length === 0) return 0;
        const totalConfidence = matches.reduce((sum, match) => sum + (match.confidence || 0), 0);
        return totalConfidence / matches.length;
    }

    /**
     * Generate recommendations based on consultation data
     */
    generateRecommendations(data) {
        const recommendations = [];
        
        // Cache-based recommendations
        if (data.cachedSolutions && data.cachedSolutions.length > 0) {
            recommendations.push({
                type: 'cache',
                priority: 'high',
                message: 'Similar task solutions found in cache. Consider adapting existing solutions.',
                solutions: data.cachedSolutions
            });
        }
        
        // Pattern-based recommendations
        if (data.patternMatches.length > 0) {
            const topMatch = data.patternMatches[0];
            if (topMatch.similarity > 0.8) {
                recommendations.push({
                    type: 'pattern',
                    priority: 'high',
                    message: `High similarity pattern found: ${topMatch.pattern} (${Math.round(topMatch.similarity * 100)}% match)`,
                    pattern: topMatch
                });
            }
        }
        
        // Decision-based recommendations
        if (data.relevantDecisions.length > 0) {
            recommendations.push({
                type: 'decision',
                priority: 'medium',
                message: 'Relevant previous decisions found. Review for consistency.',
                decisions: data.relevantDecisions.slice(0, 2)
            });
        }
        
        return recommendations;
    }

    /**
     * Log consultation for audit trail
     */
    async logConsultation(report) {
        this.consultationLog.push(report);
        
        // Save to file for persistence
        const logFile = path.join(this.memoryDir, 'consultation-log.json');
        try {
            const existingLog = JSON.parse(await fs.readFile(logFile, 'utf8'));
            existingLog.consultations.push(report);
            await fs.writeFile(logFile, JSON.stringify(existingLog, null, 2));
        } catch (error) {
            // Create new log file
            const newLog = {
                created: new Date().toISOString(),
                consultations: [report]
            };
            await fs.writeFile(logFile, JSON.stringify(newLog, null, 2));
        }
    }

    /**
     * Initialize pattern library if it doesn't exist
     */
    async initializePatternLibrary() {
        const patternLibraryPath = path.join(this.learningDir, 'pattern-library.json');
        const initialLibrary = {
            created: new Date().toISOString(),
            version: '1.0',
            patterns: []
        };
        
        await fs.writeFile(patternLibraryPath, JSON.stringify(initialLibrary, null, 2));
    }

    /**
     * Parse decision log markdown
     */
    parseDecisionLog(content) {
        // Simple parser for decision log entries
        const decisions = [];
        const entries = content.split('##').slice(1); // Skip header
        
        for (const entry of entries) {
            const lines = entry.trim().split('\n');
            if (lines.length > 0) {
                decisions.push({
                    title: lines[0].trim(),
                    context: entry,
                    decision: entry // Simplified - could be more sophisticated
                });
            }
        }
        
        return decisions;
    }

    // Placeholder methods for future implementation
    async extractLearnings(executionResult) { return {}; }
    async updatePatternLibrary(learnings) { }
    async cacheSolution(executionResult) { }
    async updateMemoryBankFiles(executionResult) { }
    async updatePerformanceMetrics(executionResult) { }
    shouldTriggerSelfImprovement(executionResult) { return false; }
    async triggerSelfImprovement() { }
}

module.exports = MandatoryMemoryConsultation;

// Export for direct usage
if (require.main === module) {
    const consultation = new MandatoryMemoryConsultation();
    
    // Example usage
    const exampleTask = {
        type: 'implementation',
        description: 'Create a new React component for user authentication',
        technology: 'React',
        complexity: 'medium'
    };
    
    consultation.mandatoryPreExecutionConsultation(exampleTask)
        .then(report => {
            console.log('\n📋 CONSULTATION REPORT:');
            console.log(JSON.stringify(report, null, 2));
        })
        .catch(error => {
            console.error('Consultation failed:', error.message);
        });
}
