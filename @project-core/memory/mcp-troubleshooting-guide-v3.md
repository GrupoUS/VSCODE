# 🔧 GUIA DE TROUBLESHOOTING MCP - GRUPO US VIBECODE V3.0

**Data**: 2025-01-09  
**Versão**: 3.0  
**Status**: ✅ ATIVO  

---

## 🚨 PROBLEMAS COMUNS E SOLUÇÕES

### **1. Sequential Thinking (Original)**

#### **Problema**: Servidor não responde
```bash
# Diagnóstico
npx -y @modelcontextprotocol/server-sequential-thinking --help

# Sintomas
- Timeout na conexão
- Erro "command not found"
- Processo não inicia
```

#### **Soluções**:
```bash
# 1. Reinstalar pacote
npm uninstall -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-sequential-thinking

# 2. Limpar cache npm
npm cache clean --force

# 3. Verificar Node.js
node --version  # Deve ser >= 18
npm --version   # Deve ser >= 9
```

#### **Configuração Correta**:
```json
{
  "mcp": {
    "servers": {
      "sequentialthinking": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
      }
    }
  }
}
```

---

### **2. Sequential Thinking Tools**

#### **Problema**: Ferramentas não são recomendadas
```bash
# Diagnóstico
npx -y mcp-sequentialthinking-tools --help

# Sintomas
- Recomendações vazias
- Confidence scores sempre 0
- Erro na análise de ferramentas
```

#### **Soluções**:
```bash
# 1. Verificar instalação
npm list -g mcp-sequentialthinking-tools

# 2. Atualizar para versão mais recente
npm update -g mcp-sequentialthinking-tools

# 3. Verificar dependências
npm audit --fix
```

#### **Configuração Correta**:
```json
{
  "mcp": {
    "servers": {
      "sequentialthinking-tools": {
        "command": "npx",
        "args": ["-y", "mcp-sequentialthinking-tools"]
      }
    }
  }
}
```

---

### **3. TaskMaster AI**

#### **Problema**: Warning sobre client capabilities
```bash
# Sintomas
[FastMCP warning] could not infer client capabilities

# Causa
- API keys não configuradas corretamente
- Configuração de ambiente incompleta
```

#### **Soluções**:
```bash
# 1. Verificar API keys
echo $ANTHROPIC_API_KEY
echo $OPENROUTER_API_KEY

# 2. Configurar variáveis de ambiente
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENROUTER_API_KEY="sk-or-v1-..."

# 3. Verificar configuração MCP
cat @project-core/configs/mcp-master-unified.json
```

#### **Configuração Completa**:
```json
{
  "mcpServers": {
    "taskmaster-ai": {
      "command": "npx",
      "args": ["-y", "--package=task-master-ai", "task-master-ai"],
      "env": {
        "ANTHROPIC_API_KEY": "sk-ant-...",
        "OPENROUTER_API_KEY": "sk-or-v1-...",
        "PERPLEXITY_API_KEY": "pplx-..."
      }
    }
  }
}
```

#### **Comandos de Diagnóstico**:
```bash
# Verificar instalação
npm list -g task-master-ai

# Testar comando básico
task-master --version

# Verificar configuração
task-master models --setup
```

---

### **4. Shrimp Task Manager**

#### **Problema**: Não conecta via Smithery
```bash
# Sintomas
- Erro de autenticação
- Profile não encontrado
- Timeout na conexão
```

#### **Soluções**:
```bash
# 1. Verificar Smithery
npx @smithery/cli@latest --version

# 2. Reinstalar via Smithery
npx -y @smithery/cli install @cjo4m06/mcp-shrimp-task-manager --client claude

# 3. Verificar credenciais
npx @smithery/cli@latest run @cjo4m06/mcp-shrimp-task-manager \
  --key 13fee89a-5427-41f8-8054-41d37e75e33b \
  --profile grieving-ostrich-Ljavzk --help
```

#### **Configuração Alternativa (Manual)**:
```json
{
  "mcp": {
    "servers": {
      "shrimp-task-manager": {
        "command": "npx",
        "args": ["-y", "mcp-shrimp-task-manager"],
        "env": {
          "DATA_DIR": "/absolute/path/to/project/data",
          "ENABLE_THOUGHT_CHAIN": "true",
          "TEMPLATES_USE": "en",
          "ENABLE_GUI": "false"
        }
      }
    }
  }
}
```

---

## 🔍 DIAGNÓSTICO SISTEMÁTICO

