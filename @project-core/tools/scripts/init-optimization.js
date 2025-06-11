#!/usr/bin/env node
/**
 * Augment Optimization Initialization Script
 * GRUPO US VIBECODE SYSTEM V2.0 - AUGMENT OPTIMIZATION
 */

const fs = require('fs');
const path = require('path');
const APIMonitor = require('../utils/api-monitor');
const BatchProcessor = require('../utils/batch-processor');
const ContextManager = require('../utils/context-manager');
const ModelRouter = require('../utils/model-router');
const PerformanceDashboard = require('../utils/performance-dashboard');

class AugmentOptimizationSystem {
  constructor() {
    this.config = this.loadConfiguration();
    this.initialized = false;
    this.systems = {};
    
    console.log('🚀 Initializing AUGMENT Performance Optimization System V2.0');
    console.log('================================================================');
  }

  /**
   * Load configuration from file
   */
  loadConfiguration() {
    try {
      const configPath = path.join(__dirname, '..', 'augment-optimization-config.json');
      const configData = fs.readFileSync(configPath, 'utf8');
      const config = JSON.parse(configData);
      
      console.log(`✅ Configuration loaded: ${config.name} v${config.version}`);
      return config;
    } catch (error) {
      console.error('❌ Failed to load configuration:', error.message);
      console.log('📄 Using default configuration...');
      return this.getDefaultConfiguration();
    }
  }

  /**
   * Get default configuration if file is missing
   */
  getDefaultConfiguration() {
    return {
      targets: {
        apiCallsReduction: 60,
        responseTime: 2000,
        costPerFeature: 0.50,
        successRate: 85,
        errorRate: 5
      },
      monitoring: { enabled: true, updateInterval: 5000 },
      apiMonitor: { enabled: true },
      batchProcessor: { enabled: true },
      contextManager: { enabled: true },
      modelRouter: { enabled: true }
    };
  }

  /**
   * Initialize all optimization systems
   */
  async initialize() {
    try {
      console.log('\n🔧 Initializing optimization systems...');
      
      // Initialize API Monitor
      if (this.config.apiMonitor?.enabled) {
        console.log('   📊 Initializing API Monitor...');
        this.systems.apiMonitor = new APIMonitor();
        console.log('   ✅ API Monitor ready');
      }
      
      // Initialize Batch Processor
      if (this.config.batchProcessor?.enabled) {
        console.log('   📦 Initializing Batch Processor...');
        this.systems.batchProcessor = new BatchProcessor({
          maxBatchSize: this.config.batchProcessor.maxBatchSize || 10,
          maxWaitTime: this.config.batchProcessor.maxWaitTime || 1000
        });
        console.log('   ✅ Batch Processor ready');
      }
      
      // Initialize Context Manager
      if (this.config.contextManager?.enabled) {
        console.log('   🧠 Initializing Context Manager...');
        this.systems.contextManager = new ContextManager({
          maxTokens: this.config.contextManager.maxTokens || 32000
        });
        console.log('   ✅ Context Manager ready');
      }
      
      // Initialize Model Router
      if (this.config.modelRouter?.enabled) {
        console.log('   🎯 Initializing Model Router...');
        this.systems.modelRouter = new ModelRouter({
          dailyBudget: this.config.modelRouter.dailyBudget || 10.0
        });
        console.log('   ✅ Model Router ready');
      }
      
      // Initialize Performance Dashboard
      if (this.config.monitoring?.enabled) {
        console.log('   📈 Initializing Performance Dashboard...');
        this.systems.dashboard = new PerformanceDashboard();
        console.log('   ✅ Performance Dashboard ready');
      }
      
      // Setup integrations
      await this.setupIntegrations();
      
      // Setup monitoring
      this.setupMonitoring();
      
      // Setup error handling
      this.setupErrorHandling();
      
      this.initialized = true;
      console.log('\n🎉 AUGMENT Optimization System initialized successfully!');
      
      // Display initial status
      this.displayStatus();
      
      return true;
      
    } catch (error) {
      console.error('❌ Initialization failed:', error);
      throw error;
    }
  }

  /**
   * Setup system integrations
   */
  async setupIntegrations() {
    console.log('\n🔗 Setting up system integrations...');
    
    // TaskMaster integration
    if (this.config.integration?.taskMaster?.enabled) {
      console.log('   🤖 TaskMaster integration: Enabled');
      // Integration logic would go here
    }
    
    // Playwright integration
    if (this.config.integration?.playwright?.enabled) {
      console.log('   🎭 Playwright integration: Enabled');
      // Integration logic would go here
    }
    
    // Memory Bank integration
    if (this.config.integration?.memoryBank?.enabled) {
      console.log('   🧠 Memory Bank integration: Enabled');
      // Integration logic would go here
    }
    
    console.log('   ✅ Integrations configured');
  }

