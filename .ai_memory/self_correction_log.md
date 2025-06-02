# Log de Auto-Correção e Aprendizado

Este arquivo registra todos os erros, soluções e aprendizados do sistema para evolução contínua.

---

## Exemplo de Entrada (Para Referência)

**### Análise de Correção - [2025-01-15 14:30:22] ###**

**1. Tarefa Solicitada:**
   - Criar componente de perfil de usuário com dados do Supabase

**2. Comando/Ação que Falhou:**
   - Query Supabase: `supabase.from('profiles').select('*').eq('id', userId)`

**3. Saída do Erro:**
```
Error: Row Level Security policy violation
Details: Policy "Users can view own profile" failed for table "profiles"
```

**4. Análise da Causa Raiz:**
- O erro ocorreu porque a política RLS estava configurada para verificar `auth.uid()` mas a query não estava sendo executada no contexto de um usuário autenticado. A política esperava `auth.uid() = user_id` mas o `auth.uid()` retornava null.

**5. Ação Corretiva Implementada:**
- Adicionei verificação de autenticação antes da query: `const { data: { user } } = await supabase.auth.getUser()` e modifiquei a query para usar o ID do usuário autenticado.

**6. Sugestão de Melhoria para as Regras:**
- Sugiro adicionar ao `coding_standards/03_nextjs_stack.md` na seção de Supabase: "Sempre verificar autenticação antes de queries que dependem de RLS. Use `supabase.auth.getUser()` para obter o usuário atual e validar se está autenticado antes de executar queries em tabelas com RLS ativo."

---

*[Futuras entradas de log serão adicionadas aqui automaticamente pelo protocolo de auto-melhoria]*
