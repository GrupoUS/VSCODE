# ♿ GRUPO US ACCESSIBILITY GUIDELINES

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Compliance**: WCAG 2.1 AA  
**Based on**: NEONPRO, AegisWallet, Harmoniza-Facil-Agendas implementations  

## 📋 OVERVIEW

Diretrizes de acessibilidade consolidadas do GRUPO US, garantindo conformidade WCAG 2.1 AA em todos os projetos e componentes do design system.

## 🎯 WCAG 2.1 AA COMPLIANCE

### **Princípios Fundamentais**
1. **Perceptível**: Informação deve ser apresentada de forma perceptível
2. **Operável**: Interface deve ser operável por todos os usuários
3. **Compreensível**: Informação e operação da UI devem ser compreensíveis
4. **Robusto**: Conteúdo deve ser robusto o suficiente para diferentes tecnologias

## 🎨 COLOR & CONTRAST

### **Requisitos de Contraste**
```css
/* WCAG AA Requirements */
--contrast-normal-text: 4.5:1;    /* Texto normal */
--contrast-large-text: 3:1;       /* Texto grande (18pt+ ou 14pt+ bold) */
--contrast-graphics: 3:1;          /* Elementos gráficos */
--contrast-ui-components: 3:1;     /* Componentes de interface */
```

### **Validação de Contraste GRUPO US**
```css
/* Combinações Validadas */
#112031 on #ffffff = 15.8:1 ✅ (Excelente)
#294359 on #ffffff = 8.2:1 ✅ (Excelente)
#AC9469 on #112031 = 4.6:1 ✅ (AA Compliant)
#B4AC9C on #112031 = 5.1:1 ✅ (AA Compliant)
#ffffff on #112031 = 15.8:1 ✅ (Excelente)
```

### **High Contrast Support**
```css
@media (prefers-contrast: high) {
  :root {
    --text-primary: #000000;
    --background: #ffffff;
    --accent-gold: #B8860B; /* Darker gold for better contrast */
  }

  .dark {
    --text-primary: #ffffff;
    --background: #000000;
    --accent-gold: #FFD700; /* Brighter gold for dark mode */
  }
}
```

## 🎯 FOCUS MANAGEMENT

### **Focus Indicators**
```css
/* Visible Focus Indicators */
.focus-visible:focus-visible {
  outline: 2px solid var(--accent-gold);
  outline-offset: 2px;
  border-radius: 4px;
}

/* Custom Focus Ring */
.focus-ring {
  box-shadow: 0 0 0 2px var(--background), 0 0 0 4px var(--accent-gold);
}

/* Focus Within for Containers */
.focus-within:focus-within {
  border-color: var(--accent-gold);
  box-shadow: 0 0 0 1px var(--accent-gold);
}
```

### **Focus Order & Navigation**
```typescript
// Skip Links Implementation
export function SkipLinks() {
  return (
    <div className="sr-only focus:not-sr-only">
      <a
        href="#main-content"
        className="fixed top-4 left-4 z-50 bg-accent-gold text-primary-dark px-4 py-2 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-accent-gold"
      >
        Skip to main content
      </a>
      <a
        href="#navigation"
        className="fixed top-4 left-32 z-50 bg-accent-gold text-primary-dark px-4 py-2 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-accent-gold"
      >
        Skip to navigation
      </a>
    </div>
  );
}
```

## 🔤 SEMANTIC HTML

### **Heading Hierarchy**
```html
<!-- Proper Heading Structure -->
<h1>Page Title</h1>
  <h2>Section Title</h2>
    <h3>Subsection Title</h3>
      <h4>Sub-subsection Title</h4>

<!-- Never skip heading levels -->
<!-- ❌ Wrong: h1 → h3 -->
<!-- ✅ Correct: h1 → h2 → h3 -->
```

### **Landmark Elements**
```html
<!-- Semantic Structure -->
<header role="banner">
  <nav role="navigation" aria-label="Main navigation">
    <!-- Navigation content -->
  </nav>
</header>

<main role="main" id="main-content">
  <section aria-labelledby="section-title">
    <h2 id="section-title">Section Title</h2>
    <!-- Section content -->
  </section>
</main>

<aside role="complementary" aria-label="Related information">
  <!-- Sidebar content -->
</aside>

<footer role="contentinfo">
  <!-- Footer content -->
</footer>
```

## 🏷️ ARIA PATTERNS

### **Common ARIA Attributes**
```typescript
// Button States
<button
  aria-pressed={isPressed}
  aria-expanded={isExpanded}
  aria-describedby="button-description"
  aria-label="Close dialog"
>
  {isPressed ? 'Pressed' : 'Not Pressed'}
</button>

// Form Controls
<div>
  <label htmlFor="email">Email Address</label>
  <input
    id="email"
    type="email"
    aria-describedby="email-error email-help"
    aria-invalid={hasError}
    aria-required="true"
  />
  <div id="email-help">We'll never share your email</div>
  {hasError && (
    <div id="email-error" role="alert" aria-live="polite">
      Please enter a valid email address
    </div>
  )}
</div>

// Modal Dialog
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
  aria-describedby="dialog-description"
>
  <h2 id="dialog-title">Dialog Title</h2>
  <p id="dialog-description">Dialog description</p>
</div>
```

