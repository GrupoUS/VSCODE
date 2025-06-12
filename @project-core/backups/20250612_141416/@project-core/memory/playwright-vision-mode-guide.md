---
description: "Guia completo para uso do Vision Mode do Playwright MCP Microsoft oficial com interações visuais avançadas"
author: "GRUPO US - VIBECODE SYSTEM"
version: "1.0"
tags: ["playwright-vision", "visual-interactions", "computer-vision", "automation", "microsoft-official"]
globs: ["**/*.js", "**/*.ts", "**/*.json", ".vscode/**/*"]
priority: "HIGH"
confidence_required: 8
---

# 👁️ GUIA VISION MODE - PLAYWRIGHT MCP MICROSOFT OFICIAL

## 🎯 OVERVIEW

O Vision Mode do Playwright MCP permite interações visuais avançadas usando screenshots e coordenadas X,Y, complementando o modo padrão de accessibility snapshots para casos onde elementos visuais são críticos.

## 🔧 CONFIGURAÇÃO IMPLEMENTADA

### **Vision Mode Ativado**:
```json
// .vscode/mcp.json
{
  "args": [
    "@playwright/mcp@latest",
    "--vision",
    "--config", "@project-core/configs/playwright-mcp-config.json"
  ]
}

// playwright-mcp-config.json
{
  "vision": true
}
```

### **Quando Usar Vision Mode vs Snapshot Mode**:

#### **Vision Mode (Screenshots + Coordenadas)**:
- ✅ **Canvas/SVG interactions**: Elementos gráficos complexos
- ✅ **Visual design validation**: Verificação de layout e cores
- ✅ **Game interfaces**: Interações em jogos web
- ✅ **Custom UI components**: Elementos não-standard
- ✅ **Image-based interactions**: Cliques em imagens específicas

#### **Snapshot Mode (Accessibility Tree)**:
- ✅ **Standard web elements**: Buttons, inputs, links
- ✅ **Form interactions**: Preenchimento de formulários
- ✅ **Navigation**: Menus e navegação estruturada
- ✅ **Performance critical**: Operações rápidas e determinísticas
- ✅ **Accessibility compliance**: Elementos com roles/labels

## 🛠️ FERRAMENTAS VISION MODE (7 TOOLS)

### **1. browser_screen_capture**
```javascript
// Captura screenshot para análise visual
await browser_screen_capture()
```

**Uso Recomendado**:
- Análise inicial de interfaces complexas
- Documentação visual de estados da aplicação
- Debug de problemas visuais

### **2. browser_screen_click**
```javascript
// Click por coordenadas X,Y
await browser_screen_click({
  element: "Login button in header",
  x: 640,
  y: 100
})
```

**Casos de Uso**:
- Elementos sem seletores CSS adequados
- Botões em canvas ou SVG
- Interações em mapas interativos
- Elementos gerados dinamicamente

### **3. browser_screen_drag**
```javascript
// Drag and drop por coordenadas
await browser_screen_drag({
  startElement: "Draggable item",
  startX: 300,
  startY: 200,
  endElement: "Drop zone",
  endX: 600,
  endY: 400
})
```

**Aplicações**:
- Drag & drop em interfaces customizadas
- Redimensionamento de elementos visuais
- Manipulação de sliders complexos
- Reorganização de dashboards

### **4. browser_screen_type**
```javascript
// Type em modo visual
await browser_screen_type({
  element: "Search field in visual interface",
  text: "GRUPO US automation",
  x: 400,
  y: 150
})
```

### **5. browser_screen_move_mouse**
```javascript
// Movimento preciso do mouse
await browser_screen_move_mouse({
  x: 500,
  y: 300
})
```

**Benefícios**:
- Hover effects em elementos visuais
- Preparação para interações complexas
- Simulação de comportamento humano

### **6. Ferramentas Compartilhadas**
```javascript
// Estas ferramentas funcionam em ambos os modos
await browser_press_key({ key: "Enter" })
await browser_wait_for({ time: 2 })
await browser_file_upload({ paths: ["file.pdf"] })
await browser_handle_dialog({ accept: true })
```

## 🎨 CASOS DE USO PRÁTICOS - GRUPO US

### **1. Teste de Componentes Figma**
```javascript
// Validar componente visual gerado do Figma
await browser_navigate({ url: "http://localhost:3000/components" })
await browser_screen_capture() // Capturar estado inicial
await browser_screen_click({ 
  element: "Custom button component",
  x: 320, 
  y: 240 
})
await browser_wait_for({ text: "Component interaction successful" })
```

### **2. Dashboard Interativo**
```javascript
// Interagir com dashboard visual complexo
await browser_navigate({ url: "https://grupous.com/dashboard" })
await browser_screen_capture() // Documentar layout
await browser_screen_drag({
  startElement: "Widget A",
  startX: 200, startY: 300,
  endElement: "Position B", 
  endX: 600, endY: 300
})
await browser_take_screenshot({ filename: "dashboard-reorganized.png" })
```

