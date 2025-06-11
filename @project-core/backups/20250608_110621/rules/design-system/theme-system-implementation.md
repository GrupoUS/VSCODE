# 🌓 GRUPO US THEME SYSTEM IMPLEMENTATION

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO, AegisWallet, Harmoniza-Facil-Agendas implementations  

## 📋 OVERVIEW

Sistema de temas universal do GRUPO US, consolidado a partir das implementações bem-sucedidas nos 3 projetos otimizados, garantindo consistência visual e experiência de usuário em dark/light modes.

## 🎯 THEME ARCHITECTURE

### **Core Theme Structure**
```css
:root {
  /* Light Mode (Default) */
  --text-primary: #112031;
  --text-secondary: #294359;
  --text-muted: #B4AC9C;
  --background: #ffffff;
  --surface: #f8f9fa;
  
  /* Theme Transition */
  --theme-transition: all 0.3s ease;
}

.dark {
  /* Dark Mode */
  --text-primary: #f5f5f5;
  --text-secondary: #D2D0C8;
  --text-muted: #8A8275;
  --background: #0f0f0f;
  --surface: #1a1a1a;
}
```

### **Theme Variables System**
```css
/* Semantic Color Variables */
:root {
  /* GRUPO US PANTONE Colors (Static) */
  --primary-dark-static: #112031;
  --primary-blue-static: #294359;
  --accent-gold-static: #AC9469;
  --neutral-light-static: #B4AC9C;
  --neutral-extralight-static: #D2D0C8;
  
  /* Dynamic Theme Colors */
  --text-primary: var(--primary-dark-static);
  --text-secondary: var(--primary-blue-static);
  --text-muted: var(--neutral-light-static);
  --background: #ffffff;
  --surface: #f8f9fa;
  
  /* Accent Colors (Consistent across themes) */
  --accent-gold: var(--accent-gold-static);
  --neutral-light: var(--neutral-light-static);
  --neutral-extralight: var(--neutral-extralight-static);
}

.dark {
  /* Dark Mode Overrides */
  --text-primary: #f5f5f5;
  --text-secondary: #D2D0C8;
  --text-muted: #8A8275;
  --background: #0f0f0f;
  --surface: #1a1a1a;
  --neutral-extralight: #3A3832;
}
```

## 🔧 IMPLEMENTATION PATTERNS

### **Next.js Implementation**
```typescript
// providers.tsx
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

// layout.tsx
import { Providers } from "@/components/providers";

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
```

### **Vite Implementation**
```typescript
// ThemeContext.tsx
import { createContext, useContext, useEffect, useState } from 'react';

type Theme = 'dark' | 'light';

interface ThemeContextType {
  theme: Theme;
  setTheme: (theme: Theme) => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<Theme>(() => {
    const stored = localStorage.getItem('theme');
    return (stored as Theme) || 'dark';
  });

  useEffect(() => {
    const root = window.document.documentElement;
    root.classList.remove('light', 'dark');
    root.classList.add(theme);
    localStorage.setItem('theme', theme);
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
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

## 🎨 THEME TOGGLE COMPONENT

### **Universal Theme Toggle**
```typescript
"use client";
import { useTheme } from "next-themes"; // or custom hook for Vite
import { useEffect, useState } from "react";
import { Moon, Sun } from "lucide-react";

export function ThemeToggle() {
  const [mounted, setMounted] = useState(false);
  const { theme, setTheme } = useTheme();

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) return null;

  return (
    <button
      onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
      className="fixed top-4 left-4 z-50 p-2 rounded-lg bg-surface border border-neutral-light hover:bg-neutral-extralight transition-all duration-300 group focus-visible"
      aria-label={`Switch to ${theme === "dark" ? "light" : "dark"} mode`}
      aria-pressed={theme === "dark"}
    >
      <span className="sr-only">
        Current theme: {theme === "dark" ? "Dark" : "Light"} mode
      </span>
      <div className="relative w-6 h-6">
        <Sun
          className={`absolute inset-0 w-6 h-6 text-accent-gold transition-all duration-300 ${
            theme === "dark" ? "rotate-90 scale-0" : "rotate-0 scale-100"
          }`}
        />
        <Moon
          className={`absolute inset-0 w-6 h-6 text-accent-gold transition-all duration-300 ${
            theme === "dark" ? "rotate-0 scale-100" : "-rotate-90 scale-0"
          }`}
        />
      </div>
    </button>
  );
}
```

## 🎭 THEME-AWARE COMPONENTS

### **Component Theme Integration**
```css
/* Base Component Styling */
.component-base {
  background: var(--surface);
  color: var(--text-primary);
  border: 1px solid var(--neutral-light);
  transition: var(--theme-transition);
}

/* Theme-specific adjustments */
.dark .component-base {
  border-color: #8A8275;
}

/* Hover states that work in both themes */
.component-base:hover {
  background: var(--neutral-extralight);
  transform: translateY(-1px);
}
```

### **Conditional Theme Styling**
```typescript
// Theme-aware className utility
function getThemeClasses(theme: string, baseClasses: string) {
  const themeClasses = {
    light: 'bg-white text-gray-900 border-gray-200',
    dark: 'bg-gray-900 text-white border-gray-700'
  };
  
  return `${baseClasses} ${themeClasses[theme as keyof typeof themeClasses]}`;
}

