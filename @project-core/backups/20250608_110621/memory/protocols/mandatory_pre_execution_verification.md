# 🚨 MANDATORY PRE-EXECUTION VERIFICATION PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 🚨 CRITICAL REQUIREMENT

This verification protocol is MANDATORY for ALL AI agents (Cline, Cursor, Roo Code, Augment Agent) and must be executed as the FIRST STEP before ANY task execution. NO EXCEPTIONS.

## 📋 CORRECTED VERIFICATION SEQUENCE

### Phase 1: Workspace Structure Verification

```bash
# Verify workspace structure
echo "Checking workspace structure..."
ls -la
test -d ".clinerules" && test -d "clinerules-bank" && test -d "cline_docs" && test -d "workflows"
test -f ".clinerules/01-memory-bank.md" && test -f ".clinerules/02-error-prevention.md"
test -f "cline_docs/projectRoadmap.md" && test -f "cline_docs/techStack.md"
# ONLY PROCEED if ALL verifications return TRUE
```

### Phase 2: Critical Directories Verification (PowerShell)

```powershell
# Verificação de diretórios críticos
Test-Path "memory-bank" -PathType Container
Test-Path "project-core" -PathType Container
Test-Path ".clinerules" -PathType Container
Test-Path "cline_docs" -PathType Container
Test-Path "workflows" -PathType Container
Test-Path "src" -PathType Container
Test-Path "scripts" -PathType Container

# All tests must return: True
```

### Phase 3: Essential Files Verification (PowerShell)

```powershell
# Verificação de arquivos essenciais
Test-Path "memory-bank/master_rule.md" -PathType Leaf
Test-Path "project-core/README.md" -PathType Leaf
Test-Path "package.json" -PathType Leaf
Test-Path ".clinerules/01-memory-bank.md" -PathType Leaf
Test-Path ".clinerules/02-error-prevention.md" -PathType Leaf
Test-Path ".clinerules/03-context-90.md" -PathType Leaf
Test-Path ".clinerules/04-confidence-check.md" -PathType Leaf
Test-Path "cline_docs/projectRoadmap.md" -PathType Leaf
Test-Path "scripts/prd.txt" -PathType Leaf
Test-Path "docs/architecture.md" -PathType Leaf
Test-Path "memory-bank/self_correction_log.md" -PathType Leaf
Test-Path "project-core/rules/00-master-execution-protocol.md" -PathType Leaf

# All tests must return: True
```

### Phase 4: Additional Verification Files

```powershell
# Verificação de arquivos adicionais do protocolo oficial
Test-Path ".clinerules/rules/sequential-thinking-mcp.md" -PathType Leaf
Test-Path ".clinerules/05-taskmaster-sequential.md" -PathType Leaf

# Verificação de Diretórios Adicionais
Test-Path "memory-bank" -PathType Container
Test-Path "project-core" -PathType Container
Test-Path ".clinerules" -PathType Container
Test-Path "workflows" -PathType Container

# All tests must return: True
```

### Phase 5: Content Accessibility Test

```powershell
# Test file read access
Get-Content "memory-bank/master_rule.md" -TotalCount 3
Get-Content "project-core/README.md" -TotalCount 3
Get-Content ".clinerules/01-memory-bank.md" -TotalCount 3

# Expected: Readable content from all files
```

## 🚨 FAILURE RESPONSE PROTOCOL

### If ANY verification fails:

1. **STOP EXECUTION IMMEDIATELY**
2. **Report specific failure with exact file path**
3. **Request user intervention**
4. **DO NOT PROCEED until 100% verification success**

### Failure Report Template:

```
🚨 WORKSPACE VERIFICATION FAILED 🚨

Failed Item: [specific file/directory path]
Error Type: [Access Denied / File Not Found / Permission Error]
Expected Location: [full path]
Current Status: [INACCESSIBLE]

ACTION REQUIRED: Please resolve workspace access issues before proceeding.
TASK EXECUTION: BLOCKED until verification passes.
```

## ✅ SUCCESS CONFIRMATION PROTOCOL

### Upon 100% verification success:

1. **Log successful verification**
2. **Proceed to context loading**
3. **Begin task execution**

### Success Confirmation Template:

```
✅ WORKSPACE VERIFICATION COMPLETE ✅

Root Directory: ✅ ACCESSIBLE
Memory-Bank System: ✅ ACCESSIBLE
Project-Core System: ✅ ACCESSIBLE
Configuration Files: ✅ ACCESSIBLE
Integration System: ✅ ACCESSIBLE

STATUS: READY FOR TASK EXECUTION
CONFIDENCE: 10/10
PROCEEDING TO: Context Loading Phase
```

## 🔄 IMPLEMENTATION REQUIREMENTS

### For Cline (.clinerules):

- Execute this verification BEFORE loading any context
- BEFORE reading memory-bank/master_rule.md
- BEFORE any MCP initialization

### For Cursor (.cursorrules):

- Execute this verification BEFORE any development task
- BEFORE loading project-core context
- BEFORE any code analysis or modification

### For Roo Code:

- Execute this verification BEFORE any analysis task
- BEFORE loading performance metrics
- BEFORE any optimization recommendations

## 📊 VERIFICATION LOGGING

### Required Log Entry Format:

```
[TIMESTAMP] WORKSPACE_VERIFICATION_START
[TIMESTAMP] ROOT_ACCESS: [PASS/FAIL]
[TIMESTAMP] MEMORY_BANK: [PASS/FAIL]
[TIMESTAMP] PROJECT_CORE: [PASS/FAIL]
[TIMESTAMP] CONFIG_FILES: [PASS/FAIL]
[TIMESTAMP] INTEGRATION: [PASS/FAIL]
[TIMESTAMP] WORKSPACE_VERIFICATION_COMPLETE: [PASS/FAIL]
```

## 🎯 ENFORCEMENT

This protocol is MANDATORY and NON-NEGOTIABLE. Any AI agent that fails to execute this verification before task execution is in violation of the GRUPO US VIBECODE SYSTEM V2.0 operational requirements.

### Compliance Requirements:

- ✅ Execute verification FIRST, before any other action
- ✅ Report verification status clearly
- ✅ Stop execution if verification fails
- ✅ Only proceed after 100% success confirmation
- ✅ Log verification results for audit trail