### **3. Canvas/Drawing Applications**
```javascript
// Teste de aplicação de desenho
await browser_navigate({ url: "http://localhost:3000/canvas-editor" })
await browser_screen_click({ element: "Brush tool", x: 50, y: 100 })
await browser_screen_drag({
  startX: 300, startY: 200,
  endX: 500, endY: 300
}) // Desenhar linha
await browser_screen_click({ element: "Save button", x: 700, y: 50 })
```

### **4. Map Interactions**
```javascript
// Interações em mapas interativos
await browser_navigate({ url: "https://grupous.com/locations" })
await browser_screen_capture() // Capturar mapa inicial
await browser_screen_click({ 
  element: "São Paulo office marker",
  x: 450, 
  y: 320 
})
await browser_wait_for({ text: "Office details loaded" })
```

## 🔄 WORKFLOW HÍBRIDO RECOMENDADO

### **Estratégia Combinada (Snapshot + Vision)**:

```javascript
// 1. Usar snapshot para navegação estruturada
await browser_navigate({ url: "https://grupous.com/app" })
await browser_snapshot() // Análise accessibility tree

// 2. Usar snapshot para elementos padrão
await browser_click({ 
  element: "Login button",
  ref: "button[data-testid='login']" 
})

// 3. Usar vision para elementos visuais complexos
await browser_screen_capture() // Capturar interface visual
await browser_screen_click({
  element: "Custom visual element",
  x: 400,
  y: 250
})

// 4. Voltar para snapshot para validação
await browser_snapshot() // Verificar resultado
```

## ⚡ OTIMIZAÇÃO DE PERFORMANCE

### **Melhores Práticas**:

#### **1. Use Vision Mode Seletivamente**:
```javascript
// ✅ CORRETO: Vision para elementos visuais específicos
await browser_snapshot() // Rápido para análise geral
await browser_click({ ref: "button.standard" }) // Rápido para elementos padrão
await browser_screen_click({ x: 400, y: 200 }) // Vision apenas quando necessário

// ❌ INCORRETO: Vision para tudo
await browser_screen_capture() // Desnecessário para elementos padrão
await browser_screen_click({ x: 100, y: 50 }) // Lento para botão simples
```

#### **2. Cache Screenshots**:
```javascript
// Capturar screenshot uma vez, usar múltiplas vezes
await browser_screen_capture()
await browser_screen_click({ x: 300, y: 200 })
await browser_screen_click({ x: 400, y: 250 }) // Mesmo screenshot
```

#### **3. Coordenadas Relativas**:
```javascript
// Usar coordenadas baseadas em viewport conhecido
const viewport = { width: 1280, height: 720 }
const centerX = viewport.width / 2  // 640
const centerY = viewport.height / 2 // 360

await browser_screen_click({ x: centerX, y: centerY })
```

## 🧪 TESTING INTEGRATION

### **Geração de Testes Visuais**:
```javascript
// Gerar teste que combina snapshot + vision
await browser_generate_playwright_test({
  name: "Visual Component Test",
  description: "Test visual component with hybrid approach",
  steps: [
    "Navigate to component page",
    "Take accessibility snapshot for structure",
    "Take screenshot for visual validation", 
    "Click visual element at coordinates",
    "Verify result with snapshot"
  ]
})
```

## 🔧 TROUBLESHOOTING VISION MODE

### **Problemas Comuns e Soluções**:

#### **1. Coordenadas Incorretas**:
```javascript
// ❌ PROBLEMA: Coordenadas fixas
await browser_screen_click({ x: 500, y: 300 })

// ✅ SOLUÇÃO: Capturar screenshot primeiro
await browser_screen_capture() // Analisar posições atuais
await browser_screen_click({ 
  element: "Specific visual element",
  x: 500, y: 300 
})
```

#### **2. Viewport Inconsistente**:
```javascript
// ✅ SOLUÇÃO: Garantir viewport consistente
await browser_resize({ width: 1280, height: 720 })
await browser_screen_capture()
await browser_screen_click({ x: 640, y: 360 }) // Centro conhecido
```

#### **3. Timing Issues**:
```javascript
// ✅ SOLUÇÃO: Wait antes de interações visuais
await browser_wait_for({ time: 2 }) // Aguardar renderização
await browser_screen_capture()
await browser_screen_click({ x: 400, y: 200 })
```

## 📊 MÉTRICAS DE PERFORMANCE

### **Benchmarks Vision vs Snapshot**:
- **Snapshot Mode**: ~500ms (accessibility tree)
- **Vision Mode**: ~2000ms (screenshot + analysis)
- **Hybrid Approach**: ~1000ms (otimizado)

### **Recomendações de Uso**:
- **80% Snapshot**: Elementos estruturados padrão
- **20% Vision**: Elementos visuais específicos
- **Hybrid**: Melhor performance geral

## 🎯 PRÓXIMOS PASSOS

### **Exploração Avançada**:
1. **Computer Vision Integration**: Reconhecimento de padrões visuais
2. **AI-Powered Interactions**: Detecção automática de elementos
3. **Visual Regression Testing**: Comparação de screenshots
4. **Custom Visual Selectors**: Seletores baseados em características visuais

---

**🎉 RESULTADO**: Vision Mode implementado com sucesso, oferecendo capacidades visuais avançadas complementares ao modo snapshot padrão, otimizado para casos de uso específicos do GRUPO US.
