---
description: Guia completo para criação de aplicações Next.js com autenticação Supabase.
author: Sistema GRUPOUS/Cline Rules
version: 1.0
globs: ["**/*"]
tags: ["nextjs", "supabase", "auth", "guideline"]
alwaysApply: true
---

# Next.js + Supabase Auth - Guia de Implementação

Esta regra define os padrões obrigatórios para a criação de aplicações Next.js que utilizam Supabase para autenticação de usuários, garantindo segurança, escalabilidade e consistência arquitetural.

## 1. Configuração de Ambiente (.env.local)

### Arquivo Obrigatório
Sempre criar o arquivo `.env.local` na raiz do projeto Next.js com as seguintes variáveis:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key

# Opcional: Para recursos server-side
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
```

### Regras de Segurança CRÍTICAS
- **NUNCA comitar o arquivo `.env.local`** - deve estar sempre no `.gitignore`
- Verificar se `.env.local` está listado no `.gitignore` antes de qualquer commit
- Criar um `.env.example` com as chaves sem valores para documentação

**Porquê**: As chaves do Supabase são sensíveis e específicas por ambiente. O vazamento dessas chaves pode comprometer a segurança da aplicação.

## 2. Criação do Cliente Supabase

### Estrutura de Arquivos Obrigatória
Criar sempre a seguinte estrutura para o cliente Supabase:

```
utils/
├── supabase/
│   ├── client.ts        # Cliente para uso no frontend
│   ├── server.ts        # Cliente para Server Components/API Routes
│   └── middleware.ts    # Cliente para middleware
```

### Implementação do Cliente Frontend

**Arquivo**: `utils/supabase/client.ts`
```typescript
import { createClientComponentClient } from '@supabase/auth-helpers-nextjs'
import { Database } from '@/types/supabase'

export const createClient = () =>
  createClientComponentClient<Database>()
```

### Implementação do Cliente Server

**Arquivo**: `utils/supabase/server.ts`
```typescript
import { createServerComponentClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { Database } from '@/types/supabase'

export const createClient = () =>
  createServerComponentClient<Database>({ cookies })
```

### Implementação do Cliente Middleware

**Arquivo**: `utils/supabase/middleware.ts`
```typescript
import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs'
import { NextRequest, NextResponse } from 'next/server'
import { Database } from '@/types/supabase'

export const createClient = (req: NextRequest, res: NextResponse) =>
  createMiddlewareClient<Database>({ req, res })
```

**Porquê**: Esta separação garante que cada contexto (client, server, middleware) use o cliente apropriado, otimizando performance e evitando problemas de hidratação.

## 3. Middleware para Rotas Protegidas

### Arquivo Obrigatório: middleware.ts

**Local**: `middleware.ts` (na raiz do projeto)

```typescript
import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs'
import { NextRequest, NextResponse } from 'next/server'
import { Database } from '@/types/supabase'

export async function middleware(req: NextRequest) {
  const res = NextResponse.next()
  const supabase = createMiddlewareClient<Database>({ req, res })

  // Verificar se há uma sessão ativa
  const {
    data: { session },
  } = await supabase.auth.getSession()

  // Rotas protegidas
  const protectedPaths = ['/dashboard', '/profile', '/admin']
  const isProtectedPath = protectedPaths.some(path => 
    req.nextUrl.pathname.startsWith(path)
  )

  // Redirecionar para login se não autenticado
  if (isProtectedPath && !session) {
    const redirectUrl = new URL('/login', req.url)
    redirectUrl.searchParams.set('redirectTo', req.nextUrl.pathname)
    return NextResponse.redirect(redirectUrl)
  }

  // Redirecionar usuários autenticados para longe da página de login
  if (req.nextUrl.pathname === '/login' && session) {
    const redirectTo = req.nextUrl.searchParams.get('redirectTo') || '/dashboard'
    return NextResponse.redirect(new URL(redirectTo, req.url))
  }

  return res
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public folder
     */
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
```

**Porquê**: O middleware do Next.js é executado antes de cada requisição, permitindo verificação de autenticação de forma eficiente sem adicionar latência às páginas públicas.

## 4. Componentes de Autenticação

### Estrutura de Componentes Obrigatória

```
components/
├── auth/
│   ├── LoginForm.tsx        # Formulário de login
│   ├── SignUpForm.tsx       # Formulário de cadastro
│   ├── LogoutButton.tsx     # Botão de logout
│   ├── AuthProvider.tsx     # Context provider para auth
│   └── ProtectedRoute.tsx   # Wrapper para rotas protegidas
```

### LoginForm.tsx

```typescript
'use client'

import { useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'

export default function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  
  const router = useRouter()
  const supabase = createClient()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    try {
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      })

      if (error) {
        setError(error.message)
        return
      }

      router.push('/dashboard')
    } catch (err) {
      setError('Erro inesperado. Tente novamente.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label htmlFor="email">Email</label>
        <input
          id="email"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />
      </div>
      
      <div>
        <label htmlFor="password">Senha</label>
        <input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />
      </div>

      {error && (
        <div className="text-red-600 text-sm">{error}</div>
      )}

      <button
        type="submit"
        disabled={loading}
        className="w-full bg-blue-600 text-white py-2 px-4 rounded disabled:opacity-50"
      >
        {loading ? 'Entrando...' : 'Entrar'}
      </button>
    </form>
  )
}
```

### LogoutButton.tsx

```typescript
'use client'

import { createClient } from '@/utils/supabase/client'
import { useRouter } from 'next/navigation'

export default function LogoutButton() {
  const router = useRouter()
  const supabase = createClient()

  const handleLogout = async () => {
    const { error } = await supabase.auth.signOut()
    
    if (!error) {
      router.push('/')
    }
  }

  return (
    <button
      onClick={handleLogout}
      className="bg-red-600 text-white py-2 px-4 rounded hover:bg-red-700"
    >
      Sair
    </button>
  )
}
```

### AuthProvider.tsx

```typescript
'use client'

import { createContext, useContext, useEffect, useState } from 'react'
import { createClient } from '@/utils/supabase/client'
import { User, Session } from '@supabase/supabase-js'

interface AuthContextType {
  user: User | null
  session: Session | null
  loading: boolean
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  session: null,
  loading: true,
})

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth deve ser usado dentro de AuthProvider')
  }
  return context
}

