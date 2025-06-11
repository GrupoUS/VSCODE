# 🧩 GRUPO US COMPONENT LIBRARY STANDARDS

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO, AegisWallet, Harmoniza-Facil-Agendas implementations  

## 📋 OVERVIEW

Padrões de componentes UI consolidados dos 3 projetos otimizados, definindo estrutura, comportamento e styling consistentes para toda a biblioteca de componentes GRUPO US.

## 🎯 COMPONENT ARCHITECTURE

### **Base Component Structure**
```typescript
interface BaseComponentProps {
  className?: string;
  children?: React.ReactNode;
  variant?: string;
  size?: string;
  disabled?: boolean;
  'data-testid'?: string;
}

const BaseComponent = React.forwardRef<HTMLElement, BaseComponentProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <element
        className={cn(componentVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);
```

## 🔘 BUTTON COMPONENT

### **Button Variants**
```typescript
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
```

### **Button Implementation**
```typescript
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement>, VariantProps<typeof buttonVariants> {
  asChild?: boolean;
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    if (asChild) {
      return (
        <span className={cn(buttonVariants({ variant, size, className }))} {...props} />
      );
    }
    
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);
```

## 📄 CARD COMPONENT

### **Card Structure**
```typescript
const Card = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div
      ref={ref}
      className={cn(
        "rounded-lg border border-neutral-light bg-surface text-text-primary shadow-sm transition-all duration-300",
        className
      )}
      {...props}
    />
  )
);

const CardHeader = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn("flex flex-col space-y-1.5 p-6", className)} {...props} />
  )
);

const CardTitle = React.forwardRef<HTMLParagraphElement, React.HTMLAttributes<HTMLHeadingElement>>(
  ({ className, ...props }, ref) => (
    <h3
      ref={ref}
      className={cn("text-2xl font-semibold leading-none tracking-tight font-heading text-text-primary", className)}
      {...props}
    />
  )
);
```

## 🎨 INPUT COMPONENT

### **Input Variants**
```typescript
const inputVariants = cva(
  "flex w-full rounded-md border border-neutral-light bg-surface px-3 py-2 text-sm text-text-primary transition-all duration-300 file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-text-muted focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent-gold disabled:cursor-not-allowed disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "border-neutral-light",
        error: "border-red-500 focus-visible:ring-red-500",
        success: "border-green-500 focus-visible:ring-green-500",
      },
      size: {
        default: "h-10",
        sm: "h-9",
        lg: "h-11",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
);
```

## 🎭 THEME TOGGLE COMPONENT

### **Theme Toggle Implementation**
```typescript
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
      <span className="sr-only">Current theme: {theme === "dark" ? "Dark" : "Light"} mode</span>
      <div className="relative w-6 h-6">
        <Sun className={`absolute inset-0 w-6 h-6 text-accent-gold transition-all duration-300 ${theme === "dark" ? "rotate-90 scale-0" : "rotate-0 scale-100"}`} />
        <Moon className={`absolute inset-0 w-6 h-6 text-accent-gold transition-all duration-300 ${theme === "dark" ? "rotate-0 scale-100" : "-rotate-90 scale-0"}`} />
      </div>
    </button>
  );
}
```

## 📊 SPACING SYSTEM

### **Spacing Scale**
```css
:root {
  --spacing-xs: 0.5rem;   /* 8px */
  --spacing-sm: 1rem;     /* 16px */
  --spacing-md: 1.5rem;   /* 24px */
  --spacing-lg: 2rem;     /* 32px */
  --spacing-xl: 3rem;     /* 48px */
  --spacing-2xl: 4rem;    /* 64px */
  --spacing-3xl: 6rem;    /* 96px */
}
```

### **Component Spacing**
```css
/* Card Spacing */
.card-padding {
  padding: var(--spacing-lg);
}

/* Button Spacing */
.btn-padding-sm {
  padding: var(--spacing-xs) var(--spacing-sm);
}

.btn-padding-default {
  padding: var(--spacing-sm) var(--spacing-md);
}

.btn-padding-lg {
  padding: var(--spacing-md) var(--spacing-xl);
}
```

