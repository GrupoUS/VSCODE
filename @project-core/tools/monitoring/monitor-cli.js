#!/usr/bin/env node

/**
 * GRUPO US RULES MONITORING CLI
 * Command-line interface for rules performance monitoring
 */

const RulesPerformanceDashboard = require('./rules-performance-dashboard');

class MonitorCLI {
    constructor() {
        this.dashboard = new RulesPerformanceDashboard();
    }

    async run() {
        const args = process.argv.slice(2);
        const command = args[0];

        switch (command) {
            case 'status':
                this.showStatus();
                break;
            case 'record':
                this.recordMetric(args[1], args[2], args[3]);
                break;
            case 'report':
                this.generateReport();
                break;
            case 'alerts':
                this.showAlerts();
                break;
            case 'dashboard':
                this.showDashboard();
                break;
            case 'test':
                this.runTest();
                break;
            default:
                this.showHelp();
        }
    }

    showStatus() {
        const data = this.dashboard.getDashboardData();
        
        console.log('\n🚀 GRUPO US RULES SYSTEM STATUS');
        console.log('================================');
        console.log(`Overall Status: ${this.getStatusEmoji(data.status)} ${data.status}`);
        console.log(`Last Updated: ${new Date(data.lastUpdated).toLocaleString()}`);
        
        console.log('\n📊 PERFORMANCE METRICS:');
        Object.keys(data.summary).forEach(type => {
            const metric = data.summary[type];
            const target = data.targets[type.replace('_', '')];
            const baseline = data.baseline[type.replace('_', '')];
            
            console.log(`\n${type.toUpperCase()}:`);
            console.log(`  Current: ${metric.average?.toFixed(2) || 'N/A'}`);
            console.log(`  Target: ${target || 'N/A'}`);
            console.log(`  Baseline: ${baseline || 'N/A'}`);
            console.log(`  Samples: ${metric.count}`);
            
            if (target && metric.average) {
                const status = this.getMetricStatus(type, metric.average, target);
                console.log(`  Status: ${this.getStatusEmoji(status)} ${status}`);
            }
        });

        if (data.alerts.length > 0) {
            console.log('\n🚨 ACTIVE ALERTS:');
            data.alerts.slice(0, 5).forEach(alert => {
                console.log(`  ${this.getSeverityEmoji(alert.severity)} ${alert.message}`);
            });
            
            if (data.alerts.length > 5) {
                console.log(`  ... and ${data.alerts.length - 5} more alerts`);
            }
        } else {
            console.log('\n✅ No active alerts');
        }
    }

    recordMetric(type, value, context) {
        if (!type || !value) {
            console.error('Usage: monitor record <type> <value> [context]');
            console.error('Types: completion_rate, token_usage, error_rate, loading_time');
            return;
        }

        const numValue = parseFloat(value);
        const contextObj = context ? JSON.parse(context) : {};
        
        const metric = this.dashboard.recordMetric(type, numValue, contextObj);
        console.log(`✅ Recorded ${type}: ${numValue}`);
        
        if (contextObj.agent) {
            console.log(`   Agent: ${contextObj.agent}`);
        }
        if (contextObj.task) {
            console.log(`   Task: ${contextObj.task}`);
        }
    }

    generateReport() {
        console.log('📊 Generating weekly report...');
        const report = this.dashboard.generateWeeklyReport();
        
        console.log('\n📋 WEEKLY PERFORMANCE REPORT');
        console.log('============================');
        console.log(`Period: ${new Date(report.period.start).toLocaleDateString()} - ${new Date(report.period.end).toLocaleDateString()}`);
        
        console.log('\n📊 SUMMARY:');
        Object.keys(report.summary).forEach(type => {
            const data = report.summary[type];
            console.log(`\n${type.toUpperCase()}:`);
            console.log(`  Average: ${data.average.toFixed(2)}`);
            console.log(`  Range: ${data.min} - ${data.max}`);
            console.log(`  Target: ${data.target}`);
            console.log(`  Baseline: ${data.baseline}`);
        });

        if (Object.keys(report.trends).length > 0) {
            console.log('\n📈 TRENDS:');
            Object.keys(report.trends).forEach(type => {
                const trend = report.trends[type];
                const emoji = trend.status === 'good' ? '✅' : trend.status === 'concerning' ? '⚠️' : '➡️';
                console.log(`  ${type}: ${emoji} ${trend.direction} by ${trend.changePercent}%`);
            });
        }

        if (report.recommendations.length > 0) {
            console.log('\n💡 RECOMMENDATIONS:');
            report.recommendations.forEach(rec => {
                const emoji = rec.priority === 'HIGH' ? '🔴' : rec.priority === 'MEDIUM' ? '🟡' : '🟢';
                console.log(`  ${emoji} ${rec.message}`);
            });
        }
    }

    showAlerts() {
        const alerts = this.dashboard.getActiveAlerts();
        
        if (alerts.length === 0) {
            console.log('✅ No active alerts');
            return;
        }

        console.log('\n🚨 ACTIVE ALERTS');
        console.log('================');
        
        const grouped = {};
        alerts.forEach(alert => {
            if (!grouped[alert.severity]) grouped[alert.severity] = [];
            grouped[alert.severity].push(alert);
        });

        ['HIGH', 'MEDIUM', 'LOW'].forEach(severity => {
            if (grouped[severity]) {
                console.log(`\n${this.getSeverityEmoji(severity)} ${severity} SEVERITY (${grouped[severity].length}):`);
                grouped[severity].forEach(alert => {
                    console.log(`  • ${alert.message}`);
                    console.log(`    Time: ${new Date(alert.timestamp).toLocaleString()}`);
                    if (alert.metric.agent) {
                        console.log(`    Agent: ${alert.metric.agent}`);
                    }
                });
            }
        });
    }

