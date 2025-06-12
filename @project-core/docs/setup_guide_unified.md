# 🚀 **GUIA DE SETUP UNIFICADO - VIBECODE SYSTEM V4.0**

## 📋 **VISÃO GERAL**

Guia completo e unificado para configuração do GRUPO US VIBECODE SYSTEM V4.0 em qualquer ambiente de desenvolvimento. Inclui setup para VS Code/Augment, Cursor, configurações MCP, e validação completa do sistema.

---

## ⚡ **SETUP RÁPIDO (5 MINUTOS)**

### **1. Pré-requisitos**
```bash
# Verificar Node.js (≥18.0.0)
node --version

# Verificar Python (≥3.8)
python --version

# Verificar Git
git --version
```

### **2. Clonagem e Configuração Inicial**
```bash
# Clonar repositório
git clone https://github.com/GrupoUS/VSCODE.git
cd VSCODE

# Configurar environment variables
cp .env.example .env
# Editar .env com suas API keys
```

### **3. Configuração MCP Automática**
```bash
# Sincronizar configurações MCP
python @project-core/automation/sync_mcp_configs.py --sync-all

# Validar configuração
python @project-core/automation/validate_mcp_configuration_enhanced.py --comprehensive
```

### **4. Validação Final**
```bash
# Executar teste unificado
python @project-core/automation/finaltest_unified.py --mode=comprehensive

# Verificar status do sistema
python @project-core/automation/validation_suite.py --type=system
```

---

## 🔧 **CONFIGURAÇÃO DETALHADA POR AMBIENTE**

### **VS CODE + AUGMENT SETUP**

#### **1. Instalação da Extensão Augment**
1. Abrir VS Code
2. Ir para Extensions (Ctrl+Shift+X)
3. Buscar "Augment"
4. Instalar e recarregar

#### **2. Configuração MCP**
```bash
# Sincronizar configuração VSCode
python @project-core/automation/sync_mcp_configs.py --sync-vscode
```

#### **3. Configurações do Workspace**
```json
// .vscode/settings.json (auto-gerado)
{
  "mcp.configPath": "@project-core/configs/mcp-master-unified.json",
  "mcp.enabled": true,
  "mcp.autoStart": true,
  "mcp.memoryIntegration": true
}
```

#### **4. Validação VSCode**
```bash
# Verificar integração Augment
python @project-core/automation/validate_mcp_configuration_enhanced.py --sync-check
```

### **CURSOR SETUP**

#### **1. Configuração MCP**
```bash
# Sincronizar configuração Cursor
python @project-core/automation/sync_mcp_configs.py --sync-cursor
```

#### **2. Configurações Específicas**
- **Composer Mode**: MCP integration habilitado
- **Chat Mode**: Sequential Thinking ativo
- **Frontend Focus**: UI/UX especialization
- **Cross-Environment**: Handoff com VSCode

#### **3. Validação Cursor**
```bash
# Verificar configuração Cursor
curl -X GET "http://localhost:3000/mcp/health" || echo "MCP servers starting..."
```

---

## 🔐 **CONFIGURAÇÃO DE SEGURANÇA**

### **Environment Variables Obrigatórias**
```bash
# .env file
ANTHROPIC_API_KEY=your_anthropic_key_here
OPENROUTER_API_KEY=your_openrouter_key_here
FIGMA_ACCESS_TOKEN=your_figma_token_here
TAVILY_API_KEY=your_tavily_key_here
UPSTASH_EMAIL=your_upstash_email_here
UPSTASH_API_KEY=your_upstash_key_here
```

### **Validação de Segurança**
```bash
# Verificar se não há secrets hardcoded
python @project-core/automation/validate_mcp_configuration_enhanced.py --comprehensive
```

### **Configuração GitHub (Opcional)**
```bash
# Para sync automático com GitHub
git config user.name "Seu Nome"
git config user.email "seu.email@exemplo.com"

# Configurar token GitHub (se necessário)
export GITHUB_TOKEN=your_github_token_here
```

---

## 🧠 **CONFIGURAÇÃO DE SERVIDORES MCP**

### **Servidores Principais**

#### **1. Sequential Thinking MCP**
- **Função**: Raciocínio avançado para tarefas complexas (≥7)
- **Comando**: `npx -y sequential-thinking-mcp`
- **Auto-ativação**: Complexidade ≥ 7

#### **2. MCP Shrimp Task Manager**
- **Função**: Coordenação de tarefas e workflows
- **Comando**: `npx -y mcp-shrimp-task-manager`
- **Integração**: Cross-environment (VSCode ↔ Cursor)

#### **3. Context7 MCP**
- **Função**: Documentação e exemplos de código
- **Comando**: `npx -y @smithery/cli@latest run @upstash/context7-mcp`
- **Chave**: Configurada automaticamente

#### **4. Playwright MCP**
- **Função**: Automação de browser e testes visuais
- **Comando**: `npx -y @playwright/mcp@latest mcp`
- **Configuração**: Browsers instalados automaticamente

