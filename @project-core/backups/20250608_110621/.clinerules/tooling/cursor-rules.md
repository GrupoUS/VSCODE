---
description: Diretrizes para criar e manter regras do Cursor para garantir consistência e efetividade.
globs: .clinerules/tooling/*.md
alwaysApply: true
---

- **Estrutura de Regra Obrigatória:**
  ```markdown
  ---
  description: Descrição clara de uma linha do que a regra enforce
  globs: path/to/files/*.ext, other/path/**/*
  alwaysApply: boolean
  ---

  - **Pontos Principais em Negrito**
    - Sub-pontos com detalhes
    - Exemplos e explicações
  ```

- **Referências de Arquivo:**
  - Use `[filename](.clinerules/tooling/path/to/file)` para referenciar arquivos
  - Exemplo: [taskmaster-reference.md](.clinerules/tooling/taskmaster-reference.md) para referências de regras
  - Exemplo: [schema.prisma](prisma/schema.prisma) para referências de código (se aplicável)

- **Exemplos de Código:**
  - Use blocos de código específicos da linguagem
  ```typescript
  // ✅ FAÇA: Mostrar exemplos bons
  const goodExample = true;
  
  // ❌ NÃO FAÇA: Mostrar anti-padrões
  const badExample = false;
  ```

- **Diretrizes de Conteúdo de Regras:**
  - Começar com visão geral de alto nível
  - Incluir requisitos específicos e acionáveis
  - Mostrar exemplos de implementação correta
  - Referenciar código existente quando possível
  - Manter regras DRY referenciando outras regras

- **Manutenção de Regras:**
  - Atualizar regras quando novos padrões emergirem
  - Adicionar exemplos do codebase atual
  - Remover padrões obsoletos
  - Cross-referenciar regras relacionadas

- **Melhores Práticas:**
  - Usar bullet points para clareza
  - Manter descrições concisas
  - Incluir ambos exemplos de FAÇA e NÃO FAÇA
  - Referenciar código real em vez de exemplos teóricos
  - Usar formatação consistente entre regras
