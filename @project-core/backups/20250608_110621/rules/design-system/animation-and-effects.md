# ✨ GRUPO US ANIMATION AND EFFECTS

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO, AegisWallet, Harmoniza-Facil-Agendas implementations  

## 📋 OVERVIEW

Sistema de animações e efeitos visuais do GRUPO US, consolidado a partir das implementações bem-sucedidas nos 3 projetos otimizados, focando nos icônicos efeitos neon gold e transições suaves.

## ✨ NEON GOLD EFFECTS

### **Drop Shadow System**
```css
/* Neon Gold Drop Shadows */
:root {
  --drop-shadow-gold-subtle: 0 0 4px rgba(172, 148, 105, 0.5);
  --drop-shadow-gold-neon: 0 0 8px rgba(172, 148, 105, 0.7);
  --drop-shadow-gold-strong: 0 0 16px rgba(172, 148, 105, 1);
  --drop-shadow-gold-intense: 0 0 24px rgba(172, 148, 105, 1.2);
}

/* Utility Classes */
.text-gold-neon {
  color: var(--accent-gold);
  filter: drop-shadow(var(--drop-shadow-gold-neon));
}

.text-gold-neon-strong {
  color: var(--accent-gold);
  filter: drop-shadow(var(--drop-shadow-gold-strong));
}
```

### **Box Shadow System**
```css
/* Neon Gold Box Shadows */
:root {
  --box-shadow-gold-subtle: 0 0 20px rgba(172, 148, 105, 0.3);
  --box-shadow-gold-medium: 0 0 30px rgba(172, 148, 105, 0.5);
  --box-shadow-gold-strong: 0 0 40px rgba(172, 148, 105, 0.8);
  --box-shadow-gold-intense: 0 0 60px rgba(172, 148, 105, 1);
}

/* Button Neon Effects */
.btn-gold-neon {
  background: var(--accent-gold);
  color: var(--primary-dark);
  box-shadow: var(--box-shadow-gold-subtle);
  transition: all 0.3s ease;
}

.btn-gold-neon:hover {
  box-shadow: var(--box-shadow-gold-medium);
  transform: translateY(-1px);
}

.btn-gold-neon:active {
  box-shadow: var(--box-shadow-gold-strong);
  transform: translateY(0);
}
```

## 🎭 ANIMATION SYSTEM

### **Duration Scale**
```css
:root {
  --duration-instant: 0ms;
  --duration-fast: 150ms;
  --duration-normal: 300ms;
  --duration-slow: 500ms;
  --duration-slower: 750ms;
  --duration-slowest: 1000ms;
}
```

### **Easing Functions**
```css
:root {
  --ease-linear: linear;
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
  --ease-elastic: cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
```

### **Core Animations**
```css
/* Fade Animations */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fadeOut {
  from { opacity: 1; }
  to { opacity: 0; }
}

/* Scale Animations */
@keyframes scaleIn {
  from { 
    opacity: 0;
    transform: scale(0.9);
  }
  to { 
    opacity: 1;
    transform: scale(1);
  }
}

@keyframes scaleOut {
  from { 
    opacity: 1;
    transform: scale(1);
  }
  to { 
    opacity: 0;
    transform: scale(0.9);
  }
}

/* Slide Animations */
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideInDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

## 🌟 NEON PULSE ANIMATIONS

### **Neon Pulse Effects**
```css
/* Neon Pulse Animation */
@keyframes neonPulse {
  0%, 100% {
    filter: drop-shadow(0 0 8px rgba(172, 148, 105, 0.7));
  }
  50% {
    filter: drop-shadow(0 0 16px rgba(172, 148, 105, 1));
  }
}

@keyframes neonGlow {
  0%, 100% {
    box-shadow: 0 0 20px rgba(172, 148, 105, 0.5);
  }
  50% {
    box-shadow: 0 0 40px rgba(172, 148, 105, 0.8);
  }
}

/* Utility Classes */
.animate-neon-pulse {
  animation: neonPulse 2s ease-in-out infinite;
}

.animate-neon-glow {
  animation: neonGlow 2s ease-in-out infinite;
}
```

### **Interactive Neon Effects**
```css
/* Hover Neon Enhancement */
.neon-interactive {
  transition: all var(--duration-normal) var(--ease-out);
  filter: drop-shadow(var(--drop-shadow-gold-subtle));
}

.neon-interactive:hover {
  filter: drop-shadow(var(--drop-shadow-gold-neon));
  transform: translateY(-2px);
}

.neon-interactive:active {
  filter: drop-shadow(var(--drop-shadow-gold-strong));
  transform: translateY(0);
}
```

## 🎨 THEME TRANSITIONS

### **Theme Switch Animation**
```css
/* Theme Transition Animation */
@keyframes themeTransition {
  0% { opacity: 0.8; }
  100% { opacity: 1; }
}

.theme-transition {
  animation: themeTransition var(--duration-normal) var(--ease-out);
}

/* Smooth Property Transitions */
.theme-aware {
  transition: 
    background-color var(--duration-normal) var(--ease-out),
    color var(--duration-normal) var(--ease-out),
    border-color var(--duration-normal) var(--ease-out),
    box-shadow var(--duration-normal) var(--ease-out);
}
```

### **Theme Toggle Icon Animation**
```css
/* Theme Toggle Rotation */
.theme-icon {
  transition: all var(--duration-normal) var(--ease-out);
}

.theme-icon.rotate-in {
  transform: rotate(0deg) scale(1);
}

