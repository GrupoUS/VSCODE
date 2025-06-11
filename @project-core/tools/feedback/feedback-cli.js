#!/usr/bin/env node

/**
 * GRUPO US FEEDBACK CLI
 * Command-line interface for developer feedback system
 */

const DeveloperFeedbackSystem = require('./developer-feedback-system');

class FeedbackCLI {
    constructor() {
        this.feedbackSystem = new DeveloperFeedbackSystem();
    }

    async run() {
        const args = process.argv.slice(2);
        const command = args[0];

        switch (command) {
            case 'submit':
                this.submitFeedback(args.slice(1));
                break;
            case 'issue':
                this.reportIssue(args.slice(1));
                break;
            case 'survey':
                this.handleSurvey(args.slice(1));
                break;
            case 'summary':
                this.showSummary();
                break;
            case 'report':
                this.generateReport();
                break;
            case 'interactive':
                this.interactiveFeedback();
                break;
            default:
                this.showHelp();
        }
    }

    submitFeedback(args) {
        if (args.length < 4) {
            console.error('Usage: feedback submit <rating> <title> <description> [ruleFile] [agent]');
            return;
        }

        const feedback = {
            rating: parseInt(args[0]),
            title: args[1],
            description: args[2],
            ruleFile: args[3] || null,
            agent: args[4] || 'unknown',
            type: 'general',
            category: 'rules'
        };

        this.feedbackSystem.submitFeedback(feedback);
    }

    reportIssue(args) {
        if (args.length < 3) {
            console.error('Usage: feedback issue <title> <description> <severity> [ruleFile] [agent]');
            return;
        }

        const issue = {
            title: args[0],
            description: args[1],
            severity: args[2] || 'MEDIUM',
            ruleFile: args[3] || null,
            agent: args[4] || 'unknown',
            type: 'general'
        };

        this.feedbackSystem.reportIssue(issue);
    }

    handleSurvey(args) {
        const subcommand = args[0];

        switch (subcommand) {
            case 'create':
                this.feedbackSystem.createDefaultSurvey();
                break;
            case 'list':
                this.listSurveys();
                break;
            case 'respond':
                console.log('Interactive survey response not implemented in CLI. Use web interface.');
                break;
            default:
                console.log('Survey subcommands: create, list, respond');
        }
    }

    showSummary() {
        const summary = this.feedbackSystem.getFeedbackSummary();
        const issues = this.feedbackSystem.getIssuesSummary();

        console.log('\n📊 FEEDBACK SUMMARY (Last 30 days)');
        console.log('===================================');
        console.log(`Total Feedback: ${summary.totalFeedback}`);
        console.log(`Average Rating: ${summary.averageRating.toFixed(1)}/10`);
        
        if (summary.trends.direction) {
            const emoji = summary.trends.direction === 'improving' ? '📈' : 
                         summary.trends.direction === 'declining' ? '📉' : '➡️';
            console.log(`Trend: ${emoji} ${summary.trends.direction} (${summary.trends.ratingTrend > 0 ? '+' : ''}${summary.trends.ratingTrend.toFixed(1)})`);
        }

        console.log('\n📋 BY PRIORITY:');
        Object.keys(summary.byPriority).forEach(priority => {
            console.log(`  ${priority}: ${summary.byPriority[priority]}`);
        });

        console.log('\n📁 BY RULE FILE:');
        const topRules = Object.keys(summary.byRuleFile)
            .sort((a, b) => summary.byRuleFile[b] - summary.byRuleFile[a])
            .slice(0, 5);
        topRules.forEach(rule => {
            console.log(`  ${rule || 'General'}: ${summary.byRuleFile[rule]} feedback items`);
        });

        console.log('\n🐛 ISSUES SUMMARY');
        console.log('=================');
        console.log(`Total Issues: ${issues.totalIssues}`);
        console.log(`Open Issues: ${issues.openIssues}`);
        console.log(`Closed Issues: ${issues.closedIssues}`);

        if (issues.criticalIssues.length > 0) {
            console.log(`\n🚨 CRITICAL ISSUES (${issues.criticalIssues.length}):`);
            issues.criticalIssues.slice(0, 3).forEach(issue => {
                console.log(`  • ${issue.title} (${issue.ruleFile || 'General'})`);
            });
        }

        console.log('\n🔧 BY SEVERITY:');
        Object.keys(issues.bySeverity).forEach(severity => {
            const emoji = severity === 'CRITICAL' ? '🔴' : 
                         severity === 'HIGH' ? '🟡' : '🟢';
            console.log(`  ${emoji} ${severity}: ${issues.bySeverity[severity]}`);
        });
    }

