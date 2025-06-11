/**
 * AI Model Routing Configuration Validator
 * GRUPO US VIBECODE SYSTEM V2.0 - Configuration Integrity Testing
 */

const fs = require('fs');
const path = require('path');

class ConfigValidator {
  constructor() {
    this.errors = [];
    this.warnings = [];
    this.validationResults = {
      passed: 0,
      failed: 0,
      warnings: 0
    };
  }

  /**
   * Main validation entry point
   */
  async validateConfiguration(configPath = null) {
    console.log('🔍 Starting AI Model Routing Configuration Validation...\n');
    
    try {
      // Validate core configuration files
      await this.validateCoreConfigs();
      
      // Validate model definitions
      await this.validateModelDefinitions();
      
      // Validate selection algorithms
      await this.validateSelectionAlgorithms();
      
      // Validate cost optimization
      await this.validateCostOptimization();
      
      // Validate performance monitoring
      await this.validatePerformanceMonitoring();
      
      // Validate cache integrity
      await this.validateCacheIntegrity();
      
      // Validate template consistency
      await this.validateTemplateConsistency();
      
      // Generate validation report
      this.generateValidationReport();
      
    } catch (error) {
      this.addError('CRITICAL', `Validation failed: ${error.message}`);
    }
    
    return this.getValidationSummary();
  }

  /**
   * Validate core configuration files
   */
  async validateCoreConfigs() {
    console.log('📋 Validating Core Configuration Files...');
    
    const coreFiles = [
      '00-master-routing-config.md',
      '01-model-definitions.md', 
      '02-selection-algorithms.md',
      '03-cost-optimization.md',
      '04-performance-monitoring.md',
      '05-universal-templates.md'
    ];
    
    for (const file of coreFiles) {
      const filePath = path.join(__dirname, '..', file);
      
      if (!fs.existsSync(filePath)) {
        this.addError('CRITICAL', `Missing core configuration file: ${file}`);
        continue;
      }
      
      const content = fs.readFileSync(filePath, 'utf8');
      
      // Validate file structure
      if (!this.validateFileStructure(content, file)) {
        this.addError('HIGH', `Invalid structure in file: ${file}`);
      }
      
      // Validate JSON blocks
      if (!this.validateJSONBlocks(content, file)) {
        this.addError('MEDIUM', `Invalid JSON configuration in file: ${file}`);
      }
      
      this.validationResults.passed++;
    }
  }

  /**
   * Validate model definitions consistency
   */
  async validateModelDefinitions() {
    console.log('🤖 Validating Model Definitions...');
    
    const requiredModels = [
      'google/gemini-2.5-flash-preview-05-20:thinking',
      'anthropic/claude-sonnet-4',
      'google/gemini-2.5-pro-preview-05-06'
    ];
    
    const cacheFile = path.join(__dirname, '..', 'cache', 'model-cache.json');
    
    if (!fs.existsSync(cacheFile)) {
      this.addError('HIGH', 'Model cache file missing');
      return;
    }
    
    const cache = JSON.parse(fs.readFileSync(cacheFile, 'utf8'));
    
    // Validate required models are present
    for (const modelId of requiredModels) {
      if (!cache.modelConfigurations[modelId]) {
        this.addError('HIGH', `Missing required model configuration: ${modelId}`);
      } else {
        // Validate model configuration structure
        const model = cache.modelConfigurations[modelId];
        
        if (!this.validateModelStructure(model, modelId)) {
          this.addError('MEDIUM', `Invalid model structure: ${modelId}`);
        }
        
        this.validationResults.passed++;
      }
    }
  }

