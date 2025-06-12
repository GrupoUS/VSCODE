# Global Standards - Padrões e Convenções Universais

## Convenções de Código

### Estrutura de Diretórios

```
projeto/
├── src/
│   ├── components/     # Componentes reutilizáveis
│   ├── pages/         # Páginas/rotas principais
│   ├── contexts/      # Context providers (React)
│   ├── hooks/         # Custom hooks
│   ├── lib/           # Utilities e configurações
│   ├── types/         # Definições de tipos TypeScript
│   └── utils/         # Funções utilitárias
├── public/            # Assets estáticos
└── memory-bank/       # Memory Bank específico do projeto
```

### Nomenclatura de Arquivos

- **Componentes React**: `PascalCase.tsx` (ex: `UserProfile.tsx`)
- **Hooks**: `camelCase.ts` começando com `use` (ex: `useAuthData.ts`)
- **Utilities**: `camelCase.ts` (ex: `formatDate.ts`)
- **Types**: `camelCase.ts` ou `PascalCase.ts` (ex: `userTypes.ts` ou `User.types.ts`)
- **Pages**: `PascalCase.tsx` (ex: `Dashboard.tsx`)

### Padrões de Código TypeScript

#### Imports Organization

```typescript
// 1. React e frameworks
import React from "react";
import { NextPage } from "next";

// 2. Third-party libraries
import { toast } from "sonner";
import { format } from "date-fns";

// 3. Internal components e contexts
import { Button } from "@/components/ui/button";
import { useAuth } from "@/contexts/auth";

// 4. Types e interfaces
import type { User, AuthData } from "@/types";
```

#### Interface e Type Definitions

```typescript
// Use PascalCase para interfaces e types
interface UserProfile {
  id: string;
  name: string;
  email: string;
  createdAt: Date;
}

// Use union types para status e estados
type AuthStatus = "authenticated" | "loading" | "unauthenticated";

// Use Generic types quando apropriado
interface ApiResponse<T> {
  data: T;
  success: boolean;
  message?: string;
}
```

### Padrões React

#### Componentes Funcionais

```typescript
// Sempre use arrow functions para componentes
const ComponentName: React.FC<Props> = ({ prop1, prop2 }) => {
  // Logic here
  return <div className="container">{/* JSX here */}</div>;
};

export default ComponentName;
```

#### Custom Hooks

```typescript
// Pattern para custom hooks
const useCustomHook = (initialValue?: string) => {
  const [state, setState] = useState(initialValue);

  const actions = {
    update: (value: string) => setState(value),
    reset: () => setState(initialValue),
  };

  return { state, ...actions };
};
```

## Convenções de Styling

### Tailwind CSS Classes

- **Responsividade**: Mobile-first approach (`sm:`, `md:`, `lg:`, `xl:`)
- **Spacing**: Usar escala padrão (4, 8, 12, 16, 20, 24, etc.)
- **Colors**: Definir paleta consistente no `tailwind.config.ts`

### shadcn-ui Integration

- **Componentes Base**: Sempre usar componentes do `/components/ui/`
- **Customização**: Estender via `className` props, não modificar arquivos base
- **Temas**: Configurar via CSS variables no `:root`

## Padrões de Banco de Dados (Supabase)

### Naming Conventions

- **Tabelas**: `snake_case` (ex: `user_profiles`, `appointment_slots`)
- **Colunas**: `snake_case` (ex: `created_at`, `user_id`)
- **Relacionamentos**: `{table}_id` (ex: `user_id`, `appointment_id`)

### Otimização de Consultas Complexas

- Para dados analíticos ou relatórios, utilize `RPC functions` para encapsular lógica e `materialized views` para pré-computar e cachear resultados de consultas pesadas, melhorando a performance.

### RLS (Row Level Security)

- **Sempre ativar** RLS em tabelas de produção
- **Políticas claras**: Nome descritivo para cada política
- **Testes**: Verificar políticas antes de deploy

### Migrations

