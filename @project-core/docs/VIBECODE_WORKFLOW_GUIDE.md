# Guia Rápido: Workflow VIBECODE com Agente Cursor

Este guia explica como usar o sistema de personas para desenvolver de forma eficiente e padronizada.

### O Ciclo de Desenvolvimento em 4 Passos

**1. Análise e Decomposição (O Desenvolvedor)**
Antes de chamar o Agente, pense:

- Qual o objetivo da tarefa?
- Qual a complexidade (1-10)?
- Qual persona principal (`ARCHITECT`, `EXECUTOR`, etc.) devo invocar?

**2. Invocação Rápida do Agente**

- Copie o conteúdo de `@project-core/docs/prompt_template_component.md`.
- Cole no chat do Cursor.
- Preencha os campos `[PREENCHER]`.
- Envie o prompt.

**3. Acompanhamento Interativo por Fases**

- O Agente vai parar após cada fase.
- Revise o trabalho e aprove com um comando simples como "Aprovado, prossiga para a próxima fase" ou peça ajustes.

**4. Finalização e Aprendizado**

- Após o código ser gerado, valide-o.
- **Crucial:** Se algo deu errado ou se aprendeu algo novo, registre em `@project-core/memory/self_correction_log.md`.
- Faça o commit do novo código e também das atualizações no log.
