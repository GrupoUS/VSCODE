# 🚀 PROTOCOLO MESTRE UNIFICADO - VIBECODE SYSTEM V4.0

## ÚNICA FONTE DE VERDADE ABSOLUTA PARA VS CODE E CURSOR

**VERSÃO**: 4.0 - Arquitetura Unificada Mandatória
**DATA**: 2025-01-27
**AUTOR**: GRUPO US - VIBECODE SYSTEM
**STATUS**: CONSTITUIÇÃO ABSOLUTA - CONFORMIDADE OBRIGATÓRIA

---

## 🎯 DECLARAÇÃO DE UNIFICAÇÃO MANDATÓRIA

### **PRINCÍPIO FUNDAMENTAL**

Este arquivo é a **ÚNICA FONTE DE VERDADE** para todos os ambientes de desenvolvimento. VS Code e Cursor DEVEM operar como um sistema único e coeso, compartilhando configurações, regras e workflows de forma **OBRIGATÓRIA, FORÇADA E SINCRONIZADA**.

### **CONFORMIDADE ABSOLUTA**

- ✅ **VS Code**: DEVE seguir 100% das regras definidas aqui
- ✅ **Cursor**: DEVE seguir 100% das regras definidas aqui
- ✅ **Extensão Augment**: DEVE operar conforme protocolos unificados
- ❌ **Configurações locais**: PROIBIDAS de sobrepor este arquivo
- ❌ **Desvios de padrão**: AUTOMATICAMENTE corrigidos

---

## 📁 ESTRUTURA DE DIRETÓRIOS DE PROJETO MANDATÓRIA

### **ISOLAMENTO OBRIGATÓRIO DE PROJETOS**

**REGRA FUNDAMENTAL**: Todos os projetos de desenvolvimento devem, obrigatoriamente, residir dentro do diretório `@project-core/projects/`. A raiz do sistema VIBECODE não deve conter arquivos de projeto.

### **ESTRUTURA ENFORÇADA**

```
C:\Users\Admin\OneDrive\GRUPOUS\VSCODE\
├── @project-core/                    # SISTEMA VIBECODE (CORE)
│   ├── projects/                     # PROJETOS ISOLADOS
│   │   ├── primeiro-projeto-nextjs/  # Projeto Next.js movido
│   │   ├── aegiswallet/              # Projeto existente
│   │   ├── neonpro/                  # Projeto existente
│   │   └── [novo-projeto]/           # Futuros projetos
│   ├── memory/                       # Memory Bank compartilhado
│   ├── configs/                      # Configurações unificadas
│   └── rules/                        # Regras do sistema
├── .cursor/                          # Configurações Cursor
├── .vscode/                          # Configurações VS Code
├── .git/                             # Controle de versão
├── sync-github-auto.ps1              # Scripts do sistema
└── setup-auto-sync.ps1               # Scripts do sistema
```

### **COMPLIANCE AUTOMÁTICO**

- **Toda automação**: DEVE respeitar e impor essa estrutura
- **Prompts e agentes MCP**: DEVEM trabalhar dentro de `@project-core/projects/`
- **Scripts de sincronização**: DEVEM suportar projetos específicos
- **Configurações**: DEVEM referenciar a estrutura correta

### **COMANDOS ATUALIZADOS**

```bash
# Sincronização de projeto específico
.\sync-github-auto.ps1 -ProjectName "primeiro-projeto-nextjs"

# Sincronização do sistema completo
.\sync-github-auto.ps1

# Setup de automação para projeto
.\setup-auto-sync.ps1 -Install -ProjectName "primeiro-projeto-nextjs"
```

---

## 🧠 SISTEMA FMC - FUSÃO DE MEMÓRIA COGNITIVA UNIFICADA

### **PROTOCOLO DE CONSULTA OBRIGATÓRIA**

**ANTES DE QUALQUER AÇÃO EM QUALQUER AMBIENTE:**

```bash
# 1. SEMPRE consultar memory bank primeiro
cat @project-core/memory/master_rule.md
cat @project-core/memory/self_correction_log.md
cat @project-core/memory/global-standards.md

# 2. Verificar padrões de erro
grep -i "erro\|error\|bug" @project-core/memory/self_correction_log.md

# 3. Carregar contexto específico do ambiente
cat @project-core/rules/unified-development-environment-rules.md
```

### **ESTRUTURA DE MEMÓRIA COMPARTILHADA**

