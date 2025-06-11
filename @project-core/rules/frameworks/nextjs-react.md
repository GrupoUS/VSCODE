# 🚀 NEXT.JS & REACT STANDARDS - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Comprehensive standards for Next.js 14+ with React, TypeScript, and Supabase integration. These standards ensure optimal performance, security, and maintainability for modern web applications.

## 🚨 REGRAS CRÍTICAS DE PREVENÇÃO DE CONFLITOS (BUG-001)

### **REGRA FUNDAMENTAL: ESTRUTURA ÚNICA OBRIGATÓRIA**

❌ **NUNCA PERMITIR**: Estruturas `app/` e `src/app/` simultaneamente
✅ **SEMPRE VALIDAR**: Consistência estrutural antes de qualquer mudança
🔍 **PROTOCOLO OBRIGATÓRIO**: Validação pré-estrutural em todos os projetos

### **Validação Automática Obrigatória:**

```bash
# EXECUTAR ANTES DE QUALQUER MUDANÇA ESTRUTURAL
if (Test-Path "app") -and (Test-Path "src/app") {
    Write-Error "🚨 CONFLITO CRÍTICO: Estruturas duplicadas detectadas"
    Write-Error "📋 AÇÃO REQUERIDA: Executar protocolo de resolução de conflitos"
    exit 1
}
```

### **Estruturas Suportadas (APENAS UMA POR PROJETO):**

1. **✅ Padrão Moderno (Recomendado)**: `src/app/` + tsconfig `@/*: ["./src/*"]`
2. **✅ Padrão Clássico**: `app/` + tsconfig `@/*: ["./"]`

### **Protocolo de Emergência (Se Conflito Detectado):**

1. **🛑 PARAR** desenvolvimento imediatamente
2. **💾 BACKUP** estrutura conflitante
3. **🧹 LIMPAR** cache completamente (.next, node_modules)
4. **🔧 RESOLVER** conflito mantendo apenas uma estrutura
5. **✅ VALIDAR** funcionamento antes de continuar

### **Referência Completa**: `@file:memory-bank/protocols/nextjs-structure-validation.md`

## 🔗 RULE DEPENDENCIES

**This rule extends and implements:**

- `@file:project-core/rules/01-core-principles.md` - Foundation principles for all development
- `@file:project-core/rules/02-coding-standards-universal.md` - Universal coding standards
- `@file:project-core/rules/00-master-execution-protocol.md` - Master execution framework

**Related MCP Integrations:**

- `@file:project-core/rules/mcp-integration/supabase-database.md` - Database integration patterns
- `@file:project-core/rules/mcp-integration/figma-design-sync.md` - Design-to-code workflows

## 🏗️ COMPONENT ARCHITECTURE

### **1. File Naming & Organization**

- **File Names**: Use `kebab-case` for component files (e.g., `user-profile.tsx`)
- **Folder Structure**: Organize components by functionality or domain
- **Index Files**: Use `index.ts` for clean imports

```
src/
├── components/
│   ├── ui/                 # Reusable UI components
│   ├── forms/              # Form components
│   └── layout/             # Layout components
├── app/                    # Next.js 14 App Router
├── lib/                    # Utilities and configurations
└── types/                  # TypeScript type definitions
```

### **2. React Server Components (RSC) - Priority**

- **Default Choice**: Use React Server Components by default for optimal performance
- **Benefits**: Server-side rendering, direct database access, better initial performance, SEO optimization

```tsx
// ✅ GOOD: Server Component by default
export default async function UserProfile({ userId }: { userId: string }) {
  const user = await getUser(userId);

  return (
    <div>
      <h1>{user.name}</h1>
      <UserActions userId={userId} /> {/* Isolated Client Component */}
    </div>
  );
}
```

### **3. Client Components - Minimize Usage**

- **Isolation**: Isolate client-side interactivity (`'use client'`) to smallest leaf components
- **Use Cases**: onClick handlers, local state, React hooks, browser APIs

```tsx
// ✅ GOOD: Isolated Client Component for interactivity
"use client";
export function UserActions({ userId }: { userId: string }) {
  const [isEditing, setIsEditing] = useState(false);

  const handleEdit = () => setIsEditing(true);

  return (
    <button onClick={handleEdit} className="btn btn-primary">
      {isEditing ? "Editing..." : "Edit Profile"}
    </button>
  );
}
```

