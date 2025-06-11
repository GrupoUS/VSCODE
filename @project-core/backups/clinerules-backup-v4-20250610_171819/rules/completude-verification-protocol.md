---
description: Protocolo obrigatório de verificação de completude após conclusão de tarefas
author: Sistema GRUPOUS/Cline Rules
version: 2.0
globs: ["**/*"]
tags: ["completeness", "verification", "quality-assurance", "mandatory", "protocol"]
alwaysApply: true
---

# Protocolo de Verificação de Completude de Tarefas

## 1. Objetivo

Este protocolo garante que todas as tarefas sejam 100% completadas conforme o planejamento inicial, evitando que itens importantes sejam esquecidos ou deixados pendentes.

## 2. Ativação Obrigatória

### 2.1. Gatilhos de Ativação
- **Conclusão de qualquer tarefa complexa** (que envolveu múltiplas etapas)
- **Finalização de implementações** (código, documentação, configurações)
- **Término de projetos ou features**
- **Antes de usar `attempt_completion`**

### 2.2. Momento da Verificação
- **SEMPRE** antes de considerar uma tarefa como finalizada
- **OBRIGATÓRIO** alternar para PLAN MODE para fazer a verificação
- **MANDATÓRIO** criar plano de completude se houver gaps

## 3. Processo de Verificação (4 Etapas)

### Etapa 1: Recuperação do Planejamento Inicial
- **Ação**: Listar todos os itens que foram planejados inicialmente
- **Fonte**: Mensagens iniciais do usuário, plans mode anteriores, especificações
- **Formato**: Lista numerada clara do que foi prometido/planejado

### Etapa 2: Auditoria da Execução Realizada
- **Ação**: Listar todos os itens que foram efetivamente implementados
- **Verificação**: Cada arquivo criado, função implementada, configuração feita
- **Status**: ✅ Completo, ⚠️ Parcial, ❌ Não feito

### Etapa 3: Análise de Gaps
- **Comparação**: Planejamento vs Execução
- **Identificação**: Itens faltantes, implementações parciais, funcionalidades pendentes
- **Categorização**: Crítico, Importante, Opcional

### Etapa 4: Plano de Completude
- **Se gaps críticos**: Criar plano detalhado para completar
- **Se gaps importantes**: Avaliar necessidade e criar plano se necessário
- **Se gaps opcionais**: Documentar para futura referência
- **Se sem gaps**: Confirmar completude total

## 4. Templates de Verificação

### 4.1. Template para Desenvolvimento de Software
```markdown
## Verificação de Completude - Desenvolvimento

### Planejamento Inicial:
- [ ] Funcionalidade A
- [ ] Funcionalidade B
- [ ] Testes
- [ ] Documentação
- [ ] Configuração

### Execução Realizada:
- [✅/⚠️/❌] Funcionalidade A: Status e detalhes
- [✅/⚠️/❌] Funcionalidade B: Status e detalhes
- [✅/⚠️/❌] Testes: Status e detalhes
- [✅/⚠️/❌] Documentação: Status e detalhes
- [✅/⚠️/❌] Configuração: Status e detalhes

### Gaps Identificados:
- **Críticos**: [Lista]
- **Importantes**: [Lista]
- **Opcionais**: [Lista]

### Plano de Completude:
- [ ] Tarefa 1 para resolver gap crítico
- [ ] Tarefa 2 para resolver gap crítico
- [ ] [Opcional] Tarefa para gap importante
```

### 4.2. Template para Criação de Regras/Protocolos
```markdown
## Verificação de Completude - Regras/Protocolos

### Planejamento Inicial:
- [ ] Arquivo principal da regra
- [ ] Integração com master_rule.md
- [ ] Exemplos práticos
- [ ] Critérios de ativação
- [ ] Documentação de uso

### Execução Realizada:
- [✅/⚠️/❌] Arquivo principal: [local] - [status]
- [✅/⚠️/❌] Integração master_rule: [detalhes]
- [✅/⚠️/❌] Exemplos práticos: [quantidade/qualidade]
- [✅/⚠️/❌] Critérios ativação: [clareza/completude]
- [✅/⚠️/❌] Documentação: [suficiência]

### Gaps Identificados:
- **Críticos**: [Lista]
- **Importantes**: [Lista]
- **Opcionais**: [Lista]

### Plano de Completude:
- [ ] [Ações específicas para resolver gaps]
```

### 4.3. Template para Configuração/Setup
```markdown
## Verificação de Completude - Configuração/Setup

### Planejamento Inicial:
- [ ] Arquivos de configuração
- [ ] Variáveis de ambiente
- [ ] Dependências
- [ ] Scripts de automação
- [ ] Documentação de setup

### Execução Realizada:
- [✅/⚠️/❌] Configs: [arquivos criados/modificados]
- [✅/⚠️/❌] Env vars: [quantidade/validação]
- [✅/⚠️/❌] Dependências: [instaladas/testadas]
- [✅/⚠️/❌] Scripts: [funcionais/testados]
- [✅/⚠️/❌] Docs: [completa/atualizada]

### Gaps Identificados:
- **Críticos**: [Lista]
- **Importantes**: [Lista]
- **Opcionais**: [Lista]

### Plano de Completude:
- [ ] [Ações específicas para resolver gaps]
```

