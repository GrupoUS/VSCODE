# Laravel Stack: PHP, Livewire & Tooling

## 1. PHP & Laravel Best Practices

### 1.1. PHP Moderno
* **PHP 8.1+:** Use recursos do PHP 8.1+ quando apropriado (ex: propriedades tipadas, `readonly`, `enum`, expressões `match`).
* **Padrões:** Siga os padrões de codificação PSR-12 e habilite tipagem estrita com `declare(strict_types=1);`.

### 1.2. Arquitetura
* **MVC:** Use a arquitetura MVC do Laravel como base.
* **Repository Pattern:** Empregue o Repository Pattern para lógica complexa de acesso a dados, separando-a dos models Eloquent.
* **Events & Listeners:** Utilize o sistema de Events e Listeners do Laravel para lógica de aplicação desacoplada.

### 1.3. Roteamento & Requests
* **Sistema de Rotas:** Use o sistema de roteamento do Laravel para definir todos os endpoints da aplicação.
* **Form Requests:** Implemente validação de request usando Form Requests para qualquer lógica de validação não trivial.
* **Middleware:** Use Middleware para filtragem, autenticação e modificação de requests.

### 1.4. Database & Eloquent
* **Eloquent ORM:** Use o Eloquent ORM para todas as interações padrão com banco de dados. Defina relacionamentos de model claramente.
* **Query Builder:** Use o Query Builder para queries complexas que são difíceis de expressar com Eloquent.
* **Migrations:** Implemente migrations de banco de dados para gerenciamento de schema e seeders para dados iniciais.
* **Transações:** Use transações de banco de dados para garantir integridade de dados durante operações multi-step.
* **Indexação:** Implemente indexação adequada de banco de dados para melhorar performance de queries.

### 1.5. Performance & Escalabilidade
* **Cache:** Utilize mecanismos de cache do Laravel (Redis, Memcached) para performance.
* **Job Queues:** Transfira tarefas de longa duração para Job Queues.
* **Scheduling:** Use recursos de agendamento built-in do Laravel para tarefas recorrentes (cron jobs).
* **Paginação:** Use paginação para exibir grandes conjuntos de dados.

### 1.6. Segurança
* **Autenticação & Autorização:** Use recursos built-in de autenticação e autorização do Laravel (Gates, Policies).
* **Proteção CSRF:** Garanta que a proteção CSRF adequada esteja ativa.

### 1.7. Tooling
* **Asset Compilation:** Use Laravel Mix ou Vite para compilação de assets.
* **Testes:** Escreva testes unitários e de feature usando PHPUnit e Pest. Use Dusk para testes de automação de browser.
* **Localização:** Use recursos de localização do Laravel para suporte multi-idioma.
* **APIs:** Para APIs, implemente versionamento e use API Resources para transformação de dados.

## 2. Livewire & Alpine.js

### 2.1. Livewire
* **UIs Dinâmicas:** Use Livewire para componentes dinâmicos e interações de usuário em tempo real. Decomponha UIs complexas em componentes Livewire menores e aninhados.
* **Reatividade:** Gerencie estado e manipulação de formulários usando propriedades e ações Livewire com `wire:model`.
* **Lifecycle Hooks:** Aproveite os lifecycle hooks do Livewire (`mount`, `updating`, `updated`, etc.) para lógica de componente.
* **Experiência do Usuário:** Use `wire:loading` e `wire:target` para fornecer feedback visual durante requests de rede.

### 2.2. Alpine.js
* **Interação JavaScript:** Use Alpine.js para interações leves do lado do cliente que não requerem uma ida ao servidor.
* **Complemento ao Livewire:** Alpine.js deve complementar, não substituir, a funcionalidade do Livewire.

## 3. Padrões Específicos do Laravel

### 3.1. Estrutura de Arquivos
```
app/
├── Http/
│   ├── Controllers/
│   ├── Middleware/
│   ├── Requests/
│   └── Resources/
├── Models/
├── Services/
├── Repositories/
└── Events/
```

### 3.2. Nomenclatura
* **Controllers:** Use sufixo `Controller` (ex: `UserController`)
* **Models:** Use singular (ex: `User`, não `Users`)
* **Migrations:** Use formato descritivo (ex: `create_users_table`)
* **Jobs:** Use verbos descritivos (ex: `SendWelcomeEmail`)

### 3.3. Validação
```php
// ✅ DO: Use Form Requests para validação complexa
class StoreUserRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8|confirmed',
        ];
    }
}

// ❌ DON'T: Validação inline em controllers para lógica complexa
public function store(Request $request)
{
    $request->validate([
        'email' => 'required|email|unique:users',
        // ... muitas regras
    ]);
}
```

### 3.4. Eloquent Relationships
```php
// ✅ DO: Defina relacionamentos claramente
class User extends Model
{
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
    
    public function profile(): HasOne
    {
        return $this->hasOne(Profile::class);
    }
}
