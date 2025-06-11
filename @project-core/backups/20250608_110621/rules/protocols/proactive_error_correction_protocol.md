---
description: Protocolo de Correção Proativa de Erros (P.C.P.E.) - Sistema de Imunidade a Erros
author: GRUPO US VIBECODE SYSTEM V2.0
version: 1.0
priority: MAXIMUM
globs: ["**/*"]
tags: ["error-prevention", "proactive", "immunity", "learning"]
alwaysApply: true
integrates: ["workflows/error-handling-protocol.md", "memory-bank/self_correction_log.md"]
---

# 🛡️ PROTOCOLO DE CORREÇÃO PROATIVA DE ERROS (P.C.P.E.)

## 📋 OBJETIVO PRINCIPAL

Criar um sistema robusto de **"imunidade a erros"** integrado ao GRUPO US VIBECODE SYSTEM V2.0, onde cada falha se torna uma lição aprendida e uma barreira preventiva para erros futuros. O sistema deve parar, analisar, consultar a memória centralizada, corrigir e registrar o aprendizado antes de continuar.

## 🚨 ATIVAÇÃO OBRIGATÓRIA

### **Triggers de Ativação:**
- **QUALQUER erro detectado** durante execução de tarefas
- **Falhas de comando** ou operações que não completam
- **Warnings críticos** que podem evoluir para erros
- **Padrões de erro recorrentes** identificados

### **Output Obrigatório de Ativação:**
```
🚨 ERRO DETECTADO. Ativando P.C.P.E. - Protocolo de Correção Proativa de Erros
📊 Iniciando análise de causa raiz e consulta à memória centralizada...
```

## 🔄 PROTOCOLO H.A.L.T. OBRIGATÓRIO (5 Passos)

### **Passo 1: HALT - Parar e Isolar**

#### **Ações Obrigatórias:**
- ✅ **Suspender IMEDIATAMENTE** a execução da tarefa atual
- ✅ **Capturar contexto completo**: Comando exato, mensagem de erro, stack trace
- ✅ **Isolar o problema**: Identificar escopo e impacto do erro
- ✅ **Timestamp preciso**: Registrar momento exato da ocorrência

#### **Output Obrigatório:**
```
⏸️ EXECUÇÃO PAUSADA
🕐 Timestamp: [AAAA-MM-DD HH:MM:SS]
📝 Comando que falhou: [comando exato]
❌ Erro capturado: [mensagem completa]
🎯 Escopo identificado: [área afetada]
```

### **Passo 2: ANALYZE - Consulta Obrigatória à Memória**

#### **Sequência de Consulta Obrigatória:**

**PRIMEIRO**: Consultar `memory-bank/self_correction_log.md`
```bash
# Buscar por palavras-chave do erro atual
grep -i "[palavra-chave-erro]" memory-bank/self_correction_log.md
```

**SEGUNDO**: Buscar em `project-core/rules/workflows/error-handling-protocol.md`
```bash
# Verificar padrões conhecidos
grep -i "[tipo-erro]" project-core/rules/workflows/error-handling-protocol.md
```

#### **Resultados Possíveis:**

**✅ Resultado A - Solução Encontrada:**
```
✅ SOLUÇÃO ENCONTRADA NA MEMÓRIA
📅 Referência: Log de [data] - Entrada #[número]
🔧 Solução aplicada anteriormente: [descrição]
⏭️ Pulando para Passo 4 (Aplicação da Correção)
```

**⚠️ Resultado B - Solução Não Encontrada:**
```
⚠️ NENHUMA SOLUÇÃO PRÉVIA ENCONTRADA
🔍 Iniciando análise de causa raiz
📊 Coletando dados para nova entrada no log
⏭️ Prosseguindo para Passo 3 (Análise Profunda)
```

### **Passo 3: LEARN - Análise de Causa Raiz**

#### **Categorização Obrigatória:**
```javascript
const errorCategories = {
  'SINTAXE': 'Erro de sintaxe em código ou comando',
  'REGRA_CODING': 'Violação de regras em coding_standards/',
  'LOGICA': 'Erro de lógica ou fluxo de execução',
  'PERMISSAO': 'Erro de permissões ou configuração',
  'DEPENDENCIA': 'Erro de dependências ou imports',
  'REDE': 'Erro de conectividade ou API',
  'AMBIENTE': 'Erro de configuração de ambiente'
};
```

