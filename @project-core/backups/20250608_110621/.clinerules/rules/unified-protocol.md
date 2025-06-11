---
description: Protocolo Unificado de Memória, Aprendizado, Meta-Melhoria e Verificação - Sistema de 4 Camadas
author: Sistema GRUPOUS/Cline Rules
version: 2.0
globs: ["**/*"]
tags: ["unified-protocol", "core-system", "4-layers", "mandatory", "meta"]
alwaysApply: true
---

# PROTOCOLO UNIFICADO: Sistema de 4 Camadas para Desenvolvimento Inteligente

## DIRETIVA PRINCIPAL

Este protocolo estabelece uma sequência obrigatória de 4 camadas que devem ser executadas em TODA tarefa, garantindo continuidade de contexto, aprendizado contínuo, meta-melhoria e verificação sistemática.

---

## LAYER 1: CORE DIRECTIVE (Memory Foundation)

### Objetivo
Carregar contexto completo do projeto antes de qualquer ação, garantindo continuidade e consistência.

### Ativação
**OBRIGATÓRIO** no início de TODA tarefa, antes de qualquer outra ação.

### Sistema de Feedback Visual
**SEMPRE** inicie com a mensagem: **"🔄 Executando Layer 1: Memory Foundation - Carregando contexto completo..."**

### Protocolo Mandatório
1. **Leia `memory-bank/global-project-overview.md`**
2. **Leia `memory-bank/workspace-task-log.md`** 
3. **Leia `memory-bank/global-learnings.md`**

### Confirmação Obrigatória
Após carregar o contexto, confirme com: **"Memory Bank context loaded."**

### Integração com Sistema Existente
- Se existe `.ai_memory/master_rule.md` local, tem precedência absoluta
- Caso contrário, proceda com este protocolo unificado
- Coordena com master_rule.md para workflows específicos

---

## LAYER 2: META-IMPROVEMENT PROTOCOL (Rule Suggestion)

### Objetivo
Evolução contínua das regras `.clinerules` baseada em feedback real do usuário e pontos de atrito identificados durante a execução.

### Sistema de Feedback Visual
**SEMPRE** anuncie quando ativar: **"🔍 Executando Layer 2: Meta-Improvement Protocol - Analisando conversa para oportunidades de melhoria..."**

### Critérios de Ativação Expandidos
Este protocolo ativa **imediatamente antes de usar `attempt_completion`** quando **QUALQUER** dos critérios abaixo for atendido:

#### Critérios Principais (Alta Prioridade)
- O usuário forneceu feedback, correções ou esclarecimentos significativos
- A tarefa envolveu múltiplas etapas não-triviais
- Foram detectados padrões de atrito ou ineficiência
- Erros recorrentes que poderiam ser evitados com novas regras

#### Critérios Expandidos (Sensibilidade Aumentada)
- **Qualquer tarefa que envolveu modificação de mais de 2 arquivos**
- **Qualquer tarefa que durou mais de 5 minutos de conversa**
- **Qualquer feedback do usuário, mesmo pequenos ajustes ou esclarecimentos**
- **Qualquer pergunta de esclarecimento feita pelo usuário**
- **Qualquer uso de ferramentas MCP especializadas** (`sequential-thinking`, `supabase`, etc.)
- **Qualquer tarefa que requerer múltiplos comandos ou iterações**
- **Qualquer tarefa que envolveu 3+ ferramentas MCP diferentes**
- **Sessão > 8 minutos com 2+ iterações na mesma subtarefa**
- **Usuário fez 2+ esclarecimentos sobre o mesmo aspecto**
- **Erro similar ao registrado em consolidated_learnings.md**

#### Comando de Ativação Manual
- **Usuário pode forçar ativação** digitando `!reflect` em qualquer momento
- Sistema perguntará se deve executar reflexão mesmo que critérios automáticos não sejam atendidos
- Permite reflexão sob demanda para capturar insights específicos

### Processo de Meta-Reflexão Obrigatório

#### Passo 1: Pausa e Análise
- **PARE** antes de finalizar a tarefa
- **Anuncie**: "🔍 Pausando para análise de meta-melhoria..."
- Analise toda a conversa do início ao fim
- Identifique pontos onde houve:
  - Necessidade de esclarecimento adicional
  - Correções ou ajustes na abordagem
  - Retrabalho desnecessário
  - Padrões que se repetem

#### Passo 2: Identificação de Gap nas Regras
Pergunte-se: **"Uma nova regra ou modificação em `.clinerules` teria prevenido este atrito?"**