    generateReport() {
        console.log('📊 Generating monthly feedback report...');
        const report = this.feedbackSystem.generateMonthlyReport();
        
        console.log('\n📋 MONTHLY FEEDBACK REPORT');
        console.log('==========================');
        console.log(`Period: ${new Date(report.period.start).toLocaleDateString()} - ${new Date(report.period.end).toLocaleDateString()}`);
        
        console.log('\n📊 FEEDBACK METRICS:');
        console.log(`  Total Feedback: ${report.feedback.totalFeedback}`);
        console.log(`  Average Rating: ${report.feedback.averageRating.toFixed(1)}/10`);
        console.log(`  Trend: ${report.feedback.trends.direction || 'No trend data'}`);

        console.log('\n🐛 ISSUE METRICS:');
        console.log(`  Total Issues: ${report.issues.totalIssues}`);
        console.log(`  Open Issues: ${report.issues.openIssues}`);
        console.log(`  Critical Issues: ${report.issues.criticalIssues.length}`);

        if (report.recommendations.length > 0) {
            console.log('\n💡 RECOMMENDATIONS:');
            report.recommendations.forEach(rec => {
                const emoji = rec.priority === 'CRITICAL' ? '🔴' : 
                             rec.priority === 'HIGH' ? '🟡' : '🟢';
                console.log(`  ${emoji} ${rec.message}`);
            });
        }

        console.log(`\n📄 Full report saved to: feedback/reports/monthly-feedback-report-${new Date().toISOString().split('T')[0]}.json`);
    }

    interactiveFeedback() {
        console.log('\n🎯 INTERACTIVE FEEDBACK SUBMISSION');
        console.log('==================================');
        console.log('Please provide feedback about the rules system:\n');

        // Simple interactive prompts (in a real implementation, you'd use a library like inquirer)
        console.log('1. Rate your overall satisfaction (1-10):');
        console.log('2. Which rule file are you providing feedback about?');
        console.log('3. What specific feedback do you have?');
        console.log('4. Any suggestions for improvement?');
        
        console.log('\nFor full interactive experience, use the web interface or submit via:');
        console.log('npm run feedback:submit <rating> "<title>" "<description>" [ruleFile] [agent]');
    }

    listSurveys() {
        // This would load and display available surveys
        console.log('\n📋 AVAILABLE SURVEYS');
        console.log('====================');
        console.log('• Monthly Rules System Satisfaction Survey');
        console.log('• Quarterly System Improvement Survey');
        console.log('\nUse: npm run feedback:survey respond <surveyId>');
    }

    showHelp() {
        console.log(`
🎯 GRUPO US FEEDBACK CLI

Usage: npm run feedback:<command> [args]

Commands:
  submit <rating> "<title>" "<description>" [ruleFile] [agent]
    Submit general feedback about the rules system
    
  issue "<title>" "<description>" <severity> [ruleFile] [agent]
    Report an issue with the rules (severity: CRITICAL, HIGH, MEDIUM, LOW)
    
  survey create
    Create a new survey
    
  survey list
    List available surveys
    
  summary
    Show feedback and issues summary
    
  report
    Generate monthly feedback report
    
  interactive
    Start interactive feedback session

Examples:
  npm run feedback:submit 8 "Great improvement" "The new centralized system is much clearer" "project-core/rules/README.md" "cursor"
  
  npm run feedback:issue "Rule conflict" "Conflicting guidance between files" "HIGH" "project-core/rules/frameworks/nextjs-react.md" "cline"
  
  npm run feedback:summary
  
  npm run feedback:report

For more information, see: project-core/rules/README.md
        `);
    }
}

// Run CLI if called directly
if (require.main === module) {
    const cli = new FeedbackCLI();
    cli.run().catch(console.error);
}

module.exports = FeedbackCLI;
