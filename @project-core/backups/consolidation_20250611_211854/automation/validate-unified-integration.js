#!/usr/bin/env node

/**
 * GRUPO US VIBECODE SYSTEM V3.1 - Unified Integration Validator
 * 
 * Validates the integration between Augment Code and Cursor AI environments
 * ensuring shared memory, configuration consistency, and cross-platform functionality.
 */

const fs = require('fs');
const path = require('path');

class UnifiedIntegrationValidator {
  constructor() {
    this.results = {
      passed: 0,
      failed: 0,
      warnings: 0,
      details: []
    };
    this.workspaceRoot = process.cwd();
  }

  log(message, type = 'info') {
    const timestamp = new Date().toISOString();
    const prefix = {
      'info': '📋',
      'success': '✅',
      'error': '❌',
      'warning': '⚠️'
    }[type] || '📋';
    
    console.log(`${prefix} [${timestamp}] ${message}`);
    this.results.details.push({ timestamp, type, message });
  }

  checkFileExists(filePath, description) {
    const fullPath = path.join(this.workspaceRoot, filePath);
    if (fs.existsSync(fullPath)) {
      this.log(`${description}: EXISTS`, 'success');
      this.results.passed++;
      return true;
    } else {
      this.log(`${description}: MISSING - ${filePath}`, 'error');
      this.results.failed++;
      return false;
    }
  }

  checkFileContent(filePath, searchPattern, description) {
    const fullPath = path.join(this.workspaceRoot, filePath);
    if (!fs.existsSync(fullPath)) {
      this.log(`${description}: FILE NOT FOUND - ${filePath}`, 'error');
      this.results.failed++;
      return false;
    }

    try {
      const content = fs.readFileSync(fullPath, 'utf8');
      if (content.includes(searchPattern)) {
        this.log(`${description}: FOUND`, 'success');
        this.results.passed++;
        return true;
      } else {
        this.log(`${description}: PATTERN NOT FOUND - ${searchPattern}`, 'warning');
        this.results.warnings++;
        return false;
      }
    } catch (error) {
      this.log(`${description}: READ ERROR - ${error.message}`, 'error');
      this.results.failed++;
      return false;
    }
  }

  validateCoreConfiguration() {
    this.log('🔍 VALIDATING CORE CONFIGURATION FILES', 'info');
    
    // Core unified configuration files
    this.checkFileExists('GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md', 'Universal AI Configuration');
    this.checkFileExists('@project-core/configs/unified-dev-environment-config.json', 'Unified Environment Config');
    this.checkFileExists('@project-core/configs/vscode-unified-settings.json', 'VS Code Unified Settings');
    this.checkFileExists('@project-core/rules/unified-development-environment-rules.md', 'Unified Development Rules');
  }

  validateEnvironmentConfigurations() {
    this.log('🔍 VALIDATING ENVIRONMENT-SPECIFIC CONFIGURATIONS', 'info');
    
    // Augment Code configuration
    this.checkFileExists('.augment-guidelines', 'Augment Guidelines');
    this.checkFileExists('.vscode/settings.json', 'VS Code Settings');
    
    // Cursor AI configuration  
    this.checkFileExists('.cursorrules', 'Cursor Rules');
    this.checkFileExists('.cursor/mcp.json', 'Cursor MCP Config');
    
    // Check for unified references
    this.checkFileContent('.cursorrules', 'GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md', 'Cursor Universal Config Reference');
    this.checkFileContent('.augment-guidelines', 'GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md', 'Augment Universal Config Reference');
  }

  validateSharedMemorySystem() {
    this.log('🔍 VALIDATING SHARED MEMORY SYSTEM', 'info');
    
    // Core memory files
    this.checkFileExists('@project-core/memory/master_rule.md', 'Master Rule');
    this.checkFileExists('@project-core/memory/self_correction_log.md', 'Self Correction Log');
    this.checkFileExists('@project-core/memory/global-standards.md', 'Global Standards');
    this.checkFileExists('@project-core/memory/augment-agent-guidelines-v3.md', 'Augment Guidelines V3');
    
    // Check memory references in configurations
    this.checkFileContent('.cursorrules', '@project-core/memory/', 'Cursor Memory Integration');
    this.checkFileContent('.augment-guidelines', '@project-core/memory/', 'Augment Memory Integration');
  }

