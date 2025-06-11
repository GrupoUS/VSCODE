#!/usr/bin/env node

/**
 * Configuration Integration Validation Script
 * GRUPO US VIBECODE SYSTEM V2.0 - Cross-Reference Validator
 * 
 * This script validates that all configuration files are properly integrated
 * and working together as a cohesive system.
 */

const fs = require('fs');
const path = require('path');

class IntegrationValidator {
    constructor() {
        this.configs = {};
        this.errors = [];
        this.warnings = [];
        this.successes = [];
        
        this.loadConfigurations();
    }

    loadConfigurations() {
        const configFiles = {
            interface: 'augment-interface-config.json',
            optimization: 'augment-optimization-config.json',
            mcp: '.vscode/mcp.json'
        };

        try {
            Object.entries(configFiles).forEach(([key, file]) => {
                const filePath = path.join(process.cwd(), file);
                if (fs.existsSync(filePath)) {
                    this.configs[key] = JSON.parse(fs.readFileSync(filePath, 'utf8'));
                    this.successes.push(`✅ Loaded ${file}`);
                } else {
                    this.errors.push(`❌ Missing configuration file: ${file}`);
                }
            });
        } catch (error) {
            this.errors.push(`❌ Error loading configurations: ${error.message}`);
        }
    }

    validateAgentModelMapping() {
        console.log('\n🤖 Validating Agent-Model Mapping...');
        
        const interfaceAgents = this.configs.interface?.agentSelector?.agents || [];
        const optimizationMapping = this.configs.optimization?.modelRouter?.agentModelMapping || {};

        interfaceAgents.forEach(agent => {
            if (agent.id === 'augment-agent') return; // Skip default agent

            // Check if agent has preferred model defined
            if (agent.preferredModel) {
                this.successes.push(`✅ ${agent.name} has preferred model: ${agent.preferredModel}`);
            } else if (optimizationMapping[agent.id]) {
                this.successes.push(`✅ ${agent.name} has model mapping in optimization config`);
            } else {
                this.warnings.push(`⚠️ ${agent.name} missing model preferences`);
            }

            // Check if agent has MCP servers defined
            if (agent.mcpServers && agent.mcpServers.length > 0) {
                this.successes.push(`✅ ${agent.name} has MCP servers: ${agent.mcpServers.join(', ')}`);
            } else {
                this.warnings.push(`⚠️ ${agent.name} missing MCP server configuration`);
            }

            // Check if agent has keywords for intelligent routing
            if (agent.keywords && agent.keywords.length > 0) {
                this.successes.push(`✅ ${agent.name} has routing keywords: ${agent.keywords.slice(0, 3).join(', ')}...`);
            } else {
                this.warnings.push(`⚠️ ${agent.name} missing routing keywords`);
            }
        });
    }

    validateMCPServerIntegration() {
        console.log('\n🔌 Validating MCP Server Integration...');
        
        const interfaceServers = this.configs.interface?.integration?.mcpServers?.servers || [];
        const mcpServers = this.configs.mcp?.servers || [];
        const serverAliases = this.configs.interface?.integration?.mcpServers?.serverAliases || {};

        // Check if all referenced servers exist in MCP config
        interfaceServers.forEach(serverName => {
            const actualName = serverAliases[serverName] || serverName;
            const mcpServer = mcpServers.find(s => s.name === actualName);
            
            if (mcpServer) {
                this.successes.push(`✅ MCP Server found: ${serverName}`);
            } else {
                this.errors.push(`❌ MCP Server not found: ${serverName} (${actualName})`);
            }
        });

        // Check for duplicate server entries
        const serverNames = mcpServers.map(s => s.name);
        const duplicates = serverNames.filter((name, index) => serverNames.indexOf(name) !== index);
        
        if (duplicates.length > 0) {
            this.warnings.push(`⚠️ Duplicate MCP servers found: ${duplicates.join(', ')}`);
        } else {
            this.successes.push(`✅ No duplicate MCP servers found`);
        }
    }

    validateModelConfiguration() {
        console.log('\n🧠 Validating Model Configuration...');
        
        const interfaceModels = this.configs.interface?.intelligentModelRouting?.models || {};
        const optimizationConfig = this.configs.optimization?.modelRouter || {};

        // Check if optimization config references interface config
        if (optimizationConfig.configSource === 'augment-interface-config.json') {
            this.successes.push(`✅ Optimization config properly references interface config`);
        } else {
            this.warnings.push(`⚠️ Optimization config should reference interface config as source`);
        }

        // Validate model consistency
        Object.entries(interfaceModels).forEach(([type, model]) => {
            if (model.provider === 'openrouter') {
                this.successes.push(`✅ ${model.name} properly configured for OpenRouter`);
            } else {
                this.warnings.push(`⚠️ ${model.name} missing OpenRouter provider specification`);
            }

            if (model.keywords && model.keywords.length > 0) {
                this.successes.push(`✅ ${model.name} has routing keywords defined`);
            } else {
                this.warnings.push(`⚠️ ${model.name} missing routing keywords`);
            }
        });
    }

