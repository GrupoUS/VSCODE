#!/usr/bin/env node

/**
 * GRUPO US CONTINUOUS IMPROVEMENT CLI
 * Command-line interface for continuous improvement system
 */

const ContinuousImprovementSystem = require('./continuous-improvement-system');

class ImprovementCLI {
    constructor() {
        this.improvementSystem = new ContinuousImprovementSystem();
    }

    async run() {
        const args = process.argv.slice(2);
        const command = args[0];

        switch (command) {
            case 'status':
                this.showStatus();
                break;
            case 'review':
                this.runReview(args[1]);
                break;
            case 'schedule':
                this.manageSchedule(args.slice(1));
                break;
            case 'actions':
                this.manageActions(args.slice(1));
                break;
            case 'check':
                this.checkSchedule();
                break;
            case 'report':
                this.generateReport(args[1]);
                break;
            default:
                this.showHelp();
        }
    }

    showStatus() {
        const status = this.improvementSystem.getImprovementStatus();
        
        console.log('\n🔄 CONTINUOUS IMPROVEMENT STATUS');
        console.log('================================');
        console.log(`Total Reviews: ${status.totalReviews}`);
        console.log(`Pending Actions: ${status.pendingActions}`);
        console.log(`Completed Actions: ${status.completedActions}`);
        
        if (status.lastReview) {
            console.log(`\nLast Review: ${status.lastReview.type} (${new Date(status.lastReview.timestamp).toLocaleDateString()})`);
            console.log(`  Findings: ${status.lastReview.findings?.length || 0}`);
            console.log(`  Actions: ${status.lastReview.actions?.length || 0}`);
        }
        
        if (status.nextScheduledReview) {
            console.log(`\nNext Scheduled: ${status.nextScheduledReview.frequency} review`);
            console.log(`  Date: ${status.nextScheduledReview.nextRun.toLocaleString()}`);
        }
    }

    runReview(type) {
        if (!type) {
            console.error('Usage: improvement review <type>');
            console.error('Types: weekly, monthly, quarterly, annual');
            return;
        }

        console.log(`🔄 Running ${type} review...`);
        
        let result;
        switch (type) {
            case 'weekly':
                result = this.improvementSystem.runWeeklyReview();
                break;
            case 'monthly':
                result = this.improvementSystem.runMonthlyReview();
                break;
            case 'quarterly':
                result = this.improvementSystem.runQuarterlyReview();
                break;
            case 'annual':
                result = this.improvementSystem.runAnnualReview();
                break;
            default:
                console.error(`Unknown review type: ${type}`);
                return;
        }

        console.log('\n📊 REVIEW RESULTS');
        console.log('=================');
        console.log(`Type: ${result.type}`);
        console.log(`Period: ${new Date(result.period.start).toLocaleDateString()} - ${new Date(result.period.end).toLocaleDateString()}`);
        console.log(`Findings: ${result.findings?.length || 0}`);
        console.log(`Actions: ${result.actions?.length || 0}`);
        
        if (result.findings && result.findings.length > 0) {
            console.log('\n🔍 KEY FINDINGS:');
            result.findings.slice(0, 3).forEach(finding => {
                const emoji = finding.severity === 'HIGH' ? '🔴' : 
                             finding.severity === 'MEDIUM' ? '🟡' : '🟢';
                console.log(`  ${emoji} ${finding.description}`);
            });
        }
        
        if (result.actions && result.actions.length > 0) {
            console.log('\n📋 ACTIONS CREATED:');
            result.actions.slice(0, 3).forEach(action => {
                const emoji = action.priority === 'CRITICAL' ? '🔴' : 
                             action.priority === 'HIGH' ? '🟡' : '🟢';
                console.log(`  ${emoji} ${action.description}`);
            });
        }
    }

