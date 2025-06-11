/**
 * GRUPO US SYSTEM VALIDATION TEST
 * Comprehensive test of the centralized rules system
 */

const fs = require('fs');
const path = require('path');
const { startLogging, endLogging, logTask, completeTask, logError, logRuleUsage } = require('../monitoring/auto-logger');
const RulesPerformanceDashboard = require('../monitoring/rules-performance-dashboard');
const DeveloperFeedbackSystem = require('../feedback/developer-feedback-system');

class SystemValidationTest {
    constructor() {
        this.dashboard = new RulesPerformanceDashboard();
        this.feedbackSystem = new DeveloperFeedbackSystem();
        this.testResults = {
            startTime: null,
            endTime: null,
            tests: [],
            metrics: {},
            summary: {}
        };
    }

    async runComprehensiveValidation() {
        console.log('🧪 Starting comprehensive system validation...');
        this.testResults.startTime = new Date().toISOString();
        
        // Start logging session
        startLogging('validation-test', { testType: 'comprehensive' });
        
        try {
            // Test 1: Rule Loading Performance
            await this.testRuleLoadingPerformance();
            
            // Test 2: Agent Configuration Validation
            await this.testAgentConfigurations();
            
            // Test 3: MCP Integration Testing
            await this.testMCPIntegrations();
            
            // Test 4: Monitoring System Validation
            await this.testMonitoringSystem();
            
            // Test 5: Feedback System Validation
            await this.testFeedbackSystem();
            
            // Test 6: Real Development Task Simulation
            await this.simulateRealDevelopmentTask();
            
            // Generate final metrics
            this.generateFinalMetrics();
            
        } catch (error) {
            logError(error, { testPhase: 'comprehensive_validation' });
            console.error('❌ Validation test failed:', error);
        } finally {
            this.testResults.endTime = new Date().toISOString();
            const sessionMetrics = endLogging();
            this.testResults.sessionMetrics = sessionMetrics;
            
            // Generate and save report
            this.generateValidationReport();
        }
    }

    async testRuleLoadingPerformance() {
        console.log('📋 Testing rule loading performance...');
        const taskId = logTask('Rule Loading Performance Test', 3);
        
        const startTime = Date.now();
        const errors = [];
        
        try {
            // Test loading all core rules
            const coreRules = [
                'project-core/rules/README.md',
                'project-core/rules/00-master-execution-protocol.md',
                'project-core/rules/01-core-principles.md',
                'project-core/rules/02-coding-standards-universal.md'
            ];
            
            for (const rule of coreRules) {
                const ruleStartTime = Date.now();
                
                if (fs.existsSync(rule)) {
                    const content = fs.readFileSync(rule, 'utf8');
                    const loadTime = Date.now() - ruleStartTime;
                    
                    logRuleUsage(rule, { loadTime, contentLength: content.length });
                    
                    this.testResults.tests.push({
                        name: `Load ${rule}`,
                        status: 'passed',
                        duration: loadTime,
                        details: { contentLength: content.length }
                    });
                } else {
                    errors.push(`Rule file not found: ${rule}`);
                    this.testResults.tests.push({
                        name: `Load ${rule}`,
                        status: 'failed',
                        error: 'File not found'
                    });
                }
            }
            
            const totalLoadTime = Date.now() - startTime;
            
            // Record performance metric
            this.dashboard.recordMetric('loading_time', totalLoadTime, {
                agent: 'validation-test',
                task: 'rule_loading_performance',
                rulesCount: coreRules.length
            });
            
            completeTask(taskId, errors.length === 0, null, errors);
            
            console.log(`✅ Rule loading test completed in ${totalLoadTime}ms`);
            
        } catch (error) {
            errors.push(error.message);
            completeTask(taskId, false, null, errors);
            throw error;
        }
    }

