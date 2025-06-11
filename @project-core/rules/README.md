﻿# ðŸš€ GRUPO US RULES SYSTEM - MASTER INDEX

## ðŸ“‹ OVERVIEW

Welcome to the centralized rules system for GRUPO US VIBECODE SYSTEM V2.0. This directory contains all consolidated rules, standards, and protocols for AI-assisted development across the entire ecosystem.

## ðŸŽ¯ SYSTEM ARCHITECTURE

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

## ðŸ“š RULES HIERARCHY & PRECEDENCE

### **ðŸš¨ PHASE 4 CENTRALIZED RULE ARCHITECTURE - ACTIVE**

**Status**: âœ… Phase 4 Implementation Complete
**Architecture**: Single Source of Truth with Universal Caller Rules
**Enforcement**: ALL rule modifications target @project-core/rules/ exclusively

#### **CENTRALIZED RULE STRUCTURE:**

```
project-core/rules/
â”œâ”€â”€ 00-master-execution-protocol.md     [MASTER ORCHESTRATOR]
â”œâ”€â”€ 01-core-principles.md               [UNIVERSAL PRINCIPLES]
â”œâ”€â”€ 02-coding-standards-universal.md    [UNIVERSAL STANDARDS]
â”œâ”€â”€ universal-pre-execution-verification.md [VERIFICATION LAYER]
â”œâ”€â”€ frameworks/                         [FRAMEWORK-SPECIFIC RULES]
â”‚   â”œâ”€â”€ nextjs-react.md                [Next.js + React standards]
â”‚   â”œâ”€â”€ laravel-livewire.md            [Laravel + Livewire standards]
â”‚   â””â”€â”€ component-naming-standards.mdc  [Universal component naming]
â”œâ”€â”€ mcp-integration/                    [MCP PROTOCOL RULES]
â”‚   â”œâ”€â”€ MCP Shrimp Task Manager-protocol.md         [MCP Shrimp Task Manager integration]
â”‚   â”œâ”€â”€ playwright-automation.md       [Playwright automation]
â”‚   â”œâ”€â”€ figma-design-sync.md           [Figma MCP integration]
â”‚   â”œâ”€â”€ supabase-database.md           [Supabase MCP integration]
â”‚   â””â”€â”€ sequential_thinking_usability.md [Sequential thinking MCP]
â”œâ”€â”€ workflows/                          [CONSOLIDATED WORKFLOWS]
â”‚   â”œâ”€â”€ development-workflow.md        [Universal dev workflow]
â”‚   â”œâ”€â”€ error-handling-protocol.md     [Error handling standards]
â”‚   â”œâ”€â”€ self-improvement-protocol.md   [Self-improvement workflow]
â”‚   â””â”€â”€ project-sync-automation.md     [Cross-project sync]
â”œâ”€â”€ tooling/                           [TOOL-SPECIFIC RULES]
â”‚   â”œâ”€â”€ cursor-integration.md          [Cursor-specific rules]
â”‚   â”œâ”€â”€ roo-code-integration.md        [Roo Code-specific rules]
â”‚   â””â”€â”€ cline-integration.md           [Cline-specific rules]
â”œâ”€â”€ project-overrides/                 [PROJECT-SPECIFIC OVERRIDES]
â”‚   â”œâ”€â”€ neonpro-overrides.md          [NEONPRO-specific rules]
â”‚   â”œâ”€â”€ aegiswallet-overrides.md      [AEGISWALLET-specific rules]
â”‚   â””â”€â”€ harmoniza-overrides.md        [HARMONIZA-specific rules]
â””â”€â”€ templates/                         [CALLER RULE TEMPLATES]
    â”œâ”€â”€ project-rule-caller.md        [Universal caller template]
    â”œâ”€â”€ clinerules-caller.md          [.clinerules caller template]
    â””â”€â”€ cursor-rules-caller.mdc       [.cursor caller template]
```

