# 🚀 Svelte + Supabase Template - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Production-ready SvelteKit template with Supabase backend integration, TypeScript support, and modern development tools. This template leverages Svelte's compile-time optimizations and SvelteKit's full-stack capabilities for building high-performance web applications.

## 🛠️ TECH STACK

### **Frontend**
- **SvelteKit** - Full-stack Svelte framework
- **TypeScript** - Type-safe JavaScript development
- **Vite** - Fast build tool and development server
- **Svelte Stores** - Reactive state management
- **Tailwind CSS** - Utility-first CSS framework
- **Skeleton UI** - Svelte-native component library

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
npm create grupo-us-project my-svelte-app --template=svelte-supabase

# Navigate to project
cd my-svelte-app

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
svelte-supabase-template/
├── static/               # Static assets
├── src/
│   ├── lib/             # Shared utilities and components
│   │   ├── components/  # Reusable Svelte components
│   │   ├── stores/      # Svelte stores
│   │   ├── utils/       # Utility functions
│   │   └── supabase.ts  # Supabase client
│   ├── routes/          # SvelteKit routes
│   │   ├── api/         # API routes
│   │   ├── auth/        # Authentication pages
│   │   └── +layout.svelte # Root layout
│   ├── hooks.client.ts  # Client-side hooks
│   ├── hooks.server.ts  # Server-side hooks
│   └── app.html         # HTML template
├── tests/               # Test files
│   ├── unit/           # Unit tests
│   └── e2e/            # End-to-end tests
├── supabase/           # Supabase configuration
│   ├── migrations/     # Database migrations
│   └── seed.sql        # Initial data
└── docs/               # Documentation
```

## 🔧 AVAILABLE SCRIPTS

### **Development**
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build
npm run check        # Run svelte-check
npm run check:watch  # Run svelte-check in watch mode
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
```

### **Database**
```bash
npm run db:migrate   # Run database migrations
npm run db:seed      # Seed database with initial data
npm run db:reset     # Reset database (dev only)
npm run db:types     # Generate TypeScript types from schema
```

## 🎯 KEY FEATURES

### **Authentication System**
```typescript
// src/lib/stores/auth.ts
import { writable } from 'svelte/store'
import { supabase } from '$lib/supabase'

export const user = writable(null)
export const loading = writable(false)

export const signIn = async (email: string, password: string) => {
  loading.set(true)
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password
  })
  loading.set(false)
  if (data.user) user.set(data.user)
  return { data, error }
}
```

### **Database Integration**
```typescript
// src/lib/database.ts
import { supabase } from '$lib/supabase'
import type { Database } from '$lib/types/database'

type User = Database['public']['Tables']['users']['Row']

export const getUsers = async (): Promise<User[]> => {
  const { data, error } = await supabase
    .from('users')
    .select('*')
  
  if (error) throw error
  return data
}
```

### **Reactive Stores**
```typescript
// src/lib/stores/todos.ts
import { writable, derived } from 'svelte/store'

export const todos = writable([])
export const filter = writable('all')

export const filteredTodos = derived(
  [todos, filter],
  ([$todos, $filter]) => {
    if ($filter === 'completed') {
      return $todos.filter(todo => todo.completed)
    }
    if ($filter === 'active') {
      return $todos.filter(todo => !todo.completed)
    }
    return $todos
  }
)
```

### **Form Handling**
```svelte
<!-- src/routes/contact/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms'
  import { z } from 'zod'
  
  const schema = z.object({
    email: z.string().email(),
    message: z.string().min(10)
  })
  
  let form: HTMLFormElement
  let errors: Record<string, string> = {}
  
  const handleSubmit = enhance(({ formData }) => {
    const data = Object.fromEntries(formData)
    const result = schema.safeParse(data)
    
    if (!result.success) {
      errors = result.error.flatten().fieldErrors
      return { update: false }
    }
    
    errors = {}
    return async ({ result }) => {
      if (result.type === 'success') {
        form.reset()
      }
    }
  })
</script>

<form bind:this={form} method="POST" use:handleSubmit>
  <input
    name="email"
    type="email"
    placeholder="Email"
    class:error={errors.email}
  />
  {#if errors.email}
    <span class="error">{errors.email}</span>
  {/if}
  
  <textarea
    name="message"
    placeholder="Message"
    class:error={errors.message}
  ></textarea>
  {#if errors.message}
    <span class="error">{errors.message}</span>
  {/if}
  
  <button type="submit">Send</button>
</form>
```

## 🔒 SECURITY FEATURES