    validateCostOptimization() {
        console.log('\n💰 Validating Cost Optimization...');
        
        const interfaceCost = this.configs.interface?.performance?.costOptimization || {};
        const optimizationCost = this.configs.optimization?.modelRouter || {};

        // Check budget consistency
        if (interfaceCost.dailyBudget === optimizationCost.dailyBudget) {
            this.successes.push(`✅ Daily budget consistent: $${interfaceCost.dailyBudget}`);
        } else {
            this.errors.push(`❌ Daily budget mismatch: Interface($${interfaceCost.dailyBudget}) vs Optimization($${optimizationCost.dailyBudget})`);
        }

        // Check if batch processing is configured
        const batchProcessing = this.configs.optimization?.batchProcessing;
        if (batchProcessing && batchProcessing.enabled) {
            this.successes.push(`✅ Batch processing enabled for cost optimization`);
        } else {
            this.warnings.push(`⚠️ Batch processing not configured for cost optimization`);
        }

        // Check if intelligent caching is configured
        const caching = this.configs.optimization?.intelligentCaching;
        if (caching && caching.enabled) {
            this.successes.push(`✅ Intelligent caching enabled for performance`);
        } else {
            this.warnings.push(`⚠️ Intelligent caching not configured`);
        }
    }

    validateContextManagement() {
        console.log('\n📝 Validating Context Management...');
        
        const interfaceContext = this.configs.interface?.integration?.vibecodeSystem || {};
        const optimizationContext = this.configs.optimization?.contextManagement || {};

        if (interfaceContext.contextManagement && optimizationContext.enabled) {
            this.successes.push(`✅ Context management enabled in both configurations`);
        } else {
            this.warnings.push(`⚠️ Context management not consistently configured`);
        }

        if (interfaceContext.memoryBankIntegration && optimizationContext.memoryBankIntegration?.enabled) {
            this.successes.push(`✅ Memory bank integration properly configured`);
        } else {
            this.warnings.push(`⚠️ Memory bank integration not consistently configured`);
        }
    }

    generateReport() {
        console.log('\n📊 CONFIGURATION INTEGRATION VALIDATION REPORT');
        console.log('='.repeat(60));
        
        console.log(`\n✅ SUCCESSES (${this.successes.length}):`);
        this.successes.forEach(success => console.log(`  ${success}`));
        
        if (this.warnings.length > 0) {
            console.log(`\n⚠️ WARNINGS (${this.warnings.length}):`);
            this.warnings.forEach(warning => console.log(`  ${warning}`));
        }
        
        if (this.errors.length > 0) {
            console.log(`\n❌ ERRORS (${this.errors.length}):`);
            this.errors.forEach(error => console.log(`  ${error}`));
        }

        console.log('\n📈 INTEGRATION SCORE:');
        const total = this.successes.length + this.warnings.length + this.errors.length;
        const score = Math.round((this.successes.length / total) * 100);
        console.log(`  ${score}% (${this.successes.length}/${total} checks passed)`);

        if (score >= 90) {
            console.log('\n🎉 EXCELLENT! Configuration integration is highly optimized.');
        } else if (score >= 75) {
            console.log('\n👍 GOOD! Minor optimizations recommended.');
        } else if (score >= 60) {
            console.log('\n⚠️ FAIR! Several improvements needed.');
        } else {
            console.log('\n❌ POOR! Major configuration issues detected.');
        }

        return {
            score,
            successes: this.successes.length,
            warnings: this.warnings.length,
            errors: this.errors.length
        };
    }

    validate() {
        console.log('🔍 Starting Configuration Integration Validation...\n');
        
        if (this.errors.length > 0) {
            console.log('❌ Cannot proceed due to configuration loading errors.');
            this.generateReport();
            return false;
        }

        this.validateAgentModelMapping();
        this.validateMCPServerIntegration();
        this.validateModelConfiguration();
        this.validateCostOptimization();
        this.validateContextManagement();

        const report = this.generateReport();
        
        console.log('\n🎯 NEXT STEPS:');
        if (report.errors > 0) {
            console.log('  1. Fix critical errors before proceeding');
            console.log('  2. Address warnings for optimal performance');
        } else if (report.warnings > 0) {
            console.log('  1. Address warnings for optimal performance');
            console.log('  2. Test the integrated system');
        } else {
            console.log('  1. System is ready for production use');
            console.log('  2. Monitor performance metrics');
        }

        return report.errors === 0;
    }
}

// CLI Interface
if (require.main === module) {
    const validator = new IntegrationValidator();
    const success = validator.validate();
    process.exit(success ? 0 : 1);
}

module.exports = IntegrationValidator;