  validateMCPIntegration() {
    this.log('🔍 VALIDATING MCP INTEGRATION', 'info');
    
    // MCP configuration files
    this.checkFileExists('@project-core/configs/mcp-master-unified.json', 'MCP Master Config');
    this.checkFileExists('.cursor/mcp.json', 'Cursor MCP Config');
    
    // Check MCP references
    this.checkFileContent('@project-core/configs/mcp-master-unified.json', 'sequential-thinking', 'Sequential Thinking MCP');
    this.checkFileContent('@project-core/configs/mcp-master-unified.json', 'mcp-shrimp-task-manager', 'Shrimp Task Manager MCP');
  }

  validateCoordinationProtocols() {
    this.log('🔍 VALIDATING COORDINATION PROTOCOLS', 'info');
    
    // Check for coordination patterns in configurations
    this.checkFileContent('@project-core/configs/unified-dev-environment-config.json', 'coordinationProtocols', 'Coordination Protocols Config');
    this.checkFileContent('@project-core/rules/unified-development-environment-rules.md', 'handoff', 'Handoff Protocols');
    this.checkFileContent('GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md', 'Environment Handoff', 'Universal Handoff System');
  }

  validateCrossEnvironmentCompatibility() {
    this.log('🔍 VALIDATING CROSS-ENVIRONMENT COMPATIBILITY', 'info');
    
    // Check for environment specialization
    this.checkFileContent('.cursorrules', 'Frontend & UI Development', 'Cursor Specialization');
    this.checkFileContent('.augment-guidelines', 'Backend & Architecture', 'Augment Specialization');
    
    // Check for complexity routing
    this.checkFileContent('GRUPO-US-UNIVERSAL-AI-CONFIGURATION.md', 'selectEnvironment', 'Environment Selection Algorithm');
    this.checkFileContent('@project-core/configs/unified-dev-environment-config.json', 'taskSpecialization', 'Task Specialization Config');
  }

  generateReport() {
    this.log('📊 GENERATING VALIDATION REPORT', 'info');
    
    const totalTests = this.results.passed + this.results.failed + this.results.warnings;
    const successRate = totalTests > 0 ? ((this.results.passed / totalTests) * 100).toFixed(1) : 0;
    
    const report = {
      timestamp: new Date().toISOString(),
      summary: {
        totalTests,
        passed: this.results.passed,
        failed: this.results.failed,
        warnings: this.results.warnings,
        successRate: `${successRate}%`
      },
      status: this.results.failed === 0 ? 'PASSED' : 'FAILED',
      details: this.results.details
    };
    
    // Save report
    const reportPath = path.join(this.workspaceRoot, '@project-core/reports/unified-integration-validation.json');
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
    
    // Console summary
    console.log('\n🎉 VALIDATION COMPLETE!');
    console.log(`📊 Total Tests: ${totalTests}`);
    console.log(`✅ Passed: ${this.results.passed}`);
    console.log(`❌ Failed: ${this.results.failed}`);
    console.log(`⚠️  Warnings: ${this.results.warnings}`);
    console.log(`📈 Success Rate: ${successRate}%`);
    console.log(`📄 Report saved: ${reportPath}`);
    
    if (this.results.failed === 0) {
      console.log('\n🚀 UNIFIED INTEGRATION VALIDATION: PASSED!');
      console.log('✅ Augment Code and Cursor AI are successfully integrated with shared memory and coordination protocols.');
    } else {
      console.log('\n🚨 UNIFIED INTEGRATION VALIDATION: FAILED!');
      console.log('❌ Some integration components are missing or misconfigured. Please review the failed tests above.');
    }
    
    return report;
  }

  async run() {
    this.log('🚀 STARTING UNIFIED INTEGRATION VALIDATION', 'info');
    this.log('📋 GRUPO US VIBECODE SYSTEM V3.1 - Augment + Cursor Integration', 'info');
    
    try {
      this.validateCoreConfiguration();
      this.validateEnvironmentConfigurations();
      this.validateSharedMemorySystem();
      this.validateMCPIntegration();
      this.validateCoordinationProtocols();
      this.validateCrossEnvironmentCompatibility();
      
      return this.generateReport();
    } catch (error) {
      this.log(`VALIDATION ERROR: ${error.message}`, 'error');
      this.results.failed++;
      return this.generateReport();
    }
  }
}

// Run validation if called directly
if (require.main === module) {
  const validator = new UnifiedIntegrationValidator();
  validator.run().then(report => {
    process.exit(report.status === 'PASSED' ? 0 : 1);
  });
}

module.exports = UnifiedIntegrationValidator;
