# 🔄 GRUPO US VIBECODE SYSTEM V2.0 - REFACTORING PLAYBOOK

## 📋 5-PHASE REFACTORING PROTOCOL

This playbook provides the standardized methodology for refactoring existing projects to comply with GRUPO US VIBECODE SYSTEM V2.0 standards.

**Version**: 2.0  
**Validated On**: neonpro, aegiswallet, harmoniza-facil-agendas  
**Success Rate**: 100% (3/3 projects)  

---

## 🎯 PRE-EXECUTION ASSESSMENT

### **STEP 0: MANDATORY VERIFICATION**
```powershell
# Verify workspace access
Get-Location
Test-Path "project-directory"
Test-Path "src/" && Test-Path "package.json"
```

### **COMPLEXITY ASSESSMENT MATRIX**

| Complexity | Score | Criteria | TaskMaster | Examples |
|------------|-------|----------|------------|----------|
| **Simple** | 1-3 | Basic structure, minimal changes | ❌ Skip | Well-organized projects |
| **Medium** | 4-6 | Good structure, needs consolidation | ❌ Skip | neonpro, aegiswallet |
| **Complex** | 7-10 | Major restructuring, duplicated files | ✅ Initialize | harmoniza-facil-agendas |

### **TASKMASTER DECISION CRITERIA**
- **Initialize** if complexity ≥7/10 (multi-phase operations, significant structural changes)
- **Skip** if complexity <7/10 (simple cleanup and consolidation tasks)

---

## 🚀 5-PHASE EXECUTION PROTOCOL

### **PHASE 1: BACKUP (CONDITIONAL)**
**Status**: SKIPPED when user confirms external backups exist

```powershell
# Only if backup required
$timestamp = Get-Date -Format 'yyyyMMddHHmmss'
Compress-Archive -Path "project-name" -DestinationPath "project_backup_$timestamp.zip" -Force
```

### **PHASE 2: CLEANUP AND CONSOLIDATION**

#### **2.1: Create Staging Directory**
```powershell
New-Item -ItemType Directory -Path "_toBeDeleted" -Force
```

#### **2.2: Remove Obsolete Files**
**Vite Files** (for Next.js projects):
```powershell
Move-Item "index.html" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
Move-Item "vite.config.ts" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
Move-Item "src\main.tsx" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
Move-Item "src\App.tsx" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
Move-Item "src\vite-env.d.ts" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
```

**Duplicate Configurations**:
```powershell
Move-Item "eslint.config.mjs" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
Move-Item "postcss.config.mjs" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
Move-Item "tsconfig.node.json" "_toBeDeleted\" -Force -ErrorAction SilentlyContinue
```

#### **2.3: Handle Nested Projects**
```powershell
# If duplicate project folder exists
Copy-Item "nested-project\src\*" "src\" -Recurse -Force
Move-Item "nested-project" "_toBeDeleted\" -Force
```

### **PHASE 3: RULE CENTRALIZATION**

#### **3.1: Create Centralized Structure**
```powershell
New-Item -ItemType Directory -Path "Rules\frameworks" -Force
New-Item -ItemType Directory -Path "Rules\mcp-integration" -Force
New-Item -ItemType Directory -Path "Rules\project-specific" -Force
```

#### **3.2: Consolidate Rules**
```powershell
Copy-Item ".clinerules\*" "Rules\project-specific\" -Force -ErrorAction SilentlyContinue
Copy-Item ".cursor\rules\*" "Rules\frameworks\" -Force -ErrorAction SilentlyContinue
Copy-Item ".roo\rules\*" "Rules\frameworks\" -Force -ErrorAction SilentlyContinue
Copy-Item ".taskmaster\*" "Rules\mcp-integration\" -Recurse -Force -ErrorAction SilentlyContinue
```

### **PHASE 4: STRUCTURE OPTIMIZATION**

#### **4.1: Create Standard Directories**
```powershell
# Core src/ structure
New-Item -ItemType Directory -Path "src\components\ui" -Force
New-Item -ItemType Directory -Path "src\components\features" -Force
New-Item -ItemType Directory -Path "src\hooks" -Force
New-Item -ItemType Directory -Path "src\lib" -Force
New-Item -ItemType Directory -Path "src\stores" -Force
New-Item -ItemType Directory -Path "src\types" -Force
New-Item -ItemType Directory -Path "src\utils" -Force

# Project structure
New-Item -ItemType Directory -Path "docs" -Force
New-Item -ItemType Directory -Path "tests\e2e" -Force
New-Item -ItemType Directory -Path "tests\unit" -Force
New-Item -ItemType Directory -Path "scripts" -Force
New-Item -ItemType Directory -Path "prisma" -Force
```

### **PHASE 5: FINAL CLEANUP**

#### **5.1: Generate Cleanup Report**
```powershell
Get-ChildItem "_toBeDeleted" -Recurse | Select-Object FullName | Out-File "cleanup_report.txt"
```

#### **5.2: User Confirmation**
Present cleanup report and request confirmation:
> "Confirma a exclusão permanente de todos os arquivos listados? Responda com 'SIM, EXCLUIR' para continuar."

### **PHASE 6: VALIDATION**

#### **6.1: Install Dependencies**
```powershell
npm install --silent
```

#### **6.2: Build Validation**
```powershell
npm run build
```

#### **6.3: Document Final Structure**
```powershell
tree /F /A > final_structure.txt
```

---

## 🔧 AUTOMATION FLAGS REFERENCE

### **PowerShell Automation**
```powershell
# Bypass confirmation prompts
-Force -ErrorAction SilentlyContinue

# Auto-confirm operations
echo "y" | command

# Silent installations
npm install --silent
```

### **TaskMaster Automation**
```bash
task-master init --yes
task-master parse-prd scripts/prd.txt --yes
```

---

## 📊 SUCCESS METRICS

### **Quality Gates**
- [ ] **Completion Rate**: >85% first attempt
- [ ] **Build Success**: npm run build passes
- [ ] **Structure Compliance**: Matches template
- [ ] **Rule Centralization**: All rules in Rules/
- [ ] **Clean Workspace**: No obsolete files

### **Performance Metrics**
- **Simple Projects**: <30 minutes
- **Medium Projects**: 30-60 minutes  
- **Complex Projects**: 60-120 minutes

---

## 🚨 TROUBLESHOOTING

### **Common Issues**
1. **Build Failures**: Check for missing dependencies
2. **Permission Errors**: Run as administrator
3. **Path Issues**: Verify working directory
4. **Nested Projects**: Follow consolidation protocol

### **Recovery Procedures**
1. Stop current process
2. Restore from backup (if created)
3. Re-assess complexity
4. Restart from appropriate phase

---

## 📚 VALIDATION CHECKLIST

- [ ] Complexity assessed correctly
- [ ] TaskMaster decision appropriate
- [ ] All phases executed in order
- [ ] Rules centralized properly
- [ ] Structure matches template
- [ ] Build and tests pass
- [ ] Documentation updated

**This playbook ensures consistent, reliable project refactoring across all GRUPO US projects.**
