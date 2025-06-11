# PROTOCOLO DE VALIDAÇÃO DE ESTRUTURA NEXT.JS - GRUPO US

## 🎯 Objetivo
Prevenir conflitos de estrutura de diretórios em projetos Next.js que podem causar falhas críticas de compilação e execução.

## 🚨 Problema Identificado (BUG-001)
- **Estruturas Duplicadas**: `app/` na raiz + `src/app/` causam confusão no Next.js
- **Cache Corrompido**: Referências incorretas entre diretórios
- **Imports Fantasma**: Componentes referenciados mas inexistentes
- **Configuração Inconsistente**: tsconfig.json vs estrutura real

## ✅ CHECKLIST DE VALIDAÇÃO PRÉ-ESTRUTURAL

### **1. Verificação de Estrutura de Diretórios**
```bash
# Verificar se existe apenas UMA estrutura app
if (Test-Path "app") -and (Test-Path "src/app") {
    Write-Error "CONFLITO: Estruturas app/ e src/app/ coexistem"
    exit 1
}

# Verificar consistência com tsconfig.json
$tsconfig = Get-Content "tsconfig.json" | ConvertFrom-Json
if ($tsconfig.compilerOptions.paths."@/*"[0] -eq "./src/*") {
    if (Test-Path "app") {
        Write-Error "INCONSISTÊNCIA: tsconfig aponta para src/ mas app/ existe na raiz"
        exit 1
    }
}
```

### **2. Validação de Imports**
```bash
# Verificar se todos os imports existem
$layoutFile = "src/app/layout.tsx"
if (Test-Path $layoutFile) {
    $content = Get-Content $layoutFile
    foreach ($line in $content) {
        if ($line -match 'import.*from\s+["\']@/(.+)["\']') {
            $importPath = "src/$($matches[1])"
            if (-not (Test-Path $importPath)) {
                Write-Error "IMPORT FANTASMA: $importPath não existe"
                exit 1
            }
        }
    }
}
```

### **3. Verificação de Cache**
```bash
# Verificar cache corrompido
if (Test-Path ".next") {
    $cacheAge = (Get-Item ".next").LastWriteTime
    $srcAge = (Get-Item "src").LastWriteTime
    if ($cacheAge -lt $srcAge) {
        Write-Warning "CACHE DESATUALIZADO: Limpeza recomendada"
    }
}
```

## 🔧 PROTOCOLO DE CORREÇÃO AUTOMÁTICA

### **Fase 1: Backup e Análise**
```powershell
# Criar backup da estrutura conflitante
if (Test-Path "app") -and (Test-Path "src/app") {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    Compress-Archive -Path "app" -DestinationPath "backup-app-conflito-$timestamp.zip"
    Write-Host "✅ Backup criado: backup-app-conflito-$timestamp.zip"
}
```

### **Fase 2: Resolução de Conflitos**
```powershell
# Determinar estrutura correta baseada no tsconfig.json
$tsconfig = Get-Content "tsconfig.json" | ConvertFrom-Json
$usesSrc = $tsconfig.compilerOptions.paths."@/*"[0] -eq "./src/*"

if ($usesSrc -and (Test-Path "app")) {
    # Remover app/ da raiz se tsconfig usa src/
    Remove-Item -Path "app" -Recurse -Force
    Write-Host "✅ Estrutura app/ removida (mantendo src/app/)"
} elseif (-not $usesSrc -and (Test-Path "src/app")) {
    # Mover src/app/ para raiz se tsconfig não usa src/
    Move-Item -Path "src/app/*" -Destination "app/" -Force
    Remove-Item -Path "src/app" -Recurse -Force
    Write-Host "✅ Estrutura movida para app/ (removendo src/app/)"
}
```

### **Fase 3: Limpeza e Reinstalação**
```powershell
# Limpeza completa de cache
Remove-Item -Path ".next" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "node_modules" -Recurse -Force
Write-Host "✅ Cache e dependências removidos"

# Reinstalação
npm install
Write-Host "✅ Dependências reinstaladas"
```

## 🛡️ MEDIDAS PREVENTIVAS

### **1. Validação Pré-Commit**
```json
// package.json
{
  "scripts": {
    "pre-commit": "node scripts/validate-nextjs-structure.js",
    "validate": "powershell -File scripts/validate-structure.ps1"
  }
}
```

### **2. Script de Validação Automática**
```javascript
// scripts/validate-nextjs-structure.js
const fs = require('fs');
const path = require('path');

function validateNextJSStructure() {
    const hasAppRoot = fs.existsSync('app');
    const hasSrcApp = fs.existsSync('src/app');
    
    if (hasAppRoot && hasSrcApp) {
        console.error('❌ ERRO: Estruturas app/ e src/app/ coexistem');
        process.exit(1);
    }
    
    // Verificar consistência com tsconfig
    const tsconfig = JSON.parse(fs.readFileSync('tsconfig.json', 'utf8'));
    const usesSrc = tsconfig.compilerOptions?.paths?.['@/*']?.[0] === './src/*';
    
    if (usesSrc && hasAppRoot) {
        console.error('❌ ERRO: tsconfig usa src/ mas app/ existe na raiz');
        process.exit(1);
    }
    
    console.log('✅ Estrutura Next.js válida');
}

validateNextJSStructure();
```

### **3. Checklist de Deploy**
- [ ] Estrutura única (app/ OU src/app/, nunca ambas)
- [ ] tsconfig.json consistente com estrutura
- [ ] Todos os imports existem
- [ ] Cache limpo após mudanças estruturais
- [ ] Servidor inicia sem erros
- [ ] Hot reload funcional

## 🔄 PROTOCOLO DE MIGRAÇÃO SEGURA

### **Para Migrar de app/ para src/app/**:
1. Criar backup completo
2. Criar diretório `src/app/`
3. Mover conteúdo de `app/` para `src/app/`
4. Atualizar tsconfig.json paths
5. Atualizar imports relativos
6. Limpar cache completamente
7. Testar funcionamento
8. Remover `app/` original

### **Para Migrar de src/app/ para app/**:
1. Criar backup completo
2. Mover conteúdo de `src/app/` para `app/`
3. Atualizar tsconfig.json paths
4. Atualizar imports para remover @/ alias
5. Limpar cache completamente
6. Testar funcionamento
7. Remover `src/app/` original

## 📊 Métricas de Sucesso
- **Zero conflitos** de estrutura em projetos Next.js
- **100% consistência** entre tsconfig e estrutura real
- **Zero imports fantasma** em componentes
- **Tempo de resolução** < 30 minutos para conflitos detectados

## 🎯 Aplicação Cross-Project
Este protocolo deve ser aplicado em:
- ✅ **NEON PRO** (Next.js + src/app/)
- 🔄 **AegisWallet** (Vite - não aplicável diretamente)
- ✅ **Harmoniza** (Next.js + verificação necessária)

---

**Criado**: 2025-06-08 após resolução do BUG-001
**Última Atualização**: 2025-06-08
**Status**: ✅ ATIVO - Protocolo operacional
