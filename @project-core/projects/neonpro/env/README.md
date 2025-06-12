# 🔒 DIRETÓRIO ENV - SECRETS E CONFIGURAÇÕES SENSÍVEIS

## ⚠️ ATENÇÃO: DIRETÓRIO BLOQUEADO NO GITIGNORE

Este diretório contém informações sensíveis que **NUNCA** devem ser commitadas:

### Arquivos Presentes:

- `github-token.txt`: Token de acesso do GitHub para sincronização
- `api-keys.env`: Chaves de API para serviços externos
- `database-credentials.env`: Credenciais de banco de dados

### Uso nos Scripts:

```bash
# Ler token do GitHub
$GITHUB_TOKEN = Get-Content "env/github-token.txt"

# Configurar remote com token
git remote set-url origin "https://${GITHUB_TOKEN}@github.com/GrupoUS/neonpro.git"
```

### Segurança:

- ✅ Bloqueado no .gitignore
- ✅ Não é sincronizado com GitHub
- ✅ Apenas local para automação
- ❌ NUNCA commitar este diretório