### **Server-Side Authentication**
```typescript
// src/hooks.server.ts
import { createSupabaseServerClient } from '@supabase/auth-helpers-sveltekit'
import type { Handle } from '@sveltejs/kit'

export const handle: Handle = async ({ event, resolve }) => {
  event.locals.supabase = createSupabaseServerClient({
    supabaseUrl: VITE_SUPABASE_URL,
    supabaseKey: VITE_SUPABASE_ANON_KEY,
    event
  })
  
  event.locals.getSession = async () => {
    const { data: { session } } = await event.locals.supabase.auth.getSession()
    return session
  }
  
  return resolve(event, {
    filterSerializedResponseHeaders(name) {
      return name === 'content-range'
    }
  })
}
```

### **Protected Routes**
```typescript
// src/routes/dashboard/+layout.server.ts
import { redirect } from '@sveltejs/kit'
import type { LayoutServerLoad } from './$types'

export const load: LayoutServerLoad = async ({ locals }) => {
  const session = await locals.getSession()
  
  if (!session) {
    throw redirect(303, '/auth/signin')
  }
  
  return {
    session,
    user: session.user
  }
}
```

### **CSRF Protection**
```typescript
// Built-in CSRF protection in SvelteKit
// Automatically handled for form actions
```

## 📱 RESPONSIVE DESIGN

### **Mobile-First Components**
```svelte
<!-- src/lib/components/Navigation.svelte -->
<script lang="ts">
  import { page } from '$app/stores'
  let mobileMenuOpen = false
</script>

<nav class="bg-white shadow-lg">
  <div class="max-w-7xl mx-auto px-4">
    <div class="flex justify-between h-16">
      <!-- Desktop menu -->
      <div class="hidden md:flex space-x-8">
        {#each navItems as item}
          <a
            href={item.href}
            class="text-gray-900 hover:text-blue-600"
            class:active={$page.url.pathname === item.href}
          >
            {item.label}
          </a>
        {/each}
      </div>
      
      <!-- Mobile menu button -->
      <button
        class="md:hidden"
        on:click={() => mobileMenuOpen = !mobileMenuOpen}
      >
        Menu
      </button>
    </div>
    
    <!-- Mobile menu -->
    {#if mobileMenuOpen}
      <div class="md:hidden">
        {#each navItems as item}
          <a href={item.href} class="block px-4 py-2">
            {item.label}
          </a>
        {/each}
      </div>
    {/if}
  </div>
</nav>
```

## 🚀 DEPLOYMENT

### **Vercel (Recommended)**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Adapter configuration in svelte.config.js
import adapter from '@sveltejs/adapter-vercel'
```

### **Netlify**
```bash
# Adapter configuration
import adapter from '@sveltejs/adapter-netlify'

# Build command: npm run build
# Publish directory: build
```

### **Node.js**
```bash
# Adapter configuration
import adapter from '@sveltejs/adapter-node'

# Build and run
npm run build
node build
```

## 📊 PERFORMANCE OPTIMIZATION

### **Code Splitting**
```typescript
// Automatic route-based code splitting
// Each route in src/routes/ is automatically split
```

### **Preloading**
```svelte
<script lang="ts">
  import { preloadData } from '$app/navigation'
  
  const handleMouseEnter = () => {
    preloadData('/dashboard')
  }
</script>

<a href="/dashboard" on:mouseenter={handleMouseEnter}>
  Dashboard
</a>
```

### **Image Optimization**
```svelte
<!-- src/lib/components/OptimizedImage.svelte -->
<script lang="ts">
  export let src: string
  export let alt: string
  export let width: number
  export let height: number
  
  $: srcset = `
    ${src}?w=${width}&h=${height}&q=75 1x,
    ${src}?w=${width * 2}&h=${height * 2}&q=75 2x
  `
</script>

<img
  {src}
  {srcset}
  {alt}
  {width}
  {height}
  loading="lazy"
  decoding="async"
/>
```

## 🧪 TESTING STRATEGY

### **Unit Tests**
```typescript
// tests/unit/components/Button.test.ts
import { render, screen } from '@testing-library/svelte'
import { describe, it, expect } from 'vitest'
import Button from '$lib/components/Button.svelte'

describe('Button', () => {
  it('renders with correct text', () => {
    render(Button, { props: { text: 'Click me' } })
    expect(screen.getByRole('button')).toHaveTextContent('Click me')
  })
})
```

### **E2E Tests**
```typescript
// tests/e2e/auth.test.ts
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
**SvelteKit Version**: 2.0+  
**Supabase Version**: 2.39+  
**License**: MIT
