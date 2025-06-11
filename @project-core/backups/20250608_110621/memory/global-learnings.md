# Global Learnings - Conhecimento Acumulado do Workspace

## Decisões Arquiteturais Globais

### LEARNING: Padronização TypeScript em Todo Workspace
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Múltiplos projetos iniciaram com diferentes abordagens para tipos e interfaces
- **Decision/Solution**: Adotado TypeScript como padrão obrigatório em todos os projetos, com convenções unificadas de nomenclatura e organização
- **Rationale**: Consistência, type safety, melhor DX (Developer Experience), facilita manutenção cross-project

---

### LEARNING: Supabase como Backend Universal
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Necessidade de backend consistente e escalável para todos os projetos
- **Decision/Solution**: Supabase escolhido como solução padrão de backend (Auth + Database + Storage)
- **Rationale**: Reduz complexidade de infraestrutura, auth unificado, PostgreSQL robusto, RLS para segurança, real-time capabilities

---

### LEARNING: Tailwind CSS + shadcn-ui como UI Stack
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Necessidade de consistência visual e velocidade de desenvolvimento UI
- **Decision/Solution**: Tailwind CSS para styling base + shadcn-ui para componentes reutilizáveis
- **Rationale**: Utility-first approach, componentes acessíveis por padrão, customização flexível, mantém consistência visual

---

### LEARNING: Context Pattern para Estado Global
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Gerenciamento de estado entre componentes (especialmente auth)
- **Decision/Solution**: React Context + Custom Hooks para estado global, evitando Redux quando possível
- **Rationale**: Menos boilerplate, integração natural com React, suficiente para a maioria dos casos de uso

---

## Padrões de Desenvolvimento Estabelecidos

### LEARNING: Estrutura de Autenticação Unificada
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Todos os projetos precisam de autenticação robusta
- **Decision/Solution**: Pattern unificado com AuthProvider + useAuth hook + ProtectedRoute components
- **Rationale**: Reutilização de código, UX consistente, security-first approach

---

### LEARNING: Memory Bank por Projeto + Global
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Necessidade de manter contexto específico por projeto mas com padrões globais
- **Decision/Solution**: Hierarquia de Memory Banks (Global → Projeto específico)
- **Rationale**: Balanceia consistência global com flexibilidade local, facilita manutenção e evolução

---

### LEARNING: Mobile-First Development
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Todos os sistemas precisam funcionar bem em mobile
- **Decision/Solution**: Abordagem mobile-first em todos os projetos, com breakpoints bem definidos
- **Rationale**: Maioria dos usuários acessam via mobile, força design mais limpo e focado

---

## Soluções para Problemas Recorrentes

### LEARNING: Env Variables Management
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Gestão segura de variáveis de ambiente em múltiplos projetos
- **Decision/Solution**: `.env.example` obrigatório, prefixos específicos por framework, rotação de keys
- **Rationale**: Security by design, facilita onboarding, previne vazamentos acidentais

---

### LEARNING: Error Handling Patterns
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Necessidade de error handling consistente
- **Decision/Solution**: Error Boundaries + Toast notifications + Try-catch em async operations
- **Rationale**: UX melhor, debugging mais fácil, aplicação mais robusta

---

### LEARNING: Performance Optimization Strategy
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Aplicações crescendo em complexidade, performance se tornando crítica
- **Decision/Solution**: Lazy loading para rotas/componentes, memoization estratégica, code splitting
- **Rationale**: Mantém aplicações responsivas conforme crescem, melhor UX

---

## Integrações e Ferramentas

### LEARNING: Development Workflow Tools
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Necessidade de ferramentas que aceleram desenvolvimento
- **Decision/Solution**: Vite para projetos SPA, Next.js para SSR/SSG, ESLint + Prettier para code quality
- **Rationale**: Developer experience otimizada, builds rápidos, qualidade de código

---

### LEARNING: Git Workflow Standards
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Colaboração entre projetos e manutenção de histórico
- **Decision/Solution**: Conventional commits, branching strategy clara, semantic versioning
- **Rationale**: Facilita colaboração, automatização de releases, tracking de mudanças

