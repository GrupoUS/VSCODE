# 🗄️ SUPABASE DATABASE PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Comprehensive protocol for Supabase integration, providing secure database operations, authentication management, real-time subscriptions, and storage solutions for modern web applications.

## 🚀 SUPABASE SETUP & CONFIGURATION

### **Project Configuration**
```bash
# Environment variables (.env.local)
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
SUPABASE_PROJECT_ID=your_project_id
SUPABASE_DATABASE_PASSWORD=your_database_password
```

### **Client Setup (Next.js App Router)**
```typescript
// lib/supabase/server.ts
import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';

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
        set(name: string, value: string, options: any) {
          cookieStore.set({ name, value, ...options });
        },
        remove(name: string, options: any) {
          cookieStore.set({ name, value: '', ...options });
        },
      },
    }
  );
}

// lib/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr';

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
}
```

### **Type Generation**
```bash
# Generate TypeScript types from database schema
npx supabase gen types typescript --project-id your_project_id > types/supabase.ts

# Update types when schema changes
npm run types:generate
```

## 🔒 SECURITY & ROW LEVEL SECURITY (RLS)

### **Mandatory RLS Implementation**
- **ALWAYS enable RLS** on all tables containing user data
- **Implement proper policies** for each operation (SELECT, INSERT, UPDATE, DELETE)
- **Test policies thoroughly** before deploying to production
- **Use auth.uid()** for user-specific data access

```sql
-- Enable RLS on table
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policy for users to view their own profile
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = user_id);

-- Policy for users to update their own profile
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = user_id);

-- Policy for users to insert their own profile
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Policy for public profiles
CREATE POLICY "Public profiles are viewable by everyone" ON profiles
  FOR SELECT USING (is_public = true);
```

### **Authentication Verification Pattern**
```typescript
// ALWAYS verify authentication before RLS-dependent queries
export async function getUserProfile(userId: string) {
  const supabase = createClient();
  
  // Verify authentication before RLS-dependent query
  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (authError || !user) {
    throw new Error('User not authenticated');
  }
  
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('user_id', userId)
    .single();
    
  if (error) {
    throw new Error(`Failed to fetch profile: ${error.message}`);
  }
  
  return data;
}
```

## 📊 DATABASE OPERATIONS

### **Query Patterns with Error Handling**
```typescript
// Type-safe database operations
import { Database } from '@/types/supabase';

type User = Database['public']['Tables']['users']['Row'];
type UserInsert = Database['public']['Tables']['users']['Insert'];
type UserUpdate = Database['public']['Tables']['users']['Update'];

export class UserService {
  private supabase = createClient();

  async createUser(userData: UserInsert): Promise<User> {
    const { data, error } = await this.supabase
      .from('users')
      .insert(userData)
      .select()
      .single();
      
    if (error) {
      throw new Error(`Failed to create user: ${error.message}`);
    }
    
    return data;
  }

  async getUserById(id: string): Promise<User | null> {
    const { data, error } = await this.supabase
      .from('users')
      .select('*')
      .eq('id', id)
      .single();
      
    if (error) {
      if (error.code === 'PGRST116') {
        return null; // No rows returned
      }
      throw new Error(`Failed to fetch user: ${error.message}`);
    }
    
    return data;
  }

  async updateUser(id: string, updates: UserUpdate): Promise<User> {
    const { data, error } = await this.supabase
      .from('users')
      .update(updates)
      .eq('id', id)
      .select()
      .single();
      
    if (error) {
      throw new Error(`Failed to update user: ${error.message}`);
    }
    
    return data;
  }

  async deleteUser(id: string): Promise<void> {
    const { error } = await this.supabase
      .from('users')
      .delete()
      .eq('id', id);
      
    if (error) {
      throw new Error(`Failed to delete user: ${error.message}`);
    }
  }

  async getUsersWithPagination(
    page: number = 1,
    limit: number = 10
  ): Promise<{ users: User[]; total: number }> {
    const offset = (page - 1) * limit;
    
    // Get total count
    const { count, error: countError } = await this.supabase
      .from('users')
      .select('*', { count: 'exact', head: true });
      
    if (countError) {
      throw new Error(`Failed to count users: ${countError.message}`);
    }
    
    // Get paginated data
    const { data, error } = await this.supabase
      .from('users')
      .select('*')
      .range(offset, offset + limit - 1)
      .order('created_at', { ascending: false });
      
    if (error) {
      throw new Error(`Failed to fetch users: ${error.message}`);
    }
    
    return {
      users: data || [],
      total: count || 0
    };
  }
}
```