    manageSchedule(args) {
        const subcommand = args[0];
        
        switch (subcommand) {
            case 'show':
                this.showSchedule();
                break;
            case 'enable':
                this.toggleSchedule(args[1], true);
                break;
            case 'disable':
                this.toggleSchedule(args[1], false);
                break;
            default:
                console.log('Schedule subcommands: show, enable <type>, disable <type>');
        }
    }

    showSchedule() {
        try {
            const schedule = JSON.parse(require('fs').readFileSync('./improvement/schedule/review-schedule.json', 'utf8'));
            
            console.log('\n📅 REVIEW SCHEDULE');
            console.log('==================');
            
            Object.keys(schedule).forEach(frequency => {
                const item = schedule[frequency];
                const status = item.enabled ? '✅ Enabled' : '❌ Disabled';
                const nextRun = item.nextRun ? new Date(item.nextRun).toLocaleString() : 'Not scheduled';
                const lastRun = item.lastRun ? new Date(item.lastRun).toLocaleString() : 'Never';
                
                console.log(`\n${frequency.toUpperCase()}:`);
                console.log(`  Status: ${status}`);
                console.log(`  Next Run: ${nextRun}`);
                console.log(`  Last Run: ${lastRun}`);
            });
        } catch (error) {
            console.error('Error loading schedule:', error);
        }
    }

    toggleSchedule(type, enabled) {
        if (!type) {
            console.error('Usage: improvement schedule enable/disable <type>');
            console.error('Types: weekly, monthly, quarterly, annual');
            return;
        }

        try {
            const fs = require('fs');
            const scheduleFile = './improvement/schedule/review-schedule.json';
            const schedule = JSON.parse(fs.readFileSync(scheduleFile, 'utf8'));
            
            if (!schedule[type]) {
                console.error(`Unknown schedule type: ${type}`);
                return;
            }
            
            schedule[type].enabled = enabled;
            fs.writeFileSync(scheduleFile, JSON.stringify(schedule, null, 2));
            
            console.log(`✅ ${type} review ${enabled ? 'enabled' : 'disabled'}`);
        } catch (error) {
            console.error('Error updating schedule:', error);
        }
    }

    manageActions(args) {
        const subcommand = args[0];
        
        switch (subcommand) {
            case 'list':
                this.listActions(args[1]);
                break;
            case 'complete':
                this.completeAction(args[1]);
                break;
            case 'pending':
                this.listActions('pending');
                break;
            default:
                console.log('Actions subcommands: list [status], complete <id>, pending');
        }
    }

    listActions(status) {
        try {
            const fs = require('fs');
            const actionsFile = './improvement/actions/improvement-actions.json';
            
            if (!fs.existsSync(actionsFile)) {
                console.log('No actions found');
                return;
            }
            
            const actions = JSON.parse(fs.readFileSync(actionsFile, 'utf8'));
            const filtered = status ? actions.filter(a => a.status === status) : actions;
            
            console.log(`\n📋 IMPROVEMENT ACTIONS${status ? ` (${status.toUpperCase()})` : ''}`);
            console.log('='.repeat(30 + (status ? status.length + 3 : 0)));
            
            if (filtered.length === 0) {
                console.log('No actions found');
                return;
            }
            
            filtered.slice(0, 10).forEach(action => {
                const emoji = action.priority === 'CRITICAL' ? '🔴' : 
                             action.priority === 'HIGH' ? '🟡' : '🟢';
                const statusEmoji = action.status === 'completed' ? '✅' : 
                                   action.status === 'in_progress' ? '🔄' : '⏳';
                
                console.log(`\n${emoji} ${statusEmoji} ${action.description}`);
                console.log(`  ID: ${action.id}`);
                console.log(`  Type: ${action.type}`);
                console.log(`  Created: ${new Date(action.createdAt).toLocaleDateString()}`);
                if (action.dueDate) {
                    console.log(`  Due: ${new Date(action.dueDate).toLocaleDateString()}`);
                }
                if (action.assignee) {
                    console.log(`  Assignee: ${action.assignee}`);
                }
            });
            
            if (filtered.length > 10) {
                console.log(`\n... and ${filtered.length - 10} more actions`);
            }
        } catch (error) {
            console.error('Error loading actions:', error);
        }
    }

