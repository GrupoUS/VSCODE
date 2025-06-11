---
description: Regras para gestão automática de contexto com handoff em 90% de uso de tokens.
author: Sistema GRUPOUS/Cline Rules
version: 1.0
globs: ["**/*"]
tags: ["context-management", "token-usage", "handoff", "task-master"]
alwaysApply: true
---

# Gestão Automática de Contexto - 90% Token Usage
# Integrado com Task Master AI CLI do GRUPO US

**⚠️ MONITORAMENTO OBRIGATÓRIO DE CONTEXTO ⚠️**

## 1. TRIGGER DE HANDOFF - 90% USAGE
Quando o context window usage atingir 90%, você DEVE:
- Completar o passo lógico atual
- Preservar estado do Task Master
- Propor criação de nova task via ask_followup_question

## 2. INTEGRAÇÃO COM TASK MASTER
Antes de criar nova task, SEMPRE:
- Execute: task-master list (para capturar estado atual)
- Execute: task-master next (para identificar próxima tarefa)
- Preserve IDs, dependencies e acceptance criteria

## 3. ESTRUTURA DO CONTEXTO HANDOFF
O bloco <context> DEVE incluir:

### Estado Task Master
- Output completo de task-master list
- Task atual em progresso (ID, status, % completo)
- Dependencies pendentes
- Acceptance criteria parcialmente cumpridos

### Trabalho Completado
- Arquivos criados/modificados com paths
- Comandos executados e resultados
- Decisões técnicas tomadas
- Problemas encontrados e soluções

### Estado do Projeto
- Estrutura de diretórios atual
- Serviços em execução
- Variáveis de ambiente configuradas
- Git status (branch, commits)

### Próximos Passos
- Próxima task do Task Master
- Subtarefas imediatas
- Comandos específicos a executar
- Validações pendentes

### Memory Bank
- Padrões estabelecidos
- Decisões arquiteturais
- Preferências do usuário
- Links e documentação relevante

## 4. PROCESSO DE HANDOFF
1. Detectar 90% usage
2. Encontrar ponto lógico de parada
3. Salvar estado com: task-master save-state (se disponível)
4. Propor nova task com contexto estruturado
5. Na nova sessão: task-master restore-state (se disponível)

## 5. EXEMPLO DE PROPOSTA
<ask_followup_question>

Context usage está em 92%. Completei [tarefa específica].

Estado Task Master:

Task #3 (75% completa): Implementar autenticação
Próxima: Task #4: Configurar Supabase
Deseja criar nova task para continuar, preservando todo o contexto?

["Sim, criar nova task", "Modificar contexto", "Continuar nesta sessão"]
</ask_followup_question>


## 6. REGRAS DE PRESERVAÇÃO
- NUNCA perder IDs de tasks do Task Master
- SEMPRE manter continuidade de arquivos .taskmaster/
- PRESERVAR estrutura scripts/prd.txt
- MANTER sincronização com repositório GitHub
