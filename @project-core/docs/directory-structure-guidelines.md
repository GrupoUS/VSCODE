# 📁 DIRECTORY STRUCTURE GUIDELINES - GRUPO US VIBECODE SYSTEM V4.0

**Version**: 1.0  
**Created**: 2025-01-10  
**Purpose**: Prevent nested duplications and maintain clean @project-core structure  
**Authority**: GRUPO US VIBECODE SYSTEM V4.0 Constitution

---

## 🎯 CORE PRINCIPLES

### **1. SINGLE SOURCE OF TRUTH**
- Each piece of content must have ONE authoritative location
- No nested duplications of @project-core directories allowed
- Clear hierarchy with logical content placement

### **2. LOGICAL ORGANIZATION**
- Content placement follows functional purpose
- Related functionality grouped together
- Clear separation of concerns

### **3. PREVENTION OVER CORRECTION**
- Proactive measures to prevent structural violations
- Automated validation before content creation
- Clear guidelines for all team members

---

## 🚫 FORBIDDEN PATTERNS

### **CRITICAL VIOLATIONS - NEVER ALLOWED**

```
❌ @project-core/@project-core/           # Nested duplication
❌ @project-core/memory/@project-core/    # Nested in memory
❌ @project-core/*/memory/@project-core/  # Nested anywhere
❌ @project-core/tools/@project-core/     # Nested in tools
❌ @project-core/configs/@project-core/   # Nested in configs
```

### **NAMING VIOLATIONS**

```
❌ project-core-backup/                  # Use @project-core/backups/
❌ project_core_temp/                    # Use @project-core/temp/
❌ core-project/                         # Confusing naming
❌ @project-core-v2/                     # Version in directory name
```

---

## ✅ APPROVED DIRECTORY STRUCTURE

### **TOP-LEVEL ORGANIZATION**

```
@project-core/
├── memory/                    # Knowledge base and learning systems
├── rules/                     # System rules and protocols
├── automation/                # Scripts and automated processes
├── configs/                   # Configuration files
├── docs/                      # Documentation and reports
├── tools/                     # Development tools and utilities
├── scripts/                   # Deployment and maintenance scripts
├── backups/                   # System backups and archives
├── monitoring/                # System monitoring and logs
└── templates/                 # Project templates and boilerplates
```

### **MEMORY DIRECTORY STRUCTURE**

```
@project-core/memory/
├── master_rule.md             # Core system rules
├── self_correction_log.md     # Learning and error tracking
├── global-standards.md        # Universal standards
├── coding_standards/          # Technology-specific standards
├── protocols/                 # Execution protocols
├── learning/                  # Pattern libraries and learning systems
├── cache/                     # Performance caching systems
├── native-rag-system/         # Native RAG implementation
├── rag-enhanced/              # Enhanced RAG functionality
├── cognee-integration/        # Cognee integration components
└── coordination/              # Multi-agent coordination
```

### **RULES DIRECTORY STRUCTURE**

```
@project-core/rules/
├── 00-vibecode-system-v4-master.md    # Constitution document
├── 01-core-principles.md              # Fundamental principles
├── 02-coding-standards-universal.md   # Universal coding standards
├── frameworks/                        # Framework-specific rules
├── protocols/                         # Execution protocols
├── specialized/                       # Specialized domain rules
└── templates/                         # Rule templates
```

---

## 📋 CONTENT PLACEMENT GUIDELINES

### **MEMORY DIRECTORY** (`@project-core/memory/`)

**Purpose**: Knowledge base, learning systems, and cognitive functionality

**Approved Content**:
- ✅ Learning and pattern libraries
- ✅ RAG systems and semantic search
- ✅ Memory caching and optimization
- ✅ Cognitive integration components
- ✅ Self-correction and improvement logs

**Forbidden Content**:
- ❌ Configuration files (use @project-core/configs/)
- ❌ Executable scripts (use @project-core/automation/)
- ❌ Documentation (use @project-core/docs/)

### **RULES DIRECTORY** (`@project-core/rules/`)

**Purpose**: System rules, protocols, and governance

**Approved Content**:
- ✅ System constitution and core principles
- ✅ Execution protocols and procedures
- ✅ Framework-specific rules and standards
- ✅ Specialized domain guidelines

**Forbidden Content**:
- ❌ Implementation code (use @project-core/tools/)
- ❌ Configuration files (use @project-core/configs/)
- ❌ Learning logs (use @project-core/memory/)

### **AUTOMATION DIRECTORY** (`@project-core/automation/`)

**Purpose**: Automated scripts and processes

**Approved Content**:
- ✅ Validation and testing scripts
- ✅ Monitoring and health check scripts
- ✅ Backup and maintenance automation
- ✅ Performance optimization scripts