## 🎯 ANIMATION STANDARDS

### **Transition Durations**
```css
:root {
  --transition-fast: 150ms;
  --transition-normal: 300ms;
  --transition-slow: 500ms;
}
```

### **Common Animations**
```css
/* Hover Effects */
.hover-lift {
  transition: transform var(--transition-normal) ease;
}

.hover-lift:hover {
  transform: translateY(-2px);
}

/* Focus Effects */
.focus-visible {
  outline: none;
  ring: 2px solid var(--accent-gold);
  ring-offset: 2px;
  ring-offset-color: var(--background);
}

/* Theme Transitions */
.theme-transition {
  transition: background-color var(--transition-normal) ease,
              color var(--transition-normal) ease,
              border-color var(--transition-normal) ease;
}
```

## 🔧 UTILITY CLASSES

### **Surface Classes**
```css
.card-surface {
  background: var(--surface);
  border: 1px solid var(--neutral-light);
  border-radius: var(--radius);
  padding: var(--spacing-lg);
  transition: all var(--transition-normal) ease;
}

.input-surface {
  background: var(--surface);
  border: 1px solid var(--neutral-light);
  border-radius: var(--radius);
  padding: var(--spacing-sm);
  color: var(--text-primary);
  transition: all var(--transition-normal) ease;
}
```

### **Text Classes**
```css
.heading-optima {
  font-family: 'Optima', serif;
  font-weight: 700;
  color: var(--text-primary);
}

.text-inter {
  font-family: 'Inter', sans-serif;
  color: var(--text-primary);
}

.text-gold-neon {
  color: var(--accent-gold);
  filter: drop-shadow(var(--drop-shadow-gold-neon));
}
```

## 📱 RESPONSIVE PATTERNS

### **Mobile-First Components**
```css
/* Base Mobile Styles */
.responsive-component {
  padding: var(--spacing-sm);
  font-size: var(--text-sm);
}

/* Tablet Styles */
@media (min-width: 768px) {
  .responsive-component {
    padding: var(--spacing-md);
    font-size: var(--text-base);
  }
}

/* Desktop Styles */
@media (min-width: 1024px) {
  .responsive-component {
    padding: var(--spacing-lg);
    font-size: var(--text-lg);
  }
}
```

## ♿ ACCESSIBILITY STANDARDS

### **Focus Management**
```css
/* Focus Visible */
.focus-visible:focus-visible {
  outline: 2px solid var(--accent-gold);
  outline-offset: 2px;
}

/* Skip Links */
.skip-link {
  position: absolute;
  top: -40px;
  left: 6px;
  background: var(--accent-gold);
  color: var(--primary-dark);
  padding: 8px;
  text-decoration: none;
  transition: top var(--transition-fast) ease;
}

.skip-link:focus {
  top: 6px;
}
```

### **ARIA Patterns**
```typescript
// Button with proper ARIA
<button
  aria-label="Close dialog"
  aria-pressed={isPressed}
  aria-expanded={isExpanded}
  aria-describedby="button-description"
>
  Close
</button>

// Input with proper labeling
<div>
  <label htmlFor="email" className="sr-only">Email address</label>
  <input
    id="email"
    type="email"
    aria-describedby="email-error"
    aria-invalid={hasError}
  />
  {hasError && <div id="email-error" role="alert">Invalid email</div>}
</div>
```

## 🧪 TESTING STANDARDS

### **Component Testing Template**
```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './button';

describe('Button', () => {
  it('renders with correct variant', () => {
    render(<Button variant="secondary">Test Button</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-transparent');
  });

  it('handles click events', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('is accessible', () => {
    render(<Button aria-label="Custom label">Button</Button>);
    expect(screen.getByLabelText('Custom label')).toBeInTheDocument();
  });
});
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