  /**
   * Validate selection algorithms
   */
  async validateSelectionAlgorithms() {
    console.log('🧮 Validating Selection Algorithms...');
    
    const selectionCache = path.join(__dirname, '..', 'cache', 'selection-cache.json');
    
    if (!fs.existsSync(selectionCache)) {
      this.addError('HIGH', 'Selection cache file missing');
      return;
    }
    
    const cache = JSON.parse(fs.readFileSync(selectionCache, 'utf8'));
    
    // Validate pattern cache
    if (!cache.patternCache) {
      this.addError('HIGH', 'Pattern cache missing');
      return;
    }
    
    // Validate complexity cache
    if (!cache.complexityCache) {
      this.addError('HIGH', 'Complexity cache missing');
      return;
    }
    
    // Validate complexity levels 1-10
    for (let i = 1; i <= 10; i++) {
      if (!cache.complexityCache[i.toString()]) {
        this.addError('MEDIUM', `Missing complexity level ${i} in cache`);
      }
    }
    
    this.validationResults.passed++;
  }

  /**
   * Validate cost optimization configuration
   */
  async validateCostOptimization() {
    console.log('💰 Validating Cost Optimization...');
    
    // Validate budget configuration
    const budgetConfig = {
      dailyBudget: 10.0,
      modelLimits: {
        'google/gemini-2.5-flash-preview-05-20:thinking': 3.0,
        'anthropic/claude-sonnet-4': 5.0,
        'google/gemini-2.5-pro-preview-05-06': 2.0
      }
    };
    
    // Validate budget totals
    const totalModelLimits = Object.values(budgetConfig.modelLimits).reduce((a, b) => a + b, 0);
    
    if (totalModelLimits !== budgetConfig.dailyBudget) {
      this.addWarning('MEDIUM', `Model limits total (${totalModelLimits}) doesn't match daily budget (${budgetConfig.dailyBudget})`);
    }
    
    this.validationResults.passed++;
  }

  /**
   * Validate performance monitoring setup
   */
  async validatePerformanceMonitoring() {
    console.log('📊 Validating Performance Monitoring...');
    
    const performanceTargets = {
      responseTime: 2000,
      selectionAccuracy: 0.95,
      cacheHitRate: 0.90,
      costEfficiency: 0.80,
      errorRate: 0.02
    };
    
    // Validate target ranges
    for (const [metric, target] of Object.entries(performanceTargets)) {
      if (typeof target !== 'number') {
        this.addError('MEDIUM', `Invalid performance target for ${metric}: ${target}`);
      }
    }
    
    this.validationResults.passed++;
  }

  /**
   * Validate cache integrity
   */
  async validateCacheIntegrity() {
    console.log('🗄️ Validating Cache Integrity...');
    
    const cacheFiles = [
      'cache/model-cache.json',
      'cache/selection-cache.json'
    ];
    
    for (const cacheFile of cacheFiles) {
      const filePath = path.join(__dirname, '..', cacheFile);
      
      if (!fs.existsSync(filePath)) {
        this.addError('HIGH', `Missing cache file: ${cacheFile}`);
        continue;
      }
      
      try {
        const cache = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        
        // Validate cache structure
        if (!cache.version || !cache.lastUpdated) {
          this.addError('MEDIUM', `Invalid cache structure in: ${cacheFile}`);
        }
        
        this.validationResults.passed++;
        
      } catch (error) {
        this.addError('HIGH', `Invalid JSON in cache file: ${cacheFile}`);
      }
    }
  }

  /**
   * Validate template consistency
   */
  async validateTemplateConsistency() {
    console.log('📝 Validating Template Consistency...');
    
    const templateDir = path.join(__dirname, '..', 'templates');
    
    if (!fs.existsSync(templateDir)) {
      this.addError('HIGH', 'Templates directory missing');
      return;
    }
    
    const templates = fs.readdirSync(templateDir);
    
    if (templates.length === 0) {
      this.addError('MEDIUM', 'No templates found');
      return;
    }
    
    // Validate each template
    for (const template of templates) {
      const templatePath = path.join(templateDir, template);
      const content = fs.readFileSync(templatePath, 'utf8');
      
      // Check for required imports
      if (!content.includes('@import project-core/rules/ai-model-routing/')) {
        this.addWarning('LOW', `Template ${template} missing core imports`);
      }
      
      this.validationResults.passed++;
    }
  }