    showDashboard() {
        const data = this.dashboard.getDashboardData();
        
        console.log('\n🚀 GRUPO US RULES PERFORMANCE DASHBOARD');
        console.log('=======================================');
        
        // ASCII art dashboard
        console.log(`
┌─────────────────────────────────────────────────────────────┐
│                    SYSTEM STATUS: ${data.status.padEnd(8)}                │
├─────────────────────────────────────────────────────────────┤
│ Completion Rate: ${this.formatMetricBar('completion_rate', data)}│
│ Token Usage:     ${this.formatMetricBar('token_usage', data)}│
│ Error Rate:      ${this.formatMetricBar('error_rate', data)}│
│ Loading Time:    ${this.formatMetricBar('loading_time', data)}│
├─────────────────────────────────────────────────────────────┤
│ Active Alerts: ${data.alerts.length.toString().padEnd(3)} │ Last Update: ${new Date(data.lastUpdated).toLocaleTimeString().padEnd(8)} │
└─────────────────────────────────────────────────────────────┘
        `);

        if (data.alerts.length > 0) {
            console.log('\n🚨 Recent Alerts:');
            data.alerts.slice(0, 3).forEach(alert => {
                console.log(`  ${this.getSeverityEmoji(alert.severity)} ${alert.message.substring(0, 50)}...`);
            });
        }
    }

    runTest() {
        console.log('🧪 Running monitoring system test...');
        
        // Record test metrics
        const testMetrics = [
            { type: 'completion_rate', value: 92, context: { agent: 'test', task: 'monitoring_test' } },
            { type: 'token_usage', value: 35000, context: { agent: 'test', task: 'monitoring_test' } },
            { type: 'error_rate', value: 8, context: { agent: 'test', task: 'monitoring_test' } },
            { type: 'loading_time', value: 1500, context: { agent: 'test', task: 'monitoring_test' } }
        ];

        testMetrics.forEach(metric => {
            this.dashboard.recordMetric(metric.type, metric.value, metric.context);
            console.log(`✅ Recorded test ${metric.type}: ${metric.value}`);
        });

        console.log('\n📊 Test completed. Check status with: npm run monitor:status');
    }

    formatMetricBar(type, data) {
        const metric = data.summary[type];
        const target = data.targets[type.replace('_', '')];
        
        if (!metric || !metric.average || !target) {
            return 'N/A'.padEnd(40);
        }

        const value = metric.average;
        const percentage = type === 'completion_rate' 
            ? Math.min(100, (value / target) * 100)
            : Math.min(100, (target / value) * 100);
        
        const barLength = 20;
        const filled = Math.round((percentage / 100) * barLength);
        const bar = '█'.repeat(filled) + '░'.repeat(barLength - filled);
        
        const status = this.getMetricStatus(type, value, target);
        const emoji = this.getStatusEmoji(status);
        
        return `${emoji} ${bar} ${value.toFixed(1)}`.padEnd(40);
    }

    getMetricStatus(type, value, target) {
        if (type === 'completion_rate') {
            return value >= target ? 'HEALTHY' : value >= target * 0.8 ? 'DEGRADED' : 'CRITICAL';
        } else {
            return value <= target ? 'HEALTHY' : value <= target * 1.2 ? 'DEGRADED' : 'CRITICAL';
        }
    }

    getStatusEmoji(status) {
        const emojis = {
            'HEALTHY': '✅',
            'DEGRADED': '⚠️',
            'WARNING': '⚠️',
            'CRITICAL': '🔴',
            'good': '✅',
            'concerning': '⚠️',
            'neutral': '➡️'
        };
        return emojis[status] || '❓';
    }

    getSeverityEmoji(severity) {
        const emojis = {
            'HIGH': '🔴',
            'MEDIUM': '🟡',
            'LOW': '🟢'
        };
        return emojis[severity] || '❓';
    }

    showHelp() {
        console.log(`
🚀 GRUPO US RULES MONITORING CLI

Usage: npm run monitor:<command> [args]

Commands:
  status              Show current system status
  record <type> <value> [context]  Record a metric
  report              Generate weekly report
  alerts              Show active alerts
  dashboard           Show ASCII dashboard
  test                Run monitoring test

Examples:
  npm run monitor:status
  npm run monitor:record completion_rate 95 '{"agent":"cline","task":"feature_dev"}'
  npm run monitor:report
  npm run monitor:alerts
  npm run monitor:dashboard
  npm run monitor:test

Metric Types:
  completion_rate     Percentage of tasks completed successfully on first attempt
  token_usage         Number of tokens used per feature/task
  error_rate          Percentage of tasks that resulted in errors
  loading_time        Time in milliseconds to load rules

For more information, see: project-core/rules/README.md
        `);
    }
}

// Run CLI if called directly
if (require.main === module) {
    const cli = new MonitorCLI();
    cli.run().catch(console.error);
}

module.exports = MonitorCLI;