  /**
   * Setup monitoring and alerts
   */
  setupMonitoring() {
    console.log('\n📊 Setting up monitoring...');
    
    if (this.systems.dashboard && this.config.monitoring?.enabled) {
      const updateInterval = this.config.monitoring.updateInterval || 5000;
      
      // Start dashboard in background
      setTimeout(() => {
        this.systems.dashboard.start(updateInterval);
      }, 1000);
      
      console.log(`   ✅ Dashboard monitoring: ${updateInterval}ms intervals`);
    }
    
    // Setup performance alerts
    if (this.config.monitoring?.alertThresholds) {
      console.log('   🚨 Performance alerts: Configured');
    }
  }

  /**
   * Setup error handling and recovery
   */
  setupErrorHandling() {
    console.log('\n🛡️  Setting up error handling...');
    
    // Global error handlers
    process.on('uncaughtException', (error) => {
      console.error('🚨 Uncaught Exception:', error);
      this.handleCriticalError(error);
    });
    
    process.on('unhandledRejection', (reason, promise) => {
      console.error('🚨 Unhandled Rejection:', reason);
      this.handleCriticalError(reason);
    });
    
    // Graceful shutdown
    process.on('SIGINT', () => {
      console.log('\n🛑 Graceful shutdown initiated...');
      this.shutdown();
    });
    
    console.log('   ✅ Error handling configured');
  }

  /**
   * Handle critical errors
   */
  handleCriticalError(error) {
    console.error('💥 Critical error detected:', error);
    
    // Save current state
    this.saveState();
    
    // Attempt recovery
    setTimeout(() => {
      console.log('🔄 Attempting system recovery...');
      this.recover();
    }, 1000);
  }

  /**
   * Display current system status
   */
  displayStatus() {
    console.log('\n📊 SYSTEM STATUS');
    console.log('================');
    
    Object.entries(this.systems).forEach(([name, system]) => {
      const status = system ? '🟢 Active' : '🔴 Inactive';
      console.log(`   ${name}: ${status}`);
    });
    
    console.log('\n🎯 PERFORMANCE TARGETS');
    console.log('======================');
    Object.entries(this.config.targets).forEach(([metric, target]) => {
      console.log(`   ${metric}: ${target}${typeof target === 'number' && target < 10 ? '%' : ''}`);
    });
    
    console.log('\n💡 OPTIMIZATION FEATURES');
    console.log('========================');
    console.log(`   📊 API Monitoring: ${this.config.apiMonitor?.enabled ? '✅' : '❌'}`);
    console.log(`   📦 Batch Processing: ${this.config.batchProcessor?.enabled ? '✅' : '❌'}`);
    console.log(`   🧠 Context Management: ${this.config.contextManager?.enabled ? '✅' : '❌'}`);
    console.log(`   🎯 Model Selection: ${this.config.modelRouter?.enabled ? '✅' : '❌'}`);
    console.log(`   📈 Performance Dashboard: ${this.config.monitoring?.enabled ? '✅' : '❌'}`);
  }

  /**
   * Get system performance report
   */
  getPerformanceReport() {
    if (!this.initialized) {
      return { error: 'System not initialized' };
    }
    
    const report = {
      timestamp: new Date().toISOString(),
      systemStatus: 'active',
      components: {}
    };
    
    // Collect metrics from each system
    if (this.systems.apiMonitor) {
      report.components.apiMonitor = this.systems.apiMonitor.getPerformanceReport();
    }
    
    if (this.systems.batchProcessor) {
      report.components.batchProcessor = this.systems.batchProcessor.getStats();
    }
    
    if (this.systems.contextManager) {
      report.components.contextManager = this.systems.contextManager.getUsageStats();
    }
    
    if (this.systems.modelRouter) {
      report.components.modelRouter = this.systems.modelRouter.getUsageStats();
    }
    
    return report;
  }

  /**
   * Save current system state
   */
  saveState() {
    try {
      const state = {
        timestamp: Date.now(),
        config: this.config,
        systems: {}
      };
      
      // Save state from each system
      if (this.systems.contextManager) {
        state.systems.contextManager = this.systems.contextManager.exportState();
      }
      
      if (this.systems.modelRouter) {
        state.systems.modelRouter = this.systems.modelRouter.getUsageStats();
      }
      
      const stateFile = `augment-state-${Date.now()}.json`;
      fs.writeFileSync(stateFile, JSON.stringify(state, null, 2));
      
      console.log(`💾 System state saved: ${stateFile}`);
      
    } catch (error) {
      console.error('❌ Failed to save state:', error);
    }
  }

