# Princípios Gerais de Desenvolvimento

Estes princípios universais se aplicam a todos os projetos, independentemente da stack tecnológica.

## 1. Filosofia Central

* **Legibilidade & Clareza:** Escreva código claro, conciso e autodocumentado. O código é lido muito mais frequentemente do que é escrito.
* **Modularidade sobre Duplicação (DRY):** Decomponha sistemas complexos em unidades menores, reutilizáveis e isoladas (componentes, serviços, etc.).
* **Arquitetura Baseada em Componentes:** Estruture UIs como uma árvore de componentes.
* **Princípios SOLID:** Adira aos princípios SOLID no design orientado a objetos e de componentes para criar sistemas escaláveis e mantíveis.
* **Nomenclatura Descritiva:** Use nomes claros e descritivos para variáveis, funções, métodos e componentes.
* **Injeção de Dependência:** Favoreça a injeção de dependência e containers de serviço para gerenciar dependências de classe e promover baixo acoplamento.
* **HTML Semântico:** Use elementos HTML semânticos (`<main>`, `<article>`, `<nav>`, etc.) sempre que possível para melhorar acessibilidade e SEO.
* **Sem Placeholders:** Implemente completamente toda funcionalidade solicitada. Não deixe `TODO`s, placeholders ou peças faltando no código final.

## 2. Tratamento de Erros, Logging & Estado

* **Tratamento Robusto de Erros:** Sempre antecipe e trate erros potenciais graciosamente.
    * Use blocos `try-catch` para exceções esperadas.
    * Crie classes de exceção customizadas para erros específicos do domínio quando necessário.
* **Logging Abrangente:** Implemente logging adequado de erros para monitorar a saúde da aplicação e facilitar debugging.
* **Estados de Loading e Erro:** Todos os componentes que fazem fetch de dados devem explicitamente tratar e exibir estados de loading e erro para o usuário, melhorando a UX.

## 3. Princípio da Busca de Dados Otimizada (Chunking)

**Contexto:** Ferramentas de IA possuem uma janela de contexto limitada. Tentar processar uma grande quantidade de dados de uma só vez (como um arquivo Figma inteiro, um banco de dados completo ou logs extensos) pode causar erros, perda de foco e falha na execução da tarefa.

**Diretiva:** Você NUNCA deve solicitar a totalidade de uma fonte de dados grande de uma só vez. Sua abordagem padrão deve ser sempre buscar informações de forma **parcial, filtrada e truncada**.

**Sinais de Alerta (Quando suspeitar que uma busca pode ser muito grande):**
- A tarefa envolve analisar "todos os X" (usuários, produtos, logs do último mês).
- A fonte de dados é conhecida por ser massiva (ex: um arquivo Figma complexo com muitas telas).
- A ferramenta não oferece filtros óbvios ou paginação por padrão.
- A descrição da tarefa é vaga sobre o escopo exato dos dados necessários.

**Estratégias Obrigatórias:**

*   **Busca por ID/Nó Específico:**
    *   **Figma:** Sempre priorize a busca por um `nodeId` específico, um frame ou um componente, em vez de solicitar o arquivo inteiro. Utilize a ferramenta `get_figma_data` com o parâmetro `nodeId`.
        *   ✅ **Bom:** `<tool_name>get_figma_data</tool_name><arguments>{"fileKey": "key", "nodeId": "123:456"}</arguments>`
        *   ❌ **Ruim:** `<tool_name>get_figma_data</tool_name><arguments>{"fileKey": "key"}</arguments>` (sem nodeId)
    *   Aja como um cirurgião, não como uma rede de arrasto.

