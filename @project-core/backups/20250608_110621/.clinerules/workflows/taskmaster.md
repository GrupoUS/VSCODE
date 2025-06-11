---
description: Referência abrangente para ferramentas MCP e comandos CLI do Taskmaster.
author: Sistema GRUPOUS/Cline Rules
version: 1.0
globs: ["**/*"]
tags: ["taskmaster", "reference", "cli", "mcp"]
alwaysApply: true
---
# Taskmaster Tool & Command Reference

This document provides a detailed reference for interacting with Taskmaster, covering both the recommended MCP tools, suitable for integrations like Cursor, and the corresponding `task-master` CLI commands, designed for direct user interaction or fallback.

**Note:** For interacting with Taskmaster programmatically or via integrated tools, using the **MCP tools is strongly recommended** due to better performance, structured data, and error handling. The CLI commands serve as a user-friendly alternative and fallback. 

**Important:** Several MCP tools involve AI processing... The AI-powered tools include `parse_prd`, `analyze_project_complexity`, `update_subtask`, `update_task`, `update`, `expand_all`, `expand_task`, and `add_task`.

---

## Initialization & Setup

### 1. Initialize Project (`init`)

*   **MCP Tool:** `initialize_project`
*   **CLI Command:** `task-master init [options]`
*   **Description:** `Set up the basic Taskmaster file structure and configuration in the current directory for a new project.`
*   **Key CLI Options:**
    *   `--name <name>`: `Set the name for your project in Taskmaster's configuration.`
    *   `--description <text>`: `Provide a brief description for your project.`
    *   `--version <version>`: `Set the initial version for your project, e.g., '0.1.0'.`
    *   `-y, --yes`: `Initialize Taskmaster quickly using default settings without interactive prompts.`
*   **Usage:** Run this once at the beginning of a new project.
*   **MCP Variant Description:** `Set up the basic Taskmaster file structure and configuration in the current directory for a new project by running the 'task-master init' command.`
*   **Key MCP Parameters/Options:**
    *   `projectName`: `Define o nome do seu projeto.` (CLI: `--name <name>`)
    *   `projectDescription`: `Fornece uma breve descrição para o seu projeto.` (CLI: `--description <text>`)
    *   `projectVersion`: `Define a versão inicial do seu projeto, por exemplo, '0.1.0'.` (CLI: `--version <version>`)
    *   `authorName`: `Nome do autor.` (CLI: `--author <author>`)
    *   `skipInstall`: `Ignora a instalação de dependências. O padrão é false.` (CLI: `--skip-install`)
    *   `addAliases`: `Adiciona aliases de shell tm e taskmaster. O padrão é false.` (CLI: `--aliases`)
    *   `yes`: `Ignora prompts e usa padrões/argumentos fornecidos. O padrão é false.` (CLI: `-y, --yes`)
*   **Usage:** Run this once at the beginning of a new project, typically via an integrated tool like Cursor. Operates on the current working directory of the MCP server. 
*   **Important:** Once complete, you *MUST* parse a prd in order to generate tasks. There will be no tasks files until then. The next step after initializing should be to create a PRD using the example PRD in .taskmaster/templates/example_prd.txt. 

### 2. Parse PRD (`parse_prd`)

*   **MCP Tool:** `parse_prd`
*   **CLI Command:** `task-master parse-prd [file] [options]`
*   **Description:** `Parse a Product Requirements Document, PRD, or text file with Taskmaster to automatically generate an initial set of tasks in tasks.json.`
*   **Key Parameters/Options:**
    *   `input`: `Path to your PRD or requirements text file that Taskmaster should parse for tasks.` (CLI: `[file]` positional or `-i, --input <file>`)
    *   `output`: `Specify where Taskmaster should save the generated 'tasks.json' file. Defaults to 'tasks/tasks.json'.` (CLI: `-o, --output <file>`)
    *   `numTasks`: `Approximate number of top-level tasks Taskmaster should aim to generate from the document.` (CLI: `-n, --num-tasks <number>`)
    *   `force`: `Use this to allow Taskmaster to overwrite an existing 'tasks.json' without asking for confirmation.` (CLI: `-f, --force`)
