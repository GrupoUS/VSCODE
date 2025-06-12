#!/usr/bin/env node

/**
 * ENHANCED TOOL LIBRARY V2.0 - ARCHON INSPIRED
 * GRUPO US VIBECODE SYSTEM - Enhanced with Archon & PraisonAI patterns
 *
 * Implements comprehensive tool library with intelligent recommendations:
 * - Prebuilt tools and examples
 * - MCP server integration
 * - Intelligent tool selection
 * - Performance optimization
 * - Automatic tool configuration
 */

const fs = require("fs").promises;
const path = require("path");
const crypto = require("crypto");

class EnhancedToolLibrary {
    constructor() {
        this.toolsDir = path.join(process.cwd(), '@project-core', 'agents', 'tools');
        this.memoryDir = path.join(process.cwd(), '@project-core', 'memory');
        this.configsDir = path.join(process.cwd(), '@project-core', 'configs');
        
        // Tool library configuration (Archon-inspired)
        this.toolConfig = {
            categories: {
                mcp_servers: {
                    description: "Model Context Protocol servers for AI integration",
                    tools: {
                        sequential_thinking: {
                            name: "Sequential Thinking MCP",
                            description: "Advanced reasoning and problem decomposition",
                            complexity_range: [7, 10],
                            use_cases: ["complex_analysis", "multi_step_reasoning", "problem_solving"],
                            integration: "sequentialthinking_Sequential_Thinking",
                            configuration: {
                                max_thoughts: 10,
                                enable_branching: true,
                                enable_revision: true
                            }
                        },
                        think_mcp_server: {
                            name: "Think MCP Server",
                            description: "Structured reasoning with memory integration",
                            complexity_range: [5, 9],
                            use_cases: ["memory_consultation", "decision_making", "reflection"],
                            integration: "think_think-mcp-server",
                            configuration: {
                                memory_integration: true,
                                cache_enabled: true,
                                reflection_mode: true
                            }
                        },
                        mcp_shrimp: {
                            name: "MCP Shrimp Task Manager",
                            description: "Advanced task coordination and management",
                            complexity_range: [6, 10],
                            use_cases: ["task_coordination", "workflow_management", "project_planning"],
                            integration: "mcp-shrimp-task-manager",
                            configuration: {
                                task_folder: "@project-core/tasks/",
                                enable_validation: true,
                                auto_backup: true
                            }
                        },
                        playwright: {
                            name: "Playwright MCP",
                            description: "Browser automation and testing",
                            complexity_range: [4, 8],
                            use_cases: ["ui_testing", "automation", "web_scraping"],
                            integration: "playwright",
                            configuration: {
                                headless: true,
                                timeout: 30000,
                                screenshot_on_failure: true
                            }
                        },
                        figma: {
                            name: "Figma MCP",
                            description: "Design-to-code integration",
                            complexity_range: [3, 7],
                            use_cases: ["ui_generation", "design_system", "component_creation"],
                            integration: "figma",
                            configuration: {
                                auto_generate_components: true,
                                design_system_integration: true
                            }
                        }
                    }
                },
                development_tools: {
                    description: "Core development and coding tools",
                    tools: {
                        codebase_retrieval: {
                            name: "Codebase Retrieval",
                            description: "Intelligent code analysis and retrieval",
                            complexity_range: [3, 8],
                            use_cases: ["code_analysis", "pattern_matching", "documentation"],
                            integration: "codebase-retrieval",
                            configuration: {
                                index_path: ".augment/",
                                max_results: 20,
                                include_context: true
                            }
                        },
                        str_replace_editor: {
                            name: "String Replace Editor",
                            description: "Precise code editing and modification",
                            complexity_range: [2, 6],
                            use_cases: ["code_editing", "refactoring", "bug_fixes"],
                            integration: "str-replace-editor",
                            configuration: {
                                backup_enabled: true,
                                validation_enabled: true
                            }
                        },
                        save_file: {
                            name: "File Creation Tool",
                            description: "Create new files with content",
                            complexity_range: [1, 4],
                            use_cases: ["file_creation", "template_generation", "documentation"],
                            integration: "save-file",
                            configuration: {
                                auto_format: true,
                                validate_syntax: true
                            }
                        }
                    }
                },
                research_tools: {
                    description: "Research and information gathering tools",
                    tools: {
                        perplexity_search: {
                            name: "Perplexity Search",
                            description: "Advanced AI-powered search and research",
                            complexity_range: [2, 6],
                            use_cases: ["research", "fact_checking", "trend_analysis"],
                            integration: "search_perplexity-search",
                            configuration: {
                                max_results: 10,
                                include_sources: true
                            }
                        },
                        context7_mcp: {
                            name: "Context7 MCP",
                            description: "Documentation and library context retrieval",
                            complexity_range: [3, 7],
                            use_cases: ["documentation_lookup", "api_reference", "library_info"],
                            integration: "resolve-library-id_context7-mcp",
                            configuration: {
                                cache_enabled: true,
                                deep_search: true
                            }
                        }
                    }
                },
                visualization_tools: {
                    description: "Visualization and diagramming tools",
                    tools: {
                        render_mermaid: {
                            name: "Mermaid Diagram Renderer",
                            description: "Create interactive diagrams and flowcharts",
                            complexity_range: [2, 5],
                            use_cases: ["documentation", "architecture_diagrams", "workflow_visualization"],
                            integration: "render-mermaid",
                            configuration: {
                                theme: "default",
                                interactive: true
                            }
                        }
                    }
                }
            },
            recommendation_engine: {
                enabled: true,
                scoring_weights: {
                    complexity_match: 0.30,
                    use_case_relevance: 0.25,
                    performance_history: 0.20,
                    integration_quality: 0.15,
                    learning_curve: 0.10
                },
                fallback_strategy: "suggest_alternatives"
            }
        };
        
        // Tool usage metrics and performance tracking
        this.toolMetrics = {};
        this.recommendationHistory = [];
        
        this.initializeToolLibrary();
    }
    
