# REGRA: Uso Obrigatório do MCP Sequential Thinking

## 🎯 OVERVIEW

Esta regra estabelece quando e como o agente **DEVE** usar a ferramenta `sequential_thinking` MCP para garantir um processo de raciocínio mais detalhado, iterativo e transparente em tarefas complexas.

## 🚨 1. GATILHOS DE ATIVAÇÃO (Quando Usar)

Você **DEVE** iniciar o uso da ferramenta `sequential_thinking` quando uma tarefa atender a QUALQUER um dos seguintes critérios:

### **Critérios Obrigatórios:**
- **Complexidade ≥ 5**: Avaliada durante o STEP 1: ULTRATHINK
- **Multi-fase detectada**: Projetos com 2+ fases identificadas pelo TaskMaster
- **Natureza da Tarefa**: Envolve planejamento de arquitetura, design iterativo, análise de causa raiz, ou quando o escopo inicial é ambíguo
- **Decomposição de Problema**: Sempre que um problema precisa ser dividido em mais de 3 passos lógicos
- **Correção de Curso**: Quando uma hipótese inicial se mostra incorreta e um novo caminho precisa ser explorado
- **Análise Profunda**: Tarefas que requerem investigação detalhada ou tomada de decisão complexa

### **Critérios Contextuais:**
- **Incerteza Alta**: Quando não há clareza sobre a melhor abordagem
- **Múltiplas Alternativas**: Quando existem várias soluções possíveis
- **Dependências Complexas**: Quando a tarefa envolve múltiplas integrações ou sistemas
- **Impacto Alto**: Quando a decisão afeta arquitetura ou padrões fundamentais

## 🔄 2. PRINCÍPIOS DE EXECUÇÃO (Como Usar)

Ao usar `sequential_thinking`, você **DEVE** seguir estes princípios:

### **2.1 Processo Iterativo**
- **Cada chamada é um "pensamento"**: Construa, questione ou revise pensamentos anteriores
- **Evolução Gradual**: Permita que a solução evolua através dos pensamentos
- **Validação Contínua**: Questione e valide cada etapa do raciocínio

### **2.2 Contagem Dinâmica de Pensamentos**
- **Estimativa Inicial**: Comece com uma estimativa para `totalThoughts`
- **Ajuste Dinâmico**: Incremente `thoughtNumber` e atualize `totalThoughts` conforme necessário
- **Flexibilidade**: Se precisar de mais passos, não hesite em expandir

### **2.3 Reflexão Honesta**
- **Expresse Incerteza**: Use `isRevision: true` e `revisesThought: <thought_number>` para marcar explicitamente as revisões
- **Explore Alternativas**: Use `branchFromThought` para explorar caminhos alternativos
- **Transparência**: Seja honesto sobre limitações e incertezas

### **2.4 Abordagem por Hipótese**
- **Formule Hipóteses**: Crie hipóteses de solução claras
- **Teste Sistematicamente**: Use os passos de pensamento para verificar hipóteses
- **Pivote Quando Necessário**: Mude de direção quando evidências contradizem a hipótese

### **2.5 Filtro de Relevância**
- **Foco Direcionado**: Ignore ativamente informações irrelevantes para o pensamento atual
- **Priorização**: Concentre-se nos aspectos mais críticos primeiro
- **Contexto Mantido**: Mantenha o contexto relevante entre pensamentos

### **2.6 Condição de Conclusão**
- **Critério Claro**: Apenas defina `nextThoughtNeeded: false` quando a solução for alcançada e verificada
- **Validação Final**: Confirme que todos os aspectos críticos foram considerados
- **Documentação**: Resuma a solução final de forma clara

## 🚀 3. EXEMPLO DE INVOCAÇÃO INICIAL

Para uma tarefa de complexidade 7, seu primeiro passo DEVE ser:

```javascript
use_mcp_tool('sequential_thinking', {
  thought: 'Iniciando a decomposição do problema. O objetivo é [objetivo da tarefa]. O plano inicial envolve [passo 1], [passo 2], e [passo 3]. Preciso analisar a complexidade e identificar possíveis riscos antes de prosseguir.',
  nextThoughtNeeded: true,
  thoughtNumber: 1,
  totalThoughts: 5 // Estimativa inicial
})
```