  /**
   * Recover system from saved state
   */
  recover() {
    try {
      console.log('🔄 Attempting system recovery...');
      
      // Find latest state file
      const stateFiles = fs.readdirSync('.')
        .filter(file => file.startsWith('augment-state-'))
        .sort()
        .reverse();
      
      if (stateFiles.length > 0) {
        const latestState = stateFiles[0];
        const stateData = JSON.parse(fs.readFileSync(latestState, 'utf8'));
        
        // Restore context manager state
        if (stateData.systems.contextManager && this.systems.contextManager) {
          this.systems.contextManager.importState(stateData.systems.contextManager);
        }
        
        console.log(`✅ System recovered from: ${latestState}`);
      } else {
        console.log('⚠️  No state files found, performing clean restart');
      }
      
    } catch (error) {
      console.error('❌ Recovery failed:', error);
    }
  }

  /**
   * Shutdown system gracefully
   */
  shutdown() {
    console.log('🛑 Shutting down optimization system...');
    
    // Save current state
    this.saveState();
    
    // Stop dashboard
    if (this.systems.dashboard) {
      this.systems.dashboard.stop();
    }
    
    // Clear batch processor
    if (this.systems.batchProcessor) {
      this.systems.batchProcessor.clear();
    }
    
    console.log('✅ Shutdown complete');
    process.exit(0);
  }

  /**
   * Run performance test
   */
  async runPerformanceTest() {
    console.log('\n🧪 Running performance validation...');
    
    try {
      const PerformanceTestSuite = require('./performance-test');
      const testSuite = new PerformanceTestSuite();
      
      const results = await testSuite.runTests();
      
      console.log('✅ Performance test completed');
      return results;
      
    } catch (error) {
      console.error('❌ Performance test failed:', error);
      throw error;
    }
  }

  /**
   * Initialize interface settings
   */
  initializeInterface() {
    try {
      const interfaceConfigPath = path.join(__dirname, '..', 'augment-interface-config.json');
      
      // Verificar se o arquivo existe
      if (!fs.existsSync(interfaceConfigPath)) {
        console.log('⚠️ Interface config não encontrado, criando configuração padrão...');
        this.createDefaultInterfaceConfig();
      }
      
      // Carregar configuração
      const interfaceConfig = JSON.parse(fs.readFileSync(interfaceConfigPath, 'utf8'));
      
      // Garantir que os controles estejam visíveis
      interfaceConfig.interface.showModelSelector = true;
      interfaceConfig.interface.showMaxModeToggle = true;
      interfaceConfig.interface.showAgentSelector = true;
      interfaceConfig.interface.mode = 'legacy';
      
      // Salvar configuração atualizada
      fs.writeFileSync(interfaceConfigPath, JSON.stringify(interfaceConfig, null, 2));
      
      console.log('✅ Interface configurada para modo padrão com todos os controles visíveis');
      return true;
    } catch (error) {
      console.error('❌ Falha ao inicializar interface:', error.message);
      return false;
    }
  }

  /**
   * Create default interface configuration
   */
  createDefaultInterfaceConfig() {
    const defaultConfig = {
      "version": "1.0.0",
      "name": "AUGMENT Interface Configuration",
      "description": "Configurações da interface do Augment para GRUPO US",
      "interface": {
        "mode": "legacy",
        "showToolbar": true,
        "showModelSelector": true,
        "showMaxModeToggle": true,
        "showAgentSelector": true,
        "defaultModel": "claude-3-sonnet",
        "defaultMaxMode": false,
        "defaultAgent": "augment-agent"
      }
    };
    
    const interfaceConfigPath = path.join(__dirname, '..', 'augment-interface-config.json');
    fs.writeFileSync(interfaceConfigPath, JSON.stringify(defaultConfig, null, 2));
    console.log('✅ Configuração padrão de interface criada com sucesso');
  }
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);
  const command = args[0] || 'init';
  
  const system = new AugmentOptimizationSystem();
  
  switch (command) {
    case 'init':
      system.initialize()
        .then(() => {
          console.log('\n🎉 System ready! Use Ctrl+C to shutdown.');
          // Keep process alive
          setInterval(() => {}, 1000);
        })
        .catch(error => {
          console.error('❌ Initialization failed:', error);
          process.exit(1);
        });
      break;
      
    case 'test':
      system.initialize()
        .then(() => system.runPerformanceTest())
        .then(() => process.exit(0))
        .catch(error => {
          console.error('❌ Test failed:', error);
          process.exit(1);
        });
      break;
      
    case 'status':
      system.initialize()
        .then(() => {
          const report = system.getPerformanceReport();
          console.log(JSON.stringify(report, null, 2));
          process.exit(0);
        })
        .catch(error => {
          console.error('❌ Status check failed:', error);
          process.exit(1);
        });
      break;
      
    default:
      console.log('Usage: node init-optimization.js [init|test|status]');
      process.exit(1);
  }
}

module.exports = AugmentOptimizationSystem;