    async initializeToolLibrary() {
        try {
            // Ensure tools directory exists
            await fs.mkdir(this.toolsDir, { recursive: true });
            
            // Load tool metrics
            await this.loadToolMetrics();
            
            // Load recommendation history
            await this.loadRecommendationHistory();
            
            console.log('✅ Enhanced Tool Library V2.0 initialized successfully');
        } catch (error) {
            console.error('❌ Failed to initialize Enhanced Tool Library:', error);
        }
    }
    
    /**
     * Main tool recommendation entry point (Archon-inspired)
     */
    async recommendTools(taskContext, requirements = {}) {
        const recommendationId = this.generateRecommendationId();
        const timestamp = new Date().toISOString();
        
        console.log(`🔧 [TOOL LIBRARY] Starting tool recommendation ${recommendationId}`);
        
        try {
            // Step 1: Analyze task requirements
            const taskAnalysis = await this.analyzeTaskForTools(taskContext);
            
            // Step 2: Score available tools
            const toolScoring = await this.scoreAvailableTools(taskAnalysis, requirements);
            
            // Step 3: Apply recommendation strategies
            const recommendations = await this.applyRecommendationStrategies(toolScoring, taskAnalysis);
            
            // Step 4: Validate and optimize recommendations
            const optimizedRecommendations = await this.optimizeRecommendations(recommendations, taskAnalysis);
            
            // Step 5: Generate tool configurations
            const toolConfigurations = await this.generateToolConfigurations(optimizedRecommendations, taskAnalysis);
            
            // Step 6: Create integration plan
            const integrationPlan = await this.createIntegrationPlan(optimizedRecommendations, toolConfigurations);
            
            // Step 7: Log recommendation
            await this.logRecommendation({
                recommendationId,
                timestamp,
                taskContext,
                taskAnalysis,
                recommendations: optimizedRecommendations,
                toolConfigurations,
                integrationPlan
            });
            
            console.log(`✅ [TOOL LIBRARY] Recommendation ${recommendationId} completed - ${optimizedRecommendations.length} tools recommended`);
            
            return {
                recommendationId,
                tools: optimizedRecommendations,
                configurations: toolConfigurations,
                integrationPlan,
                confidence: this.calculateOverallConfidence(optimizedRecommendations)
            };
            
        } catch (error) {
            console.error(`❌ [TOOL LIBRARY] Failed to recommend tools ${recommendationId}:`, error);
            throw error;
        }
    }
    
