---
description: P.C.P.E. Automated Prevention System - Sistema de Alertas Preventivos em Tempo Real
author: GRUPO US VIBECODE SYSTEM V2.0
version: 1.0
priority: HIGH
globs: ["**/*"]
tags: ["prevention", "alerts", "real-time", "automation"]
alwaysApply: true
integrates: ["protocols/proactive_error_correction_protocol.md", "protocols/pcpe_ml_predictive_engine.md"]
---

# 🚨 P.C.P.E. AUTOMATED PREVENTION SYSTEM

## 📋 OVERVIEW

Sistema de **Prevenção Automatizada** que utiliza alertas em tempo real, análise de contexto e sugestões proativas para **prevenir erros antes que ocorram**, integrando-se com o ML Engine para máxima eficácia preventiva.

## 🎯 OBJETIVOS DO PREVENTION SYSTEM

### **Prevenção Proativa:**
- **Detectar situações de risco** antes da execução
- **Alertar em tempo real** sobre potenciais problemas
- **Sugerir ações preventivas** específicas
- **Bloquear execuções perigosas** quando necessário

### **Inteligência Contextual:**
- **Analisar contexto atual** do desenvolvimento
- **Comparar com padrões históricos** de erro
- **Adaptar alertas** ao nível de experiência do usuário
- **Personalizar prevenção** por projeto/framework

## 🛡️ ARQUITETURA DO PREVENTION SYSTEM

### **Componentes Principais:**

```javascript
const PreventionSystem = {
  // Monitor de Contexto em Tempo Real
  ContextMonitor: {
    monitorFileChanges: () => {},
    trackCommandHistory: () => {},
    analyzeProjectState: () => {},
    detectRiskPatterns: () => {}
  },
  
  // Sistema de Alertas
  AlertSystem: {
    generateAlert: () => {},
    prioritizeAlerts: () => {},
    displayAlert: () => {},
    trackAlertEffectiveness: () => {}
  },
  
  // Engine de Sugestões
  SuggestionEngine: {
    generatePreventiveSuggestions: () => {},
    rankSuggestions: () => {},
    customizeSuggestions: () => {},
    trackSuggestionSuccess: () => {}
  },
  
  // Sistema de Bloqueio
  SafetyBlocker: {
    assessExecutionSafety: () => {},
    blockDangerousOperations: () => {},
    requireConfirmation: () => {},
    logBlockedOperations: () => {}
  }
};
```

## 🔍 SISTEMA DE MONITORAMENTO CONTEXTUAL

### **1. Real-Time Context Monitor**

