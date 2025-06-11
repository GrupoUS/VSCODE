# ⚡ NEXT.JS IMPLEMENTATION - GRUPO US DESIGN SYSTEM

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO, Harmoniza-Facil-Agendas implementations

## 📋 OVERVIEW

Guia específico para implementação do GRUPO US Design System em projetos Next.js, consolidado a partir das implementações bem-sucedidas no NEONPRO e Harmoniza-Facil-Agendas.

## 🚀 PROJECT SETUP

### **Next.js Configuration**

```typescript
// next.config.ts
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  experimental: {
    turbo: {
      rules: {
        "*.svg": {
          loaders: ["@svgr/webpack"],
          as: "*.js",
        },
      },
    },
  },
  images: {
    domains: ["localhost"],
  },
};

export default nextConfig;
```

### **TypeScript Configuration**

```json
// tsconfig.json
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "es6"],
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
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

## 🎨 STYLING SETUP

### **Tailwind CSS Configuration**

```typescript
// tailwind.config.ts
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  darkMode: "class",
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
        "responsive-h3": [
          "clamp(1.25rem, 3vw, 1.875rem)",
          { lineHeight: "1.3" },
        ],
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
};

export default config;
```

### **Global Styles**

```css
/* src/app/globals.css */
/* GRUPO US Design System - Next.js Implementation */
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
  transition: background-color 0.3s ease, color 0.3s ease,
    border-color 0.3s ease;
}

body {
  color: var(--text-primary);
  background: var(--background);
  font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
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
    font-family: "Optima", serif;
    font-weight: 700;
    color: var(--text-primary);
  }

  .text-inter {
    font-family: "Inter", sans-serif;
    color: var(--text-primary);
  }

  .card-surface {
    background: var(--surface);
    border: 1px solid #b4ac9c;
    border-radius: 0.5rem;
    padding: 2rem;
    transition: all 0.3s ease;
  }
}
```

## 🎭 THEME IMPLEMENTATION

### **Theme Provider Setup**

```typescript
// src/components/providers.tsx
"use client";

import { ThemeProvider } from "next-themes";

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <ThemeProvider
      attribute="class"
      defaultTheme="dark"
      enableSystem={false}
      disableTransitionOnChange={false}
    >
      {children}
    </ThemeProvider>
  );
}
```

### **Layout Integration**

```typescript
// src/app/layout.tsx
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from "@/components/providers";
import { ThemeToggle } from "@/components/theme-toggle";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

export const metadata: Metadata = {
  title: "GRUPO US Project",
  description: "GRUPO US VIBECODE SYSTEM V2.0",
  viewport: "width=device-width, initial-scale=1",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR" suppressHydrationWarning>
      <body className={`${inter.variable} font-sans antialiased`}>
        <Providers>
          <ThemeToggle />
          {children}
        </Providers>
      </body>
    </html>
  );
}
```

## 🧩 COMPONENT IMPLEMENTATION

### **Button Component**

```typescript
// src/components/ui/button.tsx
import * as React from "react";
import { cn } from "@/lib/utils";
import { cva, type VariantProps } from "class-variance-authority";

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md text-sm font-medium transition-all duration-300 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent-gold disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default:
          "bg-accent-gold text-primary-dark hover:bg-accent-gold/90 btn-gold-neon",
        secondary:
          "bg-transparent border border-accent-gold text-accent-gold hover:bg-accent-gold hover:text-primary-dark",
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
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
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
    "next": "^15.3.3",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "next-themes": "^0.2.1",
    "lucide-react": "^0.263.1",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "eslint": "^8",
    "eslint-config-next": "15.3.3",
    "postcss": "^8",
    "tailwindcss": "^3.4.1",
    "typescript": "^5"
  }
}
```

## 🧪 TESTING SETUP

### **Jest Configuration**

```javascript
// jest.config.js
const nextJest = require("next/jest");

const createJestConfig = nextJest({
  dir: "./",
});

const customJestConfig = {
  setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],
  testEnvironment: "jsdom",
  moduleNameMapping: {
    "^@/(.*)$": "<rootDir>/src/$1",
  },
};

module.exports = createJestConfig(customJestConfig);
```

## 🚀 DEPLOYMENT

### **Vercel Deployment**

```json
// vercel.json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "framework": "nextjs",
  "regions": ["gru1"]
}
```

### **Environment Variables**

```bash
# .env.local
NEXT_PUBLIC_APP_URL=https://your-app.vercel.app
NEXT_PUBLIC_ANALYTICS_ID=your-analytics-id
```

## 📊 PERFORMANCE OPTIMIZATION

### **Next.js Specific Optimizations**

```typescript
// next.config.ts optimizations
const nextConfig: NextConfig = {
  compiler: {
    removeConsole: process.env.NODE_ENV === "production",
  },
  experimental: {
    optimizeCss: true,
    turbo: true,
  },
  images: {
    formats: ["image/webp", "image/avif"],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
  },
};
```

### **Bundle Analysis**

```json
// package.json scripts
{
  "scripts": {
    "analyze": "ANALYZE=true npm run build",
    "build:analyze": "npm run build && npx @next/bundle-analyzer .next"
  }
}
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
