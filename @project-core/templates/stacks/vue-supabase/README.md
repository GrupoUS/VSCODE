# 🚀 Vue.js + Supabase Template - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Production-ready Vue.js 3 template with Supabase backend integration, TypeScript support, and modern development tools. This template provides a solid foundation for building scalable web applications with Vue's Composition API and Supabase's powerful backend services.

## 🛠️ TECH STACK

### **Frontend**
- **Vue 3** - Progressive JavaScript framework with Composition API
- **TypeScript** - Type-safe JavaScript development
- **Vite** - Fast build tool and development server
- **Vue Router 4** - Official router for Vue.js
- **Pinia** - Intuitive state management for Vue
- **Tailwind CSS** - Utility-first CSS framework
- **Headless UI** - Unstyled, accessible UI components

### **Backend & Services**
- **Supabase** - Open source Firebase alternative
- **PostgreSQL** - Robust relational database
- **Supabase Auth** - Authentication and user management
- **Supabase Storage** - File storage and CDN
- **Supabase Edge Functions** - Serverless functions

### **Development Tools**
- **Vitest** - Fast unit testing framework
- **Playwright** - End-to-end testing
- **ESLint** - Code linting and quality
- **Prettier** - Code formatting
- **Husky** - Git hooks for quality gates

## 🚀 QUICK START

### **Prerequisites**
```bash
# Required versions
Node.js >= 18.0.0
npm >= 9.0.0
```

### **Installation**
```bash
# Create new project
npm create grupo-us-project my-vue-app --template=vue-supabase

# Navigate to project
cd my-vue-app

# Install dependencies
npm install

# Setup environment
cp .env.example .env.local
# Edit .env.local with your Supabase credentials

# Start development server
npm run dev
```

### **Supabase Setup**
```bash
# 1. Create Supabase project at https://supabase.com
# 2. Get your project URL and anon key
# 3. Update .env.local:
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

# 4. Run database migrations
npm run db:migrate

# 5. Seed initial data (optional)
npm run db:seed
```

## 📁 PROJECT STRUCTURE

```
vue-supabase-template/
├── public/                 # Static assets
├── src/
│   ├── components/        # Vue components
│   │   ├── ui/           # Reusable UI components
│   │   ├── forms/        # Form components
│   │   └── layout/       # Layout components
│   ├── composables/      # Vue composables
│   ├── pages/            # Page components
│   ├── router/           # Vue Router configuration
│   ├── stores/           # Pinia stores
│   ├── types/            # TypeScript type definitions
│   ├── utils/            # Utility functions
│   └── lib/              # Third-party integrations
├── tests/                # Test files
│   ├── unit/            # Unit tests
│   └── e2e/             # End-to-end tests
├── supabase/            # Supabase configuration
│   ├── migrations/      # Database migrations
│   └── seed.sql         # Initial data
└── docs/                # Documentation
```

## 🔧 AVAILABLE SCRIPTS

### **Development**
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build
npm run type-check   # TypeScript type checking
```

### **Testing**
```bash
npm run test         # Run unit tests
npm run test:watch   # Run tests in watch mode
npm run test:e2e     # Run end-to-end tests
npm run test:coverage # Generate coverage report
```

### **Code Quality**
```bash
npm run lint         # Lint code with ESLint
npm run lint:fix     # Fix linting issues
npm run format       # Format code with Prettier
npm run type-check   # Check TypeScript types
```

### **Database**
```bash
npm run db:migrate   # Run database migrations
npm run db:seed      # Seed database with initial data
npm run db:reset     # Reset database (dev only)
npm run db:generate  # Generate TypeScript types from schema
```

## 🎯 KEY FEATURES

### **Authentication System**
```typescript
// Built-in authentication composable
import { useAuth } from '@/composables/useAuth'

const { user, signIn, signUp, signOut, loading } = useAuth()

// Usage in component
const handleSignIn = async () => {
  await signIn({ email: 'user@example.com', password: 'password' })
}
```

### **Database Integration**
```typescript
// Type-safe database operations
import { useSupabase } from '@/composables/useSupabase'

const { supabase } = useSupabase()

// Fetch data with TypeScript support
const { data: users } = await supabase
  .from('users')
  .select('*')
  .returns<User[]>()