```javascript
class RealTimeContextMonitor {
  constructor() {
    this.contextHistory = [];
    this.riskIndicators = new Set();
    this.activeMonitors = new Map();
  }

  startMonitoring() {
    // Monitor de mudanças de arquivo
    this.startFileMonitor();
    
    // Monitor de comandos
    this.startCommandMonitor();
    
    // Monitor de estado do projeto
    this.startProjectStateMonitor();
    
    // Monitor de ambiente
    this.startEnvironmentMonitor();
  }

  startFileMonitor() {
    const fileWatcher = {
      onFileChange: (filePath, changeType) => {
        const riskAssessment = this.assessFileChangeRisk(filePath, changeType);
        
        if (riskAssessment.level >= 'MEDIUM') {
          this.triggerPreventiveAlert({
            type: 'FILE_CHANGE_RISK',
            level: riskAssessment.level,
            file: filePath,
            change: changeType,
            risks: riskAssessment.risks,
            suggestions: riskAssessment.suggestions
          });
        }
      }
    };
    
    this.activeMonitors.set('fileWatcher', fileWatcher);
  }

  assessFileChangeRisk(filePath, changeType) {
    const riskFactors = {
      // Arquivos críticos
      criticalFiles: [
        'package.json',
        'tsconfig.json',
        'next.config.js',
        'vite.config.ts',
        'prisma/schema.prisma',
        '.env'
      ],
      
      // Tipos de mudança arriscados
      riskyChanges: [
        'dependency-modification',
        'config-change',
        'schema-alteration',
        'environment-variable-change'
      ]
    };

    let riskLevel = 'LOW';
    const risks = [];
    const suggestions = [];

    // Verificar se é arquivo crítico
    if (riskFactors.criticalFiles.some(critical => filePath.includes(critical))) {
      riskLevel = 'HIGH';
      risks.push('Modificação em arquivo crítico do projeto');
      
      if (filePath.includes('package.json')) {
        suggestions.push('Verificar compatibilidade de dependências antes de instalar');
        suggestions.push('Fazer backup do package-lock.json');
      }
      
      if (filePath.includes('tsconfig.json')) {
        suggestions.push('Verificar se mudanças não quebram tipos existentes');
        suggestions.push('Executar type-check após modificação');
      }
      
      if (filePath.includes('prisma/schema.prisma')) {
        suggestions.push('Gerar migration antes de aplicar mudanças');
        suggestions.push('Verificar impacto em dados existentes');
      }
    }

    return { level: riskLevel, risks, suggestions };
  }

  startCommandMonitor() {
    const commandMonitor = {
      onCommandExecution: (command, context) => {
        const riskAssessment = this.assessCommandRisk(command, context);
        
        if (riskAssessment.shouldBlock) {
          return this.blockCommand(command, riskAssessment);
        }
        
        if (riskAssessment.level >= 'MEDIUM') {
          this.triggerPreventiveAlert({
            type: 'COMMAND_RISK',
            level: riskAssessment.level,
            command: command,
            risks: riskAssessment.risks,
            suggestions: riskAssessment.suggestions
          });
        }
      }
    };
    
    this.activeMonitors.set('commandMonitor', commandMonitor);
  }

  assessCommandRisk(command, context) {
    const dangerousCommands = {
      // Comandos de alto risco
      'rm -rf': { level: 'CRITICAL', shouldBlock: true },
      'sudo rm': { level: 'CRITICAL', shouldBlock: true },
      'npm install --force': { level: 'HIGH', shouldBlock: false },
      'yarn install --force': { level: 'HIGH', shouldBlock: false },
      'prisma db push --force-reset': { level: 'CRITICAL', shouldBlock: true },
      'git reset --hard': { level: 'HIGH', shouldBlock: false },
      'git push --force': { level: 'HIGH', shouldBlock: false }
    };

    const risks = [];
    const suggestions = [];
    let level = 'LOW';
    let shouldBlock = false;

    // Verificar comandos perigosos
    Object.keys(dangerousCommands).forEach(dangerous => {
      if (command.includes(dangerous)) {
        const commandRisk = dangerousCommands[dangerous];
        level = commandRisk.level;
        shouldBlock = commandRisk.shouldBlock;
        
        risks.push(`Comando perigoso detectado: ${dangerous}`);
        
        if (dangerous.includes('rm')) {
          suggestions.push('Verificar caminhos antes de deletar');
          suggestions.push('Considerar usar lixeira ao invés de rm');
        }
        
        if (dangerous.includes('--force')) {
          suggestions.push('Tentar comando sem --force primeiro');
          suggestions.push('Verificar se força é realmente necessária');
        }
        
        if (dangerous.includes('prisma')) {
          suggestions.push('Fazer backup do banco antes de reset');
          suggestions.push('Verificar se dados podem ser perdidos');
        }
      }
    });

    return { level, shouldBlock, risks, suggestions };
  }
}
```

### **2. Alert Generation System**

