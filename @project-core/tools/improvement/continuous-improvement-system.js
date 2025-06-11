/**
 * GRUPO US CONTINUOUS IMPROVEMENT SYSTEM
 * Implements scheduled reviews and automated improvement workflows
 */

const fs = require('fs');
const path = require('path');
const RulesPerformanceDashboard = require('../monitoring/rules-performance-dashboard');
const DeveloperFeedbackSystem = require('../feedback/developer-feedback-system');
const AIAgentFeedbackIntegration = require('../feedback/ai-agent-feedback-integration');

class ContinuousImprovementSystem {
    constructor() {
        this.dashboard = new RulesPerformanceDashboard();
        this.feedbackSystem = new DeveloperFeedbackSystem();
        this.agentIntegration = new AIAgentFeedbackIntegration();
        
        this.improvementLogFile = './improvement/logs/improvement-log.json';
        this.scheduleFile = './improvement/schedule/review-schedule.json';
        this.actionsFile = './improvement/actions/improvement-actions.json';
        
        this.initializeSystem();
    }

    initializeSystem() {
        const dirs = [
            './improvement',
            './improvement/logs',
            './improvement/schedule',
            './improvement/actions',
            './improvement/reports'
        ];
        
        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
        });

        this.initializeSchedule();
    }

    initializeSchedule() {
        const defaultSchedule = {
            weekly: {
                day: 'Friday',
                time: '17:00',
                enabled: true,
                lastRun: null,
                nextRun: this.calculateNextRun('weekly')
            },
            monthly: {
                day: 'first Monday',
                time: '09:00',
                enabled: true,
                lastRun: null,
                nextRun: this.calculateNextRun('monthly')
            },
            quarterly: {
                month: 'first month',
                day: 'first Monday',
                time: '09:00',
                enabled: true,
                lastRun: null,
                nextRun: this.calculateNextRun('quarterly')
            },
            annual: {
                month: 'January',
                day: 'second Monday',
                time: '09:00',
                enabled: true,
                lastRun: null,
                nextRun: this.calculateNextRun('annual')
            }
        };

        if (!fs.existsSync(this.scheduleFile)) {
            fs.writeFileSync(this.scheduleFile, JSON.stringify(defaultSchedule, null, 2));
        }
    }

    calculateNextRun(frequency) {
        const now = new Date();
        let nextRun = new Date();

        switch (frequency) {
            case 'weekly':
                // Next Friday at 17:00
                nextRun.setDate(now.getDate() + (5 - now.getDay() + 7) % 7);
                nextRun.setHours(17, 0, 0, 0);
                break;
            case 'monthly':
                // First Monday of next month
                nextRun.setMonth(now.getMonth() + 1, 1);
                nextRun.setDate(1 + (1 - nextRun.getDay() + 7) % 7);
                nextRun.setHours(9, 0, 0, 0);
                break;
            case 'quarterly':
                // First Monday of next quarter
                const currentQuarter = Math.floor(now.getMonth() / 3);
                const nextQuarterMonth = (currentQuarter + 1) * 3;
                nextRun.setMonth(nextQuarterMonth, 1);
                nextRun.setDate(1 + (1 - nextRun.getDay() + 7) % 7);
                nextRun.setHours(9, 0, 0, 0);
                break;
            case 'annual':
                // Second Monday of next January
                nextRun.setFullYear(now.getFullYear() + 1, 0, 1);
                nextRun.setDate(1 + (1 - nextRun.getDay() + 7) % 7 + 7);
                nextRun.setHours(9, 0, 0, 0);
                break;
        }

        return nextRun.toISOString();
    }

    runWeeklyReview() {
        console.log('📊 Running weekly rule effectiveness review...');
        
        const metrics = this.dashboard.getDashboardData();
        const feedbackSummary = this.feedbackSystem.getFeedbackSummary(7);
        const agentReport = this.agentIntegration.generateAgentPerformanceReport();
        
        const review = {
            type: 'weekly',
            timestamp: new Date().toISOString(),
            period: {
                start: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
                end: new Date().toISOString()
            },
            metrics: metrics,
            feedback: feedbackSummary,
            agentPerformance: agentReport,
            findings: this.analyzeWeeklyFindings(metrics, feedbackSummary, agentReport),
            actions: this.generateWeeklyActions(metrics, feedbackSummary, agentReport)
        };

        this.saveReview(review);
        this.executeImprovementActions(review.actions);
        
        console.log(`✅ Weekly review completed. ${review.actions.length} actions identified.`);
        return review;
    }

    runMonthlyReview() {
        console.log('📊 Running monthly comprehensive rule analysis...');
        
        const metrics = this.dashboard.getDashboardData();
        const feedbackSummary = this.feedbackSystem.getFeedbackSummary(30);
        const feedbackReport = this.feedbackSystem.generateMonthlyReport();
        const agentReport = this.agentIntegration.generateAgentPerformanceReport();
        
        const review = {
            type: 'monthly',
            timestamp: new Date().toISOString(),
            period: {
                start: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
                end: new Date().toISOString()
            },
            metrics: metrics,
            feedback: feedbackReport,
            agentPerformance: agentReport,
            trends: this.analyzeMonthlyTrends(metrics, feedbackSummary, agentReport),
            findings: this.analyzeMonthlyFindings(metrics, feedbackSummary, agentReport),
            actions: this.generateMonthlyActions(metrics, feedbackSummary, agentReport),
            ruleUpdates: this.identifyRuleUpdates(feedbackSummary, agentReport)
        };

        this.saveReview(review);
        this.executeImprovementActions(review.actions);
        this.processRuleUpdates(review.ruleUpdates);
        
        console.log(`✅ Monthly review completed. ${review.actions.length} actions, ${review.ruleUpdates.length} rule updates identified.`);
        return review;
    }

    runQuarterlyReview() {
        console.log('📊 Running quarterly major rule updates and optimizations...');
        
        const metrics = this.dashboard.getDashboardData();
        const feedbackSummary = this.feedbackSystem.getFeedbackSummary(90);
        const agentReport = this.agentIntegration.generateAgentPerformanceReport();
        
        const review = {
            type: 'quarterly',
            timestamp: new Date().toISOString(),
            period: {
                start: new Date(Date.now() - 90 * 24 * 60 * 60 * 1000).toISOString(),
                end: new Date().toISOString()
            },
            metrics: metrics,
            feedback: feedbackSummary,
            agentPerformance: agentReport,
            strategicAnalysis: this.performStrategicAnalysis(metrics, feedbackSummary, agentReport),
            majorUpdates: this.identifyMajorUpdates(feedbackSummary, agentReport),
            optimizations: this.identifyOptimizations(metrics, agentReport),
            actions: this.generateQuarterlyActions(metrics, feedbackSummary, agentReport)
        };

        this.saveReview(review);
        this.executeImprovementActions(review.actions);
        this.processMajorUpdates(review.majorUpdates);
        
        console.log(`✅ Quarterly review completed. ${review.actions.length} actions, ${review.majorUpdates.length} major updates identified.`);
        return review;
    }

    runAnnualReview() {
        console.log('📊 Running annual complete system review and restructuring assessment...');
        
        const metrics = this.dashboard.getDashboardData();
        const feedbackSummary = this.feedbackSystem.getFeedbackSummary(365);
        const agentReport = this.agentIntegration.generateAgentPerformanceReport();
        
        const review = {
            type: 'annual',
            timestamp: new Date().toISOString(),
            period: {
                start: new Date(Date.now() - 365 * 24 * 60 * 60 * 1000).toISOString(),
                end: new Date().toISOString()
            },
            metrics: metrics,
            feedback: feedbackSummary,
            agentPerformance: agentReport,
            systemAssessment: this.performSystemAssessment(metrics, feedbackSummary, agentReport),
            restructuringNeeds: this.assessRestructuringNeeds(feedbackSummary, agentReport),
            strategicRecommendations: this.generateStrategicRecommendations(metrics, feedbackSummary, agentReport),
            actions: this.generateAnnualActions(metrics, feedbackSummary, agentReport)
        };

        this.saveReview(review);
        this.executeImprovementActions(review.actions);
        
        console.log(`✅ Annual review completed. ${review.actions.length} strategic actions identified.`);
        return review;
    }

    analyzeWeeklyFindings(metrics, feedback, agentReport) {
        const findings = [];
        
        // Performance findings
        if (metrics.status === 'CRITICAL' || metrics.status === 'DEGRADED') {
            findings.push({
                type: 'performance',
                severity: 'HIGH',
                description: `System status is ${metrics.status}`,
                impact: 'Immediate performance degradation affecting all agents'
            });
        }
        
        // Feedback findings
        if (feedback.averageRating < 6) {
            findings.push({
                type: 'satisfaction',
                severity: 'MEDIUM',
                description: `Low satisfaction rating: ${feedback.averageRating.toFixed(1)}/10`,
                impact: 'Developer experience degradation'
            });
        }
        
        // Agent performance findings
        if (agentReport && agentReport.byAgent) {
            Object.keys(agentReport.byAgent).forEach(agent => {
                const data = agentReport.byAgent[agent];
                if (data.avgCompletionRate < 70) {
                    findings.push({
                        type: 'agent_performance',
                        severity: 'HIGH',
                        description: `${agent} has low completion rate: ${data.avgCompletionRate.toFixed(1)}%`,
                        impact: `Reduced effectiveness for ${agent} agent`
                    });
                }
            });
        }
        
        return findings;
    }

    generateWeeklyActions(metrics, feedback, agentReport) {
        const actions = [];
        
        // Critical performance actions
        if (metrics.status === 'CRITICAL') {
            actions.push({
                type: 'immediate',
                priority: 'CRITICAL',
                description: 'Investigate and resolve critical performance issues',
                assignee: 'system_admin',
                dueDate: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
                steps: [
                    'Review active alerts',
                    'Analyze recent metric changes',
                    'Identify root cause',
                    'Implement immediate fixes'
                ]
            });
        }
        
        // High priority feedback actions
        const highPriorityFeedback = feedback.byPriority?.HIGH || 0;
        if (highPriorityFeedback > 3) {
            actions.push({
                type: 'feedback_review',
                priority: 'HIGH',
                description: `Review ${highPriorityFeedback} high-priority feedback items`,
                assignee: 'rules_team',
                dueDate: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(),
                steps: [
                    'Categorize high-priority feedback',
                    'Identify common themes',
                    'Plan rule improvements',
                    'Update affected rules'
                ]
            });
        }
        
        return actions;
    }

    identifyRuleUpdates(feedback, agentReport) {
        const updates = [];
        
        // Identify rules with frequent issues
        if (feedback.byRuleFile) {
            Object.keys(feedback.byRuleFile).forEach(ruleFile => {
                const issueCount = feedback.byRuleFile[ruleFile];
                if (issueCount > 2) {
                    updates.push({
                        ruleFile: ruleFile,
                        type: 'clarity_improvement',
                        priority: issueCount > 5 ? 'HIGH' : 'MEDIUM',
                        description: `Rule has ${issueCount} feedback items - needs clarity improvement`,
                        suggestedChanges: [
                            'Review and simplify language',
                            'Add more examples',
                            'Clarify edge cases',
                            'Update based on feedback patterns'
                        ]
                    });
                }
            });
        }
        
        // Identify rules with low agent performance
        if (agentReport && agentReport.patterns) {
            agentReport.patterns.forEach(pattern => {
                if (pattern.type === 'performance' && pattern.frequency > 3) {
                    updates.push({
                        ruleFile: pattern.affectedRules[0] || 'general',
                        type: 'performance_optimization',
                        priority: 'HIGH',
                        description: `Performance pattern detected: ${pattern.description}`,
                        suggestedChanges: [
                            'Optimize rule complexity',
                            'Improve guidance clarity',
                            'Add performance hints',
                            'Review agent-specific adaptations'
                        ]
                    });
                }
            });
        }
        
        return updates;
    }

    executeImprovementActions(actions) {
        actions.forEach(action => {
            this.logAction(action);
            
            // Execute automated actions
            if (action.type === 'automated') {
                this.executeAutomatedAction(action);
            }
        });
    }

    logAction(action) {
        let actions = [];
        if (fs.existsSync(this.actionsFile)) {
            try {
                actions = JSON.parse(fs.readFileSync(this.actionsFile, 'utf8'));
            } catch (error) {
                console.error('Error loading actions:', error);
            }
        }

        action.id = Date.now() + Math.random();
        action.status = 'pending';
        action.createdAt = new Date().toISOString();
        
        actions.push(action);
        fs.writeFileSync(this.actionsFile, JSON.stringify(actions, null, 2));
    }

    saveReview(review) {
        let reviews = [];
        if (fs.existsSync(this.improvementLogFile)) {
            try {
                reviews = JSON.parse(fs.readFileSync(this.improvementLogFile, 'utf8'));
            } catch (error) {
                console.error('Error loading reviews:', error);
            }
        }

        reviews.push(review);
        
        // Keep only last 50 reviews
        if (reviews.length > 50) {
            reviews = reviews.slice(-50);
        }

        fs.writeFileSync(this.improvementLogFile, JSON.stringify(reviews, null, 2));
        
        // Also save individual report
        const reportFile = `./improvement/reports/${review.type}-review-${new Date().toISOString().split('T')[0]}.json`;
        fs.writeFileSync(reportFile, JSON.stringify(review, null, 2));
    }

    checkSchedule() {
        try {
            const schedule = JSON.parse(fs.readFileSync(this.scheduleFile, 'utf8'));
            const now = new Date();
            
            Object.keys(schedule).forEach(frequency => {
                const item = schedule[frequency];
                if (item.enabled && item.nextRun && new Date(item.nextRun) <= now) {
                    console.log(`⏰ Running scheduled ${frequency} review...`);
                    
                    switch (frequency) {
                        case 'weekly':
                            this.runWeeklyReview();
                            break;
                        case 'monthly':
                            this.runMonthlyReview();
                            break;
                        case 'quarterly':
                            this.runQuarterlyReview();
                            break;
                        case 'annual':
                            this.runAnnualReview();
                            break;
                    }
                    
                    // Update schedule
                    item.lastRun = now.toISOString();
                    item.nextRun = this.calculateNextRun(frequency);
                    fs.writeFileSync(this.scheduleFile, JSON.stringify(schedule, null, 2));
                }
            });
        } catch (error) {
            console.error('Error checking schedule:', error);
        }
    }

    getImprovementStatus() {
        const reviews = this.loadReviews();
        const actions = this.loadActions();
        
        return {
            totalReviews: reviews.length,
            lastReview: reviews[reviews.length - 1],
            pendingActions: actions.filter(a => a.status === 'pending').length,
            completedActions: actions.filter(a => a.status === 'completed').length,
            nextScheduledReview: this.getNextScheduledReview()
        };
    }

    loadReviews() {
        if (!fs.existsSync(this.improvementLogFile)) return [];
        
        try {
            return JSON.parse(fs.readFileSync(this.improvementLogFile, 'utf8'));
        } catch (error) {
            console.error('Error loading reviews:', error);
            return [];
        }
    }

    loadActions() {
        if (!fs.existsSync(this.actionsFile)) return [];
        
        try {
            return JSON.parse(fs.readFileSync(this.actionsFile, 'utf8'));
        } catch (error) {
            console.error('Error loading actions:', error);
            return [];
        }
    }

    getNextScheduledReview() {
        try {
            const schedule = JSON.parse(fs.readFileSync(this.scheduleFile, 'utf8'));
            const nextReviews = Object.keys(schedule)
                .filter(freq => schedule[freq].enabled && schedule[freq].nextRun)
                .map(freq => ({
                    frequency: freq,
                    nextRun: new Date(schedule[freq].nextRun)
                }))
                .sort((a, b) => a.nextRun - b.nextRun);
                
            return nextReviews[0] || null;
        } catch (error) {
            console.error('Error getting next scheduled review:', error);
            return null;
        }
    }
}

module.exports = ContinuousImprovementSystem;