### **ðŸš¨ MANDATORY EXECUTION ORDER**

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
â”œâ”€â”€ nextjs-react.md           # Next.js 14+ with React & TypeScript
â”œâ”€â”€ laravel-livewire.md       # Laravel with Livewire & Alpine.js
â”œâ”€â”€ supabase-integration.md   # Supabase patterns and security
â””â”€â”€ tailwind-styling.md       # Tailwind CSS & Shadcn/ui
```

#### **STEP 4: MCP Integration Protocols (TOOL-SPECIFIC)**

```
mcp-integration/
â”œâ”€â”€ MCP Shrimp Task Manager-protocol.md    # MCP Shrimp Task Manager AI for complex tasks
â”œâ”€â”€ playwright-automation.md  # E2E testing and automation
â”œâ”€â”€ figma-design-sync.md      # Design-to-code workflows
â””â”€â”€ supabase-database.md      # Database operations and security
```

#### **STEP 5: Specialized Protocols (ON-DEMAND)**

```
specialized/
â”œâ”€â”€ sequential-thinking.md     # Complex problem solving
â”œâ”€â”€ completeness-verification.md  # Systematic validation
â”œâ”€â”€ cost-optimization.md       # Performance and cost optimization
â””â”€â”€ context-management.md      # Context and token management
```

## ðŸ”„ USAGE INSTRUCTIONS

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
@file:project-core/rules/mcp-integration/MCP Shrimp Task Manager-protocol.md
```

### **For Developers**

#### **Quick Reference:**

- **New to the system?** Start with `00-master-execution-protocol.md`
- **Working with Next.js?** Check `frameworks/nextjs-react.md`
- **Using MCP Shrimp Task Manager?** Reference `mcp-integration/MCP Shrimp Task Manager-protocol.md`
- **Need testing guidance?** See `03-quality-assurance.md`

#### **Contributing to Rules:**

1. Follow the established structure and format
2. Update this README when adding new rules
3. Ensure consistency with existing standards
4. Test rules with AI agents before finalizing

## ðŸ“Š RULE CATEGORIES EXPLAINED

### **ðŸ—ï¸ Core Foundation Rules**

**Purpose**: Establish fundamental execution patterns and quality standards
**When to Use**: ALWAYS - these are mandatory for all activities
**Files**: `00-master-execution-protocol.md`, `01-core-principles.md`, `02-coding-standards-universal.md`

### **ðŸŽ¨ Framework-Specific Rules**

**Purpose**: Provide technology-specific implementation guidance
**When to Use**: When working with specific frameworks or technologies
**Files**: Everything in `frameworks/` directory

### **ðŸ¤– MCP Integration Rules**

**Purpose**: Define protocols for Model Context Protocol tools
**When to Use**: When using MCP Shrimp Task Manager, Playwright, Figma, or Supabase
**Files**: Everything in `mcp-integration/` directory

### **âš¡ Specialized Protocols**

**Purpose**: Handle complex scenarios and advanced workflows
**When to Use**: For complex tasks, optimization, or specialized requirements
**Files**: Everything in `specialized/` directory

## ðŸ”§ CONFIGURATION INTEGRATION

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

@file:master_rule.md
@file:project-core/rules/00-master-execution-protocol.md
@file:project-core/rules/frameworks/nextjs-react.md
```

#### **Roo Code (.roo/rules/)**

```markdown
# Comprehensive integration with both systems

@file:project-core/rules/00-master-execution-protocol.md
@file:@project-core/memory/self_correction_log.md
@file:project-core/rules/mcp-integration/MCP Shrimp Task Manager-protocol.md
```

## ðŸ“ˆ QUALITY ASSURANCE

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

## ðŸ”„ MAINTENANCE & EVOLUTION

### **Regular Updates**

- **Weekly**: Review and update based on usage patterns
- **Monthly**: Comprehensive rule effectiveness analysis
- **Quarterly**: Major structural improvements and optimizations

### **Feedback Integration**

- AI agent performance metrics
- Developer feedback and suggestions
- Error pattern analysis from memory-bank
- Continuous improvement through self-correction logs

## ðŸš¨ CRITICAL REMINDERS

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

## ðŸ“ž SUPPORT & TROUBLESHOOTING

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

## ðŸŽ‰ WELCOME TO THE GRUPO US RULES SYSTEM

This centralized system ensures consistent, high-quality development across all projects and AI agents. By following these rules and protocols, we maintain excellence while enabling rapid, reliable development.

**Remember**: These rules are living documents that evolve with our needs and learnings. Contribute to their improvement and help build better development experiences for everyone.

**Confidence Level: 10/10** - Ready for optimal AI-assisted development! âœ¨

