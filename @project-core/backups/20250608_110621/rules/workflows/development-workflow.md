---
description: Universal development workflow for GRUPO US projects with TaskMaster integration
author: GRUPO US VIBECODE SYSTEM V2.0
version: 4.0
globs: ["**/*"]
tags: ["workflow", "development", "taskmaster", "universal"]
alwaysApply: true
---

# 🚀 GRUPO US UNIVERSAL DEVELOPMENT WORKFLOW

## 📋 OVERVIEW

This workflow consolidates all development processes across GRUPO US projects, integrating TaskMaster for task management, MCP tools for automation, and centralized rule enforcement.

**Consolidated from**: `.clinerules/workflows/dev_workflow.md`, project-specific workflows, and enhanced with Phase 4 centralized architecture.

## 🎯 WORKFLOW PHASES

### **PHASE 1: PROJECT INITIALIZATION**

#### **1.1: Workspace Verification (MANDATORY)**
```powershell
# Always verify workspace structure first
Get-Location
Test-Path "memory-bank" -PathType Container
Test-Path "project-core" -PathType Container
Test-Path "memory-bank/master_rule.md" -PathType Leaf
Test-Path "project-core/README.md" -PathType Leaf
```

#### **1.2: TaskMaster Initialization**
```bash
# Initialize TaskMaster for project management
task-master init --yes
task-master parse-prd scripts/prd.txt --yes  # If PRD exists
task-master list --sort=priority
task-master next --show-dependencies
```

#### **1.3: Integration Validation**
```bash
# Validate all integrations are working
npm run integration:test
task-master status
```

### **PHASE 2: TASK ANALYSIS & PLANNING**

#### **2.1: Complexity Assessment**
```bash
# Analyze project complexity before starting
task-master analyze-complexity --research
task-master complexity-report
```

#### **2.2: Task Selection Strategy**
- **Priority Order**: High → Medium → Low
- **Dependency Check**: All dependencies marked as 'done'
- **Complexity Consideration**: Start with complexity 5-7 for optimal flow
- **Resource Availability**: Match task complexity to available time

#### **2.3: Task Breakdown (Complexity ≥8)**
```bash
# For complex tasks, break down into subtasks
task-master expand-task --id=[task-id] --max-subtasks=5
task-master list --parent=[task-id]
```

### **PHASE 3: IMPLEMENTATION EXECUTION**

#### **3.1: Pre-Implementation Setup**
```bash
# Set up development environment
task-master set-status --id=[task-id] --status=in-progress
git checkout -b feature/[task-description]
```

#### **3.2: Development Process**
1. **Follow Framework Standards**: Load appropriate framework rules from `@project-core/rules/frameworks/`
2. **Implement with Standards**: Follow coding standards from `@project-core/rules/02-coding-standards-universal.md`
3. **Error Monitoring**: Activate error handling protocol on first error occurrence
4. **Progress Tracking**: Update task status regularly

#### **3.3: Error Handling Integration**
- **First Error**: Activate `@project-core/rules/workflows/error-handling-protocol.md`
- **Recurrent Errors**: Escalate to advanced error handling
- **Critical Errors**: Pause implementation, diagnose, resolve, then continue

### **PHASE 4: QUALITY ASSURANCE**

#### **4.1: Testing Strategy**
```bash
# Run comprehensive tests
npm run test                    # Unit tests
npm run test:integration       # Integration tests
npm run test:e2e              # End-to-end tests (if applicable)
```

#### **4.2: Code Quality Validation**
```bash
# Validate code quality
npm run lint                   # Linting
npm run type-check            # TypeScript validation
npm run build                 # Build validation
```

#### **4.3: Performance Validation**
- **Build Time**: Must meet project-specific targets
- **Bundle Size**: Optimize for production
- **Runtime Performance**: Validate against benchmarks

### **PHASE 5: COMPLETION & INTEGRATION**

#### **5.1: Task Completion**
```bash
# Mark task as completed
task-master set-status --id=[task-id] --status=done
task-master add-completion-notes --id=[task-id] --notes="Implementation details"
```

#### **5.2: Code Integration**
```bash
# Integrate changes
git add .
git commit -m "feat: [task-description] - closes #[task-id]"
git push origin feature/[task-description]

#### **5.2.1: Post-Push Verification (MANDATORY)**
- **Objective**: Ensure local and remote repositories are fully synchronized after a push.
- **Action**: Perform a `git status` and verify `Your branch is up to date with 'origin/main'.` or similar confirmation.
- **Verification**: If any discrepancies are found, re-evaluate and re-sync as needed.
```bash
git status
```
```

