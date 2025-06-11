# 📝 GRUPO US UNIVERSAL TYPOGRAPHY SYSTEM

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: Optima + Inter Font Combination  

## 📋 OVERVIEW

Sistema tipográfico universal do GRUPO US, consolidado a partir das implementações bem-sucedidas nos projetos NEONPRO, AegisWallet e Harmoniza-Facil-Agendas.

## 🎯 FONT FAMILIES

### **Primary Heading Font - Optima**
```css
font-family: 'Optima', serif;
```
**Uso**: Títulos principais, headings, elementos de destaque  
**Características**: Elegante, profissional, alta legibilidade  
**Fallbacks**: Georgia, Times New Roman, serif  

### **Body Text Font - Inter**
```css
font-family: 'Inter', sans-serif;
```
**Uso**: Textos corridos, parágrafos, elementos de interface  
**Características**: Moderna, legível, otimizada para telas  
**Fallbacks**: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif  

## 📏 SCALE SYSTEM

### **Font Size Scale**
```css
/* Base Scale (16px = 1rem) */
--text-xs: 0.75rem;    /* 12px */
--text-sm: 0.875rem;   /* 14px */
--text-base: 1rem;     /* 16px */
--text-lg: 1.125rem;   /* 18px */
--text-xl: 1.25rem;    /* 20px */
--text-2xl: 1.5rem;    /* 24px */
--text-3xl: 1.875rem;  /* 30px */
--text-4xl: 2.25rem;   /* 36px */
--text-5xl: 3rem;      /* 48px */
--text-6xl: 3.75rem;   /* 60px */
```

### **Responsive Typography**
```css
/* Fluid Typography with clamp() */
--text-responsive-h1: clamp(2rem, 5vw, 3.5rem);
--text-responsive-h2: clamp(1.5rem, 4vw, 2.5rem);
--text-responsive-h3: clamp(1.25rem, 3vw, 1.875rem);
--text-responsive-h4: clamp(1.125rem, 2.5vw, 1.5rem);
--text-responsive-h5: clamp(1rem, 2vw, 1.25rem);
--text-responsive-h6: clamp(0.875rem, 1.5vw, 1.125rem);
```

## 📐 LINE HEIGHT SYSTEM

### **Line Height Scale**
```css
--leading-none: 1;
--leading-tight: 1.25;
--leading-snug: 1.375;
--leading-normal: 1.5;
--leading-relaxed: 1.625;
--leading-loose: 2;
```

### **Contextual Line Heights**
```css
/* Headings */
--heading-line-height: var(--leading-tight);

/* Body Text */
--body-line-height: var(--leading-normal);

/* UI Elements */
--ui-line-height: var(--leading-snug);
```

## 🎨 FONT WEIGHTS

### **Weight Scale**
```css
--font-thin: 100;
--font-extralight: 200;
--font-light: 300;
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
--font-extrabold: 800;
--font-black: 900;
```

### **Semantic Weights**
```css
/* Optima Weights */
--heading-weight-normal: 400;
--heading-weight-bold: 700;
--heading-weight-black: 900;

/* Inter Weights */
--body-weight-light: 300;
--body-weight-normal: 400;
--body-weight-medium: 500;
--body-weight-bold: 700;
```

## 🏗️ TYPOGRAPHY CLASSES

### **Heading Classes**
```css
.heading-optima {
  font-family: 'Optima', serif;
  font-weight: var(--heading-weight-bold);
  line-height: var(--heading-line-height);
  color: var(--text-primary);
}

.heading-1 {
  font-size: var(--text-responsive-h1);
  font-weight: var(--heading-weight-black);
}

.heading-2 {
  font-size: var(--text-responsive-h2);
  font-weight: var(--heading-weight-bold);
}

.heading-3 {
  font-size: var(--text-responsive-h3);
  font-weight: var(--heading-weight-bold);
}
```

