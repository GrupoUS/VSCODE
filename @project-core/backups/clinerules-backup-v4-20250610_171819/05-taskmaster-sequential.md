# .clinerules/05-taskmaster-sequential.md

## REGRA: USO INTELIGENTE DO TASKMASTER + SEQUENTIAL THINKING V2.0

### 🎯 SMART TRIGGER - QUANDO USAR SEQUENTIAL THINKING AUTOMATICAMENTE:

#### **Critérios Primários (Score ≥ 60%):**

1. **Palavras-chave de alta complexidade**: "arquitetar", "architect", "design", "planejar", "analisar", "complexo", "integração", "refatorar", "migração"
2. **Escopo amplo**: Tasks com >3 componentes, >2 fases, confidence <7, primeira implementação
3. **Dependências complexas**: >2 dependências, dependências externas, múltiplos sistemas afetados, impacto arquitetural
4. **Padrões históricos**: Operações que historicamente requerem Sequential Thinking

#### **Sistema de Scoring Inteligente:**

- **Keyword Complexity**: 0-10 pontos (alta=3pts, média=1pt)
- **Scope Complexity**: 0-10 pontos (componentes, fases, confidence, primeira vez)
- **Dependency Complexity**: 0-10 pontos (quantidade, tipo, impacto)
- **Historical Patterns**: 0-10 pontos (baseado em histórico)
- **Threshold**: ≥60% = usar Sequential Thinking automaticamente

### 🚀 WORKFLOW OTIMIZADO V2.0:

#### **Fase 1: Análise Automática de Complexidade**

```javascript
// Smart Trigger executa automaticamente
const decision = await coordinator.decideSystem(operation, context);
// Retorna: system, confidence, reasoning, estimatedStages
```

#### **Fase 2: Execução com Cache Inteligente**

```javascript
// Cache automático para otimização
const result = await sequentialAdapter.executeSequentialThinking(params);
// Cache: thoughts (24h), plans (12h), invalidação automática
```

#### **Fase 3: Geração de Plano Estruturado**

```javascript
// Converte análise em plano TaskMaster-ready
const plan = await sequentialAdapter.generateTaskMasterPlan(analysis, context);
// Formato: tasks, dependencies, risks, recommendations
```

#### **Fase 4: Monitoramento e Métricas**

```javascript
// Métricas automáticas de performance
const metrics = sequentialAdapter.getMetrics();
// Tracking: cacheHitRate, avgResponseTime, tokensSaved
```

### 📊 CACHE STRATEGY V2.0:

#### **Configurações Inteligentes:**

- **Thoughts Cache**: 24h TTL, 100 entradas máx
- **Plans Cache**: 12h TTL, 100 entradas máx
- **Invalidação**: Automática ao modificar tasks
- **Limpeza**: Remove 20% dos mais antigos quando limite atingido
- **Chave**: Hash MD5 do conteúdo para deduplicação

#### **Otimizações de Performance:**

- **Cache Hit Rate**: Monitoramento contínuo
- **Similarity Detection**: Reutilização entre tasks similares
- **Token Savings**: Tracking de economia de API calls
- **Response Time**: Métricas de latência

### 🔧 COMANDOS OFICIAIS TASKMASTER:

#### **Comandos Base (Oficiais):**

```bash
# Inicialização do projeto
task-master init

# Parse de PRD e geração de tasks
task-master parse-prd scripts/prd.txt

# Listar todas as tasks
task-master list

# Mostrar próxima task
task-master next

# Gerar arquivos de task
task-master generate
```

#### **Integração via Chat (MCP):**

```bash
# Via chat do editor (Cursor/Windsurf/VS Code)
"Initialize taskmaster-ai in my project"
"Parse my PRD at scripts/prd.txt"
"What's the next task I should work on?"
"Can you help me implement task 3?"
"Can you help me expand task 4?"
```

#### **Comandos Híbridos (Via Coordinator):**

```javascript
// Via código JavaScript - Coordinator
await coordinator.executeHybridCommand("analyze-and-plan", params);
await coordinator.executeHybridCommand("smart-next-task", params);
await coordinator.executeHybridCommand("expand-with-thinking", params);
await coordinator.executeHybridCommand("validate-solution", params);
```

### 📈 MÉTRICAS DE SUCESSO:

#### **KPIs Automáticos:**

- **Cache Hit Rate**: >70% (target)
- **Avg Response Time**: <2s (target)
- **Complexity Detection Accuracy**: >85% (target)
- **Token Savings**: >30% vs sem cache (target)

#### **Indicadores de Qualidade:**

- **Plan Completeness**: Tasks bem estruturadas
- **Dependency Accuracy**: Dependências corretas
- **Risk Identification**: Riscos relevantes identificados
- **Recommendation Quality**: Sugestões acionáveis

### ⚡ FALLBACK E RESILIÊNCIA:

#### **Tratamento de Erros:**

- **Sequential Thinking falha**: Fallback para TaskMaster padrão
- **Cache corrompido**: Limpeza automática e regeneração
- **Timeout**: Resposta parcial com warning
- **API Limits**: Queue inteligente com retry

#### **Monitoramento Contínuo:**

- **Health Checks**: Validação de integridade do sistema
- **Performance Alerts**: Notificação de degradação
- **Cache Monitoring**: Alertas de hit rate baixo
- **Error Tracking**: Log detalhado para debugging

### 🎯 INTEGRATION POINTS:

#### **TaskMaster Commands (Oficiais):**

- `task-master init`: Inicialização padrão do projeto
- `task-master parse-prd <file>`: Parse de PRD e geração de tasks
- `task-master list`: Lista todas as tasks disponíveis
- `task-master next`: Mostra próxima task recomendada
- `task-master generate`: Gera arquivos de implementação

#### **Integração MCP (Via Chat):**

- "Initialize taskmaster-ai in my project"
- "Parse my PRD at scripts/prd.txt"
- "What's the next task I should work on?"
- "Can you help me implement task X?"

#### **Memory Bank Integration:**

- **Pattern Learning**: Armazenamento de padrões bem-sucedidos
- **Error Prevention**: Prevenção baseada em histórico
- **Continuous Improvement**: Evolução baseada em feedback
- **Knowledge Sharing**: Compartilhamento entre projetos

---

**Esta regra implementa o TASKMASTER + SEQUENTIAL THINKING V2.0 com Smart Trigger, Cache Inteligente e Métricas Avançadas para máxima eficiência e qualidade no GRUPO US VIBECODE SYSTEM.**