export default function AuthProvider({
  children,
}: {
  children: React.ReactNode
}) {
  const [user, setUser] = useState<User | null>(null)
  const [session, setSession] = useState<Session | null>(null)
  const [loading, setLoading] = useState(true)
  
  const supabase = createClient()

  useEffect(() => {
    // Verificar sessão inicial
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session)
      setUser(session?.user ?? null)
      setLoading(false)
    })

    // Escutar mudanças na auth
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session)
      setUser(session?.user ?? null)
    })

    return () => subscription.unsubscribe()
  }, [supabase.auth])

  return (
    <AuthContext.Provider value={{ user, session, loading }}>
      {children}
    </AuthContext.Provider>
  )
}
```

**Porquê**: Estes componentes centralizam a lógica de autenticação, proporcionando reutilização e manutenibilidade. O Context API evita prop drilling e mantém o estado global da autenticação.

## 5. Estrutura de Páginas de Exemplo

### Organização Obrigatória usando App Router

```
app/
├── page.tsx              # Página inicial (pública)
├── login/
│   └── page.tsx          # Página de login
├── dashboard/
│   ├── page.tsx          # Dashboard (protegida)
│   └── layout.tsx        # Layout do dashboard
└── layout.tsx            # Root layout com AuthProvider
```

### Root Layout (app/layout.tsx)

```typescript
import AuthProvider from '@/components/auth/AuthProvider'
import './globals.css'

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="pt-BR">
      <body>
        <AuthProvider>
          {children}
        </AuthProvider>
      </body>
    </html>
  )
}
```

### Página Inicial (app/page.tsx)

```typescript
import Link from 'next/link'
import { createClient } from '@/utils/supabase/server'

export default async function HomePage() {
  const supabase = createClient()
  const { data: { session } } = await supabase.auth.getSession()

  return (
    <main className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-8">Bem-vindo!</h1>
      
      {session ? (
        <div>
          <p>Olá, {session.user.email}!</p>
          <Link href="/dashboard" className="text-blue-600 hover:underline">
            Ir para Dashboard
          </Link>
        </div>
      ) : (
        <div>
          <p>Faça login para acessar sua conta.</p>
          <Link href="/login" className="text-blue-600 hover:underline">
            Fazer Login
          </Link>
        </div>
      )}
    </main>
  )
}
```

### Página de Login (app/login/page.tsx)

```typescript
import LoginForm from '@/components/auth/LoginForm'

export default function LoginPage() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="text-3xl font-bold text-center">
            Faça login na sua conta
          </h2>
        </div>
        <LoginForm />
      </div>
    </div>
  )
}
```

### Dashboard (app/dashboard/page.tsx)

```typescript
import { createClient } from '@/utils/supabase/server'
import LogoutButton from '@/components/auth/LogoutButton'
import { redirect } from 'next/navigation'

