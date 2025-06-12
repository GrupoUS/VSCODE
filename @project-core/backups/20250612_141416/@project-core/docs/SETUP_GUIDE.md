# 🚀 GRUPO US VIBECODE SYSTEM V4.0 - Guia de Setup do Ambiente

**Versão:** 1.0.0
**Data:** 2025-01-27
**Autor:** GRUPO US VIBECODE SYSTEM

---

## 📋 Visão Geral

Este guia fornece instruções completas para configurar o ambiente de desenvolvimento Python do GRUPO US VIBECODE SYSTEM V4.0, garantindo consistência e padronização entre todos os desenvolvedores.

---

## 🐍 Ambiente de Desenvolvimento Python

### 🎯 Setup Automatizado (RECOMENDADO)

O método mais rápido e confiável para configurar seu ambiente é usar o script automatizado:

```bash
# Execute o script de setup automatizado
python @project-core/scripts/setup_environment.py
```

#### O que o script faz:

- ✅ **Verifica ambiente existente**: Evita sobrescrever configurações
- ✅ **Cria ambiente virtual**: `.venv` dentro de `@project-core/`
- ✅ **Instala dependências**: Todas as bibliotecas do `requirements.txt`
- ✅ **Configura exemplo de variáveis**: Arquivo `.env.example` com templates
- ✅ **Fornece instruções**: Comandos específicos para seu SO

---

### 🔧 Setup Manual (Alternativo)

Se preferir configurar manualmente, siga estes passos:

#### 1. Criar Ambiente Virtual

```bash
# Navegar para o diretório do projeto
cd @project-core

# Criar ambiente virtual
python -m venv .venv
```

#### 2. Ativar Ambiente Virtual

**Windows:**

```cmd
@project-core\.venv\Scripts\activate
```

**Linux/macOS:**

```bash
source @project-core/.venv/bin/activate
```

#### 3. Instalar Dependências

```bash
# Com ambiente ativado
pip install -r @project-core/requirements.txt
```

#### 4. Configurar Variáveis de Ambiente

```bash
# Copiar arquivo exemplo
cp @project-core/.env.example @project-core/.env

# Editar com seus valores reais
# Use seu editor preferido para preencher as variáveis
```

---

## 🔐 Configuração de Variáveis de Ambiente

### 📋 Variáveis Obrigatórias

O arquivo `.env.example` contém templates para todas as variáveis necessárias:

```env
# Database Configuration
DATABASE_URL="sua_string_de_conexao_aqui"

# API Keys
API_KEY="sua_api_key_aqui"
OPENAI_API_KEY="sua_openai_api_key_aqui"
ANTHROPIC_API_KEY="sua_anthropic_api_key_aqui"

# Security
SECRET_KEY="sua_secret_key_aqui"
JWT_SECRET="seu_jwt_secret_aqui"

# Environment
ENVIRONMENT="development"
DEBUG="true"

# External Services
GITHUB_TOKEN="seu_github_token_aqui"
SUPABASE_URL="sua_supabase_url_aqui"
SUPABASE_ANON_KEY="sua_supabase_anon_key_aqui"
```

### 🔑 Como Obter as Chaves

