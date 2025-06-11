# 📋 TEMPLATES UNIFIED - GRUPO US VIBECODE SYSTEM V4.0

## 📋 CONSOLIDATION NOTICE

**This file consolidates and replaces:**
- `templates/clinerules-caller.md`
- `templates/cursor-rules-caller.mdc`
- `templates/project-rule-caller.md`

**Consolidation Date**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)

---

## 🎯 UNIVERSAL PROJECT RULE CALLER

### **Master Rule Integration Template**
```markdown
# PROJECT RULE INTEGRATION - GRUPO US VIBECODE SYSTEM V4.0

## 🚀 SYSTEM ACTIVATION

### Step 1: Load Master Orchestrator
@import @project-core/memory/master_rule.md

### Step 2: Load Core Principles
@import @project-core/rules/01-core-principles-unified.md

### Step 3: Load Coding Standards
@import @project-core/rules/02-coding-standards-universal.md

### Step 4: Load AI Routing System
@import @project-core/rules/04-ai-routing-system.md

### Step 5: Load Design System
@import @project-core/rules/05-design-system-unified.md

### Step 6: Load MCP Integration
@import @project-core/rules/06-mcp-integration-core.md

### Step 7: Load Error Protocols
@import @project-core/rules/07-error-protocols-unified.md

## 🧠 MEMORY BANK CONSULTATION
@import @project-core/memory/self_correction_log.md
@import @project-core/memory/global-standards.md

## 🎯 PROJECT-SPECIFIC OVERRIDES
@import @project-core/rules/project-overrides/[project-name].md
```

---

## 🛠️ AUGMENT CODE INTEGRATION TEMPLATE

### **Augment-Specific Configuration**
```markdown
# AUGMENT CODE OPTIMIZATION TEMPLATE

## 📚 Documentation Integration
- **Source**: https://docs.augmentcode.com/introduction
- **Guidelines**: @project-core/memory/augment-optimization-guide.md
- **Configuration**: .augmentignore and .augment-guidelines

## ⚡ Essential Shortcuts
- **Chat**: `Cmd/Ctrl + L` - Conversar com codebase
- **Next Edit**: `Cmd/Ctrl + ;` - Sugestões passo a passo
- **Instructions**: `Cmd/Ctrl + I` - Modificar código com linguagem natural
- **Completions**: `Tab` - Aceitar sugestões

## 🎯 Workflow Integration
- **TaskMaster + Augment**: Use Chat para explicar tasks complexas
- **Sequential Thinking + Next Edit**: Fluxo otimizado para refatorações
- **Memory Bank + Guidelines**: Aprendizados integrados ao Augment
```

---

## 🤖 CURSOR IDE INTEGRATION TEMPLATE

### **Cursor-Specific Rules**
```markdown
# CURSOR IDE OPTIMIZATION TEMPLATE

## 🎯 Cursor Configuration
- **AI Model**: Claude Sonnet 4 (primary)
- **Fallback**: Gemini 2.5 Pro
- **Context Window**: Optimized for large codebases
- **Auto-completion**: Enhanced with project context

## 📋 Cursor Rules Integration
@import @project-core/rules/01-core-principles-unified.md
@import @project-core/rules/02-coding-standards-universal.md
@import @project-core/rules/05-design-system-unified.md

## 🔧 Cursor-Specific Commands
- **Cmd+K**: AI chat for code generation
- **Cmd+L**: AI chat for explanations
- **Cmd+I**: Inline AI editing
- **Tab**: Accept AI suggestions
```

---

## 🎨 COMPONENT TEMPLATE SYSTEM

### **React Component Template**
```typescript
// Universal React Component Template
import React from 'react'
import { cn } from '@/lib/utils'

interface ComponentNameProps {
  children?: React.ReactNode
  className?: string
  variant?: 'primary' | 'secondary' | 'outline'
  size?: 'sm' | 'md' | 'lg'
}

const ComponentName: React.FC<ComponentNameProps> = ({
  children,
  className,
  variant = 'primary',
  size = 'md',
  ...props
}) => {
  const baseClasses = 'inline-flex items-center justify-center rounded-md font-medium transition-colors'
  
  const variantClasses = {
    primary: 'bg-accent-gold text-primary-dark hover:bg-accent-gold/90',
    secondary: 'bg-primary-blue text-white hover:bg-primary-blue/90',
    outline: 'border border-neutral-light bg-transparent hover:bg-neutral-extralight'
  }
  
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  }

  return (
    <div
      className={cn(baseClasses, variantClasses[variant], sizeClasses[size], className)}
      {...props}
    >
      {children}
    </div>
  )
}

export default ComponentName
```

### **API Route Template**
```typescript
// Universal API Route Template (Next.js)
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'

// Request validation schema
const RequestSchema = z.object({
  // Define your schema here
})

export async function GET(request: NextRequest) {
  try {
    // Implementation
    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('API Error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    const validatedData = RequestSchema.parse(body)
    
    // Implementation
    
    return NextResponse.json({ success: true, data: validatedData })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', details: error.errors },
        { status: 400 }
      )
    }
    
    console.error('API Error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}
```

### **Database Schema Template**
```sql
-- Universal Database Schema Template
CREATE TABLE IF NOT EXISTS table_name (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Add your columns here
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  
  -- Indexes
  CONSTRAINT table_name_email_unique UNIQUE (email)
);

-- Row Level Security (RLS)
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own data" ON table_name
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own data" ON table_name
  FOR UPDATE USING (auth.uid() = user_id);
```

---

## 🔧 CONFIGURATION TEMPLATES

### **TypeScript Config Template**
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "ES6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/types/*": ["./src/types/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### **Tailwind Config Template**
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: ["class"],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
  ],
  prefix: "",
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        // GRUPO US Color Palette
        'primary-dark': '#1a1a1a',
        'primary-blue': '#2563eb',
        'accent-gold': '#ac9469',
        'neutral-light': '#f5f5f5',
        'neutral-extralight': '#fafafa',
      },
      keyframes: {
        "neon-pulse": {
          "0%, 100%": { opacity: 1 },
          "50%": { opacity: 0.7 },
        },
      },
      animation: {
        "neon-pulse": "neon-pulse 2s ease-in-out infinite alternate",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
}
```

---

**Consolidation Complete**: This file unifies all project templates
**Performance**: 3 files → 1 file (67% reduction)
**Functionality**: 100% preserved with enhanced universality
**Last Updated**: 2025-06-11T12:47:51Z
**Version**: 4.0.0 (Unified)
**Next Review**: 2025-07-11
