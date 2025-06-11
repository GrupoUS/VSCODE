# 🔄 TASKMASTER INITIALIZATION PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0 (CORRECTED)

## 🚨 PROTOCOLO DE INICIALIZAÇÃO OBRIGATÓRIO

Este protocolo DEVE ser executado APÓS a verificação de workspace para garantir que todos os sistemas MCP estejam funcionais e sincronizados.

---

## 🚀 SEQUÊNCIA CORRETA DE INICIALIZAÇÃO

### TASKMASTER INITIALIZATION (CORRECTED COMMANDS)

```bash
# Initialize Task Master
task-master init --yes

# Parse PRD and verify integrity
task-master parse-prd scripts/prd.txt --force

# List tasks
task-master list

# Identify next task
task-master next

# Generate task files
task-master generate
```

### DIRECTORY STRUCTURE REFERENCE

```
projeto/
├── .clinerules/              # Active Cline rules
│   ├── 01-memory-bank.md     # Persistent memory system
│   ├── 02-error-prevention.md # Recurring error prevention
│   ├── 03-context-90.md      # 90% context management
│   └── 04-confidence-check.md # Confidence verification
├── clinerules-bank/          # Inactive rules bank
│   ├── frameworks/           # Framework-specific rules
│   └── clients/              # Client/project rules
├── .clineignore              # Files ignored by Cline
├── cline_docs/               # Project documentation
│   ├── projectRoadmap.md     # Roadmap and objectives
│   ├── currentTask.md        # Detailed current task
│   ├── techStack.md          # Technology stack
│   └── codebaseSummary.md    # Codebase summary
└── workflows/                # Automated workflows
    ├── pr-review.md          # PR review
    └── feature-deploy.md     # Feature deployment
```

### CONTEXT VERIFICATION AND MEMORY

```markdown
## 🧠 CONTEXT ANALYSIS

### Context Verification and Memory

- Read @file:cline_docs/projectRoadmap.md
- Check @file:.clinerules/01-memory-bank.md
- Analyze @file:scripts/prd.txt
- Examine @folder:src/
- Review @docs/architecture.md
- Check @problems for VS Code errors/warnings
- Verify:
  @file:memory-bank/master_rule.md - Regras centrais do sistema

1. @file:project-core/README.md - Documentação central do projeto
2. @file:package.json - Configuração do projeto e dependências
3. @file:.clinerules/02-error-prevention.md - Protocolo de prevenção de erros
4. @file:.clinerules/03-context-90.md - Gestão de contexto
5. @file:.clinerules/04-confidence-check.md - Verificação de confiança
6. @file:memory-bank/self_correction_log.md - Histórico de correções e aprendizados
7. @file:project-core/rules/00-master-execution-protocol.md - Protocolo de execução principal
8. @file:.clinerules/rules/sequential-thinking-mcp.md – MCP Sequential Thinking
9. @file:.clinerules/05-taskmaster-sequential.md – Integração taskmaster ai + MCP Sequential Thinking
```

### CONFIDENCE CHECK (MANDATORY)

```markdown
### CONFIDENCE CHECK (MANDATORY)

- Evaluate confidence (0-10) in understanding the task
- If < 8: Ask clarifying questions
- If < 5: Request more context
- **RESPOND "ENTENDIDO!" only if confidence >= 8**

### Complexity Assessment (1-10)

- **1-3**: Simple tasks (single file changes)
- **4-6**: Moderate tasks (multiple files, single feature)
- **7-10**: Complex tasks (system-wide changes, multiple features)
```

---

## 🎯 FASE 2: VERIFICAÇÃO MCP SERVERS

### 2.1 TaskMaster + Sequential Thinking + GitLab Status Check

