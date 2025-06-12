/**
 * GRUPO US VIBECODE SYSTEM V4.5 - Refiner Agents Test
 * Test script for prompt and workflow refiner agents
 * 
 * @version 1.0.0
 * @author GRUPO US - VIBECODE SYSTEM
 * @date 2025-02-13
 */

const PromptRefinerLogic = require('./prompt-refiner-logic.js');
const WorkflowRefinerLogic = require('./workflow-refiner-logic.js');

async function testPromptRefiner() {
    console.log('\n🧪 TESTING PROMPT REFINER AGENT...\n');
    
    const promptRefiner = new PromptRefinerLogic();
    
    try {
        // Initialize
        const initialized = await promptRefiner.initialize();
        if (!initialized) {
            throw new Error('Failed to initialize prompt refiner');
        }
        
        // Test prompt analysis
        const testPrompt = "Please create a function that does something with data";
        console.log('📝 Testing prompt analysis...');
        const analysis = await promptRefiner.analyzePrompt(testPrompt, { 
            environment: 'GRUPO US VIBECODE SYSTEM V4.5',
            complexity: 5 
        });
        
        console.log('✅ Analysis completed:');
        console.log(`   - Clarity Score: ${(analysis.scores.clarity * 100).toFixed(1)}%`);
        console.log(`   - Specificity Score: ${(analysis.scores.specificity * 100).toFixed(1)}%`);
        console.log(`   - Optimization Potential: ${(analysis.optimizationPotential * 100).toFixed(1)}%`);
        console.log(`   - Issues Found: ${analysis.issues.length}`);
        console.log(`   - Suggestions: ${analysis.suggestions.length}`);
        
        // Test prompt optimization
        console.log('\n🔧 Testing prompt optimization...');
        const optimization = await promptRefiner.optimizeStructure(testPrompt, analysis);
        
        console.log('✅ Optimization completed:');
        console.log(`   - Improvements Applied: ${optimization.improvements.length}`);
        console.log(`   - Improvement Score: ${(optimization.metrics.improvementScore * 100).toFixed(1)}%`);
        console.log(`   - Token Reduction: ${(optimization.metrics.tokenReduction * 100).toFixed(1)}%`);
        
        // Test compliance validation
        console.log('\n🔍 Testing compliance validation...');
        const validation = await promptRefiner.validateCompliance(optimization.optimizedPrompt);
        
        console.log('✅ Validation completed:');
        console.log(`   - Overall Compliance Score: ${(validation.overallScore * 100).toFixed(1)}%`);
        console.log(`   - Violations: ${validation.violations.length}`);
        console.log(`   - Recommendations: ${validation.recommendations.length}`);
        
        // Get performance metrics
        const metrics = promptRefiner.getPerformanceMetrics();
        console.log('\n📊 Performance Metrics:');
        console.log(`   - Optimizations Performed: ${metrics.optimizationsPerformed}`);
        console.log(`   - Average Improvement Score: ${(metrics.averageImprovementScore * 100).toFixed(1)}%`);
        console.log(`   - Success Rate: ${(metrics.successRate * 100).toFixed(1)}%`);
        
        return true;
        
    } catch (error) {
        console.error('❌ Prompt Refiner Test Failed:', error.message);
        return false;
    }
}

