# Next.js Stack: React, TypeScript & Supabase

## 1. Estrutura de Componentes

### 1.1. Nomenclatura e Organização
* **Nomes de Arquivos:** Use `kebab-case` para nomes de arquivos de componentes (ex: `user-profile.tsx`).
* **Estrutura de Pastas:** Organize componentes logicamente por funcionalidade ou domínio.

### 1.2. React Server Components (RSC)
* **Priorize RSCs:** Use React Server Components por padrão para performance e data fetching.
* **Benefícios dos RSCs:**
  - Renderização no servidor
  - Acesso direto ao banco de dados
  - Melhor performance inicial
  - SEO otimizado

### 1.3. Client Components
* **Minimize Client Components:** Isole interatividade client-side (`'use client'`) aos menores componentes folha possíveis.
* **Exemplos de Client Components:**
  - Botão com handler `onClick`
  - Formulários com estado local
  - Componentes que usam hooks do React

```tsx
// ✅ DO: Server Component por padrão
export default async function UserProfile({ userId }: { userId: string }) {
  const user = await getUser(userId);
  
  return (
    <div>
      <h1>{user.name}</h1>
      <UserActions userId={userId} /> {/* Client Component isolado */}
    </div>
  );
}

// ✅ DO: Client Component isolado para interatividade
'use client';
export function UserActions({ userId }: { userId: string }) {
  const handleEdit = () => {
    // lógica de edição
  };
  
  return <button onClick={handleEdit}>Editar</button>;
}
```

## 2. Data Fetching

### 2.1. Server Components
* **Fetch em Server Components:** Busque dados em Server Components sempre que possível.
* **Async/Await:** Use async/await para data fetching em Server Components.

```tsx
// ✅ DO: Data fetching em Server Component
export default async function PostsList() {
  const posts = await getPosts();
  
  return (
    <div>
      {posts.map(post => (
        <PostCard key={post.id} post={post} />
      ))}
    </div>
  );
}
```

### 2.2. Estados de Loading e Erro
* **Sempre implemente:** Estados de loading e erro devem ser sempre implementados e exibidos.
* **Suspense:** Use Suspense para loading states em Server Components.
* **Error Boundaries:** Use Error Boundaries para error states.

```tsx
// ✅ DO: Loading state com Suspense
export default function PostsPage() {
  return (
    <Suspense fallback={<PostsLoading />}>
      <PostsList />
    </Suspense>
  );
}

// ✅ DO: Error Boundary
export default function PostsLayout({ children }: { children: React.ReactNode }) {
  return (
    <ErrorBoundary fallback={<PostsError />}>
      {children}
    </ErrorBoundary>
  );
}
```

## 3. Backend & Database (Supabase)

### 3.1. Configuração
* **Use Supabase:** Para serviços de backend, incluindo autenticação, interações com banco de dados e storage.
* **Variáveis de Ambiente:** Configure adequadamente as variáveis de ambiente do Supabase.

### 3.2. Segurança
* **Row-Level Security (RLS):** Adira às melhores práticas do Supabase para segurança, especialmente políticas RLS.
* **Autenticação:** Implemente autenticação adequada usando Supabase Auth.

```sql
-- ✅ DO: Política RLS adequada
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = user_id);
```

### 3.3. Database Queries
```tsx
// ✅ DO: Query com tratamento de erro
export async function getUser(userId: string) {
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', userId)
    .single();
    
  if (error) {
    throw new Error(`Failed to fetch user: ${error.message}`);
  }
  
  return data;
}
```

## 4. TypeScript

### 4.1. Tipagem Estrita
* **Strict Mode:** Use TypeScript em modo estrito.
* **Tipos Explícitos:** Defina tipos explícitos para props, estados e funções.

```tsx
// ✅ DO: Tipos explícitos
interface UserProfileProps {
  userId: string;
  showActions?: boolean;
}

export default function UserProfile({ userId, showActions = true }: UserProfileProps) {
  // implementação
}
```

### 4.2. Tipos do Supabase
* **Geração de Tipos:** Use tipos gerados automaticamente pelo Supabase.
* **Database Types:** Mantenha tipos de banco de dados sincronizados.

```tsx
// ✅ DO: Use tipos do Supabase
import { Database } from '@/types/supabase';

type User = Database['public']['Tables']['users']['Row'];
```

## 5. Padrões de Componentes

### 5.1. Estrutura Padrão
```tsx
// ✅ DO: Estrutura padrão de componente
interface ComponentProps {
  // props tipadas
}

export default function Component({ prop1, prop2 }: ComponentProps) {
  // hooks (se client component)
  // lógica do componente
  
  return (
    <div>
      {/* JSX */}
    </div>
  );
}
```

### 5.2. Exportação
* **Default Export:** Use default export para componentes principais.
* **Named Export:** Use named export para utilitários e hooks.

```tsx
// ✅ DO: Default export para componente principal
export default function UserProfile() {
  // implementação
}

// ✅ DO: Named export para utilitários
export function formatUserName(user: User): string {
  return `${user.firstName} ${user.lastName}`;
}
```

## 6. Performance

### 6.1. Otimizações
* **Dynamic Imports:** Use dynamic imports para code splitting.
* **Image Optimization:** Use o componente Image do Next.js.
* **Lazy Loading:** Implemente lazy loading quando apropriado.

```tsx
// ✅ DO: Dynamic import
const HeavyComponent = dynamic(() => import('./HeavyComponent'), {
  loading: () => <div>Loading...</div>
});

// ✅ DO: Next.js Image
import Image from 'next/image';

export function UserAvatar({ user }: { user: User }) {
  return (
    <Image
      src={user.avatar}
      alt={`${user.name} avatar`}
      width={40}
      height={40}
      className="rounded-full"
    />
  );
}