---

## Lições de Debugging e Troubleshooting

### LEARNING: Supabase Connection Debugging
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Problemas de conexão com Supabase são comuns durante desenvolvimento
- **Decision/Solution**: Scripts de diagnóstico padrão, env validation, connection tests
- **Rationale**: Acelera debugging, padroniza troubleshooting, reduz tempo perdido

---

### LEARNING: Authentication Flow Debugging
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Auth flows complexos causam confusão frequente
- **Decision/Solution**: Logs detalhados, test utilities, auth state visualization
- **Rationale**: Debugging mais rápido, melhor entendimento do flow, menos bugs

---

## Insights de Business Logic

### LEARNING: Domain-Specific Patterns
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Cada projeto tem domínio específico (saúde, finanças, agendamento)
- **Decision/Solution**: Separação clara entre UI components e business logic, domain types bem definidos
- **Rationale**: Facilita evolução de regras de negócio, testes mais fáceis, código mais maintível

---

### LEARNING: Data Validation Strategy
- **Timestamp**: 2025-06-03 04:12:00
- **Context**: Validação de dados crítica em todos os projetos
- **Decision/Solution**: Zod para schema validation, validação no frontend e backend
- **Rationale**: Type safety, melhor UX, segurança, consistência de dados

---

---

## Post-Task Reflection: Implementação do Protocolo Unificado

### LEARNING: Sistema de 4 Camadas para Desenvolvimento Inteligente
- **Timestamp**: 2025-06-03 05:23:50
- **Context**: Necessidade de formalizar sequência obrigatória de protocolos para garantir qualidade e consistência
- **Decision/Solution**: Implementado sistema unificado com 4 camadas:
  1. **Memory Foundation**: Carregamento obrigatório de contexto
  2. **Meta-Improvement**: Auto-melhoria baseada em feedback
  3. **Completeness Verification**: Verificação sistemática de completude
  4. **Post-Task Learning**: Captura estruturada de conhecimento
- **Rationale**: Cria ciclo virtuoso de melhoria contínua, garante completude, preserva contexto
- **Actionable Improvement**: Todos os futuros workflows devem seguir esta estrutura de 4 camadas

---

### LEARNING: Meta-Improvement Protocol Baseado em Feedback
- **Timestamp**: 2025-06-03 05:23:50
- **Context**: Identificação de que muitos atritos poderiam ser evitados com regras mais específicas
- **Decision/Solution**: Layer 2 analisa conversas em busca de padrões de atrito e sugere melhorias antes de finalizar tarefas
- **Rationale**: Sistema se torna auto-adaptativo baseado em feedback real, não teórico
- **Actionable Improvement**: Implementar este protocolo como padrão para evolução das regras

---

### LEARNING: Integração Hierárquica de Protocolos
- **Timestamp**: 2025-06-03 05:23:50
- **Context**: Sistema anterior tinha protocolos isolados, causando confusão sobre precedência
- **Decision/Solution**: Unified-protocol.md como estrutura macro, master_rule.md como coordenador de workflows específicos
- **Rationale**: Clareza de precedência, preserva investimento em protocolos existentes, adiciona estrutura
- **Actionable Improvement**: Manter esta hierarquia clara em futuras expansões do sistema

---

## Post-Task Reflection: Criação Memory Bank MCP R-Task Manager

### LEARNING: Padrão Consolidado de Memory Bank por Projeto
- **Timestamp**: 2025-06-03 05:33:52
- **Context**: Necessidade de aplicar sistema de Memory Bank em projeto Next.js 15 + React 19 moderno
- **Decision/Solution**: Aplicado padrão de 3 arquivos (project-snapshot.md, task-log.md, learnings.md) com adaptações para stack moderna
- **Rationale**: Estrutura consistente facilita navegação e manutenção, independente do stack tecnológico
- **Actionable Improvement**: Template Memory Bank funciona bem para qualquer stack - manter estrutura padrão

---