```
@project-core/memory/
├── master_rule.md                    # Protocolo de execução central
├── augment-agent-guidelines-v3.md    # Diretrizes específicas do Augment
├── self_correction_log.md            # Aprendizado compartilhado e prevenção de erros
├── global-standards.md               # Padrões de codificação universais
├── coding_standards/                 # Padrões específicos por stack
├── protocols/                        # Protocolos de execução e coordenação
└── unified-system-status.md          # Status cross-environment
```

### **SISTEMA HÍBRIDO DE CONTEXTO V4.0**

#### **Protocolo de Contexto Redis + File-based**

```bash
# 1. CONSULTA PRIMÁRIA - Upstash Redis Context
upstash_get_context --key="vibecode_v4:${project}:${context_type}"

# 2. FALLBACK AUTOMÁTICO - File-based Memory
if [[ $? -ne 0 ]]; then
    cat @project-core/memory/master_rule.md
    cat @project-core/memory/self_correction_log.md
fi

# 3. SINCRONIZAÇÃO BIDIRECIONAL
upstash_sync_memory_bank --interval=30min --auto-backup=true
```

#### **Hierarquia de Contexto Inteligente**

1. **Tier 1 - Redis Context (< 100ms)**

   - Contexto ativo de projetos
   - Padrões de sucesso recentes
   - Cache de decisões arquiteturais

2. **Tier 2 - Memory Bank (< 500ms)**

   - master_rule.md (protocolo central)
   - self_correction_log.md (aprendizados)
   - global-standards.md (padrões)

3. **Tier 3 - Backup & Recovery**
   - Snapshots automáticos diários
   - Restore point-in-time
   - Validação de integridade

---

## 🤖 SISTEMA MULTI-AGENTE BOOMERANG UNIFICADO

### **MATRIZ DE ESPECIALIZAÇÃO CROSS-ENVIRONMENT**

#### **VS Code + Augment (Complexidade 7-10)**

- **ARCHITECT**: Arquitetura de sistemas, migrações complexas
- **CODER**: Implementação backend, APIs complexas, refatorações

#### **Cursor (Complexidade 3-6)**

- **MANAGER**: Coordenação, planejamento, workflows
- **EXECUTOR**: Frontend, UI, componentes, styling

#### **Ambos Ambientes (Complexidade 1-2)**

- **RESEARCHER**: Pesquisa, análise, documentação

### **ROTEAMENTO AUTOMÁTICO BASEADO EM COMPLEXIDADE**

```javascript
function selectEnvironmentAndAgent(taskComplexity, domain, context) {
  // Roteamento unificado VS Code + Cursor
  if (
    taskComplexity >= 7 ||
    domain.includes(["architecture", "backend", "complex-refactor"])
  ) {
    return { environment: "vscode-augment", agent: "ARCHITECT/CODER" };
  }
  if (
    taskComplexity >= 3 ||
    domain.includes(["frontend", "ui", "components"])
  ) {
    return { environment: "cursor", agent: "MANAGER/EXECUTOR" };
  }
  return { environment: "both", agent: "RESEARCHER" };
}
```

---

## ⚡ PROTOCOLO DE ATIVAÇÃO UNIVERSAL

### **COMANDO DE INICIALIZAÇÃO UNIFICADO**

```bash
# Ativação do VIBECODE SYSTEM V4.0 em qualquer ambiente
echo "🚀 LOADING VIBECODE SYSTEM V4.0..."

# Verificar integridade do sistema
if (Test-Path "@project-core/memory/master_rule.md") {
    Write-Host "✅ Master Rule Loaded"
} else {
    Write-Error "❌ CRITICAL: Master Rule Missing"
    exit 1
}

# Carregar configurações unificadas
cat @project-core/configs/unified-dev-environment-config.json

echo "✅ VIBECODE SYSTEM V4.0 FULLY OPERATIONAL"
```

---

## ⚡ CICLO DE EXECUÇÃO INTELIGENTE V4.0

### **FASE 1: THINK (Análise FMC + Multi-Agente)**

