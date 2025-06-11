# 🧪 TESTING INFRASTRUCTURE TEMPLATE

**Version**: 2.0  
**Status**: Active  
**Last Updated**: 2025-06-07  
**Based on**: NEONPRO, AegisWallet, Harmoniza-Facil-Agendas implementations  

## 📋 OVERVIEW

Template completo de infraestrutura de testes para projetos GRUPO US, consolidado a partir das implementações bem-sucedidas nos 3 projetos otimizados.

## 🎯 TESTING STRATEGY

### **Testing Pyramid**
```
    🔺 E2E Tests (10%)
   🔺🔺 Integration Tests (20%)
  🔺🔺🔺 Unit Tests (70%)
```

### **Test Types Coverage**
- **Unit Tests**: Components, hooks, utilities
- **Integration Tests**: API endpoints, database operations
- **E2E Tests**: Critical user journeys
- **Visual Tests**: Component snapshots
- **Accessibility Tests**: WCAG compliance
- **Performance Tests**: Bundle size, load times

## 🧪 UNIT TESTING SETUP

### **Jest Configuration (Next.js)**
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
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.stories.{js,jsx,ts,tsx}',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
};

module.exports = createJestConfig(customJestConfig);
```

### **Vitest Configuration (Vite)**
```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    globals: true,
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'src/test/',
        '**/*.d.ts',
        '**/*.stories.{js,jsx,ts,tsx}',
      ],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80,
        },
      },
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
});
```

### **Test Setup Files**
```typescript
// jest.setup.js / src/test/setup.ts
import '@testing-library/jest-dom';
import { expect, afterEach } from 'vitest';
import { cleanup } from '@testing-library/react';
import * as matchers from '@testing-library/jest-dom/matchers';

expect.extend(matchers);

afterEach(() => {
  cleanup();
});

// Mock IntersectionObserver
global.IntersectionObserver = class IntersectionObserver {
  constructor() {}
  disconnect() {}
  observe() {}
  unobserve() {}
};

// Mock ResizeObserver
global.ResizeObserver = class ResizeObserver {
  constructor() {}
  disconnect() {}
  observe() {}
  unobserve() {}
};

// Mock matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(),
    removeListener: jest.fn(),
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});
```

## 🧩 COMPONENT TESTING

### **Button Component Test**
```typescript
// src/components/ui/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('applies correct variant classes', () => {
    render(<Button variant="secondary">Secondary</Button>);
    const button = screen.getByRole('button');
    expect(button).toHaveClass('bg-transparent', 'border-accent-gold');
  });

  it('handles click events', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('is disabled when disabled prop is true', () => {
    render(<Button disabled>Disabled</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
  });

  it('has correct accessibility attributes', () => {
    render(<Button aria-label="Custom label">Button</Button>);
    expect(screen.getByLabelText('Custom label')).toBeInTheDocument();
  });
});
```

### **Theme Toggle Test**
```typescript
// src/components/ThemeToggle.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { ThemeProvider } from 'next-themes';
import { ThemeToggle } from './ThemeToggle';

const renderWithTheme = (component: React.ReactElement) => {
  return render(
    <ThemeProvider attribute="class" defaultTheme="light">
      {component}
    </ThemeProvider>
  );
};

describe('ThemeToggle', () => {
  it('renders theme toggle button', () => {
    renderWithTheme(<ThemeToggle />);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });

  it('has correct accessibility attributes', () => {
    renderWithTheme(<ThemeToggle />);
    const button = screen.getByRole('button');
    expect(button).toHaveAttribute('aria-label');
    expect(button).toHaveAttribute('aria-pressed');
  });

  it('toggles theme on click', () => {
    renderWithTheme(<ThemeToggle />);
    const button = screen.getByRole('button');
    
    fireEvent.click(button);
    // Theme change logic would be tested with proper theme context
  });
});
```

## 🔗 INTEGRATION TESTING

### **API Route Testing (Next.js)**
```typescript
// src/app/api/users/route.test.ts
import { createMocks } from 'node-mocks-http';
import { GET, POST } from './route';

describe('/api/users', () => {
  it('GET returns users list', async () => {
    const { req } = createMocks({ method: 'GET' });
    const response = await GET(req);
    const data = await response.json();
    
    expect(response.status).toBe(200);
    expect(Array.isArray(data)).toBe(true);
  });

  it('POST creates new user', async () => {
    const { req } = createMocks({
      method: 'POST',
      body: {
        name: 'John Doe',
        email: 'john@example.com',
      },
    });
    
    const response = await POST(req);
    const data = await response.json();
    
    expect(response.status).toBe(201);
    expect(data.name).toBe('John Doe');
  });
});
```

### **Custom Hook Testing**
```typescript
// src/hooks/useTheme.test.ts
import { renderHook, act } from '@testing-library/react';
import { useTheme } from './useTheme';

