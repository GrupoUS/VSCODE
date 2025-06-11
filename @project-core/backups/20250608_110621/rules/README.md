# 🚀 GRUPO US RULES SYSTEM - MASTER INDEX

## 📋 OVERVIEW

Welcome to the centralized rules system for GRUPO US VIBECODE SYSTEM V2.0. This directory contains all consolidated rules, standards, and protocols for AI-assisted development across the entire ecosystem.

## 🎯 SYSTEM ARCHITECTURE

### **Single Source of Truth with Conditional Loading**

This `project-core/rules/` directory serves as the **canonical source** for all development rules, implementing intelligent conditional loading to optimize performance while ensuring consistency across all AI agents (Cline, Cursor, Roo Code).

### **Rule Orchestration Engine**

The system now implements a sophisticated rule loading algorithm that:

- **Always loads core rules**: Foundation principles and universal standards
- **Conditionally loads framework rules**: Based on task context detection
- **Dynamically loads MCP rules**: Based on complexity and task requirements
- **Eliminates orphan rules**: All rules are interconnected through dependency graph

### **Integration with Memory Bank**

- **Memory Bank**: Active learning system (`memory-bank/`) - preserved for continuous improvement
- **Project Core**: Centralized rules system (`project-core/rules/`) - this directory
- **Agent Configs**: Updated to reference centralized rules

## 📚 RULES HIERARCHY & PRECEDENCE

### **🚨 PHASE 4 CENTRALIZED RULE ARCHITECTURE - ACTIVE**

**Status**: ✅ Phase 4 Implementation Complete
**Architecture**: Single Source of Truth with Universal Caller Rules
**Enforcement**: ALL rule modifications target @project-core/rules/ exclusively

#### **CENTRALIZED RULE STRUCTURE:**

```
project-core/rules/
├── 00-master-execution-protocol.md     [MASTER ORCHESTRATOR]
├── 01-core-principles.md               [UNIVERSAL PRINCIPLES]
├── 02-coding-standards-universal.md    [UNIVERSAL STANDARDS]
├── universal-pre-execution-verification.md [VERIFICATION LAYER]
├── frameworks/                         [FRAMEWORK-SPECIFIC RULES]
│   ├── nextjs-react.md                [Next.js + React standards]
│   ├── laravel-livewire.md            [Laravel + Livewire standards]
│   └── component-naming-standards.mdc  [Universal component naming]
├── mcp-integration/                    [MCP PROTOCOL RULES]
│   ├── taskmaster-protocol.md         [TaskMaster integration]
│   ├── playwright-automation.md       [Playwright automation]
│   ├── figma-design-sync.md           [Figma MCP integration]
│   ├── supabase-database.md           [Supabase MCP integration]
│   └── sequential_thinking_usability.md [Sequential thinking MCP]
├── workflows/                          [CONSOLIDATED WORKFLOWS]
│   ├── development-workflow.md        [Universal dev workflow]
│   ├── error-handling-protocol.md     [Error handling standards]
│   ├── self-improvement-protocol.md   [Self-improvement workflow]
│   └── project-sync-automation.md     [Cross-project sync]
├── tooling/                           [TOOL-SPECIFIC RULES]
│   ├── cursor-integration.md          [Cursor-specific rules]
│   ├── roo-code-integration.md        [Roo Code-specific rules]
│   └── cline-integration.md           [Cline-specific rules]
├── project-overrides/                 [PROJECT-SPECIFIC OVERRIDES]
│   ├── neonpro-overrides.md          [NEONPRO-specific rules]
│   ├── aegiswallet-overrides.md      [AEGISWALLET-specific rules]
│   └── harmoniza-overrides.md        [HARMONIZA-specific rules]
└── templates/                         [CALLER RULE TEMPLATES]
    ├── project-rule-caller.md        [Universal caller template]
    ├── clinerules-caller.md          [.clinerules caller template]
    └── cursor-rules-caller.mdc       [.cursor caller template]
```

### **🚨 MANDATORY EXECUTION ORDER**

#### **STEP 0: Workspace Verification (ABSOLUTE PRECEDENCE)**

```
universal-pre-execution-verification.md
```

**CRITICAL**: Must be executed BEFORE any other action - NO EXCEPTIONS

#### **STEP 1: Master Execution Protocol (CORE FOUNDATION)**

```
00-master-execution-protocol.md
```

**The 4-step execution cycle that governs ALL development activities**

#### **STEP 2: Universal Standards (APPLY TO ALL)**

```
01-core-principles.md          # Universal development principles
02-coding-standards-universal.md  # Universal coding standards
03-quality-assurance.md       # QA and testing standards
04-agent-coordination.md       # Multi-agent coordination
05-learning-improvement.md     # Self-improvement protocols
```

#### **STEP 3: Framework-Specific Rules (AS NEEDED)**

```
frameworks/
├── nextjs-react.md           # Next.js 14+ with React & TypeScript
├── laravel-livewire.md       # Laravel with Livewire & Alpine.js
├── supabase-integration.md   # Supabase patterns and security
└── tailwind-styling.md       # Tailwind CSS & Shadcn/ui
```

#### **STEP 4: MCP Integration Protocols (TOOL-SPECIFIC)**

```
mcp-integration/
├── taskmaster-protocol.md    # TaskMaster AI for complex tasks
├── playwright-automation.md  # E2E testing and automation
├── figma-design-sync.md      # Design-to-code workflows
└── supabase-database.md      # Database operations and security
```

#### **STEP 5: Specialized Protocols (ON-DEMAND)**

```
specialized/
├── sequential-thinking.md     # Complex problem solving
├── completeness-verification.md  # Systematic validation
├── cost-optimization.md       # Performance and cost optimization
└── context-management.md      # Context and token management
```