### **Script de Diagnóstico Automático**:
```bash
#!/bin/bash
# mcp-diagnostic.sh

echo "🔍 DIAGNÓSTICO MCP - GRUPO US VIBECODE V3.0"
echo "============================================"

# 1. Verificar Node.js
echo "📦 Node.js Version:"
node --version
npm --version

# 2. Testar Sequential Thinking
echo "🧠 Sequential Thinking:"
timeout 10s npx -y @modelcontextprotocol/server-sequential-thinking --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Sequential Thinking: OK"
else
    echo "❌ Sequential Thinking: ERRO"
fi

# 3. Testar Sequential Thinking Tools
echo "🛠️ Sequential Thinking Tools:"
timeout 10s npx -y mcp-sequentialthinking-tools --help > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Sequential Thinking Tools: OK"
else
    echo "❌ Sequential Thinking Tools: ERRO"
fi

# 4. Testar TaskMaster
echo "📋 TaskMaster AI:"
timeout 10s npx -y task-master-ai --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ TaskMaster AI: OK"
else
    echo "❌ TaskMaster AI: ERRO"
fi

# 5. Testar Smithery
echo "🦐 Smithery CLI:"
timeout 10s npx @smithery/cli@latest --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Smithery CLI: OK"
else
    echo "❌ Smithery CLI: ERRO"
fi

echo "============================================"
echo "✅ Diagnóstico concluído!"
```

---

## 🛠️ FERRAMENTAS DE MANUTENÇÃO

### **Limpeza de Cache**:
```bash
# Limpar cache npm
npm cache clean --force

# Limpar cache de pacotes globais
npm list -g --depth=0 | grep mcp | awk '{print $2}' | xargs npm uninstall -g

# Reinstalar pacotes MCP
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g mcp-sequentialthinking-tools
npm install -g task-master-ai
```

### **Reset Completo**:
```bash
# 1. Backup de configurações
cp User/settings.json User/settings.json.backup
cp @project-core/configs/mcp-master-unified.json @project-core/configs/mcp-master-unified.json.backup

# 2. Remover todas as configurações MCP
# (Editar manualmente os arquivos)

# 3. Reinstalar do zero
npm cache clean --force
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g mcp-sequentialthinking-tools
npm install -g task-master-ai
npx -y @smithery/cli install @cjo4m06/mcp-shrimp-task-manager --client claude

# 4. Reconfigurar
# (Aplicar configurações do backup)
```

---

## 📊 MONITORAMENTO DE SAÚDE

### **Métricas de Saúde por Servidor**:

| Servidor | Status Check | Response Time | Success Rate |
|----------|--------------|---------------|--------------|
| Sequential Thinking | `npx -y @modelcontextprotocol/server-sequential-thinking --help` | < 5s | > 95% |
| Sequential Thinking Tools | `npx -y mcp-sequentialthinking-tools --help` | < 5s | > 92% |
| TaskMaster AI | `npx -y task-master-ai --version` | < 10s | > 88% |
| Shrimp Task Manager | `npx @smithery/cli@latest --version` | < 5s | > 90% |

### **Script de Monitoramento**:
```bash
#!/bin/bash
# mcp-health-check.sh

LOGFILE="@project-core/logs/mcp-health-$(date +%Y%m%d).log"

echo "$(date): Iniciando health check MCP" >> $LOGFILE

# Função para testar servidor
test_server() {
    local name=$1
    local command=$2
    local timeout=$3
    
    echo "Testando $name..." >> $LOGFILE
    timeout $timeout $command > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "$(date): ✅ $name: OK" >> $LOGFILE
        return 0
    else
        echo "$(date): ❌ $name: ERRO" >> $LOGFILE
        return 1
    fi
}

# Executar testes
test_server "Sequential Thinking" "npx -y @modelcontextprotocol/server-sequential-thinking --help" "10s"
test_server "Sequential Thinking Tools" "npx -y mcp-sequentialthinking-tools --help" "10s"
test_server "TaskMaster AI" "npx -y task-master-ai --version" "15s"
test_server "Smithery CLI" "npx @smithery/cli@latest --version" "10s"

echo "$(date): Health check concluído" >> $LOGFILE
```

---

## 🚀 OTIMIZAÇÕES DE PERFORMANCE

### **Configurações Otimizadas**:
```json
{
  "mcp": {
    "servers": {
      "sequentialthinking": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
        "timeout": 30000,
        "retries": 3
      },
      "sequentialthinking-tools": {
        "command": "npx",
        "args": ["-y", "mcp-sequentialthinking-tools"],
        "timeout": 45000,
        "retries": 2
      }
    }
  }
}
```

### **Cache de Pacotes**:
```bash
# Pré-instalar pacotes para melhor performance
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g mcp-sequentialthinking-tools
npm install -g task-master-ai

# Verificar cache
npm cache verify
```

---

## ✅ CHECKLIST DE RESOLUÇÃO

### **Para Qualquer Problema MCP**:
- [ ] Verificar Node.js >= 18
- [ ] Limpar cache npm
- [ ] Reinstalar pacote específico
- [ ] Verificar configuração JSON
- [ ] Testar comando básico
- [ ] Verificar logs de erro
- [ ] Aplicar configuração otimizada
- [ ] Documentar solução no memory bank

---

**Status**: ✅ GUIA ATIVO E VALIDADO  
**Última atualização**: 2025-01-09  
**Próxima revisão**: 2025-02-09  
**Responsável**: AUGMENT AGENT V3.0