describe('useTheme', () => {
  it('returns default theme', () => {
    const { result } = renderHook(() => useTheme());
    expect(result.current.theme).toBe('dark');
  });

  it('updates theme correctly', () => {
    const { result } = renderHook(() => useTheme());
    
    act(() => {
      result.current.setTheme('light');
    });
    
    expect(result.current.theme).toBe('light');
  });
});
```

## 🎭 E2E TESTING WITH PLAYWRIGHT

### **Playwright Configuration**
```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### **E2E Test Examples**
```typescript
// tests/e2e/theme-toggle.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Theme Toggle', () => {
  test('should toggle between light and dark themes', async ({ page }) => {
    await page.goto('/');
    
    // Check initial theme
    await expect(page.locator('html')).toHaveClass(/dark/);
    
    // Click theme toggle
    await page.click('[aria-label*="Switch to light mode"]');
    
    // Check theme changed
    await expect(page.locator('html')).toHaveClass(/light/);
    
    // Verify visual changes
    await expect(page.locator('body')).toHaveCSS('background-color', 'rgb(255, 255, 255)');
  });

  test('should persist theme preference', async ({ page }) => {
    await page.goto('/');
    
    // Set light theme
    await page.click('[aria-label*="Switch to light mode"]');
    
    // Reload page
    await page.reload();
    
    // Check theme persisted
    await expect(page.locator('html')).toHaveClass(/light/);
  });
});

// tests/e2e/accessibility.spec.ts
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test.describe('Accessibility', () => {
  test('should not have accessibility violations', async ({ page }) => {
    await page.goto('/');
    
    const accessibilityScanResults = await new AxeBuilder({ page }).analyze();
    
    expect(accessibilityScanResults.violations).toEqual([]);
  });

  test('should support keyboard navigation', async ({ page }) => {
    await page.goto('/');
    
    // Tab through interactive elements
    await page.keyboard.press('Tab');
    await expect(page.locator(':focus')).toBeVisible();
    
    // Test Enter key on buttons
    await page.keyboard.press('Enter');
    // Add assertions based on expected behavior
  });
});
```

## 📊 VISUAL TESTING

### **Storybook Configuration**
```typescript
// .storybook/main.ts
import type { StorybookConfig } from '@storybook/nextjs';

const config: StorybookConfig = {
  stories: ['../src/**/*.stories.@(js|jsx|ts|tsx|mdx)'],
  addons: [
    '@storybook/addon-essentials',
    '@storybook/addon-a11y',
    '@storybook/addon-viewport',
  ],
  framework: {
    name: '@storybook/nextjs',
    options: {},
  },
  docs: {
    autodocs: 'tag',
  },
};

export default config;
```

### **Component Stories**
```typescript
// src/components/ui/Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'UI/Button',
  component: Button,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    variant: {
      control: { type: 'select' },
      options: ['default', 'secondary', 'outline', 'ghost', 'destructive'],
    },
  },
};

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    children: 'Button',
  },
};

export const GoldNeon: Story = {
  args: {
    children: 'Gold Neon Button',
    variant: 'default',
    className: 'btn-gold-neon',
  },
};

export const AllVariants: Story = {
  render: () => (
    <div className="flex gap-4">
      <Button variant="default">Default</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="outline">Outline</Button>
      <Button variant="ghost">Ghost</Button>
      <Button variant="destructive">Destructive</Button>
    </div>
  ),
};
```

## 🔧 BUILD OPTIMIZATION CHECKLIST

### **Pre-Build Validation**
```bash
#!/bin/bash
# scripts/pre-build-check.sh

echo "🔍 Pre-Build Validation..."

# TypeScript check
echo "📝 Checking TypeScript..."
npx tsc --noEmit

# ESLint check
echo "🔍 Running ESLint..."
npm run lint

# Test check
echo "🧪 Running tests..."
npm run test

# Bundle size check
echo "📦 Checking bundle size..."
npm run build
npm run analyze

echo "✅ Pre-Build Validation Complete!"
```

### **Build Optimization Checklist**
```markdown
## Build Optimization Checklist

### Code Quality
- [ ] TypeScript compilation successful (0 errors)
- [ ] ESLint validation passed (0 errors, <5 warnings)
- [ ] All tests passing (>80% coverage)
- [ ] No console.log statements in production

### Performance
- [ ] Bundle size < 150KB (gzipped)
- [ ] First Load JS < 100KB
- [ ] Images optimized (WebP/AVIF)
- [ ] Fonts optimized (<100KB total)
- [ ] Code splitting implemented

### Accessibility
- [ ] WCAG AA compliance verified
- [ ] Keyboard navigation tested
- [ ] Screen reader compatibility
- [ ] Color contrast validated (4.5:1)
- [ ] Focus indicators visible

### SEO & Meta
- [ ] Meta tags configured
- [ ] Open Graph tags set
- [ ] Sitemap generated
- [ ] Robots.txt configured
- [ ] Structured data implemented

### Security
- [ ] No sensitive data in client bundle
- [ ] Environment variables secured
- [ ] HTTPS enforced
- [ ] CSP headers configured
- [ ] Dependencies audited (npm audit)

### Deployment
- [ ] Environment configuration verified
- [ ] Build artifacts optimized
- [ ] CDN configuration ready
- [ ] Monitoring setup complete
- [ ] Error tracking configured
```

---

**Desenvolvido pelo GRUPO US VIBECODE SYSTEM V2.0**
