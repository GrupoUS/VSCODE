# 👑 GUIA DE SINCRONIZAÇÃO SOBERANA - PROJETOS GRUPOUS

## ⚡ COMANDOS RÁPIDOS

### **Sincronizar Projeto Específico**

```powershell
# NeonPro
@project-core/automation/sync-sovereign-projects.ps1 -ProjectName "neonpro"

# AgendaTrintaE3
@project-core/automation/sync-sovereign-projects.ps1 -ProjectName "agendatrintae3"

# AegisWallet
@project-core/automation/sync-sovereign-projects.ps1 -ProjectName "aegiswallet"
```

### **Sincronizar TODOS os Projetos**

```powershell
@project-core/automation/sync-sovereign-projects.ps1 -All
```

### **Teste Antes da Execução (Dry Run)**

```powershell
# Testar projeto específico
@project-core/automation/sync-sovereign-projects.ps1 -ProjectName "neonpro" -DryRun

# Testar todos os projetos
@project-core/automation/sync-sovereign-projects.ps1 -All -DryRun
```

## 🎯 MAPEAMENTO DE PROJETOS

| Projeto Local                           | Repositório GitHub                                                  | Status         |
| --------------------------------------- | ------------------------------------------------------------------- | -------------- |
| `@project-core/projects/neonpro`        | [GrupoUS/neonpro](https://github.com/GrupoUS/neonpro)               | ✅ Configurado |
| `@project-core/projects/agendatrintae3` | [GrupoUS/agendatrintae3](https://github.com/GrupoUS/agendatrintae3) | ✅ Configurado |
| `@project-core/projects/aegiswallet`    | [GrupoUS/aegiswallet](https://github.com/GrupoUS/aegiswallet)       | ✅ Configurado |

## 👑 CARACTERÍSTICAS DA SINCRONIZAÇÃO SOBERANA

### **🔥 MODO SOBERANO ATIVO**

- ✅ **Pastas locais SEMPRE dominantes**
- ✅ **Force push automático**
- ✅ **Remove arquivos GitHub não existentes localmente**
- ✅ **Sobrescreve histórico remoto completamente**
- ✅ **Backup automático antes da sincronização**

### **⚠️ IMPORTANTE**

> **ATENÇÃO**: Esta sincronização é DESTRUTIVA para o repositório remoto.
> O GitHub será SOBRESCRITO completamente para ficar idêntico à pasta local.

## 📋 WORKFLOW AUTOMÁTICO

1. **Verificação**: Confirma existência do projeto local
2. **Git Setup**: Inicializa/configura repositório Git se necessário
3. **Backup**: Cria backup de segurança
4. **Staging**: Adiciona TODOS os arquivos (`git add -A`)
5. **Commit**: Commita com mensagem automática
6. **Force Push**: Envia para GitHub sobrescrevendo tudo
7. **Relatório**: Mostra resultado da sincronização

## 🔧 CONFIGURAÇÃO

### **Arquivo de Configuração**

`@project-core/configs/projects-sync-config.json`

### **Logs e Documentação**

- **Memory Bank**: `@project-core/memory/self_correction_log.md`
- **Configuração**: `@project-core/configs/projects-sync-config.json`
- **Script Principal**: `@project-core/automation/sync-sovereign-projects.ps1`

## 🚨 TROUBLESHOOTING

### **Erro: Projeto não encontrado**

- Verifique se a pasta existe em `@project-core/projects/`
- Confirme o nome do projeto na configuração

### **Erro: Falha no push**

- Verifique credenciais GitHub
- Confirme permissões de escrita no repositório
- Verifique conectividade com GitHub

### **Erro: Configuração não encontrada**

- Confirme que `@project-core/configs/projects-sync-config.json` existe
- Verifique sintaxe JSON válida

## ⏰ USO RECOMENDADO

### **Diário**

```powershell
# Sincronizar apenas o projeto ativo
@project-core/automation/sync-sovereign-projects.ps1 -ProjectName "neonpro"
```

### **Semanal**

```powershell
# Sincronizar todos os projetos
@project-core/automation/sync-sovereign-projects.ps1 -All
```

### **Antes de Mudanças Importantes**

```powershell
# Sempre testar primeiro
@project-core/automation/sync-sovereign-projects.ps1 -All -DryRun
```

## 📞 SUPORTE

- **Documentação Completa**: `@project-core/memory/self_correction_log.md`
- **Configuração JSON**: `@project-core/configs/projects-sync-config.json`
- **VIBECODE System**: Consulte sempre o `master_rule.md` antes de modificações

---

**🚀 GRUPO US - VIBECODE SYSTEM V4.0**
_Sincronização Soberana: Onde o Local é Supremo!_