*   **Usage:** Useful for bootstrapping a project from an existing requirements document.
*   **Notes:** Task Master will strictly adhere to any specific requirements mentioned in the PRD, such as libraries, database schemas, frameworks, tech stacks, etc., while filling in any gaps where the PRD isn't fully specified. Tasks are designed to provide the most direct implementation path while avoiding over-engineering.
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress. If the user does not have a PRD, suggest discussing their idea and then use the example PRD in .taskmaster/templates/example_prd.txt as a template for creating the PRD based on their idea, for use with `parse-prd`.

---

## AI Model Configuration

### 2. Manage Models (`models`)
*   **MCP Tool:** `models`
*   **CLI Command:** `task-master models [options]`
*   **Description:** `View the current AI model configuration or set specific models for different roles (main, research, fallback). Allows setting custom model IDs for Ollama and OpenRouter.`
*   **Key MCP Parameters/Options:**
    *   `setMain <model_id>`: `Set the primary model ID for task generation/updates.` (CLI: `--set-main <model_id>`)
    *   `setResearch <model_id>`: `Set the model ID for research-backed operations.` (CLI: `--set-research <model_id>`)
    *   `setFallback <model_id>`: `Set the model ID to use if the primary fails.` (CLI: `--set-fallback <model_id>`)
    *   `ollama <boolean>`: `Indicates the set model ID is a custom Ollama model.` (CLI: `--ollama`)
    *   `openrouter <boolean>`: `Indicates the set model ID is a custom OpenRouter model.` (CLI: `--openrouter`)
    *   `listAvailableModels <boolean>`: `If true, lists available models not currently assigned to a role.` (CLI: No direct equivalent; CLI lists available automatically)
    *   `projectRoot <string>`: `Optional. Absolute path to the project root directory.` (CLI: Determined automatically)
*   **Key CLI Options:**
    *   `--set-main <model_id>`: `Set the primary model.`
    *   `--set-research <model_id>`: `Set the research model.`
    *   `--set-fallback <model_id>`: `Set the fallback model.`
    *   `--ollama`: `Specify that the provided model ID is for Ollama (use with --set-*).`
    *   `--openrouter`: `Specify that the provided model ID is for OpenRouter (use with --set-*). Valida contra a API do OpenRouter.`
    *   `--setup`: `Executa a configuração interativa para configurar modelos, incluindo IDs personalizados de Ollama/OpenRouter.`
*   **Usage (MCP):** Call without set flags to get current config. Use `setMain`, `setResearch`, or `setFallback` with a valid model ID to update the configuration. Use `listAvailableModels: true` to get a list of unassigned models. To set a custom model, provide the model ID and set `ollama: true` or `openrouter: true`.
*   **Usage (CLI):** Run without flags to view current configuration and available models. Use set flags to update specific roles. Use `--setup` for guided configuration, including custom models. To set a custom model via flags, use `--set-<role>=<model_id>` along with either `--ollama` or `--openrouter`.
*   **Notes:** Configuration is stored in `.taskmaster/config.json` in the project root. This command/tool modifies that file. Use `listAvailableModels` or `task-master models` to see internally supported models. OpenRouter custom models are validated against their live API. Ollama custom models are not validated live.
*   **API note:** API keys for selected AI providers (based on their model) need to exist in the mcp.json file to be accessible in MCP context. The API keys must be present in the local .env file for the CLI to be able to read them.
*   **Model costs:** The costs in supported models are expressed in dollars. An input/output value of 3 is $3.00. A value of 0.8 is $0.80. 
*   **Warning:** DO NOT MANUALLY EDIT THE .taskmaster/config.json FILE. Use the included commands either in the MCP or CLI format as needed. Always prioritize MCP tools when available and use the CLI as a fallback.

---

## Task Listing & Viewing

### 3. Get Tasks (`get_tasks`)

