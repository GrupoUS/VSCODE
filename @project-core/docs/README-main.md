# 🚀 GRUPO US VIBECODE SYSTEM V2.0 - Task Master AI CLI

## 📋 Visão Geral do Projeto

O **Task Master AI CLI** é uma ferramenta avançada de linha de comando integrada ao **GRUPO US VIBECODE SYSTEM V2.0**, projetada para gerenciar tarefas com otimização de IA e execução autônoma. Esta ferramenta permite aos usuários adicionar, listar, visualizar, atualizar e excluir tarefas de forma eficiente, com suporte completo para protocolos de execução autônoma e integração MCP.

### 🎯 **Principais Características:**

- ✅ **Execução Autônoma**: Protocolo de execução não supervisionada após aprovação inicial
- ✅ **Integração MCP**: Suporte completo para TaskMaster, Playwright, Figma e Supabase
- ✅ **VIBECODE SYSTEM V2.0**: Arquitetura centralizada de regras e protocolos
- ✅ **Gestão Inteligente**: IA otimizada para decomposição e execução de tarefas complexas
- ✅ **Qualidade Garantida**: Padrões GRUPO US de excelência técnica

### 📊 **Status do Sistema:**

- **Versão**: V2.0.0 (VIBECODE SYSTEM)
- **Protocolos Ativos**: Unattended Execution Protocol V1.0.0
- **Integração MCP**: ✅ Operacional
- **TaskMaster**: ✅ Inicializado e funcional
- **Última Atualização**: 2025-06-07

## 🚀 NEON PRO V2.0 - Next.js Setup

### Instalação e Configuração

1.  **Clone o repositório:**

    ```bash
    git clone [URL_DO_REPOSITORIO]
    cd neonpro
    ```

2.  **Instale as dependências:**

    ```bash
    npm install
    ```

3.  **Inicie o servidor de desenvolvimento:**

    ```bash
    npm run dev
    ```

