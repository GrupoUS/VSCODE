## Regra: Sistema Inteligente de Edição de Arquivos

### DETECÇÃO AUTOMÁTICA DE ERRO
```yaml
error_patterns:
  - "Invalid REPLACE marker detected"
  - "could not find matching SEARCH block"
  - "SEARCH block content doesn't match"

auto_fallback: true
max_replace_attempts: 2
```

### WORKFLOW AUTOMÁTICO
```python
def smart_file_edit(file_path, old_content, new_content):
    """
    Função que tenta replace_in_file primeiro,
    com fallback automático para write_to_file
    """
    attempts = 0
    max_attempts = 2
    
    while attempts < max_attempts:
        try:
            # Tentar replace_in_file
            replace_in_file(
                path=file_path,
                search=old_content,
                replace=new_content
            )
            print(f"✅ Sucesso com replace_in_file")
            return True
        except ReplaceError as e:
            attempts += 1
            print(f"⚠️ Tentativa {attempts} falhou: {e}")
            
            if attempts >= max_attempts:
                print("🔄 Executando fallback para write_to_file...")
                
                # Fallback: Ler → Modificar → Escrever
                content = read_file(file_path)
                modified = content.replace(old_content, new_content)
                write_to_file(file_path, modified)
                
                print("✅ Sucesso com write_to_file (fallback)")
                
                # Registrar na memória
                log_to_memory(f"Fallback usado em: {file_path}")
                return True
```

### PREVENÇÃO PROATIVA
Antes de replace_in_file:
- Normalizar whitespace: `text.strip().replace('\r\n', '\n')`
- Verificar encoding: UTF-8
- Confirmar existência do conteúdo

Blocos SEARCH otimizados:
- Máximo 5 linhas por bloco
- Evitar caracteres especiais problemáticos
- Incluir contexto único mínimo

### MEMORY BANK PATTERN
```json
{
  "file": "path/to/file",
  "error_type": "replace_in_file_mismatch",
  "solution": "write_to_file_fallback",
  "timestamp": "2025-06-04T10:30:00Z",
  "prevention": "normalize_whitespace"
}