## 📊 DATA FETCHING PATTERNS

### **1. Server Components Data Fetching**

- **Async/Await**: Use async/await for data fetching in Server Components
- **Direct Database Access**: Leverage direct database queries for optimal performance

```tsx
// ✅ GOOD: Data fetching in Server Component
export default async function PostsList() {
  const posts = await getPosts();

  if (!posts.length) {
    return <EmptyState message="No posts found" />;
  }

  return (
    <div className="grid gap-4">
      {posts.map((post) => (
        <PostCard key={post.id} post={post} />
      ))}
    </div>
  );
}
```

### **2. Loading & Error States (MANDATORY)**

- **Always Implement**: Loading and error states must be implemented and displayed
- **Suspense**: Use Suspense for loading states in Server Components
- **Error Boundaries**: Use Error Boundaries for error handling

```tsx
// ✅ GOOD: Loading state with Suspense
export default function PostsPage() {
  return (
    <Suspense fallback={<PostsLoading />}>
      <PostsList />
    </Suspense>
  );
}

// ✅ GOOD: Error Boundary
export default function PostsLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <ErrorBoundary fallback={<PostsError />}>{children}</ErrorBoundary>;
}

// ✅ GOOD: Loading component
export function PostsLoading() {
  return (
    <div className="grid gap-4">
      {Array.from({ length: 3 }).map((_, i) => (
        <div key={i} className="skeleton h-32 w-full" />
      ))}
    </div>
  );
}
```

### **3. Client-Side Data Fetching**

- **SWR/React Query**: Use for client-side data fetching when needed
- **Error Handling**: Always handle loading and error states

```tsx
// ✅ GOOD: Client-side data fetching with SWR
"use client";
import useSWR from "swr";

export function UserStats({ userId }: { userId: string }) {
  const {
    data: stats,
    error,
    isLoading,
  } = useSWR(`/api/users/${userId}/stats`, fetcher);

  if (isLoading) return <StatsLoading />;
  if (error) return <StatsError error={error} />;

  return <StatsDisplay stats={stats} />;
}
```

## 🗄️ SUPABASE INTEGRATION

### **1. Configuration & Setup**

- **Environment Variables**: Properly configure Supabase environment variables
- **Client Setup**: Use appropriate Supabase client for server/client contexts

```typescript
// lib/supabase/server.ts
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";

export function createClient() {
  const cookieStore = cookies();

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value;
        },
      },
    }
  );
}
```

### **2. Security - Row Level Security (RLS)**

- **Always Use RLS**: Implement proper Row Level Security policies
- **Authentication**: Implement proper authentication using Supabase Auth

```sql
-- ✅ GOOD: Proper RLS policies
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Public profiles are viewable by everyone" ON profiles
  FOR SELECT USING (is_public = true);
```

### **3. Database Queries**

- **Error Handling**: Always handle database errors properly
- **Type Safety**: Use generated Supabase types

```tsx
// ✅ GOOD: Query with proper error handling
export async function getUser(userId: string) {
  const supabase = createClient();

  const { data, error } = await supabase
    .from("users")
    .select("*")
    .eq("id", userId)
    .single();

  if (error) {
    throw new Error(`Failed to fetch user: ${error.message}`);
  }

  return data;
}

// ✅ GOOD: Authentication check before RLS-dependent queries
export async function getUserProfile(userId: string) {
  const supabase = createClient();

  // Verify authentication before RLS-dependent query
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    throw new Error("User not authenticated");
  }

  const { data, error } = await supabase
    .from("profiles")
    .select("*")
    .eq("user_id", userId)
    .single();

  if (error) {
    throw new Error(`Failed to fetch profile: ${error.message}`);
  }

  return data;
}
```

## 🔷 TYPESCRIPT STANDARDS

### **1. Strict Typing**

- **Strict Mode**: Use TypeScript in strict mode
- **Explicit Types**: Define explicit types for props, state, and functions
- **No Any**: Avoid `any` type - use proper typing

```tsx
// ✅ GOOD: Explicit types
interface UserProfileProps {
  userId: string;
  showActions?: boolean;
  className?: string;
}

export default function UserProfile({
  userId,
  showActions = true,
  className,
}: UserProfileProps) {
  // implementation
}
```

