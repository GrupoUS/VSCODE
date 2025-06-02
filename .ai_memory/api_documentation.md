# TaskMaster + Sequential Thinking API Documentation

This document is the central repository for all API endpoint documentation. It must be consulted and updated whenever endpoints are changed. [cite: 27, 29]

---

## TaskMaster CLI Commands

### `task-master list [options]`
* **Purpose:** Lista todas as tarefas do projeto com status e dependências
* **Authentication:** Nenhuma (CLI local)
* **Options:**
  - `--status <status>`: Filtra por status específico
  - `--with-subtasks`: Inclui subtarefas na listagem
  - `--file <path>`: Especifica arquivo tasks.json alternativo
* **Success Response:** Tabela formatada com tarefas e dashboard de progresso
* **Example:** `task-master list --status=pending --with-subtasks`

---

### `task-master next [options]`
* **Purpose:** Mostra a próxima tarefa recomendada para trabalhar baseada em dependências
* **Authentication:** Nenhuma (CLI local)
* **Options:**
  - `--file <path>`: Especifica arquivo tasks.json alternativo
* **Success Response:** Detalhes completos da próxima tarefa com ações sugeridas
* **Example:** `task-master next`

---

### `task-master show <id> [options]`
* **Purpose:** Exibe detalhes completos de uma tarefa específica
* **Authentication:** Nenhuma (CLI local)
* **Parameters:**
  - `<id>`: ID da tarefa (ex: "3" ou "3.2" para subtarefa)
* **Options:**
  - `--file <path>`: Especifica arquivo tasks.json alternativo
* **Success Response:** Informações detalhadas da tarefa incluindo subtarefas
* **Example:** `task-master show 3`

---

### `task-master set-status --id=<id> --status=<status>`
* **Purpose:** Atualiza o status de uma tarefa específica
* **Authentication:** Nenhuma (CLI local)
* **Parameters:**
  - `--id <id>`: ID da tarefa a ser atualizada
  - `--status <status>`: Novo status (pending, in-progress, done, deferred)
* **Success Response:** Confirmação da atualização com regeneração de arquivos
* **Example:** `task-master set-status --id=3 --status=done`

---

### `task-master expand --id=<id> [options]`
* **Purpose:** Expande uma tarefa em subtarefas usando AI
* **Authentication:** Requer API keys configuradas
* **Parameters:**
  - `--id <id>`: ID da tarefa a ser expandida
* **Options:**
  - `--num <number>`: Número de subtarefas a gerar
  - `--research`: Usa Perplexity AI para pesquisa
  - `--force`: Substitui subtarefas existentes
  - `--prompt <text>`: Contexto adicional para expansão
* **Success Response:** Subtarefas geradas e integradas ao sistema
* **Example:** `task-master expand --id=3 --research --force`

---

## Advanced Rules Engine API

### `AdvancedRulesEngine.evaluate(operation, context)`
* **Purpose:** Avalia qual sistema usar baseado em operação e contexto
* **Authentication:** Instância da classe
* **Request Parameters:**
```javascript
{
  "operation": "string", // Nome da operação
  "context": {
    "complexity": "number", // 1-10
    "type": "string", // Tipo de contexto
    "description": "string", // Descrição opcional
    "dependencies": "array", // Lista de dependências
    "hasDeadline": "boolean" // Se tem prazo
  }
}
```
* **Success Response:**
```javascript
{
  "system": "taskmaster|sequential|hybrid",
  "confidence": "number", // 0-1
  "reasoning": "string",
  "scores": {
    "taskmaster": "number",
    "sequential": "number", 
    "hybrid": "number"
  },
  "metadata": {
    "operation": "string",
    "timestamp": "ISO string",
    "decisionId": "string"
  }
}
```

---

