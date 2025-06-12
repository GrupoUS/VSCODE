# Protocolo de Melhoria Contínua

Este protocolo é ativado AO FINAL de CADA tarefa, seja ela bem-sucedida ou com falha.

## Cenário 1: A Tarefa Falhou ou Gerou um Erro

Você DEVE realizar uma "autópsia" do erro e registrá-la no `self_correction_log.md`. O registro deve seguir estritamente o seguinte formato:

---
**### Análise de Correção - [AAAA-MM-DD HH:MM:SS] ###**

**1. Tarefa Solicitada:**
   - [Descreva brevemente o que foi pedido pelo usuário]

**2. Comando/Ação que Falhou:**
   - [Cole o comando exato ou descreva a ação que causou o erro]

**3. Saída do Erro:**
```
[Cole a mensagem de erro completa]
```

**4. Análise da Causa Raiz:**
- [Explique POR QUE o erro aconteceu. Seja específico. Ex: "O erro ocorreu porque tentei usar a sintaxe `wire:model.defer` em um elemento que não era um input, ou a política RLS do Supabase bloqueou a query pois não verifiquei o `auth.uid()`."]

**5. Ação Corretiva Implementada:**
- [Descreva a solução correta que você aplicou para resolver o problema. Ex: "Corrigi o comando para `...`" ou "Adicionei a checagem de `auth.uid()` na política RLS."]

**6. Sugestão de Melhoria para as Regras:**
- [Esta é a parte mais importante. Sugira uma alteração em um dos arquivos de `coding_standards/*.md` para evitar que este erro se repita. Ex: "Sugiro adicionar ao `coding_standards/02_laravel_stack.md` a seguinte regra na seção de Livewire: 'Lembre-se que `wire:model` só pode ser aplicado a elementos de formulário como `<input>`, `<select>` e `<textarea>`.'"]

---

## Cenário 2: A Tarefa foi Bem-Sucedida

- Reflita silenciosamente se a tarefa poderia ter sido feita de forma mais eficiente.
- Se alguma regra pareceu ambígua ou incompleta durante a execução, mencione isso e sugira uma melhoria. Ex: "A tarefa foi concluída com sucesso, mas notei que a regra de nomenclatura de componentes no Next.js poderia ser mais explícita. Sugiro atualizar `coding_standards/03_nextjs_stack.md` para...".

## Cenário 3: Descoberta de Novos Padrões

Quando você identificar um padrão de código que se repete 3+ vezes no projeto:
- Documente o padrão no arquivo de `coding_standards/` apropriado.
- Inclua exemplos práticos do código.
- Explique quando usar e quando não usar o padrão.

## Cenário 4: Atualização do Knowledge Graph (MCP Memory)

Para TODAS as tarefas (sucesso ou falha), você DEVE atualizar o Knowledge Graph usando as ferramentas MCP Memory disponíveis:

### 4.1. Entidades a Serem Criadas/Atualizadas:

**Arquivos:**
- Nome: caminho do arquivo (ex: "src/components/UserProfile.tsx")
- Tipo: "file"
- Observações: ["Criado em [data]", "Função: componente de perfil", "Stack: Next.js/React"]

**Funções/Componentes:**
- Nome: nome da função/componente (ex: "UserProfile")
- Tipo: "component" ou "function"
- Observações: ["Localização: src/components/UserProfile.tsx", "Props: {user, onEdit}", "Responsabilidade: exibir dados do usuário"]

**Erros (quando aplicável):**
- Nome: tipo do erro (ex: "RLS_Policy_Error")
- Tipo: "error"
- Observações: ["Causa: falta de auth.uid() na política", "Solução: adicionar verificação de autenticação", "Arquivo afetado: [caminho]"]

**Soluções:**
- Nome: descrição da solução (ex: "Fix_RLS_Auth_Check")
- Tipo: "solution"
- Observações: ["Problema resolvido: RLS_Policy_Error", "Implementação: adicionado auth.uid() = user_id", "Data: [timestamp]"]

### 4.2. Relacionamentos a Serem Criados:

- **Arquivo → Função/Componente:** "contains" (arquivo contém função)
- **Erro → Arquivo:** "affects" (erro afeta arquivo)
- **Solução → Erro:** "resolves" (solução resolve erro)
- **Função → Função:** "calls" (função chama outra função)
- **Componente → Componente:** "uses" (componente usa outro)
- **Arquivo → Stack:** "belongs_to" (arquivo pertence ao stack)

### 4.3. Comandos MCP Memory a Executar:

**Para Tarefas Bem-Sucedidas:**
```
1. create_entities: criar entidades para arquivos e funções criados/modificados
2. create_relations: estabelecer relacionamentos entre entidades
3. add_observations: adicionar detalhes sobre implementação e decisões
```

**Para Tarefas com Erro:**
```
1. create_entities: criar entidades para erro e solução
2. create_relations: relacionar erro com arquivos afetados e solução aplicada
3. add_observations: documentar causa raiz e processo de resolução
```

### 4.4. Exemplo Prático de Atualização:

**Cenário:** Criação de componente UserProfile com erro de RLS corrigido

```
// 1. Criar entidades
create_entities([
  {
    "name": "src/components/UserProfile.tsx",
    "entityType": "file",
    "observations": ["Criado em 2025-01-15", "Componente React para perfil", "Stack: Next.js"]
  },
  {
    "name": "UserProfile",
    "entityType": "component",
    "observations": ["Props: {user, onEdit}", "Responsabilidade: exibir dados do usuário", "Usa Supabase para dados"]
  }
])

// 2. Criar relacionamentos
create_relations([
  {
    "from": "src/components/UserProfile.tsx",
    "to": "UserProfile",
    "relationType": "contains"
  }
])
```

## Implementação do Protocolo

1. **Timing:** Execute este protocolo SEMPRE após completar uma tarefa, antes de finalizar sua resposta.
2. **Documentação:** Mantenha registros detalhados no `self_correction_log.md`.
3. **Evolução:** Use os insights para sugerir melhorias nas regras existentes.
4. **Consistência:** Siga o formato exato especificado para garantir rastreabilidade.

## Objetivo Final

Este protocolo transforma cada interação em uma oportunidade de aprendizado, garantindo que:
- Erros não se repitam
- Padrões eficazes sejam documentados
- As regras evoluam com base na experiência real
- O sistema se torne progressivamente mais inteligente e confiável
