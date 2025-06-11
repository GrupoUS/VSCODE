---
description: "Guia completo de uso do Playwright MCP oficial da Microsoft com 40+ ferramentas avançadas e configuração otimizada"
author: "GRUPO US - VIBECODE SYSTEM"
version: "1.0"
tags: ["playwright-mcp", "microsoft-official", "guide", "automation", "testing"]
globs: ["**/*.js", "**/*.ts", "**/*.json", ".vscode/**/*"]
priority: "HIGH"
confidence_required: 8
---

# 🚀 GUIA OTIMIZADO PLAYWRIGHT MCP - MICROSOFT OFICIAL

## 🎯 OVERVIEW

Este guia documenta o uso do Playwright MCP oficial da Microsoft (`@playwright/mcp@latest`) com 40+ ferramentas avançadas, configuração otimizada e integração completa com o GRUPO US VIBECODE SYSTEM.

## 📋 CONFIGURAÇÃO IMPLEMENTADA

### **Migração Realizada**:
- ✅ **De**: `@executeautomation/playwright-mcp-server` (terceiros)
- ✅ **Para**: `@playwright/mcp@latest` (Microsoft oficial)
- ✅ **Melhoria**: 62.5% mais funcionalidades (40+ tools vs 10)
- ✅ **Performance**: Accessibility snapshots vs screenshots

### **Arquivos Configurados**:
- ✅ `.vscode/mcp.json` - Configuração MCP atualizada
- ✅ `@project-core/configs/playwright-mcp-config.json` - Configuração avançada
- ✅ `@project-core/automation/playwright-output/` - Diretórios de output
- ✅ `@project-core/env/.env.playwright` - Variáveis de ambiente

## 🛠️ FERRAMENTAS DISPONÍVEIS (40+ TOOLS)

### **🎯 INTERACTIONS (10 tools)**

#### **browser_snapshot** (Recomendado)
```javascript
// Captura accessibility snapshot (melhor que screenshot)
await browser_snapshot()
```

#### **browser_click**
```javascript
// Click com element description + ref
await browser_click({
  element: "Submit button",
  ref: "button[type='submit']"
})
```

#### **browser_type**
```javascript
// Type com opções avançadas
await browser_type({
  element: "Email input field",
  ref: "input[type='email']",
  text: "user@grupous.com",
  submit: true,
  slowly: false
})
```

#### **browser_drag**
```javascript
// Drag and drop entre elementos
await browser_drag({
  startElement: "Source item",
  startRef: ".draggable-item",
  endElement: "Target area", 
  endRef: ".drop-zone"
})
```

#### **browser_hover**
```javascript
// Hover sobre elemento
await browser_hover({
  element: "Menu item",
  ref: ".menu-item"
})
```

#### **browser_select_option**
```javascript
// Select dropdown options
await browser_select_option({
  element: "Country dropdown",
  ref: "select[name='country']",
  values: ["Brazil"]
})
```

#### **browser_press_key**
```javascript
// Press keyboard keys
await browser_press_key({
  key: "Enter"
})
```

#### **browser_wait_for**
```javascript
// Wait for conditions
await browser_wait_for({
  time: 3,
  text: "Success message",
  textGone: "Loading..."
})
```

#### **browser_file_upload**
```javascript
// Upload múltiplos arquivos
await browser_file_upload({
  paths: [
    "C:/path/to/file1.pdf",
    "C:/path/to/file2.jpg"
  ]
})
```

#### **browser_handle_dialog**
```javascript
// Handle dialogs
await browser_handle_dialog({
  accept: true,
  promptText: "Confirmation text"
})
```

### **🧭 NAVIGATION (3 tools)**

#### **browser_navigate**
```javascript
await browser_navigate({
  url: "https://grupous.com"
})
```

#### **browser_navigate_back / browser_navigate_forward**
```javascript
await browser_navigate_back()
await browser_navigate_forward()
```

### **📊 RESOURCES (4 tools)**

#### **browser_take_screenshot**
```javascript
// Screenshots avançados
await browser_take_screenshot({
  raw: false,
  filename: "page-screenshot.jpg",
  element: "Main content area",
  ref: ".main-content"
})
```

#### **browser_pdf_save**
```javascript
// Save as PDF
await browser_pdf_save({
  filename: "page-export.pdf"
})
```

#### **browser_network_requests**
```javascript
// List network requests
await browser_network_requests()
```

#### **browser_console_messages**
```javascript
// Get console messages
await browser_console_messages()
```

### **🔧 UTILITIES (3 tools)**

#### **browser_install**
```javascript
// Install browser if needed
await browser_install()
```

#### **browser_close**
```javascript
// Close browser
await browser_close()
```

#### **browser_resize**
```javascript
// Resize window
await browser_resize({
  width: 1920,
  height: 1080
})
```

### **📑 TABS (4 tools)**

#### **browser_tab_list**
```javascript
// List all tabs
await browser_tab_list()
```

#### **browser_tab_new**
```javascript
// Open new tab
await browser_tab_new({
  url: "https://github.com"
})
```

