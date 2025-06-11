---
description: Guia unificado para gerenciar workflows de desenvolvimento orientados a tarefas usando Task Master.
globs: **/*
alwaysApply: true
---
# Workflow de Desenvolvimento Unificado do Task Master

Este guia descreve o processo típico para usar o Task Master para gerenciar projetos de desenvolvimento de software, consolidando diretrizes de `.cursor/rules/dev_workflow.mdc`, `.windsurfrules` e `.clinerules/master_rule.md`.

## Interação Primária: Servidor MCP vs. CLI

O Task Master oferece duas formas principais de interação:

1.  **Servidor MCP (Recomendado para Ferramentas Integradas)**:
    - Para agentes de IA e ambientes de desenvolvimento integrados (como Cursor), a interação via **servidor MCP é o método preferencial**.
    - O servidor MCP expõe a funcionalidade do Task Master através de um conjunto de ferramentas (ex: `get_tasks`, `add_subtask`).
    - Este método oferece melhor desempenho, troca de dados estruturada e tratamento de erros mais rico em comparação com a análise da CLI.
    - Uma lista abrangente e descrição das ferramentas MCP e seus comandos CLI correspondentes pode ser encontrada em [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md).
    - **Reinicie o servidor MCP** se a lógica central em `scripts/modules` ou as definições de ferramentas/funções diretas do MCP mudarem.

2.  **CLI `task-master` (Para Usuários e Fallback)**:
    - O comando global `task-master` fornece uma interface amigável para interação direta no terminal.
    - Também pode servir como fallback se o servidor MCP estiver inacessível ou uma função específica não for exposta via MCP.
    - Instale globalmente com `npm install -g claude-task-master` ou use localmente via `npx claude-task-master ...`.
    - Os comandos da CLI frequentemente espelham as ferramentas MCP (ex: `task-master list` corresponde a `get_tasks`).
    - Consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md) para uma referência detalhada de comandos.

## Processo Padrão do Workflow de Desenvolvimento

-   Inicie novos projetos executando a ferramenta `initialize_project` / `task-master init` ou `parse_prd` / `task-master parse-prd --input='<prd-file.txt>'` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) para gerar o `tasks.json` inicial.
-   Comece as sessões de codificação com `get_tasks` / `task-master list` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) para ver as tarefas atuais, status e IDs.
-   Determine a próxima tarefa a ser trabalhada usando `next_task` / `task-master next` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)).
-   Analise a complexidade da tarefa com `analyze_project_complexity` / `task-master analyze-complexity --research` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) antes de decompor as tarefas.
-   Revise o relatório de complexidade usando `complexity_report` / `task-master complexity-report` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)).
-   Selecione as tarefas com base nas dependências (todas marcadas como 'done'), nível de prioridade e ordem de ID.
-   Esclareça as tarefas verificando os arquivos de tarefa no diretório `tasks/` ou pedindo a entrada do usuário.
-   Visualize detalhes específicos da tarefa usando `get_task` / `task-master show <id>` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) para entender os requisitos de implementação.
-   Decomponha tarefas complexas usando `expand_task` / `task-master expand --id=<id> --force --research` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) com flags apropriadas como `--force` (para substituir subtarefas existentes) e `--research`.
-   Limpe as subtarefas existentes, se necessário, usando `clear_subtasks` / `task-master clear-subtasks --id=<id>` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) antes de regenerar.
-   Implemente o código seguindo os detalhes da tarefa, dependências e padrões do projeto.
-   Verifique as tarefas de acordo com as estratégias de teste antes de marcar como concluídas.
-   Marque as tarefas concluídas com `set_task_status` / `task-master set-status --id=<id> --status=done` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)).
-   Atualize as tarefas dependentes quando a implementação diferir do plano original usando `update` / `task-master update --from=<id> --prompt="..."` ou `update_task` / `task-master update-task --id=<id> --prompt="..."` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)).
-   Adicione novas tarefas descobertas durante a implementação usando `add_task` / `task-master add-task --prompt="..." --research` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)).
-   Adicione novas subtarefas conforme necessário usando `add_subtask` / `task-master add-subtask --parent=<id> --title="..."` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)).
-   Anexe notas ou detalhes às subtarefas usando `update_subtask` / `task-master update-subtask --id=<subtaskId> --prompt='Adicionar notas de implementação aqui...\nMais detalhes...'` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)).
-   Gere arquivos de tarefa com `generate` / `task-master generate` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) após atualizar `tasks.json`.
-   Mantenha uma estrutura de dependência válida com as ferramentas `add_dependency`/`remove_dependency` ou os comandos `task-master add-dependency`/`remove-dependency`, `validate_dependencies` / `task-master validate-dependencies`, e `fix_dependencies` / `task-master fix-dependencies` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) quando necessário.
-   Respeite as cadeias de dependência e as prioridades das tarefas ao selecionar o trabalho.
-   Relate o progresso regularmente usando `get_tasks` / `task-master list`.
-   Reorganize as tarefas conforme necessário usando `move_task` / `task-master move --from=<id> --to=<id>` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) para alterar a hierarquia ou a ordem das tarefas.

## Análise de Complexidade da Tarefa

-   Execute `analyze_project_complexity` / `task-master analyze-complexity --research` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) para uma análise abrangente.
-   Revise o relatório de complexidade via `complexity_report` / `task-master complexity-report` (consulte [`taskmaster-reference.md`](.clinerules/tooling/taskmaster-reference.md)) para uma versão formatada e legível.
-   Concentre-se nas tarefas com as maiores pontuações de complexidade (8-10) para uma decomposição detalhada.
-   Use os resultados da análise para determinar a alocação apropriada de subtarefas.
-   Observe que os relatórios são usados automaticamente pela ferramenta/comando `expand_task`.

## Processo de Decomposição da Tarefa

-   Use `expand_task` / `task-master expand --id=<id>`. Ele usa automaticamente o relatório de complexidade, se encontrado, caso contrário, gera o número padrão de subtarefas.
-   Use `--num=<number>` para especificar um número explícito de subtarefas, substituindo os padrões ou as recomendações do relatório de complexidade.
-   Adicione a flag `--research` para aproveitar a Perplexity AI para uma expansão baseada em pesquisa.
-   Adicione a flag `--force` para limpar as subtarefas existentes antes de gerar novas (o padrão é anexar).
-   Use `--prompt="<context>"` para fornecer contexto adicional quando necessário.
-   Revise e ajuste as subtarefas geradas conforme necessário.
-   Use a ferramenta `expand_all` ou `task-master expand --all` para expandir várias tarefas pendentes de uma vez, respeitando flags como `--force` e `--research`.
-   Se as subtarefas precisarem de substituição completa (independentemente da flag `--force` em `expand`), limpe-as primeiro com `clear_subtasks` / `task-master clear-subtasks --id=<id>`.

## Tratamento de Desvios de Implementação

-   Quando a implementação difere significativamente da abordagem planejada.
-   Quando tarefas futuras precisam de modificação devido às escolhas de implementação atuais.
-   Quando novas dependências ou requisitos surgem.
-   Use `update` / `task-master update --from=<futureTaskId> --prompt='<explanation>\nAtualizar contexto...' --research` para atualizar várias tarefas futuras.
-   Use `update_task` / `task-master update-task --id=<taskId> --prompt='<explanation>\nAtualizar contexto...' --research` para atualizar uma única tarefa específica.

## Gerenciamento de Status da Tarefa

-   Use 'pending' para tarefas prontas para serem trabalhadas.
-   Use 'done' para tarefas concluídas e verificadas.
-   Use 'deferred' para tarefas adiadas.
-   Adicione valores de status personalizados conforme necessário para fluxos de trabalho específicos do projeto.

## Campos da Estrutura da Tarefa

-   **id**: Identificador único para a tarefa (Exemplo: `1`, `1.1`)
-   **title**: Título breve e descritivo (Exemplo: `"Inicializar Repositório"`)
-   **description**: Resumo conciso do que a tarefa envolve (Exemplo: `"Criar um novo repositório, configurar a estrutura inicial."`)
-   **status**: Estado atual da tarefa (Exemplo: `"pending"`, `"done"`, `"deferred"`)
-   **dependencies**: IDs de tarefas pré-requisito (Exemplo: `[1, 2.1]`)
    - As dependências são exibidas com indicadores de status (✅ para concluídas, ⏱️ para pendentes)
    - Isso ajuda a identificar rapidamente quais tarefas pré-requisito estão bloqueando o trabalho.
-   **priority**: Nível de importância (Exemplo: `"high"`, `"medium"`, `"low"`)
-   **details**: Instruções de implementação detalhadas (Exemplo: `"Usar ID/segredo do cliente GitHub, lidar com callback, definir token de sessão."`)
-   **testStrategy**: Abordagem de verificação (Exemplo: `"Implantar e chamar o endpoint para confirmar a resposta 'Hello World'."`)
-   **subtasks**: Lista de tarefas menores e mais específicas (Exemplo: `[{"id": 1, "title": "Configurar OAuth", ...}]`)

## Gerenciamento de Configuração (Atualizado)

A configuração do Taskmaster é gerenciada por dois mecanismos principais:

1.  **Arquivo `.taskmaster/config.json` (Primário):**
    *   Localizado na raiz do diretório do projeto.
    *   Armazena a maioria das configurações: seleções de modelo de IA (principal, pesquisa, fallback), parâmetros (tokens máximos, temperatura), nível de log, subtarefas/prioridade padrão, nome do projeto, etc.
    *   **Gerenciado via comando `task-master models --setup`.** Não edite manualmente, a menos que saiba o que está fazendo.
    *   **Visualize/Defina modelos específicos via comando `task-master models` ou ferramenta MCP `models`.**
    *   Criado automaticamente quando você executa `task-master models --setup` pela primeira vez.

2.  **Variáveis de Ambiente (`.env` / `mcp.json`):**
    *   Usadas **apenas** para chaves de API sensíveis e URLs de endpoint específicas.
    *   Coloque as chaves de API (uma por provedor) em um arquivo `.env` na raiz do projeto para uso da CLI.
    *   Para integração MCP/Cursor, configure essas chaves na seção `env` do seu arquivo `.cursor/mcp.json`.
    *   Chaves/variáveis disponíveis: Consulte `assets/env.example` ou a seção de Configuração na referência de comandos (anteriormente vinculada a `taskmaster.mdc`).

**Importante:** As configurações que não são chaves de API (como seleções de modelo, `MAX_TOKENS`, `TASKMASTER_LOG_LEVEL`) **não são mais configuradas via variáveis de ambiente**. Use o comando `task-master models` (ou `--setup` para configuração interativa) ou a ferramenta MCP `models`.
**Se os comandos de IA falharem no MCP**, verifique se a chave de API para o provedor selecionado está presente na seção `env` do `.cursor/mcp.json`.
**Se os comandos de IA falharem na CLI**, verifique se a chave de API para o provedor selecionado está presente no arquivo `.env` na raiz do projeto.

## Análise de Código e Técnicas de Refatoração

-   **Busca de Funções de Nível Superior**:
    - Útil para entender a estrutura do módulo ou planejar refatorações.
    - Use grep/ripgrep para encontrar funções/constantes exportadas:
      `rg "export (async function|function|const) \w+"` ou padrões semelhantes.
    - Pode ajudar a comparar funções entre arquivos durante migrações ou identificar potenciais conflitos de nomenclatura.
