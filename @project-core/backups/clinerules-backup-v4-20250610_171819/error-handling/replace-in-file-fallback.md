---
description: Regra para fallback automático de replace_in_file para write_to_file.
globs: ["**/*"]
alwaysApply: true
---

# Regra: Fallback Automático para write_to_file

## Contexto
Quando `replace_in_file` falha após 2 tentativas, usar automaticamente `write_to_file`.

## Implementação
1. **Primeira tentativa**: Use SEARCH block completo.
2. **Segunda tentativa**: Use SEARCH block mínimo (1-3 linhas).
3. **Terceira ação**: Fallback para `write_to_file`.

## Workflow
```yaml
on_error: replace_in_file
max_retries: 2
fallback_strategy:
  - read_file: obter conteúdo atual
  - modify_in_memory: aplicar mudanças
  - write_to_file: sobrescrever arquivo
  - validate: verificar mudanças aplicadas
```

## Prevenção
- Sempre verificar espaços em branco e quebras de linha.
- Usar `read_file` antes de `replace_in_file` para confirmar conteúdo.
- Preferir blocos SEARCH pequenos e únicos.
- Documentar no `memory bank` quando fallback foi usado.

## Snippets Práticos

### 1. Script de Validação (`validate-replace.js`):
```javascript
// Função para validar conteúdo antes de replace
function validateSearchBlock(filePath, searchContent) {
  const fileContent = fs.readFileSync(filePath, 'utf8');
  const normalizedFile = fileContent.replace(/\r\n/g, '\n').trim();
  const normalizedSearch = searchContent.replace(/\r\n/g, '\n').trim();

  return normalizedFile.includes(normalizedSearch);
}
```

### 2. Workflow Automático (`.taskmaster/workflows/file-edit.yml`):
```yaml
name: Smart File Edit
steps:
  - name: Read Current Content
    tool: read_file
    params:
      path: $FILE_PATH

  - name: Try Replace
    tool: replace_in_file
    params:
      path: $FILE_PATH
      diff: $SEARCH_REPLACE_BLOCK
    on_error:
      - name: Fallback to Write
        tool: write_to_file
        params:
          path: $FILE_PATH
          content: $MODIFIED_CONTENT