Considere:
- Diretrizes de implementação mais específicas
- Padrões de código que deveriam ser padronizados
- Workflows que poderiam ser mais eficientes
- Validações que poderiam ser automatizadas

#### Classificação de Insights
Após identificar um gap, classifique o insight de acordo com o impacto e a urgência:
- **CRÍTICO**: Previne erros que quebram funcionalidade, causam perda de dados ou impactam segurança.
- **IMPORTANTE**: Melhora eficiência significativamente (>20%), reduz retrabalho ou aprimora UX.
- **OTIMIZAÇÃO**: Refinamentos que agregam valor marginal, melhorias de performance menores ou legibilidade.
- **EXPERIMENTAL**: Ideias para teste futuro, conceitos novos ou abordagens não comprovadas.

#### Passo 3: Formulação de Sugestão
Se identificou oportunidade de melhoria, formule:
- **Descrição clara** do problema identificado
- **Regra proposta** (formatada como código Markdown)
- **Justificativa** de como melhoraria futuros desenvolvimentos
- **Localização sugerida** no sistema de regras

#### Templates Estruturados para Sugestões
Para garantir consistência e clareza nas propostas de melhoria, utilize os seguintes templates:

##### Template: Nova Regra Proposta
```markdown
## Proposta de Nova Regra para .clinerules

**Categoria**: [Técnica/Processo/Ferramenta/UX/Segurança/Performance]
**Prioridade**: [CRÍTICO/IMPORTANTE/OTIMIZAÇÃO/EXPERIMENTAL]
**Trigger Identificado**: [Descreva a situação específica ou o padrão de atrito que ativou esta sugestão. Ex: "Erro recorrente ao configurar ambiente", "Padrão de código duplicado em 3+ arquivos"]
**Problema Resolvido**: [Explique claramente o problema que esta nova regra visa resolver ou o atrito que ela previne. Seja conciso e direto.]
**Regra Proposta**:
```markdown
---
description: [Descrição clara de uma linha do que a regra enforce]
globs: [path/to/files/*.ext, other/path/**/*]
alwaysApply: [true/false]
---

- **[Ponto Principal em Negrito]**
  - [Sub-ponto com detalhes]
  - [Exemplos e explicações]
```
**Justificativa**: [Explique por que esta regra é necessária e como ela melhorará futuros desenvolvimentos. Mencione o impacto esperado (ex: redução de X% de erros, aumento de Y% na eficiência, padronização de Z).]
**Impacto Esperado**: [Métrica ou benefício mensurável. Ex: "Redução de 30% no tempo de setup", "Eliminação de bugs de tipo X", "Melhora na legibilidade do código."]
**Localização Sugerida**: [Caminho completo do arquivo onde a regra deve ser adicionada ou modificada. Ex: `.clinerules/workflows/new-feature-workflow.md`]
```

##### Template: Melhoria de Workflow Existente
```markdown
## Proposta de Melhoria para Workflow Existente

**Workflow Afetado**: [Nome do workflow ou protocolo. Ex: "DEV_WORKFLOW", "Error Handling Protocol"]
**Prioridade**: [CRÍTICO/IMPORTANTE/OTIMIZAÇÃO/EXPERIMENTAL]
**Trigger Identificado**: [Descreva a situação específica ou o atrito que ativou esta sugestão. Ex: "Passos manuais excessivos", "Falta de clareza em uma etapa"]
**Problema Resolvido**: [Explique claramente o problema que esta melhoria visa resolver. Ex: "Retrabalho devido a inconsistências", "Atraso na entrega de tarefas"]
**Melhoria Proposta**: [Descreva a mudança específica no workflow. Pode ser um novo passo, uma automação, uma reordenação de etapas, etc.]
**Justificativa**: [Explique por que esta melhoria é necessária e como ela otimizará o processo. Mencione o impacto esperado.]
**Impacto Esperado**: [Métrica ou benefício mensurável. Ex: "Redução de 15% no tempo de execução do workflow", "Aumento da confiabilidade do processo."]
**Localização Sugerida**: [Caminho completo do arquivo onde a melhoria deve ser documentada. Ex: `.clinerules/workflows/dev-workflow-unified.md`]
```