### **Verificação de Servidores**
```bash
# Status de todos os servidores MCP
python @project-core/automation/validate_mcp_configuration_enhanced.py --quick-check
```

---

## 📊 **VALIDAÇÃO E TESTES**

### **Testes de Funcionalidade**

#### **1. Teste Básico**
```bash
# Validação rápida
python @project-core/automation/finaltest_unified.py --mode=simple
```

#### **2. Teste Completo**
```bash
# Validação comprehensive
python @project-core/automation/finaltest_unified.py --mode=comprehensive
```

#### **3. Teste de Memória**
```bash
# Validação do memory bank
python @project-core/automation/finaltest_unified.py --mode=memory
```

### **Testes de Integração**

#### **1. MCP Integration**
```bash
# Testar todos os servidores MCP
python @project-core/automation/validation_suite.py --type=integration
```

#### **2. Cross-Environment**
```bash
# Testar handoff VSCode ↔ Cursor
python @project-core/automation/validation_suite.py --type=sync
```

---

## 🛠️ **TROUBLESHOOTING**

### **Problemas Comuns**

#### **1. MCP Servers não iniciam**
```bash
# Solução: Reinstalar dependências
npm install -g sequential-thinking-mcp mcp-shrimp-task-manager

# Verificar configuração
python @project-core/automation/validate_mcp_configuration_enhanced.py --repair-mode
```

#### **2. Configuração fora de sincronia**
```bash
# Solução: Forçar re-sincronização
python @project-core/automation/sync_mcp_configs.py --sync-all
```

#### **3. API Keys inválidas**
```bash
# Solução: Verificar .env file
cat .env | grep -E "(API_KEY|TOKEN)" | head -5

# Testar conectividade
python @project-core/automation/finaltest_unified.py --mode=simple
```

#### **4. Dependências ausentes**
```bash
# Solução: Instalar dependências Python
pip install -r requirements.txt

# Verificar módulos
python -c "import json, pathlib, datetime; print('✅ Dependências OK')"
```

### **Logs de Diagnóstico**
```bash
# Verificar logs de sincronização
tail -f @project-core/logs/mcp_sync.log

# Verificar logs de validação
tail -f @project-core/logs/mcp_validation.log

# Verificar logs de automação
tail -f @project-core/logs/finaltest_unified.log
```

---

## 📈 **OTIMIZAÇÃO E PERFORMANCE**

### **Configurações Recomendadas**

#### **VS Code Settings**
```json
{
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/@project-core/logs/**": true,
    "**/@project-core/backups/**": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/@project-core/logs": true
  }
}
```

#### **Sistema de Cache**
```bash
# Limpar cache se necessário
rm -rf @project-core/logs/*.log
rm -rf @project-core/backups/old-*
```

### **Monitoramento Contínuo**
```bash
# Monitorar configurações MCP em tempo real
python @project-core/automation/sync_mcp_configs.py --monitor

# Monitorar saúde do sistema
python @project-core/automation/validation_suite.py --type=monitor --duration=300
```

---

## 🎯 **VERIFICAÇÃO FINAL**

### **Checklist de Setup Completo**
- [ ] ✅ Node.js ≥18.0.0 instalado
- [ ] ✅ Python ≥3.8 instalado
- [ ] ✅ Repositório clonado
- [ ] ✅ Environment variables configuradas
- [ ] ✅ MCP configurations sincronizadas
- [ ] ✅ VS Code/Augment configurado (se aplicável)
- [ ] ✅ Cursor configurado (se aplicável)
- [ ] ✅ Servidores MCP funcionando
- [ ] ✅ Testes de validação passando
- [ ] ✅ Logs sem erros críticos

### **Comando de Validação Final**
```bash
# Executar validação completa
python @project-core/automation/finaltest_unified.py --mode=comprehensive

# Resultado esperado: ✅ SUCCESS com 90%+ dos testes passando
```

---

## 📚 **RECURSOS ADICIONAIS**

### **Documentação Relacionada**
- `@project-core/configs/README.md` - Configurações MCP detalhadas
- `@project-core/automation/README.md` - Scripts de automação
- `@project-core/docs/migration_history.md` - Histórico de mudanças

### **Scripts Úteis**
- `sync_mcp_configs.py` - Sincronização de configurações
- `validate_mcp_configuration_enhanced.py` - Validação avançada
- `finaltest_unified.py` - Testes unificados
- `validation_suite.py` - Suite de validação

### **Suporte**
- **Issues**: GitHub Issues no repositório
- **Documentação**: `@project-core/docs/`
- **Logs**: `@project-core/logs/`

---

**🚀 VIBECODE SYSTEM V4.0 - SETUP UNIFICADO E OTIMIZADO**

*"Um setup para todos os ambientes, uma configuração para encontrá-los, uma validação para trazê-los todos e na unificação vinculá-los."*