### `AdvancedRulesEngine.markDecisionOutcome(decisionId, successful)`
* **Purpose:** Marca o resultado de uma decisão para aprendizado
* **Authentication:** Instância da classe
* **Parameters:**
  - `decisionId`: ID da decisão retornado em evaluate()
  - `successful`: boolean indicando sucesso/falha
* **Success Response:** Atualização das métricas de aprendizado
* **Example:** `engine.markDecisionOutcome("decision_123", true)`

---

## TaskMaster Coordinator API

### `TaskMasterCoordinator.executeHybridCommand(command, params)`
* **Purpose:** Executa comandos híbridos que usam ambos os sistemas
* **Authentication:** Instância da classe
* **Available Commands:**
  - `analyze-and-plan`: Análise + Planejamento
  - `smart-next-task`: Próxima tarefa inteligente
  - `expand-with-thinking`: Expansão com análise
  - `validate-solution`: Validação de solução
* **Request Parameters:**
```javascript
{
  "command": "string",
  "params": {
    "problem": "string", // Para analyze-and-plan
    "requirements": "string", // Para analyze-and-plan
    "taskId": "string", // Para expand-with-thinking
    "solution": "string" // Para validate-solution
  }
}
```
* **Success Response:** Resultado específico do comando executado

---

## Sequential Thinking MCP Tools

### `sequentialthinking`
* **Purpose:** Executa análise sequencial de problemas complexos
* **Authentication:** MCP Server connection
* **Request Parameters:**
```javascript
{
  "thought": "string", // Pensamento atual
  "nextThoughtNeeded": "boolean",
  "thoughtNumber": "number",
  "totalThoughts": "number",
  "isRevision": "boolean", // Opcional
  "revisesThought": "number" // Opcional
}
```
* **Success Response:** Resultado da análise com próximos passos

---

## Workflow Patterns

### Hybrid Workflow: analyze-and-plan
1. **Sequential Thinking:** Análise inicial do problema
2. **Sequential Thinking:** Identificação de componentes  
3. **TaskMaster:** Estruturação em tarefas
4. **Sequential Thinking:** Validação de dependências
5. **TaskMaster:** Criação de estrutura final
6. **Hybrid:** Otimização do plano

### Hybrid Workflow: smart-next-task
1. **TaskMaster:** Busca tarefas disponíveis
2. **Sequential Thinking:** Análise de complexidade e contexto
3. **Sequential Thinking:** Avaliação de riscos
4. **Hybrid:** Geração de recomendações personalizadas
5. **TaskMaster:** Atualização de prioridades

### Hybrid Workflow: expand-with-thinking
1. **TaskMaster:** Recuperação da tarefa original
2. **Sequential Thinking:** Análise profunda de requisitos
3. **Sequential Thinking:** Identificação de subtarefas
4. **TaskMaster:** Criação de estrutura de subtarefas
5. **Sequential Thinking:** Validação de completude
6. **TaskMaster:** Definição de dependências

---

## Error Handling Patterns

### Standard Error Response
```javascript
{
  "success": false,
  "error": "string", // Mensagem de erro
  "operation": "string", // Operação que falhou
  "fallback": "string" // Sistema de fallback usado
}
```

### Fallback Strategy
1. **Primary System Failure:** Tenta sistema de fallback
2. **Complete Failure:** Retorna para TaskMaster (mais estável)
3. **Logging:** Sempre loga erros para análise posterior
4. **Recovery:** Tenta recuperar contexto quando possível

---

## Performance Metrics

### Tracked Metrics
- **Total Decisions:** Número total de decisões tomadas
- **Success Rate:** Porcentagem de decisões bem-sucedidas
- **Average Confidence:** Confiança média das decisões
- **System Usage:** Distribuição de uso entre sistemas
- **Learning Patterns:** Padrões identificados e sua confiança
- **Response Time:** Tempo médio de resposta por operação

### Metrics Access
```javascript
const stats = engine.getAdvancedStats();
// Retorna objeto com todas as métricas atuais
