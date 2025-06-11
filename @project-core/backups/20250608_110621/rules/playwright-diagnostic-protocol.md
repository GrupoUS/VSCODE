# PLAYWRIGHT DIAGNOSTIC PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 🎯 PROTOCOLO PARA DIAGNÓSTICO DE PROBLEMAS PLAYWRIGHT

### **QUANDO USAR**
- TimeoutError em automações Playwright
- Elementos não encontrados (waitForSelector failures)
- Navegação não funcionando como esperado
- Problemas de integração TaskMaster + Playwright

### **METODOLOGIA DE 4 ETAPAS**

#### **STEP 1: VERIFICAÇÃO BÁSICA**
```bash
# 1. Verificar instalação Playwright
npx playwright --version

# 2. Verificar browsers instalados
npx playwright install --with-deps

# 3. Teste básico de navegação
node -e "const { chromium } = require('playwright'); (async () => { const browser = await chromium.launch(); const page = await browser.newPage(); await page.goto('https://www.google.com'); console.log('✅ Navegação básica OK'); await browser.close(); })()"
```

#### **STEP 2: SCRIPT DE DIAGNÓSTICO ISOLADO**
```javascript
// Usar diagnose-playwright.js como template
// Testes progressivos:
// 1. Site confiável (Google)
// 2. Site alvo específico
// 3. Análise de elementos HTML reais
```

#### **STEP 3: ANÁLISE DE CAUSA RAIZ**
**Checklist de Problemas Comuns:**
- [ ] **Case sensitivity** no parser de tarefas
- [ ] **Seletores CSS** incorretos ou genéricos
- [ ] **URLs** sem protocolo não detectadas
- [ ] **Timeouts** insuficientes
- [ ] **Elementos** não visíveis ou carregados
- [ ] **Navegação** não completada

#### **STEP 4: IMPLEMENTAÇÃO DE CORREÇÕES**
**Padrões de Solução:**
1. **Case-insensitive parsing**
2. **Seletores específicos** baseados em análise real
3. **Parser de URL robusto**
4. **Timeouts adequados**
5. **Wait strategies** apropriadas

---

## 🛠️ TEMPLATES DE CÓDIGO

### **Parser Case-Insensitive**
```javascript
const descLower = description.toLowerCase();
if (descLower.includes("navegar") || descLower.includes("navigate")) {
  // Lógica de navegação
}
```

### **Parser de URL Robusto**
```javascript
let urlMatch = description.match(/https?:\/\/[^\s,]+/);
if (!urlMatch) {
  urlMatch = description.match(/([a-zA-Z0-9.-]+\.[a-zA-Z]{2,}[^\s,]*)/);
  if (urlMatch) {
    urlMatch[0] = "https://" + urlMatch[0];
  }
}
```

### **Seletores Múltiplos com Fallback**
```javascript
case "fill_form_specific":
  const results = [];
  for (const selector of step.selectors) {
    try {
      await this.automation.fill(selector, step.value);
      results.push({ selector, success: true });
    } catch (error) {
      results.push({ selector, success: false, error: error.message });
    }
  }
  return { success: results.some(r => r.success) };
```

---

## 📋 CHECKLIST DE DIAGNÓSTICO

### **Pré-Diagnóstico**
- [ ] Workspace verification executada
- [ ] TaskMaster initialized (se complexidade ≥7)
- [ ] Confidence level ≥8/10
- [ ] Logs detalhados habilitados

### **Durante Diagnóstico**
- [ ] Script isolado criado
- [ ] Teste básico (Google) executado
- [ ] Teste específico (site alvo) executado
- [ ] Screenshots capturados
- [ ] Elementos HTML analisados

### **Pós-Diagnóstico**
- [ ] Causa raiz identificada
- [ ] Correções implementadas
- [ ] Testes de validação executados
- [ ] Memory bank atualizado
- [ ] Documentação criada

---

## 🎯 MÉTRICAS DE SUCESSO

### **Critérios de Aprovação**
- ✅ Taxa de sucesso ≥95%
- ✅ Tempo de execução otimizado
- ✅ Screenshots capturados corretamente
- ✅ Logs sem erros críticos
- ✅ Elementos encontrados e interagidos

### **KPIs de Qualidade**
- **Completion Rate**: >85% primeira tentativa
- **Error Rate**: <15% em produção
- **Average Execution Time**: <30s por tarefa
- **User Satisfaction**: >9/10

---

## 🔄 INTEGRAÇÃO COM VIBECODE SYSTEM V2.0

### **Protocolos Obrigatórios**
1. **Pre-execution verification** de workspace
2. **TaskMaster initialization** para complexidade ≥7
3. **4-step execution cycle** (ULTRATHINK/PLAN/EXECUTE/LEARN)
4. **Centralized rule management** em @project-core/
5. **Memory bank updates** pós-execução

### **Ferramentas MCP**
- **TaskMaster**: Gestão de tarefas complexas
- **Playwright**: Automação e testes
- **Sequential Thinking**: Para análise complexa

---

## 📚 REFERÊNCIAS

- `diagnose-playwright.js` - Script de diagnóstico reutilizável
- `memory-bank/self_correction_log.md` - Histórico de soluções
- `PLAYWRIGHT-DIAGNOSTIC-SOLUTION.md` - Documentação completa
- TaskMaster Task #11 - Caso de sucesso documentado

---

**GRUPO US VIBECODE SYSTEM V2.0 - Playwright Diagnostic Protocol**