    /**
     * Analyze task to determine tool requirements
     */
    async analyzeTaskForTools(taskContext) {
        const analysis = {
            complexity: this.assessTaskComplexity(taskContext),
            domains: this.identifyTaskDomains(taskContext),
            useCases: this.extractUseCases(taskContext),
            constraints: this.identifyToolConstraints(taskContext),
            performance_requirements: this.assessPerformanceRequirements(taskContext)
        };
        
        // Enhanced analysis
        analysis.similar_tasks = await this.findSimilarToolUsage(taskContext);
        analysis.integration_needs = this.assessIntegrationNeeds(taskContext);
        analysis.scalability_requirements = this.assessScalabilityNeeds(taskContext);
        
        return analysis;
    }
    
    /**
     * Score all available tools for the task
     */
    async scoreAvailableTools(taskAnalysis, requirements) {
        const toolScores = {};
        
        for (const [categoryName, category] of Object.entries(this.toolConfig.categories)) {
            for (const [toolName, toolConfig] of Object.entries(category.tools)) {
                const score = await this.scoreToolForTask(toolName, toolConfig, taskAnalysis, requirements);
                
                toolScores[toolName] = {
                    category: categoryName,
                    config: toolConfig,
                    score: score,
                    reasoning: score.reasoning
                };
            }
        }
        
        return toolScores;
    }
    
    /**
     * Score individual tool for task compatibility
     */
    async scoreToolForTask(toolName, toolConfig, taskAnalysis, requirements) {
        const scores = {
            complexity_match: this.scoreComplexityMatch(toolConfig, taskAnalysis),
            use_case_relevance: this.scoreUseCaseRelevance(toolConfig, taskAnalysis),
            performance_history: this.scorePerformanceHistory(toolName),
            integration_quality: this.scoreIntegrationQuality(toolConfig, taskAnalysis),
            learning_curve: this.scoreLearningCurve(toolConfig, requirements)
        };
        
        // Calculate weighted overall score
        const weights = this.toolConfig.recommendation_engine.scoring_weights;
        const overallScore = Object.entries(scores).reduce((total, [metric, score]) => {
            return total + (score * (weights[metric] || 0));
        }, 0);
        
        return {
            overall: overallScore,
            breakdown: scores,
            reasoning: this.generateScoringReasoning(toolName, scores, overallScore)
        };
    }
    
    /**
     * Apply recommendation strategies to select best tools
     */
    async applyRecommendationStrategies(toolScoring, taskAnalysis) {
        // Sort tools by overall score
        const sortedTools = Object.entries(toolScoring)
            .sort(([,a], [,b]) => b.score.overall - a.score.overall);
        
        const recommendations = [];
        const usedCategories = new Set();
        
        // Primary recommendations (top scoring tools)
        for (const [toolName, toolData] of sortedTools) {
            if (toolData.score.overall >= 0.7 && recommendations.length < 5) {
                recommendations.push({
                    tool: toolName,
                    category: toolData.category,
                    config: toolData.config,
                    score: toolData.score.overall,
                    priority: 'primary',
                    reasoning: toolData.reasoning
                });
                usedCategories.add(toolData.category);
            }
        }
        
        // Secondary recommendations (fill gaps in categories)
        for (const [toolName, toolData] of sortedTools) {
            if (!usedCategories.has(toolData.category) && 
                toolData.score.overall >= 0.5 && 
                recommendations.length < 8) {
                recommendations.push({
                    tool: toolName,
                    category: toolData.category,
                    config: toolData.config,
                    score: toolData.score.overall,
                    priority: 'secondary',
                    reasoning: toolData.reasoning
                });
                usedCategories.add(toolData.category);
            }
        }
        
        return recommendations;
    }
    