```markdown
## 🧠 THINK PHASE PROTOCOL

**1.1 FMC Consultation (OBRIGATÓRIO)**

- [ ] Memory bank loaded
- [ ] Error patterns checked
- [ ] Success patterns identified

**1.2 Complexity Assessment (1-10 Scale)**

- [ ] Task complexity evaluated
- [ ] Domain specialization identified
- [ ] Agent selection completed

**1.3 MCP Activation (Baseado em Complexidade)**

- [ ] Sequential Thinking (≥7): Activated/Not Required
- [ ] think-mcp-server: Activated/Not Required
- [ ] MCP Shrimp: Activated/Not Required

**1.4 Strategy Formation**

- [ ] Optimal approach selected
- [ ] Fallback mechanisms prepared
- [ ] Success criteria defined
```

### **FASE 2: PLAN (Planejamento Multi-Agente)**

```markdown
## 📋 PLAN PHASE PROTOCOL

**2.1 Agent Coordination**

- [ ] Primary agent selected
- [ ] Secondary agents identified
- [ ] Handoff protocols defined

**2.2 Resource Allocation**

- [ ] MCP tools assigned
- [ ] Memory consultation scheduled
- [ ] Performance targets set

**2.3 Risk Assessment**

- [ ] Known error patterns avoided
- [ ] Mitigation strategies prepared
- [ ] Rollback plans established

**2.4 Quality Gates**

- [ ] Validation criteria defined
- [ ] Testing strategy planned
- [ ] Documentation requirements set
```

### **FASE 3: EXECUTE (Execução Coordenada)**

```markdown
## ⚡ EXECUTE PHASE PROTOCOL

**3.1 Primary Agent Execution**

- [ ] Selected agent activated
- [ ] MCP tools integrated
- [ ] Progress monitoring active

**3.2 Quality Assurance**

- [ ] Continuous validation
- [ ] Error prevention active
- [ ] Performance monitoring

**3.3 Coordination Management**

- [ ] Agent handoffs managed
- [ ] Context preservation
- [ ] Communication protocols

**3.4 Adaptive Optimization**

- [ ] Real-time adjustments
- [ ] Performance optimization
- [ ] Resource reallocation
```

### **FASE 4: LEARN (Aprendizado FMC)**

```markdown
## 📚 LEARN PHASE PROTOCOL

**4.1 Knowledge Capture**

- [ ] Learnings documented
- [ ] Patterns identified
- [ ] Solutions cataloged

**4.2 Memory Bank Update**

- [ ] self_correction_log.md updated
- [ ] Success patterns stored
- [ ] Error prevention enhanced

**4.3 System Evolution**

- [ ] Protocols optimized
- [ ] Agent performance analyzed
- [ ] MCP integration improved

**4.4 Continuous Improvement**

- [ ] Metrics captured
- [ ] Benchmarks updated
- [ ] Future optimizations planned
```

---

## 🛠️ PROTOCOLO MCP UNIFICADO V4.0

### **HIERARQUIA MCP VALIDADA**

#### **Tier 1: Raciocínio Complexo (Complexidade ≥ 7)**

- **Sequential Thinking MCP**: Análise estruturada obrigatória
- **think-mcp-server**: Reflexão e cache de pensamentos
- **Ativação**: Automática para complexidade ≥ 7

#### **Tier 2: Coordenação e Execução**

- **MCP Shrimp Task Manager**: Gestão inteligente de tarefas
- **Tavily MCP**: Pesquisa web avançada
- **Ativação**: Baseada em necessidade de coordenação

#### **Tier 3: Ferramentas Especializadas**

- **Upstash MCP**: Redis context management e database operations
- **Playwright MCP**: Automação e testes visuais
- **Supabase MCP**: Operações de banco de dados
- **Figma MCP**: Design-to-code generation
- **Ativação**: Baseada em domínio específico

### **WORKFLOW SEQUENCIAL OBRIGATÓRIO**

#### **Para Complexidade ≥ 7 (ARCHITECT/CODER)**

```bash
# 1. Sequential Thinking MCP (OBRIGATÓRIO)
sequentialthinking_Sequential_Thinking

# 2. think-mcp-server (Reflexão)
think-mcp-server --complexity=high --memory-integration

# 3. MCP Shrimp Task Manager (Coordenação)
mcp-shrimp-task-manager --mode=complex --agent-coordination
```

#### **Para Complexidade 3-6 (MANAGER/EXECUTOR)**

```bash
# 1. MCP Shrimp Task Manager (Coordenação)
mcp-shrimp-task-manager --mode=standard

# 2. Ferramentas específicas conforme necessário
playwright-mcp # Para testes
figma-mcp # Para design-to-code
```