```bash
# Verificar status do TaskMaster
task-master list

# Listar tarefas pendentes
task-master list --status=pending

# Obter próxima tarefa sugerida
task-master next

# Verificar configuração MCP TaskMaster
cat .vscode/mcp.json | grep -A 10 "taskmaster"

# Verificar Sequential Thinking MCP
cat .vscode/mcp.json | grep -A 3 "sequentialthinking"

# Verificar GitLab MCP
cat .vscode/mcp.json | grep -A 10 "gitlab-mcp"

# Testar GitLab connectivity (se configurado)
# gitlab_mcp_test_connection

# Testar Sequential Thinking (se necessário)
# Use sequentialthinking tool para teste rápido
```

### 2.2 Playwright Integration Check

```bash
# Verificar Playwright
npm run automation:simple

# Testar integração
npm run integration:test

# Verificar configuração
cat playwright.config.ts
cat .env.playwright
```

### 2.3 Figma Integration Check

```bash
# Verificar Figma MCP
npm run figma:test

# Testar integração Playwright + Figma
npm run integration:figma-playwright

# Verificar configuração
cat .env.figma
```

### 2.4 Supabase Integration Check

```bash
# Verificar configuração Supabase
cat .vscode/mcp.json | grep -A 5 "supabase"

# Testar conexão (se aplicável)
# supabase status
```

---

## 📊 FASE 3: CONFIDENCE CHECK E ANÁLISE

### 3.1 Avaliação de Confiança (0-10)

```
Confidence Level: ___/10

Critérios:
- [ ] Entendi completamente a tarefa (2 pontos)
- [ ] Conheço o contexto do projeto (2 pontos)
- [ ] MCP servers estão funcionais (2 pontos)
- [ ] Tenho acesso a todas as ferramentas necessárias (2 pontos)
- [ ] Posso executar a tarefa sem ambiguidades (2 pontos)

REGRA: Se < 8, fazer perguntas clarificadoras
REGRA: Se < 5, solicitar mais contexto
```

### 3.2 Análise de Contexto Específico

```
@file:scripts/prd.txt          # Requisitos do projeto
@folder:src/                   # Código existente
@docs/architecture.md          # Arquitetura (se existir)
@problems                      # Erros VS Code ativos
@file:.taskmaster/docs/prd.txt # PRD TaskMaster (se existir)
```

---

## 🛠️ FASE 4: PREPARAÇÃO DO AMBIENTE

### 4.1 Verificar Dependências

```bash
# Node.js e npm
node --version
npm --version

# Verificar instalações globais necessárias
npm list -g task-master-ai
npm list -g figma-developer-mcp
npm list -g @executeautomation/playwright-mcp-server

# Verificar dependências locais
npm list @playwright/test
npm list playwright
npm list dotenv
```

### 4.2 Verificar Variáveis de Ambiente

```bash
# Verificar arquivos de ambiente
ls -la .env*

# Verificar configurações críticas (sem expor valores)
echo "FIGMA_API_KEY configured: $([ -n "$FIGMA_API_KEY" ] && echo "YES" || echo "NO")"
echo "ANTHROPIC_API_KEY configured: $([ -n "$ANTHROPIC_API_KEY" ] && echo "YES" || echo "NO")"
```

### 4.3 Verificar Estrutura de Diretórios

```bash
# Verificar estrutura esperada
ls -la automation/
ls -la figma-integration/
ls -la taskmaster-*/
ls -la memory-bank/
ls -la screenshots/
ls -la reports/
```

---

## 🎯 FASE 5: SINCRONIZAÇÃO COM TASKMASTER

### 5.1 Verificar Tarefas Ativas

```bash
# Obter status completo
task-master status

# Listar todas as tarefas por status
task-master list --status=todo
task-master list --status=in_progress
task-master list --status=completed

# Verificar próxima tarefa prioritária
task-master next
```

### 5.2 Sincronizar com PRD (se existir)

```bash
# Verificar se existe PRD
cat .taskmaster/docs/prd.txt

# Analisar e criar tarefas se necessário
task-master parse-prd
```

### 5.3 Criar Tarefa para Sessão Atual (se aplicável)