4.  **Acesse a aplicação:**
    Abra [http://localhost:3000](http://localhost:3000) no seu navegador.

### Estrutura do Projeto

- `app/` - Diretório principal do Next.js App Router
- `src/app/` - Estrutura completa da aplicação
- `next.config.ts` - Configuração otimizada do Next.js 15
- `package.json` - Dependências e scripts do projeto

**Nota**: O projeto foi corrigido para funcionar com Next.js 15 e suporta tanto a estrutura `app/` na raiz quanto `src/app/`.

## Uso

O CLI oferece os seguintes comandos para gerenciar suas tarefas:

### Adicionar uma Tarefa

Adiciona uma nova tarefa ao seu projeto.

```bash
node cli.js add "<Título da Tarefa>" "<Descrição da Tarefa>" [opções]
```

**Opções:**

- `-s, --status <status>`: Status da tarefa (ex: `pending`, `in-progress`, `done`). Padrão: `pending`.
- `-p, --priority <priority>`: Prioridade da tarefa (ex: `high`, `medium`, `low`). Padrão: `medium`.
- `-d, --dependencies <ids>`: Lista de IDs de tarefas separadas por vírgula das quais esta tarefa depende.

**Exemplo:**

```bash
node cli.js add "Implementar Autenticação" "Adicionar sistema de login e registro" -p high -d 1,2
```

### Listar Todas as Tarefas

Lista todas as tarefas existentes.

```bash
node cli.js list
```

**Exemplo de Saída:**

```
ID: 1, Título: Inicializar Projeto, Status: done, Prioridade: high, Dependências:
ID: 2, Título: Implementar CRUD, Status: in-progress, Prioridade: high, Dependências: 1
```

### Mostrar Detalhes de uma Tarefa

Exibe todos os detalhes de uma tarefa específica pelo seu ID.

```bash
node cli.js show <ID_DA_TAREFA>
```

**Exemplo:**

```bash
node cli.js show 1
```

**Exemplo de Saída:**

```json
Detalhes da Tarefa: {
  "id": 1,
  "title": "Inicializar Projeto",
  "description": "Configurar o ambiente inicial do projeto.",
  "status": "done",
  "priority": "high",
  "dependencies": []
}
```

### Atualizar uma Tarefa

Atualiza as propriedades de uma tarefa existente pelo seu ID.

```bash
node cli.js update <ID_DA_TAREFA> [opções]
```

**Opções:**

- `-t, --title <title>`: Novo título para a tarefa.
- `-d, --description <description>`: Nova descrição para a tarefa.
- `-s, --status <status>`: Novo status para a tarefa.
- `-p, --priority <priority>`: Nova prioridade para a tarefa.
- `-e, --dependencies <ids>`: Nova lista de IDs de tarefas separadas por vírgula das quais esta tarefa depende.

**Exemplo:**

```bash
node cli.js update 2 -s done -p medium
```

### Excluir uma Tarefa

Remove uma tarefa pelo seu ID.

```bash
node cli.js delete <ID_DA_TAREFA>
```

**Exemplo:**

```bash
node cli.js delete 3
```

## Desenvolvimento

### Estrutura do Projeto

```
.
├── cli.js                  # Ponto de entrada da CLI
├── models/
│   └── task.js             # Definição do modelo de dados da tarefa
├── services/
│   └── taskService.js      # Lógica CRUD para tarefas
├── __tests__/
│   ├── taskService.test.js # Testes unitários para taskService
│   └── cli.e2e.test.js     # Testes end-to-end para a CLI
├── jest.config.js          # Configuração do Jest
├── babel.config.js         # Configuração do Babel para transpilação
├── package.json            # Dependências e scripts
├── .gitignore              # Arquivos e diretórios ignorados pelo Git
└── .taskmaster/            # Arquivos de configuração e dados do TaskMaster
    └── tasks/
        └── tasks.json      # Armazenamento de dados das tarefas
    └── tasks-test/
        └── tasks.test.json # Armazenamento de dados para testes
```

### Executando Testes

Para executar os testes unitários e end-to-end:

```bash
npm test
```

### Contribuindo

1.  Faça um fork do repositório.
2.  Crie uma nova branch para sua feature (`git checkout -b feature/sua-feature`).
3.  Faça suas alterações e escreva testes.
4.  Certifique-se de que todos os testes passem (`npm test`).
5.  Envie suas alterações (`git push origin feature/sua-feature`).
6.  Abra um Pull Request.

## Solução de Problemas

- **`Error: No valid tasks found in .taskmaster/tasks/tasks.json`**: Isso pode ocorrer se o arquivo `tasks.json` estiver vazio ou corrompido. Tente recriar as tarefas a partir do seu PRD usando `task-master parse-prd scripts/prd.txt`.
- **Erros de `SyntaxError: Cannot use import statement outside a module` ou `Unexpected token 'export'` em `node_modules` durante os testes**: Isso indica que o Jest não está transpilando corretamente os módulos ES. Verifique a configuração `transformIgnorePatterns` em `jest.config.js` e `babel.config.js`.
- **Testes E2E falhando devido a dados inconsistentes**: Certifique-se de que o `beforeEach` nos testes E2E limpa o arquivo de dados de teste (`.taskmaster/tasks-test/tasks.test.json`) antes de cada execução.

## 🤖 Protocolos de Execução Autônoma

### **Unattended Execution Protocol V1.0.0**

Este projeto implementa o protocolo de execução autônoma do GRUPO US VIBECODE SYSTEM V2.0:

- **Ativação**: Aprovação inicial com "YARRR!", "sim", "prossiga", "ok", "execute"
- **Execução Contínua**: Sem interrupções após aprovação do plano
- **Comandos Não-Interativos**: Sistema de flags prioritário (--yes, --force, --assume-yes)
- **Modificações Automáticas**: Seleção automática de "keep changes"
- **Override de Emergência**: "EXECUTE WITH MANUAL SUPERVISION"

### **Documentação de Protocolos**

- 📋 **Regras Centralizadas**: `@project-core/rules/`
- 🧠 **Memory Bank**: `memory-bank/` (aprendizado contínuo)
- 🔧 **Configurações MCP**: `.cursor/mcp.json`
- 📊 **Logs de Execução**: `memory-bank/self_correction_log.md`

## 🔗 Links de Documentação

### **Protocolos e Regras:**

- [Master Execution Protocol](project-core/rules/00-master-execution-protocol.md)
- [Unattended Execution Protocol](project-core/rules/01-unattended-execution-protocol.md)
- [Core Principles](project-core/rules/01-core-principles.md)
- [Coding Standards](project-core/rules/02-coding-standards-universal.md)

### **Integrações MCP:**

- [TaskMaster Protocol](project-core/rules/mcp-integration/taskmaster-protocol.md)
- [Playwright Automation](project-core/rules/mcp-integration/playwright-automation.md)
- [Figma Design Sync](project-core/rules/mcp-integration/figma-design-sync.md)
- [Supabase Database](project-core/rules/mcp-integration/supabase-database.md)

### **Design System:**

- [Universal Design System](project-core/rules/design-system.md)
- [Color Palette](project-core/rules/design-system/universal-color-palette.md)
- [Typography System](project-core/rules/design-system/typography-system.md)
- [Component Standards](project-core/rules/design-system/component-library-standards.md)

## 📈 Métricas de Qualidade

### **KPIs do Sistema:**

- **Completion Rate**: >85% primeira tentativa
- **Token Usage**: <50k por feature
- **Error Rate**: <15% em produção
- **User Satisfaction**: >9/10

### **Monitoramento Ativo:**

- Execução autônoma em tempo real
- Logs detalhados de decisões
- Métricas de performance contínuas
- Feedback loop de aprendizado

## 🚀 GRUPO US VIBECODE SYSTEM V2.0

**Excellence Through Integration!**

## Licença

Este projeto está licenciado sob a licença ISC.