export default async function DashboardPage() {
  const supabase = createClient()
  const { data: { session } = await supabase.auth.getSession()

  // Redundância de segurança (middleware já protege)
  if (!session) {
    redirect('/login')
  }

  return (
    <main className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold">Dashboard</h1>
        <LogoutButton />
      </div>
      
      <div className="bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-semibold mb-4">
          Bem-vindo ao seu dashboard!
        </h2>
        <p>Email: {session.user.email}</p>
        <p>ID: {session.user.id}</p>
      </div>
    </main>
  )
}
```

**Porquê**: Esta estrutura demonstra o uso correto dos Server Components para verificação de sessão server-side, enquanto mantém interatividade onde necessário com Client Components.

## 6. Dependências Necessárias

### Package.json - Dependências Obrigatórias

```json
{
  "dependencies": {
    "@supabase/auth-helpers-nextjs": "^0.8.7",
    "@supabase/supabase-js": "^2.38.4",
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "typescript": "^5.0.0"
  }
}
```

### Comando de Instalação

```bash
npm install @supabase/auth-helpers-nextjs @supabase/supabase-js
```

## 7. Tipos TypeScript (Opcional mas Recomendado)

### Geração de Tipos

```bash
# Instalar CLI do Supabase
npm install -g supabase

# Gerar tipos TypeScript
npx supabase gen types typescript --project-id YOUR_PROJECT_ID > types/supabase.ts
```

### Uso dos Tipos

```typescript
// types/supabase.ts será gerado automaticamente
export type Database = {
  // tipos gerados...
}
```

**Porquê**: Os tipos TypeScript garantem type safety e melhor experiência de desenvolvimento com autocomplete.

## 8. Checklist de Implementação

### ✅ Verificações Obrigatórias

- [ ] `.env.local` criado e **NÃO** comitado
- [ ] `.env.example` criado para documentação
- [ ] Clientes Supabase criados para cada contexto (client/server/middleware)
- [ ] Middleware implementado e configurado
- [ ] Componentes de auth criados e testados
- [ ] Páginas de exemplo funcionando
- [ ] AuthProvider envolvendo a aplicação
- [ ] Rotas protegidas testadas
- [ ] Tipos TypeScript configurados (se aplicável)

### 🔒 Verificações de Segurança

- [ ] Chaves sensíveis apenas em variáveis de ambiente
- [ ] Middleware protegendo rotas corretas
- [ ] Validação de sessão server-side em páginas sensíveis
- [ ] Redirecionamentos apropriados implementados
- [ ] Tratamento de erros de autenticação

## 9. Boas Práticas Adicionais

### Performance
- Usar Server Components sempre que possível
- Client Components apenas para interatividade
- Implementar loading states nos formulários

### UX/UI
- Feedback visual para estados de loading
- Mensagens de erro claras e traduzidas
- Redirecionamentos intuitivos após login/logout

### Manutenibilidade
- Separar lógica de auth em hooks customizados
- Centralizar configurações de Supabase
- Documentar fluxos de autenticação

**Porquê**: Estas práticas garantem uma aplicação robusta, segura e mantível a longo prazo.

---

*Esta diretriz garante implementação consistente e segura de autenticação Next.js + Supabase em todos os projetos.*<environment_details>
# VSCode Visible Files
.clinerules/workflows/dev_workflow.md

# VSCode Open Tabs
.clinerules/master_rule.md
../../Documentos/Cline/Rules/global-theme-grupous.md
../../Documentos/Cline/Rules/global.md
.clinerules/ui-standards.md
.clinerules/workflows/aegiswallet.md
.clinerules/workflows/cursor_rules.md
.clinerules/workflows/dev_workflow.md

# Current Time
6/4/2025, 5:25:13 PM (America/Sao_Paulo, UTC-3:00)

# Context Window Usage
818,142 / 1,048.576K tokens used (78%)

# Current Mode
ACT MODE
</environment_details><environment_details>
# VSCode Visible Files
.clinerules/workflows/self_improve.md

# VSCode Open Tabs
../../Documentos/Cline/Rules/global-theme-grupous.md
../../Documentos/Cline/Rules/global.md
.clinerules/ui-standards.md
.clinerules/workflows/aegiswallet.md
.clinerules/workflows/cursor_rules.md
.clinerules/workflows/dev_workflow.md
.clinerules/workflows/neonpro.md
.clinerules/workflows/sync-all-repos.md
.clinerules/workflows/trintae3.md
.clinerules/master_rule.md
.clinerules/workflows/taskmaster.md
.clinerules/workflows/next-js-supabase-auth-guideline.md
.clinerules/workflows/self_improve.md

# Current Time
6/4/2025, 6:27:18 PM (America/Sao_Paulo, UTC-3:00)

# Context Window Usage
840,593 / 1,048.576K tokens used (80%)

# Current Mode
ACT MODE
</environment_details><environment_details>
# VSCode Visible Files
.clinerules/workflows/next-js-supabase-auth-guideline.md

# VSCode Open Tabs
../../Documentos/Cline/Rules/global-theme-grupous.md
../../Documentos/Cline/Rules/global.md
.clinerules/ui-standards.md
.clinerules/workflows/aegiswallet.md
.clinerules/workflows/cursor_rules.md
.clinerules/workflows/dev_workflow.md
.clinerules/workflows/neonpro.md
.clinerules/workflows/sync-all-repos.md
.clinerules/workflows/trintae3.md
.clinerules/master_rule.md
.clinerules/workflows/taskmaster.md
.clinerules/workflows/self_improve.md
.clinerules/workflows/next-js-supabase-auth-guideline.md

# Current Time
6/4/2025, 6:28:32 PM (America/Sao_Paulo, UTC-3:00)

# Context Window Usage
882,912 / 1,048.576K tokens used (84%)

# Current Mode
ACT MODE
</environment_details>