### **Body Text Classes**
```css
.text-inter {
  font-family: 'Inter', sans-serif;
  line-height: var(--body-line-height);
  color: var(--text-primary);
}

.text-body-large {
  font-size: var(--text-lg);
  font-weight: var(--body-weight-normal);
}

.text-body {
  font-size: var(--text-base);
  font-weight: var(--body-weight-normal);
}

.text-body-small {
  font-size: var(--text-sm);
  font-weight: var(--body-weight-normal);
}
```

## 📱 RESPONSIVE BREAKPOINTS

### **Typography Breakpoints**
```css
/* Mobile First Approach */
@media (min-width: 640px) {
  .responsive-text {
    font-size: calc(var(--text-base) * 1.1);
  }
}

@media (min-width: 768px) {
  .responsive-text {
    font-size: calc(var(--text-base) * 1.2);
  }
}

@media (min-width: 1024px) {
  .responsive-text {
    font-size: calc(var(--text-base) * 1.3);
  }
}
```

## ♿ ACCESSIBILITY FEATURES

### **Font Loading Optimization**
```css
/* Font Display Strategy */
@font-face {
  font-family: 'Optima';
  font-display: swap;
  /* Prevents invisible text during font load */
}

@font-face {
  font-family: 'Inter';
  font-display: swap;
  /* Ensures text remains visible during font load */
}
```

### **Reading Accessibility**
```css
/* Improved Readability */
body {
  font-feature-settings: "rlig" 1, "calt" 1;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
}

/* High Contrast Support */
@media (prefers-contrast: high) {
  .text-primary {
    color: #000000;
    font-weight: var(--font-bold);
  }
}
```

## 🔧 IMPLEMENTATION GUIDE

### **CSS Implementation**
```css
/* Import Fonts */
@import url('https://fonts.googleapis.com/css2?family=Optima:wght@400;700;900&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;700&display=swap');

/* Base Typography */
:root {
  /* Font Families */
  --font-heading: 'Optima', serif;
  --font-body: 'Inter', sans-serif;
  
  /* Font Sizes */
  --text-xs: 0.75rem;
  --text-sm: 0.875rem;
  --text-base: 1rem;
  --text-lg: 1.125rem;
  --text-xl: 1.25rem;
  --text-2xl: 1.5rem;
  --text-3xl: 1.875rem;
  --text-4xl: 2.25rem;
  --text-5xl: 3rem;
  --text-6xl: 3.75rem;
  
  /* Responsive Sizes */
  --text-responsive-h1: clamp(2rem, 5vw, 3.5rem);
  --text-responsive-h2: clamp(1.5rem, 4vw, 2.5rem);
  --text-responsive-h3: clamp(1.25rem, 3vw, 1.875rem);
}
```

### **Tailwind Configuration**
```javascript
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        'heading': ['Optima', 'serif'],
        'body': ['Inter', 'sans-serif'],
        'sans': ['Inter', 'sans-serif'],
        'serif': ['Optima', 'serif'],
      },
      fontSize: {
        'responsive-h1': ['clamp(2rem, 5vw, 3.5rem)', { lineHeight: '1.1' }],
        'responsive-h2': ['clamp(1.5rem, 4vw, 2.5rem)', { lineHeight: '1.2' }],
        'responsive-h3': ['clamp(1.25rem, 3vw, 1.875rem)', { lineHeight: '1.3' }],
      }
    }
  }
}
```

## 🧪 TESTING & VALIDATION

### **Typography Checklist**
- [ ] Fonts carregam corretamente
- [ ] Fallbacks funcionam adequadamente
- [ ] Responsive scaling funciona
- [ ] Contraste atende WCAG AA
- [ ] Performance otimizada
- [ ] Cross-browser compatibility

### **Performance Metrics**
- **Font Load Time**: <200ms
- **CLS (Cumulative Layout Shift)**: <0.1
- **Font Display**: swap strategy
- **Bundle Impact**: <50KB total

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
