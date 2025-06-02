# Styling & Frontend Dependencies

## 1. Engine de Estilização

### 1.1. Tailwind CSS
* **Abordagem Utility-First:** Use Tailwind CSS com abordagem utility-first para toda estilização.
* **Configuração:** Mantenha uma linguagem de design consistente usando a configuração do Tailwind (`tailwind.config.js`).

```javascript
// ✅ DO: Configuração personalizada do Tailwind
module.exports = {
  content: ['./src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          900: '#1e3a8a',
        },
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
    },
  },
  plugins: [require('daisyui')],
}
```

### 1.2. daisyUI
* **Componentes Pré-construídos:** Aproveite os componentes pré-construídos do daisyUI para desenvolvimento rápido e UI consistente.
* **Temas:** Use o sistema de temas do daisyUI para consistência visual.

```html
<!-- ✅ DO: Use componentes daisyUI -->
<button class="btn btn-primary">Primary Button</button>
<div class="card bg-base-100 shadow-xl">
  <div class="card-body">
    <h2 class="card-title">Card Title</h2>
    <p>Card content</p>
  </div>
</div>
```

## 2. Design Responsivo

### 2.1. Breakpoints do Tailwind
* **Mobile-First:** Implemente design responsivo usando os breakpoints do Tailwind (`sm`, `md`, `lg`, `xl`, `2xl`).
* **Abordagem Mobile-First:** Comece com design mobile e adicione estilos para telas maiores.

```html
<!-- ✅ DO: Design responsivo mobile-first -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <div class="p-4 bg-white rounded-lg shadow">Item 1</div>
  <div class="p-4 bg-white rounded-lg shadow">Item 2</div>
  <div class="p-4 bg-white rounded-lg shadow">Item 3</div>
</div>
```

### 2.2. Containers e Layout
```html
<!-- ✅ DO: Use containers apropriados -->
<div class="container mx-auto px-4 sm:px-6 lg:px-8">
  <main class="max-w-7xl mx-auto py-6">
    <!-- Conteúdo -->
  </main>
</div>
```

## 3. Dark Mode

### 3.1. Implementação
* **Suporte Nativo:** Implemente dark mode usando utilitários built-in do Tailwind e daisyUI.
* **Persistência:** Mantenha a preferência do usuário persistida.

```html
<!-- ✅ DO: Classes para dark mode -->
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
  <h1 class="text-2xl font-bold">Título</h1>
</div>
```

```tsx
// ✅ DO: Hook para dark mode
'use client';
import { useTheme } from 'next-themes';

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  
  return (
    <button
      onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
      className="btn btn-ghost"
    >
      {theme === 'dark' ? '☀️' : '🌙'}
    </button>
  );
}
```

## 4. Acessibilidade (A11y)

### 4.1. HTML Semântico
* **Elementos Semânticos:** Use elementos HTML semânticos apropriados.
* **Atributos ARIA:** Implemente atributos `aria-*` quando necessário.

```html
<!-- ✅ DO: HTML semântico -->
<nav aria-label="Main navigation">
  <ul class="flex space-x-4">
    <li><a href="/" class="text-blue-600 hover:text-blue-800">Home</a></li>
    <li><a href="/about" class="text-blue-600 hover:text-blue-800">About</a></li>
  </ul>
</nav>

<main>
  <article>
    <header>
      <h1>Título do Artigo</h1>
    </header>
    <section>
      <p>Conteúdo do artigo...</p>
    </section>
  </article>
</main>
```

### 4.2. Contraste e Foco
```html
<!-- ✅ DO: Estados de foco visíveis -->
<button class="btn btn-primary focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
  Botão Acessível
</button>

<!-- ✅ DO: Contraste adequado -->
<div class="bg-gray-900 text-white p-4">
  <p class="text-gray-100">Texto com contraste adequado</p>
</div>
```

## 5. Gerenciamento de Dependências

### 5.1. PHP (Composer)
* **Backend:** Use Composer para dependências de backend.
* **Versionamento:** Mantenha versões específicas para estabilidade.

```json
// ✅ DO: composer.json com versões específicas
{
  "require": {
    "php": "^8.1",
    "laravel/framework": "^10.0",
    "livewire/livewire": "^3.0"
  }
}
```

### 5.2. JavaScript (NPM/Yarn)
* **Frontend:** Use NPM ou Yarn para dependências de frontend.
* **Lock Files:** Sempre commite lock files para reprodutibilidade.

```json
// ✅ DO: package.json organizado
{
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "tailwindcss": "^3.0.0",
    "daisyui": "^4.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.0",
    "typescript": "^5.0.0",
    "eslint": "^8.0.0"
  }
}
```

## 6. Padrões de Componentes UI

### 6.1. Estrutura de Componente
```tsx
// ✅ DO: Componente UI reutilizável
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
}

export function Button({ 
  variant = 'primary', 
  size = 'md', 
  children, 
  onClick,
  disabled = false 
}: ButtonProps) {
  const baseClasses = 'btn font-medium rounded-lg transition-colors';
  const variantClasses = {
    primary: 'btn-primary',
    secondary: 'btn-secondary', 
    danger: 'btn-error'
  };
  const sizeClasses = {
    sm: 'btn-sm',
    md: 'btn-md',
    lg: 'btn-lg'
  };
  
  return (
    <button
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]}`}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </button>
  );
}
```

### 6.2. Composição de Classes
```tsx
// ✅ DO: Utilitário para composição de classes
import { clsx } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: (string | undefined)[]) {
  return twMerge(clsx(inputs));
}

// Uso
<div className={cn(
  'base-classes',
  variant === 'primary' && 'primary-classes',
  disabled && 'disabled-classes'
)}>
```

## 7. Performance de CSS

### 7.1. Purging
* **CSS Purging:** Configure adequadamente o purging do Tailwind para remover CSS não utilizado.
* **Produção:** Garanta que apenas classes utilizadas sejam incluídas no build de produção.

### 7.2. Critical CSS
```tsx
// ✅ DO: Carregamento otimizado de fontes
import { Inter } from 'next/font/google';

const inter = Inter({ 
  subsets: ['latin'],
  display: 'swap',
});

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR" className={inter.className}>
      <body>{children}</body>
    </html>
  );
}
