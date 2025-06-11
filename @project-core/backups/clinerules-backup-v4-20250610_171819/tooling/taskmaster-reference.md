---
description: Referência abrangente para ferramentas MCP e comandos CLI do Taskmaster.
globs: **/*
alwaysApply: true
---
# Referência de Ferramentas e Comandos do Taskmaster

Este documento fornece uma referência detalhada para interagir com o Taskmaster, cobrindo tanto as ferramentas MCP recomendadas, adequadas para integrações como o Cursor, quanto os comandos CLI `task-master` correspondentes, projetados para interação direta do usuário ou fallback.

**Nota:** Para interagir com o Taskmaster programaticamente ou via ferramentas integradas, o uso das **ferramentas MCP é fortemente recomendado** devido ao melhor desempenho, dados estruturados e tratamento de erros. Os comandos CLI servem como uma alternativa amigável ao usuário e fallback. 

**Importante:** Várias ferramentas MCP envolvem processamento de IA... As ferramentas alimentadas por IA incluem `parse_prd`, `analyze_project_complexity`, `update_subtask`, `update_task`, `update`, `expand_all`, `expand_task` e `add_task`.

---

## Inicialização e Configuração

### 1. Inicializar Projeto (`init`)

*   **Ferramenta:** `initialize_project`
*   **Comando CLI:** `task-master init [opções]`
*   **Descrição:** `Configura a estrutura básica de arquivos e a configuração do Taskmaster no diretório atual para um novo projeto.`
*   **Principais Opções CLI:**
    *   `--name <nome>`: `Define o nome do seu projeto na configuração do Taskmaster.`
    *   `--description <texto>`: `Fornece uma breve descrição para o seu projeto.`
    *   `--version <versão>`: `Define a versão inicial do seu projeto, por exemplo, '0.1.0'.`
    *   `-y, --yes`: `Inicializa o Taskmaster rapidamente usando as configurações padrão sem prompts interativos.`
*   **Uso:** Execute isso uma vez no início de um novo projeto.
*   **Descrição da Variante MCP:** `Configura a estrutura básica de arquivos e a configuração do Taskmaster no diretório atual para um novo projeto executando o comando 'task-master init'.`
*   **Principais Parâmetros/Opções MCP:**
    *   `projectName`: `Define o nome do seu projeto.` (CLI: `--name <nome>`)
    *   `projectDescription`: `Fornece uma breve descrição para o seu projeto.` (CLI: `--description <texto>`)
    *   `projectVersion`: `Define a versão inicial do seu projeto, por exemplo, '0.1.0'.` (CLI: `--version <versão>`)
    *   `authorName`: `Nome do autor.` (CLI: `--author <autor>`)
    *   `skipInstall`: `Ignora a instalação de dependências. O padrão é false.` (CLI: `--skip-install`)
    *   `addAliases`: `Adiciona aliases de shell tm e taskmaster. O padrão é false.` (CLI: `--aliases`)
    *   `yes`: `Ignora prompts e usa padrões/argumentos fornecidos. O padrão é false.` (CLI: `-y, --yes`)
*   **Uso:** Execute isso uma vez no início de um novo projeto, tipicamente via uma ferramenta integrada como o Cursor. Opera no diretório de trabalho atual do servidor MCP.
*   **Importante:** Uma vez concluído, você *DEVE* analisar um PRD para gerar tarefas. Não haverá arquivos de tarefas até então. O próximo passo após a inicialização deve ser criar um PRD usando o exemplo de PRD em .taskmaster/templates/example_prd.txt.

### 2. Analisar PRD (`parse_prd`)

*   **Ferramenta MCP:** `parse_prd`
*   **Comando CLI:** `task-master parse-prd [arquivo] [opções]`
*   **Descrição:** `Analisa um Documento de Requisitos de Produto, PRD, ou arquivo de texto com o Taskmaster para gerar automaticamente um conjunto inicial de tarefas em tasks.json.`
*   **Principais Parâmetros/Opções:**
    *   `input`: `Caminho para o seu PRD ou arquivo de texto de requisitos que o Taskmaster deve analisar para tarefas.` (CLI: `[arquivo]` posicional ou `-i, --input <arquivo>`)
    *   `output`: `Especifica onde o Taskmaster deve salvar o arquivo 'tasks.json' gerado. O padrão é '.taskmaster/tasks/tasks.json'.` (CLI: `-o, --output <arquivo>`)
    *   `numTasks`: `Número aproximado de tarefas de nível superior que o Taskmaster deve tentar gerar a partir do documento.` (CLI: `-n, --num-tasks <número>`)
    *   `force`: `Use isso para permitir que o Taskmaster sobrescreva um 'tasks.json' existente sem pedir confirmação.` (CLI: `-f, --force`)
*   **Uso:** Útil para iniciar um projeto a partir de um documento de requisitos existente.
*   **Notas:** O Task Master aderirá estritamente a quaisquer requisitos específicos mencionados no PRD, como bibliotecas, schemas de banco de dados, frameworks, pilhas de tecnologia, etc., preenchendo quaisquer lacunas onde o PRD não estiver totalmente especificado. As tarefas são projetadas para fornecer o caminho de implementação mais direto, evitando o excesso de engenharia.
*   **Importante:** Esta ferramenta MCP faz chamadas de IA e pode levar até um minuto para ser concluída. Por favor, informe os usuários para aguardarem enquanto a operação está em andamento. Se o usuário não tiver um PRD, sugira discutir sua ideia e, em seguida, use o exemplo de PRD em `.taskmaster/templates/example_prd.txt` como um modelo para criar o PRD com base em sua ideia, para uso com `parse-prd`.

---

## Configuração do Modelo de IA

### 2. Gerenciar Modelos (`models`)
*   **Ferramenta MCP:** `models`
*   **Comando CLI:** `task-master models [opções]`
*   **Descrição:** `Visualiza a configuração atual do modelo de IA ou define modelos específicos para diferentes funções (principal, pesquisa, fallback). Permite definir IDs de modelo personalizados para Ollama e OpenRouter.`
*   **Principais Parâmetros/Opções MCP:**
    *   `setMain <model_id>`: `Define o ID do modelo principal para geração/atualização de tarefas.` (CLI: `--set-main <model_id>`)
    *   `setResearch <model_id>`: `Define o ID do modelo para operações baseadas em pesquisa.` (CLI: `--set-research <model_id>`)
    *   `setFallback <model_id>`: `Define o ID do modelo a ser usado se o principal falhar.` (CLI: `--set-fallback <model_id>`)
    *   `ollama <boolean>`: `Indica que o ID do modelo definido é um modelo Ollama personalizado.` (CLI: `--ollama`)
    *   `openrouter <boolean>`: `Indica que o ID do modelo definido é um modelo OpenRouter personalizado.` (CLI: `--openrouter`)
    *   `listAvailableModels <boolean>`: `Se true, lista os modelos disponíveis que não estão atualmente atribuídos a uma função.` (CLI: Sem equivalente direto; CLI lista os disponíveis automaticamente)
    *   `projectRoot <string>`: `Opcional. Caminho absoluto para o diretório raiz do projeto.` (CLI: Determinado automaticamente)
*   **Principais Opções CLI:**
    *   `--set-main <model_id>`: `Define o modelo principal.`
    *   `--set-research <model_id>`: `Define o modelo de pesquisa.`
    *   `--set-fallback <model_id>`: `Define o modelo de fallback.`
    *   `--ollama`: `Especifica que o ID do modelo fornecido é para Ollama (use com --set-*).`
    *   `--openrouter`: `Especifica que o ID do modelo fornecido é para OpenRouter (use com --set-*). Valida contra a API do OpenRouter.`
    *   `--setup`: `Executa a configuração interativa para configurar modelos, incluindo IDs personalizados de Ollama/OpenRouter.`
*   **Uso (MCP):** Chame sem flags de conjunto para obter a configuração atual. Use `setMain`, `setResearch`, ou `setFallback` com um ID de modelo válido para atualizar a configuração. Use `listAvailableModels: true` para obter uma lista de modelos não atribuídos. Para definir um modelo personalizado, forneça o ID do modelo e defina `ollama: true` ou `openrouter: true`.
*   **Uso (CLI):** Execute sem flags para visualizar a configuração atual e os modelos disponíveis. Use flags de conjunto para atualizar funções específicas. Use `--setup` para configuração guiada, incluindo modelos personalizados. Para definir um modelo personalizado via flags, use `--set-<função>=<model_id>` junto com `--ollama` ou `--openrouter`.
*   **Notas:** A configuração é armazenada em `.taskmaster/config.json` na raiz do projeto. Este comando/ferramenta modifica esse arquivo. Use `listAvailableModels` ou `task-master models` para ver os modelos suportados internamente. Os modelos personalizados do OpenRouter são validados contra sua API ao vivo. Os modelos personalizados do Ollama não são validados ao vivo.
*   **Nota da API:** As chaves de API para os provedores de IA selecionados (com base em seu modelo) precisam existir no arquivo mcp.json para serem acessíveis no contexto MCP. As chaves de API devem estar presentes no arquivo .env local para que a CLI possa lê-las.
*   **Custos do modelo:** Os custos nos modelos suportados são expressos em dólares. Um valor de entrada/saída de 3 é $3,00. Um valor de 0,8 é $0,80.
*   **Aviso:** NÃO EDITE MANUALMENTE O ARQUIVO .taskmaster/config.json. Use os comandos incluídos no formato MCP ou CLI conforme necessário. Sempre priorize as ferramentas MCP quando disponíveis e use a CLI como fallback.

---

## Listagem e Visualização de Tarefas

### 3. Obter Tarefas (`get_tasks`)

*   **Ferramenta MCP:** `get_tasks`
*   **Comando CLI:** `task-master list [opções]`
*   **Descrição:** `Lista suas tarefas do Taskmaster, opcionalmente filtrando por status e mostrando subtarefas.`
*   **Principais Parâmetros/Opções:**
    *   `status`: `Mostra apenas as tarefas do Taskmaster que correspondem a este status, por exemplo, 'pending' ou 'done'.` (CLI: `-s, --status <status>`)
    *   `withSubtasks`: `Inclui subtarefas recuadas sob suas tarefas pai na lista.` (CLI: `--with-subtasks`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Obtenha uma visão geral do status do projeto, frequentemente usado no início de uma sessão de trabalho.

### 4. Obter Próxima Tarefa (`next_task`)

*   **Ferramenta MCP:** `next_task`
*   **Comando CLI:** `task-master next [opções]`
*   **Descrição:** `Pede ao Taskmaster para mostrar a próxima tarefa disponível em que você pode trabalhar, com base no status e nas dependências concluídas.`
*   **Principais Parâmetros/Opções:**
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Identifique o que trabalhar em seguida de acordo com o plano.

### 5. Obter Detalhes da Tarefa (`get_task`)

*   **Ferramenta MCP:** `get_task`
*   **Comando CLI:** `task-master show [id] [opções]`
*   **Descrição:** `Exibe informações detalhadas para uma tarefa ou subtarefa específica do Taskmaster por seu ID.`
*   **Principais Parâmetros/Opções:**
    *   `id`: `Obrigatório. O ID da tarefa do Taskmaster, por exemplo, '15', ou subtarefa, por exemplo, '15.2', que você deseja visualizar.` (CLI: `[id]` posicional ou `-i, --id <id>`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Entenda todos os detalhes, notas de implementação e estratégia de teste para uma tarefa específica antes de iniciar o trabalho.

---

## Criação e Modificação de Tarefas

### 6. Adicionar Tarefa (`add_task`)

*   **Ferramenta MCP:** `add_task`
*   **CLI Command:** `task-master add-task [opções]`
*   **Description:** `Adiciona uma nova tarefa ao Taskmaster descrevendo-a; a IA a estruturará.`
*   **Principais Parâmetros/Opções:**
    *   `prompt`: `Obrigatório. Descreva a nova tarefa que você deseja que o Taskmaster crie, por exemplo, "Implementar autenticação de usuário usando JWT".` (CLI: `-p, --prompt <texto>`)
    *   `dependencies`: `Especifica os IDs de quaisquer tarefas do Taskmaster que devem ser concluídas antes que esta nova possa começar, por exemplo, '12,14'.` (CLI: `-d, --dependencies <ids>`)
    *   `priority`: `Define a prioridade para a nova tarefa: 'high', 'medium' ou 'low'. O padrão é 'medium'.` (CLI: `--priority <prioridade>`)
    *   `research`: `Permite que o Taskmaster use a função de pesquisa para uma criação de tarefa potencialmente mais informada.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Adicione rapidamente tarefas recém-identificadas durante o desenvolvimento.
*   **Importante:** Esta ferramenta MCP faz chamadas de IA e pode levar até um minuto para ser concluída. Por favor, informe os usuários para aguardarem enquanto a operação está em andamento.

### 7. Adicionar Subtarefa (`add_subtask`)

*   **MCP Tool:** `add_subtask`
*   **CLI Command:** `task-master add-subtask [opções]`
*   **Description:** `Adiciona uma nova subtarefa a uma tarefa pai do Taskmaster, ou converte uma tarefa existente em uma subtarefa.`
*   **Principais Parâmetros/Opções:**
    *   `id` / `parent`: `Obrigatório. O ID da tarefa do Taskmaster que será a pai.` (MCP: `id`, CLI: `-p, --parent <id>`)
    *   `taskId`: `Use isso se você deseja converter uma tarefa de nível superior existente do Taskmaster em uma subtarefa do pai especificado.` (CLI: `-i, --task-id <id>`)
    *   `title`: `Obrigatório se não estiver usando taskId. O título para a nova subtarefa que o Taskmaster deve criar.` (CLI: `-t, --title <título>`)
    *   `description`: `Uma breve descrição para a nova subtarefa.` (CLI: `-d, --description <texto>`)
    *   `details`: `Fornece notas de implementação ou detalhes para a nova subtarefa.` (CLI: `--details <texto>`)
    *   `dependencies`: `Especifica IDs de outras tarefas ou subtarefas, por exemplo, '15' ou '16.1', que devem ser feitas antes desta nova subtarefa.` (CLI: `--dependencies <ids>`)
    *   `status`: `Define o status inicial para a nova subtarefa. O padrão é 'pending'.` (CLI: `-s, --status <status>`)
    *   `skipGenerate`: `Impede que o Taskmaster regenere automaticamente os arquivos de tarefa markdown após adicionar a subtarefa.` (CLI: `--skip-generate`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Divida tarefas manualmente ou reorganize tarefas existentes.

### 8. Atualizar Tarefas (`update`)

*   **MCP Tool:** `update`
*   **CLI Command:** `task-master update [opções]`
*   **Description:** `Atualiza várias tarefas futuras no Taskmaster com base em novo contexto ou alterações, começando de um ID de tarefa específico.`
*   **Principais Parâmetros/Opções:**
    *   `from`: `Obrigatório. O ID da primeira tarefa que o Taskmaster deve atualizar. Todas as tarefas com este ID ou superior que não estão 'done' serão consideradas.` (CLI: `--from <id>`)
    *   `prompt`: `Obrigatório. Explica a alteração ou o novo contexto para o Taskmaster aplicar às tarefas, por exemplo, "Estamos agora usando React Query em vez de Redux Toolkit para busca de dados".` (CLI: `-p, --prompt <texto>`)
    *   `research`: `Permite que o Taskmaster use a função de pesquisa para uma atualização mais informada. Requer chave de API apropriada.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Lida com alterações significativas de implementação ou pivôs que afetam várias tarefas futuras. Exemplo CLI: `task-master update --from='18' --prompt='Switching to React Query.\nNeed to refactor data fetching...'`
*   **Importante:** Esta ferramenta MCP faz chamadas de IA e pode levar até um minuto para ser concluída. Por favor, informe os usuários para aguardarem enquanto a operação está em andamento.

### 9. Atualizar Tarefa (`update_task`)

*   **MCP Tool:** `update_task`
*   **CLI Command:** `task-master update-task [opções]`
*   **Description:** `Modifica uma tarefa ou subtarefa específica do Taskmaster por seu ID, incorporando novas informações ou alterações.`
*   **Principais Parâmetros/Opções:**
    *   `id`: `Obrigatório. O ID específico da tarefa do Taskmaster, por exemplo, '15', ou subtarefa, por exemplo, '15.2', que você deseja atualizar.` (CLI: `-i, --id <id>`)
    *   `prompt`: `Obrigatório. Explica as alterações específicas ou fornece as novas informações que o Taskmaster deve incorporar a esta tarefa.` (CLI: `-p, --prompt <texto>`)
    *   `research`: `Permite que o Taskmaster use a função de pesquisa para uma atualização mais informada. Requer chave de API apropriada.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Refina uma tarefa específica com base em nova compreensão ou feedback. Exemplo CLI: `task-master update-task --id='15' --prompt='Clarification: Use PostgreSQL em vez de MySQL.\nUpdate schema details...'`
*   **Importante:** Esta ferramenta MCP faz chamadas de IA e pode levar até um minuto para ser concluída. Por favor, informe os usuários para aguardarem enquanto a operação está em andamento.

### 10. Atualizar Subtarefa (`update_subtask`)

*   **MCP Tool:** `update_subtask`
*   **CLI Command:** `task-master update-subtask [options]`
*   **Description:** `Anexa notas ou detalhes com carimbo de data/hora a uma subtarefa específica do Taskmaster sem sobrescrever o conteúdo existente. Destinado ao registro iterativo da implementação.`
*   **Key Parameters/Options:**
    *   `id`: `Required. The specific ID of the Taskmaster subtask, e.g., '15.2', you want to add information to.` (CLI: `-i, --id <id>`)
    *   `prompt`: `Required. Provide the information or notes Taskmaster should append to the subtask's details. Ensure this adds *new* information not already present.` (CLI: `-p, --prompt <text>`)
    *   `research`: `Enable Taskmaster to use the research role for more informed updates. Requires appropriate API key.` (CLI: `-r, --research`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Add implementation notes, code snippets, or clarifications to a subtask during development. Before calling, review the subtask's current details to append only fresh insights, helping to build a detailed log of the implementation journey and avoid redundancy. Example CLI: `task-master update-subtask --id='15.2' --prompt='Discovered that the API requires header X.\nImplementation needs adjustment...'`
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress.

### 11. Set Task Status (`set_task_status`)

*   **MCP Tool:** `set_task_status`
*   **CLI Command:** `task-master set-status [options]`
*   **Description:** `Update the status of one or more Taskmaster tasks or subtasks, e.g., 'pending', 'in-progress', 'done'.`
*   **Key Parameters/Options:**
    *   `id`: `Required. The ID(s) of the Taskmaster task(s) or subtask(s), e.g., '15', '15.2', or '16,17.1', to update.` (CLI: `-i, --id <id>`)
    *   `status`: `Required. The new status to set, e.g., 'done', 'pending', 'in-progress', 'review', 'cancelled'.` (CLI: `-s, --status <status>`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Mark progress as tasks move through the development cycle.

### 12. Remove Task (`remove_task`)

*   **MCP Tool:** `remove_task`
*   **CLI Command:** `task-master remove-task [options]`
*   **Description:** `Permanently remove a task or subtask from the Taskmaster tasks list.`
*   **Key Parameters/Options:**
    *   `id`: `Required. The ID of the Taskmaster task, e.g., '5', or subtask, e.g., '5.2', to permanently remove.` (CLI: `-i, --id <id>`)
    *   `yes`: `Skip the confirmation prompt and immediately delete the task.` (CLI: `-y, --yes`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Permanently delete tasks or subtasks that are no longer needed in the project.
*   **Notes:** Use with caution as this operation cannot be undone. Consider using 'blocked', 'cancelled', or 'deferred' status instead if you just want to exclude a task from active planning but keep it for reference. The command automatically cleans up dependency references in other tasks.

---

## Task Structure & Breakdown

### 13. Expand Task (`expand_task`)

*   **MCP Tool:** `expand_task`
*   **CLI Command:** `task-master expand [options]`
*   **Description:** `Use Taskmaster's AI to break down a complex task into smaller, manageable subtasks. Appends subtasks by default.`
*   **Key Parameters/Options:**
    *   `id`: `The ID of the specific Taskmaster task you want to break down into subtasks.` (CLI: `-i, --id <id>`)
    *   `num`: `Optional: Suggests how many subtasks Taskmaster should aim to create. Uses complexity analysis/defaults otherwise.` (CLI: `-n, --num <number>`)
    *   `research`: `Enable Taskmaster to use the research role for more informed subtask generation. Requires appropriate API key.` (CLI: `-r, --research`)
    *   `prompt`: `Optional: Provide extra context or specific instructions to Taskmaster for generating the subtasks.` (CLI: `-p, --prompt <text>`)
    *   `force`: `Optional: If true, clear existing subtasks before generating new ones. Default is false (append).` (CLI: `--force`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Generate a detailed implementation plan for a complex task before starting coding. Automatically uses complexity report recommendations if available and `num` is not specified.
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress.

### 14. Expand All Tasks (`expand_all`)

*   **MCP Tool:** `expand_all`
*   **CLI Command:** `task-master expand --all [options]` (Note: CLI uses the `expand` command with the `--all` flag)
*   **Description:** `Tell Taskmaster to automatically expand all eligible pending/in-progress tasks based on complexity analysis or defaults. Appends subtasks by default.`
*   **Key Parameters/Options:**
    *   `num`: `Optional: Suggests how many subtasks Taskmaster should aim to create per task.` (CLI: `-n, --num <number>`)
    *   `research`: `Enable research role for more informed subtask generation. Requires appropriate API key.` (CLI: `-r, --research`)
    *   `prompt`: `Optional: Provide extra context for Taskmaster to apply generally during expansion.` (CLI: `-p, --prompt <text>`)
    *   `force`: `Optional: If true, clear existing subtasks before generating new ones for each eligible task. Default is false (append).` (CLI: `--force`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Useful after initial task generation or complexity analysis to break down multiple tasks at once.
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress.

### 15. Clear Subtasks (`clear_subtasks`)

*   **MCP Tool:** `clear_subtasks`
*   **CLI Command:** `task-master clear-subtasks [options]`
*   **Description:** `Remove all subtasks from one or more specified Taskmaster parent tasks.`
*   **Key Parameters/Options:**
    *   `id`: `The ID(s) of the Taskmaster parent task(s) whose subtasks you want to remove, e.g., '15' or '16,18'. Required unless using `all`.) (CLI: `-i, --id <ids>`)
    *   `all`: `Tell Taskmaster to remove subtasks from all parent tasks.` (CLI: `--all`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Used before regenerating subtasks with `expand_task` if the previous breakdown needs replacement.

### 16. Remove Subtask (`remove_subtask`)

*   **MCP Tool:** `remove_subtask`
*   **CLI Command:** `task-master remove-subtask [options]`
*   **Description:** `Remove a subtask from its Taskmaster parent, optionally converting it into a standalone task.`
*   **Key Parameters/Options:**
    *   `id`: `Required. The ID(s) of the Taskmaster subtask(s) to remove, e.g., '15.2' or '16.1,16.3'.` (CLI: `-i, --id <id>`)
    *   `convert`: `If used, Taskmaster will turn the subtask into a regular top-level task instead of deleting it.` (CLI: `-c, --convert`)
    *   `skipGenerate`: `Prevent Taskmaster from automatically regenerating markdown task files after removing the subtask.` (CLI: `--skip-generate`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Delete unnecessary subtasks or promote a subtask to a top-level task.

### 17. Move Task (`move_task`)

*   **MCP Tool:** `move_task`
*   **CLI Command:** `task-master move [options]`
*   **Description:** `Move a task or subtask to a new position within the task hierarchy.`
*   **Key Parameters/Options:**
    *   `from`: `Required. ID of the task/subtask to move (e.g., "5" or "5.2"). Can be comma-separated for multiple tasks.` (CLI: `--from <id>`)
    *   `to`: `Required. ID of the destination (e.g., "7" or "7.3"). Must match the number of source IDs if comma-separated.` (CLI: `--to <id>`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Reorganize tasks by moving them within the hierarchy. Supports various scenarios like:
    *   Moving a task to become a subtask
    *   Moving a subtask to become a standalone task
    *   Moving a subtask to a different parent
    *   Reordering subtasks within the same parent
    *   Moving a task to a new, non-existent ID (automatically creates placeholders)
    *   Moving multiple tasks at once with comma-separated IDs
*   **Validation Features:**
    *   Allows moving tasks to non-existent destination IDs (creates placeholder tasks)
    *   Prevents moving to existing task IDs that already have content (to avoid overwriting)
    *   Validates that source tasks exist before attempting to move them
    *   Maintains proper parent-child relationships
*   **Example CLI:** `task-master move --from=5.2 --to=7.3` to move subtask 5.2 to become subtask 7.3.
*   **Example Multi-Move:** `task-master move --from=10,11,12 --to=16,17,18` to move multiple tasks to new positions.
*   **Common Use:** Resolving merge conflicts in tasks.json when multiple team members create tasks on different branches.

---

## Dependency Management

### 18. Add Dependency (`add_dependency`)

*   **MCP Tool:** `add_dependency`
*   **CLI Command:** `task-master add-dependency [options]`
*   **Description:** `Define a dependency in Taskmaster, making one task a prerequisite for another.`
*   **Key Parameters/Options:**
    *   `id`: `Required. The ID of the Taskmaster task that will depend on another.` (CLI: `-i, --id <id>`)
    *   `dependsOn`: `Required. The ID of the Taskmaster task that must be completed first, the prerequisite.` (CLI: `-d, --depends-on <id>`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <path>`)
*   **Usage:** Establish the correct order of execution between tasks.

### 19. Remove Dependency (`remove_dependency`)

*   **MCP Tool:** `remove_dependency`
*   **CLI Command:** `task-master remove-dependency [options]`
*   **Description:** `Remove a dependency relationship between two Taskmaster tasks.`
*   **Key Parameters/Options:**
    *   `id`: `Required. The ID of the Taskmaster task you want to remove a prerequisite from.` (CLI: `-i, --id <id>`)
    *   `dependsOn`: `Required. The ID of the Taskmaster task that should no longer be a prerequisite.` (CLI: `-d, --depends-on <id>`)
    *   `file`: `Path to your Taskmaster 'tasks.json' file. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
*   **Usage:** Update task relationships when the order of execution changes.

### 20. Validar Dependências (`validate_dependencies`)

*   **Ferramenta MCP:** `validate_dependencies`
*   **Comando CLI:** `task-master validate-dependencies [opções]`
*   **Descrição:** `Verifica suas tarefas do Taskmaster em busca de problemas de dependência (como referências circulares ou links para tarefas não existentes) sem fazer alterações.`
*   **Principais Parâmetros/Opções:**
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Audite a integridade de suas dependências de tarefas.

### 21. Corrigir Dependências (`fix_dependencies`)

*   **Ferramenta MCP:** `fix_dependencies`
*   **Comando CLI:** `task-master fix-dependencies [opções]`
*   **Descrição:** `Corrige automaticamente problemas de dependência (como referências circulares ou links para tarefas não existentes) em suas tarefas do Taskmaster.`
*   **Principais Parâmetros/Opções:**
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Limpe os erros de dependência automaticamente.

---

## Análise e Relatórios

### 22. Analisar Complexidade do Projeto (`analyze_project_complexity`)

*   **Ferramenta MCP:** `analyze_project_complexity`
*   **Comando CLI:** `task-master analyze-complexity [opções]`
*   **Descrição:** `Pede ao Taskmaster para analisar suas tarefas para determinar sua complexidade e sugerir quais precisam ser detalhadas ainda mais.`
*   **Principais Parâmetros/Opções:**
    *   `output`: `Onde salvar o relatório de análise de complexidade (padrão: '.taskmaster/reports/task-complexity-report.json').` (CLI: `-o, --output <arquivo>`)
    *   `threshold`: `A pontuação mínima de complexidade (1-10) que deve acionar uma recomendação para expandir uma tarefa.` (CLI: `-t, --threshold <número>`)
    *   `research`: `Permite a função de pesquisa para uma análise de complexidade mais precisa. Requer chave de API apropriada.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Usado antes de detalhar tarefas para identificar quais precisam de mais atenção.
*   **Importante:** Esta ferramenta MCP faz chamadas de IA e pode levar até um minuto para ser concluída. Por favor, informe os usuários para aguardarem enquanto a operação está em andamento.

### 23. Visualizar Relatório de Complexidade (`complexity_report`)

*   **Ferramenta MCP:** `complexity_report`
*   **Comando CLI:** `task-master complexity-report [opções]`
*   **Descrição:** `Exibe o relatório de análise de complexidade da tarefa em um formato legível.`
*   **Principais Parâmetros/Opções:**
    *   `file`: `Caminho para o relatório de complexidade (padrão: '.taskmaster/reports/task-complexity-report.json').` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Revise e entenda os resultados da análise de complexidade após executar analyze-complexity.

---

## Gerenciamento de Arquivos

### 24. Gerar Arquivos de Tarefa (`generate`)

*   **Ferramenta MCP:** `generate`
*   **Comando CLI:** `task-master generate [opções]`
*   **Descrição:** `Cria ou atualiza arquivos Markdown individuais para cada tarefa com base no seu tasks.json.`
*   **Principais Parâmetros/Opções:**
    *   `output`: `O diretório onde o Taskmaster deve salvar os arquivos de tarefa (padrão: em um diretório 'tasks').` (CLI: `-o, --output <diretório>`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Execute isso depois de fazer alterações em tasks.json para manter os arquivos de tarefa individuais atualizados.

---

## Configuração de Variáveis de Ambiente (Atualizado)

O Taskmaster usa principalmente o arquivo **`.taskmaster/config.json`** (na raiz do projeto) para configuração (modelos, parâmetros, nível de log, etc.), gerenciado via `task-master models --setup`.

As variáveis de ambiente são usadas **apenas** para chaves de API sensíveis relacionadas a provedores de IA e substituições específicas como a URL base do Ollama:

*   **Chaves de API (Obrigatório para o provedor correspondente):**
    *   `ANTHROPIC_API_KEY`
    *   `PERPLEXITY_API_KEY`
    *   `OPENAI_API_KEY`
    *   `GOOGLE_API_KEY`
    *   `MISTRAL_API_KEY`
    *   `AZURE_OPENAI_API_KEY` (Requer `AZURE_OPENAI_ENDPOINT` também)
    *   `OPENROUTER_API_KEY`
    *   `XAI_API_KEY`
    *   `OLLANA_API_KEY` (Requer `OLLAMA_BASE_URL` também)
*   **Endpoints (Opcional/Específico do Provedor dentro de .taskmaster/config.json):**
    *   `AZURE_OPENAI_ENDPOINT`
    *   `OLLAMA_BASE_URL` (Padrão: `http://localhost:11434/api`)

**Defina as chaves de API** em seu arquivo **`.env`** na raiz do projeto (para uso CLI) ou na seção `env` do seu arquivo **`.cursor/mcp.json`** (para integração MCP/Cursor). Todas as outras configurações (escolha do modelo, tokens máximos, temperatura, nível de log, endpoints personalizados) são gerenciadas em `.taskmaster/config.json` via comando `task-master models` ou ferramenta MCP `models`.

---

Para detalhes sobre como esses comandos se encaixam no processo de desenvolvimento, consulte o [Guia de Fluxo de Trabalho de Desenvolvimento](mdc:.cursor/rules/dev_workflow.mdc).
