# 🚀 Sistema de Push Automático para GitHub

Este sistema automatiza o processo de envio de todos os seus projetos para o GitHub e configura push automático.

## 📋 Pré-requisitos

1. **Git instalado** no seu sistema
2. **Conta no GitHub** ativa
3. **Personal Access Token** do GitHub com permissões de repositório

### Como criar um Personal Access Token:

1. Acesse: https://github.com/settings/tokens
2. Clique em "Generate new token" > "Generate new token (classic)"
3. Defina um nome para o token (ex: "Auto Push Projects")
4. Selecione as permissões:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows)
   - ✅ `delete_repo` (Delete repositories)
5. Clique em "Generate token"
6. **COPIE O TOKEN** (você não conseguirá vê-lo novamente!)

## 🎯 Como usar

### 1. Execução inicial (primeira vez)

```powershell
# Execute o script principal
.\push-all-projects.ps1
```

O script irá solicitar:
- ✉️ **Seu email do GitHub**
- 🔑 **Seu Personal Access Token**
- 👤 **Seu username do GitHub**

### 2. Push automático (uso diário)

```powershell
# Execute sempre que quiser fazer push de todos os projetos
.\auto-push.ps1
```

## 📁 Projetos que serão enviados

O sistema identificou os seguintes projetos:

- 🏦 **aegiswallet** - Sistema de carteira financeira
- 💼 **assessoria** - Sistema de assessoria
- 🎯 **mcp-r-task-manager** - Gerenciador de tarefas MCP
- 🔧 **taskmaster-integration** - Integração TaskMaster
- 🎲 **trintae3** - Projeto Trintae3
- 🔌 **extensions** - Extensões
- 🖥️ **github-server** - Servidor GitHub

## 🤖 Push Automático

### GitHub Actions (Recomendado)

O sistema criou uma GitHub Action que fará push automático:
- ⏰ **Diariamente às 23:00 (BRT)**
- 🔄 **A cada push no branch main**
- 🎮 **Manualmente via GitHub interface**

### Execução manual

Para fazer push de todos os projetos manualmente:

```powershell
.\auto-push.ps1
```

## 📂 Estrutura criada

```
📁 Seu diretório/
├── 📄 push-all-projects.ps1    # Script de configuração inicial
├── 📄 auto-push.ps1            # Script de push automático
├── 📄 README-GITHUB-SETUP.md   # Este arquivo
├── 📁 .github/
│   └── 📁 workflows/
│       └── 📄 auto-push.yml    # GitHub Action
└── 📁 [seus-projetos]/
```

## 🔧 Configurações avançadas

### Adicionar novos projetos

Para adicionar um novo projeto ao sistema automático:

1. Edite o arquivo `auto-push.ps1`
2. Adicione o nome do projeto na lista `$projects`
3. Execute o script novamente

### Alterar horário do push automático

1. Edite `.github/workflows/auto-push.yml`
2. Modifique a linha `cron: '0 2 * * *'`
3. Use https://crontab.guru/ para ajudar com o formato

### Configurar projetos privados

Para tornar repositórios privados por padrão:

1. Edite `push-all-projects.ps1`
2. Altere `"private" = $false` para `"private" = $true`

## 🛠️ Solução de problemas

### Erro de autenticação

```
❌ Error: Authentication failed
```

**Solução:** Verifique se seu Personal Access Token está correto e tem as permissões necessárias.

### Erro de repositório já existe

```
⚠️ Repository 'nome-projeto' already exists
```

**Solução:** Normal! O script detecta repositórios existentes e continua o processo.

### Erro de push

```
❌ Error: failed to push some refs
```

**Solução:** Execute o comando manualmente:

```powershell
cd nome-do-projeto
git push origin main --force
```

### Verificar status dos repositórios

```powershell
# Verificar status de um projeto específico
cd aegiswallet
git status
git remote -v

# Voltar ao diretório principal
cd ..
```

## 📊 Monitoramento

### Ver logs do GitHub Actions

1. Acesse seu repositório no GitHub
2. Vá em **Actions**
3. Clique em **Auto Push All Projects**
4. Veja os logs de execução

### Verificar último push

```powershell
# Ver último commit de cada projeto
$projects = @("aegiswallet", "assessoria", "mcp-r-task-manager", "taskmaster-integration", "trintae3", "extensions", "github-server")

foreach ($project in $projects) {
    if (Test-Path $project) {
        Write-Host "📁 $project" -ForegroundColor Yellow
        Set-Location $project
        git log --oneline -1
        Set-Location ..
        Write-Host ""
    }
}
```

## 🎉 Benefícios do sistema

- ✅ **Backup automático** de todos os projetos
- ✅ **Sincronização diária** sem intervenção manual
- ✅ **Histórico completo** de mudanças
- ✅ **Acesso remoto** aos projetos de qualquer lugar
- ✅ **Colaboração facilitada** com outros desenvolvedores
- ✅ **Integração com GitHub Actions** para CI/CD

## 📞 Suporte

Se encontrar problemas:

1. Verifique se o Git está configurado corretamente
2. Confirme se o Personal Access Token tem as permissões corretas
3. Execute os comandos manualmente para identificar o erro específico
4. Consulte a documentação do GitHub: https://docs.github.com/

---

**Criado em:** 01/06/2025  
**Autor:** Mauricio  
**Versão:** 1.0
