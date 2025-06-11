/**
 * GRUPO US DEVELOPER FEEDBACK SYSTEM
 * Collects and analyzes feedback on rules effectiveness
 */

const fs = require('fs');
const path = require('path');

class DeveloperFeedbackSystem {
    constructor() {
        this.feedbackFile = './feedback/data/developer-feedback.json';
        this.surveysFile = './feedback/data/surveys.json';
        this.issuesFile = './feedback/data/rule-issues.json';
        this.reportsDir = './feedback/reports';
        
        this.initializeDirectories();
    }

    initializeDirectories() {
        const dirs = [
            './feedback',
            './feedback/data',
            './feedback/reports',
            './feedback/templates'
        ];
        
        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
        });
    }

    submitFeedback(feedback) {
        const feedbackEntry = {
            id: Date.now() + Math.random(),
            timestamp: new Date().toISOString(),
            type: feedback.type || 'general',
            category: feedback.category || 'rules',
            rating: feedback.rating, // 1-10 scale
            title: feedback.title,
            description: feedback.description,
            ruleFile: feedback.ruleFile,
            agent: feedback.agent,
            context: feedback.context || {},
            status: 'open',
            priority: this.calculatePriority(feedback),
            tags: feedback.tags || []
        };

        // Load existing feedback
        let allFeedback = [];
        if (fs.existsSync(this.feedbackFile)) {
            try {
                allFeedback = JSON.parse(fs.readFileSync(this.feedbackFile, 'utf8'));
            } catch (error) {
                console.error('Error loading feedback:', error);
            }
        }

        allFeedback.push(feedbackEntry);
        
        // Keep only last 500 feedback entries
        if (allFeedback.length > 500) {
            allFeedback = allFeedback.slice(-500);
        }

        fs.writeFileSync(this.feedbackFile, JSON.stringify(allFeedback, null, 2));
        
        console.log(`✅ Feedback submitted: ${feedbackEntry.title}`);
        console.log(`   Priority: ${feedbackEntry.priority}`);
        console.log(`   ID: ${feedbackEntry.id}`);
        
        return feedbackEntry;
    }

    calculatePriority(feedback) {
        let priority = 'LOW';
        
        // High priority conditions
        if (feedback.rating <= 3) priority = 'HIGH';
        if (feedback.type === 'bug' || feedback.type === 'error') priority = 'HIGH';
        if (feedback.category === 'blocking') priority = 'CRITICAL';
        
        // Medium priority conditions
        if (feedback.rating <= 6 && priority === 'LOW') priority = 'MEDIUM';
        if (feedback.type === 'improvement' && priority === 'LOW') priority = 'MEDIUM';
        
        return priority;
    }

    reportIssue(issue) {
        const issueEntry = {
            id: Date.now() + Math.random(),
            timestamp: new Date().toISOString(),
            title: issue.title,
            description: issue.description,
            ruleFile: issue.ruleFile,
            agent: issue.agent,
            severity: issue.severity || 'MEDIUM',
            type: issue.type || 'conflict', // conflict, gap, unclear, outdated
            reproductionSteps: issue.reproductionSteps || [],
            expectedBehavior: issue.expectedBehavior,
            actualBehavior: issue.actualBehavior,
            status: 'open',
            assignee: null,
            resolution: null,
            tags: issue.tags || []
        };

        // Load existing issues
        let allIssues = [];
        if (fs.existsSync(this.issuesFile)) {
            try {
                allIssues = JSON.parse(fs.readFileSync(this.issuesFile, 'utf8'));
            } catch (error) {
                console.error('Error loading issues:', error);
            }
        }

        allIssues.push(issueEntry);
        fs.writeFileSync(this.issuesFile, JSON.stringify(allIssues, null, 2));
        
        console.log(`🐛 Issue reported: ${issueEntry.title}`);
        console.log(`   Severity: ${issueEntry.severity}`);
        console.log(`   Rule: ${issueEntry.ruleFile || 'General'}`);
        
        return issueEntry;
    }

    createSurvey(surveyData) {
        const survey = {
            id: Date.now() + Math.random(),
            title: surveyData.title,
            description: surveyData.description,
            questions: surveyData.questions,
            createdAt: new Date().toISOString(),
            expiresAt: surveyData.expiresAt,
            status: 'active',
            responses: []
        };

        // Load existing surveys
        let surveys = [];
        if (fs.existsSync(this.surveysFile)) {
            try {
                surveys = JSON.parse(fs.readFileSync(this.surveysFile, 'utf8'));
            } catch (error) {
                console.error('Error loading surveys:', error);
            }
        }

        surveys.push(survey);
        fs.writeFileSync(this.surveysFile, JSON.stringify(surveys, null, 2));
        
        console.log(`📋 Survey created: ${survey.title}`);
        return survey;
    }

    submitSurveyResponse(surveyId, responses, respondentInfo = {}) {
        let surveys = [];
        if (fs.existsSync(this.surveysFile)) {
            try {
                surveys = JSON.parse(fs.readFileSync(this.surveysFile, 'utf8'));
            } catch (error) {
                console.error('Error loading surveys:', error);
                return null;
            }
        }

        const survey = surveys.find(s => s.id === surveyId);
        if (!survey) {
            console.error('Survey not found');
            return null;
        }

        const response = {
            id: Date.now() + Math.random(),
            timestamp: new Date().toISOString(),
            responses: responses,
            respondent: respondentInfo
        };

        survey.responses.push(response);
        fs.writeFileSync(this.surveysFile, JSON.stringify(surveys, null, 2));
        
        console.log(`📝 Survey response submitted for: ${survey.title}`);
        return response;
    }

    getFeedbackSummary(timeframe = 30) {
        const cutoff = new Date(Date.now() - timeframe * 24 * 60 * 60 * 1000);
        
        let feedback = [];
        if (fs.existsSync(this.feedbackFile)) {
            try {
                const allFeedback = JSON.parse(fs.readFileSync(this.feedbackFile, 'utf8'));
                feedback = allFeedback.filter(f => new Date(f.timestamp) >= cutoff);
            } catch (error) {
                console.error('Error loading feedback:', error);
            }
        }

        const summary = {
            totalFeedback: feedback.length,
            averageRating: feedback.length > 0 
                ? feedback.reduce((sum, f) => sum + (f.rating || 0), 0) / feedback.filter(f => f.rating).length
                : 0,
            byPriority: this.groupBy(feedback, 'priority'),
            byCategory: this.groupBy(feedback, 'category'),
            byAgent: this.groupBy(feedback, 'agent'),
            byRuleFile: this.groupBy(feedback, 'ruleFile'),
            trends: this.calculateFeedbackTrends(feedback)
        };

        return summary;
    }

    getIssuesSummary() {
        let issues = [];
        if (fs.existsSync(this.issuesFile)) {
            try {
                issues = JSON.parse(fs.readFileSync(this.issuesFile, 'utf8'));
            } catch (error) {
                console.error('Error loading issues:', error);
            }
        }

        const openIssues = issues.filter(i => i.status === 'open');
        
        return {
            totalIssues: issues.length,
            openIssues: openIssues.length,
            closedIssues: issues.length - openIssues.length,
            bySeverity: this.groupBy(openIssues, 'severity'),
            byType: this.groupBy(openIssues, 'type'),
            byRuleFile: this.groupBy(openIssues, 'ruleFile'),
            criticalIssues: openIssues.filter(i => i.severity === 'CRITICAL'),
            oldestIssues: openIssues.sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp)).slice(0, 5)
        };
    }

    groupBy(array, key) {
        return array.reduce((groups, item) => {
            const value = item[key] || 'Unknown';
            groups[value] = (groups[value] || 0) + 1;
            return groups;
        }, {});
    }

    calculateFeedbackTrends(feedback) {
        if (feedback.length < 2) return {};
        
        const sorted = feedback.sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
        const midpoint = Math.floor(sorted.length / 2);
        
        const firstHalf = sorted.slice(0, midpoint);
        const secondHalf = sorted.slice(midpoint);
        
        const firstAvg = firstHalf.reduce((sum, f) => sum + (f.rating || 0), 0) / firstHalf.filter(f => f.rating).length;
        const secondAvg = secondHalf.reduce((sum, f) => sum + (f.rating || 0), 0) / secondHalf.filter(f => f.rating).length;
        
        const trend = secondAvg - firstAvg;
        
        return {
            ratingTrend: trend,
            direction: trend > 0 ? 'improving' : trend < 0 ? 'declining' : 'stable',
            firstHalfAvg: firstAvg,
            secondHalfAvg: secondAvg
        };
    }

    generateMonthlyReport() {
        const summary = this.getFeedbackSummary(30);
        const issues = this.getIssuesSummary();
        
        const report = {
            period: {
                start: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString(),
                end: new Date().toISOString()
            },
            feedback: summary,
            issues: issues,
            recommendations: this.generateRecommendations(summary, issues),
            generatedAt: new Date().toISOString()
        };

        const reportFile = path.join(this.reportsDir, `monthly-feedback-report-${new Date().toISOString().split('T')[0]}.json`);
        fs.writeFileSync(reportFile, JSON.stringify(report, null, 2));
        
        console.log(`📊 Monthly feedback report generated: ${reportFile}`);
        return report;
    }

    generateRecommendations(feedbackSummary, issuesSummary) {
        const recommendations = [];
        
        // Low rating recommendations
        if (feedbackSummary.averageRating < 6) {
            recommendations.push({
                type: 'IMPROVE_SATISFACTION',
                priority: 'HIGH',
                message: `Average rating is ${feedbackSummary.averageRating.toFixed(1)}/10. Review and improve rule clarity and effectiveness.`
            });
        }
        
        // High priority feedback
        const highPriorityCount = feedbackSummary.byPriority.HIGH || 0;
        if (highPriorityCount > 5) {
            recommendations.push({
                type: 'ADDRESS_HIGH_PRIORITY',
                priority: 'HIGH',
                message: `${highPriorityCount} high-priority feedback items need immediate attention.`
            });
        }
        
        // Critical issues
        if (issuesSummary.criticalIssues.length > 0) {
            recommendations.push({
                type: 'RESOLVE_CRITICAL_ISSUES',
                priority: 'CRITICAL',
                message: `${issuesSummary.criticalIssues.length} critical issues require immediate resolution.`
            });
        }
        
        // Rule-specific issues
        const problematicRules = Object.keys(issuesSummary.byRuleFile)
            .filter(rule => issuesSummary.byRuleFile[rule] > 2)
            .sort((a, b) => issuesSummary.byRuleFile[b] - issuesSummary.byRuleFile[a]);
            
        if (problematicRules.length > 0) {
            recommendations.push({
                type: 'REVIEW_PROBLEMATIC_RULES',
                priority: 'MEDIUM',
                message: `Rules with most issues: ${problematicRules.slice(0, 3).join(', ')}. Consider revision.`
            });
        }
        
        return recommendations;
    }

    createDefaultSurvey() {
        const defaultSurvey = {
            title: 'Monthly Rules System Satisfaction Survey',
            description: 'Help us improve the centralized rules system',
            questions: [
                {
                    id: 'overall_satisfaction',
                    type: 'rating',
                    question: 'How satisfied are you with the centralized rules system?',
                    scale: 10
                },
                {
                    id: 'ease_of_use',
                    type: 'rating',
                    question: 'How easy is it to find and apply the rules?',
                    scale: 10
                },
                {
                    id: 'rule_clarity',
                    type: 'rating',
                    question: 'How clear and understandable are the rules?',
                    scale: 10
                },
                {
                    id: 'most_helpful',
                    type: 'text',
                    question: 'Which rules or sections do you find most helpful?'
                },
                {
                    id: 'improvements',
                    type: 'text',
                    question: 'What improvements would you suggest?'
                },
                {
                    id: 'missing_rules',
                    type: 'text',
                    question: 'Are there any missing rules or gaps you\'ve noticed?'
                }
            ],
            expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString()
        };
        
        return this.createSurvey(defaultSurvey);
    }
}

module.exports = DeveloperFeedbackSystem;
