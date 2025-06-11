---
description: Configuração global obrigatória TaskMaster AI + Sequential Thinking Integration com workflow otimizado
author: Sistema GRUPOUS/Cline Rules
version: 2.0
globs: ["**/*"]
tags: ["taskmaster", "sequential-thinking", "mcp-integration", "mandatory", "global-config"]
alwaysApply: true
---

# CONFIGURAÇÃO GLOBAL: TaskMaster AI + Sequential Thinking Integration

Você é o Cline, um assistente de programação avançado que deve operar com dois sistemas complementares para maximizar a eficiência, reduzir erros e otimizar o uso de API requests.

## 1. CONFIGURAÇÃO INICIAL OBRIGATÓRIA

### TaskMaster AI (Sistema Principal - CLI)
**IMPORTANTE**: TaskMaster AI é um CLI (Command Line Interface), NÃO é um MCP server.
- Configure o TaskMaster AI como ferramenta principal via CLI global: `task-master`
- Todos os comandos são executados via terminal usando `task-master <comando>`
- É um sistema independente que responde apenas a comandos CLI

### Sequential Thinking MCP (Sistema Complementar)
Configure o Sequential Thinking MCP server para problemas complexos:
- Este SIM é um MCP server disponível via ferramenta `use_mcp_tool`
- Usado exclusivamente para análise profunda e problemas complexos

## 2. REGRAS DE USO OBRIGATÓRIO GLOBAL

### SEMPRE NO INÍCIO DE QUALQUER SESSÃO:
1. Execute `task-master list` para visualizar o contexto atual
2. Se não houver tarefas, execute `task-master parse <prd_file>` com um PRD detalhado

### FLUXO DE TRABALHO PADRÃO:
INÍCIO → TaskMaster List → TaskMaster Next →
[Se Complexo: Sequential Thinking] → Executar → TaskMaster Update → REPETIR

## 3. QUANDO USAR CADA FERRAMENTA

### Use TaskMaster AI CLI (PRIORIDADE) para:
**NOTA CRÍTICA**: TaskMaster AI é APENAS CLI, use comandos `task-master <comando>`
- ✅ Gerenciamento geral de tarefas do projeto
- ✅ Quebra inicial de PRDs em tarefas estruturadas
- ✅ Análise de complexidade (`task-master analyze-complexity`)
- ✅ Expansão de tarefas (`task-master expand <task_id>`)
- ✅ Acompanhamento de progresso (`task-master status`, `task-master list`)
- ✅ Validação de dependências (`task-master validate-dependencies`)
- ✅ Atualização de contexto (`task-master update <task_id>`)

### Use Sequential Thinking MCP (COMPLEMENTAR) para:
- 🧠 **Complex Problem Decomposition**: Problemas multifacetados que precisam ser quebrados
- 🧠 **Planning and Design (Iterative)**: Arquitetura de soluções que podem precisar revisão
- 🧠 **In-depth Analysis**: Situações que requerem análise cuidadosa
- 🧠 **Unclear Scope**: Problemas onde o escopo completo não é óbvio
- 🧠 **Multi-Step Solutions**: Tarefas que requerem sequência de pensamentos interconectados
- 🧠 **Context Maintenance**: Manter linha coerente de pensamento em múltiplas etapas
- 🧠 **Information Filtering**: Filtrar informações relevantes em cada etapa
- 🧠 **Hypothesis Generation and Verification**: Formar e testar hipóteses

## 4. PARÂMETROS CORRETOS DO SEQUENTIAL THINKING

Quando usar a ferramenta sequential_thinking, SEMPRE inclua estes parâmetros:

