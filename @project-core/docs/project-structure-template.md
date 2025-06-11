# 🏗️ GRUPO US VIBECODE SYSTEM V2.0 - PROJECT STRUCTURE TEMPLATE

## 📋 OFFICIAL STANDARDIZED PROJECT STRUCTURE

This template defines the mandatory project structure for all GRUPO US projects, validated across **neonpro**, **aegiswallet**, and **harmoniza-facil-agendas**.

**Version**: 2.0  
**Last Updated**: 2025-06-06  
**Status**: MANDATORY for all new projects  

---

## 🎯 STANDARD DIRECTORY STRUCTURE

```
project-name/
├── src/                           # Source code (MANDATORY)
│   ├── app/                      # Next.js App Router pages
│   │   ├── (auth)/               # Route groups
│   │   ├── api/                  # API routes
│   │   ├── globals.css           # Global styles
│   │   ├── layout.tsx            # Root layout
│   │   └── page.tsx              # Home page
│   ├── components/               # React components (MANDATORY)
│   │   ├── ui/                   # Base UI components (shadcn/ui)
│   │   ├── features/             # Feature-specific components
│   │   ├── layout/               # Layout components
│   │   └── shared/               # Shared components
│   ├── hooks/                    # Custom React hooks (MANDATORY)
│   ├── lib/                      # Utilities and configurations (MANDATORY)
│   │   ├── utils.ts              # General utilities
│   │   ├── supabase/             # Supabase client configs
│   │   └── validations/          # Zod schemas
│   ├── stores/                   # State management (MANDATORY)
│   │   └── useStore.ts           # Zustand stores
│   ├── types/                    # TypeScript definitions (MANDATORY)
│   │   ├── database.ts           # Database types
│   │   └── global.ts             # Global types
│   └── utils/                    # Helper functions (MANDATORY)
├── Rules/                        # Centralized rules (MANDATORY)
│   ├── frameworks/               # Technology-specific rules
│   │   ├── cursor_rules.mdc      # Cursor IDE rules
│   │   ├── roo_rules.md          # Roo Code rules
│   │   └── dev_workflow.md       # Development workflow
│   ├── mcp-integration/          # MCP protocols
│   │   ├── taskmaster.md         # TaskMaster integration
│   │   └── config.json           # MCP configurations
│   └── project-specific/         # Project-unique rules
├── docs/                         # Documentation (MANDATORY)
│   ├── README.md                 # Project overview
│   ├── DEPLOYMENT.md             # Deployment guide
│   └── API.md                    # API documentation
├── tests/                        # Testing structure (MANDATORY)
│   ├── e2e/                      # End-to-end tests
│   │   └── playwright.config.ts  # Playwright configuration
│   └── unit/                     # Unit tests
│       └── jest.config.js        # Jest configuration
├── scripts/                      # Project scripts (MANDATORY)
│   ├── deploy.js                 # Deployment scripts
│   └── setup.js                  # Setup scripts
├── prisma/                       # Database schema (CONDITIONAL)
│   ├── schema.prisma             # Prisma schema
│   └── migrations/               # Database migrations
├── supabase/                     # Supabase configs (CONDITIONAL)
│   ├── config.toml               # Supabase configuration
│   └── migrations/               # Supabase migrations
├── public/                       # Static assets (MANDATORY)
│   ├── images/                   # Image assets
│   └── icons/                    # Icon assets
├── _toBeDeleted/                 # Cleanup staging (TEMPORARY)
├── .github/                      # GitHub workflows (MANDATORY)
│   └── workflows/                # CI/CD workflows
├── .cursor/                      # Cursor IDE config (MANDATORY)
│   ├── rules/                    # Cursor-specific rules
│   └── mcp.json                  # MCP configuration
├── .roo/                         # Roo Code config (MANDATORY)
│   └── rules/                    # Roo-specific rules
├── .taskmaster/                  # TaskMaster config (MANDATORY)
│   ├── config.json               # TaskMaster settings
│   └── tasks/                    # Task definitions
├── package.json                  # Dependencies (MANDATORY)
├── next.config.ts                # Next.js configuration
├── tailwind.config.ts            # Tailwind CSS config
├── tsconfig.json                 # TypeScript config
├── eslint.config.js              # ESLint configuration
├── postcss.config.js             # PostCSS configuration
├── components.json               # shadcn/ui config
├── .env.example                  # Environment template
├── .gitignore                    # Git ignore rules
└── README.md                     # Project documentation
```

---

## 🔧 TECHNOLOGY STACK REQUIREMENTS

### **Frontend (MANDATORY)**
- **Next.js 14+** with App Router
- **TypeScript** in strict mode
- **Tailwind CSS** + **shadcn/ui** components
- **React Hook Form** + **Zod** validation
- **Zustand** for state management
- **React Query** for data fetching

### **Backend (CONDITIONAL)**
- **Supabase** (PostgreSQL + Auth + Storage) OR
- **Node.js** + **Express/Fastify** + **Prisma ORM**
- **Redis** for caching (when needed)

### **Development Tools (MANDATORY)**
- **ESLint** + **Prettier** for code quality
- **Jest** for unit testing
- **Playwright** for E2E testing
- **TaskMaster AI** for task management

---

## 📊 COMPLEXITY ASSESSMENT CRITERIA

### **Simple Projects (Complexity 1-3)**
- Basic CRUD operations
- Single user type
- Minimal integrations
- **Structure**: Core directories only

### **Medium Projects (Complexity 4-6)**
- Multiple user roles
- External API integrations
- Basic real-time features
- **Structure**: Full template structure

### **Complex Projects (Complexity 7-10)**
- Multi-tenant architecture
- Advanced real-time features
- Complex business logic
- **Structure**: Full template + custom extensions

---

## 🚀 IMPLEMENTATION GUIDELINES

### **New Project Setup**
1. Copy this template structure
2. Install dependencies: `npm create next-app@latest --typescript --tailwind --eslint`
3. Add shadcn/ui: `npx shadcn-ui@latest init`
4. Initialize TaskMaster: `task-master init --yes`
5. Configure MCP integrations

### **Existing Project Migration**
1. Follow the 5-phase refactoring protocol
2. Assess complexity for TaskMaster decision
3. Apply structure incrementally
4. Validate with build and tests

---

## ✅ VALIDATION CHECKLIST

- [ ] All MANDATORY directories created
- [ ] Technology stack matches requirements
- [ ] Rules centralized in `Rules/` directory
- [ ] Tests configured and passing
- [ ] Documentation complete
- [ ] MCP integrations functional
- [ ] Build process successful
- [ ] Deployment ready

---

## 📚 REFERENCES

- **Refactoring Playbook**: `@project-core/docs/refactoring-playbook.md`
- **GRUPO US Guidelines**: `@project-core/rules/`
- **MCP Integration**: `@project-core/rules/mcp-integration/`

**This template is the official standard for all GRUPO US VIBECODE SYSTEM V2.0 projects.**
