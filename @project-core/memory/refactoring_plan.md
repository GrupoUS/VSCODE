# 📋 PLANO DE REFATORAÇÃO ESTRUTURAL - @project-core

## 🎯 OBJETIVO

Otimizar e consolidar a estrutura do diretório @project-core, reduzindo redundâncias e mantendo apenas os arquivos essenciais.

## 📊 ANÁLISE INICIAL

### Diretórios Identificados para Consolidação:

1. `docs/` + `knowledge-base/` → Consolidar em `docs/`
2. `templates/` + `templates-unified/` → Consolidar em `templates/`
3. `@project-core/` (duplicado) → Remover e consolidar conteúdo
4. `.cursor/` + `.vscode/` → Manter separados (configurações específicas)

### Arquivos para Consolidação:

1. Arquivos de Relatório:

   - `CONSOLIDATION_AUDIT_LOG.md`
   - `SYNC_AUDIT_REPORT.md`
   - `FINALTEST_VALIDATION_REPORT.md`
   - `CONSOLIDATION_REPORT_V4.md`
     → Consolidar em `docs/reports/consolidation-history.md`

2. Arquivos de Regras:

   - `MASTER_RULE_RELOCATION_REPORT.md`
   - `README-UNIFIED-IMPLEMENTATION.md`
     → Consolidar conteúdo em `memory/master_rule.md`

3. Arquivos de Configuração:
   - `.cursorrules`
     → Mover para `configs/cursor-rules.json`

## 📝 PLANO DE AÇÃO

### FASE 1: CONSOLIDAÇÃO DE DIRETÓRIOS

1. Consolidar Documentação:

   ```bash
   # Mover conteúdo de knowledge-base para docs
   mv @project-core/knowledge-base/* @project-core/docs/
   rm -r @project-core/knowledge-base
   ```

2. Consolidar Templates:

   ```bash
   # Mover conteúdo de templates-unified para templates
   mv @project-core/templates-unified/* @project-core/templates/
   rm -r @project-core/templates-unified
   ```

3. Remover Diretório Duplicado:
   ```bash
   # Consolidar conteúdo do @project-core duplicado
   mv @project-core/@project-core/* @project-core/
   rm -r @project-core/@project-core
   ```

### FASE 2: CONSOLIDAÇÃO DE ARQUIVOS

1. Consolidar Relatórios:

   ```bash
   # Criar diretório de relatórios consolidados
   mkdir -p @project-core/docs/reports

   # Consolidar relatórios em um único arquivo
   cat @project-core/CONSOLIDATION_AUDIT_LOG.md \
       @project-core/SYNC_AUDIT_REPORT.md \
       @project-core/FINALTEST_VALIDATION_REPORT.md \
       @project-core/CONSOLIDATION_REPORT_V4.md > \
       @project-core/docs/reports/consolidation-history.md

   # Remover arquivos originais
   rm @project-core/CONSOLIDATION_AUDIT_LOG.md
   rm @project-core/SYNC_AUDIT_REPORT.md
   rm @project-core/FINALTEST_VALIDATION_REPORT.md
   rm @project-core/CONSOLIDATION_REPORT_V4.md
   ```

2. Consolidar Regras:

   ```bash
   # Adicionar conteúdo dos relatórios ao master_rule.md
   cat @project-core/MASTER_RULE_RELOCATION_REPORT.md \
       @project-core/README-UNIFIED-IMPLEMENTATION.md >> \
       @project-core/memory/master_rule.md

   # Remover arquivos originais
   rm @project-core/MASTER_RULE_RELOCATION_REPORT.md
   rm @project-core/README-UNIFIED-IMPLEMENTATION.md
   ```

3. Mover Configurações:
   ```bash
   # Converter .cursorrules para JSON
   mv @project-core/.cursorrules @project-core/configs/cursor-rules.json
   ```

### FASE 3: ATUALIZAÇÃO DE REFERÊNCIAS

1. Atualizar Referências em Arquivos:

   - Atualizar todos os caminhos nos arquivos de configuração
   - Atualizar referências nos scripts de automação
   - Atualizar documentação

2. Validar Integridade:
   - Executar testes de integridade
   - Verificar workflows
   - Confirmar funcionalidade do sistema

## 🎯 RESULTADO ESPERADO

### Estrutura Final Otimizada:

```
@project-core/
├── memory/                    # Sistema FMC
├── configs/                   # Configurações unificadas
├── rules/                     # Regras do sistema
├── docs/                      # Documentação consolidada
├── templates/                 # Templates unificados
├── automation/                # Scripts de automação
├── projects/                  # Projetos isolados
└── tools/                     # Ferramentas do sistema
```

### Métricas de Sucesso:

- ✅ Redução de 40% no número total de arquivos
- ✅ Eliminação de todas as redundâncias
- ✅ Manutenção de 100% da funcionalidade
- ✅ Preservação de todos os workflows críticos

## ⚠️ SALVAGUARDAS

1. Backup Completo:

   ```bash
   # Criar backup antes de iniciar
   tar -czf @project-core-backup-$(date +%Y%m%d).tar.gz @project-core/
   ```

2. Validação por Fase:

   - Testar cada operação em um subconjunto pequeno
   - Verificar integridade após cada fase
   - Manter logs detalhados de todas as operações

3. Plano de Rollback:
   - Backup completo antes de iniciar
   - Scripts de restauração preparados
   - Pontos de verificação após cada fase