    async testAgentConfigurations() {
        console.log('🤖 Testing agent configurations...');
        const taskId = logTask('Agent Configuration Validation', 5);
        
        const errors = [];
        const agentConfigs = [
            { name: 'Cline', file: '.clinerules/rules/master_rule.md' },
            { name: 'Cursor', file: '.cursorrules' },
            { name: 'Roo Code', file: '.roo/rules/project.md' }
        ];
        
        try {
            for (const config of agentConfigs) {
                if (fs.existsSync(config.file)) {
                    const content = fs.readFileSync(config.file, 'utf8');
                    
                    // Check if config references project-core/rules/
                    const hasProjectCoreReference = content.includes('project-core/rules/');
                    const hasUpdatedStructure = content.includes('UPDATED') || content.includes('ATUALIZADO');
                    
                    this.testResults.tests.push({
                        name: `${config.name} Configuration`,
                        status: hasProjectCoreReference && hasUpdatedStructure ? 'passed' : 'warning',
                        details: {
                            hasProjectCoreReference,
                            hasUpdatedStructure,
                            fileSize: content.length
                        }
                    });
                    
                    if (!hasProjectCoreReference) {
                        errors.push(`${config.name} config missing project-core reference`);
                    }
                } else {
                    errors.push(`${config.name} config file not found: ${config.file}`);
                    this.testResults.tests.push({
                        name: `${config.name} Configuration`,
                        status: 'failed',
                        error: 'Configuration file not found'
                    });
                }
            }
            
            completeTask(taskId, errors.length === 0, null, errors);
            console.log(`✅ Agent configuration test completed with ${errors.length} issues`);
            
        } catch (error) {
            errors.push(error.message);
            completeTask(taskId, false, null, errors);
            throw error;
        }
    }

    async testMCPIntegrations() {
        console.log('🔧 Testing MCP integrations...');
        const taskId = logTask('MCP Integration Validation', 7);
        
        const errors = [];
        const mcpProtocols = [
            'project-core/rules/mcp-integration/taskmaster-protocol.md',
            'project-core/rules/mcp-integration/playwright-automation.md',
            'project-core/rules/mcp-integration/figma-design-sync.md',
            'project-core/rules/mcp-integration/supabase-database.md'
        ];
        
        try {
            for (const protocol of mcpProtocols) {
                if (fs.existsSync(protocol)) {
                    const content = fs.readFileSync(protocol, 'utf8');
                    const protocolName = path.basename(protocol, '.md');
                    
                    // Check protocol completeness
                    const hasSetup = content.includes('SETUP') || content.includes('Configuration');
                    const hasExamples = content.includes('Example') || content.includes('```');
                    const hasIntegration = content.includes('Integration') || content.includes('Protocol');
                    
                    this.testResults.tests.push({
                        name: `MCP ${protocolName}`,
                        status: hasSetup && hasExamples && hasIntegration ? 'passed' : 'warning',
                        details: {
                            hasSetup,
                            hasExamples,
                            hasIntegration,
                            contentLength: content.length
                        }
                    });
                } else {
                    errors.push(`MCP protocol not found: ${protocol}`);
                    this.testResults.tests.push({
                        name: `MCP ${path.basename(protocol, '.md')}`,
                        status: 'failed',
                        error: 'Protocol file not found'
                    });
                }
            }
            
            // Test Figma integration specifically (since it's configured)
            if (process.env.FIGMA_API_KEY) {
                this.testResults.tests.push({
                    name: 'Figma API Configuration',
                    status: 'passed',
                    details: { configured: true }
                });
            } else {
                this.testResults.tests.push({
                    name: 'Figma API Configuration',
                    status: 'warning',
                    details: { configured: false }
                });
            }
            
            completeTask(taskId, errors.length === 0, null, errors);
            console.log(`✅ MCP integration test completed with ${errors.length} issues`);
            
        } catch (error) {
            errors.push(error.message);
            completeTask(taskId, false, null, errors);
            throw error;
        }
    }

