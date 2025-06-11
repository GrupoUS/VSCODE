# [REGRA DE AUTOMAÇÃO] Sincronização Bilateral Pós-Execução

## Propósito & Escopo
Esta regra define o procedimento padrão de sincronização com o repositório GitHub após a conclusão de todas as tarefas de uma sessão no chat. O objetivo é garantir que o estado do repositório remoto reflita o trabalho concluído, mas com uma camada de confirmação humana para evitar ações destrutivas.

## Implementation Guidelines

### MUST (Obrigatório)
- **MUST**: Ao final da execução de TODAS as tarefas gerenciadas pelo `task-master`, você **DEVE** pausar e perguntar ao usuário se ele deseja sincronizar as alterações com o repositório remoto.
- **MUST**: A pergunta deve ser clara sobre a natureza da operação: "Todas as tarefas foram concluídas. Deseja executar a sincronização bilateral forçada com o GitHub para a branch 'main' (ou a branch de trabalho atual)?".
- **MUST**: Se o usuário confirmar, você **DEVE** executar o script `scripts/force-sync-github.sh` passando a branch de trabalho atual como parâmetro.
- **MUST**: Sempre verificar o arquivo `.gitignore` antes de executar a sincronização para evitar commit de arquivos sensíveis.

### NEVER (Nunca)
- **NEVER**: **NUNCA** execute o script de sincronização sem a confirmação explícita e afirmativa do usuário.
- **NEVER**: **NUNCA** execute a sincronização se houver arquivos `.env`, chaves de API ou outros dados sensíveis não protegidos pelo `.gitignore`.

### SHOULD (Recomendado)
- **SHOULD**: Mostrar o status atual do git (`git status --short`) antes de solicitar confirmação.
- **SHOULD**: Informar ao usuário sobre os riscos da operação de force push.
- **SHOULD**: Sugerir ao usuário revisar as alterações antes da confirmação.

## Exemplo de Interação

```
Agente:
✅ Todas as tarefas foram concluídas com sucesso.

📊 Status atual do Git:
M  scripts/force-sync-github.sh
A  project-core/rules/mcp-integration/05-auto-sync-on-task-completion.md
A  project-core/workflows/sync-github.md

❓ Deseja executar a sincronização bilateral forçada com o GitHub para a branch 'main'?
⚠️  Aviso: Esta ação irá reescrever o histórico remoto usando --force-with-lease.

Usuário:
sim

Agente:
🔄 Executando sincronização...
(Executa ./scripts/force-sync-github.sh main)
```

## Triggers de Ativação

Esta regra é ativada quando:
1. **TaskMaster indica conclusão**: Quando `task-master list` mostra todas as tarefas como concluídas
2. **Fim de sessão complexa**: Após implementação de múltiplas funcionalidades
3. **Solicitação explícita**: Quando o usuário solicita sincronização manual
4. **Comando !syncgithub**: Quando o workflow manual é acionado

## Verificações de Segurança

Antes de executar a sincronização, SEMPRE verificar:
- [ ] Arquivo `.gitignore` existe e está configurado adequadamente
- [ ] Não há arquivos `.env*` no staging area
- [ ] Não há chaves de API ou tokens expostos
- [ ] Usuário confirmou explicitamente a operação
- [ ] Branch de destino está correta

## Integração com TaskMaster

```bash
# Verificar status das tarefas
task-master list --status=completed

# Se todas concluídas, ativar esta regra
# Solicitar confirmação do usuário
# Executar script se confirmado
```

## Related Rules
- `@project-core/rules/00-master-execution-protocol.md`
- `@project-core/rules/universal-pre-execution-verification.md`
- `@project-core/workflows/sync-github.md`

## Histórico de Versões
- v1.0: Criação inicial da regra de automação pós-tarefa
- Data: 2024-12-19
- Autor: GRUPO US VIBECODE SYSTEM V2.0