// Usage in component
function Card({ children, className }: CardProps) {
  const { theme } = useTheme();
  
  return (
    <div className={cn(
      "rounded-lg border p-6 transition-all duration-300",
      "bg-surface text-text-primary border-neutral-light",
      className
    )}>
      {children}
    </div>
  );
}
```

## 🌈 THEME TRANSITIONS

### **Smooth Transitions**
```css
/* Global Transition Setup */
* {
  transition: background-color 0.3s ease,
              color 0.3s ease,
              border-color 0.3s ease,
              box-shadow 0.3s ease;
}

/* Prevent transition on theme change for specific elements */
.no-theme-transition {
  transition: none !important;
}

/* Theme change animation */
@keyframes theme-transition {
  0% { opacity: 0.8; }
  100% { opacity: 1; }
}

.theme-transition {
  animation: theme-transition 0.3s ease-in-out;
}
```

### **Reduced Motion Support**
```css
@media (prefers-reduced-motion: reduce) {
  * {
    transition-duration: 0.01ms !important;
  }
  
  .theme-transition {
    animation: none !important;
  }
}
```

## 🎨 THEME-SPECIFIC ASSETS

### **Image Handling**
```typescript
// Theme-aware image component
interface ThemeImageProps {
  lightSrc: string;
  darkSrc: string;
  alt: string;
  className?: string;
}

export function ThemeImage({ lightSrc, darkSrc, alt, className }: ThemeImageProps) {
  const { theme } = useTheme();
  
  return (
    <img
      src={theme === 'dark' ? darkSrc : lightSrc}
      alt={alt}
      className={className}
    />
  );
}

// CSS-based approach
.theme-image-light {
  display: block;
}

.theme-image-dark {
  display: none;
}

.dark .theme-image-light {
  display: none;
}

.dark .theme-image-dark {
  display: block;
}
```

## 📱 SYSTEM PREFERENCE DETECTION

### **System Theme Detection**
```typescript
// Hook for system preference
function useSystemTheme() {
  const [systemTheme, setSystemTheme] = useState<'light' | 'dark'>('light');

  useEffect(() => {
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    setSystemTheme(mediaQuery.matches ? 'dark' : 'light');

    const handler = (e: MediaQueryListEvent) => {
      setSystemTheme(e.matches ? 'dark' : 'light');
    };

    mediaQuery.addEventListener('change', handler);
    return () => mediaQuery.removeEventListener('change', handler);
  }, []);

  return systemTheme;
}

// Enhanced theme provider with system detection
export function EnhancedThemeProvider({ children }: { children: React.ReactNode }) {
  const systemTheme = useSystemTheme();
  const [theme, setTheme] = useState<'light' | 'dark' | 'system'>('system');

  const resolvedTheme = theme === 'system' ? systemTheme : theme;

  return (
    <ThemeProvider value={{ theme: resolvedTheme, setTheme }}>
      {children}
    </ThemeProvider>
  );
}
```

## 🧪 TESTING THEMES

### **Theme Testing Utilities**
```typescript
// Test utility for theme switching
export function renderWithTheme(component: React.ReactElement, theme: 'light' | 'dark' = 'light') {
  return render(
    <ThemeProvider defaultTheme={theme}>
      {component}
    </ThemeProvider>
  );
}

// Theme-aware test
describe('Component with themes', () => {
  it('renders correctly in light theme', () => {
    renderWithTheme(<Component />, 'light');
    expect(screen.getByTestId('component')).toHaveClass('bg-white');
  });

  it('renders correctly in dark theme', () => {
    renderWithTheme(<Component />, 'dark');
    expect(screen.getByTestId('component')).toHaveClass('bg-gray-900');
  });

  it('switches themes correctly', () => {
    const { rerender } = renderWithTheme(<ThemeToggle />, 'light');
    
    fireEvent.click(screen.getByRole('button'));
    
    expect(document.documentElement).toHaveClass('dark');
  });
});
```

## 📊 PERFORMANCE CONSIDERATIONS

### **Theme Loading Optimization**
```typescript
// Prevent flash of unstyled content
const themeScript = `
  (function() {
    const theme = localStorage.getItem('theme') || 'dark';
    document.documentElement.classList.add(theme);
  })();
`;

// In HTML head
<script dangerouslySetInnerHTML={{ __html: themeScript }} />

// CSS for preventing FOUC
.theme-loading {
  visibility: hidden;
}

.theme-loaded {
  visibility: visible;
}
```

### **Bundle Size Optimization**
```typescript
// Lazy load theme-specific components
const DarkModeChart = lazy(() => import('./DarkModeChart'));
const LightModeChart = lazy(() => import('./LightModeChart'));

function Chart() {
  const { theme } = useTheme();
  
  return (
    <Suspense fallback={<ChartSkeleton />}>
      {theme === 'dark' ? <DarkModeChart /> : <LightModeChart />}
    </Suspense>
  );
}
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
