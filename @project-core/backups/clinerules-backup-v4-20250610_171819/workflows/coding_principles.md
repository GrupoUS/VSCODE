---
description: Princípios fundamentais de codificação para garantir qualidade, manutenibilidade e arquitetura modular
author: Sistema GRUPOUS/Cline Rules
version: 2.0
globs: ["**/*"]
tags: ["coding-principles", "architecture", "modular-design", "quality", "mandatory"]
alwaysApply: true
---

# Princípios Fundamentais de Codificação

Este documento estabelece os princípios obrigatórios que devem ser seguidos em todos os projetos para garantir código de alta qualidade, manutenível e escalável.

## 1. Princípio da Execução Truncada (Decomposição Obrigatória)

### **Regra Fundamental:**
Qualquer solicitação de alteração ou implementação considerada "grande" DEVE ser primeiramente decomposta em um plano de sub-tarefas sequenciais e menores.

### **Critérios para Classificação como "Tarefa Grande":**
- Implementações que afetam múltiplos arquivos (3+ arquivos)
- Funcionalidades que envolvem múltiplas camadas da aplicação (frontend + backend + banco)
- Refatorações que impactam a arquitetura existente
- Implementações estimadas em mais de 4 horas de trabalho
- Qualquer tarefa que gere incerteza sobre por onde começar

### **Processo Obrigatório:**
1. **Análise Inicial:** Identificar todos os componentes, arquivos e sistemas afetados
2. **Decomposição:** Quebrar em sub-tarefas de no máximo 1-2 horas cada
3. **Sequenciamento:** Definir ordem lógica de execução com dependências claras
4. **Aprovação:** Apresentar o plano antes de iniciar a codificação
5. **Execução Iterativa:** Implementar uma sub-tarefa por vez, validando antes de prosseguir

### **Benefícios:**
- Reduz riscos de implementação
- Facilita revisão e debugging
- Permite ajustes de curso durante o desenvolvimento
- Melhora estimativas de tempo
- Facilita colaboração em equipe

## 2. Princípio da Arquitetura Modular e Responsabilidade Única

### **Regra Fundamental:**
Todo código deve seguir o Princípio da Responsabilidade Única, sendo organizado em componentes modulares, auto-contidos e com propósito bem definido.

### **Limite Prático de Código:**
- **Limite Máximo:** Nenhum arquivo de código-fonte deve exceder **300 linhas de código**
- **Limite Recomendado:** Manter arquivos entre 50-200 linhas quando possível
- **Exceções:** Arquivos de configuração, schemas de banco de dados e arquivos gerados automaticamente

### **Critérios de Modularidade:**

#### **Para Componentes React:**
```typescript
// ✅ BOM: Componente com responsabilidade única
const UserCard = ({ user, onEdit }) => {
  return (
    <div className="user-card">
      <UserAvatar src={user.avatar} />
      <UserInfo name={user.name} email={user.email} />
      <UserActions onEdit={onEdit} />
    </div>
  );
};

// ❌ RUIM: Componente fazendo muitas coisas
const UserDashboard = () => {
  // 50+ linhas de lógica de estado
  // 100+ linhas de JSX
  // Múltiplas responsabilidades misturadas
};
```

#### **Para Funções e Classes:**
```typescript
// ✅ BOM: Função com propósito único
const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

// ✅ BOM: Classe com responsabilidade única
class EmailValidator {
  private static readonly EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  
  static validate(email: string): boolean {
    return this.EMAIL_REGEX.test(email);
  }
}

// ❌ RUIM: Classe fazendo muitas coisas
class UserManager {
  validateEmail() { /* ... */ }
  sendEmail() { /* ... */ }
  saveToDatabase() { /* ... */ }
  generateReport() { /* ... */ }
  // Múltiplas responsabilidades
}
```

### **Processo de Refatoração Obrigatória:**

Quando um arquivo exceder 300 linhas durante o desenvolvimento:

1. **Identificação Automática:** Monitorar tamanho dos arquivos durante desenvolvimento
2. **Análise de Responsabilidades:** Identificar diferentes responsabilidades no código
3. **Planejamento da Divisão:** Definir como separar em módulos menores
4. **Refatoração Imediata:** Não prosseguir com novas funcionalidades até refatorar
5. **Validação:** Garantir que a funcionalidade permanece intacta após divisão

### **Estratégias de Modularização:**

#### **Separação por Responsabilidade:**
```
// Antes: components/UserDashboard.tsx (400 linhas)
// Depois:
components/
├── UserDashboard/
│   ├── index.tsx (50 linhas - orquestração)
│   ├── UserProfile.tsx (80 linhas)
│   ├── UserStats.tsx (60 linhas)
│   ├── UserActions.tsx (70 linhas)
│   └── hooks/
│       ├── useUserData.ts (40 linhas)
│       └── useUserStats.ts (35 linhas)
```

#### **Separação por Camadas:**
```
// Antes: services/userService.ts (350 linhas)
// Depois:
services/user/
├── index.ts (20 linhas - exports)
├── userApi.ts (80 linhas - API calls)
├── userValidation.ts (60 linhas - validações)
├── userTransforms.ts (70 linhas - transformações)
└── userCache.ts (50 linhas - cache)
```

### **Indicadores de Qualidade Modular:**
- **Alta Coesão:** Elementos dentro do módulo trabalham juntos para um objetivo comum
- **Baixo Acoplamento:** Módulos dependem minimamente uns dos outros
- **Interface Clara:** Exports bem definidos e documentados
- **Testabilidade:** Cada módulo pode ser testado independentemente
- **Reutilização:** Módulos podem ser reutilizados em diferentes contextos

### **Ferramentas de Monitoramento:**
- Usar linters para alertar sobre arquivos grandes
- Implementar pre-commit hooks para verificar tamanho de arquivos
- Incluir métricas de complexidade em code reviews
- Monitorar métricas de acoplamento entre módulos

## 3. Aplicação Prática dos Princípios

### **Durante o Desenvolvimento:**
1. **Antes de Codificar:** Sempre decompor tarefas grandes
2. **Durante a Codificação:** Monitorar tamanho dos arquivos
3. **Ao Atingir 250 linhas:** Planejar refatoração
4. **Ao Atingir 300 linhas:** Parar e refatorar imediatamente
5. **Após Refatoração:** Validar funcionalidade e testes

### **Durante Code Review:**
- Verificar se tarefas grandes foram adequadamente decompostas
- Validar que arquivos respeitam o limite de 300 linhas
- Confirmar que cada módulo tem responsabilidade única
- Avaliar qualidade da modularização proposta

### **Exceções Controladas:**
Em casos excepcionais onde o limite de 300 linhas não pode ser respeitado:
1. **Documentar Justificativa:** Explicar por que a exceção é necessária
2. **Aprovação Explícita:** Obter aprovação em code review
3. **Plano de Refatoração:** Definir quando e como será refatorado
4. **Monitoramento:** Acompanhar para evitar crescimento adicional

---

*Estes princípios são fundamentais para manter a qualidade e sustentabilidade do código. Sua aplicação consistente resulta em sistemas mais robustos, manuteníveis e escaláveis.*
