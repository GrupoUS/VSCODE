---
description: Protocolo obrigatório de resposta imediata a erros que impedem conclusão de sub-tarefas
author: Sistema GRUPOUS/Cline Rules
version: 2.0
globs: ["**/*"]
tags: ["error-handling", "protocol", "immediate-response", "mandatory", "critical"]
alwaysApply: true
---

# 🚨 Protocolo de Resposta Imediata a Erros

## Objetivo

Este protocolo define o procedimento obrigatório para resposta sistemática a erros que impedem a conclusão de sub-tarefas, garantindo diagnóstico preciso, correção efetiva e aprendizado contínuo.

## 🔥 Gatilho de Ativação Crítico

**ATIVAÇÃO AUTOMÁTICA:** Este protocolo **MUST** ser ativado na **primeira ocorrência** de **QUALQUER erro** que impeça a conclusão de uma sub-tarefa.

### Exemplos de Gatilhos:
- ✅ **JSON malformado** em chamadas de ferramentas MCP
- ✅ **Falhas de autenticação** em APIs
- ✅ **Erros de sintaxe** que quebram execução
- ✅ **Timeouts** em operações críticas
- ✅ **Permissões negadas** em operações de arquivo
- ❌ **NÃO ativar** para warnings ou avisos não-críticos

## 🚨 Procedimento Obrigatório (5 Etapas)

### Etapa 1: Pausa e Diagnóstico Imediato
**MUST** executar imediatamente:
- **PARE** toda execução da tarefa atual
- **ANALISE** a mensagem de erro completa
- **IDENTIFIQUE** a causa raiz do problema
- **DOCUMENTE** o contexto exato do erro

```markdown
## Exemplo de Diagnóstico:
❌ **Erro Detectado:** JSON parse error at line 15
🔍 **Contexto:** Chamada para use_mcp_tool com parâmetros malformados
🎯 **Causa Raiz:** Aspas não fechadas no campo "description"
```

### Etapa 2: Plano de Correção Estruturado
**MUST** formular plano detalhado:
- **DEFINA** ação corretiva específica
- **AVALIE** riscos da correção
- **IDENTIFIQUE** impactos em outras partes
- **ESTABELEÇA** critérios de sucesso

```markdown
## Exemplo de Plano:
✅ **Ação:** Corrigir sintaxe JSON no parâmetro "description"
⚠️ **Risco:** Baixo - correção de sintaxe isolada
🎯 **Critério de Sucesso:** Ferramenta MCP executa sem erro
```

### Etapa 3: Execução da Correção
**MUST** seguir protocolo de execução:
- **SE** ação de **baixo risco**: Execute imediatamente
- **SE** ação de **alto risco**: **PEÇA confirmação** antes de executar
- **APLIQUE** correção de forma incremental
- **VERIFIQUE** resultado imediatamente

**🚨 Ações de Alto Risco (Requerem Confirmação):**
- Modificação de arquivos críticos
- Alteração de configurações de segurança
- Operações que afetam múltiplos sistemas
- Mudanças estruturais no código

### Etapa 4: Registro Obrigatório na Memória
**APÓS correção bem-sucedida**, **MUST** registrar no Knowledge Graph:

```markdown
## Template de Registro:
- **Erro:** [Descrição técnica]
- **Contexto:** [Situação quando ocorreu]
- **Diagnóstico:** [Causa identificada]
- **Solução:** [Ação corretiva aplicada]
- **Prevenção:** [Como evitar no futuro]
- **Timestamp:** [Data/hora da ocorrência]
```

### Etapa 5: Retomada Controlada da Tarefa
**SOMENTE APÓS** registro completo:
- **CONFIRME** que erro foi totalmente resolvido
- **VALIDE** que sistema está funcional
- **RETOME** execução da tarefa original
- **MONITORE** para recorrência do erro

## 🎯 Verificações de Sucesso

### ✅ Protocolo Executado Corretamente Quando:
- Erro foi identificado e pausou execução
- Diagnóstico preciso foi realizado
- Plano de correção foi formulado
- Correção foi aplicada com sucesso
- Registro foi salvo no Knowledge Graph
- Tarefa foi retomada sem problemas

### ❌ Falhas Críticas a Evitar:
- **NEVER** ignore erros esperando que se resolvam
- **NEVER** aplique correções sem diagnóstico
- **NEVER** pule o registro na memória
- **NEVER** retome tarefa antes do registro completo

## 🔄 Integração com Sistema de Regras

### Coordenação com Master Rule
- Este protocolo tem **prioridade alta** no sistema hierárquico
- Integra automaticamente com `completude-verification-protocol.md`
- Utiliza `sequential-thinking-mcp.md` para problemas complexos

### Coordenação com Error Handling V2
- Protocolo V1 (este) é para **primeira ocorrência** de erros
- Protocolo V2 é ativado para **erros recorrentes** (2+ vezes)
- Ambos protocolos são complementares, não substituem um ao outro

## 📊 Métricas de Efetividade

### Indicadores de Sucesso:
- **Taxa de Resolução:** % de erros resolvidos na primeira tentativa
- **Tempo de Recuperação:** Tempo médio entre erro e retomada
- **Recorrência:** % de erros que não se repetem
- **Completude de Registro:** % de erros registrados adequadamente

---

*Este protocolo garante resposta sistemática e aprendizado contínuo com cada erro encontrado, transformando problemas em conhecimento para melhorar eficiência futura.*