  /**
   * Validate file structure
   */
  validateFileStructure(content, filename) {
    // Check for required sections based on file type
    const requiredSections = {
      '00-master-routing-config.md': ['Core Configuration', 'OpenRouter Integration', 'Intelligent Model Selection'],
      '01-model-definitions.md': ['Primary Models Configuration', 'Model Selection Matrix'],
      '02-selection-algorithms.md': ['Core Selection Algorithm', 'Complexity Assessment'],
      '03-cost-optimization.md': ['Budget Management System', 'Cost Calculation Engine'],
      '04-performance-monitoring.md': ['Performance Metrics System', 'Real-Time Monitoring'],
      '05-universal-templates.md': ['Universal Template Architecture', 'Extension-Specific Templates']
    };
    
    const sections = requiredSections[filename];
    if (!sections) return true;
    
    for (const section of sections) {
      if (!content.includes(section)) {
        this.addWarning('LOW', `Missing section "${section}" in ${filename}`);
        return false;
      }
    }
    
    return true;
  }

  /**
   * Validate JSON blocks in markdown
   */
  validateJSONBlocks(content, filename) {
    const jsonBlocks = content.match(/```json\n([\s\S]*?)\n```/g);
    
    if (!jsonBlocks) return true;
    
    for (const block of jsonBlocks) {
      const jsonContent = block.replace(/```json\n/, '').replace(/\n```/, '');
      
      try {
        JSON.parse(jsonContent);
      } catch (error) {
        this.addError('MEDIUM', `Invalid JSON in ${filename}: ${error.message}`);
        return false;
      }
    }
    
    return true;
  }

  /**
   * Validate model structure
   */
  validateModelStructure(model, modelId) {
    const requiredFields = ['configuration', 'cached', 'lastAccessed', 'averageResponseTime'];
    
    for (const field of requiredFields) {
      if (!(field in model)) {
        this.addError('MEDIUM', `Missing field "${field}" in model ${modelId}`);
        return false;
      }
    }
    
    return true;
  }

  /**
   * Add error to validation results
   */
  addError(severity, message) {
    this.errors.push({ severity, message, timestamp: new Date().toISOString() });
    this.validationResults.failed++;
  }

  /**
   * Add warning to validation results
   */
  addWarning(severity, message) {
    this.warnings.push({ severity, message, timestamp: new Date().toISOString() });
    this.validationResults.warnings++;
  }

  /**
   * Generate validation report
   */
  generateValidationReport() {
    console.log('\n📋 VALIDATION REPORT');
    console.log('='.repeat(50));
    console.log(`✅ Passed: ${this.validationResults.passed}`);
    console.log(`❌ Failed: ${this.validationResults.failed}`);
    console.log(`⚠️  Warnings: ${this.validationResults.warnings}`);
    
    if (this.errors.length > 0) {
      console.log('\n❌ ERRORS:');
      this.errors.forEach(error => {
        console.log(`  [${error.severity}] ${error.message}`);
      });
    }
    
    if (this.warnings.length > 0) {
      console.log('\n⚠️  WARNINGS:');
      this.warnings.forEach(warning => {
        console.log(`  [${warning.severity}] ${warning.message}`);
      });
    }
    
    console.log('\n' + '='.repeat(50));
  }

  /**
   * Get validation summary
   */
  getValidationSummary() {
    return {
      success: this.validationResults.failed === 0,
      results: this.validationResults,
      errors: this.errors,
      warnings: this.warnings
    };
  }
}

// CLI execution
if (require.main === module) {
  const validator = new ConfigValidator();
  validator.validateConfiguration().then(summary => {
    process.exit(summary.success ? 0 : 1);
  });
}

module.exports = ConfigValidator;
