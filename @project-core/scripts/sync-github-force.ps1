# SCRIPT DE SINCRONIZACAO FORCADA COM GITHUB V2.0
# Objetivo: Sincronizar o repositorio local com o repositorio remoto no GitHub,
# forcando o push das alteracoes. Este processo fara com que o repositorio remoto
# fique exatamente igual ao seu diretorio local, incluindo a adicao de novos arquivos,
# a atualizacao dos modificados e a exclusao dos que nao existem mais localmente.

Write-Host "=== INICIANDO SINCRONIZACAO FORCADA COM GITHUB V2.0 ===" -ForegroundColor Cyan
Write-Host "ATENCAO: Este comando ira sobrescrever o historico e a estrutura de arquivos" -ForegroundColor Yellow
Write-Host "da sua branch remota para que ela se torne um espelho exato do seu ambiente local." -ForegroundColor Yellow
Write-Host "Tenha certeza de que seu ambiente local esta na versao que voce deseja manter." -ForegroundColor Yellow
Write-Host ""

# Detecta automaticamente a branch atual
$currentBranch = git rev-parse --abbrev-ref HEAD
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERRO: Nao foi possivel identificar a branch atual. Verifique se esta em um repositorio Git valido."
    exit 1
}

Write-Host "Branch atual detectada: $currentBranch" -ForegroundColor Green
Write-Host ""

# Mostra o status atual antes da sincronizacao
Write-Host "Status atual do repositorio:" -ForegroundColor Cyan
git status --short
Write-Host ""

# 1. Adiciona todas as alteracoes, incluindo arquivos novos, modificados e deletados.
Write-Host "1. Adicionando todas as alteracoes ao stage..." -ForegroundColor Cyan
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERRO ao adicionar arquivos ao stage."
    exit 1
}
Write-Host "Todas as alteracoes locais adicionadas ao stage." -ForegroundColor Green

# 2. Cria um commit com uma mensagem descritiva.
Write-Host "2. Criando commit com mensagem descritiva..." -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commitMessage = "CHORE: Forca a sincronizacao total do local para o remoto - $timestamp"
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "Nenhuma alteracao para commit (working tree limpo)" -ForegroundColor Yellow
    Write-Host "Prosseguindo com push para garantir sincronizacao..." -ForegroundColor Yellow
} else {
    Write-Host "Commit criado: $commitMessage" -ForegroundColor Green
}

# 3. Realiza o push forcado para a branch de origem, sobrescrevendo o conteudo remoto.
Write-Host "3. Executando push forcado para '$currentBranch'..." -ForegroundColor Cyan
Write-Host "Comando: git push origin $currentBranch --force" -ForegroundColor Gray
git push origin $currentBranch --force
if ($LASTEXITCODE -ne 0) {
    Write-Error "ERRO ao forcar o push para o GitHub na branch '$currentBranch'."
    Write-Host "Possiveis solucoes:" -ForegroundColor Yellow
    Write-Host "- Verifique sua conexao com a internet" -ForegroundColor Yellow
    Write-Host "- Confirme suas credenciais do GitHub" -ForegroundColor Yellow
    Write-Host "- Verifique se tem permissoes de push no repositorio" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=== SINCRONIZACAO FORCADA CONCLUIDA COM SUCESSO! ===" -ForegroundColor Green
Write-Host "O repositorio remoto na branch '$currentBranch' agora esta identico ao seu ambiente local." -ForegroundColor Green
Write-Host ""

# Verificacao pos-push
Write-Host "Status final do repositorio:" -ForegroundColor Cyan
git status
Write-Host ""
Write-Host "Sincronizacao concluida em: $timestamp" -ForegroundColor Green
