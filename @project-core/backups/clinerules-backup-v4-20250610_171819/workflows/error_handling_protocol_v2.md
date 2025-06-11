---
description: Protocolo complementar para tratamento de erros recorrentes (Regra das 2 Tentativas)
author: Sistema GRUPOUS/Cline Rules
version: 2.0
globs: ["**/*"]
tags: ["error-handling", "recurrent-errors", "auto-correction", "complementary", "protocol"]
alwaysApply: true
---

# 🔄 Protocolo de Tratamento de Erros Recorrentes (V2)

## Objetivo

Este protocolo complementar define o procedimento obrigatório para tratamento sistemático de erros recorrentes, implementando a **Regra das 2 Tentativas** para diagnóstico aprofundado e correção definitiva quando o mesmo erro se repete.

## 🚨 Relação com Protocolo Principal

**PROTOCOLO BASE:** O protocolo principal em `error_handling_protocol.md` permanece **SEMPRE ativo** para resposta imediata a erros críticos.

**PROTOCOLO COMPLEMENTAR:** Este protocolo é ativado **ADICIONALMENTE** para casos específicos de recorrência.

## ⚡ Gatilho de Ativação: Regra das 2 Tentativas

**ATIVAÇÃO AUTOMÁTICA:** Este protocolo **MUST** ser ativado quando encontrar o **mesmo erro específico** por **2 (duas) ou mais vezes consecutivas** ao tentar executar uma única sub-tarefa.

### 🎯 Critérios de Identificação de "Mesmo Erro":
- ✅ **Mensagem de erro idêntica** ou substancialmente similar
- ✅ **Contexto operacional similar** (mesma ferramenta, mesma operação)
- ✅ **Falha no mesmo ponto** do processo
- ❌ **NÃO aplicar** para erros diferentes mesmo que relacionados

### Exemplos de Erros Recorrentes:
```bash
# Exemplo 1: Permissão negada recorrente
❌ Tentativa 1: "Permission denied: /var/log/app.log"
❌ Tentativa 2: "Permission denied: /var/log/app.log"
🚨 ATIVAR PROTOCOLO V2

# Exemplo 2: Diretório não encontrado recorrente
❌ Tentativa 1: "No such file or directory: /tmp/uploads"
❌ Tentativa 2: "No such file or directory: /tmp/uploads"
🚨 ATIVAR PROTOCOLO V2
```

## 🚨 Procedimento Obrigatório (5 Etapas Aprimoradas)

### Etapa 1: Pausa e Diagnóstico Aprofundado
**MUST** executar análise expandida:
- **PARE** imediatamente a execução da tarefa atual
- **ANALISE** a mensagem de erro completa e contexto
- **COMPARE** com tentativas anteriores para identificar padrões
- **IDENTIFIQUE** fatores ambientais ou configuracionais

```markdown
## Exemplo de Diagnóstico Aprofundado:
❌ **Erro Recorrente:** Permission denied: /var/log/app.log
🔍 **Padrão Identificado:** Mesmo erro em 2 tentativas consecutivas
🎯 **Análise Ambiental:** Processo rodando como usuário 'node', arquivo pertence a 'root'
🔧 **Causa Raiz:** Permissões inadequadas do sistema de arquivos
```

### Etapa 2: Plano de Correção Sistemática
**MUST** formular plano mais robusto que tentativas anteriores:

```markdown
## Categorias de Correção Sistemática:

### 🔐 Erros de Permissão:
✅ **Estratégia:** Executar com `sudo` ou alterar ownership
⚠️ **Risco:** Médio - requer validação de segurança

### 📁 Diretório/Arquivo Não Encontrado:
✅ **Estratégia:** Criar estrutura necessária com `mkdir -p`
⚠️ **Risco:** Baixo - operação de criação isolada

### 🌐 Falhas de API/MCP:
✅ **Estratégia:** Verificar conectividade, credenciais, método alternativo
⚠️ **Risco:** Baixo - validação sem modificação

### ⚙️ Comando/Sintaxe Inválida:
✅ **Estratégia:** Consultar documentação, corrigir sintaxe
⚠️ **Risco:** Baixo - correção de formato
```