**Forbidden Content**:
- ❌ Configuration files (use @project-core/configs/)
- ❌ Documentation (use @project-core/docs/)
- ❌ Learning data (use @project-core/memory/)

---

## 🔧 NAMING CONVENTIONS

### **DIRECTORY NAMING**

```
✅ kebab-case-naming           # Preferred format
✅ snake_case_naming           # Acceptable alternative
❌ CamelCaseNaming            # Avoid
❌ UPPERCASE_NAMING           # Avoid
❌ mixedCase_Naming           # Avoid
```

### **FILE NAMING**

```
✅ descriptive-file-name.md    # Clear, descriptive names
✅ component-specific.js       # Purpose-specific naming
✅ 00-priority-file.md         # Numbered for ordering
❌ temp.md                     # Vague naming
❌ file1.js                    # Non-descriptive
❌ backup_backup.md            # Redundant naming
```

### **BACKUP NAMING**

```
✅ backup-YYYYMMDD-HHMMSS/     # Timestamped backups
✅ archive-project-name/       # Archived projects
✅ deprecated-YYYY-MM-DD/      # Deprecated content
❌ backup/                     # Generic naming
❌ old/                        # Vague naming
❌ temp/                       # Temporary without timestamp
```

---

## 🛡️ VALIDATION PROCEDURES

### **PRE-CREATION VALIDATION**

Before creating any new directory or moving content:

1. **Check Naming Convention**: Ensure name follows approved patterns
2. **Verify Placement**: Confirm content belongs in target location
3. **Prevent Nesting**: Ensure no nested @project-core structures
4. **Validate Purpose**: Confirm directory serves clear functional purpose

### **AUTOMATED CHECKS**

```powershell
# Run before any structural changes
.\@project-core\automation\structure-integrity-monitor.ps1 -Detailed

# Validate specific directory creation
.\@project-core\automation\validate-directory-creation.ps1 -Path "new-directory"
```

### **MANUAL REVIEW CHECKLIST**

- [ ] Directory name follows naming conventions
- [ ] Content placement is logical and appropriate
- [ ] No nested @project-core structures created
- [ ] Clear functional purpose defined
- [ ] Documentation updated if needed

---

## 🚨 VIOLATION RESPONSE PROTOCOL

### **IMMEDIATE ACTIONS**

1. **Stop Current Operation**: Halt any ongoing structural changes
2. **Document Violation**: Record what was attempted and why it failed
3. **Assess Impact**: Determine if any damage occurred
4. **Implement Correction**: Move content to appropriate location
5. **Update Guidelines**: Enhance guidelines to prevent similar violations

### **ESCALATION PROCEDURES**

**Level 1 - Minor Violations**: Incorrect naming, minor misplacement
- Immediate correction by developer
- Update in self_correction_log.md

**Level 2 - Moderate Violations**: Structural misplacement, multiple violations
- Team lead review required
- Comprehensive validation before correction

**Level 3 - Critical Violations**: Nested duplications, system integrity threats
- Full system backup before correction
- Sequential Thinking MCP activation required
- Comprehensive post-correction validation

---

## 📚 TEAM TRAINING REQUIREMENTS

### **MANDATORY KNOWLEDGE**

All team members must understand:
- Approved directory structure
- Forbidden patterns and violations
- Naming conventions
- Validation procedures

### **TRAINING MATERIALS**

- This guidelines document
- Hands-on validation script training
- Real-world violation examples
- Best practices workshops

### **COMPETENCY VALIDATION**

- Successful completion of structure validation quiz
- Demonstration of proper directory creation
- Understanding of violation response protocol

---

## 🔄 CONTINUOUS IMPROVEMENT

### **GUIDELINE EVOLUTION**

These guidelines will evolve based on:
- Team feedback and practical experience
- New technology requirements
- System optimization discoveries
- Violation pattern analysis

### **UPDATE PROCEDURES**

1. **Propose Changes**: Document proposed modifications
2. **Team Review**: Collaborative review and discussion
3. **Testing**: Validate changes in development environment
4. **Implementation**: Update guidelines and training materials
5. **Communication**: Ensure all team members understand changes

---

## ✅ SUCCESS METRICS

### **STRUCTURE HEALTH INDICATORS**

- Zero nested @project-core duplications
- 100% compliance with naming conventions
- Clear functional separation of content
- Efficient navigation and content discovery

### **TEAM ADOPTION METRICS**

- 100% team member training completion
- Zero critical violations per month
- Proactive violation prevention
- Continuous improvement suggestions

---

**Document Authority**: GRUPO US VIBECODE SYSTEM V4.0  
**Enforcement**: Mandatory for all team members  
**Review Cycle**: Monthly assessment and quarterly updates  
**Contact**: System Architecture Team
