#!/usr/bin/env node

/**
 * Intelligent Model Routing Initialization Script
 * GRUPO US VIBECODE SYSTEM V2.0 - OpenRouter Integration
 * 
 * This script initializes and tests the intelligent automatic model switching
 * system with OpenRouter API integration.
 */

const fs = require('fs');
const path = require('path');

class IntelligentRoutingManager {
    constructor() {
        this.configPath = path.join(process.cwd(), 'augment-interface-config.json');
        this.config = null;
        this.loadConfig();
    }

    loadConfig() {
        try {
            const configData = fs.readFileSync(this.configPath, 'utf8');
            this.config = JSON.parse(configData);
            console.log('✅ Configuration loaded successfully');
        } catch (error) {
            console.error('❌ Failed to load configuration:', error.message);
            process.exit(1);
        }
    }

    validateOpenRouterConfig() {
        const openRouter = this.config.openRouter;
        
        if (!openRouter || !openRouter.enabled) {
            console.error('❌ OpenRouter integration is not enabled');
            return false;
        }

        if (!openRouter.apiKey || !openRouter.apiKey.startsWith('sk-or-v1-')) {
            console.error('❌ Invalid OpenRouter API key');
            return false;
        }

        console.log('✅ OpenRouter configuration is valid');
        return true;
    }

    validateModelRouting() {
        const routing = this.config.intelligentModelRouting;
        
        if (!routing || !routing.enabled) {
            console.error('❌ Intelligent model routing is not enabled');
            return false;
        }

        const requiredModels = ['primary', 'coding', 'strategic'];
        for (const modelType of requiredModels) {
            if (!routing.models[modelType]) {
                console.error(`❌ Missing ${modelType} model configuration`);
                return false;
            }
        }

        console.log('✅ Model routing configuration is valid');
        return true;
    }

    testTaskAnalysis() {
        const testCases = [
            {
                input: "Help me create a React component for user authentication",
                expectedModel: "anthropic/claude-sonnet-4",
                type: "coding"
            },
            {
                input: "Plan the architecture for a new SaaS application",
                expectedModel: "google/gemini-2.5-pro-preview-05-06",
                type: "strategic"
            },
            {
                input: "Explain how to read a file in JavaScript",
                expectedModel: "google/gemini-2.5-flash-preview-05-20:thinking",
                type: "general"
            }
        ];

        console.log('\n🧪 Testing task analysis and model selection...');
        
        testCases.forEach((testCase, index) => {
            const selectedModel = this.analyzeTask(testCase.input);
            const isCorrect = selectedModel === testCase.expectedModel;
            
            console.log(`Test ${index + 1}: ${isCorrect ? '✅' : '❌'}`);
            console.log(`  Input: "${testCase.input}"`);
            console.log(`  Expected: ${testCase.expectedModel}`);
            console.log(`  Selected: ${selectedModel}`);
            console.log(`  Type: ${testCase.type}\n`);
        });
    }

    analyzeTask(input) {
        const routing = this.config.intelligentModelRouting;
        const taskAnalysis = this.config.taskAnalysis;
        
        let scores = {
            primary: 0,
            coding: 0,
            strategic: 0
        };

        // Keyword analysis
        Object.keys(routing.models).forEach(modelType => {
            const model = routing.models[modelType];
            model.keywords.forEach(keyword => {
                if (input.toLowerCase().includes(keyword.toLowerCase())) {
                    scores[modelType] += 1;
                }
            });
        });

        // Complexity analysis
        taskAnalysis.complexityFactors.codeKeywords.forEach(keyword => {
            if (input.toLowerCase().includes(keyword.toLowerCase())) {
                scores.coding += 2;
            }
        });

        taskAnalysis.complexityFactors.planningKeywords.forEach(keyword => {
            if (input.toLowerCase().includes(keyword.toLowerCase())) {
                scores.strategic += 2;
            }
        });

        // Select model with highest score
        const selectedType = Object.keys(scores).reduce((a, b) => 
            scores[a] > scores[b] ? a : b
        );

        return routing.models[selectedType].id;
    }

    generateReport() {
        console.log('\n📊 INTELLIGENT ROUTING SYSTEM REPORT');
        console.log('=====================================');
        
        console.log('\n🔧 Configuration Status:');
        console.log(`  Version: ${this.config.version}`);
        console.log(`  OpenRouter: ${this.config.openRouter.enabled ? '✅ Enabled' : '❌ Disabled'}`);
        console.log(`  Intelligent Routing: ${this.config.intelligentModelRouting.enabled ? '✅ Enabled' : '❌ Disabled'}`);
        console.log(`  Task Analysis: ${this.config.taskAnalysis.enabled ? '✅ Enabled' : '❌ Disabled'}`);
        
        console.log('\n🤖 Configured Models:');
        Object.entries(this.config.intelligentModelRouting.models).forEach(([type, model]) => {
            console.log(`  ${type.toUpperCase()}: ${model.name} (${model.id})`);
            console.log(`    Provider: ${model.provider}`);
            console.log(`    Cost: ${model.cost}`);
            console.log(`    Speed: ${model.speed}`);
        });

        console.log('\n💰 Cost Optimization:');
        const costOpt = this.config.performance.costOptimization;
        console.log(`  Daily Budget: $${costOpt.dailyBudget}`);
        console.log(`  Fallback on Budget Exceeded: ${costOpt.fallbackWhenBudgetExceeded ? '✅' : '❌'}`);
        
        console.log('\n📈 Monitoring:');
        console.log(`  Real-time Updates: ${this.config.monitoring.realTimeUpdates ? '✅' : '❌'}`);
        console.log(`  Usage Analytics: ${this.config.integration.openRouterIntegration.usageAnalytics ? '✅' : '❌'}`);
        console.log(`  Cost Tracking: ${this.config.integration.openRouterIntegration.costTracking ? '✅' : '❌'}`);
    }

    init() {
        console.log('🚀 Initializing Intelligent Model Routing System...\n');
        
        if (!this.validateOpenRouterConfig()) {
            process.exit(1);
        }
        
        if (!this.validateModelRouting()) {
            process.exit(1);
        }
        
        this.testTaskAnalysis();
        this.generateReport();
        
        console.log('\n✅ Intelligent Model Routing System initialized successfully!');
        console.log('\n🎯 Next Steps:');
        console.log('  1. Restart VS Code to apply configuration changes');
        console.log('  2. Test the model switching with different types of requests');
        console.log('  3. Monitor the dashboard for usage analytics');
        console.log('  4. Adjust thresholds based on performance metrics');
    }
}

// CLI Interface
if (require.main === module) {
    const manager = new IntelligentRoutingManager();
    manager.init();
}

module.exports = IntelligentRoutingManager;
