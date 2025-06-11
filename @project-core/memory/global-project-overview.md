# Global Project Overview - Workspace VSCODE

## Workspace Structure

Este workspace contém múltiplos projetos em desenvolvimento ativo, cada um com propósitos específicos mas compartilhando padrões tecnológicos similares.

## Projetos Ativos

### 1. **NEON PRO** (`/neonpro/`)
- **Tipo**: Sistema de Gestão Clínica
- **Tech Stack**: React + Vite + TypeScript + Supabase + shadcn-ui + Tailwind CSS
- **Propósito**: Gestão completa de clínicas médicas (agenda, pacientes, financeiro, relatórios)
- **Status**: Em desenvolvimento ativo
- **Características**: SPA com autenticação robusta, módulos especializados para área médica

### 2. **Harmoniza Fácil Agendas** (`/harmoniza-facil-agendas/`)
- **Tipo**: Sistema de Agendamento
- **Tech Stack**: Next.js 15 + React 19 + TypeScript + Supabase + Tailwind CSS
- **Propósito**: Plataforma de agendamento e calendários
- **Status**: Em desenvolvimento ativo
- **Características**: SSR/SSG, react-big-calendar, integração com sistemas de agenda

### 3. **Aegis Wallet** (`/aegiswallet/`)
- **Tipo**: Carteira Digital
- **Tech Stack**: React + Vite + TypeScript + Supabase + shadcn-ui + DaisyUI + Tailwind CSS
- **Propósito**: Gerenciamento de transações financeiras e carteira digital
- **Status**: Em desenvolvimento ativo
- **Características**: Interface híbrida (shadcn + DaisyUI), foco em segurança financeira

### 4. **Taskmaster Integration** (`/taskmaster-integration/`)
- **Tipo**: Sistema de Integração
- **Tech Stack**: Node.js + JavaScript
- **Propósito**: Automação e coordenação entre sistemas
- **Status**: Em desenvolvimento
- **Características**: CLI tools, coordenação de workflows

## Padrões Tecnológicos Comuns

### Frontend Frameworks
- **React** (Vite ou Next.js)
- **TypeScript** (padrão em todos os projetos)
- **Tailwind CSS** (sistema de styling universal)

### Backend & Database
- **Supabase** (banco de dados e autenticação padrão)
- **PostgreSQL** (através do Supabase)

### UI Libraries
- **shadcn-ui** (componentes padrão)
- **DaisyUI** (componentes complementares quando necessário)
- **Radix UI** (primitivos de baixo nível)

### Tooling
- **TaskMaster AI CLI** (gerenciamento centralizado de tarefas)
- **ESLint** (linting)
- **Vite/Next.js** (bundling)
- **React Hook Form + Zod** (forms e validação)

## Arquitetura de Memória

Cada projeto possui seu próprio Memory Bank (`projeto/memory-bank/`) que herda e especializa as regras globais definidas neste workspace.

---
### Sistema .clinerules

O workspace possui um sistema de regras consolidado em `.clinerules/` que implementa:

#### Protocolo Unificado de 4 Camadas
- **Layer 1**: Memory Foundation (carregamento obrigatório de contexto)
- **Layer 2**: Meta-Improvement Protocol (auto-melhoria baseada em feedback)
- **Layer 3**: Completeness Verification (verificação sistemática de completude)
- **Layer 4**: Post-Task Learning (captura estruturada de conhecimento)

#### Organizaização Hierárquica de Regras
- `unified-protocol.md` = Definição completa do protocolo macro de 4 camadas
- `master_rule.md` = Coordenador que referencia unified-protocol + workflows específicos
- Arquivos específicos = Implementações especializadas que referenciam o core

**Actionable Improvement**: Sistema .clinerules implementa princípio DRY - cada protocolo tem um arquivo principal com definição completa, outros arquivos apenas referenciam (evita duplicação e inconsistências).

---
**Última Atualização**: 2025-06-04 03:41:00