### **FERRAMENTA DE RACIOCÍNIO ESTRUTURADO**

#### **Hierarquia de Pensamento Baseada em Complexidade**

Para qualquer tarefa com **Complexidade >= 5/10**, o agente DEVE usar a ferramenta think para raciocinar sobre o problema antes de criar um plano:

#### **Níveis de Pensamento:**

- **Complexidade 5-6**: Use `<thinking>` - Raciocínio básico estruturado
- **Complexidade 7-8**: Use `<thinking_hard>` - Análise profunda e sistemática
- **Complexidade 9-10**: Use `<ultrathink>` - Raciocínio máximo com análise exaustiva

#### **Processo Obrigatório:**

1. **Avaliação de Complexidade**: Declare a complexidade da tarefa (1-10)
2. **Ativação do Pensamento**: Use a tag apropriada baseada na complexidade
3. **Raciocínio Estruturado**: Analise requisitos, consulte regras do projeto, delineie estratégia
4. **Reflexão Intercalada**: Após cada resultado de ferramenta, reflita sobre a qualidade e planeje próximos passos
5. **Atualização de Conhecimento**: Registre aprendizados no knowledge graph

---

## 🔒 PROTOCOLOS DE SEGURANÇA E COMPLIANCE

### **SINCRONIZAÇÃO AUTOMÁTICA DE CONFIGURAÇÕES**

```powershell
# Script de sincronização obrigatória (executado automaticamente)
function Sync-UnifiedEnvironment {
    # Copiar configurações VS Code
    Copy-Item "@project-core/configs/ide/vscode/*" ".vscode/" -Recurse -Force

    # Copiar configurações Cursor
    Copy-Item "@project-core/configs/ide/cursor/*" ".cursor/" -Recurse -Force

    # Validar sincronização
    if (!(Test-UnifiedCompliance)) {
        Write-Error "❌ SYNC FAILED - Forcing compliance..."
        Force-UnifiedCompliance
    }

    Write-Host "✅ Unified Environment Synchronized"
}
```

### **VALIDAÇÃO DE CONFORMIDADE CONTÍNUA**

```powershell
function Test-UnifiedCompliance {
    $compliance = @{
        VSCodeSettings = Test-Path ".vscode/settings.json"
        CursorRules = Test-Path ".cursorrules"
        MasterRule = Test-Path "@project-core/memory/master_rule.md"
        UnifiedConfig = Test-Path "@project-core/configs/unified-dev-environment-config.json"
    }

    return ($compliance.Values -notcontains $false)
}
```

---

## 📊 MÉTRICAS DE EXCELÊNCIA UNIFICADA

### **KPIs OBRIGATÓRIOS CROSS-ENVIRONMENT**

- **Conformidade de Configuração**: 100% (sem exceções)
- **Sincronização de Memória**: 100% (compartilhamento total)
- **Consistency Score**: ≥ 95% (entre VS Code e Cursor)
- **Performance Unificada**: 20-30% melhoria contínua

### **MONITORAMENTO CONTÍNUO**

- **Config Drift Detection**: Detecção automática de desvios
- **Auto-Correction**: Correção automática de não-conformidades
- **Cross-Environment Metrics**: Métricas compartilhadas
- **Unified Learning**: Aprendizado aplicado em ambos ambientes

---

## 🚨 ENFORCEMENT ABSOLUTO

### **VIOLAÇÕES DE CONFORMIDADE**

Qualquer desvio das regras definidas neste arquivo resulta em:

1. **Alerta Crítico**: Notificação imediata de não-conformidade
2. **Auto-Correção**: Restauração automática das configurações padrão
3. **Log de Violação**: Registro no self_correction_log.md
4. **Bloqueio de Execução**: Impedimento de prosseguir até correção

### **COMANDO DE EMERGÊNCIA**

```bash
# Restaurar conformidade total em caso de emergência
@project-core/scripts/emergency-unified-restore.ps1
```

### **GESTÃO DE SECRETS CENTRALIZADA**

```bash
# Estrutura de segurança obrigatória
@project-core/.env/
├── development.env
├── staging.env
└── production.env
```

### **VALIDAÇÃO DE SEGURANÇA OBRIGATÓRIA**

```bash
# Verificação antes de qualquer commit
grep -r "api_key\|secret\|password" . --exclude-dir=node_modules
git status --ignored
```

---