## 🔄 USAGE INSTRUCTIONS

### **For AI Agents (Cline, Cursor, Roo Code)**

#### **Mandatory Loading Sequence:**

1. **ALWAYS** start with workspace verification
2. **ALWAYS** load master execution protocol
3. **ALWAYS** follow the 4-step execution cycle
4. Load framework-specific rules as needed
5. Activate MCP protocols when required
6. Use specialized protocols for complex tasks

#### **Example Loading Pattern:**

```markdown
@file:project-core/rules/universal-pre-execution-verification.md
@file:project-core/rules/00-master-execution-protocol.md
@file:project-core/rules/02-coding-standards-universal.md
@file:project-core/rules/frameworks/nextjs-react.md
@file:project-core/rules/mcp-integration/taskmaster-protocol.md
```

### **For Developers**

#### **Quick Reference:**

- **New to the system?** Start with `00-master-execution-protocol.md`
- **Working with Next.js?** Check `frameworks/nextjs-react.md`
- **Using TaskMaster?** Reference `mcp-integration/taskmaster-protocol.md`
- **Need testing guidance?** See `03-quality-assurance.md`

#### **Contributing to Rules:**

1. Follow the established structure and format
2. Update this README when adding new rules
3. Ensure consistency with existing standards
4. Test rules with AI agents before finalizing

## 📊 RULE CATEGORIES EXPLAINED

### **🏗️ Core Foundation Rules**

**Purpose**: Establish fundamental execution patterns and quality standards
**When to Use**: ALWAYS - these are mandatory for all activities
**Files**: `00-master-execution-protocol.md`, `01-core-principles.md`, `02-coding-standards-universal.md`

### **🎨 Framework-Specific Rules**

**Purpose**: Provide technology-specific implementation guidance
**When to Use**: When working with specific frameworks or technologies
**Files**: Everything in `frameworks/` directory

### **🤖 MCP Integration Rules**

**Purpose**: Define protocols for Model Context Protocol tools
**When to Use**: When using TaskMaster, Playwright, Figma, or Supabase
**Files**: Everything in `mcp-integration/` directory

### **⚡ Specialized Protocols**

**Purpose**: Handle complex scenarios and advanced workflows
**When to Use**: For complex tasks, optimization, or specialized requirements
**Files**: Everything in `specialized/` directory

## 🔧 CONFIGURATION INTEGRATION

### **Agent Configuration Updates**

#### **Cline (.clinerules/)**

```markdown
# Updated to reference project-core/rules/ as primary source

@file:project-core/rules/00-master-execution-protocol.md
@file:project-core/rules/02-coding-standards-universal.md

# ... additional rules as needed
```

#### **Cursor (.cursorrules)**

```markdown
# Memory-bank integration with project-core rules

@file:memory-bank/master_rule.md
@file:project-core/rules/00-master-execution-protocol.md
@file:project-core/rules/frameworks/nextjs-react.md
```

#### **Roo Code (.roo/rules/)**

```markdown
# Comprehensive integration with both systems

@file:project-core/rules/00-master-execution-protocol.md
@file:memory-bank/self_correction_log.md
@file:project-core/rules/mcp-integration/taskmaster-protocol.md
```

## 📈 QUALITY ASSURANCE

### **Rule Validation Checklist**

- [ ] Follows established format and structure
- [ ] Includes practical examples and code snippets
- [ ] Defines clear activation criteria
- [ ] Provides troubleshooting guidance
- [ ] Integrates with existing rule hierarchy
- [ ] Tested with AI agents

### **Performance Metrics**

- **Completion Rate**: > 85% first attempt success
- **Token Efficiency**: < 50k tokens per feature
- **Error Rate**: < 15% in production
- **User Satisfaction**: > 9/10 rating

## 🔄 MAINTENANCE & EVOLUTION

### **Regular Updates**

- **Weekly**: Review and update based on usage patterns
- **Monthly**: Comprehensive rule effectiveness analysis
- **Quarterly**: Major structural improvements and optimizations

### **Feedback Integration**

- AI agent performance metrics
- Developer feedback and suggestions
- Error pattern analysis from memory-bank
- Continuous improvement through self-correction logs

## 🚨 CRITICAL REMINDERS

### **For AI Agents**

1. **NEVER skip workspace verification** - it's mandatory
2. **ALWAYS follow the 4-step execution cycle** - no exceptions
3. **CONFIRM plans before execution** - prevent rework
4. **UPDATE memory-bank after tasks** - enable learning
5. **USE appropriate MCP tools** - leverage available integrations

### **For Developers**

1. **Keep rules updated** - reflect current best practices
2. **Test with AI agents** - ensure rules work in practice
3. **Document changes** - maintain clear change history
4. **Share learnings** - contribute to collective knowledge

## 📞 SUPPORT & TROUBLESHOOTING

### **Common Issues**

- **Rules not loading**: Check file paths and permissions
- **Conflicting standards**: Follow precedence hierarchy
- **Performance issues**: Review token usage and optimization
- **Integration failures**: Verify MCP tool configurations

### **Getting Help**

- Check `memory-bank/self_correction_log.md` for similar issues
- Review troubleshooting sections in specific rule files
- Consult with team members for complex scenarios
- Update documentation with solutions for future reference

---

## 🎉 WELCOME TO THE GRUPO US RULES SYSTEM

This centralized system ensures consistent, high-quality development across all projects and AI agents. By following these rules and protocols, we maintain excellence while enabling rapid, reliable development.

**Remember**: These rules are living documents that evolve with our needs and learnings. Contribute to their improvement and help build better development experiences for everyone.

**Confidence Level: 10/10** - Ready for optimal AI-assisted development! ✨
