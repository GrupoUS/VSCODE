# 🚀 LARAVEL & LIVEWIRE STANDARDS - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Comprehensive standards for Laravel with Livewire and Alpine.js integration. These standards ensure robust, scalable, and maintainable PHP applications following modern Laravel best practices.

## 🏗️ LARAVEL ARCHITECTURE

### **1. PHP Modern Standards**
- **PHP 8.1+**: Use modern PHP features (typed properties, `readonly`, `enum`, `match` expressions)
- **Strict Types**: Enable strict typing with `declare(strict_types=1);`
- **PSR-12**: Follow PSR-12 coding standards

```php
<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\User;
use App\Repositories\UserRepositoryInterface;

final readonly class UserService
{
    public function __construct(
        private UserRepositoryInterface $userRepository
    ) {}
    
    public function createUser(array $data): User
    {
        return $this->userRepository->create($data);
    }
}
```

### **2. MVC Architecture**
- **Controllers**: Handle HTTP requests and responses
- **Models**: Represent data and business logic
- **Views**: Handle presentation layer
- **Services**: Contain business logic
- **Repositories**: Abstract data access layer

```php
// ✅ GOOD: Clean controller with service injection
class UserController extends Controller
{
    public function __construct(
        private UserService $userService
    ) {}
    
    public function store(StoreUserRequest $request): RedirectResponse
    {
        $user = $this->userService->createUser($request->validated());
        
        return redirect()
            ->route('users.show', $user)
            ->with('success', 'User created successfully');
    }
}
```

### **3. Repository Pattern**
- **Interface-Based**: Use interfaces for repository contracts
- **Dependency Injection**: Inject repositories into services
- **Complex Queries**: Separate complex data access logic

```php
// ✅ GOOD: Repository interface
interface UserRepositoryInterface
{
    public function create(array $data): User;
    public function findByEmail(string $email): ?User;
    public function getActiveUsers(): Collection;
}

// ✅ GOOD: Repository implementation
class UserRepository implements UserRepositoryInterface
{
    public function create(array $data): User
    {
        return User::create($data);
    }
    
    public function findByEmail(string $email): ?User
    {
        return User::where('email', $email)->first();
    }
    
    public function getActiveUsers(): Collection
    {
        return User::where('is_active', true)
            ->with(['profile', 'roles'])
            ->get();
    }
}
```

## 🗄️ DATABASE & ELOQUENT

### **1. Eloquent Models**
- **Relationships**: Define clear model relationships
- **Fillable/Guarded**: Properly configure mass assignment protection
- **Casts**: Use attribute casting for data types

```php
// ✅ GOOD: Well-defined model
class User extends Authenticatable
{
    protected $fillable = [
        'name',
        'email',
        'password',
    ];
    
    protected $hidden = [
        'password',
        'remember_token',
    ];
    
    protected $casts = [
        'email_verified_at' => 'datetime',
        'is_active' => 'boolean',
        'settings' => 'array',
    ];
    
    // Relationships
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
    
    public function profile(): HasOne
    {
        return $this->hasOne(Profile::class);
    }
    
    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class);
    }
}
```

### **2. Migrations & Database Design**
- **Descriptive Names**: Use clear migration names
- **Indexes**: Add appropriate database indexes
- **Foreign Keys**: Define foreign key constraints

```php
// ✅ GOOD: Well-structured migration
public function up(): void
{
    Schema::create('posts', function (Blueprint $table) {
        $table->id();
        $table->string('title');
        $table->text('content');
        $table->string('slug')->unique();
        $table->enum('status', ['draft', 'published', 'archived'])
              ->default('draft');
        $table->foreignId('user_id')
              ->constrained()
              ->onDelete('cascade');
        $table->timestamp('published_at')->nullable();
        $table->timestamps();
        
        // Indexes
        $table->index(['status', 'published_at']);
        $table->index('slug');
    });
}
```

### **3. Query Optimization**
- **Eager Loading**: Use `with()` to prevent N+1 queries
- **Query Builder**: Use for complex queries
- **Database Transactions**: Use for multi-step operations