##### Template: Otimização de Ferramenta/MCP
```markdown
## Proposta de Otimização para Ferramenta/MCP

**Ferramenta/MCP Afetada**: [Nome da ferramenta ou servidor MCP. Ex: "sequentialthinking", "Taskmaster CLI", "Figma-Context-MCP"]
**Prioridade**: [CRÍTICO/IMPORTANTE/OTIMIZAÇÃO/EXPERIMENTAL]
**Trigger Identificado**: [Descreva a situação específica ou o atrito que ativou esta sugestão. Ex: "Uso ineficiente da ferramenta", "Falta de integração com outro sistema"]
**Problema Resolvido**: [Explique claramente o problema que esta otimização visa resolver. Ex: "Custo elevado de tokens", "Tempo de resposta lento", "Funcionalidade não explorada"]
**Otimização Proposta**: [Descreva a mudança específica na configuração ou uso da ferramenta/MCP. Pode ser um novo parâmetro, uma forma de uso mais eficiente, uma integração.]
**Justificativa**: [Explique por que esta otimização é necessária e como ela melhorará o desempenho ou custo. Mencione o impacto esperado.]
**Impacto Esperado**: [Métrica ou benefício mensurável. Ex: "Redução de 20% no custo de tokens", "Aumento de 10% na velocidade de execução", "Melhora na precisão da IA."]
**Localização Sugerida**: [Caminho completo do arquivo onde a otimização deve ser documentada. Ex: `.clinerules/sequential-thinking-mcp.md`, `.clinerules/00-cost-optimization.md`]
```

#### Passo 4: Proposta ao Usuário
**ANTES** de prosseguir com `attempt_completion`:
- Apresente a sugestão claramente
- Explique o benefício esperado
- Aguarde confirmação do usuário
- Só proceda após aprovação ou rejeição explícita

### Integração com Protocolos Existentes
- Coordena com `completude-verification-protocol.md`
- Utiliza insights do `sequential-thinking-mcp.md` quando aplicável
- Registra melhorias aprovadas no `global-learnings.md`

---

## LAYER 3: COMPLETENESS VERIFICATION PROTOCOL (Plan Adherence)

### Objetivo
Garantir que todas as tarefas do plano inicial foram completamente executadas antes de concluir o ciclo de trabalho.

### Ativação
**OBRIGATÓRIO** após conclusão de um conjunto de tarefas, mas **ANTES** do Layer 4.

### Sistema de Feedback Visual
**SEMPRE** anuncie quando ativar: **"✅ Executando Layer 3: Completeness Verification - Verificando completude das tarefas..."**

### Protocolo de Verificação

#### Passo 1: Mudança para Plan Mode
Declare: **"✅ Entrando em Plan Mode para verificação de completude."**

#### Passo 2: Comparação Sistemática
- Recupere o plano inicial formulado no início das tarefas
- Compare item por item com as ações executadas
- Utilize o `completude-verification-protocol.md` existente para metodologia detalhada
- Consulte `workspace-task-log.md` para histórico de ações

#### Passo 3: Relatório de Status
**Se todas as tarefas estão completas:**
- Confirme: **"Verificação bem-sucedida. Todas as tarefas planejadas estão completas."**
- Proceda imediatamente para Layer 4

**Se existem tarefas pendentes:**
- Reporte: **"Verificação completa. As seguintes tarefas do plano inicial não foram endereçadas:"**
- Liste especificamente cada item pendente
- Crie novo plano detalhado para as tarefas restantes
- Aguarde aprovação do usuário
- Execute as tarefas pendentes
- Repita verificação até completude total

### Coordenação com Sistema Existente
- Utiliza metodologia do `completude-verification-protocol.md`
- Integra com `sequential-thinking-mcp.md` para tarefas complexas
- Registra gaps identificados para melhoria futura de planejamento

---

## LAYER 4: POST-TASK LEARNING PROTOCOL (Knowledge Capture)

### Objetivo
Capturar e cristalizar conhecimento adquirido durante a execução, alimentando o sistema de melhoria contínua.

### Ativação
**OBRIGATÓRIO** como sequência final após verificação completa de todas as tarefas.

### Sistema de Feedback Visual
**SEMPRE** anuncie quando ativar: **"📚 Executando Layer 4: Post-Task Learning - Capturando conhecimento e atualizando Memory Bank..."**

### Protocolo de Captura de Conhecimento (Sistema de 2 Camadas)

#### Passo 1: Captura Bruta (Raw Reflection)
- **Registre em `memory-bank/raw_reflection_log.md`** entrada detalhada seguindo formato estruturado:
  - Data/Hora/TaskRef
  - Learnings específicos
  - Dificuldades encontradas e soluções
  - Sucessos e fatores contribuintes
  - Itens identificados para consolidação
