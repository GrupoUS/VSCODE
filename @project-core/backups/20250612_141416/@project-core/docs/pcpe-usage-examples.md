# 🛡️ P.C.P.E. - EXEMPLOS PRÁTICOS DE USO

## 📋 OVERVIEW

Este documento apresenta exemplos práticos de como o **Protocolo de Correção Proativa de Erros (P.C.P.E.)** funciona em situações reais do desenvolvimento GRUPO US.

## 🎯 EXEMPLO 1: ERRO DE DEPENDÊNCIA NPM

### **Situação Real:**
```bash
# Comando executado
npm install @shadcn/ui

# Erro retornado
npm ERR! peer dep missing: react@^18.0.0, required by @shadcn/ui@0.8.0
```

### **Ativação do P.C.P.E.:**

#### **🚨 Passo 1: HALT - Parar e Isolar**
```
🚨 ERRO DETECTADO. Ativando P.C.P.E. - Protocolo de Correção Proativa de Erros
📊 Iniciando análise de causa raiz e consulta à memória centralizada...

⏸️ EXECUÇÃO PAUSADA
🕐 Timestamp: 2025-06-07T18:00:00Z
📝 Comando que falhou: npm install @shadcn/ui
❌ Erro capturado: npm ERR! peer dep missing: react@^18.0.0
🎯 Escopo identificado: DEPENDENCIA
```

#### **🔍 Passo 2: ANALYZE - Consulta à Memória**
```
🔍 INICIANDO ANÁLISE - Consulta à Memória Centralizada

📚 Consultando memory-bank/self_correction_log.md...
🔍 Buscando por: "peer dep missing", "react", "shadcn"

✅ SOLUÇÃO ENCONTRADA NA MEMÓRIA
📅 Referência: Log de 2025-06-05 - Entrada #142
🔧 Solução aplicada anteriormente: Install peer dependency first: npm install react@^18.0.0
⏭️ Pulando para Passo 4 (Aplicação da Correção)
```

#### **🔧 Passo 4: TROUBLESHOOT - Ação Corretiva**
```
🔧 APLICANDO CORREÇÃO IDENTIFICADA

🛠️ Executando: npm install react@^18.0.0
✅ React 18.2.0 instalado com sucesso

🔄 Re-executando comando original: npm install @shadcn/ui
✅ @shadcn/ui instalado com sucesso

✅ CORREÇÃO APLICADA COM SUCESSO
📈 Problema resolvido em 45 segundos
⏭️ Prosseguindo para Passo 5 (Registro)
```

#### **📝 Passo 5: HALT - Registro Obrigatório**
```
📝 REGISTRO COMPLETO NO MEMORY BANK
✅ Entrada #247 atualizada (solução reutilizada)
🧠 Contador de eficácia incrementado
🔄 Retomando tarefa original...
```

---

## 🎯 EXEMPLO 2: ERRO DE TYPESCRIPT

### **Situação Real:**
```typescript
// Código com erro
const user = await getUser(id);
const name = user.profile.name; // Error: Object is possibly 'undefined'
```

### **Ativação do P.C.P.E.:**

#### **🚨 Passo 1: HALT - Parar e Isolar**
```
🚨 ERRO DETECTADO. Ativando P.C.P.E. - Protocolo de Correção Proativa de Erros

⏸️ EXECUÇÃO PAUSADA
🕐 Timestamp: 2025-06-07T18:05:00Z
📝 Comando que falhou: TypeScript compilation
❌ Erro capturado: Object is possibly 'undefined' at user.profile.name
🎯 Escopo identificado: LOGICA
```

#### **🔍 Passo 2: ANALYZE - Consulta à Memória**
```
📚 Consultando memory-bank/self_correction_log.md...
🔍 Buscando por: "possibly undefined", "optional chaining", "typescript"

⚠️ NENHUMA SOLUÇÃO PRÉVIA ENCONTRADA
🔍 Iniciando análise de causa raiz
⏭️ Prosseguindo para Passo 3 (Análise Profunda)
```

#### **🔍 Passo 3: LEARN - Análise de Causa Raiz**
```
🔍 ANÁLISE DE CAUSA RAIZ COMPLETA
📂 Categoria: LOGICA
💡 Hipótese: Tentativa de acessar propriedade de objeto que pode ser undefined
📋 Regras consultadas: typescript-standards.md, null-safety-patterns.md
🎯 Contexto: TypeScript strict mode ativo, optional chaining necessário
```

#### **🔧 Passo 4: TROUBLESHOOT - Ação Corretiva**
```
🔧 APLICANDO CORREÇÃO IDENTIFICADA

🛠️ Solução aplicada: Implementar optional chaining
📝 Código corrigido:
   const name = user?.profile?.name || 'Nome não disponível';

✅ CORREÇÃO APLICADA COM SUCESSO
🔄 TypeScript compilation bem-sucedida
📈 Problema resolvido
```

