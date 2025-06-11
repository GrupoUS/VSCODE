# 🏗️ MANDATORY PROJECT STRUCTURE - GRUPO US VIBECODE SYSTEM V2.0

## 📋 ENFORCEMENT PROTOCOL

This rule enforces the standardized project structure across ALL GRUPO US projects, effective immediately.

**Authority**: GRUPO US VIBECODE SYSTEM V2.0  
**Scope**: All new projects and refactored existing projects  
**Compliance**: MANDATORY  

---

## 🎯 STRUCTURE ENFORCEMENT RULES

### **RULE 1: MANDATORY DIRECTORIES**
Every GRUPO US project MUST include these directories:

```
✅ REQUIRED:
├── src/                    # Source code
│   ├── app/               # Next.js App Router
│   ├── components/        # React components
│   │   ├── ui/            # Base UI components
│   │   └── features/      # Feature components
│   ├── hooks/             # Custom hooks
│   ├── lib/               # Utilities and configs
│   ├── stores/            # State management
│   ├── types/             # TypeScript definitions
│   └── utils/             # Helper functions
├── Rules/                 # Centralized rules
│   ├── frameworks/        # Tech-specific rules
│   ├── mcp-integration/   # MCP protocols
│   └── project-specific/  # Project rules
├── docs/                  # Documentation
├── tests/                 # Testing structure
│   ├── e2e/              # End-to-end tests
│   └── unit/             # Unit tests
└── scripts/              # Project scripts
```

### **RULE 2: TECHNOLOGY STACK COMPLIANCE**
- **Frontend**: Next.js 14+ + TypeScript + Tailwind CSS + shadcn/ui
- **State**: Zustand for global state
- **Forms**: React Hook Form + Zod validation
- **Testing**: Jest (unit) + Playwright (E2E)
- **AI Tools**: TaskMaster integration for complexity ≥7/10

### **RULE 3: RULE CENTRALIZATION**
- ALL project rules MUST be stored in `Rules/` directory
- NO scattered `.clinerules`, `.cursor/rules` files
- Rules organized by category (frameworks, mcp-integration, project-specific)

### **RULE 4: NAMING CONVENTIONS**
- **Directories**: lowercase with hyphens (kebab-case)
- **Files**: camelCase for JS/TS, PascalCase for components
- **Components**: PascalCase with descriptive names
- **Hooks**: camelCase starting with "use"

---

## 🔧 IMPLEMENTATION REQUIREMENTS

### **NEW PROJECTS**
1. **MUST** use project structure template from `@project-core/docs/project-structure-template.md`
2. **MUST** initialize with required technology stack
3. **MUST** configure TaskMaster for projects with complexity ≥7/10
4. **MUST** pass structure validation before deployment

### **EXISTING PROJECTS**
1. **MUST** be refactored using `@project-core/docs/refactoring-playbook.md`
2. **MUST** undergo complexity assessment
3. **MUST** centralize all rules in `Rules/` directory
4. **MUST** validate structure compliance post-refactoring

---

## 📊 COMPLIANCE VALIDATION

### **AUTOMATED CHECKS**
```bash
# Structure validation
npm run validate:structure

# Rule centralization check
npm run validate:rules

# Build compliance
npm run build

# Test compliance
npm run test
```

### **MANUAL VERIFICATION**
- [ ] All mandatory directories present
- [ ] Technology stack matches requirements
- [ ] Rules centralized in `Rules/` directory
- [ ] Documentation complete in `docs/`
- [ ] Tests configured and passing

---

## 🚨 NON-COMPLIANCE CONSEQUENCES

### **PROJECT REJECTION**
Projects that do not comply with this structure will be:
- **Rejected** from production deployment
- **Flagged** for immediate refactoring
- **Blocked** from CI/CD pipeline

### **REFACTORING MANDATE**
Non-compliant projects MUST:
1. Stop all development work
2. Apply refactoring playbook immediately
3. Pass compliance validation
4. Resume development only after approval

---

## 🎯 EXCEPTIONS AND APPROVALS

### **EXCEPTION PROCESS**
Deviations from this structure require:
1. **Written justification** with technical reasoning
2. **Approval** from GRUPO US technical leadership
3. **Documentation** of alternative approach
4. **Validation** that alternative meets quality standards

### **LEGACY PROJECT GRACE PERIOD**
- **Deadline**: 30 days from rule implementation
- **Support**: Refactoring assistance available
- **Priority**: Critical projects first

---

## 📚 RESOURCES AND SUPPORT

### **DOCUMENTATION**
- **Template**: `@project-core/docs/project-structure-template.md`
- **Playbook**: `@project-core/docs/refactoring-playbook.md`
- **Guidelines**: `@project-core/rules/`

### **ASSISTANCE**
- **AI Support**: TaskMaster for complex refactoring
- **Technical Review**: Available upon request
- **Training**: Structure implementation workshops

---

## ✅ COMPLIANCE CERTIFICATION

Projects that successfully implement this structure receive:
- **Compliance Badge** in documentation
- **Priority Support** for deployment
- **Quality Assurance** certification
- **Best Practice** recognition

**This structure is non-negotiable for all GRUPO US VIBECODE SYSTEM V2.0 projects.**