```php
// ✅ GOOD: Optimized queries with eager loading
public function getPublishedPostsWithAuthors(): Collection
{
    return Post::with(['user:id,name,email', 'categories'])
        ->where('status', 'published')
        ->where('published_at', '<=', now())
        ->orderBy('published_at', 'desc')
        ->get();
}

// ✅ GOOD: Database transaction
public function transferUserData(User $fromUser, User $toUser): void
{
    DB::transaction(function () use ($fromUser, $toUser) {
        $fromUser->posts()->update(['user_id' => $toUser->id]);
        $fromUser->comments()->update(['user_id' => $toUser->id]);
        $fromUser->delete();
    });
}
```

## 🔄 LIVEWIRE COMPONENTS

### **1. Component Structure**
- **Single Responsibility**: Each component should have a single, clear purpose
- **Nested Components**: Break complex UIs into smaller, nested components
- **Lifecycle Hooks**: Use appropriate lifecycle hooks

```php
// ✅ GOOD: Well-structured Livewire component
class UserProfile extends Component
{
    public User $user;
    public bool $editing = false;
    
    protected $rules = [
        'user.name' => 'required|string|max:255',
        'user.email' => 'required|email|unique:users,email',
    ];
    
    public function mount(User $user): void
    {
        $this->user = $user;
    }
    
    public function startEditing(): void
    {
        $this->editing = true;
    }
    
    public function save(): void
    {
        $this->validate();
        
        $this->user->save();
        $this->editing = false;
        
        $this->dispatch('user-updated', $this->user->id);
        session()->flash('success', 'Profile updated successfully');
    }
    
    public function render(): View
    {
        return view('livewire.user-profile');
    }
}
```

### **2. Data Binding & Reactivity**
- **Wire:model**: Use for form inputs and reactive data
- **Wire:loading**: Provide visual feedback during requests
- **Wire:target**: Target specific actions for loading states

```blade
{{-- ✅ GOOD: Livewire template with proper binding --}}
<div>
    @if($editing)
        <form wire:submit="save">
            <div class="form-group">
                <label for="name">Name</label>
                <input 
                    type="text" 
                    id="name"
                    wire:model="user.name"
                    class="form-control @error('user.name') is-invalid @enderror"
                >
                @error('user.name')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input 
                    type="email" 
                    id="email"
                    wire:model="user.email"
                    class="form-control @error('user.email') is-invalid @enderror"
                >
                @error('user.email')
                    <div class="invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
            
            <button 
                type="submit" 
                class="btn btn-primary"
                wire:loading.attr="disabled"
                wire:target="save"
            >
                <span wire:loading.remove wire:target="save">Save</span>
                <span wire:loading wire:target="save">Saving...</span>
            </button>
        </form>
    @else
        <div class="profile-display">
            <h3>{{ $user->name }}</h3>
            <p>{{ $user->email }}</p>
            <button wire:click="startEditing" class="btn btn-secondary">
                Edit Profile
            </button>
        </div>
    @endif
</div>
```

### **3. Component Communication**
- **Events**: Use events for component communication
- **Properties**: Pass data through component properties
- **Dispatch**: Dispatch events to parent components or browser

```php
// ✅ GOOD: Event-driven component communication
class PostList extends Component
{
    public Collection $posts;
    
    protected $listeners = [
        'post-created' => 'refreshPosts',
        'post-deleted' => 'removePost',
    ];
    
    public function refreshPosts(): void
    {
        $this->posts = Post::with('user')->latest()->get();
    }
    
    public function removePost(int $postId): void
    {
        $this->posts = $this->posts->reject(fn($post) => $post->id === $postId);
    }
}
```

## 🎨 ALPINE.JS INTEGRATION

### **1. Client-Side Interactivity**
- **Lightweight Interactions**: Use Alpine.js for simple client-side interactions
- **Complement Livewire**: Alpine should complement, not replace Livewire
- **No Server Round-trips**: Use for interactions that don't need server communication

```blade
{{-- ✅ GOOD: Alpine.js for client-side interactions --}}
<div x-data="{ 
    open: false,
    search: '',
    get filteredItems() {
        return this.search === '' 
            ? this.items 
            : this.items.filter(item => 
                item.name.toLowerCase().includes(this.search.toLowerCase())
            )
    }
}">
    <button @click="open = !open" class="btn btn-primary">
        Toggle Dropdown
    </button>
    
    <div x-show="open" x-transition class="dropdown-menu">
        <input 
            x-model="search" 
            placeholder="Search items..."
            class="form-control mb-2"
        >
        
        <template x-for="item in filteredItems" :key="item.id">
            <div x-text="item.name" class="dropdown-item"></div>
        </template>
    </div>
</div>
```