    /**
     * Optimize recommendations based on task context
     */
    async optimizeRecommendations(recommendations, taskAnalysis) {
        // Remove conflicting tools
        const optimized = this.removeConflictingTools(recommendations);
        
        // Ensure essential tools for complexity level
        this.ensureEssentialTools(optimized, taskAnalysis);
        
        // Optimize for performance
        this.optimizeForPerformance(optimized, taskAnalysis);
        
        return optimized;
    }
    
    /**
     * Generate tool configurations for recommended tools
     */
    async generateToolConfigurations(recommendations, taskAnalysis) {
        const configurations = {};
        
        for (const recommendation of recommendations) {
            const baseConfig = recommendation.config.configuration || {};
            const optimizedConfig = await this.optimizeToolConfiguration(
                recommendation.tool,
                baseConfig,
                taskAnalysis
            );
            
            configurations[recommendation.tool] = {
                integration: recommendation.config.integration,
                configuration: optimizedConfig,
                priority: recommendation.priority,
                estimated_setup_time: this.estimateSetupTime(recommendation.tool, optimizedConfig)
            };
        }
        
        return configurations;
    }
    
    /**
     * Create integration plan for recommended tools
     */
    async createIntegrationPlan(recommendations, configurations) {
        const plan = {
            phases: [],
            dependencies: {},
            estimated_total_time: 0,
            integration_order: []
        };
        
        // Phase 1: Essential tools (primary recommendations)
        const primaryTools = recommendations.filter(r => r.priority === 'primary');
        if (primaryTools.length > 0) {
            plan.phases.push({
                phase: 1,
                name: "Essential Tools Setup",
                tools: primaryTools.map(t => t.tool),
                estimated_time: primaryTools.reduce((total, tool) => {
                    return total + (configurations[tool.tool]?.estimated_setup_time || 10);
                }, 0)
            });
        }
        
        // Phase 2: Supporting tools (secondary recommendations)
        const secondaryTools = recommendations.filter(r => r.priority === 'secondary');
        if (secondaryTools.length > 0) {
            plan.phases.push({
                phase: 2,
                name: "Supporting Tools Setup",
                tools: secondaryTools.map(t => t.tool),
                estimated_time: secondaryTools.reduce((total, tool) => {
                    return total + (configurations[tool.tool]?.estimated_setup_time || 5);
                }, 0)
            });
        }
        
        // Calculate total time and integration order
        plan.estimated_total_time = plan.phases.reduce((total, phase) => total + phase.estimated_time, 0);
        plan.integration_order = plan.phases.flatMap(phase => phase.tools);
        
        return plan;
    }
    
    // Helper methods for scoring
    scoreComplexityMatch(toolConfig, taskAnalysis) {
        const toolRange = toolConfig.complexity_range || [1, 10];
        const taskComplexity = taskAnalysis.complexity;
        
        if (taskComplexity >= toolRange[0] && taskComplexity <= toolRange[1]) {
            return 1.0; // Perfect match
        } else if (taskComplexity < toolRange[0]) {
            return Math.max(0.3, 1 - (toolRange[0] - taskComplexity) * 0.2);
        } else {
            return Math.max(0.3, 1 - (taskComplexity - toolRange[1]) * 0.2);
        }
    }
    
    scoreUseCaseRelevance(toolConfig, taskAnalysis) {
        const toolUseCases = toolConfig.use_cases || [];
        const taskUseCases = taskAnalysis.useCases;
        
        const matches = toolUseCases.filter(useCase => 
            taskUseCases.some(taskUseCase => 
                taskUseCase.toLowerCase().includes(useCase.toLowerCase()) ||
                useCase.toLowerCase().includes(taskUseCase.toLowerCase())
            )
        );
        
        return matches.length / Math.max(toolUseCases.length, taskUseCases.length, 1);
    }
    
