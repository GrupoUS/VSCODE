#!/bin/bash

# 🔒 SCRIPT DE ALTO RISCO: SINCRONIZAÇÃO FORÇADA COM O GITHUB 🔒
# Use com extrema cautela. Este script irá reescrever o histórico da branch remota.
# GRUPO US VIBECODE SYSTEM V2.0 - Git Force Synchronization Script

# Verifica se o nome da branch foi fornecido como argumento
if [ -z "$1" ]; then
  echo "❌ Erro: O nome da branch é obrigatório."
  echo "Uso: ./scripts/force-sync-github.sh <nome-da-branch>"
  exit 1
fi

BRANCH_NAME=$1

echo "------------------------------------------------------------------"
echo "⚠️ ATENÇÃO: PRESTES A FORÇAR A SINCRONIZAÇÃO COM O GITHUB ⚠️"
echo "Branch Alvo: $BRANCH_NAME"
echo "Workspace: $(pwd)"
echo "------------------------------------------------------------------"
echo ""
echo "🔍 VERIFICAÇÕES DE SEGURANÇA:"
echo "1. Verificando se .gitignore existe e está configurado..."

# Verifica se .gitignore existe
if [ ! -f ".gitignore" ]; then
    echo "❌ ERRO: Arquivo .gitignore não encontrado!"
    echo "Por favor, crie um arquivo .gitignore antes de continuar."
    exit 1
fi

echo "✅ .gitignore encontrado"
echo ""
echo "📋 CONTEÚDO ATUAL DO .gitignore (primeiras 20 linhas):"
head -20 .gitignore
echo ""
echo "⚠️ IMPORTANTE: Verifique se arquivos sensíveis (.env, chaves API, etc.) estão no .gitignore"
echo ""

# Mostra status atual do git
echo "📊 STATUS ATUAL DO GIT:"
git status --short
echo ""

# Confirmação dupla para segurança
echo "🚨 CONFIRMAÇÃO DE SEGURANÇA 🚨"
echo "Esta operação irá:"
echo "  - Adicionar TODOS os arquivos não ignorados ao staging"
echo "  - Criar um commit com timestamp atual"
echo "  - Forçar push para '$BRANCH_NAME' (reescrevendo histórico remoto)"
echo ""
read -p "Você verificou o .gitignore e tem CERTEZA que deseja continuar? (digite 'CONFIRMO'): " -r
echo

if [[ ! $REPLY == "CONFIRMO" ]]; then
    echo "❌ Sincronização cancelada. (Resposta: '$REPLY')"
    echo "Para confirmar, digite exatamente: CONFIRMO"
    exit 1
fi

echo "✅ Iniciando sincronização forçada..."
echo ""

# Adiciona todos os arquivos ao staging area
echo "📦 Adicionando arquivos ao staging..."
git add .
echo "✅ Todos os arquivos foram adicionados ao stage."

# Cria um commit com uma mensagem padrão
COMMIT_MESSAGE="chore: Sincronização bilateral forçada - $(date '+%Y-%m-%d %H:%M:%S')"
echo "💾 Criando commit..."
git commit -m "$COMMIT_MESSAGE" --no-verify
COMMIT_RESULT=$?

if [ $COMMIT_RESULT -eq 0 ]; then
    echo "✅ Commit criado: \"$COMMIT_MESSAGE\""
elif [ $COMMIT_RESULT -eq 1 ]; then
    echo "ℹ️ Nenhuma alteração para commit (working tree limpo)"
    echo "🔄 Prosseguindo com push para garantir sincronização..."
else
    echo "❌ Erro ao criar commit (código: $COMMIT_RESULT)"
    exit 1
fi

# Força o push para a branch remota usando --force-with-lease para segurança
echo ""
echo "🚀 Executando push para a branch remota '$BRANCH_NAME'..."
echo "Usando --force-with-lease para segurança adicional..."

git push origin "$BRANCH_NAME" --force-with-lease
PUSH_RESULT=$?

echo ""
if [ $PUSH_RESULT -eq 0 ]; then
    echo "🎉 SINCRONIZAÇÃO BILATERAL FORÇADA CONCLUÍDA COM SUCESSO!"
    echo "✅ Branch '$BRANCH_NAME' sincronizada com o repositório remoto"
    echo "📊 Status final:"
    git status --short
else
    echo "❌ ERRO no push (código: $PUSH_RESULT)"
    echo "Possíveis causas:"
    echo "  - Branch remota foi atualizada por outro colaborador"
    echo "  - Problemas de conectividade"
    echo "  - Permissões insuficientes"
    echo ""
    echo "💡 Sugestão: Execute 'git fetch' e tente novamente"
    exit 1
fi

echo ""
echo "🔒 SINCRONIZAÇÃO CONCLUÍDA - $(date '+%Y-%m-%d %H:%M:%S')"