## 🔒 SECURITY & VALIDATION

### **1. Form Requests**
- **Complex Validation**: Use Form Requests for complex validation logic
- **Authorization**: Include authorization logic in Form Requests
- **Custom Rules**: Create custom validation rules when needed

```php
// ✅ GOOD: Comprehensive Form Request
class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', Post::class);
    }
    
    public function rules(): array
    {
        return [
            'title' => 'required|string|max:255|unique:posts,title',
            'content' => 'required|string|min:100',
            'category_id' => 'required|exists:categories,id',
            'tags' => 'array|max:5',
            'tags.*' => 'string|max:50',
            'featured_image' => 'nullable|image|max:2048',
            'published_at' => 'nullable|date|after:now',
        ];
    }
    
    public function messages(): array
    {
        return [
            'content.min' => 'Post content must be at least 100 characters long.',
            'tags.max' => 'You can only add up to 5 tags.',
        ];
    }
}
```

### **2. Authentication & Authorization**
- **Gates & Policies**: Use Laravel's authorization system
- **Middleware**: Implement custom middleware for complex authorization
- **CSRF Protection**: Ensure CSRF protection is active

```php
// ✅ GOOD: Policy-based authorization
class PostPolicy
{
    public function view(User $user, Post $post): bool
    {
        return $post->is_published || $user->id === $post->user_id;
    }
    
    public function update(User $user, Post $post): bool
    {
        return $user->id === $post->user_id || $user->hasRole('admin');
    }
    
    public function delete(User $user, Post $post): bool
    {
        return $user->id === $post->user_id || $user->hasRole('admin');
    }
}
```

## ⚡ PERFORMANCE & OPTIMIZATION

### **1. Caching Strategies**
- **Query Caching**: Cache expensive database queries
- **View Caching**: Cache rendered views when appropriate
- **Redis**: Use Redis for session and cache storage

```php
// ✅ GOOD: Strategic caching
class PostService
{
    public function getPopularPosts(): Collection
    {
        return Cache::remember('popular_posts', 3600, function () {
            return Post::with(['user', 'categories'])
                ->where('published_at', '<=', now())
                ->orderBy('views_count', 'desc')
                ->limit(10)
                ->get();
        });
    }
    
    public function clearPostCache(): void
    {
        Cache::forget('popular_posts');
        Cache::tags(['posts'])->flush();
    }
}
```

### **2. Queue Jobs**
- **Background Processing**: Move time-consuming tasks to queues
- **Job Batching**: Use job batching for related tasks
- **Failed Job Handling**: Implement proper failed job handling

```php
// ✅ GOOD: Queue job implementation
class SendWelcomeEmail implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
    
    public function __construct(
        private User $user
    ) {}
    
    public function handle(MailService $mailService): void
    {
        $mailService->sendWelcomeEmail($this->user);
    }
    
    public function failed(Throwable $exception): void
    {
        Log::error('Failed to send welcome email', [
            'user_id' => $this->user->id,
            'error' => $exception->getMessage(),
        ]);
    }
}
```

## 🧪 TESTING STANDARDS

### **1. Feature Tests**
- **HTTP Tests**: Test complete request/response cycles
- **Database Testing**: Use database transactions for test isolation
- **Authentication**: Test with different user roles

```php
// ✅ GOOD: Comprehensive feature test
class PostManagementTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_authenticated_user_can_create_post(): void
    {
        $user = User::factory()->create();
        $category = Category::factory()->create();
        
        $response = $this->actingAs($user)
            ->post('/posts', [
                'title' => 'Test Post',
                'content' => 'This is a test post content that is long enough.',
                'category_id' => $category->id,
            ]);
            
        $response->assertRedirect();
        $this->assertDatabaseHas('posts', [
            'title' => 'Test Post',
            'user_id' => $user->id,
        ]);
    }
    
    public function test_guest_cannot_create_post(): void
    {
        $response = $this->post('/posts', [
            'title' => 'Test Post',
            'content' => 'Test content',
        ]);
        
        $response->assertRedirect('/login');
    }
}
```

---

**These standards ensure robust, secure, and maintainable Laravel applications with modern PHP practices and optimal Livewire integration.**