```

### **State Management**
```typescript
// Pinia store example
import { defineStore } from 'pinia'

export const useUserStore = defineStore('user', () => {
  const user = ref<User | null>(null)
  const loading = ref(false)
  
  const fetchUser = async (id: string) => {
    loading.value = true
    // Fetch user logic
    loading.value = false
  }
  
  return { user, loading, fetchUser }
})
```

### **Form Handling**
```vue
<template>
  <form @submit.prevent="handleSubmit">
    <input
      v-model="form.email"
      type="email"
      :class="{ 'border-red-500': errors.email }"
    />
    <span v-if="errors.email" class="text-red-500">
      {{ errors.email }}
    </span>
    <button type="submit" :disabled="loading">
      Submit
    </button>
  </form>
</template>

<script setup lang="ts">
import { useForm } from '@/composables/useForm'
import { z } from 'zod'

const schema = z.object({
  email: z.string().email('Invalid email'),
  password: z.string().min(8, 'Password too short')
})

const { form, errors, loading, handleSubmit } = useForm(schema, {
  onSubmit: async (data) => {
    // Handle form submission
  }
})
</script>
```

## 🔒 SECURITY FEATURES

### **Row Level Security (RLS)**
```sql
-- Example RLS policy
CREATE POLICY "Users can only see their own data"
ON users FOR ALL
USING (auth.uid() = id);
```

### **Type-Safe Environment Variables**
```typescript
// src/lib/env.ts
import { z } from 'zod'

const envSchema = z.object({
  VITE_SUPABASE_URL: z.string().url(),
  VITE_SUPABASE_ANON_KEY: z.string().min(1),
})

export const env = envSchema.parse(import.meta.env)
```

### **Input Validation**
```typescript
// All forms use Zod validation
import { z } from 'zod'

const userSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  name: z.string().min(2).max(50)
})

type User = z.infer<typeof userSchema>
```

## 📱 RESPONSIVE DESIGN

### **Mobile-First Approach**
```vue
<template>
  <!-- Mobile-first responsive design -->
  <div class="
    grid grid-cols-1 gap-4
    md:grid-cols-2 md:gap-6
    lg:grid-cols-3 lg:gap-8
  ">
    <Card v-for="item in items" :key="item.id" />
  </div>
</template>
```

### **Accessibility Features**
- WCAG 2.1 AA compliance
- Keyboard navigation support
- Screen reader optimization
- Focus management
- Color contrast validation

## 🚀 DEPLOYMENT

### **Vercel (Recommended)**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Set environment variables in Vercel dashboard
```

### **Netlify**
```bash
# Build command: npm run build
# Publish directory: dist
# Environment variables: Set in Netlify dashboard
```

### **Docker**
```dockerfile
# Dockerfile included in template
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "run", "preview"]
```

## 📊 PERFORMANCE OPTIMIZATION

### **Code Splitting**
```typescript
// Automatic route-based code splitting
const routes = [
  {
    path: '/dashboard',
    component: () => import('@/pages/Dashboard.vue')
  }
]
```

### **Image Optimization**
```vue
<template>
  <!-- Optimized image component -->
  <OptimizedImage
    :src="imageUrl"
    :alt="imageAlt"
    :width="400"
    :height="300"
    loading="lazy"
  />
</template>
```

## 🧪 TESTING STRATEGY

### **Unit Tests**
```typescript
// Component testing with Vue Test Utils
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import UserCard from '@/components/UserCard.vue'

describe('UserCard', () => {
  it('renders user information correctly', () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser }
    })
    
    expect(wrapper.text()).toContain(mockUser.name)
  })
})
```

### **E2E Tests**
```typescript
// Playwright E2E testing
import { test, expect } from '@playwright/test'

test('user can sign in', async ({ page }) => {
  await page.goto('/auth/signin')
  await page.fill('[data-testid="email"]', 'test@example.com')
  await page.fill('[data-testid="password"]', 'password123')
  await page.click('[data-testid="signin-button"]')
  
  await expect(page).toHaveURL('/dashboard')
})
```

---

**Template Version**: 1.0.0  
**Last Updated**: 2025-06-08T11:06:21Z  
**Vue Version**: 3.4+  
**Supabase Version**: 2.39+  
**License**: MIT
