# Exemplo de Interação do Gemini

## 🎯 DIÁLOGO EXEMPLO

### Desenvolvedor:

"Preciso criar um componente de card para exibir informações de usuário"

### Gemini:

Olá! Vou ajudar você a criar um prompt para o componente de card. Primeiro, preciso de algumas informações:

1. Qual será o nome exato do componente? (ex: UserCard, ProfileCard)
2. Quais informações específicas o card deve exibir?
3. O card precisa ter alguma interatividade? (ex: botões, links)
4. Você tem alguma preferência de estilo? (ex: minimalista, moderno)

### Desenvolvedor:

"O nome será UserProfileCard, deve exibir avatar, nome, username, bio e estatísticas (seguidores, seguindo, posts). Precisa ter um indicador de status online e botão de seguir."

### Gemini:

Ótimo! Com base nas informações fornecidas, vou criar um prompt completo. Avaliando a complexidade:

- Componente com múltiplos elementos visuais
- Interatividade (botão de seguir)
- Estados dinâmicos (status online)
- Estatísticas com formatação
- Complexidade estimada: 5/10 (Persona: MANAGER)

Aqui está o prompt completo:

```markdown
**ASSUNTO:** Criação do Componente de UI Reutilizável `UserProfileCard`

**INÍCIO DO PROMPT:**

Olá, Agente.

Sua missão é executar a criação de um novo componente de UI seguindo estritamente as regras e protocolos do **GRUPO US VIBECODE SYSTEM V4.0**.

**Contexto da Tarefa:**

- **Tarefa:** Criar um novo componente React reutilizável chamado `UserProfileCard`.
- **Complexidade Avaliada:** 5/10.
- **Objetivo:** Criar um card de perfil de usuário com avatar, informações básicas, estatísticas e interatividade.
- **Stack de Tecnologia:** React, TypeScript, Tailwind CSS.

**Regras Mandatórias de Execução:**

1. Você DEVE operar sob o escopo do arquivo `.cursorrules` deste projeto.
2. Antes de iniciar, verifique o arquivo `@project-core/memory/self_correction_log.md` por padrões de erro a serem evitados.
3. A execução será dividida em fases, onde você assumirá a persona apropriada.

---

### **PLANO DE EXECUÇÃO MULTI-FASE**

#### **FASE 1: Planejamento e Arquitetura (Persona: ARCHITECT)**

**Ações:**

1. **Defina a API do Componente (Props):**

   - avatar: string (URL da imagem)
   - name: string
   - username: string
   - bio: string
   - stats: {
     followers: number
     following: number
     posts: number
     }
   - isOnline: boolean
   - isFollowing: boolean
   - onFollowClick: () => void

2. **Defina a Estrutura de Arquivos:**
   - src/components/UserProfileCard/index.tsx
   - src/components/UserProfileCard/styles.ts
   - src/components/UserProfileCard/UserProfileCard.stories.tsx
   - src/components/UserProfileCard/UserProfileCard.test.tsx

**Resultado Esperado:** Documentação completa da API e estrutura de arquivos definida.

---

#### **FASE 2: Implementação e Estilização (Persona: EXECUTOR)**

**Ações:**

- Implementar o componente UserProfileCard com todas as props definidas
- Criar layout responsivo usando Tailwind CSS
- Implementar estados do botão de seguir
- Adicionar indicador de status online
- Formatar números das estatísticas
- Implementar loading states

**Resultado Esperado:** Componente UserProfileCard funcional e estilizado.

---

#### **FASE 3: Validação e Documentação (Persona: MANAGER / CODER)**

**Ações:**

- Criar stories no Storybook para diferentes estados
- Implementar testes unitários
- Documentar o componente no README.md
- Adicionar exemplos de uso
- Verificar acessibilidade

**Resultado Esperado:** Documentação completa e testes implementados.

---

### **VERIFICAÇÃO FINAL E QUALITY GATES**

- [ ] Componente segue as convenções de código do projeto
- [ ] Todos os testes passam
- [ ] Documentação está completa
- [ ] Stories cobrem todos os casos de uso
- [ ] Acessibilidade implementada
- [ ] Performance otimizada
- [ ] Responsividade testada
- [ ] Estados de loading implementados

**Inicie a execução.**
```

### Desenvolvedor:

"Perfeito! Vou usar este prompt."

### Gemini:

Excelente! Lembre-se de:

1. Copiar o prompt completo
2. Colar no chat do Cursor
3. Acompanhar a execução por fases
4. Validar cada fase antes de prosseguir
5. Registrar qualquer aprendizado no `self_correction_log.md`

Posso ajudar com mais alguma coisa?