### **Live Regions**
```typescript
// Status Updates
<div aria-live="polite" aria-atomic="true" className="sr-only">
  {statusMessage}
</div>

// Error Announcements
<div aria-live="assertive" role="alert">
  {errorMessage}
</div>

// Loading States
<div aria-live="polite" aria-busy={isLoading}>
  {isLoading ? 'Loading...' : 'Content loaded'}
</div>
```

## ⌨️ KEYBOARD NAVIGATION

### **Keyboard Support Standards**
```typescript
// Custom Keyboard Handler
function useKeyboardNavigation(onEscape?: () => void, onEnter?: () => void) {
  useEffect(() => {
    function handleKeyDown(event: KeyboardEvent) {
      switch (event.key) {
        case 'Escape':
          onEscape?.();
          break;
        case 'Enter':
        case ' ':
          onEnter?.();
          break;
        case 'Tab':
          // Let browser handle tab navigation
          break;
        default:
          break;
      }
    }

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [onEscape, onEnter]);
}

// Focus Trap for Modals
function useFocusTrap(isActive: boolean) {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!isActive || !containerRef.current) return;

    const focusableElements = containerRef.current.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    const firstElement = focusableElements[0] as HTMLElement;
    const lastElement = focusableElements[focusableElements.length - 1] as HTMLElement;

    function handleTabKey(e: KeyboardEvent) {
      if (e.key !== 'Tab') return;

      if (e.shiftKey) {
        if (document.activeElement === firstElement) {
          lastElement.focus();
          e.preventDefault();
        }
      } else {
        if (document.activeElement === lastElement) {
          firstElement.focus();
          e.preventDefault();
        }
      }
    }

    document.addEventListener('keydown', handleTabKey);
    firstElement?.focus();

    return () => document.removeEventListener('keydown', handleTabKey);
  }, [isActive]);

  return containerRef;
}
```

## 📱 RESPONSIVE ACCESSIBILITY

### **Touch Targets**
```css
/* Minimum Touch Target Size: 44x44px */
.touch-target {
  min-height: 44px;
  min-width: 44px;
  padding: 12px;
}

/* Spacing Between Touch Targets */
.touch-targets-container > * + * {
  margin-top: 8px;
}

@media (min-width: 768px) {
  .touch-targets-container > * + * {
    margin-top: 4px;
    margin-left: 8px;
  }
}
```

### **Responsive Text**
```css
/* Ensure text remains readable when zoomed to 200% */
.responsive-text {
  font-size: clamp(1rem, 2.5vw, 1.25rem);
  line-height: 1.5;
  max-width: 70ch; /* Optimal reading length */
}
```

## 🎬 MOTION & ANIMATION

### **Reduced Motion Support**
```css
/* Respect user preferences */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Safe animations */
.safe-animation {
  animation: fadeIn 0.3s ease-in-out;
}

@media (prefers-reduced-motion: reduce) {
  .safe-animation {
    animation: none;
  }
}
```

## 🧪 TESTING & VALIDATION

### **Automated Testing**
```typescript
// Jest + Testing Library Accessibility Tests
import { render, screen } from '@testing-library/react';
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

describe('Component Accessibility', () => {
  it('should not have accessibility violations', async () => {
    const { container } = render(<Component />);
    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('should have proper ARIA labels', () => {
    render(<Button aria-label="Close dialog">×</Button>);
    expect(screen.getByLabelText('Close dialog')).toBeInTheDocument();
  });

  it('should support keyboard navigation', () => {
    render(<Button>Click me</Button>);
    const button = screen.getByRole('button');
    button.focus();
    expect(button).toHaveFocus();
  });
});
```

### **Manual Testing Checklist**
```markdown
## Accessibility Testing Checklist

### Keyboard Navigation
- [ ] All interactive elements are focusable
- [ ] Focus order is logical
- [ ] Focus indicators are visible
- [ ] No keyboard traps
- [ ] Skip links work properly

### Screen Reader
- [ ] All content is announced properly
- [ ] Headings create proper structure
- [ ] Form labels are associated correctly
- [ ] Error messages are announced
- [ ] Status updates are communicated

### Visual
- [ ] Text contrast meets WCAG AA (4.5:1)
- [ ] Large text contrast meets WCAG AA (3:1)
- [ ] UI components contrast meets WCAG AA (3:1)
- [ ] Content is readable at 200% zoom
- [ ] No information conveyed by color alone

### Motor
- [ ] Touch targets are at least 44x44px
- [ ] Adequate spacing between interactive elements
- [ ] No time limits or they can be extended
- [ ] Motion can be paused or disabled
```

## 🛠️ IMPLEMENTATION TOOLS

### **Recommended Tools**
- **axe-core**: Automated accessibility testing
- **WAVE**: Web accessibility evaluation
- **Lighthouse**: Performance and accessibility audits
- **Color Oracle**: Color blindness simulation
- **NVDA/JAWS**: Screen reader testing

### **Browser Extensions**
- **axe DevTools**: Real-time accessibility testing
- **WAVE**: Web accessibility evaluation
- **Stark**: Color blindness and contrast checking
- **Accessibility Insights**: Microsoft accessibility testing

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