    scorePerformanceHistory(toolName) {
        const metrics = this.toolMetrics[toolName];
        if (!metrics) return 0.5; // Default score for new tools
        
        return (metrics.success_rate * 0.6 + metrics.performance_score * 0.4);
    }
    
    scoreIntegrationQuality(toolConfig, taskAnalysis) {
        // Simplified integration quality scoring
        const hasIntegration = !!toolConfig.integration;
        const hasConfiguration = !!toolConfig.configuration;
        
        return (hasIntegration ? 0.7 : 0.3) + (hasConfiguration ? 0.3 : 0.1);
    }
    
    scoreLearningCurve(toolConfig, requirements) {
        // Simplified learning curve assessment
        const complexity = toolConfig.complexity_range ? 
            (toolConfig.complexity_range[1] - toolConfig.complexity_range[0]) : 5;
        
        return Math.max(0.2, 1 - (complexity * 0.1));
    }
    
    generateScoringReasoning(toolName, scores, overallScore) {
        const topScore = Object.entries(scores)
            .sort(([,a], [,b]) => b - a)[0];
        
        return `${toolName} scored ${overallScore.toFixed(3)} overall, strongest in ${topScore[0]} (${topScore[1].toFixed(3)})`;
    }
    
    // Helper methods for task analysis
    assessTaskComplexity(taskContext) {
        // Simplified complexity assessment
        const description = taskContext.description || '';
        let complexity = 5;
        
        if (description.includes('simple') || description.includes('basic')) complexity -= 2;
        if (description.includes('complex') || description.includes('advanced')) complexity += 2;
        if (description.includes('integration') || description.includes('system')) complexity += 1;
        
        return Math.max(1, Math.min(10, complexity));
    }
    
    identifyTaskDomains(taskContext) {
        const description = taskContext.description || '';
        const domains = [];
        
        if (description.includes('frontend') || description.includes('ui')) domains.push('frontend');
        if (description.includes('backend') || description.includes('api')) domains.push('backend');
        if (description.includes('test') || description.includes('automation')) domains.push('testing');
        if (description.includes('research') || description.includes('analyze')) domains.push('research');
        
        return domains.length > 0 ? domains : ['general'];
    }
    
    extractUseCases(taskContext) {
        const description = taskContext.description || '';
        const useCases = [];
        
        // Extract use cases based on keywords
        const useCaseMap = {
            'code': ['code_editing', 'refactoring'],
            'test': ['testing', 'automation'],
            'research': ['research', 'analysis'],
            'design': ['ui_generation', 'design_system'],
            'task': ['task_coordination', 'workflow_management']
        };
        
        for (const [keyword, cases] of Object.entries(useCaseMap)) {
            if (description.toLowerCase().includes(keyword)) {
                useCases.push(...cases);
            }
        }
        
        return useCases.length > 0 ? useCases : ['general'];
    }
    
    identifyToolConstraints(taskContext) {
        return taskContext.constraints || [];
    }
    
    assessPerformanceRequirements(taskContext) {
        return {
            speed: 'medium',
            accuracy: 'high',
            reliability: 'high'
        };
    }
    
    async findSimilarToolUsage(taskContext) {
        // Simplified similar task finding
        return [];
    }
    
    assessIntegrationNeeds(taskContext) {
        return ['mcp_integration', 'workflow_coordination'];
    }
    
    assessScalabilityNeeds(taskContext) {
        return 'medium';
    }
    
    removeConflictingTools(recommendations) {
        // Remove tools that conflict with each other
        return recommendations; // Simplified - no conflicts for now
    }
    
    ensureEssentialTools(recommendations, taskAnalysis) {
        // Ensure essential tools are included based on complexity
        if (taskAnalysis.complexity >= 7) {
            const hasSequentialThinking = recommendations.some(r => r.tool === 'sequential_thinking');
            if (!hasSequentialThinking) {
                // Add sequential thinking as essential for high complexity
                const sequentialThinking = this.toolConfig.categories.mcp_servers.tools.sequential_thinking;
                recommendations.push({
                    tool: 'sequential_thinking',
                    category: 'mcp_servers',
                    config: sequentialThinking,
                    score: 0.9,
                    priority: 'primary',
                    reasoning: 'Essential for high complexity tasks'
                });
            }
        }
    }
    
