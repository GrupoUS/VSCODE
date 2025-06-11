# PROTOCOLO DE PREVENÇÃO DE ERROS - GRUPO US VIBECODE SYSTEM V2.0

## 🎯 Objetivo
Implementar sistema abrangente de prevenção, detecção e correção de erros baseado no aprendizado do BUG-001 e outros incidentes críticos.

## 📚 Base de Conhecimento
Este protocolo foi desenvolvido após a resolução bem-sucedida do **BUG-001: Conflitos de Estrutura Next.js** no NEON PRO V2.0, que causou falhas críticas de compilação.

## 🔄 CICLO DE PREVENÇÃO DE ERROS

### **Fase 1: PREVENÇÃO PROATIVA**
```
ANTES → DURANTE → DEPOIS
   ↓        ↓        ↓
Validar → Monitorar → Aprender
```

#### **1.1 Validação Pré-Execução (OBRIGATÓRIA)**
- ✅ Verificar estrutura de projeto
- ✅ Validar configurações críticas
- ✅ Confirmar existência de dependências
- ✅ Testar imports e referências

#### **1.2 Checklist Universal**
```bash
# Para projetos Next.js
- [ ] Estrutura única (app/ OU src/app/, nunca ambas)
- [ ] tsconfig.json consistente
- [ ] Imports válidos
- [ ] Cache limpo

# Para projetos Vite
- [ ] Configuração vite.config.ts válida
- [ ] Estrutura src/ organizada
- [ ] Imports de assets corretos

# Para todos os projetos
- [ ] package.json scripts funcionais
- [ ] Dependências instaladas
- [ ] Variáveis de ambiente configuradas
```

### **Fase 2: DETECÇÃO AUTOMÁTICA**
#### **2.1 Scripts de Validação**
- **Next.js**: `scripts/validate-nextjs-structure.js`
- **Universal**: `scripts/validate-structure.ps1`
- **Cross-Platform**: Adaptações para diferentes frameworks

#### **2.2 Integração com Workflow**
```json
// package.json
{
  "scripts": {
    "pre-dev": "npm run validate",
    "pre-build": "npm run validate",
    "validate": "node scripts/validate-structure.js"
  }
}
```

### **Fase 3: CORREÇÃO AUTOMÁTICA**
#### **3.1 Modo Fix Automático**
```bash
# PowerShell
./scripts/validate-structure.ps1 -Fix

# Node.js
node scripts/validate-structure.js --fix
```

#### **3.2 Protocolo de Backup**
- **SEMPRE** criar backup antes de correções
- **NUNCA** fazer mudanças destrutivas sem confirmação
- **VALIDAR** funcionamento após correção

## 🚨 PADRÕES DE ERRO IDENTIFICADOS

### **Categoria 1: Conflitos Estruturais**
**Exemplo**: BUG-001 - Estruturas Next.js duplicadas
- **Causa**: Migração incompleta ou configuração inconsistente
- **Prevenção**: Validação estrutural obrigatória
- **Correção**: Backup + remoção + limpeza cache

### **Categoria 2: Imports Fantasma**
**Exemplo**: Componentes referenciados mas inexistentes
- **Causa**: Refatoração incompleta ou arquivos removidos
- **Prevenção**: Validação de imports antes de build
- **Correção**: Remoção ou criação do componente faltante

### **Categoria 3: Cache Corrompido**
**Exemplo**: Referências incorretas em .next
- **Causa**: Mudanças estruturais sem limpeza de cache
- **Prevenção**: Limpeza automática após mudanças
- **Correção**: Remoção completa + reinstalação

### **Categoria 4: Configuração Inconsistente**
**Exemplo**: tsconfig.json vs estrutura real
- **Causa**: Configuração manual sem validação
- **Prevenção**: Verificação de consistência
- **Correção**: Alinhamento de configuração com estrutura

## 🛡️ MEDIDAS PREVENTIVAS POR PROJETO

### **NEON PRO (Next.js + src/app/)**
- ✅ Protocolo implementado e funcionando
- ✅ Scripts de validação ativos
- ✅ Estrutura consolidada
- ✅ BUG-001 resolvido completamente

### **Harmoniza (Next.js + src/app/)**
- ✅ Estrutura correta confirmada
- 🔄 Scripts de validação a implementar
- ✅ Sem conflitos detectados

### **AegisWallet (Vite + React)**
- 🔄 Protocolo adaptado para Vite necessário
- 🔄 Validação específica para estrutura Vite
- ℹ️ Diferentes padrões de erro possíveis

## 📊 MÉTRICAS DE SUCESSO

### **KPIs de Prevenção**
- **Zero conflitos** estruturais em projetos ativos
- **100% validação** antes de mudanças críticas
- **< 30 minutos** tempo de resolução para erros detectados
- **> 95% detecção** automática de problemas

### **Indicadores de Qualidade**
- **Completion Rate**: > 85% primeira tentativa
- **Error Rate**: < 15% em desenvolvimento
- **Recovery Time**: < 30 minutos para erros críticos
- **Prevention Rate**: > 90% erros evitados

## 🔄 PROCESSO DE APRENDIZADO CONTÍNUO

### **1. Documentação Obrigatória**
Todos os erros devem ser documentados em:
- `memory-bank/self_correction_log.md`
- Protocolos específicos em `memory-bank/protocols/`
- Regras atualizadas em `project-core/rules/`

### **2. Padrão de Documentação**
```markdown
### [DATA] - [ERRO_ID] - [SEVERIDADE]
**Contexto**: [Descrição do contexto]
**Erro**: [Descrição detalhada]
**Causa Raiz**: [Análise fundamental]
**Solução**: [Como foi resolvido]
**Prevenção**: [Medidas preventivas]
**Impacto**: [Resultados e melhorias]
```

### **3. Evolução do Protocolo**
- **Mensal**: Revisão de padrões de erro
- **Trimestral**: Atualização de protocolos
- **Anual**: Evolução completa do sistema

## 🎯 APLICAÇÃO CROSS-PROJECT

### **Template Universal**
1. **Análise**: Identificar padrões específicos do framework
2. **Adaptação**: Criar scripts de validação específicos
3. **Implementação**: Integrar com workflow do projeto
4. **Validação**: Testar efetividade do protocolo
5. **Documentação**: Registrar aprendizados e padrões

### **Próximos Passos**
- [ ] Implementar protocolo no Harmoniza
- [ ] Adaptar protocolo para AegisWallet (Vite)
- [ ] Criar templates para novos projetos
- [ ] Estabelecer monitoramento contínuo

---

**Status**: ✅ ATIVO - Protocolo operacional baseado em BUG-001
**Última Atualização**: 2025-06-08
**Próxima Revisão**: 2025-07-08
