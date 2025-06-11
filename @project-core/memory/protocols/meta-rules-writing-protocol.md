---
description: "Protocolo para escrita e edição eficaz de regras e guidelines baseado nas melhores práticas do Cline adaptadas para Augment Code"
author: "GRUPO US - VIBECODE SYSTEM"
version: "1.0"
tags: ["meta-rules", "guidelines", "writing-protocol", "cline-inspired", "augment-optimization"]
globs: ["@project-core/memory/**/*.md", "@project-core/rules/**/*.md"]
priority: "HIGH"
confidence_required: 9
---

# 📝 PROTOCOLO DE ESCRITA DE META-REGRAS - AUGMENT AGENT

## 🎯 OBJETIVO

Estabelecer padrões consistentes e eficazes para criação, edição e manutenção de regras e guidelines do AUGMENT AGENT, baseado nas melhores práticas identificadas na análise comparativa com diretrizes do Cline.

## 🚨 PRINCÍPIOS FUNDAMENTAIS

### **1. CLAREZA E PRECISÃO (CRITICAL)**

- **MUST** usar linguagem diretiva clara:
  - **MUST** para requisitos absolutos
  - **SHOULD** para recomendações fortes  
  - **MAY** para ações opcionais
  - **MUST NOT** / **NEVER** para proibições absolutas
  - **SHOULD NOT** para desencorajamento forte

- **MUST** usar formatação visual consistente:
  - 🚨 para instruções críticas
  - ⚠️ para avisos importantes
  - ✅ para exemplos corretos
  - ❌ para exemplos incorretos
  - 📋 para checklists
  - 🎯 para objetivos

### **2. ESTRUTURA MODULAR (REQUIRED)**

- **MUST** incluir frontmatter YAML com:
  ```yaml
  ---
  description: "Descrição clara e concisa do propósito"
  author: "GRUPO US - VIBECODE SYSTEM"
  version: "X.Y"
  tags: ["tag1", "tag2", "tag3"]
  globs: ["pattern1", "pattern2"]
  priority: "CRITICAL|HIGH|MEDIUM|LOW"
  confidence_required: X
  ---
  ```

- **MUST** organizar conteúdo com hierarquia clara:
  - `#` para título principal
  - `##` para seções principais
  - `###` para subseções
  - `####` para detalhes específicos

### **3. TIPOS DE REGRAS (CLASSIFICATION)**

#### **a. Regras Informacionais/Documentação**
- **Propósito**: Fornecer informações abrangentes sobre sistemas, arquiteturas ou tecnologias
- **Elementos-chave**:
  - Overview e objetivos do projeto
  - Explicações detalhadas de componentes
  - Diagramas (Mermaid.js quando aplicável)
  - Snippets de código ou configuração
  - Definições de termos-chave

#### **b. Regras de Processo/Workflow**
- **Propósito**: Definir sequência de passos para alcançar resultado específico
- **Elementos-chave**:
  - Ponto de início e fim claros
  - Passos numerados para ações sequenciais
  - Pontos de decisão com opções claras
  - Especificação de ferramentas MCP
  - Inputs e outputs esperados
  - Dependências e pré-requisitos

#### **c. Regras Comportamentais/Instrucionais (para AI)**
- **Propósito**: Instruir diretamente o comportamento do AUGMENT AGENT
- **Elementos-chave**:
  - **Instruções explícitas** com verbos imperativos
  - **Avisos críticos** com formatação destacada
  - **Exemplos positivos e negativos** de código/comportamento
  - **Triggers e condições** para ativação
  - **Blocos de verificação AI** para auto-validação
  - **Gestão de contexto** e memória

#### **d. Meta-Regras**
- **Propósito**: Definir como o AUGMENT AGENT gerencia ou melhora suas próprias regras
- **Elementos-chave**:
  - Triggers para meta-processos
  - Passos do meta-processo
  - Pontos de interação com usuário
  - Protocolos de auto-melhoria

## 🔧 PADRÕES DE IMPLEMENTAÇÃO

### **Linguagem para Orientação AI**

```markdown
## 🚨 CRITICAL INSTRUCTIONS FOR AI LANGUAGE MODELS 🚨

**MUST** seguir este padrão exato:
- Use **MUST** para requisitos absolutos
- Use **SHOULD** para recomendações fortes
- Use **NEVER** para proibições absolutas

**❌ NEVER GENERATE THIS PATTERN:**
```javascript
// Código incorreto ou desencorajado
```

**✅ ALWAYS GENERATE THIS EXACT PATTERN:**
```javascript
// Código correto e recomendado
```

**🤔 AI MODEL VERIFICATION STEPS:**
<thinking>
Antes de prosseguir, verifico:
1. Consultei o memory bank?
2. Verifiquei self_correction_log.md?
3. Confidence ≥ 8/10?
4. Protocolos de segurança aplicados?
</thinking>
```

### **Estrutura de Blocos de Verificação**

```markdown
<augment_agent_verification>
<check>Consulta ao memory bank realizada?</check>
<check>Self correction log verificado?</check>
<check>Confidence level ≥ 8/10?</check>
<check>Protocolos de segurança aplicados?</check>
<action>Prosseguir apenas se TODAS as verificações forem ✅</action>
</augment_agent_verification>
```

## 📋 CHECKLIST DE QUALIDADE PARA REGRAS

### **Antes de Finalizar Qualquer Regra:**

- [ ] **Frontmatter YAML** completo e correto
- [ ] **Objetivo claro** definido na descrição
- [ ] **Linguagem diretiva** consistente (MUST/SHOULD/NEVER)
- [ ] **Formatação visual** padronizada (emojis, destaque)
- [ ] **Exemplos práticos** incluídos (positivos e negativos)
- [ ] **Blocos de verificação AI** implementados
- [ ] **Globs relevantes** especificados
- [ ] **Tags apropriadas** para categorização
- [ ] **Versioning** adequado
- [ ] **Referências cruzadas** para outras regras (quando aplicável)

### **Teste de Qualidade:**

1. **Legibilidade Humana**: Outro desenvolvedor consegue entender?
2. **Interpretação AI**: Instruções são específicas e não ambíguas?
3. **Aplicação Prática**: Pode ser seguida na prática?
4. **Aderência a Este Protocolo**: Segue os padrões estabelecidos?

## 🔄 PROTOCOLO DE ATUALIZAÇÃO

### **Para Edições de Regras Existentes:**

1. **MUST** incrementar version number
2. **MUST** documentar mudanças no self_correction_log.md
3. **MUST** verificar impacto em regras relacionadas
4. **MUST** atualizar tags se necessário
5. **MUST** testar aplicabilidade das mudanças

### **Para Novas Regras:**

1. **MUST** seguir este protocolo completamente
2. **MUST** verificar duplicação com regras existentes
3. **MUST** estabelecer referências cruzadas apropriadas
4. **MUST** documentar criação no memory bank

## 🎯 MÉTRICAS DE SUCESSO

- **Clareza**: Regra pode ser seguida sem ambiguidade
- **Completude**: Todos os elementos necessários incluídos
- **Consistência**: Aderência aos padrões estabelecidos
- **Aplicabilidade**: Pode ser implementada na prática
- **Manutenibilidade**: Fácil de atualizar e modificar

---

**🚨 ENFORCEMENT**: O não cumprimento deste protocolo é considerado erro crítico e deve ser registrado no self_correction_log.md para prevenção futura.