## 5. Critérios de Completude por Categoria

### 5.1. Completude Crítica (Obrigatória)
- **Funcionalidade core** implementada e funcionando
- **Integração principal** estabelecida e testada
- **Arquivos essenciais** criados com conteúdo correto
- **Configurações mínimas** para funcionamento

### 5.2. Completude Importante (Altamente Recomendada)
- **Documentação** adequada e atualizada
- **Exemplos de uso** claros e funcionais
- **Tratamento de erros** básico implementado
- **Testes básicos** (quando aplicável)

### 5.3. Completude Opcional (Melhoria Futura)
- **Otimizações** de performance
- **Features avançadas** não essenciais
- **Documentação estendida**
- **Testes abrangentes**

## 6. Ações Baseadas em Resultados

### 6.1. Se Completude Total (100%)
```markdown
✅ **TAREFA TOTALMENTE COMPLETA**
- Todos os itens planejados foram implementados
- Qualidade atende aos critérios definidos
- Pode prosseguir com `attempt_completion`
```

### 6.2. Se Gaps Críticos Identificados
```markdown
❌ **COMPLETUDE INSUFICIENTE - AÇÃO NECESSÁRIA**
- Gaps críticos devem ser resolvidos antes de finalizar
- Criar plano detalhado para resolução
- Executar plano antes de `attempt_completion`
```

### 6.3. Se Apenas Gaps Importantes/Opcionais
```markdown
⚠️ **COMPLETUDE PARCIAL - DECISÃO NECESSÁRIA**
- Avaliar se gaps afetam funcionalidade essencial
- Se sim: criar plano e resolver
- Se não: documentar para futura implementação
```

## 7. Integração com Sistema de Regras

### 7.1. Coordenação com Master Rule
- Este protocolo é ativado automaticamente pelo master_rule.md
- Tem prioridade alta na hierarquia de protocolos
- Deve ser executado antes de finalizar qualquer tarefa complexa

### 7.2. Coordenação com Error Handling
- Se gaps críticos são identificados, pode acionar error_handling_protocol
- Gaps não resolvidos são tratados como "incomplete task errors"

### 7.3. Coordenação com Knowledge Graph
- Registrar padrões de gaps frequentes
- Armazenar templates bem-sucedidos
- Aprender com verificações anteriores

## 8. Exemplos de Uso

### 8.1. Exemplo: Verificação da Tarefa Sequential Thinking
```markdown
## Verificação - Criação Regra Sequential Thinking

### Planejamento Inicial:
- ✅ Criar arquivo .clinerules/sequential-thinking-mcp.md
- ✅ Integrar com master_rule.md
- ✅ Incluir exemplos práticos de uso
- ✅ Definir critérios de ativação
- ✅ Estruturar protocolo técnico detalhado

### Execução Realizada:
- ✅ Arquivo criado: 8 seções completas com 2000+ palavras
- ✅ Master rule: Atualizado com referências e precedência
- ✅ Exemplos: 2 cenários detalhados (auth MFA + debug performance)
- ✅ Critérios: 4 categorias de ativação bem definidas
- ✅ Protocolo: Sintaxe exata e workflow iterativo

### Gaps Identificados:
- **Críticos**: Nenhum
- **Importantes**: Nenhum  
- **Opcionais**: Possível adição de mais exemplos futuramente

### Resultado: ✅ COMPLETUDE TOTAL (100%)
```

## 9. Métricas e Monitoramento

### 9.1. Métricas de Sucesso
- **Taxa de completude**: % de tarefas com 100% de completude
- **Gaps críticos**: Frequência de gaps críticos identificados
- **Retrabalho**: Frequência de volta para resolver gaps

### 9.2. Indicadores de Melhoria
- Redução de gaps críticos ao longo do tempo
- Aumento da taxa de completude total
- Melhoria na qualidade dos planejamentos iniciais

## 10. Manutenção do Protocolo

### 10.1. Atualização dos Templates
- Adicionar novos templates conforme surgem novos tipos de tarefa
- Refinar templates existentes baseado na experiência
- Remover templates obsoletos

### 10.2. Evolução dos Critérios
- Ajustar critérios de completude baseado em resultados
- Adicionar novas categorias se necessário
- Balancear rigor vs praticidade

---

*Este protocolo garante que nenhuma tarefa seja considerada finalizada sem verificação completa de que todos os itens planejados foram adequadamente implementados.*
