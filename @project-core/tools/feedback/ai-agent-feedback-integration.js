/**
 * GRUPO US AI AGENT FEEDBACK INTEGRATION
 * Integrates AI agent performance data with memory-bank system
 */

const fs = require('fs');
const path = require('path');
const DeveloperFeedbackSystem = require('./developer-feedback-system');

class AIAgentFeedbackIntegration {
    constructor() {
        this.feedbackSystem = new DeveloperFeedbackSystem();
        this.memoryBankPath = './memory-bank';
        this.selfCorrectionLog = path.join(this.memoryBankPath, 'self_correction_log.md');
        this.agentPerformanceFile = './feedback/data/agent-performance.json';
        this.errorPatternsFile = './feedback/data/error-patterns.json';
        
        this.initializeIntegration();
    }

    initializeIntegration() {
        // Ensure data directory exists
        const dataDir = path.dirname(this.agentPerformanceFile);
        if (!fs.existsSync(dataDir)) {
            fs.mkdirSync(dataDir, { recursive: true });
        }
    }

    captureAgentPerformance(agent, taskData) {
        const performanceEntry = {
            id: Date.now() + Math.random(),
            timestamp: new Date().toISOString(),
            agent: agent,
            task: {
                description: taskData.description,
                complexity: taskData.complexity,
                duration: taskData.duration,
                success: taskData.success,
                tokenUsage: taskData.tokenUsage,
                rulesUsed: taskData.rulesUsed || [],
                errors: taskData.errors || []
            },
            performance: {
                completionRate: taskData.success ? 100 : 0,
                efficiency: this.calculateEfficiency(taskData),
                ruleAdherence: this.calculateRuleAdherence(taskData),
                errorRate: taskData.errors ? (taskData.errors.length / 1) * 100 : 0
            },
            context: taskData.context || {}
        };

        // Save to agent performance log
        this.saveAgentPerformance(performanceEntry);
        
        // Analyze for patterns
        this.analyzePerformancePatterns(performanceEntry);
        
        // Update memory-bank if significant learning
        if (this.isSignificantLearning(performanceEntry)) {
            this.updateMemoryBank(performanceEntry);
        }

        return performanceEntry;
    }

    calculateEfficiency(taskData) {
        if (!taskData.tokenUsage || !taskData.duration) return null;
        
        // Simple efficiency metric: tokens per minute
        const tokensPerMinute = taskData.tokenUsage / (taskData.duration / 60000);
        
        // Normalize to 0-100 scale (assuming 1000 tokens/min is baseline)
        return Math.min(100, (1000 / tokensPerMinute) * 100);
    }

    calculateRuleAdherence(taskData) {
        if (!taskData.rulesUsed || taskData.rulesUsed.length === 0) return null;
        
        // Calculate based on rules used vs expected rules for task complexity
        const expectedRules = Math.max(1, Math.floor(taskData.complexity / 2));
        const adherenceScore = Math.min(100, (taskData.rulesUsed.length / expectedRules) * 100);
        
        return adherenceScore;
    }

    saveAgentPerformance(performanceEntry) {
        let performances = [];
        if (fs.existsSync(this.agentPerformanceFile)) {
            try {
                performances = JSON.parse(fs.readFileSync(this.agentPerformanceFile, 'utf8'));
            } catch (error) {
                console.error('Error loading agent performance:', error);
            }
        }

        performances.push(performanceEntry);
        
        // Keep only last 200 performance entries
        if (performances.length > 200) {
            performances = performances.slice(-200);
        }

        fs.writeFileSync(this.agentPerformanceFile, JSON.stringify(performances, null, 2));
    }