- **Nomenclatura**: `YYYYMMDD_HHMMSS_description.sql`
- **Reversibilidade**: Sempre considerar rollback
- **Atomicidade**: Uma alteração lógica por migration

## Padrões de Autenticação

### Supabase Auth

```typescript
// Pattern padrão para verificação de auth
const { user, loading } = useAuth();

if (loading) return <LoadingSpinner />;
if (!user) return <Navigate to="/auth" />;

// Componente autenticado
return <AuthenticatedContent />;
```

### Proteção de Rotas

- **React Router**: `ProtectedRoute` wrapper component
- **Next.js**: Middleware ou `getServerSideProps`
- **Estado Global**: Context para auth state

## Tratamento de Erros

### Error Boundaries

```typescript
// Sempre implementar Error Boundaries para components críticos
const ErrorBoundary: React.FC<{ children: React.ReactNode }> = ({
  children,
}) => {
  // Error boundary logic
};
```

### Toast Notifications

- **Sucesso**: Verde (#10B981)
- **Erro**: Vermelho (#EF4444)
- **Warning**: Amarelo (#F59E0B)
- **Info**: Azul (#3B82F6)

## Padrões de Performance

### Lazy Loading

```typescript
// Para componentes grandes
const LazyComponent = lazy(() => import("./HeavyComponent"));

// Para rotas
const LazyPage = lazy(() => import("../pages/HeavyPage"));
```

### Memoization

- **React.memo**: Para componentes que re-renderizam frequentemente
- **useMemo**: Para cálculos custosos
- **useCallback**: Para funções passadas como props

## Git e Versionamento

### Commit Messages

```
feat: adiciona componente de calendario
fix: corrige validacao de email
docs: atualiza README com setup
style: ajusta espacamento do header
refactor: reorganiza estrutura de arquivos
test: adiciona testes para auth hook
```

### Branching

- **main**: Código de produção
- **develop**: Desenvolvimento ativo
- **feature/**: Novas funcionalidades
- **fix/**: Correções de bugs
- **hotfix/**: Correções críticas

## Security Standards

### Variáveis de Ambiente

- **Nunca** commitar `.env` files
- **Sempre** usar `.env.example` para documentar variáveis
- **Prefixos**: `VITE_` para Vite, `NEXT_PUBLIC_` para Next.js

### API Keys

- **Rotação regular** de chaves em produção
- **Minimal permissions** para cada chave
- **Monitoring** de uso de APIs

## 🔒 Padrões de Segurança

### Gestão de Segredos

1. **Uso Obrigatório do Git Secrets**

   - Todo repositório DEVE ter o `git-secrets` configurado
   - Execute `setup-git-secrets.ps1` durante o setup inicial
   - Mantenha os hooks do git-secrets atualizados

2. **Variáveis de Ambiente**

   - Use SEMPRE arquivos `.env` para segredos
   - Mantenha um `.env.example` atualizado
   - Nunca comite arquivos `.env` ou outros com segredos
   - Use nomes descritivos para variáveis (ex: `DB_PASSWORD`, `API_KEY`)

3. **Padrões de Bloqueio**

   - Chaves de API (AWS, Google, etc.)
   - Tokens de autenticação
   - Senhas e credenciais
   - Chaves privadas e certificados
   - Outros padrões sensíveis

4. **Boas Práticas**

   - Revise o código antes de commitar
   - Use `git secrets --scan` para verificar commits
   - Mantenha segredos em serviços de gestão de segredos
   - Rotacione chaves regularmente
   - Use diferentes segredos por ambiente

5. **Validação de Segurança**
   - Execute `git secrets --scan` antes de cada commit
   - Verifique o `.gitignore` regularmente
   - Mantenha o `setup-git-secrets.ps1` atualizado
   - Documente qualquer exceção necessária

## 📁 DIRECTORY STRUCTURE MAINTENANCE PROTOCOLS

**Authority**: GRUPO US VIBECODE SYSTEM V4.0 Post-Consolidation Implementation
**Status**: Active - Mandatory Compliance
**Last Updated**: 2025-01-10

### **🚨 CRITICAL STRUCTURE INTEGRITY RULES**

#### **1. NESTED DUPLICATION PREVENTION**

- **FORBIDDEN**: Any nested @project-core directories (`@project-core/@project-core/`)
- **FORBIDDEN**: Nested memory structures (`@project-core/memory/@project-core/`)
- **MANDATORY**: Pre-creation validation using `pre-commit-structure-validator.ps1`
- **ENFORCEMENT**: Automated monitoring via `structure-integrity-monitor.ps1`

#### **2. CONTENT PLACEMENT STANDARDS**

- **Memory Systems**: All RAG and cognitive functionality in `@project-core/memory/`
- **Rules & Protocols**: System governance in `@project-core/rules/`
- **Automation**: Scripts and processes in `@project-core/automation/`
- **Configuration**: System configs in `@project-core/configs/`
- **Documentation**: Reports and guides in `@project-core/docs/`

#### **3. NAMING CONVENTION ENFORCEMENT**

- **Directories**: kebab-case or snake_case only
- **Files**: descriptive-names with appropriate extensions
- **Backups**: timestamp format `backup-YYYYMMDD-HHMMSS/`
- **Archives**: purpose-specific naming `archived-project-name/`

### **🔧 MAINTENANCE PROCEDURES**

#### **Weekly Integrity Monitoring**

```powershell
# Automated weekly execution
.\@project-core\automation\weekly-integrity-scheduler.ps1 -Install

# Manual execution
.\@project-core\automation\simple-structure-monitor.ps1 -Detailed
```

#### **Pre-Modification Validation**

```powershell
# Before creating any new directory
.\@project-core\automation\pre-commit-structure-validator.ps1 -TargetPath "new-directory-path"

# Before structural changes
.\@project-core\automation\pre-commit-structure-validator.ps1 -TargetPath "target-path" -DryRun
```

#### **Optimization Scanning**

```powershell
# Monthly optimization analysis
.\@project-core\automation\optimization-opportunity-scanner.ps1 -GenerateReport

# Targeted optimization execution
.\@project-core\automation\targeted-optimization-executor.ps1 -DryRun
```

### **📋 CHANGE MANAGEMENT PROTOCOLS**

#### **Structural Modification Approval Matrix**

| Change Type       | Approval Required | Validation Steps      | Backup Required |
| ----------------- | ----------------- | --------------------- | --------------- |
| New Directory     | Self-approval     | Pre-commit validator  | No              |
| Content Move      | Self-approval     | Integrity monitor     | Recommended     |
| Large Restructure | Team lead         | Full validation suite | Mandatory       |
| System Migration  | Architecture team | Comprehensive testing | Critical        |

#### **Mandatory Documentation Updates**

- All structural changes logged in `self_correction_log.md`
- Optimization results documented in monitoring reports
- Guidelines updated for new patterns or violations
- Team training materials refreshed quarterly

### **🎯 CONTINUOUS OPTIMIZATION FRAMEWORK**

#### **4-Phase Consolidation Methodology**

1. **Security & Analysis**: Backup creation and comprehensive mapping
2. **Systematic Consolidation**: Incremental content migration with validation
3. **Validation & Testing**: Integrity verification and functionality testing
4. **Memory System Updates**: Learning documentation and pattern capture

#### **Optimization Targets & Thresholds**

- **File Reduction**: Target 20-30% reduction in optimization cycles
- **Duplicate Elimination**: Zero tolerance for nested @project-core structures
- **Performance Improvement**: Measurable navigation and access speed gains
- **Maintenance Overhead**: Continuous reduction in structural complexity

#### **Success Metrics & KPIs**

- **Structure Health**: Zero nested duplications detected
- **Naming Compliance**: 100% adherence to naming conventions
- **Optimization Efficiency**: Regular achievement of reduction targets
- **Team Adoption**: 100% compliance with validation procedures

---

**Última Atualização**: 2025-01-10 20:45:00
