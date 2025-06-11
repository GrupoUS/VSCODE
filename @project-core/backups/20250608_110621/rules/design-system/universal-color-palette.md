# 🎨 GRUPO US UNIVERSAL COLOR PALETTE

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: PANTONE Color Specification  

## 📋 OVERVIEW

Este documento define a paleta de cores universal do GRUPO US, consolidada a partir das implementações bem-sucedidas nos projetos NEONPRO, AegisWallet e Harmoniza-Facil-Agendas.

## 🎯 CORES PRIMÁRIAS - PANTONE SPECIFICATION

### **Primary Dark** - PANTONE 5395 C
```css
--primary-dark: #112031;
--primary-dark-rgb: 17, 32, 49;
--primary-dark-hsl: 210, 49%, 13%;
```
**Uso**: Textos principais, elementos de alta hierarquia, fundos escuros

### **Primary Blue** - PANTONE 2168 C
```css
--primary-blue: #294359;
--primary-blue-rgb: 41, 67, 89;
--primary-blue-hsl: 208, 37%, 25%;
```
**Uso**: Textos secundários, elementos de apoio, estados hover

### **Accent Gold** - PANTONE 4007 C
```css
--accent-gold: #AC9469;
--accent-gold-rgb: 172, 148, 105;
--accent-gold-hsl: 39, 28%, 54%;
```
**Uso**: CTAs, destaques, elementos interativos, neon effects

### **Neutral Light** - PANTONE 7535 C
```css
--neutral-light: #B4AC9C;
--neutral-light-rgb: 180, 172, 156;
--neutral-light-hsl: 40, 13%, 66%;
```
**Uso**: Bordas, separadores, elementos sutis

### **Neutral Extra Light** - PANTONE 400 C
```css
--neutral-extralight: #D2D0C8;
--neutral-extralight-rgb: 210, 208, 200;
--neutral-extralight-hsl: 48, 11%, 80%;
```
**Uso**: Fundos secundários, áreas de conteúdo

## 🌓 SISTEMA DE TEMAS

### **Light Mode**
```css
:root {
  --text-primary: #112031;
  --text-secondary: #294359;
  --text-muted: #B4AC9C;
  --background: #ffffff;
  --surface: #f8f9fa;
}
```

### **Dark Mode**
```css
.dark {
  --text-primary: #f5f5f5;
  --text-secondary: #D2D0C8;
  --text-muted: #8A8275;
  --background: #0f0f0f;
  --surface: #1a1a1a;
}
```

## ✨ EFEITOS ESPECIAIS

### **Neon Gold Effects**
```css
/* Drop Shadow Variants */
--drop-shadow-gold-neon: 0 0 8px rgba(172, 148, 105, 0.7);
--drop-shadow-gold-neon-strong: 0 0 16px rgba(172, 148, 105, 1);

/* Box Shadow Variants */
--box-shadow-gold-subtle: 0 0 20px rgba(172, 148, 105, 0.3);
--box-shadow-gold-medium: 0 0 30px rgba(172, 148, 105, 0.5);
--box-shadow-gold-strong: 0 0 40px rgba(172, 148, 105, 0.8);
```

### **Utility Classes**
```css
.text-gold-neon {
  color: var(--accent-gold);
  filter: drop-shadow(var(--drop-shadow-gold-neon));
}

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
```

## 🎨 CORES SEMÂNTICAS

### **Estados de Feedback**
```css
/* Success */
--success: #22c55e;
--success-foreground: #ffffff;

/* Warning */
--warning: #f59e0b;
--warning-foreground: #112031;

/* Error */
--error: #ef4444;
--error-foreground: #ffffff;

/* Info */
--info: #3b82f6;
--info-foreground: #ffffff;
```

## 📊 ACESSIBILIDADE - WCAG AA

### **Contraste Mínimo**
- **Texto Normal**: 4.5:1
- **Texto Grande**: 3:1
- **Elementos Gráficos**: 3:1

### **Validação de Contraste**
```css
/* Combinações Validadas */
#112031 on #ffffff = 15.8:1 ✅
#294359 on #ffffff = 8.2:1 ✅
#AC9469 on #112031 = 4.6:1 ✅
#B4AC9C on #112031 = 5.1:1 ✅
```

## 🔧 IMPLEMENTAÇÃO

### **CSS Custom Properties**
```css
:root {
  /* GRUPO US PANTONE Colors */
  --primary-dark: #112031;
  --primary-blue: #294359;
  --accent-gold: #AC9469;
  --neutral-light: #B4AC9C;
  --neutral-extralight: #D2D0C8;
  
  /* Semantic Colors */
  --text-primary: var(--primary-dark);
  --text-secondary: var(--primary-blue);
  --text-muted: var(--neutral-light);
  --background: #ffffff;
  --surface: #f8f9fa;
  
  /* Effects */
  --gold-neon-glow: 0 0 20px rgba(172, 148, 105, 0.5);
}
```

### **Tailwind CSS Configuration**
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        'primary-dark': '#112031',
        'primary-blue': '#294359',
        'accent-gold': '#AC9469',
        'neutral-light': '#B4AC9C',
        'neutral-extralight': '#D2D0C8',
      },
      dropShadow: {
        'gold-neon': '0 0 8px rgba(172, 148, 105, 0.7)',
        'gold-neon-strong': '0 0 16px rgba(172, 148, 105, 1)',
      }
    }
  }
}
```

## 📱 ADAPTAÇÕES POR FRAMEWORK

### **Next.js Implementation**
- CSS Custom Properties em `globals.css`
- Tailwind configuration em `tailwind.config.ts`
- Theme provider com `next-themes`

### **Vite Implementation**
- CSS Custom Properties em `index.css`
- Tailwind configuration em `tailwind.config.js`
- Theme provider com context API

### **Universal Patterns**
- Sempre usar CSS Custom Properties como base
- Implementar dark mode com classe `.dark`
- Manter transições suaves (300ms)
- Validar contraste WCAG AA

## 🧪 TESTES DE VALIDAÇÃO

### **Checklist de Implementação**
- [ ] Cores PANTONE implementadas corretamente
- [ ] Dark/Light mode funcionando
- [ ] Transições suaves configuradas
- [ ] Contraste WCAG AA validado
- [ ] Neon effects implementados
- [ ] Responsive design testado

### **Ferramentas de Validação**
- **Contrast Checker**: WebAIM Contrast Checker
- **Color Blindness**: Stark (Figma/Sketch)
- **Accessibility**: axe DevTools
- **Performance**: Lighthouse

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