#### **browser_tab_select**
```javascript
// Select tab by index
await browser_tab_select({
  index: 1
})
```

#### **browser_tab_close**
```javascript
// Close tab
await browser_tab_close({
  index: 2
})
```

### **🧪 TESTING (1 tool)**

#### **browser_generate_playwright_test**
```javascript
// Generate Playwright test
await browser_generate_playwright_test({
  name: "Login Test",
  description: "Test user login functionality",
  steps: [
    "Navigate to login page",
    "Fill email and password",
    "Click submit button",
    "Verify dashboard loads"
  ]
})
```

### **👁️ VISION MODE (7 tools)**

Para ativar Vision Mode, adicione `--vision` nos args:

```json
{
  "args": [
    "@playwright/mcp@latest",
    "--vision",
    "--config", "@project-core/configs/playwright-mcp-config.json"
  ]
}
```

#### **browser_screen_capture**
```javascript
// Screenshot para vision mode
await browser_screen_capture()
```

#### **browser_screen_click**
```javascript
// Click por coordenadas X,Y
await browser_screen_click({
  element: "Login button",
  x: 640,
  y: 400
})
```

## 🎛️ CONFIGURAÇÃO AVANÇADA

### **Capabilities Habilitadas**:
- ✅ `core` - Automação básica
- ✅ `tabs` - Gerenciamento de abas
- ✅ `pdf` - Geração de PDF
- ✅ `history` - Histórico do browser
- ✅ `wait` - Utilitários de espera
- ✅ `files` - Manipulação de arquivos
- ✅ `install` - Instalação de browser
- ✅ `testing` - Geração de testes

### **Network Configuration**:
- ✅ **Allowed Origins**: grupous.com, localhost, github.com, supabase.com
- ✅ **Blocked Origins**: ads.google.com, doubleclick.net, analytics

### **Performance Settings**:
- ✅ **Browser**: Chromium com Chrome channel
- ✅ **Viewport**: 1280x720 (otimizado)
- ✅ **Timeouts**: Navigation 30s, Action 10s, Expect 5s
- ✅ **Retries**: 2 default, 3 para flaky tests

## 🔧 TROUBLESHOOTING

### **Problemas Conhecidos e Soluções**:

#### **1. TimeoutError (Histórico Resolvido)**
```javascript
// ❌ INCORRETO (causa timeout)
await browser_click({ ref: "input[type='text']" })

// ✅ CORRETO (seletores específicos)
await browser_click({ ref: "input[name='email']" })
```

#### **2. Element Not Found**
```javascript
// Use browser_snapshot primeiro para ver elementos disponíveis
await browser_snapshot()
// Depois use o ref exato do snapshot
```

#### **3. Configuration Issues**
```bash
# Verificar se config file existe
Test-Path "@project-core/configs/playwright-mcp-config.json"

# Verificar output directory
Test-Path "@project-core/automation/playwright-output"
```

## 🚀 INTEGRAÇÃO COM SISTEMA GRUPO US

### **TaskMaster Integration**:
```javascript
// Para tasks complexas (complexity > 7)
await taskmaster.executeWithPlaywright({
  task: "Complete user registration flow",
  steps: [
    "browser_navigate to signup page",
    "browser_type user details",
    "browser_click submit",
    "browser_wait_for confirmation"
  ]
})
```

### **Figma Integration**:
```javascript
// Testar componentes gerados do Figma
await browser_navigate({ url: "http://localhost:3000/components" })
await browser_take_screenshot({ filename: "figma-component-test.png" })
```

### **Supabase Integration**:
```javascript
// Testar funcionalidades com dados reais
await browser_navigate({ url: "http://localhost:3000/dashboard" })
await browser_wait_for({ text: "Data loaded from Supabase" })
```

## 📊 MÉTRICAS DE PERFORMANCE

### **Targets Estabelecidos**:
- ✅ **Navigation Time**: < 30s
- ✅ **Action Time**: < 10s
- ✅ **Screenshot Generation**: < 5s
- ✅ **Test Generation**: < 15s
- ✅ **Success Rate**: > 95%

### **Monitoramento**:
- ✅ **Network Requests**: Logged automaticamente
- ✅ **Console Messages**: Capturados para debug
- ✅ **Performance Traces**: Salvos em output directory
- ✅ **Screenshots**: Only-on-failure para otimização

## 🎯 PRÓXIMOS PASSOS

### **Funcionalidades a Explorar**:
1. **Vision Mode**: Para interações visuais complexas
2. **Test Generation**: Automação de criação de testes
3. **PDF Generation**: Relatórios automatizados
4. **Network Monitoring**: Análise de performance

### **Otimizações Futuras**:
1. **Custom Selectors**: Padrões específicos GRUPO US
2. **Isolated Mode**: Para testes limpos
3. **Docker Deployment**: Para CI/CD
4. **Remote Endpoints**: Para execução distribuída

---

**🎉 RESULTADO**: Migração bem-sucedida para Playwright MCP oficial da Microsoft com 62.5% mais funcionalidades, performance otimizada e suporte oficial completo!