    optimizeForPerformance(recommendations, taskAnalysis) {
        // Optimize tool selection for performance
        // This could involve removing redundant tools or selecting faster alternatives
    }
    
    async optimizeToolConfiguration(toolName, baseConfig, taskAnalysis) {
        // Optimize tool configuration based on task requirements
        const optimized = { ...baseConfig };
        
        // Task-specific optimizations
        if (taskAnalysis.complexity >= 8 && toolName === 'sequential_thinking') {
            optimized.max_thoughts = 15; // Increase for complex tasks
            optimized.enable_revision = true;
        }
        
        if (taskAnalysis.performance_requirements.speed === 'high') {
            optimized.timeout = optimized.timeout ? optimized.timeout * 0.8 : 20000;
        }
        
        return optimized;
    }
    
    estimateSetupTime(toolName, configuration) {
        // Estimate setup time in minutes
        const baseTime = {
            'sequential_thinking': 5,
            'think_mcp_server': 3,
            'mcp_shrimp': 8,
            'playwright': 10,
            'figma': 7
        };
        
        return baseTime[toolName] || 5;
    }
    
    calculateOverallConfidence(recommendations) {
        if (recommendations.length === 0) return 0;
        
        const averageScore = recommendations.reduce((sum, rec) => sum + rec.score, 0) / recommendations.length;
        return Math.min(averageScore, 1.0);
    }
    
    generateRecommendationId() {
        return crypto.randomBytes(6).toString('hex');
    }
    
    async loadToolMetrics() {
        try {
            const metricsFile = path.join(this.toolsDir, 'tool-metrics.json');
            const metricsData = await fs.readFile(metricsFile, 'utf8');
            this.toolMetrics = JSON.parse(metricsData);
        } catch (error) {
            this.toolMetrics = {};
        }
    }
    
    async loadRecommendationHistory() {
        try {
            const historyFile = path.join(this.toolsDir, 'recommendation-history.json');
            const historyData = await fs.readFile(historyFile, 'utf8');
            this.recommendationHistory = JSON.parse(historyData);
        } catch (error) {
            this.recommendationHistory = [];
        }
    }
    
    async logRecommendation(recommendationData) {
        // Add to recommendation history
        this.recommendationHistory.push(recommendationData);
        
        // Keep only last 500 recommendations
        if (this.recommendationHistory.length > 500) {
            this.recommendationHistory = this.recommendationHistory.slice(-500);
        }
        
        // Save recommendation history
        const historyFile = path.join(this.toolsDir, 'recommendation-history.json');
        await fs.writeFile(historyFile, JSON.stringify(this.recommendationHistory, null, 2));
        
        console.log(`📝 [TOOL LIBRARY] Logged recommendation ${recommendationData.recommendationId}`);
    }
}

// Export for use in other modules
module.exports = EnhancedToolLibrary;

// CLI usage
if (require.main === module) {
    const toolLibrary = new EnhancedToolLibrary();
    
    // Example usage
    const exampleTask = {
        description: "Create a complex React component with TypeScript, testing, and documentation",
        requirements: ["high_performance", "comprehensive_testing"],
        constraints: ["existing_design_system"]
    };
    
    toolLibrary.recommendTools(exampleTask)
        .then(recommendation => {
            console.log('\n🎉 Tool Recommendations:');
            recommendation.tools.forEach(tool => {
                console.log(`🔧 ${tool.tool} (${tool.category}) - Score: ${(tool.score * 100).toFixed(1)}%`);
                console.log(`   ${tool.reasoning}`);
            });
            console.log(`\n📊 Overall Confidence: ${(recommendation.confidence * 100).toFixed(1)}%`);
            console.log(`⏱️ Estimated Setup Time: ${recommendation.integrationPlan.estimated_total_time} minutes`);
        })
        .catch(error => {
            console.error('❌ Tool recommendation failed:', error);
        });
}