- **OpenAI API Key**: [OpenAI Platform](https://platform.openai.com/api-keys)
- **Anthropic API Key**: [Anthropic Console](https://console.anthropic.com/)
- **GitHub Token**: [GitHub Settings](https://github.com/settings/tokens)
- **Supabase**: [Supabase Dashboard](https://supabase.com/dashboard)

---

## 🎮 Comandos Essenciais

### 📦 Gerenciamento de Pacotes

```bash
# Instalar nova dependência
@project-core/.venv/Scripts/pip install nome_do_pacote  # Windows
@project-core/.venv/bin/pip install nome_do_pacote     # Linux/macOS

# Atualizar requirements.txt
pip freeze > @project-core/requirements.txt

# Instalar dependências de desenvolvimento
pip install -r @project-core/requirements.txt
```

### 🐍 Execução de Scripts

```bash
# Executar script Python
@project-core/.venv/Scripts/python.exe script.py  # Windows
@project-core/.venv/bin/python script.py          # Linux/macOS

# Executar script de automação
python @project-core/automation/finaltest_unified.py --mode=enhanced
```

### 🔍 Validação do Ambiente

```bash
# Testar configuração
python -c "import sys; print('Python:', sys.version); print('Executable:', sys.executable)"

# Verificar dependências instaladas
pip list

# Verificar variáveis de ambiente
python -c "import os; print('ENV loaded:', bool(os.getenv('DATABASE_URL')))"
```

---

## 🛠️ Ferramentas de Desenvolvimento

### 🧪 Qualidade de Código

As seguintes ferramentas estão incluídas no `requirements.txt`:

- **Black**: Formatação automática de código
- **isort**: Organização de imports
- **flake8**: Linting e verificação de estilo
- **mypy**: Verificação de tipos estáticos

```bash
# Executar formatação
black @project-core/
isort @project-core/

# Verificar qualidade
flake8 @project-core/
mypy @project-core/
```

### 🧪 Testes

```bash
# Executar testes
pytest @project-core/tests/

# Executar com cobertura
pytest --cov=@project-core @project-core/tests/
```

---

## 📁 Estrutura de Diretórios

```
@project-core/
├── .venv/                    # Ambiente virtual (criado pelo setup)
├── .env                      # Variáveis de ambiente (você cria)
├── .env.example              # Template de variáveis (criado pelo setup)
├── requirements.txt          # Dependências Python
├── scripts/
│   └── setup_environment.py # Script de setup automatizado
├── automation/              # Scripts de automação
├── docs/                    # Documentação
├── memory/                  # Sistema de memória
└── tests/                   # Testes automatizados
```

---

## ⚠️ Considerações Importantes

### 🚫 Arquivos que NÃO devem ser versionados

O `.gitignore` está configurado para ignorar:

- `.venv/` - Ambiente virtual
- `.env` - Variáveis de ambiente
- `__pycache__/` - Cache Python
- `*.pyc` - Bytecode Python

### 🔒 Segurança

- **NUNCA** commite arquivos `.env` com chaves reais
- **SEMPRE** use o `.env.example` como template
- **MANTENHA** chaves de API seguras e privadas

### 🔄 Atualizações

Para atualizar o ambiente após mudanças no `requirements.txt`:

```bash
# Ativar ambiente
@project-core\.venv\Scripts\activate  # Windows
source @project-core/.venv/bin/activate  # Linux/macOS

# Atualizar dependências
pip install -r @project-core/requirements.txt --upgrade
```

---

## 🆘 Solução de Problemas

### Problema: "Comando python não encontrado"

**Solução:**

- Instale Python 3.8+ do [python.org](https://python.org)
- Adicione Python ao PATH do sistema
- Reinicie o terminal

### Problema: "Erro de permissão ao criar .venv"

**Solução:**

- Execute o terminal como administrador (Windows)
- Use `sudo` se necessário (Linux/macOS)
- Verifique permissões da pasta

### Problema: "ModuleNotFoundError após instalação"

**Solução:**

- Confirme que o ambiente virtual está ativado
- Reinstale as dependências: `pip install -r requirements.txt`
- Verifique se está usando o Python correto: `which python`

---

## 📞 Suporte

Para problemas adicionais:

1. **Consulte** os logs em `@project-core/logs/`
2. **Execute** os scripts de validação em `@project-core/automation/`
3. **Verifique** a documentação completa em `@project-core/docs/`

---

## ✅ Verificação Final

Após completar o setup, execute estes comandos para verificar:

```bash
# 1. Verificar Python virtual
python --version

# 2. Verificar dependências
pip list | grep -E "(loguru|requests|GitPython)"

# 3. Verificar variáveis de ambiente
python -c "import os; print('Setup OK' if os.getenv('DATABASE_URL') else 'Configure .env')"

# 4. Executar teste do sistema
python @project-core/automation/finaltest_unified.py --mode=quick
```

**✅ Se todos os comandos executarem sem erro, seu ambiente está pronto!**

---

**🚀 GRUPO US VIBECODE SYSTEM V4.0 - Ambiente Configurado com Sucesso!** 🐍