#### **Análise Obrigatória:**
- ✅ **Identificar categoria** do erro
- ✅ **Formular hipótese** sobre causa raiz
- ✅ **Consultar regras relevantes** em `@project-core/rules/coding_standards/`
- ✅ **Verificar contexto** do projeto e framework

#### **Output Obrigatório:**
```
🔍 ANÁLISE DE CAUSA RAIZ COMPLETA
📂 Categoria: [categoria identificada]
💡 Hipótese: [explicação da causa raiz]
📋 Regras consultadas: [arquivos verificados]
🎯 Contexto: [framework/projeto/situação]
```

### **Passo 4: TROUBLESHOOT - Ação Corretiva**

#### **Aplicação da Correção:**
- ✅ **Aplicar correção identificada** (da memória ou análise)
- ✅ **Re-executar ação** que falhou para verificação
- ✅ **Validar resultado** da correção

#### **Resultados Possíveis:**

**✅ Sucesso:**
```
✅ CORREÇÃO APLICADA COM SUCESSO
🔄 Re-execução bem-sucedida
📈 Problema resolvido
⏭️ Prosseguindo para Passo 5 (Registro)
```

**❌ Falha:**
```
❌ CORREÇÃO FALHOU
🔄 Re-execução ainda apresenta erro
🔍 Reiniciando análise com dados adicionais
⏪ Retornando ao Passo 3 (Análise Aprofundada)
```

### **Passo 5: HALT - Registro Obrigatório**

#### **CRÍTICO**: Entrada Obrigatória no `memory-bank/self_correction_log.md`

**Formato Obrigatório:**
```markdown
### 🛡️ P.C.P.E. - Análise de Correção - [AAAA-MM-DD HH:MM:SS] ###

**1. Tarefa Solicitada:** [descrição completa da tarefa]
**2. Comando/Ação que Falhou:** [comando exato que causou erro]
**3. Saída do Erro:** [mensagem de erro completa]
**4. Categoria do Erro:** [categoria identificada]
**5. Análise da Causa Raiz:** [explicação detalhada]
**6. Ação Corretiva Implementada:** [solução exata aplicada]
**7. Resultado da Correção:** [sucesso/falha e detalhes]
**8. Sugestão de Melhoria para as Regras:** [proposta para coding_standards]
**9. Prevenção Futura:** [como evitar este erro no futuro]
**10. Palavras-chave para Busca:** [tags para facilitar busca futura]

---
```

#### **Output Final Obrigatório:**
```
📝 REGISTRO COMPLETO NO MEMORY BANK
✅ Entrada #[número] criada em self_correction_log.md
🧠 Sistema de imunidade atualizado
🔄 Retomando tarefa original...
```

## 🔗 INTEGRAÇÃO COM SISTEMA EXISTENTE

### **Integração com Error Handling Protocol:**
- **P.C.P.E.** atua como **camada preventiva** sobre o protocolo existente
- **Consulta obrigatória** ao memory bank antes de aplicar resoluções
- **Aprendizado ativo** que alimenta o sistema de conhecimento

### **Integração com Master Rule:**
- **Referência obrigatória** adicionada na seção "4. Protocolos Especiais Integrados"
- **Prioridade máxima** sobre outros protocolos
- **Ativação automática** em qualquer detecção de erro

## 📊 MÉTRICAS DE SUCESSO

### **KPIs do P.C.P.E.:**
- **Redução de Erros Recorrentes**: Target 50% em 30 dias
- **Taxa de Registro**: 100% de erros documentados
- **Tempo de Resolução**: < 5 minutos por erro
- **Taxa de Prevenção**: > 80% de erros similares evitados

### **Monitoramento Contínuo:**
- **Análise semanal** do self_correction_log.md
- **Identificação de padrões** recorrentes
- **Atualização proativa** das regras de coding_standards
- **Evolução contínua** do sistema de imunidade

## ⚡ OTIMIZAÇÃO DE PERFORMANCE

### **Busca Inteligente:**
- **Indexação automática** de palavras-chave no memory bank
- **Cache de soluções** frequentemente utilizadas
- **Busca por similaridade** para erros relacionados

### **Prevenção Proativa:**
- **Análise preditiva** de padrões de erro
- **Alertas preventivos** antes da execução de comandos arriscados
- **Sugestões automáticas** de melhorias no código

---

**🎯 GRUPO US VIBECODE SYSTEM V2.0 - PROTOCOLO DE CORREÇÃO PROATIVA DE ERROS**  
**Sistema de Imunidade a Erros - Versão 1.0**
