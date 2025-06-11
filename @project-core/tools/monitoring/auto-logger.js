/**
 * GRUPO US AUTOMATED LOGGING SYSTEM
 * Automatically logs rule usage patterns and performance metrics
 */

const fs = require('fs');
const path = require('path');
const RulesPerformanceDashboard = require('./rules-performance-dashboard');

class AutoLogger {
    constructor() {
        this.dashboard = new RulesPerformanceDashboard();
        this.logFile = './monitoring/logs/auto-log.json';
        this.sessionFile = './monitoring/logs/current-session.json';
        this.isActive = false;
        this.sessionData = {
            startTime: null,
            endTime: null,
            agent: null,
            tasks: [],
            metrics: [],
            errors: []
        };
        
        this.initializeLogging();
    }

    initializeLogging() {
        // Ensure log directory exists
        const logDir = path.dirname(this.logFile);
        if (!fs.existsSync(logDir)) {
            fs.mkdirSync(logDir, { recursive: true });
        }

        // Load existing session if any
        this.loadSession();
    }

    startSession(agent, context = {}) {
        this.sessionData = {
            startTime: new Date().toISOString(),
            endTime: null,
            agent: agent,
            context: context,
            tasks: [],
            metrics: [],
            errors: [],
            ruleLoadings: []
        };
        
        this.isActive = true;
        this.saveSession();
        
        console.log(`📊 Auto-logging started for agent: ${agent}`);
        
        // Record session start metric
        this.dashboard.recordMetric('session_start', 1, {
            agent: agent,
            ...context
        });
    }

    endSession() {
        if (!this.isActive) return;
        
        this.sessionData.endTime = new Date().toISOString();
        this.isActive = false;
        
        // Calculate session metrics
        const sessionMetrics = this.calculateSessionMetrics();
        
        // Record final metrics
        Object.keys(sessionMetrics).forEach(metric => {
            this.dashboard.recordMetric(metric, sessionMetrics[metric], {
                agent: this.sessionData.agent,
                sessionType: 'complete'
            });
        });
        
        // Save to permanent log
        this.saveToLog();
        
        console.log(`📊 Auto-logging ended. Session duration: ${sessionMetrics.duration}ms`);
        console.log(`   Tasks completed: ${this.sessionData.tasks.length}`);
        console.log(`   Errors encountered: ${this.sessionData.errors.length}`);
        
        return sessionMetrics;
    }

    logRuleLoading(ruleFile, loadTime, success = true) {
        if (!this.isActive) return;
        
        const logEntry = {
            timestamp: new Date().toISOString(),
            ruleFile: ruleFile,
            loadTime: loadTime,
            success: success
        };
        
        this.sessionData.ruleLoadings.push(logEntry);
        this.saveSession();
        
        // Record loading time metric
        this.dashboard.recordMetric('loading_time', loadTime, {
            agent: this.sessionData.agent,
            ruleFile: ruleFile,
            success: success
        });
    }

    logTaskStart(taskDescription, complexity = 5) {
        if (!this.isActive) return;
        
        const task = {
            id: Date.now() + Math.random(),
            description: taskDescription,
            complexity: complexity,
            startTime: new Date().toISOString(),
            endTime: null,
            success: null,
            tokenUsage: null,
            errors: []
        };
        
        this.sessionData.tasks.push(task);
        this.saveSession();
        
        console.log(`📝 Task started: ${taskDescription} (complexity: ${complexity})`);
        return task.id;
    }

    logTaskEnd(taskId, success, tokenUsage = null, errors = []) {
        if (!this.isActive) return;
        
        const task = this.sessionData.tasks.find(t => t.id === taskId);
        if (!task) return;
        
        task.endTime = new Date().toISOString();
        task.success = success;
        task.tokenUsage = tokenUsage;
        task.errors = errors;
        
        this.saveSession();
        
        // Calculate task duration
        const duration = new Date(task.endTime) - new Date(task.startTime);
        
        // Record metrics
        this.dashboard.recordMetric('completion_rate', success ? 100 : 0, {
            agent: this.sessionData.agent,
            task: task.description,
            complexity: task.complexity,
            duration: duration
        });
        
        if (tokenUsage) {
            this.dashboard.recordMetric('token_usage', tokenUsage, {
                agent: this.sessionData.agent,
                task: task.description,
                complexity: task.complexity
            });
        }
        
        if (errors.length > 0) {
            this.dashboard.recordMetric('error_rate', (errors.length / 1) * 100, {
                agent: this.sessionData.agent,
                task: task.description,
                errors: errors.length
            });
        }
        
        console.log(`✅ Task completed: ${task.description} (${success ? 'SUCCESS' : 'FAILED'})`);
        if (tokenUsage) console.log(`   Token usage: ${tokenUsage}`);
        if (errors.length > 0) console.log(`   Errors: ${errors.length}`);
    }

    logError(error, context = {}) {
        if (!this.isActive) return;
        
        const errorEntry = {
            timestamp: new Date().toISOString(),
            error: error.toString(),
            stack: error.stack,
            context: context
        };
        
        this.sessionData.errors.push(errorEntry);
        this.saveSession();
        
        console.log(`❌ Error logged: ${error.message}`);
    }