### LEARNING: Next.js 15 + React 19 + Tailwind CSS v4 como Stack Moderna
- **Timestamp**: 2025-06-03 05:33:52
- **Context**: Projeto MCP R-Task Manager usando tecnologias cutting-edge
- **Decision/Solution**: Documentado stack completo: Next.js 15, React 19, TypeScript, Tailwind CSS v4, daisyUI, Geist font
- **Rationale**: Stack representa estado-da-arte para aplicações modernas, offering performance + DX benefits
- **Actionable Improvement**: Considerar este stack para novos projetos que precisam de performance máxima

---

### LEARNING: daisyUI para Rapid UI Development
- **Timestamp**: 2025-06-03 05:33:52
- **Context**: Avaliação de biblioteca de componentes para acelerar desenvolvimento
- **Decision/Solution**: daisyUI escolhido para combinar utility-first Tailwind com componentes pré-construídos
- **Rationale**: Acelera desenvolvimento, mantém flexibilidade do Tailwind, acessibilidade built-in
- **Actionable Improvement**: daisyUI pode ser padrão para projetos que precisam de velocidade de desenvolvimento

---

---

## Post-Task Reflection: Incorporação do Protocolo Unificado no Sistema .clinerules

### LEARNING: Princípio DRY para Organização de Arquivos .clinerules
- **Timestamp**: 2025-06-03 05:42:15
- **Context**: Durante implementação do protocolo unificado, identificada duplicação desnecessária entre master_rule.md e unified-protocol.md
- **Decision/Solution**: Implementado princípio "Single Source of Truth" onde cada protocolo tem UM arquivo principal com definição completa, e outros arquivos apenas referenciam
- **Rationale**: Evita inconsistências, facilita manutenção, reduz confusão sobre qual arquivo é autoridade
- **Actionable Improvement**: Aplicar este princípio DRY em todas as futuras expansões do sistema .clinerules - um arquivo principal, demais fazem referência

---

### LEARNING: Estrutura de 4 Camadas Implementada com Sucesso
- **Timestamp**: 2025-06-03 05:42:15
- **Context**: Primeira implementação completa do protocolo unificado em tarefa real
- **Decision/Solution**: Executadas todas as 4 camadas: Memory Foundation → Meta-Improvement → Completeness Verification → Post-Task Learning
- **Rationale**: Sistema funciona como planejado, criando ciclo virtuoso de melhoria contínua
- **Actionable Improvement**: Protocolo unificado demonstrou eficácia - manter como estrutura obrigatória para todas as tarefas complexas

---

### LEARNING: Meta-Improvement Baseado em Feedback Real é Efetivo
- **Timestamp**: 2025-06-03 05:42:15
- **Context**: Layer 2 identificou problema organizacional real e sugeriu melhoria específica que foi aprovada pelo usuário
- **Decision/Solution**: Processo de "pause and analyze" antes de attempt_completion permite identificar melhorias baseadas em fricção real, não teórica
- **Rationale**: Sistema se adapta baseado em experiência real de uso, tornando-se mais eficiente com o tempo
- **Actionable Improvement**: Layer 2 do protocolo unificado é valiosa - deve sempre ser executada em tarefas multi-etapa ou quando há feedback do usuário

---

---

## Post-Task Reflection: Implementação de Melhorias no Sistema de Auto-Reflexão

### LEARNING: Sistema de Feedback Visual Aumenta Transparência
- **Timestamp**: 2025-06-03 06:02:35
- **Context**: Usuário reportou que sistema de auto-reflexão existia mas não era visível o suficiente
- **Decision/Solution**: Implementado feedback visual obrigatório com emojis em todas as 4 camadas: 🔄 → 🔍 → ✅ → 📚
- **Rationale**: Transparência total sobre quando sistema está analisando, permite usuário acompanhar progresso
- **Actionable Improvement**: Feedback visual deve ser padrão em todos os protocolos automatizados - usuário precisa saber quando sistema está processando

---