.theme-icon.rotate-out {
  transform: rotate(90deg) scale(0);
}
```

## 🎯 INTERACTION ANIMATIONS

### **Button Animations**
```css
/* Button Hover Effects */
.btn-hover-lift {
  transition: all var(--duration-fast) var(--ease-out);
}

.btn-hover-lift:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* Button Press Effects */
.btn-press {
  transition: all var(--duration-fast) var(--ease-out);
}

.btn-press:active {
  transform: scale(0.98);
}
```

### **Card Animations**
```css
/* Card Hover Effects */
.card-hover {
  transition: all var(--duration-normal) var(--ease-out);
}

.card-hover:hover {
  transform: translateY(-4px);
  box-shadow: 
    0 10px 25px rgba(0, 0, 0, 0.1),
    0 0 20px rgba(172, 148, 105, 0.2);
}
```

## 📱 RESPONSIVE ANIMATIONS

### **Mobile-Optimized Animations**
```css
/* Reduce animations on mobile for performance */
@media (max-width: 768px) {
  .mobile-reduce-animation {
    animation-duration: var(--duration-fast) !important;
    transition-duration: var(--duration-fast) !important;
  }
}

/* Touch-friendly hover states */
@media (hover: hover) {
  .hover-only:hover {
    transform: translateY(-2px);
  }
}

@media (hover: none) {
  .hover-only:active {
    transform: scale(0.98);
  }
}
```

## ♿ ACCESSIBILITY CONSIDERATIONS

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
  }
  
  /* Maintain essential feedback */
  .essential-feedback {
    transition: opacity var(--duration-fast) var(--ease-out) !important;
  }
}

/* Safe animations that respect reduced motion */
.safe-animation {
  animation: fadeIn var(--duration-normal) var(--ease-out);
}

@media (prefers-reduced-motion: reduce) {
  .safe-animation {
    animation: none;
    opacity: 1;
  }
}
```

## 🎬 LOADING ANIMATIONS

### **Loading States**
```css
/* Skeleton Loading */
@keyframes skeleton {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

.skeleton {
  background: linear-gradient(
    90deg,
    var(--surface) 25%,
    var(--neutral-extralight) 50%,
    var(--surface) 75%
  );
  background-size: 200% 100%;
  animation: skeleton 1.5s infinite;
}

/* Spinner Animation */
@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.spinner {
  animation: spin 1s linear infinite;
}
```

### **Progress Animations**
```css
/* Progress Bar Animation */
@keyframes progressFill {
  from { width: 0%; }
  to { width: var(--progress-value); }
}

.progress-bar {
  animation: progressFill var(--duration-slow) var(--ease-out);
}
```

## 🔧 IMPLEMENTATION UTILITIES

### **Animation Utility Classes**
```css
/* Animation Control */
.animate-none { animation: none; }
.animate-spin { animation: spin 1s linear infinite; }
.animate-ping { animation: ping 1s cubic-bezier(0, 0, 0.2, 1) infinite; }
.animate-pulse { animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite; }
.animate-bounce { animation: bounce 1s infinite; }

/* Transition Utilities */
.transition-none { transition: none; }
.transition-all { transition: all var(--duration-normal) var(--ease-out); }
.transition-colors { transition: color var(--duration-normal) var(--ease-out), background-color var(--duration-normal) var(--ease-out); }
.transition-opacity { transition: opacity var(--duration-normal) var(--ease-out); }
.transition-transform { transition: transform var(--duration-normal) var(--ease-out); }

/* Duration Utilities */
.duration-75 { transition-duration: 75ms; }
.duration-100 { transition-duration: 100ms; }
.duration-150 { transition-duration: 150ms; }
.duration-200 { transition-duration: 200ms; }
.duration-300 { transition-duration: 300ms; }
.duration-500 { transition-duration: 500ms; }
.duration-700 { transition-duration: 700ms; }
.duration-1000 { transition-duration: 1000ms; }
```

## 🧪 TESTING ANIMATIONS

### **Animation Testing**
```typescript
// Test animation presence
describe('Animation Tests', () => {
  it('should apply neon effect on hover', () => {
    render(<Button className="btn-gold-neon">Test</Button>);
    const button = screen.getByRole('button');
    
    expect(button).toHaveClass('btn-gold-neon');
    
    fireEvent.mouseEnter(button);
    expect(button).toHaveStyle('transform: translateY(-1px)');
  });

  it('should respect reduced motion preference', () => {
    // Mock reduced motion preference
    Object.defineProperty(window, 'matchMedia', {
      writable: true,
      value: jest.fn().mockImplementation(query => ({
        matches: query === '(prefers-reduced-motion: reduce)',
        media: query,
        onchange: null,
        addListener: jest.fn(),
        removeListener: jest.fn(),
      })),
    });

    render(<AnimatedComponent />);
    const element = screen.getByTestId('animated-element');
    
    expect(element).toHaveStyle('animation-duration: 0.01ms');
  });
});
```

## 📊 PERFORMANCE OPTIMIZATION

### **Animation Performance**
```css
/* GPU Acceleration */
.gpu-accelerated {
  transform: translateZ(0);
  will-change: transform, opacity;
}

/* Optimize for 60fps */
.smooth-animation {
  animation-timing-function: var(--ease-out);
  animation-fill-mode: both;
}

/* Cleanup after animation */
.animation-cleanup {
  animation-fill-mode: forwards;
}

.animation-cleanup.animation-complete {
  will-change: auto;
}
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
