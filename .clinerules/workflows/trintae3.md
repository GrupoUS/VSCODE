# Regras de Workflow e Diretrizes do Projeto: Prática TRINTAE3

Este documento serve como um guia de contexto para o desenvolvimento do projeto "Prática TRINTAE3". Todas as contribuições de código, sejam elas geradas por IA ou escritas manualmente, devem seguir estas diretrizes.

## 1. Visão Geral do Projeto

- **Nome:** Prática TRINTAE3
- **Conceito:** Plataforma de gestão e agendamento para "Práticas Presenciais" de harmonização facial.
- **Objetivo:** Conectar e gerenciar o fluxo entre Administradores, Professores/Preceptores, Alunos e Pacientes Modelo.
- **Linguagem da UI:** Toda a interface deve ser em **Português-Brasil (pt-BR)**.

## 2. Tech Stack

- **Plataforma de Geração Inicial:** Lovable.dev
- **Frontend:** React com Next.js
- **Linguagem:** TypeScript
- **Backend & Banco de Dados:** Supabase
- **Estilização:** Tailwind CSS (ou a biblioteca de componentes escolhida, ex: Chakra UI) para implementar um design customizado.

## 3. UI/UX e Diretrizes de Design

- **Tema Principal:** Dark Theme (Tema Escuro). O fundo principal deve ser um cinza muito escuro ou quase preto (ex: `#111827` ou `#0B1437`).
- **Cor de Destaque:** Dourado Neon. A cor principal para botões, links, ícones ativos e outros elementos interativos deve ser um dourado vibrante.
  - **Cor Primária (Dourado Neon):** `~#f2c75a` (inspirado em trintae3.drasacha.com.br, pode ser ajustado para um efeito "glow" com CSS).
- **Cores de Texto:**
  - Texto principal: Branco ou cinza claro com alto contraste (ex: `#FFFFFF` ou `#F3F4F6`).
  - Texto secundário: Cinza mais suave (ex: `#A0AEC0`).
- **Layout:**
  - **Inspiração:** O layout dos painéis deve ser inspirado em dashboards modernos como o **Horizon UI Pro**.
  - **Estrutura:** Baseado em cards, limpo, organizado e com boa hierarquia visual.
- **Responsividade:** O design deve ser totalmente responsivo e funcional em desktop, tablet e mobile.

## 4. Estrutura de Papéis (User Roles)

O sistema possui 4 papéis de usuário. A lógica e os componentes devem sempre levar em conta o papel do usuário logado:

1.  **`Administrador`:** Visão e controle total. Gerencia usuários e configurações.
2.  **`Professor/Preceptor`:** Cria e gerencia suas próprias "Práticas Presenciais". Visualiza seus agendamentos (alunos e pacientes).
3.  **`Aluno`:** Visualiza e se inscreve nas "Práticas Presenciais" disponíveis.
4.  **`PacienteModelo`:** Visualiza e agenda procedimentos específicos durante as Práticas Presenciais.

## 5. Padrões de Código e Boas Práticas

- **Nomenclatura:**
  - **Componentes React:** PascalCase (ex: `PatientCard.tsx`).
  - **Variáveis e Funções:** camelCase (ex: `fetchAppointments`).
- **Comentários:** O código deve ser claro e legível. Comentários (em inglês ou português) devem ser usados para explicar lógicas complexas.
- **Performance:**
  - Otimizar o carregamento das páginas (ex: `next/image` para imagens).
  - As queries ao Supabase devem ser eficientes, buscando apenas os dados necessários.
  - Manter o "bundle size" o menor possível, evitando dependências desnecessárias.
- **Acessibilidade (A11y):** Utilizar tags semânticas de HTML, fornecer atributos `alt` para imagens e garantir que a aplicação seja navegável via teclado.

## 6. Terminologia Chave

- **"Práticas Presenciais"**: Sempre usar este termo em vez de "cursos" ou "aulas" na UI para se referir aos eventos de treinamento prático criados pelos professores.