### **2. Supabase Types**

- **Generated Types**: Use automatically generated Supabase types
- **Database Sync**: Keep database types synchronized

```tsx
// ✅ GOOD: Use Supabase types
import { Database } from "@/types/supabase";

type User = Database["public"]["Tables"]["users"]["Row"];
type UserInsert = Database["public"]["Tables"]["users"]["Insert"];
type UserUpdate = Database["public"]["Tables"]["users"]["Update"];

interface UserCardProps {
  user: User;
  onUpdate?: (user: UserUpdate) => void;
}
```

## 🎨 STYLING STANDARDS

### **1. Tailwind CSS + Shadcn/ui**

- **Utility-First**: Use Tailwind CSS utility classes
- **Component Library**: Use Shadcn/ui for consistent UI components
- **Custom Components**: Build custom components on top of Shadcn/ui

```tsx
// ✅ GOOD: Tailwind + Shadcn/ui usage
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export function UserCard({ user }: { user: User }) {
  return (
    <Card className="w-full max-w-md">
      <CardHeader>
        <CardTitle className="text-lg font-semibold">{user.name}</CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-muted-foreground">{user.email}</p>
        <Button className="mt-4 w-full" variant="outline">
          View Profile
        </Button>
      </CardContent>
    </Card>
  );
}
```

### **2. Responsive Design**

- **Mobile-First**: Design mobile-first with responsive breakpoints
- **Consistent Spacing**: Use Tailwind spacing scale consistently

```tsx
// ✅ GOOD: Responsive design
export function ResponsiveGrid({ children }: { children: React.ReactNode }) {
  return (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      {children}
    </div>
  );
}
```

## ⚡ PERFORMANCE OPTIMIZATION

### **1. Code Splitting & Lazy Loading**

- **Dynamic Imports**: Use dynamic imports for code splitting
- **Lazy Loading**: Implement lazy loading for heavy components

```tsx
// ✅ GOOD: Dynamic import with loading state
const HeavyComponent = dynamic(() => import("./HeavyComponent"), {
  loading: () => <div className="skeleton h-32 w-full" />,
  ssr: false, // if component requires client-side only
});
```

### **2. Image Optimization**

- **Next.js Image**: Always use Next.js Image component
- **Proper Sizing**: Specify width and height for layout stability

```tsx
// ✅ GOOD: Optimized image usage
import Image from "next/image";

export function UserAvatar({ user }: { user: User }) {
  return (
    <Image
      src={user.avatar || "/default-avatar.png"}
      alt={`${user.name} avatar`}
      width={40}
      height={40}
      className="rounded-full object-cover"
      priority={false} // Set to true for above-the-fold images
    />
  );
}
```

### **3. Bundle Optimization**

- **Tree Shaking**: Import only what you need
- **Bundle Analysis**: Regular bundle size analysis

```tsx
// ✅ GOOD: Specific imports
import { format } from "date-fns";
import { Button } from "@/components/ui/button";

// ❌ BAD: Importing entire library
import * as dateFns from "date-fns";
import * as UI from "@/components/ui";
```

## 🧪 TESTING STANDARDS

### **1. Component Testing**

- **React Testing Library**: Use React Testing Library for component tests
- **User-Centric**: Test from user perspective

```tsx
// ✅ GOOD: Component test
import { render, screen, fireEvent } from "@testing-library/react";
import { UserProfile } from "./UserProfile";

describe("UserProfile", () => {
  it("displays user information correctly", () => {
    const mockUser = { id: "1", name: "John Doe", email: "john@example.com" };

    render(<UserProfile user={mockUser} />);

    expect(screen.getByText("John Doe")).toBeInTheDocument();
    expect(screen.getByText("john@example.com")).toBeInTheDocument();
  });

  it("handles edit button click", () => {
    const mockOnEdit = jest.fn();
    const mockUser = { id: "1", name: "John Doe", email: "john@example.com" };

    render(<UserProfile user={mockUser} onEdit={mockOnEdit} />);

    fireEvent.click(screen.getByRole("button", { name: /edit/i }));

    expect(mockOnEdit).toHaveBeenCalledWith(mockUser);
  });
});
```

---

**These standards ensure high-quality, performant, and maintainable Next.js applications in the GRUPO US ecosystem.**
