---
description: Regras para uso efetivo do MCP Playwright para automação de testes e interações com o navegador.
globs: ["**/*"]
alwaysApply: true
---

# Regras de Uso do MCP Playwright

Este documento define as diretrizes e melhores práticas para a utilização do MCP Playwright, garantindo automação de testes eficiente, interações confiáveis com o navegador e integração harmoniosa com o fluxo de trabalho existente.

## 1. Configuração Essencial

### 1.1. Modo Headless
- **SEMPRE** configure o Playwright para rodar em modo não-headless (`"PLAYWRIGHT_HEADLESS": "false"`) durante o desenvolvimento e depuração para visualização das interações.
- Para ambientes de CI/CD ou execução em background, o modo headless pode ser ativado.

### 1.2. Configuração do `.vscode/mcp.json`
- Mantenha o arquivo `.vscode/mcp.json` atualizado com as configurações mais recentes do Playwright MCP.
- **NUNCA** modifique este arquivo manualmente, a menos que instruído explicitamente. Use as ferramentas apropriadas para gerenciar as configurações.

## 2. Interações com o Navegador

### 2.1. Navegação
- Utilize `playwright_navigate` para abrir URLs.
- **SEMPRE** verifique se a URL está correta e acessível antes de iniciar as interações.

### 2.2. Cliques e Preenchimento
- Use `playwright_click` para interações de clique.
- Use `playwright_fill` para preencher campos de texto.
- Para elementos dentro de iframes, utilize `playwright_iframe_click` e `playwright_iframe_fill`.
- **SEMPRE** utilize seletores CSS robustos e únicos para garantir a estabilidade dos testes.

### 2.3. Capturas de Tela
- Utilize `playwright_screenshot` para capturar o estado visual da página.
- Nomeie as capturas de tela de forma descritiva para facilitar a depuração.

### 2.4. Logs do Console
- Use `playwright_console_logs` para monitorar mensagens do console do navegador.
- Filtre os logs por tipo (`error`, `warning`, etc.) e por texto de busca para focar em informações relevantes.

## 3. Automação de Testes

### 3.1. Geração de Código
- Utilize `start_codegen_session` para iniciar sessões de gravação de testes.
- `end_codegen_session` para finalizar e gerar o arquivo de teste.
- Revise e refatore o código gerado para melhorar a legibilidade e a manutenibilidade.

### 3.2. Estrutura de Testes
- Organize os testes em diretórios lógicos (ex: `tests/e2e`, `tests/integration`).
- Siga as convenções de nomenclatura de arquivos de teste (ex: `nome-da-feature.spec.ts`).

### 3.3. Assertions
- Utilize as ferramentas de asserção do Playwright para validar o comportamento esperado da aplicação.
- Inclua asserções para elementos visíveis, texto, atributos e estados.

## 4. Boas Práticas e Troubleshooting

### 4.1. Tratamento de Erros
- Implemente blocos `try-catch` para lidar com falhas esperadas durante as interações.
- Registre erros detalhados para facilitar a depuração.

### 4.2. Otimização de Performance
- Evite esperas desnecessárias (`waitForTimeout`). Utilize esperas condicionais (`waitForSelector`, `waitForLoadState`).
- Minimize o número de interações para acelerar a execução dos testes.

### 4.3. Depuração
- Utilize o modo não-headless para depurar visualmente os testes.
- Inspecione os logs do console e as capturas de tela para identificar a causa raiz dos problemas.

## 5. Integração com o Workflow

### 5.1. CI/CD
- Integre os testes Playwright no pipeline de CI/CD para garantir a qualidade contínua da aplicação.
- Configure os ambientes de CI/CD para instalar as dependências necessárias do Playwright.

### 5.2. Versionamento
- Mantenha os arquivos de teste e as configurações do Playwright sob controle de versão.

---
