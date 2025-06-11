---
description: Diretrizes para padronização da identidade visual dourada no sistema NEON PRO.
author: Sistema GRUPOUS/Cline Rules
version: 1.0
globs: ["neonpro/src/**/*"]
tags: ["ui-standards", "neon-pro", "visual-identity"]
alwaysApply: true
---

# Padrões de Identidade Visual - Dourado NEON PRO

## 1. Cor Dourada Padrão

- A cor dourada oficial para o sistema NEON PRO é o **Neon-Gold**: `#AC9469`.
- Esta cor deve ser utilizada para todos os elementos de destaque, CTAs (Call-to-Actions), links, ícones e textos que necessitem de ênfase visual.

## 2. Uso de Variáveis e Classes

- **Variável CSS**: Utilize `--neon-gold` ou `--accent` (definidos em `neonpro/src/styles/base.css`) para referenciar a cor dourada em estilos CSS customizados.
- **Classe Tailwind CSS**: Prefira usar `text-neon-brand`, `bg-neon-brand`, `border-neon-brand` ou as classes `text-accent`, `bg-accent`, `border-accent` (conforme definido em `neonpro/tailwind.config.ts`) para aplicar a cor dourada em componentes React/HTML.

## 3. Regra de Conversão

- **Qualquer texto ou elemento visual que atualmente utilize uma tonalidade de amarelo ou dourado inconsistente com `#AC9469` DEVE ser convertido** para o Neon-Gold (`#AC9469`).
- Evite hardcoding de cores. Sempre utilize as variáveis CSS ou classes Tailwind definidas.

## 4. Diretrizes de Acessibilidade

- Garanta que o contraste entre o texto dourado e o fundo seja sempre acessível (WCAG AA). Para texto sobre fundos escuros, o Neon-Gold `#AC9469` é adequado. Para texto sobre fundos claros, utilize `--color-primary-dark` (`#112031`) para o texto, conforme `global-theme-grupous.md`.

## 5. Exemplos de Uso

### ✅ FAÇA:
```html
<button className="bg-neon-brand text-primary-dark font-semibold py-2 px-4 rounded">
  Ação Principal
</button>

<span className="text-neon-brand font-medium">
  Texto de Destaque
</span>
```

### ❌ NÃO FAÇA:
```html
<button style={{ backgroundColor: '#FFD700' }}>
  Ação Antiga
</button>

<span className="text-yellow-500">
  Texto Amarelo
</span>