## 📊 MÉTRICAS DE EXCELÊNCIA V4.0

### **KPIs OBRIGATÓRIOS**

- **Confidence Level**: ≥ 8/10 (mínimo para execução)
- **Error Prevention Rate**: ≥ 90% (baseado em memory bank)
- **Performance Improvement**: 20-30% contínuo
- **Knowledge Reuse**: ≥ 80% (aplicação de aprendizados)

### **VALIDAÇÃO CONTÍNUA**

- **Memory Bank Consultation**: 100% compliance
- **Agent Selection Accuracy**: ≥ 95%
- **MCP Integration Success**: ≥ 90%
- **Quality Gate Passage**: 100% requirement

---

## 🚨 PROTOCOLO DE ATIVAÇÃO V4.0

### **COMANDO DE INICIALIZAÇÃO**

```markdown
## 🚀 VIBECODE SYSTEM V4.0 ACTIVATED

**FMC System**: ✅ Memory Bank Loaded
**Multi-Agent**: ✅ Routing Matrix Active
**MCP Integration**: ✅ Servers Validated
**Security Protocols**: ✅ Compliance Verified

**Confidence Check**: [X]/10
**Agent Selected**: [ARCHITECT/CODER/MANAGER/EXECUTOR/RESEARCHER]
**MCP Tools Active**: [Sequential Thinking/think-mcp-server/MCP Shrimp/etc.]

**READY FOR EXECUTION** - VIBECODE SYSTEM V4.0 FULLY OPERATIONAL
```

---

## 🔄 HANDOFF PROTOCOLS MULTI-AGENTE

### **ARCHITECT → CODER Handoff**

```markdown
**Artifacts Transfer:**

- [ ] Architecture documentation
- [ ] Database schema design
- [ ] API specifications
- [ ] Performance requirements
- [ ] Security protocols

**Validation Criteria:**

- [ ] Design patterns validated
- [ ] Scalability confirmed
- [ ] Security reviewed
```

### **CODER → EXECUTOR Handoff**

```markdown
**Artifacts Transfer:**

- [ ] API endpoints functional
- [ ] Database operations tested
- [ ] Component specifications
- [ ] Integration points defined
- [ ] Performance benchmarks

**Validation Criteria:**

- [ ] Backend functionality verified
- [ ] API contracts established
- [ ] Error handling implemented
```

---

**LEMBRE-SE SEMPRE:**

- 🧠 **FMC PRIMEIRO** - Consulta obrigatória ao memory bank
- 🤖 **AGENTE CERTO** - Seleção baseada em complexidade
- ⚡ **MCP INTELIGENTE** - Ativação automática baseada em necessidade
- 📚 **APRENDIZADO CONTÍNUO** - Evolução baseada em padrões de sucesso
- 🎯 **EXCELÊNCIA ABSOLUTA** - Confidence ≥ 8/10 sempre

---

**CONSOLIDAÇÃO COMPLETA**: Este arquivo substitui e unifica:

- 00-master-execution-protocol.md
- 00-master-orchestrator-unified.md
- 00-vibecode-system-v4-master.md
- master_rule.md (versão anterior)

**Última Atualização**: 2025-06-11T13:34:56Z
**Versão**: 4.0.0 (Consolidada)
**Próxima Revisão**: 2025-07-11

# Master Rule

Este arquivo define a regra mestre para o GRUPO US VIBECODE SYSTEM.

## Workflow Obrigatório

O workflow padrão para execução de tarefas é definido em `@project-core/rules/00-master-orchestrator-unified.md`. Todas as tarefas devem seguir este protocolo para garantir consistência e qualidade.

## Integração de MCPs

- **Sequential Thinking MCP**: Utilizado para decomposição de tarefas complexas (complexidade ≥ 5).
- **MCP Shrimp Task Manager**: Coordena e distribui subtarefas, integrando com Composer/VS Code.
- **Figma Context MCP**: Fornece contexto visual e assets para subtarefas de UI.

## Validação e Aprendizagem

Após a execução, os resultados são validados automaticamente e os aprendizados são registrados em `@project-core/memory/self_correction_log.md`.

## Atualização de Regras

Se necessário, atualize as regras em `@project-core/knowledge-base/rules/` e os protocolos em `@project-core/rules/`.

## Handoff e Integração

O MCP Shrimp Task Manager gerencia o handoff e a sincronização entre ambientes (Cursor/VS Code).