### **Complex Queries with Joins**
```typescript
export async function getUsersWithProfiles() {
  const supabase = createClient();
  
  const { data, error } = await supabase
    .from('users')
    .select(`
      *,
      profiles (
        id,
        bio,
        avatar_url,
        website
      ),
      posts (
        id,
        title,
        created_at
      )
    `)
    .eq('is_active', true)
    .order('created_at', { ascending: false });
    
  if (error) {
    throw new Error(`Failed to fetch users with profiles: ${error.message}`);
  }
  
  return data;
}

// Advanced filtering and search
export async function searchUsers(query: string, filters: any = {}) {
  const supabase = createClient();
  
  let queryBuilder = supabase
    .from('users')
    .select(`
      *,
      profiles (*)
    `)
    .or(`name.ilike.%${query}%,email.ilike.%${query}%`);
    
  // Apply filters
  if (filters.role) {
    queryBuilder = queryBuilder.eq('role', filters.role);
  }
  
  if (filters.isActive !== undefined) {
    queryBuilder = queryBuilder.eq('is_active', filters.isActive);
  }
  
  if (filters.createdAfter) {
    queryBuilder = queryBuilder.gte('created_at', filters.createdAfter);
  }
  
  const { data, error } = await queryBuilder
    .order('created_at', { ascending: false })
    .limit(50);
    
  if (error) {
    throw new Error(`Search failed: ${error.message}`);
  }
  
  return data;
}
```

## 🔄 REAL-TIME SUBSCRIPTIONS

### **Real-time Data Synchronization**
```typescript
export class RealtimeService {
  private supabase = createClient();
  private subscriptions = new Map<string, any>();

  subscribeToTable(
    table: string,
    callback: (payload: any) => void,
    filter?: string
  ): string {
    const subscriptionId = `${table}-${Date.now()}`;
    
    let channel = this.supabase
      .channel(subscriptionId)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: table,
          filter: filter
        },
        callback
      );
      
    channel.subscribe();
    
    this.subscriptions.set(subscriptionId, channel);
    return subscriptionId;
  }

  subscribeToUserData(userId: string, callback: (payload: any) => void): string {
    return this.subscribeToTable(
      'profiles',
      callback,
      `user_id=eq.${userId}`
    );
  }

  unsubscribe(subscriptionId: string): void {
    const channel = this.subscriptions.get(subscriptionId);
    if (channel) {
      this.supabase.removeChannel(channel);
      this.subscriptions.delete(subscriptionId);
    }
  }

  unsubscribeAll(): void {
    for (const [id, channel] of this.subscriptions) {
      this.supabase.removeChannel(channel);
    }
    this.subscriptions.clear();
  }
}

// Usage in React component
export function useRealtimeData(table: string, filter?: string) {
  const [data, setData] = useState<any[]>([]);
  const realtimeService = useMemo(() => new RealtimeService(), []);

  useEffect(() => {
    const subscriptionId = realtimeService.subscribeToTable(
      table,
      (payload) => {
        console.log('Real-time update:', payload);
        
        switch (payload.eventType) {
          case 'INSERT':
            setData(prev => [...prev, payload.new]);
            break;
          case 'UPDATE':
            setData(prev => prev.map(item => 
              item.id === payload.new.id ? payload.new : item
            ));
            break;
          case 'DELETE':
            setData(prev => prev.filter(item => item.id !== payload.old.id));
            break;
        }
      },
      filter
    );

    return () => {
      realtimeService.unsubscribe(subscriptionId);
    };
  }, [table, filter, realtimeService]);

  return data;
}
```

## 🔐 AUTHENTICATION MANAGEMENT

### **Authentication Service**
```typescript
export class AuthService {
  private supabase = createClient();

  async signUp(email: string, password: string, metadata?: any) {
    const { data, error } = await this.supabase.auth.signUp({
      email,
      password,
      options: {
        data: metadata
      }
    });
    
    if (error) {
      throw new Error(`Sign up failed: ${error.message}`);
    }
    
    return data;
  }

  async signIn(email: string, password: string) {
    const { data, error } = await this.supabase.auth.signInWithPassword({
      email,
      password
    });
    
    if (error) {
      throw new Error(`Sign in failed: ${error.message}`);
    }
    
    return data;
  }

  async signOut() {
    const { error } = await this.supabase.auth.signOut();
    
    if (error) {
      throw new Error(`Sign out failed: ${error.message}`);
    }
  }

  async getCurrentUser() {
    const { data: { user }, error } = await this.supabase.auth.getUser();
    
    if (error) {
      throw new Error(`Failed to get current user: ${error.message}`);
    }
    
    return user;
  }

  async updateProfile(updates: any) {
    const { data, error } = await this.supabase.auth.updateUser({
      data: updates
    });
    
    if (error) {
      throw new Error(`Profile update failed: ${error.message}`);
    }
    
    return data;
  }

  onAuthStateChange(callback: (event: string, session: any) => void) {
    return this.supabase.auth.onAuthStateChange(callback);
  }
}
```

## 📁 STORAGE MANAGEMENT

