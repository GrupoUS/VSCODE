# Workflow Otimizado - Protocolo Mestre

Este documento define o workflow padrão obrigatório para execução de tarefas no GRUPO US VIBECODE SYSTEM.

## Workflow Otimizado

1. **Recebimento de Task**
   - Toda task recebida é avaliada quanto à complexidade.
2. **Decomposição Inicial**
   - Se complexidade ≥ 5:
     **Sequential Thinking MCP** decompõe a task em subtarefas lógicas e sugere plano de execução.
   - Se complexidade < 5:
     Task pode ser enviada diretamente ao MCP Shrimp Task Manager.
3. **Coordenação e Distribuição**
   - **MCP Shrimp Task Manager** recebe as subtarefas, organiza o workflow, define responsáveis e integra com Composer/VS Code.
   - Para subtarefas de UI, aciona o **Figma Context MCP** para fornecer contexto visual e assets.
4. **Execução**
   - Subtarefas são atribuídas a agentes (Executor/Coder) conforme especialização.
   - Para subtarefas complexas, pode-se reativar o **Sequential Thinking MCP** para detalhamento adicional.
5. **Validação e Aprendizagem**
   - Após execução, resultados são validados automaticamente.
   - Erros, aprendizados e padrões são registrados em `@project-core/memory/self_correction_log.md`.
6. **Atualização de Memória e Regras**
   - Se necessário, atualize regras em `@project-core/knowledge-base/rules/` e protocolos em `@project-core/rules/`.
7. **Handoff e Integração**
   - Se a task/subtask requer integração entre ambientes (Cursor/VS Code), o MCP Shrimp Task Manager gerencia o handoff e sincronização.

Este workflow é obrigatório para todas as tarefas do sistema.
