# 📚 MULTI-PROJECT OPTIMIZATION PLAYBOOK

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO, AegisWallet, Harmoniza-Facil-Agendas optimizations  

## 📋 OVERVIEW

Guia completo passo-a-passo para otimização de projetos seguindo os padrões GRUPO US VIBECODE SYSTEM V2.0, consolidado a partir das implementações bem-sucedidas nos 3 projetos.

## 🎯 OPTIMIZATION PHASES

### **PHASE 1: PRE-OPTIMIZATION ANALYSIS**

#### **1.1 Project Assessment**
```bash
# Workspace verification
Get-Location
Test-Path "memory-bank" && Test-Path "project-core"

# Project structure analysis
tree /f > project_structure_before.txt

# Dependency audit
npm audit
npm ls --depth=0
```

#### **1.2 Performance Baseline**
```bash
# Build analysis
npm run build
npm run analyze  # if available

# Bundle size check
du -sh dist/ || du -sh .next/

# Performance metrics
lighthouse --output=json --output-path=./lighthouse-before.json
```

#### **1.3 Code Quality Assessment**
```bash
# ESLint analysis
npx eslint . --ext .ts,.tsx,.js,.jsx --format=json > eslint-report.json

# TypeScript check
npx tsc --noEmit

# Test coverage
npm run test:coverage
```

### **PHASE 2: HORIZON UI PRO INTEGRATION**

#### **2.1 Figma Analysis**
```bash
# Figma MCP integration
figma-mcp analyze --project-id=horizon-ui-pro
figma-mcp extract-components --output=./figma-components.json
```

#### **2.2 Design System Implementation**
```typescript
// 1. Install design system dependencies
npm install @radix-ui/react-* lucide-react class-variance-authority

// 2. Configure Tailwind with GRUPO US colors
// tailwind.config.ts
const config = {
  theme: {
    extend: {
      colors: {
        "primary-dark": "#112031",
        "primary-blue": "#294359", 
        "accent-gold": "#AC9469",
        "neutral-light": "#B4AC9C",
        "neutral-extralight": "#D2D0C8",
      }
    }
  }
}

// 3. Implement theme system
// providers.tsx
export function Providers({ children }) {
  return (
    <ThemeProvider attribute="class" defaultTheme="dark">
      {children}
    </ThemeProvider>
  );
}
```

#### **2.3 Component Migration**
```bash
# Create component library structure
mkdir -p src/components/ui
mkdir -p src/components/layout
mkdir -p src/components/forms

# Generate base components
npx shadcn-ui@latest add button card input
```

### **PHASE 3: STRUCTURE OPTIMIZATION**

#### **3.1 Directory Restructuring**
```bash
# Standard GRUPO US structure
src/
├── app/                 # Next.js App Router
├── components/
│   ├── ui/             # Base UI components
│   ├── layout/         # Layout components
│   └── forms/          # Form components
├── lib/                # Utilities
├── hooks/              # Custom hooks
├── types/              # TypeScript types
├── styles/             # Global styles
└── utils/              # Helper functions
```

#### **3.2 Configuration Optimization**
```typescript
// next.config.ts / vite.config.ts optimization
const config = {
  experimental: {
    turbo: true,
    optimizeCss: true,
  },
  images: {
    formats: ['image/webp', 'image/avif'],
  },
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },
};
```

### **PHASE 4: FEATURE ENHANCEMENT**

#### **4.1 Dark/Light Theme Implementation**
```typescript
// 1. Theme toggle component
export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  
  return (
    <button
      onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
      className="fixed top-4 left-4 z-50 p-2 rounded-lg bg-surface"
    >
      {theme === "dark" ? <Sun /> : <Moon />}
    </button>
  );
}

// 2. CSS custom properties
:root {
  --text-primary: #112031;
  --background: #ffffff;
}

.dark {
  --text-primary: #f5f5f5;
  --background: #0f0f0f;
}
```

#### **4.2 Accessibility Implementation**
```typescript
// WCAG AA compliance
const accessibilityFeatures = {
  contrast: "4.5:1 minimum",
  focusManagement: "visible focus indicators",
  keyboardNavigation: "full keyboard support",
  screenReader: "proper ARIA labels",
  reducedMotion: "respects user preferences"
};
```

