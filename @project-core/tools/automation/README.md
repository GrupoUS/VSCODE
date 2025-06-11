# 🎭 GRUPO US - Playwright Automation Suite

Seguindo **VIBECODE SYSTEM V2.0** - Sistema completo de automação com Playwright e MCP.

## 🚀 Configuração Inicial

### 1. Instalação das Dependências
```bash
npm install
npm run setup:automation
```

### 2. Configuração do MCP
O arquivo `.vscode/mcp.json` já está configurado com:
- Playwright MCP Server
- Variáveis de ambiente otimizadas
- Configurações de timeout e browser

### 3. Variáveis de Ambiente
Arquivo `.env.playwright` contém todas as configurações necessárias.

## 📋 Scripts Disponíveis

### Testes Playwright
```bash
npm test                    # Executar testes
npm run test:headed         # Testes com interface gráfica
npm run test:debug          # Modo debug
```

### Automações Básicas
```bash
npm run automation:basic    # Navegação básica
npm run automation:form     # Automação de formulários
npm run automation:multi    # Teste multi-browser
```

### Utilitários
```bash
npm run playwright:codegen  # Gerar código automaticamente
npm run mcp:start          # Iniciar servidor MCP
```

## 🎯 Exemplos de Uso

### 1. Navegação Básica
```javascript
const PlaywrightAutomation = require('./automation/playwright-basic');

const automation = new PlaywrightAutomation();
await automation.init('chromium');
await automation.navigate('https://example.com');
await automation.screenshot('homepage');
await automation.close();
```

### 2. Automação de Formulários
```javascript
await automation.fill('input[name="email"]', 'test@grupous.com');
await automation.click('button[type="submit"]');
await automation.waitForElement('.success-message');
```

### 3. Teste Multi-Browser
```javascript
const multiBrowserTest = require('./automation/examples/multi-browser-test');
const results = await multiBrowserTest();
console.log(results);
```

## 🔧 Configurações Avançadas

### Timeouts
- **Navegação**: 30s
- **Elementos**: 10s
- **Testes**: 60s

### Screenshots
- Automáticas em caso de erro
- Pasta: `screenshots/`
- Formato: PNG com timestamp

### Browsers Suportados
- ✅ Chromium (padrão)
- ✅ Firefox
- ✅ WebKit (Safari)

## 🎭 Integração MCP

### Comandos Disponíveis via MCP
- `playwright_navigate` - Navegar para URL
- `playwright_click` - Clicar em elemento
- `playwright_fill` - Preencher campo
- `playwright_screenshot` - Capturar tela
- `playwright_close` - Fechar browser

### Exemplo de Uso MCP
```xml
<use_mcp_tool>
<server_name>github.com/executeautomation/mcp-playwright</server_name>
<tool_name>playwright_navigate</tool_name>
<arguments>
{
  "url": "https://grupous.com"
}
</arguments>
</use_mcp_tool>
```

## 📊 Monitoramento e Logs

### Logs Estruturados
- ✅ Sucesso
- ❌ Erro
- 📸 Screenshot
- 🌐 Navegação
- 👆 Clique
- ✏️ Preenchimento

### Métricas
- Tempo de carregamento
- Taxa de sucesso
- Performance por browser

## 🛠️ Troubleshooting

### Browser não abre
```bash
# Verificar instalação
npm run playwright:install

# Verificar configuração MCP
cat .vscode/mcp.json
```

### Elemento não encontrado
- Verificar seletor CSS
- Usar `waitForElement()` para elementos dinâmicos
- Capturar screenshot para debug

### Performance lenta
- Ajustar `PLAYWRIGHT_SLOW_MO` no `.env.playwright`
- Usar `headless: true` para CI/CD
- Otimizar seletores

## 📚 Documentação Adicional

- [Playwright Docs](https://playwright.dev/)
- [MCP Playwright](https://github.com/executeautomation/mcp-playwright)
- [GRUPO US Standards](../memory-bank/global-standards.md)

---

**GRUPO US VIBECODE SYSTEM V2.0** - Maximize resultados, minimize tokens! 🚀