*   **MCP Tool:** `get_tasks`
*   **CLI Command:** `task-master list [opções]`
*   **Description:** `Lista suas tarefas do Taskmaster, opcionalmente filtrando por status e mostrando subtarefas.`
*   **Key Parameters/Options:**
    *   `status`: `Mostra apenas as tarefas do Taskmaster que correspondem a este status, por exemplo, 'pending' ou 'done'.` (CLI: `-s, --status <status>`)
    *   `withSubtasks`: `Inclui subtarefas recuadas sob suas tarefas pai na lista.` (CLI: `--with-subtasks`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Obtenha uma visão geral do projeto status, frequentemente usado no início de uma sessão de trabalho.

### 4. Get Next Task (`next_task`)

*   **MCP Tool:** `next_task`
*   **CLI Command:** `task-master next [opções]`
*   **Description:** `Pede ao Taskmaster para mostrar a próxima tarefa disponível em que você pode trabalhar, com base no status e nas dependências concluídas.`
*   **Key Parameters/Options:**
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Identifique o que trabalhar em seguida de acordo com o plano.

### 5. Get Task Details (`get_task`)

*   **MCP Tool:** `get_task`
*   **CLI Command:** `task-master show [id] [opções]`
*   **Description:** `Exibe informações detalhadas para uma tarefa ou subtarefa específica do Taskmaster por seu ID.`
*   **Key Parameters/Options:**
    *   `id`: `Obrigatório. O ID da tarefa do Taskmaster, por exemplo, '15', ou subtarefa, por exemplo, '15.2', que você deseja visualizar.` (CLI: `[id]` posicional ou `-i, --id <id>`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Entenda todos os detalhes, notas de implementação e estratégia de teste para uma tarefa específica antes de iniciar o trabalho.

---

## Task Creation & Modification

### 6. Add Task (`add_task`)

*   **MCP Tool:** `add_task`
*   **CLI Command:** `task-master add-task [opções]`
*   **Description:** `Add a new task to Taskmaster by describing it; AI will structure it.`
*   **Key Parameters/Options:**
    *   `prompt`: `Required. Describe the new task you want Taskmaster to create, e.g., "Implement user authentication using JWT".` (CLI: `-p, --prompt <text>`)
    *   `dependencies`: `Specify the IDs of any Taskmaster tasks that must be completed before this new one can start, e.g., '12,14'.` (CLI: `-d, --dependencies <ids>`)
    *   `priority`: `Set the priority for the new task: 'high', 'medium', or 'low'. Default is 'medium'.` (CLI: `--priority <priority>`)
    *   `research`: `Enable Taskmaster to use the research role for potentially more informed task creation.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Quickly add newly identified tasks during development.
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress.

### 7. Add Subtask (`add_subtask`)

*   **MCP Tool:** `add_subtask`
*   **CLI Command:** `task-master add-subtask [opções]`
*   **Description:** `Add a new subtask to a Taskmaster parent task, or convert an existing task into a subtask.`
*   **Key Parameters/Options:**
    *   `id` / `parent`: `Required. The ID of the Taskmaster task that will be the parent.` (MCP: `id`, CLI: `-p, --parent <id>`)
    *   `taskId`: `Use this if you want to convert an existing top-level Taskmaster task into a subtask of the specified parent.` (CLI: `-i, --task-id <id>`)
    *   `title`: `Required if not using taskId. The title for the new subtask Taskmaster should create.` (CLI: `-t, --title <título>`)
    *   `description`: `A brief description for the new subtask.` (CLI: `-d, --description <text>`)
    *   `details`: `Provide implementation notes or details for the new subtask.` (CLI: `--details <text>`)
    *   `dependencies`: `Specify IDs of other tasks or subtasks, e.g., '15' or '16.1', that must be done before this new subtask.` (CLI: `--dependencies <ids>`)
    *   `status`: `Define o status inicial para a new subtask. Default is 'pending'.` (CLI: `-s, --status <status>`)
    *   `skipGenerate`: `Impede que o Taskmaster regenere automaticamente os arquivos de tarefa markdown após adicionar a subtarefa.` (CLI: `--skip-generate`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Divida tarefas manualmente ou reorganize tarefas existentes.

### 8. Update Tasks (`update`)

*   **MCP Tool:** `update`
*   **CLI Command:** `task-master update [opções]`
*   **Description:** `Atualiza várias tarefas futuras no Taskmaster com base em novo contexto ou alterações, começando de um ID de tarefa específico.`
*   **Key Parameters/Options:**
    *   `from`: `Obrigatório. O ID da primeira tarefa que o Taskmaster deve atualizar. Todas as tarefas com este ID ou superior que não estão 'done' serão consideradas.` (CLI: `--from <id>`)
    *   `prompt`: `Obrigatório. Explica a alteração ou o novo contexto para o Taskmaster aplicar às tarefas, por exemplo, "Estamos agora usando React Query em vez de Redux Toolkit para busca de dados".` (CLI: `-p, --prompt <texto>`)
    *   `research`: `Permite que o Taskmaster use a função de pesquisa para uma atualização mais informada. Requer chave de API apropriada.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Lida com alterações significativas de implementação ou pivôs que afetam várias tarefas futuras. Exemplo CLI: `task-master update --from='18' --prompt='Switching to React Query.\nNeed to refactor data fetching...'`
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress.

### 9. Update Task (`update_task`)

*   **MCP Tool:** `update_task`
*   **CLI Command:** `task-master update-task [opções]`
*   **Description:** `Modifica uma tarefa ou subtarefa específica do Taskmaster por seu ID, incorporando novas informações ou alterações.`
*   **Key Parameters/Options:**
    *   `id`: `Obrigatório. O ID específico da tarefa do Taskmaster, por exemplo, '15', ou subtarefa, por exemplo, '15.2', que você deseja atualizar.` (CLI: `-i, --id <id>`)
    *   `prompt`: `Obrigatório. Explica as alterações específicas ou fornece as novas informações que o Taskmaster deve incorporar a esta tarefa.` (CLI: `-p, --prompt <texto>`)
    *   `research`: `Permite que o Taskmaster use a função de pesquisa para uma atualização mais informada. Requer chave de API apropriada.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Refina uma tarefa específica com base em nova compreensão ou feedback. Exemplo CLI: `task-master update-task --id='15' --prompt='Clarification: Use PostgreSQL em vez de MySQL.\nUpdate schema details...'`
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress.

### 10. Update Subtask (`update_subtask`)

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
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
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
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. Default relies on auto-detection.` (CLI: `-f, --file <file>`)
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
*   **CLI Command:** `task-master analyze-complexity [opções]`
*   **Descrição:** `Pede ao Taskmaster para analisar suas tarefas para determinar sua complexidade e sugerir quais precisam ser detalhadas ainda mais.`
*   **Principais Parâmetros/Opções:**
    *   `output`: `Onde salvar o relatório de análise de complexidade (padrão: '.taskmaster/reports/task-complexity-report.json').` (CLI: `-o, --output <arquivo>`)
    *   `threshold`: `A pontuação mínima de complexidade (1-10) que deve acionar uma recomendação para expandir uma tarefa.` (CLI: `-t, --threshold <número>`)
    *   `research`: `Permite a função de pesquisa para uma análise de complexidade mais precisa. Requer chave de API apropriada.` (CLI: `-r, --research`)
    *   `file`: `Caminho para o seu arquivo 'tasks.json' do Taskmaster. O padrão depende da detecção automática.` (CLI: `-f, --file <arquivo>`)
*   **Uso:** Usado antes de detalhar tarefas para identificar quais precisam de mais atenção.
*   **Important:** This MCP tool makes AI calls and can take up to a minute to complete. Please inform users to hang tight while the operation is in progress.

### 23.<environment_details>
# VSCode Visible Files
.clinerules/workflows/sync-all-repos.md

# VSCode Open Tabs
.clinerules/master_rule.md
../../Documentos/Cline/Rules/global-theme-grupous.md
../../Documentos/Cline/Rules/global.md
.clinerules/ui-standards.md
.clinerules/workflows/aegiswallet.md
.clinerules/workflows/cursor_rules.md
.clinerules/workflows/dev_workflow.md
.clinerules/workflows/neonpro.md
.clinerules/workflows/next-js-supabase-auth-guideline.md
.clinerules/workflows/self_improve.md
.clinerules/workflows/sync-all-repos.md

# Current Time
6/4/2025, 5:27:10 PM (America/Sao_Paulo, UTC-3:00)

# Context Window Usage
876,403 / 1,048.576K tokens used (84%)

# Current Mode
ACT MODE
</environment_details>
