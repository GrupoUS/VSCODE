# TASK MASTER AI CLI - REGRAS OBRIGATÓRIAS

## COMANDOS CLI DISPONÍVEIS
- `task-master init` - Inicializar projeto
- `task-master parse-prd <arquivo>` - Analisar PRD e gerar tarefas
- `task-master list` - Listar todas as tarefas
- `task-master next` - Mostrar próxima tarefa prioritária
- `task-master generate` - Gerar arquivos de tarefas

## WORKFLOW MANDATÓRIO CLI
1. SEMPRE verificar se projeto foi inicializado: `task-master init`
2. SEMPRE ter PRD em `scripts/prd.txt`
3. SEMPRE gerar tarefas com: `task-master parse-prd scripts/prd.txt`
4. SEMPRE verificar próxima tarefa: `task-master next`
5. SEMPRE listar tarefas ativas: `task-master list`
6. SEMPRE gerar arquivos após mudanças: `task-master generate`

## COMANDOS PROIBIDOS SEM TASK MASTER CLI
- PROIBIDO iniciar implementação sem `task-master next`
- PROIBIDO criar funcionalidades sem `task-master parse-prd`
- PROIBIDO fazer commits sem `task-master generate`

## DIRETRIZES DE USO DO COMANDO

O `task-master` é uma ferramenta de linha de comando (CLI) global. Isso significa que ele deve ser invocado diretamente no terminal, sem prefixos de caminho ou chamadas de script.

### ✅ FAÇA: Uso Correto
```bash
task-master list
task-master next
task-master set-status --id=1 --status=done
```

### ❌ NÃO FAÇA: Uso Incorreto
```bash
# Não use prefixos de caminho
./task-master list
../task-master next

# Não chame via node ou scripts
node scripts/dev.js list
npx task-master-ai list # Use apenas 'task-master' se instalado globalmente

# Não use prefixos de diretório
cd scripts && task-master list
```

**Lembre-se**: Se o comando `task-master` não for reconhecido, certifique-se de que a ferramenta está instalada globalmente (`npm install -g @task-master-ai/cli`) ou que você está usando `npx task-master-ai <comando>` para chamadas locais.