    completeAction(actionId) {
        if (!actionId) {
            console.error('Usage: improvement actions complete <actionId>');
            return;
        }

        try {
            const fs = require('fs');
            const actionsFile = './improvement/actions/improvement-actions.json';
            const actions = JSON.parse(fs.readFileSync(actionsFile, 'utf8'));
            
            const action = actions.find(a => a.id.toString() === actionId);
            if (!action) {
                console.error(`Action not found: ${actionId}`);
                return;
            }
            
            action.status = 'completed';
            action.completedAt = new Date().toISOString();
            
            fs.writeFileSync(actionsFile, JSON.stringify(actions, null, 2));
            console.log(`✅ Action completed: ${action.description}`);
        } catch (error) {
            console.error('Error completing action:', error);
        }
    }

    checkSchedule() {
        console.log('⏰ Checking scheduled reviews...');
        this.improvementSystem.checkSchedule();
        console.log('✅ Schedule check completed');
    }

    generateReport(type) {
        if (!type) {
            console.error('Usage: improvement report <type>');
            console.error('Types: summary, detailed, trends');
            return;
        }

        console.log(`📊 Generating ${type} improvement report...`);
        
        const status = this.improvementSystem.getImprovementStatus();
        
        console.log('\n📋 IMPROVEMENT SYSTEM REPORT');
        console.log('============================');
        console.log(`Report Type: ${type}`);
        console.log(`Generated: ${new Date().toLocaleString()}`);
        
        console.log('\n📊 SYSTEM METRICS:');
        console.log(`  Total Reviews: ${status.totalReviews}`);
        console.log(`  Pending Actions: ${status.pendingActions}`);
        console.log(`  Completed Actions: ${status.completedActions}`);
        console.log(`  Success Rate: ${status.completedActions > 0 ? ((status.completedActions / (status.pendingActions + status.completedActions)) * 100).toFixed(1) : 0}%`);
        
        if (status.lastReview) {
            console.log('\n📋 LATEST REVIEW:');
            console.log(`  Type: ${status.lastReview.type}`);
            console.log(`  Date: ${new Date(status.lastReview.timestamp).toLocaleDateString()}`);
            console.log(`  Findings: ${status.lastReview.findings?.length || 0}`);
            console.log(`  Actions Created: ${status.lastReview.actions?.length || 0}`);
        }
        
        if (status.nextScheduledReview) {
            console.log('\n⏰ UPCOMING:');
            console.log(`  Next Review: ${status.nextScheduledReview.frequency}`);
            console.log(`  Scheduled: ${status.nextScheduledReview.nextRun.toLocaleString()}`);
        }
    }

    showHelp() {
        console.log(`
🔄 GRUPO US CONTINUOUS IMPROVEMENT CLI

Usage: npm run improvement:<command> [args]

Commands:
  status                          Show improvement system status
  review <type>                   Run a specific review (weekly, monthly, quarterly, annual)
  schedule show                   Show review schedule
  schedule enable <type>          Enable scheduled review
  schedule disable <type>         Disable scheduled review
  actions list [status]           List improvement actions
  actions complete <id>           Mark action as completed
  actions pending                 List pending actions
  check                          Check and run scheduled reviews
  report <type>                  Generate improvement report

Examples:
  npm run improvement:status
  npm run improvement:review weekly
  npm run improvement:schedule show
  npm run improvement:actions pending
  npm run improvement:check

Review Types: weekly, monthly, quarterly, annual
Action Statuses: pending, in_progress, completed

For more information, see: project-core/rules/README.md
        `);
    }
}

// Run CLI if called directly
if (require.main === module) {
    const cli = new ImprovementCLI();
    cli.run().catch(console.error);
}

module.exports = ImprovementCLI;