*   **Paginação e Limites em Bancos de Dados:**
    *   **Supabase (MCP Tool `execute_postgresql`):** Ao consultar bancos de dados, sempre aplique `LIMIT` e `OFFSET` (ou métodos de paginação equivalentes) para buscar os dados em lotes (chunks).
        *   ✅ **Bom:** `SELECT * FROM users LIMIT 10 OFFSET 20;`
        *   ❌ **Ruim:** `SELECT * FROM users;`
    *   **Supabase (MCP Tool `get_tables`, `get_table_schema`):** Estas ferramentas já são otimizadas, mas esteja ciente do volume de dados se um esquema tiver muitas tabelas.

*   **Filtros Rígidos:**
    *   Utilize cláusulas `WHERE` (para SQL) e filtros o mais específicos possível para extrair apenas a informação estritamente necessária para a tarefa em questão.
    *   **Supabase (MCP Tool `retrieve_logs`):** Utilize os parâmetros `filters`, `search`, `hours_ago` e `limit` para refinar a busca de logs.
        *   ✅ **Bom:** `<tool_name>retrieve_logs</tool_name><arguments>{"collection": "postgres", "limit": 50, "hours_ago": 1, "filters": [{"field": "parsed.error_severity", "operator": "=", "value": "ERROR"}]}</arguments>`
        *   ❌ **Ruim:** `<tool_name>retrieve_logs</tool_name><arguments>{"collection": "postgres"}</arguments>` (sem filtros ou limites)

*   **Leitura Parcial de Arquivos:**
    *   **MCP Filesystem (`read_file`):** Para arquivos de log ou documentos extensos, se a tarefa permitir, tente primeiro analisar a estrutura ou metadados. Se precisar ler o conteúdo, esteja ciente do tamanho. Se for muito grande, avise o usuário e peça para refinar o escopo.
    *   **Ferramentas de Busca (`search_files`):** Use regex precisos para encontrar apenas as seções relevantes.

*   **Confirmação de Escopo (Integração com Protocolo Mestre):**
    *   Se uma tarefa parece exigir uma grande quantidade de dados, seu **Passo 2: Planejar a Execução** (do `master_rule.md`) DEVE incluir uma etapa de confirmação com o usuário sobre o escopo exato da informação necessária.
    *   **Exemplo de Plano:** "Para analisar os logs de erro, meu plano é: 1. Usar `retrieve_logs` para buscar os últimos 50 eventos de erro da coleção 'postgres' da última hora. 2. Analisar os erros encontrados. Isso é suficiente ou você precisa de um período de tempo específico ou um volume maior de logs?"
    *   Aguarde a confirmação antes de prosseguir com a busca de dados.

**Checklist Rápido Antes de Buscar Dados:**
1.  Preciso realmente de TODOS esses dados?
2.  Existe um ID ou filtro específico que posso usar?
3.  A ferramenta oferece opções de paginação/limite?
4.  Posso restringir por data ou tipo?
5.  O escopo está claro e confirmado pelo usuário (se a busca for potencialmente grande)?

Ao seguir este princípio, você garante uma operação mais rápida, eficiente, com menor custo e maior confiabilidade.

## 4. Acessibilidade (A11y)

* Garanta que componentes sejam acessíveis usando HTML semântico e atributos `aria-*` apropriados.
* Implemente navegação por teclado adequada.
* Mantenha contraste de cores apropriado.
* Forneça textos alternativos para imagens e elementos visuais.

## 5. Performance

* Otimize para performance desde o início do desenvolvimento.
* Use lazy loading quando apropriado.
* Minimize o tamanho de bundles e assets.
* Implemente caching estratégico.
* Monitore e meça performance regularmente.

## 6. Segurança

* Sempre valide e sanitize inputs do usuário.
* Implemente autenticação e autorização adequadas.
* Use HTTPS em produção.
* Mantenha dependências atualizadas.
* Siga princípios de menor privilégio.

## 7. Testes

* Escreva testes para funcionalidades críticas.
* Mantenha cobertura de testes adequada.
* Use testes unitários, de integração e end-to-end conforme apropriado.
* Mantenha testes simples e focados.