    analyzePerformancePatterns(performanceEntry) {
        // Load existing patterns
        let patterns = [];
        if (fs.existsSync(this.errorPatternsFile)) {
            try {
                patterns = JSON.parse(fs.readFileSync(this.errorPatternsFile, 'utf8'));
            } catch (error) {
                console.error('Error loading error patterns:', error);
            }
        }

        // Analyze errors for patterns
        if (performanceEntry.task.errors && performanceEntry.task.errors.length > 0) {
            performanceEntry.task.errors.forEach(error => {
                this.updateErrorPattern(patterns, error, performanceEntry);
            });
        }

        // Analyze performance degradation patterns
        if (performanceEntry.performance.completionRate < 80) {
            this.updatePerformancePattern(patterns, performanceEntry);
        }

        fs.writeFileSync(this.errorPatternsFile, JSON.stringify(patterns, null, 2));
    }

    updateErrorPattern(patterns, error, performanceEntry) {
        const errorSignature = this.generateErrorSignature(error);
        
        let pattern = patterns.find(p => p.signature === errorSignature);
        if (!pattern) {
            pattern = {
                signature: errorSignature,
                type: 'error',
                description: error.message || error.toString(),
                occurrences: [],
                frequency: 0,
                affectedAgents: new Set(),
                affectedRules: new Set(),
                firstSeen: performanceEntry.timestamp,
                lastSeen: performanceEntry.timestamp
            };
            patterns.push(pattern);
        }

        pattern.occurrences.push({
            timestamp: performanceEntry.timestamp,
            agent: performanceEntry.agent,
            task: performanceEntry.task.description,
            context: performanceEntry.context
        });
        
        pattern.frequency++;
        pattern.affectedAgents.add(performanceEntry.agent);
        pattern.lastSeen = performanceEntry.timestamp;
        
        if (performanceEntry.task.rulesUsed) {
            performanceEntry.task.rulesUsed.forEach(rule => {
                pattern.affectedRules.add(rule);
            });
        }

        // Convert Sets to Arrays for JSON serialization
        pattern.affectedAgents = Array.from(pattern.affectedAgents);
        pattern.affectedRules = Array.from(pattern.affectedRules);
    }

    updatePerformancePattern(patterns, performanceEntry) {
        const patternSignature = `low_completion_${performanceEntry.agent}`;
        
        let pattern = patterns.find(p => p.signature === patternSignature);
        if (!pattern) {
            pattern = {
                signature: patternSignature,
                type: 'performance',
                description: `Low completion rate for ${performanceEntry.agent}`,
                occurrences: [],
                frequency: 0,
                affectedAgents: [performanceEntry.agent],
                affectedRules: [],
                firstSeen: performanceEntry.timestamp,
                lastSeen: performanceEntry.timestamp
            };
            patterns.push(pattern);
        }

        pattern.occurrences.push({
            timestamp: performanceEntry.timestamp,
            completionRate: performanceEntry.performance.completionRate,
            task: performanceEntry.task.description,
            complexity: performanceEntry.task.complexity
        });
        
        pattern.frequency++;
        pattern.lastSeen = performanceEntry.timestamp;
    }

