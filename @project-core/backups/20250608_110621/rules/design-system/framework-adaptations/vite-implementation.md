# ⚡ VITE IMPLEMENTATION - GRUPO US DESIGN SYSTEM

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: AegisWallet implementation  

## 📋 OVERVIEW

Guia específico para implementação do GRUPO US Design System em projetos Vite + React, consolidado a partir da implementação bem-sucedida no AegisWallet.

## 🚀 PROJECT SETUP

### **Vite Configuration**
```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  css: {
    postcss: './postcss.config.js',
  },
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          ui: ['lucide-react', 'class-variance-authority'],
        },
      },
    },
  },
  server: {
    port: 3000,
    open: true,
  },
});
```

### **TypeScript Configuration**
```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
```

## 🎨 STYLING SETUP

### **Tailwind CSS Configuration**
```javascript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // GRUPO US Color Palette - PANTONE Specification
        "primary-dark": {
          DEFAULT: "#112031",
          dark: "#0A1520",
        },
        "primary-blue": {
          DEFAULT: "#294359",
          dark: "#1E3A4F",
        },
        "accent-gold": {
          DEFAULT: "#AC9469",
          dark: "#C4A876",
        },
        "neutral-light": {
          DEFAULT: "#B4AC9C",
          dark: "#8A8275",
        },
        "neutral-extralight": {
          DEFAULT: "#D2D0C8",
          dark: "#3A3832",
        },
        // Semantic Colors
        "text-primary": "var(--text-primary)",
        "text-secondary": "var(--text-secondary)",
        "text-muted": "var(--text-muted)",
        background: "var(--background)",
        surface: "var(--surface)",
      },
      fontFamily: {
        heading: ["Optima", "serif"],
        body: ["Inter", "sans-serif"],
        sans: ["Inter", "sans-serif"],
        serif: ["Optima", "serif"],
      },
      fontSize: {
        "responsive-h1": ["clamp(2rem, 5vw, 3.5rem)", { lineHeight: "1.1" }],
        "responsive-h2": ["clamp(1.5rem, 4vw, 2.5rem)", { lineHeight: "1.2" }],
        "responsive-h3": ["clamp(1.25rem, 3vw, 1.875rem)", { lineHeight: "1.3" }],
      },
      animation: {
        "theme-transition": "theme-transition 0.3s ease-in-out",
        "neon-pulse": "neon-pulse 2s ease-in-out infinite alternate",
      },
      keyframes: {
        "theme-transition": {
          "0%": { opacity: "0.8" },
          "100%": { opacity: "1" },
        },
        "neon-pulse": {
          "0%": { filter: "drop-shadow(0 0 8px rgba(172, 148, 105, 0.7))" },
          "100%": { filter: "drop-shadow(0 0 16px rgba(172, 148, 105, 1))" },
        },
      },
      dropShadow: {
        "gold-neon": "0 0 8px rgba(172, 148, 105, 0.7)",
        "gold-neon-strong": "0 0 16px rgba(172, 148, 105, 1)",
      },
    },
  },
  plugins: [],
}
```

### **Global Styles**
```css
/* src/index.css */
/* GRUPO US Design System - Vite Implementation */
@import url("https://fonts.googleapis.com/css2?family=Optima:wght@400;700;900&display=swap");
@import url("https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;700&display=swap");

@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  /* Light Mode Colors - GRUPO US PANTONE Specification */
  --text-primary: #112031;
  --text-secondary: #294359;
  --text-muted: #b4ac9c;
  --background: #ffffff;
  --surface: #f8f9fa;
}

.dark {
  /* Dark Mode Colors - GRUPO US PANTONE Specification */
  --text-primary: #f5f5f5;
  --text-secondary: #d2d0c8;
  --text-muted: #8a8275;
  --background: #0f0f0f;
  --surface: #1a1a1a;
}

/* Smooth transitions for theme switching */
* {
  transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
}

body {
  margin: 0;
  color: var(--text-primary);
  background: var(--background);
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-feature-settings: "rlig" 1, "calt" 1;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* GRUPO US Utility Classes */
@layer utilities {
  .text-gold-neon {
    @apply text-accent-gold drop-shadow-gold-neon;
  }

  .text-gold-neon-strong {
    @apply text-accent-gold drop-shadow-gold-neon-strong;
  }

  .btn-gold-neon {
    @apply bg-accent-gold text-primary-dark shadow-lg;
    box-shadow: 0 0 20px rgba(172, 148, 105, 0.3);
  }

  .btn-gold-neon:hover {
    box-shadow: 0 0 30px rgba(172, 148, 105, 0.5);
    transform: translateY(-1px);
  }
}

/* Component Base Classes */
@layer components {
  .heading-optima {
    font-family: 'Optima', serif;
    font-weight: 700;
    color: var(--text-primary);
  }

  .text-inter {
    font-family: 'Inter', sans-serif;
    color: var(--text-primary);
  }

  .card-surface {
    background: var(--surface);
    border: 1px solid #B4AC9C;
    border-radius: 0.5rem;
    padding: 2rem;
    transition: all 0.3s ease;
  }
}
```