- **Status**: Marque como "⏳ Pendente" para consolidação posterior

#### Passo 2: Atualização do Task Log
- Atualize `memory-bank/workspace-task-log.md` com entrada estruturada
- Inclua: timestamp, resumo das ações, decisões tomadas, outcomes
- Documente padrões ou técnicas descobertas

#### Passo 3: Reflexão Estruturada
Analise sistematicamente:
- **Desafio Central**: Qual foi o problema core resolvido?
- **Eficiência**: Como o processo poderia ser mais eficiente?
- **Insight Chave**: Qual o learning mais importante?
- **Padrões Emergentes**: Que padrões novos foram identificados?

#### Passo 4: Consolidação de Conhecimento (Quando Aplicável)
Se insights são de alto valor e reutilizáveis:
- **Atualize `memory-bank/consolidated_learnings.md`** com padrões refinados
- **Organize por categoria** (Técnico, Gestão, Ferramentas, Problemas, etc.)
- **Marque entrada em raw_reflection_log.md como "✅ Processado"**

#### Passo 5: Atualização Operacional
Se o "Actionable Improvement" define nova convenção permanente:
- Atualize `memory-bank/global-project-overview.md`
- Considere criar/atualizar regras específicas em `.clinerules`

#### Passo 6: Confirmação Final
Conclua com a mensagem obrigatória:
**"Tarefa completa. Memory Bank (raw + consolidated) e conhecimento operacional atualizados através do Protocolo de Melhoria Contínua."**

#### Passo 5: Atualização Operacional
Se o "Actionable Improvement" define nova convenção permanente:
- Atualize `memory-bank/global-project-overview.md`
- Considere criar/atualizar regras específicas em `.clinerules`

#### Passo 6: Confirmação Final
Conclua com a mensagem obrigatória:
**"Tarefa completa. Memory Bank (raw + consolidated) e conhecimento operacional atualizados através do Protocolo de Melhoria Contínua."**

### Integração com Knowledge Graph
- Registre insights no MCP Knowledge Graph quando disponível
- Utilize padrões identificados para melhorar `sequential-thinking-mcp.md`
- Alimente `error_handling_protocol.md` com soluções documentadas

---

## HIERARQUIA DE PRECEDÊNCIA ATUALIZADA

1. **Regras Locais** (`.ai_memory/master_rule.md`) - Precedência absoluta
2. **Protocolo Unificado** (este arquivo) - Estrutura obrigatória de 4 camadas
3. **Protocolos de Emergência** (`error_handling_protocol.md`) - Ativação automática
4. **Ferramentas MCP Especializadas** (`sequential-thinking-mcp.md`) - Para problemas complexos
5. **Workflows Específicos** (arquivos em `.clinerules/workflows/`)
6. **Regras Globais** (sistema base)

---

## INTEGRAÇÃO COM SISTEMA EXISTENTE

### Coordenação com Master Rule
- O `master_rule.md` permanece como coordenador de workflows específicos
- Este protocolo unificado fornece a estrutura macro obrigatória
- Workflows específicos operam dentro desta estrutura de 4 camadas

### Utilização de Ferramentas Existentes
- **Sequential Thinking**: Usado quando Layer 2 identifica problemas complexos
- **Completude Verification**: Metodologia detalhada para Layer 3
- **Error Handling**: Integrado em todas as camadas conforme necessário

### Memory Bank Evolution
- Sistema atual preservado e expandido
- Novos padrões de captura de conhecimento através do Layer 4
- Integração bidirecional: lê contexto (Layer 1) e atualiza knowledge (Layer 4)

---

## MONITORAMENTO E EVOLUÇÃO

### Métricas de Sucesso
- Taxa de identificação de melhorias (Layer 2)
- Precisão na verificação de completude (Layer 3)
- Qualidade dos insights capturados (Layer 4)
- Redução de retrabalho ao longo do tempo

### Ciclo de Melhoria
- Layer 2 identifica oportunidades
- Layer 4 documenta patterns
- Sistema evolui organicamente
- Rules se tornam mais eficazes com uso

### Auditoria Regular
- Revisão mensal dos global-learnings.md
- Identificação de patterns cross-project
- Consolidação de regras que emergiram
- Deprecação de práticas obsoletas

---

**Protocolo estabelecido**: 2025-06-03 08:22:36  
**Versão**: 1.0  
**Compatibilidade**: Totalmente compatível com sistema existente .clinerules  
**Precedência**: Estrutura macro obrigatória para todos os workflows