```javascript
class AlertGenerationSystem {
  constructor() {
    this.alertQueue = [];
    this.alertHistory = [];
    this.userPreferences = {
      alertLevel: 'MEDIUM', // MINIMAL, LOW, MEDIUM, HIGH, CRITICAL
      alertStyle: 'DETAILED', // MINIMAL, SUMMARY, DETAILED
      autoBlock: false
    };
  }

  generateAlert(alertData) {
    const alert = {
      id: this.generateAlertId(),
      timestamp: new Date().toISOString(),
      type: alertData.type,
      level: alertData.level,
      title: this.generateAlertTitle(alertData),
      message: this.generateAlertMessage(alertData),
      suggestions: alertData.suggestions || [],
      actions: this.generateAlertActions(alertData),
      context: alertData.context || {}
    };

    // Verificar se deve mostrar baseado nas preferências
    if (this.shouldShowAlert(alert)) {
      this.displayAlert(alert);
    }

    // Sempre registrar no histórico
    this.alertHistory.push(alert);
    
    return alert;
  }

  generateAlertTitle(alertData) {
    const titles = {
      'FILE_CHANGE_RISK': '📁 Modificação em Arquivo Crítico Detectada',
      'COMMAND_RISK': '⚠️ Comando de Alto Risco Detectado',
      'DEPENDENCY_RISK': '📦 Risco de Dependência Identificado',
      'BUILD_RISK': '🔨 Risco de Build Detectado',
      'DATABASE_RISK': '🗄️ Operação de Banco Perigosa',
      'ENVIRONMENT_RISK': '🌍 Mudança de Ambiente Arriscada'
    };

    return titles[alertData.type] || '⚠️ Risco Detectado';
  }

  generateAlertMessage(alertData) {
    let message = `🚨 PREVENTION SYSTEM ALERT - Nível: ${alertData.level}\n\n`;
    
    if (alertData.risks && alertData.risks.length > 0) {
      message += '🎯 Riscos Identificados:\n';
      alertData.risks.forEach(risk => {
        message += `   • ${risk}\n`;
      });
      message += '\n';
    }

    if (alertData.suggestions && alertData.suggestions.length > 0) {
      message += '💡 Sugestões Preventivas:\n';
      alertData.suggestions.forEach(suggestion => {
        message += `   ✅ ${suggestion}\n`;
      });
      message += '\n';
    }

    message += '🤔 Deseja prosseguir mesmo assim?';
    
    return message;
  }

  generateAlertActions(alertData) {
    const baseActions = [
      { id: 'proceed', label: 'Prosseguir', style: 'warning' },
      { id: 'cancel', label: 'Cancelar', style: 'safe' },
      { id: 'more_info', label: 'Mais Informações', style: 'info' }
    ];

    // Adicionar ações específicas baseadas no tipo
    if (alertData.type === 'COMMAND_RISK') {
      baseActions.unshift({
        id: 'modify_command',
        label: 'Modificar Comando',
        style: 'primary'
      });
    }

    if (alertData.type === 'FILE_CHANGE_RISK') {
      baseActions.unshift({
        id: 'backup_first',
        label: 'Fazer Backup Primeiro',
        style: 'primary'
      });
    }

    return baseActions;
  }

  displayAlert(alert) {
    console.log('\n' + '='.repeat(60));
    console.log(`🚨 ${alert.title}`);
    console.log('='.repeat(60));
    console.log(alert.message);
    
    if (alert.actions && alert.actions.length > 0) {
      console.log('\n📋 Ações Disponíveis:');
      alert.actions.forEach((action, index) => {
        const emoji = this.getActionEmoji(action.style);
        console.log(`   ${index + 1}. ${emoji} ${action.label}`);
      });
    }
    
    console.log('\n' + '='.repeat(60));
  }

  getActionEmoji(style) {
    const emojis = {
      'safe': '✅',
      'warning': '⚠️',
      'primary': '🔧',
      'info': 'ℹ️',
      'danger': '🚫'
    };
    
    return emojis[style] || '📋';
  }
}
```

### **3. Suggestion Engine**

```javascript
class PreventiveSuggestionEngine {
  constructor() {
    this.suggestionDatabase = new Map();
    this.contextualSuggestions = new Map();
    this.userFeedback = [];
  }

  generateSuggestions(context, riskAssessment) {
    const suggestions = [];

    // Sugestões baseadas no tipo de risco
    const typeSuggestions = this.getTypeSuggestions(context.type, riskAssessment);
    suggestions.push(...typeSuggestions);

    // Sugestões baseadas no contexto
    const contextSuggestions = this.getContextualSuggestions(context);
    suggestions.push(...contextSuggestions);

    // Sugestões baseadas no histórico
    const historicalSuggestions = this.getHistoricalSuggestions(context);
    suggestions.push(...historicalSuggestions);

    // Ranquear e filtrar sugestões
    return this.rankAndFilterSuggestions(suggestions, context);
  }

  getTypeSuggestions(type, riskAssessment) {
    const typeSuggestions = {
      'DEPENDENCY_RISK': [
        {
          id: 'check_compatibility',
          text: 'Verificar compatibilidade de versões antes de instalar',
          priority: 'HIGH',
          action: 'npm ls --depth=0'
        },
        {
          id: 'backup_lockfile',
          text: 'Fazer backup do package-lock.json',
          priority: 'MEDIUM',
          action: 'cp package-lock.json package-lock.json.backup'
        },
        {
          id: 'use_exact_versions',
          text: 'Considerar usar versões exatas ao invés de ranges',
          priority: 'LOW',
          action: 'npm install --save-exact'
        }
      ],
      
      'BUILD_RISK': [
        {
          id: 'clean_build',
          text: 'Limpar cache de build antes de tentar novamente',
          priority: 'HIGH',
          action: 'npm run clean && npm run build'
        },
        {
          id: 'check_types',
          text: 'Verificar erros de TypeScript primeiro',
          priority: 'HIGH',
          action: 'npx tsc --noEmit'
        },
        {
          id: 'update_dependencies',
          text: 'Verificar se dependências estão atualizadas',
          priority: 'MEDIUM',
          action: 'npm outdated'
        }
      ],
      
      'DATABASE_RISK': [
        {
          id: 'backup_database',
          text: 'CRÍTICO: Fazer backup do banco antes de prosseguir',
          priority: 'CRITICAL',
          action: 'pg_dump database_name > backup.sql'
        },
        {
          id: 'test_migration',
          text: 'Testar migration em ambiente de desenvolvimento primeiro',
          priority: 'HIGH',
          action: 'npx prisma migrate dev'
        },
        {
          id: 'check_data_impact',
          text: 'Verificar impacto nos dados existentes',
          priority: 'HIGH',
          action: 'npx prisma migrate diff'
        }
      ]
    };

    return typeSuggestions[type] || [];
  }

  getContextualSuggestions(context) {
    const suggestions = [];

    // Sugestões baseadas no framework
    if (context.framework === 'next.js') {
      suggestions.push({
        id: 'nextjs_build_check',
        text: 'Verificar se build do Next.js está funcionando',
        priority: 'MEDIUM',
        action: 'npm run build'
      });
    }

    if (context.framework === 'vite') {
      suggestions.push({
        id: 'vite_config_check',
        text: 'Verificar configuração do Vite',
        priority: 'MEDIUM',
        action: 'npx vite --config vite.config.ts'
      });
    }

    // Sugestões baseadas no projeto
    if (context.project === 'neonpro') {
      suggestions.push({
        id: 'neonpro_health_check',
        text: 'Executar health check específico do NEONPRO',
        priority: 'MEDIUM',
        action: 'npm run test:health'
      });
    }

    return suggestions;
  }

  rankAndFilterSuggestions(suggestions, context) {
    // Remover duplicatas
    const uniqueSuggestions = suggestions.filter((suggestion, index, self) =>
      index === self.findIndex(s => s.id === suggestion.id)
    );

    // Ordenar por prioridade
    const priorityOrder = { 'CRITICAL': 4, 'HIGH': 3, 'MEDIUM': 2, 'LOW': 1 };
    uniqueSuggestions.sort((a, b) => 
      priorityOrder[b.priority] - priorityOrder[a.priority]
    );

    // Limitar número de sugestões
    return uniqueSuggestions.slice(0, 5);
  }
}
```