## 🎭 THEME IMPLEMENTATION

### **Theme Context**
```typescript
// src/contexts/ThemeContext.tsx
import { createContext, useContext, useEffect, useState, ReactNode } from 'react';

type Theme = 'dark' | 'light' | 'system';

interface ThemeContextType {
  theme: Theme;
  setTheme: (theme: Theme) => void;
  resolvedTheme: 'dark' | 'light';
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<Theme>(() => {
    const stored = localStorage.getItem('theme') as Theme;
    return stored || 'dark';
  });

  const [resolvedTheme, setResolvedTheme] = useState<'dark' | 'light'>('dark');

  useEffect(() => {
    const root = window.document.documentElement;
    
    if (theme === 'system') {
      const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
      setResolvedTheme(systemTheme);
      root.classList.remove('light', 'dark');
      root.classList.add(systemTheme);
    } else {
      setResolvedTheme(theme);
      root.classList.remove('light', 'dark');
      root.classList.add(theme);
    }
    
    localStorage.setItem('theme', theme);
  }, [theme]);

  // Listen for system theme changes
  useEffect(() => {
    if (theme === 'system') {
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
      const handler = (e: MediaQueryListEvent) => {
        const systemTheme = e.matches ? 'dark' : 'light';
        setResolvedTheme(systemTheme);
        document.documentElement.classList.remove('light', 'dark');
        document.documentElement.classList.add(systemTheme);
      };

      mediaQuery.addEventListener('change', handler);
      return () => mediaQuery.removeEventListener('change', handler);
    }
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ theme, setTheme, resolvedTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
}
```

### **App Integration**
```typescript
// src/App.tsx
import { ThemeProvider } from '@/contexts/ThemeContext';
import { ThemeToggle } from '@/components/ThemeToggle';
import './index.css';

function App() {
  return (
    <ThemeProvider>
      <div className="min-h-screen bg-background text-text-primary">
        <ThemeToggle />
        {/* Your app content */}
      </div>
    </ThemeProvider>
  );
}

export default App;
```

## 🧩 COMPONENT IMPLEMENTATION

### **Button Component**
```typescript
// src/components/ui/Button.tsx
import { forwardRef, ButtonHTMLAttributes } from 'react';
import { cn } from '@/lib/utils';
import { cva, type VariantProps } from 'class-variance-authority';

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md text-sm font-medium transition-all duration-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent-gold disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-accent-gold text-primary-dark hover:bg-accent-gold/90 btn-gold-neon",
        secondary: "bg-transparent border border-accent-gold text-accent-gold hover:bg-accent-gold hover:text-primary-dark",
        outline: "border border-neutral-light bg-transparent hover:bg-surface",
        ghost: "hover:bg-surface hover:text-text-primary",
        destructive: "bg-red-500 text-white hover:bg-red-600",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
);

export interface ButtonProps
  extends ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);
Button.displayName = "Button";

export { Button, buttonVariants };
```

## 📦 PACKAGE DEPENDENCIES

### **Required Dependencies**
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "lucide-react": "^0.263.1",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.15",
    "@types/react-dom": "^18.2.7",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "@vitejs/plugin-react": "^4.0.3",
    "autoprefixer": "^10.4.14",
    "eslint": "^8.45.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.3",
    "postcss": "^8.4.27",
    "tailwindcss": "^3.3.0",
    "typescript": "^5.0.2",
    "vite": "^4.4.5"
  }
}
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