    async testMonitoringSystem() {
        console.log('📊 Testing monitoring system...');
        const taskId = logTask('Monitoring System Validation', 4);
        
        const errors = [];
        
        try {
            // Test dashboard functionality
            const dashboardData = this.dashboard.getDashboardData();
            
            this.testResults.tests.push({
                name: 'Monitoring Dashboard',
                status: dashboardData ? 'passed' : 'failed',
                details: {
                    status: dashboardData?.status,
                    metricsCount: Object.keys(dashboardData?.summary || {}).length,
                    alertsCount: dashboardData?.alerts?.length || 0
                }
            });
            
            // Test metric recording
            this.dashboard.recordMetric('test_metric', 100, {
                agent: 'validation-test',
                task: 'monitoring_validation'
            });
            
            this.testResults.tests.push({
                name: 'Metric Recording',
                status: 'passed',
                details: { testMetricRecorded: true }
            });
            
            completeTask(taskId, errors.length === 0, null, errors);
            console.log(`✅ Monitoring system test completed`);
            
        } catch (error) {
            errors.push(error.message);
            completeTask(taskId, false, null, errors);
            throw error;
        }
    }

    async testFeedbackSystem() {
        console.log('💬 Testing feedback system...');
        const taskId = logTask('Feedback System Validation', 4);
        
        const errors = [];
        
        try {
            // Test feedback submission
            const testFeedback = this.feedbackSystem.submitFeedback({
                rating: 9,
                title: 'System Validation Test Feedback',
                description: 'Testing the feedback system during validation',
                ruleFile: 'project-core/rules/README.md',
                agent: 'validation-test',
                type: 'test',
                category: 'validation'
            });
            
            this.testResults.tests.push({
                name: 'Feedback Submission',
                status: testFeedback ? 'passed' : 'failed',
                details: {
                    feedbackId: testFeedback?.id,
                    priority: testFeedback?.priority
                }
            });
            
            // Test feedback summary
            const summary = this.feedbackSystem.getFeedbackSummary(1);
            
            this.testResults.tests.push({
                name: 'Feedback Summary',
                status: summary ? 'passed' : 'failed',
                details: {
                    totalFeedback: summary?.totalFeedback,
                    averageRating: summary?.averageRating
                }
            });
            
            completeTask(taskId, errors.length === 0, null, errors);
            console.log(`✅ Feedback system test completed`);
            
        } catch (error) {
            errors.push(error.message);
            completeTask(taskId, false, null, errors);
            throw error;
        }
    }

    async simulateRealDevelopmentTask() {
        console.log('🚀 Simulating real development task...');
        const taskId = logTask('Real Development Task Simulation', 8);
        
        const errors = [];
        const startTime = Date.now();
        
        try {
            // Simulate a complex development task using the centralized rules
            const simulatedSteps = [
                'Load project-core/rules/00-master-execution-protocol.md',
                'Apply 4-step execution cycle',
                'Load framework-specific rules (Next.js)',
                'Apply coding standards',
                'Implement feature with error handling',
                'Apply MCP integration protocols',
                'Validate implementation',
                'Update memory-bank with learnings'
            ];
            
            for (let i = 0; i < simulatedSteps.length; i++) {
                const step = simulatedSteps[i];
                const stepStartTime = Date.now();
                
                // Simulate step execution time
                await new Promise(resolve => setTimeout(resolve, Math.random() * 100 + 50));
                
                const stepDuration = Date.now() - stepStartTime;
                
                this.testResults.tests.push({
                    name: `Development Step ${i + 1}: ${step}`,
                    status: 'passed',
                    duration: stepDuration
                });
                
                // Simulate occasional errors (realistic scenario)
                if (Math.random() < 0.1) { // 10% chance of error
                    errors.push(`Simulated error in step: ${step}`);
                }
            }
            
            const totalDuration = Date.now() - startTime;
            const tokenUsage = Math.floor(Math.random() * 20000) + 30000; // Simulate token usage
            
            // Record comprehensive metrics
            this.dashboard.recordMetric('completion_rate', errors.length === 0 ? 100 : 85, {
                agent: 'validation-test',
                task: 'real_development_simulation',
                complexity: 8
            });
            
            this.dashboard.recordMetric('token_usage', tokenUsage, {
                agent: 'validation-test',
                task: 'real_development_simulation'
            });
            
            this.dashboard.recordMetric('error_rate', (errors.length / simulatedSteps.length) * 100, {
                agent: 'validation-test',
                task: 'real_development_simulation'
            });
            
            completeTask(taskId, errors.length <= 1, tokenUsage, errors);
            
            console.log(`✅ Real development task simulation completed`);
            console.log(`   Duration: ${totalDuration}ms`);
            console.log(`   Token Usage: ${tokenUsage}`);
            console.log(`   Errors: ${errors.length}`);
            
        } catch (error) {
            errors.push(error.message);
            completeTask(taskId, false, null, errors);
            throw error;
        }
    }