### **PHASE 5: PERFORMANCE & TESTING**

#### **5.1 Performance Optimization**
```bash
# Bundle analysis
npm run build:analyze

# Image optimization
npx @next/codemod new-link .
npx @next/codemod next-image .

# Code splitting
# Implement dynamic imports for heavy components
const HeavyComponent = lazy(() => import('./HeavyComponent'));
```

#### **5.2 Testing Infrastructure**
```bash
# Install testing dependencies
npm install -D jest @testing-library/react @testing-library/jest-dom
npm install -D playwright @playwright/test

# Configure Jest
# jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};

# Configure Playwright
# playwright.config.ts
export default defineConfig({
  testDir: './tests/e2e',
  use: {
    baseURL: 'http://localhost:3000',
  },
});
```

### **PHASE 6: VALIDATION & DEPLOYMENT**

#### **6.1 Quality Validation**
```bash
# Build validation
npm run build
npm run lint
npm run type-check

# Test validation
npm run test
npm run test:e2e

# Performance validation
lighthouse --output=json --output-path=./lighthouse-after.json
```

#### **6.2 Deployment Preparation**
```bash
# Environment setup
cp .env.example .env.local

# Deployment configuration
# vercel.json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "framework": "nextjs"
}
```

## 🔧 AUTOMATION SCRIPTS

### **Optimization Script**
```bash
#!/bin/bash
# optimize-project.sh

echo "🚀 Starting GRUPO US Project Optimization..."

# Phase 1: Analysis
echo "📊 Phase 1: Analysis"
npm audit
npm run build

# Phase 2: Dependencies
echo "📦 Phase 2: Dependencies"
npm install @radix-ui/react-slot lucide-react class-variance-authority
npm install -D @types/node

# Phase 3: Structure
echo "🏗️ Phase 3: Structure"
mkdir -p src/components/ui src/lib src/hooks

# Phase 4: Configuration
echo "⚙️ Phase 4: Configuration"
cp project-core/rules/design-system/tailwind.config.example.ts ./tailwind.config.ts

# Phase 5: Validation
echo "✅ Phase 5: Validation"
npm run build
npm run lint

echo "🎉 Optimization Complete!"
```

## 📊 SUCCESS METRICS

### **Performance Targets**
```yaml
Build Time: < 30s
Bundle Size: < 150KB (gzipped)
First Load JS: < 100KB
Lighthouse Score: > 90
TypeScript Errors: 0
ESLint Warnings: 0
Test Coverage: > 80%
```

### **Quality Checklist**
```markdown
## Optimization Checklist

### Design System
- [ ] GRUPO US colors implemented
- [ ] Typography system configured
- [ ] Component library created
- [ ] Dark/light theme working
- [ ] Neon gold effects implemented

### Performance
- [ ] Bundle optimized
- [ ] Images optimized
- [ ] Code splitting implemented
- [ ] Lazy loading configured
- [ ] Performance budget met

### Accessibility
- [ ] WCAG AA compliance
- [ ] Keyboard navigation
- [ ] Screen reader support
- [ ] Focus management
- [ ] Reduced motion support

### Testing
- [ ] Unit tests passing
- [ ] E2E tests configured
- [ ] Accessibility tests
- [ ] Performance tests
- [ ] Cross-browser testing

### Deployment
- [ ] Build successful
- [ ] Environment configured
- [ ] CI/CD pipeline
- [ ] Monitoring setup
- [ ] Documentation updated
```

## 🔄 CONTINUOUS IMPROVEMENT

### **Post-Optimization Monitoring**
```typescript
// Performance monitoring
const performanceMetrics = {
  buildTime: "< 30s",
  bundleSize: "< 150KB",
  lighthouse: "> 90",
  errorRate: "< 1%",
  userSatisfaction: "> 9/10"
};

// Quality metrics
const qualityMetrics = {
  testCoverage: "> 80%",
  typeScriptErrors: 0,
  eslintWarnings: 0,
  accessibilityScore: "100%",
  performanceScore: "> 90"
};
```

### **Feedback Loop**
```bash
# Weekly optimization review
npm run analyze
npm run test:coverage
lighthouse --output=json

# Monthly dependency updates
npm audit
npm update
npm run test
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