#### **📝 Passo 5: HALT - Registro Obrigatório**
```
### 🛡️ P.C.P.E. - Análise de Correção - 2025-06-07T18:05:30Z ###

**1. Tarefa Solicitada:** Compilação TypeScript do componente UserProfile
**2. Comando/Ação que Falhou:** TypeScript compilation
**3. Saída do Erro:** Object is possibly 'undefined' at user.profile.name
**4. Categoria do Erro:** LOGICA
**5. Análise da Causa Raiz:** Acesso a propriedade sem validação de undefined
**6. Ação Corretiva Implementada:** Optional chaining: user?.profile?.name
**7. Resultado da Correção:** SUCESSO
**8. Sugestão de Melhoria para as Regras:** Adicionar lint rule para optional chaining obrigatório
**9. Prevenção Futura:** ESLint rule: @typescript-eslint/prefer-optional-chain
**10. Palavras-chave para Busca:** typescript, undefined, optional-chaining, null-safety

---
```

---

## 🎯 EXEMPLO 3: ERRO DE PERMISSÃO DE ARQUIVO

### **Situação Real:**
```bash
# Comando executado
echo "export default config" > /usr/local/config.js

# Erro retornado
bash: /usr/local/config.js: Permission denied
```

### **Ativação do P.C.P.E.:**

#### **🚨 Passo 1: HALT - Parar e Isolar**
```
🚨 ERRO DETECTADO. Ativando P.C.P.E. - Protocolo de Correção Proativa de Erros

⏸️ EXECUÇÃO PAUSADA
🕐 Timestamp: 2025-06-07T18:10:00Z
📝 Comando que falhou: echo "export default config" > /usr/local/config.js
❌ Erro capturado: Permission denied
🎯 Escopo identificado: PERMISSAO
```

#### **🔍 Passo 2: ANALYZE - Consulta à Memória**
```
📚 Consultando memory-bank/self_correction_log.md...
🔍 Buscando por: "permission denied", "/usr/local", "write access"

✅ SOLUÇÃO ENCONTRADA NA MEMÓRIA
📅 Referência: Log de 2025-06-03 - Entrada #089
🔧 Solução aplicada anteriormente: Use project directory instead of system directory
⏭️ Pulando para Passo 4 (Aplicação da Correção)
```

#### **🔧 Passo 4: TROUBLESHOOT - Ação Corretiva**
```
🔧 APLICANDO CORREÇÃO IDENTIFICADA

🛠️ Solução aplicada: Redirecionar para diretório do projeto
📝 Comando corrigido: echo "export default config" > ./src/config.js

✅ CORREÇÃO APLICADA COM SUCESSO
📁 Arquivo criado em ./src/config.js
📈 Problema resolvido
```

---

## 📊 MÉTRICAS DE EFICÁCIA

### **Resultados dos Exemplos:**

| Exemplo | Categoria | Tempo Resolução | Solução Encontrada | Status |
|---------|-----------|-----------------|-------------------|---------|
| NPM Dependency | DEPENDENCIA | 45s | ✅ Memory Bank | ✅ Sucesso |
| TypeScript Error | LOGICA | 2m 30s | ❌ Nova Análise | ✅ Sucesso |
| File Permission | PERMISSAO | 30s | ✅ Memory Bank | ✅ Sucesso |

### **KPIs Atingidos:**
- **Taxa de Resolução**: 100% (3/3)
- **Tempo Médio**: 1m 41s (< 5min target ✅)
- **Reutilização de Soluções**: 67% (2/3)
- **Taxa de Registro**: 100% (3/3)

---

## 🚀 BENEFÍCIOS DEMONSTRADOS

### **1. Velocidade de Resolução**
- **Soluções conhecidas**: Resolução em < 1 minuto
- **Novas análises**: Resolução sistemática em < 3 minutos
- **Prevenção futura**: Erros similares evitados

### **2. Aprendizado Contínuo**
- **Cada erro documentado** no memory bank
- **Padrões identificados** automaticamente
- **Soluções reutilizadas** em casos similares

### **3. Qualidade Consistente**
- **Zero erros não documentados**
- **Análise sistemática** de causa raiz
- **Melhoria contínua** das regras

---

## 🎯 PRÓXIMOS PASSOS

### **Para Desenvolvedores:**
1. **Familiarizar-se** com outputs do P.C.P.E.
2. **Consultar memory bank** antes de resolver erros manualmente
3. **Contribuir** com soluções para o sistema de aprendizado

### **Para o Sistema:**
1. **Monitorar métricas** de eficácia em produção
2. **Identificar padrões** recorrentes para prevenção
3. **Otimizar algoritmos** de busca e categorização

---

**🎯 GRUPO US VIBECODE SYSTEM V2.0 - P.C.P.E. USAGE EXAMPLES**  
**Sistema de Imunidade a Erros em Ação**