## 🔍 4. PADRÕES DE USO AVANÇADO

### **4.1 Revisão e Refinamento**
```javascript
use_mcp_tool('sequential_thinking', {
  thought: 'Revisando minha abordagem anterior. Identifiquei que [problema específico] na solução proposta. Vou explorar uma alternativa focada em [nova abordagem].',
  nextThoughtNeeded: true,
  thoughtNumber: 3,
  totalThoughts: 6, // Ajustado para cima
  isRevision: true,
  revisesThought: 2
})
```

### **4.2 Exploração de Alternativas**
```javascript
use_mcp_tool('sequential_thinking', {
  thought: 'Explorando uma abordagem alternativa baseada em [critério diferente]. Esta direção pode oferecer [vantagens específicas] em comparação com a abordagem anterior.',
  nextThoughtNeeded: true,
  thoughtNumber: 4,
  totalThoughts: 7,
  branchFromThought: 2
})
```

### **4.3 Conclusão e Síntese**
```javascript
use_mcp_tool('sequential_thinking', {
  thought: 'Síntese final: Após análise detalhada, a solução recomendada é [solução específica] porque [justificativa]. Os próximos passos são: [lista de ações]. Esta abordagem mitiga os riscos identificados e atende aos critérios de sucesso.',
  nextThoughtNeeded: false,
  thoughtNumber: 7,
  totalThoughts: 7
})
```

## 📊 5. INTEGRAÇÃO COM OUTROS PROTOCOLOS

### **5.1 TaskMaster Integration**
- **Coordenação**: Use `sequential_thinking` para decompor tarefas complexas antes de criar sub-tarefas no TaskMaster
- **Validação**: Use para validar estratégias de execução de tarefas multi-fase
- **Otimização**: Use para otimizar sequências de execução de tarefas

### **5.2 Memory Bank Integration**
- **Aprendizado**: Documente insights do `sequential_thinking` no `self_correction_log.md`
- **Padrões**: Identifique padrões de raciocínio bem-sucedidos para reutilização
- **Evolução**: Use para evoluir estratégias baseadas em experiências passadas

### **5.3 Quality Assurance**
- **Validação**: Use para validar soluções antes da implementação
- **Revisão**: Use para revisar decisões arquiteturais importantes
- **Documentação**: Use para documentar o processo de tomada de decisão

## ⚡ 6. MÉTRICAS DE SUCESSO

### **6.1 Indicadores de Uso Efetivo**
- **Profundidade**: Pensamentos demonstram análise progressivamente mais profunda
- **Clareza**: Cada pensamento adiciona valor e clareza à solução
- **Convergência**: O processo converge para uma solução bem fundamentada
- **Documentação**: O raciocínio é claro e pode ser seguido por outros

### **6.2 Sinais de Alerta**
- **Repetição**: Pensamentos repetitivos sem progresso
- **Divergência**: Pensamentos que se afastam do objetivo
- **Superficialidade**: Análise superficial sem profundidade adequada
- **Confusão**: Raciocínio confuso ou contraditório

## 🎯 7. ENFORCEMENT E ACCOUNTABILITY

### **7.1 Auto-Monitoramento**
- **Pergunta Crítica**: "Estou usando `sequential_thinking` quando deveria?"
- **Avaliação Regular**: Revise o uso da ferramenta após cada tarefa complexa
- **Feedback Loop**: Use insights para melhorar o uso futuro

### **7.2 Integração no Ciclo de Execução**
- **STEP 1 (THINK)**: Avalie se `sequential_thinking` é necessário
- **STEP 2 (PLAN)**: Use `sequential_thinking` para planejar tarefas complexas
- **STEP 4 (LEARN)**: Documente insights do uso da ferramenta

### **7.3 Continuous Improvement**
- **Padrão de Uso**: Desenvolva padrões pessoais de uso efetivo
- **Otimização**: Otimize o número de pensamentos baseado na experiência
- **Compartilhamento**: Compartilhe padrões bem-sucedidos com o sistema

---

**Esta regra é parte integral do GRUPO US VIBECODE SYSTEM V2.0 e deve ser seguida rigorosamente para garantir a qualidade e profundidade do raciocínio em tarefas complexas.**