    generateErrorSignature(error) {
        // Create a signature for error pattern matching
        const message = error.message || error.toString();
        
        // Remove specific values and keep pattern
        const signature = message
            .replace(/\d+/g, 'NUMBER')
            .replace(/['"]/g, '')
            .replace(/\s+/g, ' ')
            .trim()
            .toLowerCase();
            
        return signature;
    }

    isSignificantLearning(performanceEntry) {
        // Determine if this performance data represents significant learning
        const criteria = [
            performanceEntry.task.errors && performanceEntry.task.errors.length > 0,
            performanceEntry.performance.completionRate < 70,
            performanceEntry.performance.efficiency && performanceEntry.performance.efficiency < 50,
            performanceEntry.task.complexity >= 7
        ];

        return criteria.filter(Boolean).length >= 2;
    }

    updateMemoryBank(performanceEntry) {
        try {
            // Read current self-correction log
            let logContent = '';
            if (fs.existsSync(this.selfCorrectionLog)) {
                logContent = fs.readFileSync(this.selfCorrectionLog, 'utf8');
            }

            // Create new entry
            const newEntry = this.generateMemoryBankEntry(performanceEntry);
            
            // Find insertion point (before the final placeholder)
            const placeholder = '_[Futuras entradas de log serão adicionadas aqui automaticamente pelo protocolo de auto-melhoria]_';
            const insertionPoint = logContent.lastIndexOf(placeholder);
            
            if (insertionPoint !== -1) {
                const beforePlaceholder = logContent.substring(0, insertionPoint);
                const afterPlaceholder = logContent.substring(insertionPoint);
                
                logContent = beforePlaceholder + newEntry + '\n\n' + afterPlaceholder;
            } else {
                // If placeholder not found, append to end
                logContent += '\n\n' + newEntry;
            }

            fs.writeFileSync(this.selfCorrectionLog, logContent);
            console.log(`📝 Updated memory-bank with learning from ${performanceEntry.agent}`);
            
        } catch (error) {
            console.error('Error updating memory-bank:', error);
        }
    }

    generateMemoryBankEntry(performanceEntry) {
        const timestamp = new Date().toISOString().split('T')[0];
        const agent = performanceEntry.agent.toUpperCase();
        
        let entry = `## 🤖 AI AGENT PERFORMANCE LEARNING (${timestamp})\n\n`;
        entry += `### **Agent**: ${agent}\n`;
        entry += `### **Task**: ${performanceEntry.task.description}\n`;
        entry += `### **Complexity**: ${performanceEntry.task.complexity}/10\n\n`;
        
        entry += `### **Performance Metrics**:\n`;
        entry += `- **Completion Rate**: ${performanceEntry.performance.completionRate}%\n`;
        if (performanceEntry.performance.efficiency) {
            entry += `- **Efficiency**: ${performanceEntry.performance.efficiency.toFixed(1)}%\n`;
        }
        if (performanceEntry.task.tokenUsage) {
            entry += `- **Token Usage**: ${performanceEntry.task.tokenUsage}\n`;
        }
        if (performanceEntry.task.duration) {
            entry += `- **Duration**: ${(performanceEntry.task.duration / 1000).toFixed(1)}s\n`;
        }

        if (performanceEntry.task.rulesUsed && performanceEntry.task.rulesUsed.length > 0) {
            entry += `\n### **Rules Applied**:\n`;
            performanceEntry.task.rulesUsed.forEach(rule => {
                entry += `- ${rule}\n`;
            });
        }

        if (performanceEntry.task.errors && performanceEntry.task.errors.length > 0) {
            entry += `\n### **Errors Encountered**:\n`;
            performanceEntry.task.errors.forEach(error => {
                entry += `- ${error.message || error.toString()}\n`;
            });
            
            entry += `\n### **Learning Opportunities**:\n`;
            entry += `- Review rule clarity for complexity ${performanceEntry.task.complexity} tasks\n`;
            entry += `- Consider additional guidance for ${agent} agent\n`;
            entry += `- Analyze error patterns for systematic improvements\n`;
        }

        if (performanceEntry.performance.completionRate < 70) {
            entry += `\n### **Improvement Actions**:\n`;
            entry += `- **Priority**: HIGH - Low completion rate detected\n`;
            entry += `- **Recommended**: Review and simplify relevant rules\n`;
            entry += `- **Follow-up**: Monitor ${agent} performance on similar tasks\n`;
        }

        return entry;
    }

    generateAgentPerformanceReport() {
        let performances = [];
        if (fs.existsSync(this.agentPerformanceFile)) {
            try {
                performances = JSON.parse(fs.readFileSync(this.agentPerformanceFile, 'utf8'));
            } catch (error) {
                console.error('Error loading agent performance:', error);
                return null;
            }
        }

        const report = {
            totalSessions: performances.length,
            byAgent: this.groupPerformanceByAgent(performances),
            patterns: this.loadErrorPatterns(),
            trends: this.calculatePerformanceTrends(performances),
            recommendations: this.generateAgentRecommendations(performances),
            generatedAt: new Date().toISOString()
        };

        return report;
    }

    groupPerformanceByAgent(performances) {
        const byAgent = {};
        
        performances.forEach(perf => {
            if (!byAgent[perf.agent]) {
                byAgent[perf.agent] = {
                    sessions: 0,
                    avgCompletionRate: 0,
                    avgEfficiency: 0,
                    totalErrors: 0,
                    avgTokenUsage: 0
                };
            }
            
            const agent = byAgent[perf.agent];
            agent.sessions++;
            agent.avgCompletionRate += perf.performance.completionRate;
            if (perf.performance.efficiency) {
                agent.avgEfficiency += perf.performance.efficiency;
            }
            if (perf.task.errors) {
                agent.totalErrors += perf.task.errors.length;
            }
            if (perf.task.tokenUsage) {
                agent.avgTokenUsage += perf.task.tokenUsage;
            }
        });

        // Calculate averages
        Object.keys(byAgent).forEach(agent => {
            const data = byAgent[agent];
            data.avgCompletionRate = data.avgCompletionRate / data.sessions;
            data.avgEfficiency = data.avgEfficiency / data.sessions;
            data.avgTokenUsage = data.avgTokenUsage / data.sessions;
        });

        return byAgent;
    }

    loadErrorPatterns() {
        if (!fs.existsSync(this.errorPatternsFile)) return [];
        
        try {
            return JSON.parse(fs.readFileSync(this.errorPatternsFile, 'utf8'));
        } catch (error) {
            console.error('Error loading error patterns:', error);
            return [];
        }
    }

    calculatePerformanceTrends(performances) {
        if (performances.length < 10) return {};
        
        const sorted = performances.sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
        const midpoint = Math.floor(sorted.length / 2);
        
        const firstHalf = sorted.slice(0, midpoint);
        const secondHalf = sorted.slice(midpoint);
        
        const firstAvgCompletion = firstHalf.reduce((sum, p) => sum + p.performance.completionRate, 0) / firstHalf.length;
        const secondAvgCompletion = secondHalf.reduce((sum, p) => sum + p.performance.completionRate, 0) / secondHalf.length;
        
        const trend = secondAvgCompletion - firstAvgCompletion;
        
        return {
            completionRateTrend: trend,
            direction: trend > 5 ? 'improving' : trend < -5 ? 'declining' : 'stable',
            firstHalfAvg: firstAvgCompletion,
            secondHalfAvg: secondAvgCompletion
        };
    }

    generateAgentRecommendations(performances) {
        const recommendations = [];
        const byAgent = this.groupPerformanceByAgent(performances);
        
        Object.keys(byAgent).forEach(agent => {
            const data = byAgent[agent];
            
            if (data.avgCompletionRate < 70) {
                recommendations.push({
                    agent: agent,
                    type: 'IMPROVE_COMPLETION_RATE',
                    priority: 'HIGH',
                    message: `${agent} has low completion rate (${data.avgCompletionRate.toFixed(1)}%). Review rule clarity and complexity.`
                });
            }
            
            if (data.avgTokenUsage > 60000) {
                recommendations.push({
                    agent: agent,
                    type: 'OPTIMIZE_TOKEN_USAGE',
                    priority: 'MEDIUM',
                    message: `${agent} uses high tokens per task (${data.avgTokenUsage.toFixed(0)}). Consider rule optimization.`
                });
            }
            
            if (data.totalErrors / data.sessions > 2) {
                recommendations.push({
                    agent: agent,
                    type: 'REDUCE_ERRORS',
                    priority: 'HIGH',
                    message: `${agent} has high error rate (${(data.totalErrors / data.sessions).toFixed(1)} per session). Analyze error patterns.`
                });
            }
        });
        
        return recommendations;
    }
}

module.exports = AIAgentFeedbackIntegration;
