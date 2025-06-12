# 🚀 GUIA: !syncgithub Multi-Projetos V4.0

## 📋 VISÃO GERAL

O sistema `!syncgithub` foi completamente reformulado para suportar sincronização de múltiplos projetos com seus respectivos repositórios GitHub individuais.

### 🎯 PROJETOS SUPORTADOS

| Projeto | Pasta Local | Repositório GitHub |
|---------|-------------|-------------------|
| **neonpro** | `@project-core/projects/neonpro` | https://github.com/GrupoUS/neonpro |
| **aegiswallet** | `@project-core/projects/aegiswallet` | https://github.com/GrupoUS/aegiswallet |
| **agendatrintae3** | `@project-core/projects/agendatrintae3` | https://github.com/GrupoUS/agendatrintae3 |

---

## 🚀 COMANDOS DISPONÍVEIS

### 1. Sincronizar Todos os Projetos
```powershell
!syncgithub -All
```
- ✅ Sincroniza todos os projetos habilitados
- ✅ Executa em paralelo para eficiência
- ✅ Relatório consolidado no final

### 2. Sincronizar Projeto Específico
```powershell
!syncgithub -Project neonpro
!syncgithub -Project aegiswallet
!syncgithub -Project agendatrintae3
```
- ✅ Sincroniza apenas o projeto especificado
- ✅ Mais rápido para mudanças pontuais
- ✅ Ideal para desenvolvimento focado

### 3. Simulação (Dry Run)
```powershell
!syncgithub -All -DryRun
!syncgithub -Project neonpro -DryRun
```
- ✅ Mostra o que seria feito sem executar
- ✅ Perfeito para validar mudanças
- ✅ Seguro para testes

### 4. Forçar Sincronização
```powershell
!syncgithub -All -Force
!syncgithub -Project aegiswallet -Force
```
- ⚠️ Usa `--force-with-lease` para push
- ⚠️ Use apenas quando necessário
- ⚠️ Pode sobrescrever mudanças remotas

### 5. Mensagem Personalizada
```powershell
!syncgithub -All -Message "feat: implementação de nova funcionalidade"
!syncgithub -Project neonpro -Message "fix: correção de bug crítico"
```
- ✅ Personaliza a mensagem de commit
- ✅ Segue padrões de conventional commits
- ✅ Melhor rastreabilidade

---

## 📁 ESTRUTURA DE ARQUIVOS

```
C:\Users\Admin\OneDrive\GRUPOUS\VSCODE\
├── !syncgithub.ps1                           # Comando principal
├── sync-github-multi-projects.ps1            # Engine de sincronização
├── sync-github-auto.ps1                      # Script legado (compatibilidade)
└── @project-core/
    ├── configs/
    │   └── projects-sync-config.json          # Configuração dos projetos
    └── projects/
        ├── neonpro/                           # → github.com/GrupoUS/neonpro
        ├── aegiswallet/                       # → github.com/GrupoUS/aegiswallet
        └── agendatrintae3/                    # → github.com/GrupoUS/agendatrintae3
```

---

## ⚙️ CONFIGURAÇÃO

### Arquivo: `@project-core/configs/projects-sync-config.json`

```json
{
  "projects": {
    "neonpro": {
      "name": "NeonPro",
      "localPath": "@project-core\\projects\\neonpro",
      "repositoryUrl": "https://github.com/GrupoUS/neonpro.git",
      "branch": "main",
      "enabled": true
    },
    "aegiswallet": {
      "name": "AegisWallet", 
      "localPath": "@project-core\\projects\\aegiswallet",
      "repositoryUrl": "https://github.com/GrupoUS/aegiswallet.git",
      "branch": "main",
      "enabled": true
    },
    "agendatrintae3": {
      "name": "AgendaTrintaE3",
      "localPath": "@project-core\\projects\\agendatrintae3", 
      "repositoryUrl": "https://github.com/GrupoUS/agendatrintae3.git",
      "branch": "main",
      "enabled": true
    }
  }
}
```

---

## 🔄 FLUXO DE EXECUÇÃO

### Para Cada Projeto:
1. **Validação** - Verifica se a pasta existe
2. **Git Check** - Inicializa repositório se necessário
3. **Remote Setup** - Configura URL do repositório
4. **Status Check** - Verifica mudanças pendentes
5. **Staging** - Adiciona arquivos modificados
6. **Commit** - Cria commit com timestamp
7. **Push** - Envia para o repositório GitHub
8. **Relatório** - Registra resultado da operação

### Tratamento de Erros:
- ✅ Erros em um projeto não afetam outros
- ✅ Relatório detalhado de sucessos/falhas
- ✅ Logs específicos para debugging
- ✅ Rollback automático em caso de falha crítica

---

## 📊 RELATÓRIO DE EXECUÇÃO

```
📊 RELATÓRIO DE SINCRONIZAÇÃO
============================================================
✅ Sucessos: 2
❌ Falhas: 1

✅ NeonPro (3 mudanças)
✅ AegisWallet (sem mudanças)  
❌ AgendaTrintaE3 (Erro: repositório não inicializado)
```

---

## 🛠️ TROUBLESHOOTING

### Problema: "Projeto não encontrado"
**Solução**: Verificar se a pasta existe em `@project-core/projects/`

### Problema: "Remote URL incorreta"
**Solução**: O script corrige automaticamente baseado na configuração

### Problema: "Push rejeitado"
**Solução**: Use `-Force` ou resolva conflitos manualmente

### Problema: "Configuração não encontrada"
**Solução**: Verificar se `projects-sync-config.json` existe e está válido

---

## 🚀 EXEMPLOS PRÁTICOS

### Desenvolvimento Diário
```powershell
# Verificar o que mudou
!syncgithub -All -DryRun

# Sincronizar tudo
!syncgithub -All
```

### Trabalho Focado
```powershell
# Apenas o projeto atual
!syncgithub -Project neonpro

# Com mensagem específica
!syncgithub -Project neonpro -Message "feat: nova API de pagamentos"
```

### Situações de Emergência
```powershell
# Forçar sincronização
!syncgithub -All -Force

# Projeto específico com força
!syncgithub -Project aegiswallet -Force
```

---

## 📈 BENEFÍCIOS

- 🎯 **Precisão**: Cada projeto vai para seu repositório correto
- ⚡ **Eficiência**: Sincronização paralela quando possível
- 🛡️ **Segurança**: Validação e backup automático
- 📊 **Visibilidade**: Relatórios detalhados de cada operação
- 🔧 **Flexibilidade**: Suporte a diferentes configurações por projeto
- 🚀 **Produtividade**: Comando único para múltiplos repositórios

---

**GRUPO US VIBECODE SYSTEM V4.0** - Sincronização Multi-Projetos Inteligente! 🚀
