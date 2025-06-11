/**
 * GRUPO US RULES PERFORMANCE DASHBOARD
 * Monitors effectiveness of centralized rules system
 */

const fs = require('fs');
const path = require('path');

class RulesPerformanceDashboard {
    constructor() {
        this.metricsFile = './monitoring/metrics/rules-performance.json';
        this.alertsFile = './monitoring/alerts/performance-alerts.json';
        this.reportsDir = './monitoring/reports';
        this.baselineFile = './monitoring/baseline/pre-consolidation-metrics.json';
        
        this.targets = {
            completionRate: 85, // >85% first attempt
            tokenUsage: 50000,  // <50k per feature
            errorRate: 15,      // <15% in production
            loadingTime: 2000   // <2s rule loading
        };
        
        this.initializeDirectories();
        this.loadBaseline();
    }

    initializeDirectories() {
        const dirs = [
            './monitoring',
            './monitoring/metrics',
            './monitoring/alerts',
            './monitoring/reports',
            './monitoring/baseline',
            './monitoring/logs'
        ];
        
        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
        });
    }

    loadBaseline() {
        try {
            if (fs.existsSync(this.baselineFile)) {
                this.baseline = JSON.parse(fs.readFileSync(this.baselineFile, 'utf8'));
            } else {
                // Create initial baseline
                this.baseline = {
                    completionRate: 70,
                    tokenUsage: 65000,
                    errorRate: 25,
                    loadingTime: 5000,
                    recordedAt: new Date().toISOString()
                };
                this.saveBaseline();
            }
        } catch (error) {
            console.error('Error loading baseline:', error);
            this.baseline = {};
        }
    }

    saveBaseline() {
        fs.writeFileSync(this.baselineFile, JSON.stringify(this.baseline, null, 2));
    }

    recordMetric(type, value, context = {}) {
        const metric = {
            type,
            value,
            context,
            timestamp: new Date().toISOString(),
            agent: context.agent || 'unknown',
            task: context.task || 'unknown',
            ruleSet: context.ruleSet || 'project-core'
        };

        // Load existing metrics
        let metrics = [];
        if (fs.existsSync(this.metricsFile)) {
            try {
                metrics = JSON.parse(fs.readFileSync(this.metricsFile, 'utf8'));
            } catch (error) {
                console.error('Error loading metrics:', error);
            }
        }

        metrics.push(metric);

        // Keep only last 1000 metrics to prevent file bloat
        if (metrics.length > 1000) {
            metrics = metrics.slice(-1000);
        }

        fs.writeFileSync(this.metricsFile, JSON.stringify(metrics, null, 2));
        
        // Check for alerts
        this.checkAlerts(metric);
        
        return metric;
    }

    checkAlerts(metric) {
        const alerts = [];
        
        switch (metric.type) {
            case 'completion_rate':
                if (metric.value < this.targets.completionRate) {
                    alerts.push({
                        type: 'LOW_COMPLETION_RATE',
                        message: `Completion rate ${metric.value}% below target ${this.targets.completionRate}%`,
                        severity: 'HIGH',
                        metric
                    });
                }
                break;
                
            case 'token_usage':
                if (metric.value > this.targets.tokenUsage) {
                    alerts.push({
                        type: 'HIGH_TOKEN_USAGE',
                        message: `Token usage ${metric.value} exceeds target ${this.targets.tokenUsage}`,
                        severity: 'MEDIUM',
                        metric
                    });
                }
                break;
                
            case 'error_rate':
                if (metric.value > this.targets.errorRate) {
                    alerts.push({
                        type: 'HIGH_ERROR_RATE',
                        message: `Error rate ${metric.value}% exceeds target ${this.targets.errorRate}%`,
                        severity: 'HIGH',
                        metric
                    });
                }
                break;
                
            case 'loading_time':
                if (metric.value > this.targets.loadingTime) {
                    alerts.push({
                        type: 'SLOW_LOADING',
                        message: `Rule loading time ${metric.value}ms exceeds target ${this.targets.loadingTime}ms`,
                        severity: 'LOW',
                        metric
                    });
                }
                break;
        }

        if (alerts.length > 0) {
            this.saveAlerts(alerts);
        }
    }

    saveAlerts(newAlerts) {
        let alerts = [];
        if (fs.existsSync(this.alertsFile)) {
            try {
                alerts = JSON.parse(fs.readFileSync(this.alertsFile, 'utf8'));
            } catch (error) {
                console.error('Error loading alerts:', error);
            }
        }

        alerts.push(...newAlerts.map(alert => ({
            ...alert,
            id: Date.now() + Math.random(),
            timestamp: new Date().toISOString(),
            resolved: false
        })));

        fs.writeFileSync(this.alertsFile, JSON.stringify(alerts, null, 2));
        
        // Log high severity alerts
        newAlerts.filter(a => a.severity === 'HIGH').forEach(alert => {
            console.warn(`🚨 HIGH SEVERITY ALERT: ${alert.message}`);
        });
    }

    generateWeeklyReport() {
        const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
        
        let metrics = [];
        if (fs.existsSync(this.metricsFile)) {
            try {
                const allMetrics = JSON.parse(fs.readFileSync(this.metricsFile, 'utf8'));
                metrics = allMetrics.filter(m => new Date(m.timestamp) >= weekAgo);
            } catch (error) {
                console.error('Error loading metrics for report:', error);
            }
        }

        const report = {
            period: {
                start: weekAgo.toISOString(),
                end: new Date().toISOString()
            },
            summary: this.calculateSummary(metrics),
            trends: this.calculateTrends(metrics),
            alerts: this.getActiveAlerts(),
            recommendations: this.generateRecommendations(metrics),
            generatedAt: new Date().toISOString()
        };

        const reportFile = path.join(this.reportsDir, `weekly-report-${new Date().toISOString().split('T')[0]}.json`);
        fs.writeFileSync(reportFile, JSON.stringify(report, null, 2));
        
        console.log(`📊 Weekly report generated: ${reportFile}`);
        return report;
    }

    calculateSummary(metrics) {
        const byType = {};
        metrics.forEach(metric => {
            if (!byType[metric.type]) byType[metric.type] = [];
            byType[metric.type].push(metric.value);
        });

        const summary = {};
        Object.keys(byType).forEach(type => {
            const values = byType[type];
            summary[type] = {
                count: values.length,
                average: values.reduce((a, b) => a + b, 0) / values.length,
                min: Math.min(...values),
                max: Math.max(...values),
                target: this.targets[type.replace('_', '')] || 'N/A',
                baseline: this.baseline[type.replace('_', '')] || 'N/A'
            };
        });

        return summary;
    }

    calculateTrends(metrics) {
        // Simple trend calculation - could be enhanced with more sophisticated analysis
        const trends = {};
        const types = [...new Set(metrics.map(m => m.type))];
        
        types.forEach(type => {
            const typeMetrics = metrics.filter(m => m.type === type).sort((a, b) => 
                new Date(a.timestamp) - new Date(b.timestamp)
            );
            
            if (typeMetrics.length >= 2) {
                const first = typeMetrics[0].value;
                const last = typeMetrics[typeMetrics.length - 1].value;
                const change = ((last - first) / first) * 100;
                
                trends[type] = {
                    direction: change > 0 ? 'increasing' : 'decreasing',
                    changePercent: Math.abs(change).toFixed(2),
                    status: this.getTrendStatus(type, change)
                };
            }
        });
        
        return trends;
    }

    getTrendStatus(type, change) {
        // Determine if trend is good or bad based on metric type
        const improvingMetrics = ['completion_rate'];
        const decliningMetrics = ['token_usage', 'error_rate', 'loading_time'];
        
        if (improvingMetrics.includes(type)) {
            return change > 0 ? 'good' : 'concerning';
        } else if (decliningMetrics.includes(type)) {
            return change < 0 ? 'good' : 'concerning';
        }
        
        return 'neutral';
    }

    getActiveAlerts() {
        if (!fs.existsSync(this.alertsFile)) return [];
        
        try {
            const alerts = JSON.parse(fs.readFileSync(this.alertsFile, 'utf8'));
            return alerts.filter(alert => !alert.resolved);
        } catch (error) {
            console.error('Error loading alerts:', error);
            return [];
        }
    }

    generateRecommendations(metrics) {
        const recommendations = [];
        const summary = this.calculateSummary(metrics);
        
        Object.keys(summary).forEach(type => {
            const data = summary[type];
            const target = this.targets[type.replace('_', '')];
            
            if (target && data.average) {
                if (type === 'completion_rate' && data.average < target) {
                    recommendations.push({
                        type: 'IMPROVE_COMPLETION_RATE',
                        message: `Consider reviewing and simplifying rules in project-core/rules/ to improve completion rate`,
                        priority: 'HIGH'
                    });
                }
                
                if (type === 'token_usage' && data.average > target) {
                    recommendations.push({
                        type: 'OPTIMIZE_TOKEN_USAGE',
                        message: `Review rule verbosity and consider consolidating repetitive content`,
                        priority: 'MEDIUM'
                    });
                }
                
                if (type === 'error_rate' && data.average > target) {
                    recommendations.push({
                        type: 'REDUCE_ERRORS',
                        message: `Analyze error patterns in memory-bank/self_correction_log.md and update rules`,
                        priority: 'HIGH'
                    });
                }
            }
        });
        
        return recommendations;
    }

    getDashboardData() {
        const summary = this.calculateSummary(this.loadRecentMetrics());
        const alerts = this.getActiveAlerts();
        
        return {
            summary,
            alerts,
            targets: this.targets,
            baseline: this.baseline,
            status: this.getOverallStatus(summary, alerts),
            lastUpdated: new Date().toISOString()
        };
    }

    loadRecentMetrics(hours = 24) {
        const cutoff = new Date(Date.now() - hours * 60 * 60 * 1000);
        
        if (!fs.existsSync(this.metricsFile)) return [];
        
        try {
            const allMetrics = JSON.parse(fs.readFileSync(this.metricsFile, 'utf8'));
            return allMetrics.filter(m => new Date(m.timestamp) >= cutoff);
        } catch (error) {
            console.error('Error loading recent metrics:', error);
            return [];
        }
    }

    getOverallStatus(summary, alerts) {
        const highAlerts = alerts.filter(a => a.severity === 'HIGH').length;
        const mediumAlerts = alerts.filter(a => a.severity === 'MEDIUM').length;
        
        if (highAlerts > 0) return 'CRITICAL';
        if (mediumAlerts > 2) return 'WARNING';
        
        // Check if metrics are meeting targets
        let targetsMet = 0;
        let targetsTotal = 0;
        
        Object.keys(summary).forEach(type => {
            const target = this.targets[type.replace('_', '')];
            if (target && summary[type].average !== undefined) {
                targetsTotal++;
                
                if (type === 'completion_rate' && summary[type].average >= target) targetsMet++;
                else if (type !== 'completion_rate' && summary[type].average <= target) targetsMet++;
            }
        });
        
        const targetPercentage = targetsTotal > 0 ? (targetsMet / targetsTotal) * 100 : 100;
        
        if (targetPercentage >= 80) return 'HEALTHY';
        if (targetPercentage >= 60) return 'DEGRADED';
        return 'CRITICAL';
    }
}

module.exports = RulesPerformanceDashboard;