    logRuleUsage(ruleFile, context = {}) {
        if (!this.isActive) return;
        
        const usageEntry = {
            timestamp: new Date().toISOString(),
            ruleFile: ruleFile,
            context: context
        };
        
        this.sessionData.metrics.push(usageEntry);
        this.saveSession();
    }

    calculateSessionMetrics() {
        const startTime = new Date(this.sessionData.startTime);
        const endTime = new Date(this.sessionData.endTime || new Date());
        const duration = endTime - startTime;
        
        const completedTasks = this.sessionData.tasks.filter(t => t.success === true);
        const failedTasks = this.sessionData.tasks.filter(t => t.success === false);
        const totalTasks = this.sessionData.tasks.length;
        
        const completionRate = totalTasks > 0 ? (completedTasks.length / totalTasks) * 100 : 0;
        
        const totalTokens = this.sessionData.tasks
            .filter(t => t.tokenUsage)
            .reduce((sum, t) => sum + t.tokenUsage, 0);
        
        const avgTokensPerTask = completedTasks.length > 0 ? totalTokens / completedTasks.length : 0;
        
        const totalErrors = this.sessionData.errors.length + 
            this.sessionData.tasks.reduce((sum, t) => sum + t.errors.length, 0);
        
        const errorRate = totalTasks > 0 ? (totalErrors / totalTasks) * 100 : 0;
        
        const avgLoadingTime = this.sessionData.ruleLoadings.length > 0 
            ? this.sessionData.ruleLoadings.reduce((sum, r) => sum + r.loadTime, 0) / this.sessionData.ruleLoadings.length
            : 0;
        
        return {
            duration,
            completionRate,
            avgTokensPerTask,
            errorRate,
            avgLoadingTime,
            totalTasks,
            completedTasks: completedTasks.length,
            failedTasks: failedTasks.length,
            totalErrors
        };
    }

    saveSession() {
        try {
            fs.writeFileSync(this.sessionFile, JSON.stringify(this.sessionData, null, 2));
        } catch (error) {
            console.error('Error saving session:', error);
        }
    }

    loadSession() {
        try {
            if (fs.existsSync(this.sessionFile)) {
                this.sessionData = JSON.parse(fs.readFileSync(this.sessionFile, 'utf8'));
                this.isActive = this.sessionData.endTime === null;
            }
        } catch (error) {
            console.error('Error loading session:', error);
        }
    }

    saveToLog() {
        try {
            let logs = [];
            if (fs.existsSync(this.logFile)) {
                logs = JSON.parse(fs.readFileSync(this.logFile, 'utf8'));
            }
            
            logs.push({
                ...this.sessionData,
                metrics: this.calculateSessionMetrics()
            });
            
            // Keep only last 100 sessions
            if (logs.length > 100) {
                logs = logs.slice(-100);
            }
            
            fs.writeFileSync(this.logFile, JSON.stringify(logs, null, 2));
        } catch (error) {
            console.error('Error saving to log:', error);
        }
    }

    getSessionStatus() {
        return {
            isActive: this.isActive,
            agent: this.sessionData.agent,
            startTime: this.sessionData.startTime,
            tasksCount: this.sessionData.tasks.length,
            errorsCount: this.sessionData.errors.length,
            currentMetrics: this.isActive ? this.calculateSessionMetrics() : null
        };
    }

    generateSessionReport() {
        if (!this.isActive && !this.sessionData.endTime) {
            console.log('No active or completed session to report');
            return null;
        }
        
        const metrics = this.calculateSessionMetrics();
        
        console.log('\n📊 SESSION REPORT');
        console.log('=================');
        console.log(`Agent: ${this.sessionData.agent}`);
        console.log(`Duration: ${(metrics.duration / 1000 / 60).toFixed(2)} minutes`);
        console.log(`Tasks: ${metrics.totalTasks} (${metrics.completedTasks} completed, ${metrics.failedTasks} failed)`);
        console.log(`Completion Rate: ${metrics.completionRate.toFixed(2)}%`);
        console.log(`Avg Tokens/Task: ${metrics.avgTokensPerTask.toFixed(0)}`);
        console.log(`Error Rate: ${metrics.errorRate.toFixed(2)}%`);
        console.log(`Avg Loading Time: ${metrics.avgLoadingTime.toFixed(0)}ms`);
        
        return metrics;
    }
}

// Global instance for easy access
let globalLogger = null;

function getLogger() {
    if (!globalLogger) {
        globalLogger = new AutoLogger();
    }
    return globalLogger;
}

// Convenience functions
function startLogging(agent, context) {
    return getLogger().startSession(agent, context);
}

function endLogging() {
    return getLogger().endSession();
}

function logTask(description, complexity) {
    return getLogger().logTaskStart(description, complexity);
}

function completeTask(taskId, success, tokenUsage, errors) {
    return getLogger().logTaskEnd(taskId, success, tokenUsage, errors);
}

function logError(error, context) {
    return getLogger().logError(error, context);
}

function logRuleUsage(ruleFile, context) {
    return getLogger().logRuleUsage(ruleFile, context);
}

function getStatus() {
    return getLogger().getSessionStatus();
}

module.exports = {
    AutoLogger,
    getLogger,
    startLogging,
    endLogging,
    logTask,
    completeTask,
    logError,
    logRuleUsage,
    getStatus
};
