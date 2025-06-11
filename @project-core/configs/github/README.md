# 📁 GitHub Configuration - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

This directory contains centralized GitHub-related configurations that were migrated from the root `.github/` directory as part of the architectural optimization project.

## 📄 FILES

### **copilot-instructions.md**

- **Source**: `.github/copilot-instructions.md`
- **Purpose**: GitHub Copilot configuration for GRUPO US development standards
- **Migration Date**: 2025-01-27
- **Status**: ✅ Migrated successfully

## 🔄 MIGRATION NOTES

### **Workflows Directory**

The `.github/workflows/` directory remains in the root location because:

- GitHub Actions requires workflows to be in `.github/workflows/` for automatic execution
- Moving workflows would break CI/CD automation
- This is a GitHub platform requirement, not a project choice

### **Future Considerations**

- Monitor GitHub for any changes to workflow location requirements
- Consider creating symbolic links if needed for better organization
- Maintain documentation of GitHub-specific requirements

## 🚀 USAGE

To reference the migrated copilot instructions:

```markdown
@file:@project-core/configs/github/copilot-instructions.md
```

## 📚 RELATED DOCUMENTATION

- `@project-core/memory/self_correction_log.md` - Migration log
- `@project-core/memory/protocols/self_improvement_protocol.md` - ROO patterns integrated
- `.github/workflows/` - Active GitHub workflows (kept in original location)

---

**GRUPO US VIBECODE SYSTEM V2.0** - Architectural Excellence! 🚀