#### **5.3: Documentation Update**
- Update relevant documentation
- Add code examples if applicable
- Update API documentation if needed

## 🔧 FRAMEWORK-SPECIFIC ADAPTATIONS

### **Next.js Projects (NEONPRO, HARMONIZA)**
```bash
# Next.js specific workflow
npm run dev                    # Development server
npm run build                  # Production build
npm run start                  # Production server
npx next lint                  # Next.js linting
```

**Performance Targets**:
- Build time: <60s (NEONPRO), <90s (HARMONIZA)
- Component generation: <5s
- Hot reload: <2s

### **Vite Projects (AEGISWALLET)**
```bash
# Vite specific workflow
npm run dev                    # Development server
npm run build                  # Production build
npm run preview               # Preview build
npm run security-scan         # Security validation
```

**Performance Targets**:
- Build time: <45s
- Component generation: <3s
- Security scan: <30s

### **Laravel Projects (Future)**
```bash
# Laravel specific workflow
php artisan serve             # Development server
php artisan test              # Run tests
composer install              # Dependencies
php artisan migrate           # Database migrations
```

## 🎯 MCP INTEGRATION POINTS

### **TaskMaster Integration (Complexity ≥7)**
- **Automatic Activation**: For multi-phase tasks
- **Task Decomposition**: Break complex tasks into manageable subtasks
- **Progress Tracking**: Real-time task status updates
- **Dependency Management**: Ensure proper task sequencing

### **Playwright Integration (UI Tasks)**
- **Visual Testing**: Automated UI validation
- **Cross-browser Testing**: Ensure compatibility
- **Performance Testing**: Validate loading times
- **Accessibility Testing**: WCAG compliance validation

### **Figma Integration (Design Tasks)**
- **Component Generation**: Auto-generate components from Figma
- **Design Token Sync**: Maintain design system consistency
- **Visual Comparison**: Compare implementation with designs
- **Asset Optimization**: Optimize images and icons

### **Supabase Integration (Database Tasks)**
- **Schema Management**: Database schema updates
- **Authentication**: User management and auth flows
- **Real-time Features**: Live data synchronization
- **Storage Management**: File upload and management

## 📊 PERFORMANCE METRICS

### **Workflow Efficiency Targets**
- **Task Completion Rate**: >85% first attempt
- **Error Rate**: <15% during implementation
- **Build Success Rate**: >95%
- **Test Pass Rate**: >98%

### **Quality Metrics**
- **Code Coverage**: >80% for critical paths
- **Performance Budgets**: Meet project-specific targets
- **Security Compliance**: 100% for security-critical features
- **Accessibility**: WCAG AA compliance

## 🔄 CONTINUOUS IMPROVEMENT

### **Learning Integration**
- **Error Patterns**: Document and learn from errors
- **Performance Optimization**: Continuously improve build times
- **Process Refinement**: Update workflow based on team feedback
- **Tool Integration**: Integrate new tools as they become available

### **Feedback Loop**
```bash
# After task completion, update learning system
# This is handled automatically by the centralized rule system
# Updates are made to @project-core/rules/ exclusively
```

## ✅ WORKFLOW VALIDATION CHECKLIST

Before considering any task complete:

- [ ] **Workspace verified** and all integrations working
- [ ] **Task complexity assessed** and appropriate tools activated
- [ ] **Implementation follows** framework-specific standards
- [ ] **All tests pass** (unit, integration, e2e)
- [ ] **Code quality validated** (lint, type-check, build)
- [ ] **Performance targets met** for the specific project
- [ ] **Documentation updated** as needed
- [ ] **Task marked complete** in TaskMaster
- [ ] **Changes integrated** via proper git workflow
- [ ] **Learning documented** in centralized system

## 🚨 CRITICAL REMINDERS

### **Centralized Rule Enforcement**
- **ALL rule modifications** must target `@project-core/rules/` exclusively
- **NO local rule modifications** allowed
- **Framework detection** automatically loads appropriate rules
- **MCP integration** based on task complexity and requirements

### **Error Handling Priority**
- **First error**: Immediate activation of error handling protocol
- **Recurrent errors**: Escalate to advanced error handling
- **Critical errors**: Full stop until resolution

### **Quality Gates**
- **No task completion** without passing all quality checks
- **No code integration** without proper testing
- **No production deployment** without performance validation

---

**🎯 GRUPO US VIBECODE SYSTEM V2.0 - UNIVERSAL DEVELOPMENT WORKFLOW**  
**Centralized Rule Architecture - Phase 4 Implementation**