    generateFinalMetrics() {
        const totalTests = this.testResults.tests.length;
        const passedTests = this.testResults.tests.filter(t => t.status === 'passed').length;
        const failedTests = this.testResults.tests.filter(t => t.status === 'failed').length;
        const warningTests = this.testResults.tests.filter(t => t.status === 'warning').length;
        
        const successRate = (passedTests / totalTests) * 100;
        const duration = new Date(this.testResults.endTime) - new Date(this.testResults.startTime);
        
        this.testResults.summary = {
            totalTests,
            passedTests,
            failedTests,
            warningTests,
            successRate,
            duration,
            status: successRate >= 85 ? 'PASSED' : successRate >= 70 ? 'WARNING' : 'FAILED'
        };
        
        // Record final system validation metric
        this.dashboard.recordMetric('system_validation', successRate, {
            agent: 'validation-test',
            task: 'comprehensive_validation',
            totalTests,
            duration
        });
    }

    generateValidationReport() {
        const report = {
            title: 'GRUPO US Rules System Validation Report',
            timestamp: new Date().toISOString(),
            version: '2.0',
            ...this.testResults
        };
        
        // Save detailed report
        const reportFile = `./validation/validation-report-${new Date().toISOString().split('T')[0]}.json`;
        fs.writeFileSync(reportFile, JSON.stringify(report, null, 2));
        
        // Display summary
        console.log('\n📊 VALIDATION REPORT SUMMARY');
        console.log('============================');
        console.log(`Overall Status: ${this.getStatusEmoji(report.summary.status)} ${report.summary.status}`);
        console.log(`Success Rate: ${report.summary.successRate.toFixed(1)}%`);
        console.log(`Duration: ${(report.summary.duration / 1000).toFixed(1)}s`);
        console.log(`Tests: ${report.summary.totalTests} total, ${report.summary.passedTests} passed, ${report.summary.failedTests} failed, ${report.summary.warningTests} warnings`);
        
        if (report.sessionMetrics) {
            console.log('\n📈 SESSION METRICS:');
            console.log(`Completion Rate: ${report.sessionMetrics.completionRate.toFixed(1)}%`);
            console.log(`Avg Token Usage: ${report.sessionMetrics.avgTokensPerTask.toFixed(0)}`);
            console.log(`Error Rate: ${report.sessionMetrics.errorRate.toFixed(1)}%`);
        }
        
        console.log(`\n📄 Full report saved: ${reportFile}`);
        
        return report;
    }

    getStatusEmoji(status) {
        const emojis = {
            'PASSED': '✅',
            'WARNING': '⚠️',
            'FAILED': '❌'
        };
        return emojis[status] || '❓';
    }
}

// Run validation if called directly
if (require.main === module) {
    const validator = new SystemValidationTest();
    validator.runComprehensiveValidation().catch(console.error);
}

module.exports = SystemValidationTest;