### Etapa 3: Execução da Correção Definitiva
**MUST** aplicar correção mais robusta:
- **SE** ação de **baixo/médio risco**: Execute imediatamente
- **SE** ação de **alto risco**: **PEÇA confirmação** antes de executar
- **APLIQUE** correção que resolva a causa raiz
- **VALIDE** efetividade imediatamente

**🚨 Ações de Alto Risco (Requerem Confirmação):**
- Alteração de permissões de sistema (`chmod`, `chown`)
- Modificação de configurações de segurança
- Instalação de dependências ou pacotes
- Mudanças estruturais no environment

### Etapa 4: Registro Detalhado na Memória
**APÓS correção bem-sucedida**, **MUST** registrar no Knowledge Graph com detalhes expandidos:

```markdown
## Template de Registro V2 (Erros Recorrentes):
- **Erro:** [Mensagem exata do erro]
- **Recorrência:** [Número de tentativas falhadas]
- **Contexto:** [Situação operacional completa]
- **Padrão:** [O que se repetiu entre tentativas]
- **Diagnóstico Aprofundado:** [Causa raiz identificada]
- **Solução Definitiva:** [Ação corretiva robusta aplicada]
- **Prevenção:** [Como evitar recorrência]
- **Lições Aprendidas:** [Insights para casos similares]
- **Timestamp:** [Data/hora da resolução]
```

### Etapa 5: Retomada com Monitoramento
**SOMENTE APÓS** registro completo:
- **CONFIRME** que erro foi **definitivamente** resolvido
- **VALIDE** que solução não introduziu novos problemas
- **ESTABELEÇA** monitoramento para evitar nova recorrência
- **RETOME** execução da tarefa original

## 🎯 Verificações de Sucesso Aprimoradas

### ✅ Protocolo V2 Executado Corretamente Quando:
- Padrão de recorrência foi identificado corretamente
- Diagnóstico aprofundado revelou causa raiz
- Solução definitiva foi aplicada (não apenas paliativa)
- Erro não se repetiu após correção
- Registro completo foi salvo no Knowledge Graph
- Sistema permanece estável após correção

### ❌ Falhas Críticas a Evitar:
- **NEVER** aplique a mesma solução que já falhou antes
- **NEVER** ignore padrões de recorrência
- **NEVER** use soluções paliativas para erros recorrentes
- **NEVER** pule análise aprofundada em favor de rapidez

## 🔄 Integração e Hierarquia

### Hierarquia de Ativação:
1. **🚨 Erro Crítico Imediato** → Protocolo Principal (V1)
2. **🔄 Erro Recorrente (2+ vezes)** → Protocolo Complementar (V2)
3. **📚 Ambos registram no Knowledge Graph** para aprendizado futuro

### Coordenação entre Protocolos:
- **V1 e V2 são COMPLEMENTARES**, não se substituem
- **V1** foca em resposta imediata e primeira ocorrência
- **V2** foca em diagnóstico aprofundado e solução definitiva
- **Ambos** utilizam o mesmo sistema de Knowledge Graph

### Integração com Sistema de Regras:
- Coordena com `master_rule.md` para escalation se necessário
- Utiliza `sequential-thinking-mcp.md` para análise complexa de padrões
- Integra com `completude-verification-protocol.md` para validação final

## 📊 Métricas de Efetividade V2

### Indicadores Específicos para Erros Recorrentes:
- **Taxa de Resolução Definitiva:** % de erros recorrentes resolvidos permanentemente
- **Redução de Recorrência:** % de diminuição em repetições do mesmo erro
- **Tempo de Diagnóstico Aprofundado:** Tempo médio para identificar causa raiz
- **Efetividade de Soluções:** % de soluções que impedem nova recorrência

---

*Este protocolo complementar garante que erros recorrentes sejam tratados com análise aprofundada e soluções definitivas, não apenas correções paliativas, transformando padrões problemáticos em conhecimento para prevenção futura.*