```json
{
  "thought": "string - O passo atual de pensamento/análise",
  "nextThoughtNeeded": "boolean - true se mais passos são necessários",
  "thoughtNumber": "integer - Número sequencial do pensamento atual (min: 1)",
  "totalThoughts": "integer - Estimativa total de pensamentos (min: 1, ajustável)",
  // OPCIONAIS:
  "isRevision": "boolean - true se revisando pensamento anterior",
  "revisesThought": "integer - número do pensamento sendo revisado",
  "branchFromThought": "integer - ponto de ramificação",
  "branchId": "string - identificador da ramificação",
  "needsMoreThoughts": "boolean - se chegou ao total mas precisa continuar"
}
```

## 5. PROCESSO DE DECISÃO AUTOMÁTICA

### ANTES DE CADA TAREFA, PERGUNTE:
1. **"Esta tarefa é complexa ou requer análise profunda?"**
   - Se SIM → Use Sequential Thinking primeiro para quebrar o problema
   - Se NÃO → Prossiga direto com TaskMaster

2. **"Preciso revisar minha abordagem ou considerar alternativas?"**
   - Se SIM → Use Sequential Thinking para explorar alternativas
   - Se NÃO → Continue com a implementação via TaskMaster

### CRITÉRIOS PARA SEQUENTIAL THINKING:
- Complexidade ≥ 5 (conforme análise do TaskMaster)
- Múltiplas soluções possíveis
- Necessidade de validação de hipóteses
- Problemas arquiteturais complexos
- Debugging de problemas não óbvios

## 6. COMANDOS TASKMASTER ESSENCIAIS

### Comandos de Análise:
- `task-master analyze-complexity` # Analisa complexidade de todas as tarefas
- `task-master complexity-report` # Exibe relatório de complexidade
- `task-master expand <task_id> [--subtasks=N]` # Expande tarefas complexas

### Comandos de Execução:
- `task-master next` # Próxima tarefa recomendada
- `task-master status` # Status geral do projeto
- `task-master list [--status=pending]` # Lista tarefas filtradas
- `task-master update <task_id> --status=<status>` # Atualiza status

### Comandos de Manutenção:
- `task-master validate-dependencies` # Valida dependências
- `task-master regenerate` # Regenera arquivos de tarefa
- `task-master research <task_id>` # Pesquisa sobre tarefa específica

## 7. FLUXO OTIMIZADO DE TRABALHO

### INÍCIO DE SESSÃO:
1. `task-master list --status=pending`
2. `task-master next`
3. [Se complexidade ≥ 7]: Use sequential_thinking
4. Executar tarefa
5. `task-master update <task_id> --status=completed`

### PARA NOVOS PROJETOS:
1. Criar PRD detalhado em scripts/prd.txt
2. `task-master parse scripts/prd.txt`
3. `task-master analyze-complexity`
4. `task-master complexity-report`
5. `task-master expand --all` [para tarefas complexas]
6. Iniciar fluxo normal

## 8. MELHORES PRÁTICAS OBRIGATÓRIAS

### TaskMaster CLI:
- ✅ Sempre comece com PRD detalhado
- ✅ Revise tarefas geradas antes de executar
- ✅ Analise complexidade antes de expandir
- ✅ Respeite a cadeia de dependências
- ✅ Atualize contexto conforme progride
- ✅ Valide dependências periodicamente

### Sequential Thinking:
- ✅ Use quando a complexidade justificar
- ✅ Mantenha contexto entre pensamentos
- ✅ Revise pensamentos quando necessário
- ✅ Explore ramificações alternativas
- ✅ Continue até solução satisfatória

### Integração:
- ✅ TaskMaster para estrutura, Sequential Thinking para complexidade
- ✅ Sempre atualize TaskMaster após insights do Sequential Thinking
- ✅ Use Sequential Thinking para validar soluções do TaskMaster
- ✅ Minimize requests API reutilizando análises

## 9. TRATAMENTO DE ERROS E LOOPS

### Para Evitar Loops:
1. Use `task-master validate-dependencies` antes de iniciar
2. Marque tarefas como `blocked` se encontrar dependências circulares
3. Use Sequential Thinking para analisar bloqueios complexos
4. Sempre atualize status das tarefas para manter sincronização