### LEARNING: Critérios de Ativação Sensíveis Capturam Mais Oportunidades
- **Timestamp**: 2025-06-03 06:02:35
- **Context**: Sistema anterior tinha critérios restritivos, perdendo oportunidades de melhoria em tarefas menores
- **Decision/Solution**: Expandidos critérios para incluir: +2 arquivos, +5 min conversa, qualquer feedback do usuário, uso de MCP tools
- **Rationale**: Mais oportunidades = mais aprendizado = sistema se torna mais eficiente ao longo do tempo
- **Actionable Improvement**: Protocolos devem ter múltiplos níveis de sensibilidade - "lite" para tarefas simples, "completo" para complexas

---

### LEARNING: Controle Manual Empodera o Usuário
- **Timestamp**: 2025-06-03 06:02:35
- **Context**: Necessidade de permitir usuário forçar reflexão quando desejar, independente de critérios automáticos
- **Decision/Solution**: Implementado comando `!reflect` que ativa Layer 2 sob demanda
- **Rationale**: Usuário pode ter insights que sistema automático não detecta, controle manual aumenta valor
- **Actionable Improvement**: Todos os protocolos automatizados devem ter mecanismo de ativação manual - usuário deve ter controle final

---

### LEARNING: Categorização de Critérios Melhora Documentação
- **Timestamp**: 2025-06-03 06:02:35
- **Context**: Lista única de critérios era confusa, não ficava claro qual situação priorizava ativação
- **Decision/Solution**: Separados critérios em "Principais" (alta prioridade) e "Expandidos" (sensibilidade aumentada)
- **Rationale**: Clareza hierárquica facilita entendimento e manutenção do sistema
- **Actionable Improvement**: Organização hierárquica deve ser aplicada em todos os protocolos com múltiplos critérios

---

### LEARNING: Protocolo Unificado de 4 Camadas É Efetivo para Auto-Melhoria
- **Timestamp**: 2025-06-03 06:02:35
- **Context**: Esta própria tarefa foi executada seguindo o protocolo unificado implementado anteriormente
- **Decision/Solution**: Layer 1 (contexto) → Layer 2 (não ativou - sem atrito) → Layer 3 (verificação completa) → Layer 4 (esta reflexão)
- **Rationale**: Sistema funciona como planejado, auto-aplicação demonstra eficácia
- **Actionable Improvement**: Protocolo unificado deve ser mantido como padrão para todas as tarefas complexas - comprovadamente efetivo

**Última Atualização**: 2025-06-04 04:31:17

### LEARNING: Inicialização e Invocação do Taskmaster AI
- **Timestamp**: 2025-06-04 04:16:24 (aproximado)
- **Context**: Dificuldade inicial em invocar e inicializar o Taskmaster AI CLI.
- **Decision/Solution**:
  - A invocação preferencial é `task-master <comando>` (após a configuração de aliases).
  - `npx task-master-ai <comando>` é um fallback robusto para garantir a execução, especialmente antes da inicialização completa.
  - O comando `init` não deve usar `--yes` para permitir prompts interativos e configuração guiada.
- **Rationale**: Garante uma inicialização suave e consistente do Taskmaster em novos projetos, evitando erros comuns de invocação e configuração.
- **Actionable Improvement**: Priorizar `task-master init` para inicialização e `task-master <comando>` para uso geral, com `npx task-master-ai` como fallback.

### LEARNING: Erro de Invocação de Comando CLI (`..task-master`)
- **Timestamp**: 2025-06-04 01:35:00 PM (America/Sao_Paulo)
- **Context**: Tentativa de invocar o comando `task-master` com um prefixo de caminho incorreto (`..task-master`), resultando em "The term '..task-master' is not recognized".
- **Decision/Solution**:
  - O `task-master` é um comando CLI global e deve ser invocado diretamente (ex: `task-master next`).
  - Atualizada a regra `.clinerules/taskmaster-cli-integration.md` para incluir diretrizes claras de uso correto e incorreto, com exemplos.
- **Rationale**: Prevenir erros de sintaxe comuns ao invocar ferramentas CLI globais, garantindo que o sistema reconheça e execute os comandos corretamente.
- **Actionable Improvement**: Reforçar a importância da sintaxe correta para comandos CLI globais em toda a documentação e nos prompts de uso.