### **File Upload and Management**
```typescript
export class StorageService {
  private supabase = createClient();

  async uploadFile(
    bucket: string,
    path: string,
    file: File,
    options?: any
  ): Promise<string> {
    const { data, error } = await this.supabase.storage
      .from(bucket)
      .upload(path, file, {
        cacheControl: '3600',
        upsert: false,
        ...options
      });
      
    if (error) {
      throw new Error(`File upload failed: ${error.message}`);
    }
    
    // Get public URL
    const { data: { publicUrl } } = this.supabase.storage
      .from(bucket)
      .getPublicUrl(data.path);
      
    return publicUrl;
  }

  async deleteFile(bucket: string, path: string): Promise<void> {
    const { error } = await this.supabase.storage
      .from(bucket)
      .remove([path]);
      
    if (error) {
      throw new Error(`File deletion failed: ${error.message}`);
    }
  }

  async listFiles(bucket: string, folder?: string) {
    const { data, error } = await this.supabase.storage
      .from(bucket)
      .list(folder, {
        limit: 100,
        offset: 0
      });
      
    if (error) {
      throw new Error(`Failed to list files: ${error.message}`);
    }
    
    return data;
  }

  getPublicUrl(bucket: string, path: string): string {
    const { data } = this.supabase.storage
      .from(bucket)
      .getPublicUrl(path);
      
    return data.publicUrl;
  }
}
```

## 🧪 TESTING & VALIDATION

### **Database Testing Patterns**
```typescript
// Test utilities
export class SupabaseTestUtils {
  private supabase = createClient();

  async createTestUser(overrides: Partial<UserInsert> = {}): Promise<User> {
    const userData: UserInsert = {
      email: `test-${Date.now()}@example.com`,
      name: 'Test User',
      ...overrides
    };
    
    const { data, error } = await this.supabase
      .from('users')
      .insert(userData)
      .select()
      .single();
      
    if (error) {
      throw new Error(`Failed to create test user: ${error.message}`);
    }
    
    return data;
  }

  async cleanupTestData(userIds: string[]): Promise<void> {
    const { error } = await this.supabase
      .from('users')
      .delete()
      .in('id', userIds);
      
    if (error) {
      console.error('Failed to cleanup test data:', error);
    }
  }

  async resetTestDatabase(): Promise<void> {
    // Only use in test environment
    if (process.env.NODE_ENV !== 'test') {
      throw new Error('resetTestDatabase can only be used in test environment');
    }
    
    // Implement database reset logic
    await this.supabase.rpc('reset_test_data');
  }
}

// Integration tests
describe('UserService', () => {
  let userService: UserService;
  let testUtils: SupabaseTestUtils;
  let createdUserIds: string[] = [];

  beforeEach(() => {
    userService = new UserService();
    testUtils = new SupabaseTestUtils();
  });

  afterEach(async () => {
    await testUtils.cleanupTestData(createdUserIds);
    createdUserIds = [];
  });

  it('should create a user successfully', async () => {
    const userData = {
      email: 'test@example.com',
      name: 'Test User'
    };
    
    const user = await userService.createUser(userData);
    createdUserIds.push(user.id);
    
    expect(user.email).toBe(userData.email);
    expect(user.name).toBe(userData.name);
  });

  it('should handle RLS policies correctly', async () => {
    // Test that RLS prevents unauthorized access
    const user = await testUtils.createTestUser();
    createdUserIds.push(user.id);
    
    // This should fail due to RLS
    await expect(
      userService.getUserById(user.id)
    ).rejects.toThrow();
  });
});
```

## 📊 PERFORMANCE OPTIMIZATION

### **Query Optimization Strategies**
- **Use indexes** for frequently queried columns
- **Limit result sets** with pagination
- **Use select()** to fetch only needed columns
- **Implement caching** for frequently accessed data
- **Use database functions** for complex operations

```sql
-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);

-- Composite index for complex queries
CREATE INDEX idx_posts_status_created ON posts(status, created_at DESC);
```

### **Caching Implementation**
```typescript
export class CachedUserService extends UserService {
  private cache = new Map<string, { data: any; timestamp: number }>();
  private cacheTimeout = 5 * 60 * 1000; // 5 minutes

  async getUserById(id: string): Promise<User | null> {
    const cacheKey = `user-${id}`;
    const cached = this.cache.get(cacheKey);
    
    if (cached && Date.now() - cached.timestamp < this.cacheTimeout) {
      return cached.data;
    }
    
    const user = await super.getUserById(id);
    
    this.cache.set(cacheKey, {
      data: user,
      timestamp: Date.now()
    });
    
    return user;
  }

  invalidateCache(id: string): void {
    this.cache.delete(`user-${id}`);
  }
}
```

---

**This protocol ensures secure, efficient, and scalable Supabase integration for all database operations, authentication, and storage needs in the GRUPO US ecosystem.**