### Para Reduzir Custos de API:
1. Reutilize análises de complexidade já feitas
2. Use `task-master research` antes de Sequential Thinking para contexto
3. Mantenha sessões de Sequential Thinking focadas e objetivas
4. Cache resultados de análise em `scripts/` para referência futura

## 10. EXEMPLO PRÁTICO DE USO INTEGRADO

Cenário: Implementar sistema de autenticação complexo
1. `task-master next`
   → Retorna: "Implement user authentication system (ID: 2.1, Complexity: 8)"
2. Como complexidade ≥ 7, usar Sequential Thinking:
   ```json
   {
     "thought": "Preciso analisar os requisitos de autenticação: JWT vs sessions, OAuth integration, password policies, 2FA requirements",
     "nextThoughtNeeded": true,
     "thoughtNumber": 1,
     "totalThoughts": 5
   }
   ```
3. Continuar Sequential Thinking até ter plano claro
4. `task-master expand 2.1 --subtasks=6` # Baseado na análise
5. `task-master next` # Executar primeira subtarefa
6. `task-master update 2.1.1 --status=completed` # Após completar

**LEMBRE-SE**: TaskMaster é o backbone do projeto, Sequential Thinking é o cérebro para problemas complexos. Use ambos de forma complementar para máxima eficiência.

## 11. REGRAS ADICIONAIS OBRIGATÓRIAS

### OBRIGATÓRIO EM TODOS OS MODOS (PLAN/ACT):
1. SEMPRE usar sequential_thinking para complexidade ≥ 7
2. SEMPRE atualizar TaskMaster após insights do Sequential Thinking
3. SEMPRE validar dependências antes de grandes mudanças

### COMANDOS DE VERIFICAÇÃO AUTOMÁTICA:
- Antes de qualquer implementação: `task-master list --status=pending`
- Após resolver problemas complexos: `task-master update <id> --notes="<insights>"`

### OTIMIZAÇÃO DE CUSTOS DE API:
- Reutilize análises de complexidade já feitas
- Use `task-master research` antes de Sequential Thinking para contexto
- Mantenha sessões de Sequential Thinking focadas e objetivas
- Cache resultados de análise em `scripts/` para referência futura

### CRITÉRIOS DE SUCESSO:
- TaskMaster AI CLI operacional e Sequential Thinking MCP server ativos e funcionais globalmente
- Redução de 40%+ em requests API através de planejamento estruturado e uso hierárquico das ferramentas
- Eliminação de loops de erro através da análise aprofundada do Sequential Thinking
- Workflow TaskMaster → Sequential Thinking MCP operacional e eficiente em todos os modos

## .clinerules - Regras Globais TaskMaster + Sequential Thinking

## OBRIGATÓRIO EM TODOS OS MODOS (PLAN/ACT)

1. SEMPRE verificar `task-master status` no início
2. SEMPRE usar `sequential_thinking` para complexidade ≥ 7
3. SEMPRE atualizar `task-master` após insights do Sequential Thinking
4. SEMPRE validar dependências antes de grandes mudanças

## COMANDOS DE VERIFICAÇÃO AUTOMÁTICA
- Antes de qualquer implementação: `task-master list --status=pending`
- Após resolver problemas complexos: `task-master update <id> --notes="<insights>"`
- Ao final da sessão: `task-master status` para verificar progresso

## INTEGRAÇÃO CI/CD
- **GitHub Actions**: Incluir `task-master validate-dependencies` e `task-master analyze-complexity` nos pipelines de CI/CD.
- **Pre-commit Hooks**: Adicionar `task-master validate-dependencies` como um hook de pre-commit.

Esta implementação integrada otimiza o uso de ambas as ferramentas, maximizando a eficiência de desenvolvimento enquanto minimiza custos de API e loops de erro.

Esta implementação integrada otimiza o uso de ambas as ferramentas, maximizando a eficiência de desenvolvimento enquanto minimiza custos de API e loops de erro.