```bash
# Criar tarefa baseada na solicitação do usuário
task-master create "Implementar [DESCRIÇÃO_DA_TAREFA]" --type=development --priority=high
```

---

## 📋 FASE 6: RELATÓRIO DE STATUS

### 6.1 Gerar Relatório de Inicialização

```markdown
## 🚀 RELATÓRIO DE INICIALIZAÇÃO MCP

**Data/Hora**: [TIMESTAMP]
**Projeto**: [NOME_DO_PROJETO]
**Confidence Level**: [X/10]

### ✅ Status dos MCP Servers:

- [ ] TaskMaster: [FUNCIONANDO/ERRO]
- [ ] Sequential Thinking: [FUNCIONANDO/ERRO]
- [ ] GitLab MCP: [FUNCIONANDO/ERRO]
- [ ] Playwright: [FUNCIONANDO/ERRO]
- [ ] Figma: [FUNCIONANDO/ERRO]
- [ ] Supabase: [FUNCIONANDO/ERRO]

### 📊 TaskMaster Status:

- **Tarefas Pendentes**: [NÚMERO]
- **Próxima Tarefa**: [DESCRIÇÃO]
- **Prioridade**: [ALTA/MÉDIA/BAIXA]

### 🛠️ Ambiente:

- **Node.js**: [VERSÃO]
- **Dependências**: [OK/PROBLEMAS]
- **Variáveis de Ambiente**: [CONFIGURADAS/FALTANDO]

### 🎯 Próximos Passos:

1. [AÇÃO 1]
2. [AÇÃO 2]
3. [AÇÃO 3]

**Status Geral**: [PRONTO/NECESSITA_ATENÇÃO]
```

---

## ⚠️ TROUBLESHOOTING COMUM

### TaskMaster não responde:

```bash
# Verificar instalação
npm list -g task-master-ai

# Reinstalar se necessário
npm install -g task-master-ai

# Verificar configuração MCP
cat .vscode/mcp.json
```

### Playwright com problemas:

```bash
# Reinstalar browsers
npx playwright install

# Verificar configuração
cat playwright.config.ts
npm run automation:simple
```

### Figma MCP com erro:

```bash
# Verificar instalação
npm list -g figma-developer-mcp

# Verificar API key
cat .env.figma | grep FIGMA_API_KEY

# Testar conexão
npm run figma:test
```

### Problemas de dependências:

```bash
# Limpar cache e reinstalar
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

---

## 🔄 CHECKLIST DE INICIALIZAÇÃO

Antes de prosseguir com qualquer tarefa:

- [ ] **Memória carregada** (master_rule.md, guidelines)
- [ ] **Confidence >= 8/10**
- [ ] **TaskMaster funcionando**
- [ ] **Sequential Thinking funcionando**
- [ ] **GitLab MCP funcionando**
- [ ] **Playwright funcionando**
- [ ] **Figma MCP funcionando**
- [ ] **Variáveis de ambiente configuradas**
- [ ] **Dependências instaladas**
- [ ] **Estrutura de diretórios OK**
- [ ] **Próxima tarefa identificada**
- [ ] **Relatório de status gerado**

**APENAS prossiga se TODOS os itens estiverem ✅**

---

## 🎯 INTEGRAÇÃO COM WORKFLOW PRINCIPAL

Este protocolo se integra com o **master_rule.md** da seguinte forma:

1. **ANTES do Passo 1 (THINK)**: Execute este protocolo
2. **Durante o Passo 2 (PLAN)**: Use informações dos MCP servers
3. **Durante o Passo 3 (EXECUTE)**: Utilize MCP tools conforme necessário
4. **Durante o Passo 4 (LEARN)**: Atualize TaskMaster e memory bank

---

**LEMBRE-SE**: Este protocolo é OBRIGATÓRIO e deve ser executado SEMPRE no início de cada sessão para garantir máxima eficiência e qualidade no GRUPO US VIBECODE SYSTEM V2.0.

**"YARRR!" = Sistema MCP totalmente operacional e pronto para excelência!** 🚀
