# 🎯 CORE PRINCIPLES UNIFIED - GRUPO US VIBECODE SYSTEM V4.0

## 🔄 **PROTOCOLO EHS V1 - DEPENDÊNCIA CRÍTICA**

**⚠️ ATENÇÃO**: Este arquivo opera sob o **Protocolo de Evolução e Higiene Sustentável (EHS) V1** definido em `00-protocolo-ehs-v1.md` (Regra #0 - Prioridade Máxima).

**Compliance Obrigatória**: Todas as operações devem seguir as diretivas EHS V1:

- ✅ **Self-Improve**: Reutilização inteligente (85%+) de sistemas existentes
- ✅ **Self-Clean**: Tolerância ZERO com arquivos fora da estrutura @project-core/
- ✅ **Self-Healing**: Consulta obrigatória ao memory bank e auto-correção
- ✅ **Performance V4.0**: Preservação dos ganhos de redução de complexidade (55%+)

---

## 📋 CONSOLIDATION NOTICE

**This file consolidates and replaces:**

- `01-core-principles.md`
- `01-universal-principles-consolidated.md`
- `01-unattended-execution-protocol.md`

**Consolidation Date**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)
**EHS Integration**: 2025-01-27 (Protocolo EHS V1 Compliance)

---

## 🏗️ ARCHITECTURAL PRINCIPLES

### **1. Single Source of Truth**

- **Centralized Rules**: All rules and standards maintained in `@project-core/rules/`
- **Canonical Data**: One authoritative source for each piece of information
- **Consistent References**: All agents and developers use the same rule sources
- **Version Control**: All changes tracked and documented

### **2. Modularity & Reusability**

- **Component-Based Architecture**: Decompose systems into reusable components
- **DRY Principle**: Don't Repeat Yourself - consolidate common patterns
- **Separation of Concerns**: Clear boundaries between different system layers
- **Interface-Driven Design**: Well-defined contracts between components

### **3. Performance & Scalability**

- **Optimization First**: Design for performance from the beginning
- **Lazy Loading**: Load resources only when needed
- **Caching Strategies**: Implement intelligent caching at all levels
- **Resource Management**: Efficient use of memory and processing power

### **4. Security & Compliance**

- **Security by Design**: Build security into every layer
- **Data Protection**: Encrypt sensitive data at rest and in transit
- **Access Control**: Implement proper authentication and authorization
- **Audit Trails**: Maintain logs for security and compliance

---

## 🎨 DEVELOPMENT STANDARDS

### **Code Quality Principles**

- **Readability & Clarity**: Write clear, concise, and self-documenting code
- **SOLID Principles**: Adhere to SOLID principles for scalable, maintainable systems
- **Descriptive Naming**: Use clear, descriptive names for variables, functions, and components
- **No Placeholders**: Implement complete functionality - NO TODOs or placeholders

### **File Naming Conventions**

```
Components:     PascalCase.tsx     (UserProfile.tsx)
Hooks:          camelCase.ts       (useAuthData.ts)
Utilities:      camelCase.ts       (formatDate.ts)
Types:          PascalCase.types.ts (User.types.ts)
Pages:          PascalCase.tsx     (Dashboard.tsx)
API Routes:     kebab-case.ts      (user-profile.ts)
```

### **Directory Structure (Universal)**

```
project/
├── src/
│   ├── components/     # Reusable UI components
│   ├── pages/         # Route components/pages
│   ├── hooks/         # Custom React hooks
│   ├── lib/           # Utilities and configurations
│   ├── types/         # TypeScript type definitions
│   ├── contexts/      # React context providers
│   └── utils/         # Helper functions
├── public/            # Static assets
├── tests/             # Test files
└── docs/              # Documentation
```

---

## 🔒 SECURITY STANDARDS

### **Authentication & Authorization**

```typescript
// Standard auth pattern
const { user, loading } = useAuth();

if (loading) return <LoadingSpinner />;
if (!user) return <Navigate to="/auth" />;

// Authenticated content
return <AuthenticatedComponent />;
```

### **Data Validation**

```typescript
// Use Zod for runtime validation
import { z } from "zod";

const UserSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Invalid email format"),
  age: z.number().min(18, "Must be 18 or older"),
});

type User = z.infer<typeof UserSchema>;
```

### **Environment Variables**

- **Never commit** `.env` files
- **Always use** `.env.example` for documentation
- **Prefix public vars**: `VITE_` for Vite, `NEXT_PUBLIC_` for Next.js
- **Centralize in**: `@project-core/env/` directory

---

## 📊 PERFORMANCE STANDARDS

### **Code Splitting & Lazy Loading**

```typescript
// Lazy load heavy components
const HeavyComponent = lazy(() => import('./HeavyComponent'))

// Use with Suspense
<Suspense fallback={<LoadingSpinner />}>
  <HeavyComponent />
</Suspense>
```

### **Memoization Patterns**

```typescript
// Memoize expensive calculations
const expensiveValue = useMemo(() => {
  return heavyCalculation(data);
}, [data]);

// Memoize callback functions
const handleClick = useCallback(() => {
  onAction(id);
}, [onAction, id]);
```

---

## 🧪 TESTING STANDARDS

### **Coverage Requirements**

- **Unit Tests**: 80% minimum coverage
- **Integration Tests**: Critical user flows
- **E2E Tests**: Main application workflows
- **Performance Tests**: Core functionality benchmarks

### **Test Structure**

```typescript
describe("ComponentName", () => {
  beforeEach(() => {
    // Test setup
  });

  it("should render correctly with valid props", () => {
    // Test implementation
  });

  it("should handle empty data gracefully", () => {
    // Test implementation
  });
});
```

---

## 🔄 ERROR HANDLING PATTERNS

### **API Error Handling**

```typescript
try {
  const response = await api.getData();
  return response.data;
} catch (error) {
  if (error instanceof ApiError) {
    toast.error(error.message);
  } else {
    toast.error("An unexpected error occurred");
    console.error("Unexpected error:", error);
  }
  throw error;
}
```

---

## 🎯 QUALITY GATES

### **Pre-Commit Checklist**

- [ ] Code passes linting (ESLint)
- [ ] Types are correct (TypeScript)
- [ ] Tests pass (Jest/Vitest)
- [ ] No console.log statements
- [ ] Performance validated
- [ ] Security reviewed
- [ ] Documentation updated

### **Code Review Checklist**

- [ ] Follows naming conventions
- [ ] Implements error handling
- [ ] Has appropriate tests
- [ ] Performance optimized
- [ ] Security considerations addressed
- [ ] Documentation complete

---

**Consolidation Complete**: This file unifies all core principles
**Last Updated**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)
**Next Review**: 2025-07-11
