# 🔧 FRAMEWORK-SPECIFIC ADAPTATIONS

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO (Next.js), AegisWallet (Vite), Harmoniza-Facil-Agendas (Next.js) implementations  

## 📋 OVERVIEW

Guia detalhado das adaptações específicas necessárias para implementar o GRUPO US Design System em diferentes frameworks, consolidado a partir das experiências dos 3 projetos otimizados.

## ⚡ NEXT.JS ADAPTATIONS

### **App Router vs Pages Router**
```typescript
// App Router (Recommended - Next.js 13+)
// app/layout.tsx
import { Providers } from '@/components/providers';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR" suppressHydrationWarning>
      <body>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  );
}

// Pages Router (Legacy)
// pages/_app.tsx
import { AppProps } from 'next/app';
import { Providers } from '@/components/providers';

export default function App({ Component, pageProps }: AppProps) {
  return (
    <Providers>
      <Component {...pageProps} />
    </Providers>
  );
}
```

### **Server Components Considerations**
```typescript
// Server Component (default in App Router)
export default function ServerComponent() {
  return (
    <div className="bg-surface text-text-primary">
      {/* Static content */}
    </div>
  );
}

// Client Component (when needed)
"use client";
import { useTheme } from 'next-themes';

export default function ClientComponent() {
  const { theme, setTheme } = useTheme();
  
  return (
    <button onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}>
      Toggle Theme
    </button>
  );
}
```

### **Next.js Specific Optimizations**
```typescript
// next.config.ts
const nextConfig = {
  experimental: {
    turbo: true,
    optimizeCss: true,
  },
  images: {
    formats: ['image/webp', 'image/avif'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
  },
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },
};
```

## ⚡ VITE ADAPTATIONS

### **Build Configuration**
```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          ui: ['lucide-react', 'class-variance-authority'],
          theme: ['./src/contexts/ThemeContext'],
        },
      },
    },
    target: 'esnext',
    minify: 'terser',
  },
  css: {
    postcss: './postcss.config.js',
  },
});
```

### **Environment Variables**
```typescript
// Vite environment variables (VITE_ prefix required)
// .env
VITE_APP_TITLE=GRUPO US Project
VITE_API_URL=https://api.example.com

// Usage
const apiUrl = import.meta.env.VITE_API_URL;
```

### **Asset Handling**
```typescript
// Vite asset imports
import logoUrl from '@/assets/logo.svg';
import iconUrl from '@/assets/icon.png?url';
import inlineIcon from '@/assets/icon.svg?raw';

// Dynamic imports
const LazyComponent = lazy(() => import('@/components/LazyComponent'));
```

## 🎨 STYLING ADAPTATIONS

### **CSS-in-JS vs Utility-First**
```typescript
// Tailwind CSS (Recommended)
const Button = ({ variant = 'default' }) => (
  <button className={cn(
    "btn-base",
    variant === 'gold' && "btn-gold-neon",
    variant === 'secondary' && "btn-secondary"
  )}>
    Button
  </button>
);

// Styled Components (Alternative)
const StyledButton = styled.button<{ variant: string }>`
  ${({ variant }) => variant === 'gold' && css`
    background: var(--accent-gold);
    box-shadow: 0 0 20px rgba(172, 148, 105, 0.3);
  `}
`;
```

### **CSS Custom Properties Strategy**
```css
/* Universal approach (works in all frameworks) */
:root {
  --primary-dark: #112031;
  --accent-gold: #AC9469;
  --transition-duration: 300ms;
}

/* Framework-specific optimizations */
/* Next.js - globals.css */
@layer base {
  body {
    @apply bg-background text-text-primary;
  }
}

/* Vite - index.css */
body {
  background: var(--background);
  color: var(--text-primary);
}
```

## 🎭 THEME SYSTEM ADAPTATIONS

### **Next.js Theme Implementation**
```typescript
// Using next-themes
import { ThemeProvider } from 'next-themes';

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

### **Vite Theme Implementation**
```typescript
// Custom theme context
import { createContext, useContext, useEffect, useState } from 'react';

const ThemeContext = createContext<{
  theme: 'light' | 'dark';
  setTheme: (theme: 'light' | 'dark') => void;
} | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<'light' | 'dark'>(() => {
    return (localStorage.getItem('theme') as 'light' | 'dark') || 'dark';
  });

  useEffect(() => {
    document.documentElement.classList.remove('light', 'dark');
    document.documentElement.classList.add(theme);
    localStorage.setItem('theme', theme);
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}
```

## 📦 DEPENDENCY MANAGEMENT

### **Framework-Specific Dependencies**

#### **Next.js Dependencies**
```json
{
  "dependencies": {
    "next": "^15.3.3",
    "next-themes": "^0.2.1",
    "@next/font": "^15.3.3"
  },
  "devDependencies": {
    "@next/bundle-analyzer": "^15.3.3",
    "eslint-config-next": "^15.3.3"
  }
}
```

#### **Vite Dependencies**
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.3",
    "vite": "^4.4.5",
    "vite-bundle-analyzer": "^0.7.0"
  }
}
```

## 🧪 TESTING ADAPTATIONS

### **Next.js Testing Setup**
```javascript
// jest.config.js
const nextJest = require('next/jest');

const createJestConfig = nextJest({
  dir: './',
});

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jsdom',
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};

module.exports = createJestConfig(customJestConfig);
```

### **Vite Testing Setup**
```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
});
```

## 🚀 BUILD & DEPLOYMENT

### **Next.js Deployment**
```bash
# Vercel (Recommended)
npm run build
vercel --prod

# Docker
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

### **Vite Deployment**
```bash
# Static hosting (Netlify, Vercel)
npm run build
# Deploy dist/ folder

# Docker
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## 📊 PERFORMANCE CONSIDERATIONS

### **Bundle Size Optimization**

#### **Next.js**
```typescript
// Dynamic imports
const DynamicComponent = dynamic(() => import('@/components/Heavy'), {
  loading: () => <p>Loading...</p>,
  ssr: false,
});

// Bundle analysis
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
});
```

#### **Vite**
```typescript
// Code splitting
const routes = [
  {
    path: '/dashboard',
    component: lazy(() => import('@/pages/Dashboard')),
  },
];

// Bundle analysis
import { defineConfig } from 'vite';
import { analyzer } from 'vite-bundle-analyzer';

export default defineConfig({
  plugins: [
    analyzer({
      analyzerMode: 'server',
      openAnalyzer: true,
    }),
  ],
});
```

## 🔧 MIGRATION STRATEGIES

### **From Create React App to Vite**
```bash
# 1. Remove CRA dependencies
npm uninstall react-scripts

# 2. Install Vite
npm install -D vite @vitejs/plugin-react

# 3. Update scripts
# package.json
{
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  }
}

# 4. Create vite.config.ts
# 5. Move index.html to root
# 6. Update imports
```

### **From Pages Router to App Router**
```bash
# 1. Create app directory
mkdir app

# 2. Move pages to app directory
# pages/index.tsx -> app/page.tsx
# pages/_app.tsx -> app/layout.tsx

# 3. Update imports and exports
# 4. Test thoroughly
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