## 🔒 SISTEMA DE BLOQUEIO DE SEGURANÇA

### **Safety Blocker Implementation:**

```javascript
class SafetyBlocker {
  constructor() {
    this.blockedOperations = [];
    this.blockingRules = new Map();
    this.emergencyOverrides = new Set();
  }

  assessExecutionSafety(command, context) {
    const safetyAssessment = {
      shouldBlock: false,
      blockReason: '',
      severity: 'LOW',
      overrideRequired: false,
      alternatives: []
    };

    // Verificar comandos críticos
    if (this.isCriticalCommand(command)) {
      safetyAssessment.shouldBlock = true;
      safetyAssessment.blockReason = 'Comando crítico detectado';
      safetyAssessment.severity = 'CRITICAL';
      safetyAssessment.overrideRequired = true;
    }

    // Verificar contexto perigoso
    if (this.isDangerousContext(context)) {
      safetyAssessment.shouldBlock = true;
      safetyAssessment.blockReason = 'Contexto perigoso detectado';
      safetyAssessment.severity = 'HIGH';
    }

    return safetyAssessment;
  }

  isCriticalCommand(command) {
    const criticalPatterns = [
      /rm\s+-rf\s+\//, // rm -rf /
      /sudo\s+rm/, // sudo rm
      /DROP\s+DATABASE/i, // SQL DROP DATABASE
      /TRUNCATE\s+TABLE/i, // SQL TRUNCATE
      /git\s+push\s+--force-with-lease\s+origin\s+main/, // Force push to main
      /prisma\s+db\s+push\s+--force-reset/ // Prisma force reset
    ];

    return criticalPatterns.some(pattern => pattern.test(command));
  }

  blockCommand(command, assessment) {
    const blockEntry = {
      timestamp: new Date().toISOString(),
      command: command,
      reason: assessment.blockReason,
      severity: assessment.severity,
      context: assessment.context
    };

    this.blockedOperations.push(blockEntry);

    console.log('\n🚫 OPERAÇÃO BLOQUEADA PELO SISTEMA DE SEGURANÇA');
    console.log('=' .repeat(50));
    console.log(`⚠️ Comando: ${command}`);
    console.log(`🎯 Motivo: ${assessment.blockReason}`);
    console.log(`📊 Severidade: ${assessment.severity}`);
    
    if (assessment.alternatives && assessment.alternatives.length > 0) {
      console.log('\n💡 Alternativas Sugeridas:');
      assessment.alternatives.forEach(alt => {
        console.log(`   ✅ ${alt}`);
      });
    }

    if (assessment.overrideRequired) {
      console.log('\n🔓 Para prosseguir, use: EXECUTE WITH MANUAL SUPERVISION');
    }

    console.log('=' .repeat(50));

    return { blocked: true, entry: blockEntry };
  }
}
```

---

**🚨 GRUPO US VIBECODE SYSTEM V2.0 - P.C.P.E. AUTOMATED PREVENTION**  
**Sistema de Alertas Preventivos e Bloqueio de Segurança**
