---
description: Guia para usar o Task Master para gerenciar fluxos de trabalho de desenvolvimento orientados a tarefas.
globs: **/*
alwaysApply: true
---
# Fluxo de Trabalho de Desenvolvimento do Task Master

Este guia descreve o processo típico para usar o Task Master para gerenciar projetos de desenvolvimento de software.

## Interação Primária: Servidor MCP vs. CLI

O Task Master oferece duas maneiras principais de interagir:

1.  **Servidor MCP (Recomendado para Ferramentas Integradas)**:
    - Para agentes de IA e ambientes de desenvolvimento integrados (como o Cursor), a interação via **servidor MCP é o método preferencial**.
    - O servidor MCP expõe a funcionalidade do Task Master através de um conjunto de ferramentas (por exemplo, `get_tasks`, `add_subtask`).
    - Este método oferece melhor desempenho, troca de dados estruturada e tratamento de erros mais rico em comparação com a análise da CLI.
    - Consulte [`mcp.mdc`](mdc:.cursor/rules/mcp.mdc) para obter detalhes sobre a arquitetura MCP e as ferramentas disponíveis.
    - Uma lista abrangente e descrição das ferramentas MCP e seus comandos CLI correspondentes podem ser encontradas em [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc).
    - **Reinicie o servidor MCP** se a lógica principal em `scripts/modules` ou as definições de ferramentas/funções diretas do MCP mudarem.

2.  **CLI `task-master` (Para Usuários e Fallback)**:
    - O comando global `task-master` fornece uma interface amigável para interação direta com o terminal.
    - Também pode servir como um fallback se o servidor MCP estiver inacessível ou uma função específica não for exposta via MCP.
    - Instale globalmente com `npm install -g task-master-ai` ou use localmente via `npx task-master-ai ...`.
    - Os comandos da CLI geralmente espelham as ferramentas MCP (por exemplo, `task-master list` corresponde a `get_tasks`).
    - Consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc) para obter uma referência detalhada do comando.

## Processo Padrão do Fluxo de Trabalho de Desenvolvimento

-   Inicie novos projetos executando a ferramenta `initialize_project` / `task-master init` ou `parse_prd` / `task-master parse-prd --input='<prd-file.txt>'` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) para gerar o `tasks.json` inicial.
-   Inicie as sessões de codificação com `get_tasks` / `task-master list` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) para ver as tarefas atuais, status e IDs.
-   Determine a próxima tarefa a ser trabalhada usando `next_task` / `task-master next` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)).
-   Analise a complexidade da tarefa com `analyze_project_complexity` / `task-master analyze-complexity --research` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) antes de detalhar as tarefas.
-   Revise o relatório de complexidade usando `complexity_report` / `task-master complexity-report` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)).
-   Selecione as tarefas com base nas dependências (todas marcadas como 'done'), nível de prioridade e ordem de ID.
-   Esclareça as tarefas verificando os arquivos de tarefa no diretório `tasks/` ou solicitando a entrada do usuário.
-   Visualize os detalhes de tarefas específicas usando `get_task` / `task-master show <id>` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) para entender os requisitos de implementação.
-   Detalhe tarefas complexas usando `expand_task` / `task-master expand --id=<id> --force --research` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) com as flags apropriadas, como `--force` (para substituir subtarefas existentes) e `--research`.
-   Limpe as subtarefas existentes, se necessário, usando `clear_subtasks` / `task-master clear-subtasks --id=<id>` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) antes de regenerar.
-   Implemente o código seguindo os detalhes da tarefa, dependências e padrões do projeto.
-   Verifique as tarefas de acordo com as estratégias de teste antes de marcá-las como concluídas (consulte [`tests.mdc`](mdc:.cursor/rules/tests.mdc)).
-   Marque as tarefas concluídas com `set_task_status` / `task-master set-status --id=<id> --status=done` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)).
-   Atualize as tarefas dependentes quando a implementação diferir do plano original usando `update` / `task-master update --from=<id> --prompt="..."` ou `update_task` / `task-master update-task --id=<id> --prompt="..."` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)).
-   Adicione novas tarefas descobertas durante a implementação usando `add_task` / `task-master add-task --prompt="..." --research` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)).
-   Adicione novas subtarefas conforme necessário usando `add_subtask` / `task-master add-subtask --parent=<id> --title="..."` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)).
-   Anexe notas ou detalhes às subtarefas usando `update_subtask` / `task-master update-subtask --id=<subtaskId> --prompt='Adicionar notas de implementação aqui...\nMais detalhes...'` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)).
-   Gere arquivos de tarefa com `generate` / `task-master generate` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) após atualizar `tasks.json`.
-   Mantenha uma estrutura de dependência válida com as ferramentas `add_dependency`/`remove_dependency` ou os comandos `task-master add-dependency`/`remove-dependency`, `validate_dependencies` / `task-master validate-dependencies` e `fix_dependencies` / `task-master fix-dependencies` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) quando necessário.
-   Respeite as cadeias de dependência e as prioridades das tarefas ao selecionar o trabalho.
-   Relate o progresso regularmente usando `get_tasks` / `task-master list`.
-   Reorganize as tarefas conforme necessário usando `move_task` / `task-master move --from=<id> --to=<id>` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) para alterar a hierarquia ou a ordem das tarefas.

## Análise de Complexidade da Tarefa

-   Execute `analyze_project_complexity` / `task-master analyze-complexity --research` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) para uma análise abrangente.
-   Revise o relatório de complexidade via `complexity_report` / `task-master complexity-report` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) para uma versão formatada e legível.
-   Concentre-se nas tarefas com as maiores pontuações de complexidade (8-10) para um detalhamento aprofundado.
-   Use os resultados da análise para determinar a alocação apropriada de subtarefas.
-   Observe que os relatórios são usados automaticamente pela ferramenta `expand_task`.

## Processo de Detalhamento da Tarefa

-   Use `expand_task` / `task-master expand --id=<id>`. Ele usa automaticamente o relatório de complexidade, se encontrado, caso contrário, gera o número padrão de subtarefas.
-   Use `--num=<number>` para especificar um número explícito de subtarefas, substituindo os padrões ou as recomendações do relatório de complexidade.
-   Adicione a flag `--research` para aproveitar a Perplexity AI para uma expansão baseada em pesquisa.
-   Adicione a flag `--force` para limpar as subtarefas existentes antes de gerar novas (o padrão é anexar).
-   Use `--prompt="<context>"` para fornecer contexto adicional quando necessário.
-   Revise e ajuste as subtarefas geradas conforme necessário.
-   Use a ferramenta `expand_all` ou `task-master expand --all` para expandir várias tarefas pendentes de uma vez, respeitando as flags como `--force` e `--research`.
-   Se as subtarefas precisarem de substituição completa (independentemente da flag `--force` em `expand`), limpe-as primeiro com `clear_subtasks` / `task-master clear-subtasks --id=<id>`.

## Tratamento de Desvios de Implementação

-   Quando a implementação difere significativamente da abordagem planejada.
-   Quando tarefas futuras precisam de modificação devido a escolhas de implementação atuais.
-   Quando novas dependências ou requisitos surgem.
-   Use `update` / `task-master update --from=<futureTaskId> --prompt='<explanation>\nAtualizar contexto...' --research` para atualizar várias tarefas futuras.
-   Use `update_task` / `task-master update-task --id=<taskId> --prompt='<explanation>\nAtualizar contexto...' --research` para atualizar uma única tarefa específica.

## Gerenciamento de Status da Tarefa

-   Use 'pending' para tarefas prontas para serem trabalhadas.
-   Use 'done' para tarefas concluídas e verificadas.
-   Use 'deferred' para tarefas adiadas.
-   Adicione valores de status personalizados conforme necessário para fluxos de trabalho específicos do projeto.

## Campos da Estrutura da Tarefa

- **id**: Identificador único para a tarefa (Exemplo: `1`, `1.1`)
- **title**: Título breve e descritivo (Exemplo: `"Inicializar Repositório"`)
- **description**: Resumo conciso do que a tarefa envolve (Exemplo: `"Criar um novo repositório, configurar a estrutura inicial."`)
- **status**: Estado atual da tarefa (Exemplo: `"pending"`, `"done"`, `"deferred"`)
- **dependencies**: IDs de tarefas pré-requisito (Exemplo: `[1, 2.1]`)
    - As dependências são exibidas com indicadores de status (✅ para concluídas, ⏱️ para pendentes)
    - Isso ajuda a identificar rapidamente quais tarefas pré-requisito estão bloqueando o trabalho.
- **priority**: Nível de importância (Exemplo: `"high"`, `"medium"`, `"low"`)
- **details**: Instruções de implementação detalhadas (Exemplo: `"Usar ID/segredo do cliente GitHub, lidar com callback, definir token de sessão."`) 
- **testStrategy**: Abordagem de verificação (Exemplo: `"Implantar e chamar o endpoint para confirmar a resposta 'Hello World'."`) 
- **subtasks**: Lista de tarefas menores e mais específicas (Exemplo: `[{"id": 1, "title": "Configurar OAuth", ...}]`) 
- Consulte os detalhes da estrutura da tarefa (anteriormente vinculados a `tasks.mdc`).

## Gerenciamento de Configuração (Atualizado)

A configuração do Taskmaster é gerenciada por meio de dois mecanismos principais:

1.  **Arquivo `.taskmaster/config.json` (Primário):**
    *   Localizado no diretório raiz do projeto.
    *   Armazena a maioria das configurações: seleções de modelo de IA (principal, pesquisa, fallback), parâmetros (tokens máximos, temperatura), nível de log, subtarefas/prioridade padrão, nome do projeto, etc.
    *   **Gerenciado via comando `task-master models --setup`.** Não edite manualmente, a menos que saiba o que está fazendo.
    *   **Visualize/defina modelos específicos via comando `task-master models` ou ferramenta MCP `models`.**
    *   Criado automaticamente quando você executa `task-master models --setup` pela primeira vez.

2.  **Variáveis de Ambiente (`.env` / `mcp.json`):**
    *   Usado **apenas** para chaves de API sensíveis e URLs de endpoint específicas.
    *   Coloque as chaves de API (uma por provedor) em um arquivo `.env` na raiz do projeto para uso da CLI.
    *   Para integração MCP/Cursor, configure essas chaves na seção `env` do seu `.cursor/mcp.json`.
    *   Variáveis/chaves disponíveis: Consulte `assets/env.example` ou a seção Configuração na referência de comando (anteriormente vinculada a `taskmaster.mdc`).

**Importante:** As configurações que não são chaves de API (como seleções de modelo, `MAX_TOKENS`, `TASKMASTER_LOG_LEVEL`) **não são mais configuradas via variáveis de ambiente**. Use o comando `task-master models` (ou `--setup` para configuração interativa) ou a ferramenta MCP `models`.
**Se os comandos de IA FALHAREM no MCP**, verifique se a chave de API para o provedor selecionado está presente na seção `env` do seu `.cursor/mcp.json`.
**Se os comandos de IA FALHAREM na CLI**, verifique se a chave de API para o provedor selecionado está presente no arquivo `.env` na raiz do projeto.

## Determinando a Próxima Tarefa

- Execute `next_task` / `task-master next` para mostrar a próxima tarefa a ser trabalhada.
- O comando identifica tarefas com todas as dependências satisfeitas.
- As tarefas são priorizadas por nível de prioridade, contagem de dependências e ID.
- O comando mostra informações abrangentes da tarefa, incluindo:
    - Detalhes básicos da tarefa e descrição.
    - Detalhes de implementação.
    - Subtarefas (se existirem).
    - Ações sugeridas contextuais.
- Recomendado antes de iniciar qualquer novo trabalho de desenvolvimento.
- Respeita a estrutura de dependência do seu projeto.
- Garante que as tarefas sejam concluídas na sequência apropriada.
- Fornece comandos prontos para uso para ações comuns de tarefas.

## Visualizando Detalhes de Tarefas Específicas

- Execute `get_task` / `task-master show <id>` para visualizar uma tarefa específica.
- Use a notação de ponto para subtarefas: `task-master show 1.2` (mostra a subtarefa 2 da tarefa 1).
- Exibe informações abrangentes semelhantes ao comando `next`, mas para uma tarefa específica.
- Para tarefas pai, mostra todas as subtarefas e seu status atual.
- Para subtarefas, mostra informações e relacionamento da tarefa pai.
- Fornece ações sugeridas contextuais apropriadas para a tarefa específica.
- Útil para examinar os detalhes da tarefa antes da implementação ou verificar o status.

## Gerenciando Dependências de Tarefas

- Use `add_dependency` / `task-master add-dependency --id=<id> --depends-on=<id>` para adicionar uma dependência.
- Use `remove_dependency` / `task-master remove-dependency --id=<id> --depends-on=<id>` para remover uma dependência.
- O sistema impede dependências circulares e entradas de dependência duplicadas.
- As dependências são verificadas quanto à existência antes de serem adicionadas ou removidas.
- Os arquivos de tarefa são regenerados automaticamente após as alterações de dependência.
- As dependências são visualizadas com indicadores de status nas listas de tarefas e nos arquivos.

## Reorganização de Tarefas

- Use `move_task` / `task-master move --from=<id> --to=<id>` para mover tarefas ou subtarefas dentro da hierarquia.
- Este comando suporta vários casos de uso:
  - Mover uma tarefa autônoma para se tornar uma subtarefa (por exemplo, `--from=5 --to=7`).
  - Mover uma subtarefa para se tornar uma tarefa autônoma (por exemplo, `--from=5.2 --to=7`).
  - Mover uma subtarefa para um pai diferente (por exemplo, `--from=5.2 --to=7.3`).
  - Reordenar subtarefas dentro do mesmo pai (por exemplo, `--from=5.2 --to=5.4`).
  - Mover uma tarefa para uma nova posição de ID não existente (por exemplo, `--from=5 --to=25`).
  - Mover várias tarefas de uma vez usando IDs separados por vírgulas (por exemplo, `--from=10,11,12 --to=16,17,18`).
- O sistema inclui validação para evitar perda de dados:
  - Permite mover para IDs não existentes criando tarefas de espaço reservado.
  - Impede o movimento para IDs de tarefas existentes que já possuem conteúdo (para evitar sobrescrever).
  - Valida se as tarefas de origem existem antes de tentar movê-las.
- O sistema mantém relacionamentos pai-filho adequados e integridade de dependência.
- Os arquivos de tarefa são regenerados automaticamente após a operação de movimentação.
- Isso proporciona maior flexibilidade na organização e refinamento da estrutura da tarefa à medida que a compreensão do projeto evolui.
- Isso é especialmente útil ao lidar com possíveis conflitos de mesclagem decorrentes de equipes que criam tarefas em branches diferentes. Resolva esses conflitos muito facilmente movendo suas tarefas e mantendo as deles.

## Implementação Iterativa de Subtarefas

Uma vez que uma tarefa tenha sido detalhada em subtarefas usando `expand_task` ou métodos semelhantes, siga este processo iterativo para a implementação:

1.  **Entenda o Objetivo (Preparação):**
    *   Use `get_task` / `task-master show <subtaskId>` (consulte [`taskmaster.mdc`](mdc:.cursor/rules/taskmaster.mdc)) para entender completamente os objetivos e requisitos específicos da subtarefa.

2.  **Exploração Inicial e Planejamento (Iteração 1):**
    *   Esta é a primeira tentativa de criar um plano de implementação concreto.
    *   Explore a base de código para identificar os arquivos, funções e até mesmo linhas de código específicas que precisarão de modificação.
    *   Determine as alterações de código pretendidas (diffs) e seus locais.
    *   Reúna *todos* os detalhes relevantes desta fase de exploração.

3.  **Registre o Plano:**
    *   Execute `update_subtask` / `task-master update-subtask --id=<subtaskId> --prompt='<detailed plan>'`.
    *   Forneça os resultados *completos e detalhados* da fase de exploração no prompt. Inclua caminhos de arquivo, números de linha, diffs propostos, raciocínio e quaisquer desafios potenciais identificados. Não omita detalhes. O objetivo é criar um log rico e com carimbo de data/hora nos `details` da subtarefa.

4.  **Verifique o Plano:**
    *   Execute `get_task` / `task-master show <subtaskId>` novamente para confirmar que o plano de implementação detalhado foi anexado com sucesso aos detalhes da subtarefa.

5.  **Inicie a Implementação:**
    *   Defina o status da subtarefa usando `set_task_status` / `task-master set-status --id=<subtaskId> --status=in-progress`.
    *   Comece a codificar com base no plano registrado.

6.  **Refine e Registre o Progresso (Iteração 2+):**
    *   À medida que a implementação avança, você encontrará desafios, descobrirá nuances ou confirmará abordagens bem-sucedidas.
    *   **Antes de anexar novas informações**: Revise brevemente os detalhes *existentes* registrados na subtarefa (usando `get_task` ou lembrando do contexto) para garantir que a atualização adicione novos insights e evite redundância.
    *   **Regularmente**, use `update_subtask` / `task-master update-subtask --id=<subtaskId> --prompt='<update details>\n- O que funcionou...\n- O que não funcionou...'` para anexar novas descobertas.
    *   **Crucialmente, registre:**
        *   O que funcionou ("verdades fundamentais" descobertas).
        *   O que não funcionou e por quê (para evitar repetir erros).
        *   Trechos de código ou configurações específicas que foram bem-sucedidos.
        *   Decisões tomadas, especialmente se confirmadas com a entrada do usuário.
        *   Quaisquer desvios do plano inicial e o raciocínio.
    *   O objetivo é enriquecer continuamente os detalhes da subtarefa, criando um log da jornada de implementação que ajuda a IA (e os desenvolvedores humanos) a aprender, adaptar e evitar a repetição de erros.

7.  **Revise e Atualize as Regras (Pós-Implementação):**
    *   Uma vez que a implementação da subtarefa esteja funcionalmente completa, revise todas as alterações de código e o histórico de chat relevante.
    *   Identifique quaisquer padrões de código, convenções ou melhores práticas novos ou modificados estabelecidos durante a implementação.
    *   Crie novas ou atualize as regras existentes seguindo as diretrizes internas (anteriormente vinculadas a `cursor_rules.mdc` e `self_improve.mdc`).

8.  **Marque a Tarefa como Concluída:**
    *   Após verificar a implementação e atualizar as regras necessárias, marque a subtarefa como concluída: `set_task_status` / `task-master set-status --id=<subtaskId> --status=done`.

9.  **Confirme as Alterações (Se estiver usando Git):**
    *   Prepare as alterações de código relevantes e quaisquer arquivos de regras atualizados/novos (`git add .`).
    *   Crie uma mensagem de commit Git abrangente resumindo o trabalho feito para a subtarefa, incluindo a implementação do código e quaisquer ajustes de regras.
    *   Execute o comando commit diretamente no terminal (por exemplo, `git commit -m 'feat(module): Implementar recurso X para subtarefa <subtaskId>\n\n- Detalhes sobre as alterações...\n- Regra Y atualizada para o padrão Z'`).
    *   Considere se um Changeset é necessário de acordo com as diretrizes internas de versionamento (anteriormente vinculadas a `changeset.mdc`). Se sim, execute `npm run changeset`, prepare o arquivo gerado e altere o commit ou crie um novo.

10. **Prossiga para a Próxima Subtarefa:**
    *   Identifique a próxima subtarefa (por exemplo, usando `next_task` / `task-master next`).

## Técnicas de Análise e Refatoração de Código

- **Pesquisa de Funções de Nível Superior**:
    - Útil para entender a estrutura do módulo ou planejar refatorações.
    - Use grep/ripgrep para encontrar funções/constantes exportadas:
      `rg "export (async function|function|const) \w+"` ou padrões semelhantes.
    - Pode ajudar a comparar funções entre arquivos durante migrações ou identificar possíveis conflitos de nomenclatura.

---
*Este fluxo de trabalho fornece uma diretriz geral. Adapte-o com base nas necessidades específicas do seu projeto e nas práticas da equipe.*