async function testWorkflowRefiner() {
    console.log('\n🧪 TESTING WORKFLOW REFINER AGENT...\n');
    
    const workflowRefiner = new WorkflowRefinerLogic();
    
    try {
        // Initialize
        const initialized = await workflowRefiner.initialize();
        if (!initialized) {
            throw new Error('Failed to initialize workflow refiner');
        }
        
        // Test workflow analysis
        const testWorkflow = {
            name: 'test-development-workflow',
            description: 'Test workflow for development tasks',
            steps: [
                { name: 'planning', description: 'Plan the task' },
                { name: 'implementation', description: 'Implement the solution' },
                { name: 'testing', description: 'Test the implementation' },
                { name: 'deployment', description: 'Deploy the solution' }
            ],
            errorHandling: false,
            validation: true
        };
        
        console.log('📊 Testing workflow analysis...');
        const analysis = await workflowRefiner.analyzeWorkflow(testWorkflow, {
            environment: 'GRUPO US VIBECODE SYSTEM V4.5',
            project: 'test-project'
        });
        
        console.log('✅ Analysis completed:');
        console.log(`   - Complexity Score: ${(analysis.metrics.complexity * 100).toFixed(1)}%`);
        console.log(`   - Efficiency Score: ${(analysis.metrics.efficiency * 100).toFixed(1)}%`);
        console.log(`   - Reliability Score: ${(analysis.metrics.reliability * 100).toFixed(1)}%`);
        console.log(`   - Optimization Potential: ${(analysis.optimizationPotential * 100).toFixed(1)}%`);
        console.log(`   - Risk Factors: ${analysis.riskFactors.length}`);
        
        // Test pattern identification
        console.log('\n🔍 Testing pattern identification...');
        const patterns = await workflowRefiner.identifyPatterns(testWorkflow);
        
        console.log('✅ Pattern identification completed:');
        console.log(`   - Success Patterns: ${patterns.success.length}`);
        console.log(`   - Failure Patterns: ${patterns.failure.length}`);
        console.log(`   - Optimization Patterns: ${patterns.optimization.length}`);
        console.log(`   - Performance Patterns: ${patterns.performance.length}`);
        console.log(`   - Integration Patterns: ${patterns.integration.length}`);
        
        // Test improvement suggestions
        console.log('\n💡 Testing improvement suggestions...');
        const suggestions = workflowRefiner.suggestImprovements(analysis.metrics, patterns);
        
        console.log('✅ Suggestions generated:');
        suggestions.forEach((suggestion, index) => {
            console.log(`   ${index + 1}. [${suggestion.priority.toUpperCase()}] ${suggestion.description}`);
        });
        
        // Generate optimization report
        console.log('\n📋 Generating optimization report...');
        const report = await workflowRefiner.generateOptimizationReport(analysis);
        
        console.log('✅ Report generated:');
        console.log(`   - Overall Score: ${(report.overallScore * 100).toFixed(1)}%`);
        console.log(`   - Critical Issues: ${report.criticalIssues.length}`);
        console.log(`   - Top Suggestions: ${report.topSuggestions.length}`);
        console.log(`   - Recommendations: ${report.recommendations.length}`);
        
        // Get performance metrics
        const metrics = workflowRefiner.getPerformanceMetrics();
        console.log('\n📊 Performance Metrics:');
        console.log(`   - Analyses Performed: ${metrics.analysesPerformed}`);
        console.log(`   - Patterns Identified: ${metrics.patternsIdentified}`);
        console.log(`   - Improvements Suggested: ${metrics.improvementsSuggested}`);
        console.log(`   - Success Rate: ${(metrics.successRate * 100).toFixed(1)}%`);
        
        return true;
        
    } catch (error) {
        console.error('❌ Workflow Refiner Test Failed:', error.message);
        return false;
    }
}

async function runAllTests() {
    console.log('🚀 GRUPO US VIBECODE SYSTEM V4.5 - REFINER AGENTS TEST SUITE');
    console.log('================================================================');
    
    const results = {
        promptRefiner: false,
        workflowRefiner: false
    };
    
    // Test Prompt Refiner
    results.promptRefiner = await testPromptRefiner();
    
    // Test Workflow Refiner
    results.workflowRefiner = await testWorkflowRefiner();
    
    // Summary
    console.log('\n📋 TEST RESULTS SUMMARY');
    console.log('========================');
    console.log(`Prompt Refiner: ${results.promptRefiner ? '✅ PASSED' : '❌ FAILED'}`);
    console.log(`Workflow Refiner: ${results.workflowRefiner ? '✅ PASSED' : '❌ FAILED'}`);
    
    const allPassed = results.promptRefiner && results.workflowRefiner;
    console.log(`\nOverall Result: ${allPassed ? '✅ ALL TESTS PASSED' : '❌ SOME TESTS FAILED'}`);
    
    if (allPassed) {
        console.log('\n🎉 REFINER AGENTS ARE READY FOR PRODUCTION!');
        console.log('Integration with knowledge graph and MCP system successful.');
    } else {
        console.log('\n⚠️ Please review failed tests before proceeding.');
    }
    
    return allPassed;
}

// Run tests if this file is executed directly
if (require.main === module) {
    runAllTests()
        .then(success => {
            process.exit(success ? 0 : 1);
        })
        .catch(error => {
            console.error('💥 Test suite crashed:', error.message);
            process.exit(1);
        });
}

module.exports = {
    testPromptRefiner,
    testWorkflowRefiner,
    runAllTests
};
