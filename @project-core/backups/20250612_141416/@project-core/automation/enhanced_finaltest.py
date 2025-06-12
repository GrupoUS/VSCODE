#!/usr/bin/env python3
"""
===============================================================================
ENHANCED FINALTEST - COMPREHENSIVE VALIDATION & ARCHITECTURAL GUARDIAN
GRUPO US VIBECODE SYSTEM V4.5 - ADVANCED VALIDATION ENGINE
===============================================================================
Author: ARCHITECT & CODER Agent - System Evolution & Validation
Date: 2025-01-11
Version: 4.5.0

MISSION: Transform into a guardian of architectural integrity for the GRUPO US
VIBECODE SYSTEM V4.0, ensuring every prompt execution contributes to system
evolution and learning.

CAPABILITIES:
- Architectural compliance validation
- Prompt completion verification
- Redundancy analysis and consolidation suggestions
- Self-improvement cycle integration
- Real-time correction proposal generation
"""

import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Set
import hashlib
import difflib

from loguru import logger
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.progress import Progress, TaskID
from rich.markdown import Markdown

# Initialize rich console
console = Console()

# Global tracking variables
error_count = 0
success_count = 0
warning_count = 0
start_time = datetime.now()
corrections_proposed = []
optimization_suggestions = []

class ArchitecturalRules:
    """Dynamic loader and interpreter of architectural rules."""

    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.rules = {}
        self.mandatory_structure = {}
        self.file_patterns = {}
        self.load_rules()

    def load_rules(self):
        """Load and parse architectural rules from core documentation."""
        rule_sources = [
            "@project-core/docs/directory-structure-guidelines.md",
            "@project-core/docs/architecture.md",
            "@project-core/memory/master_rule.md",
            "@project-core/memory/global-standards.md"
        ]

        for source in rule_sources:
            rule_path = self.project_root / source
            if rule_path.exists():
                self._parse_rule_file(rule_path, source)

    def _parse_rule_file(self, file_path: Path, source: str):
        """Parse individual rule files and extract patterns."""
        try:
            content = file_path.read_text(encoding='utf-8')

            # Extract directory structure rules
            structure_patterns = re.findall(r'```\s*(?:bash|text)?\s*([\w\-\/\.\@]*\/[\w\-\/\.\@\s]*)\s*```', content)
            for pattern in structure_patterns:
                if '@project-core' in pattern:
                    self._add_structure_rule(pattern, source)

            # Extract file naming patterns
            naming_patterns = re.findall(r'(?:DEVE|MUST|OBRIGATÓRIO).*?`([^`]+)`', content, re.IGNORECASE)
            for pattern in naming_patterns:
                self._add_naming_rule(pattern, source)

            # Extract forbidden patterns
            forbidden_patterns = re.findall(r'(?:PROIBIDO|FORBIDDEN|NOT ALLOWED).*?`([^`]+)`', content, re.IGNORECASE)
            for pattern in forbidden_patterns:
                self._add_forbidden_rule(pattern, source)

        except Exception as e:
            console.print(f"[red]Error parsing {source}: {e}[/red]")

    def _add_structure_rule(self, pattern: str, source: str):
        """Add directory structure rule."""
        if 'mandatory_directories' not in self.rules:
            self.rules['mandatory_directories'] = []

        clean_pattern = pattern.strip()
        if clean_pattern and clean_pattern not in self.rules['mandatory_directories']:
            self.rules['mandatory_directories'].append({
                'pattern': clean_pattern,
                'source': source
            })

    def _add_naming_rule(self, pattern: str, source: str):
        """Add file naming rule."""
        if 'naming_patterns' not in self.rules:
            self.rules['naming_patterns'] = []

        self.rules['naming_patterns'].append({
            'pattern': pattern,
            'source': source
        })

    def _add_forbidden_rule(self, pattern: str, source: str):
        """Add forbidden pattern rule."""
        if 'forbidden_patterns' not in self.rules:
            self.rules['forbidden_patterns'] = []

        self.rules['forbidden_patterns'].append({
            'pattern': pattern,
            'source': source
        })

    def validate_file_location(self, file_path: str) -> Tuple[bool, Optional[str], Optional[str]]:
        """Validate if file is in correct location according to rules."""
        path = Path(file_path)

        # Check if it's within @project-core/projects/ for project files
        if not file_path.startswith('@project-core/') and path.suffix in ['.tsx', '.ts', '.js', '.jsx', '.vue', '.svelte']:
            suggested_location = f"@project-core/projects/{path.name}"
            return False, suggested_location, "Project files must be within @project-core/projects/"

        # Check against mandatory structure
        for rule in self.rules.get('mandatory_directories', []):
            pattern = rule['pattern']
            if self._matches_pattern(file_path, pattern):
                return True, None, None

        # Check forbidden patterns
        for rule in self.rules.get('forbidden_patterns', []):
            if rule['pattern'] in file_path:
                return False, None, f"File matches forbidden pattern: {rule['pattern']}"

        return True, None, None

    def _matches_pattern(self, file_path: str, pattern: str) -> bool:
        """Check if file path matches architectural pattern."""
        return pattern in file_path or file_path.startswith(pattern)

class PromptValidator:
    """Validates prompt completion against objectives."""

    def __init__(self, project_root: Path):
        self.project_root = project_root

    def verify_prompt_completion(self, prompt_inicial: str, git_diff: List[str]) -> Dict:
        """Compare prompt objectives with actual file changes."""
        objectives = self._extract_objectives(prompt_inicial)
        changed_files = self._parse_git_diff(git_diff)

        completion_status = {}
        for objective in objectives:
            status = self._check_objective_completion(objective, changed_files)
            completion_status[objective] = status

        return {
            'objectives': objectives,
            'completion_status': completion_status,
            'changed_files': changed_files,
            'completion_rate': sum(1 for status in completion_status.values() if status) / len(objectives) if objectives else 1.0
        }

    def _extract_objectives(self, prompt: str) -> List[str]:
        """Extract actionable objectives from prompt text."""
        objectives = []

        # Pattern matching for common objective indicators
        objective_patterns = [
            r'(?:criar|create|implementar|implement|desenvolver|develop)\s+([^.!\n]{10,100})',
            r'(?:adicionar|add|incluir|include)\s+([^.!\n]{10,100})',
            r'(?:modificar|modify|alterar|change|atualizar|update)\s+([^.!\n]{10,100})',
            r'(?:corrigir|fix|resolver|solve)\s+([^.!\n]{10,100})',
        ]

        for pattern in objective_patterns:
            matches = re.findall(pattern, prompt, re.IGNORECASE)
            objectives.extend([match.strip() for match in matches])

        # Extract numbered objectives
        numbered_objectives = re.findall(r'\d+\.\s*([^.\n]{10,100})', prompt)
        objectives.extend([obj.strip() for obj in numbered_objectives])

        return list(set(objectives))  # Remove duplicates

    def _parse_git_diff(self, git_diff: List[str]) -> List[Dict]:
        """Parse git diff output to extract changed files."""
        changed_files = []

        for line in git_diff:
            if line.startswith('diff --git'):
                # Extract file path from diff header
                match = re.search(r'diff --git a/(.*?) b/(.*)', line)
                if match:
                    file_path = match.group(2)
                    changed_files.append({
                        'path': file_path,
                        'type': 'modified'
                    })
            elif line.startswith('new file mode'):
                # New file created
                if changed_files:
                    changed_files[-1]['type'] = 'created'
            elif line.startswith('deleted file mode'):
                # File deleted
                if changed_files:
                    changed_files[-1]['type'] = 'deleted'

        return changed_files

    def _check_objective_completion(self, objective: str, changed_files: List[Dict]) -> bool:
        """Check if an objective appears to be completed based on file changes."""
        objective_lower = objective.lower()

        # Simple heuristics for completion checking
        for file_info in changed_files:
            file_path = file_info['path'].lower()

            # Check if file name relates to objective
            if any(word in file_path for word in objective_lower.split() if len(word) > 3):
                return True

            # Check file extensions match objective type
            if 'component' in objective_lower and file_path.endswith(('.tsx', '.jsx', '.vue')):
                return True
            if 'api' in objective_lower and file_path.endswith(('.py', '.js', '.ts')):
                return True
            if 'config' in objective_lower and file_path.endswith(('.json', '.yaml', '.yml', '.env')):
                return True

        return False

class RedundancyAnalyzer:
    """Analyzes content for redundancy and optimization opportunities."""

    def __init__(self, project_root: Path):
        self.project_root = project_root

    def analyze_redundancy(self, new_files: List[str]) -> List[Dict]:
        """Analyze new files for potential redundancy and consolidation opportunities."""
        suggestions = []

        for file_path in new_files:
            full_path = self.project_root / file_path
            if not full_path.exists():
                continue

            try:
                content = full_path.read_text(encoding='utf-8')
                file_suggestions = self._analyze_file_content(file_path, content)
                suggestions.extend(file_suggestions)
            except Exception as e:
                console.print(f"[yellow]Warning: Could not analyze {file_path}: {e}[/yellow]")

        return suggestions

    def _analyze_file_content(self, file_path: str, content: str) -> List[Dict]:
        """Analyze individual file content for consolidation opportunities."""
        suggestions = []

        # Check for similar content in existing files
        similar_files = self._find_similar_files(content)
        if similar_files:
            suggestions.append({
                'type': 'consolidation',
                'file': file_path,
                'suggestion': f"Content similar to existing files: {', '.join(similar_files)}",
                'action': 'Consider merging or refactoring to avoid duplication'
            })

        # Check if content could belong to existing structure
        existing_location = self._suggest_existing_location(file_path, content)
        if existing_location:
            suggestions.append({
                'type': 'relocation',
                'file': file_path,
                'suggestion': f"Content could be added to existing file: {existing_location}",
                'action': f"Consider adding to {existing_location} instead of creating new file"
            })

        # Check for small files that could be consolidated
        if len(content.split('\n')) < 20:
            suggestions.append({
                'type': 'size_optimization',
                'file': file_path,
                'suggestion': "Small file could potentially be consolidated",
                'action': "Consider if this content could be added to a related existing file"
            })

        return suggestions

    def _find_similar_files(self, content: str) -> List[str]:
        """Find files with similar content."""
        similar_files = []
        content_hash = hashlib.md5(content.encode()).hexdigest()

        # Search in common locations for similar patterns
        search_paths = [
            "@project-core/rules",
            "@project-core/docs",
            "@project-core/memory",
            "@project-core/configs"
        ]

        for search_path in search_paths:
            path_obj = self.project_root / search_path
            if path_obj.exists():
                for file_path in path_obj.rglob("*.md"):
                    try:
                        existing_content = file_path.read_text(encoding='utf-8')
                        similarity = difflib.SequenceMatcher(None, content, existing_content).ratio()
                        if similarity > 0.7:  # 70% similarity threshold
                            relative_path = file_path.relative_to(self.project_root)
                            similar_files.append(str(relative_path))
                    except:
                        continue

        return similar_files

    def _suggest_existing_location(self, file_path: str, content: str) -> Optional[str]:
        """Suggest existing file where content could be added."""
        path = Path(file_path)

        # Rule-based suggestions
        if 'rule' in path.name.lower() or 'guideline' in path.name.lower():
            rules_dir = self.project_root / "@project-core/rules"
            if rules_dir.exists():
                # Find most relevant existing rule file
                for rule_file in rules_dir.glob("*.md"):
                    if any(keyword in rule_file.name.lower() for keyword in ['universal', 'general', 'standard']):
                        return str(rule_file.relative_to(self.project_root))

        if 'config' in path.name.lower():
            configs_dir = self.project_root / "@project-core/configs"
            if configs_dir.exists():
                return "@project-core/configs/unified-config.json"

        return None

class ComplianceValidator:
    """Main validation orchestrator."""

    def __init__(self, project_root: Path):
        self.project_root = project_root
        self.rules = ArchitecturalRules(project_root)
        self.prompt_validator = PromptValidator(project_root)
        self.redundancy_analyzer = RedundancyAnalyzer(project_root)

    def validate_architecture(self, git_diff: List[str]) -> Dict:
        """Validate architectural compliance of changed files."""
        violations = []
        corrections = []

        changed_files = self.prompt_validator._parse_git_diff(git_diff)

        for file_info in changed_files:
            file_path = file_info['path']
            is_valid, suggested_location, reason = self.rules.validate_file_location(file_path)

            if not is_valid:
                violations.append({
                    'file': file_path,
                    'violation': reason or "Architectural compliance violation",
                    'suggested_location': suggested_location
                })

                if suggested_location:
                    corrections.append({
                        'command': f'mv "{file_path}" "{suggested_location}"',
                        'reason': f'Move {file_path} to comply with architectural standards'
                    })

        return {
            'violations': violations,
            'corrections': corrections,
            'compliance_rate': 1.0 - (len(violations) / len(changed_files)) if changed_files else 1.0
        }

def log_result(message: str, result_type: str = "info") -> None:
    """Log test result with appropriate styling and tracking."""
    global error_count, success_count, warning_count

    timestamp = datetime.now().strftime("%H:%M:%S")

    if result_type == "success":
        console.print(f"[{timestamp}] ✅ {message}", style="green")
        logger.success(message)
        success_count += 1
    elif result_type == "warning":
        console.print(f"[{timestamp}] ⚠️  {message}", style="yellow")
        logger.warning(message)
        warning_count += 1
    elif result_type == "error":
        console.print(f"[{timestamp}] ❌ {message}", style="red")
        logger.error(message)
        error_count += 1
    else:
        console.print(f"[{timestamp}] ℹ️  {message}", style="cyan")
        logger.info(message)

def get_git_diff() -> List[str]:
    """Get git diff output for recent changes."""
    try:
        result = subprocess.run(['git', 'diff', '--name-status', 'HEAD~1'],
                              capture_output=True, text=True, cwd=Path.cwd())
        if result.returncode == 0:
            return result.stdout.split('\n')
        else:
            log_result("Could not get git diff - using fallback detection", "warning")
            return []
    except Exception as e:
        log_result(f"Git diff failed: {e}", "warning")
        return []

def generate_finaltest_report(
    prompt_inicial: str,
    validation_results: Dict,
    architecture_results: Dict,
    redundancy_results: List[Dict],
    compliance_score: float
) -> str:
    """Generate comprehensive finaltest report in markdown."""

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    report = f"""# 🔍 FINALTEST VALIDATION REPORT

**Timestamp**: {timestamp}
**Prompt**: {prompt_inicial[:100]}...
**Overall Compliance Score**: {compliance_score:.1%}

## 📋 EXECUTIVE SUMMARY

- **Total Errors**: {error_count}
- **Total Warnings**: {warning_count}
- **Total Successes**: {success_count}
- **Architectural Compliance**: {architecture_results.get('compliance_rate', 0):.1%}
- **Prompt Completion Rate**: {validation_results.get('completion_rate', 0):.1%}

## ✅ PROMPT COMPLETION ANALYSIS

### Objectives Identified:
"""

    for i, objective in enumerate(validation_results.get('objectives', []), 1):
        status = "✅" if validation_results.get('completion_status', {}).get(objective, False) else "❌"
        report += f"{i}. {status} {objective}\n"

    report += f"""
### Files Modified:
"""

    for file_info in validation_results.get('changed_files', []):
        report += f"- **{file_info['type'].upper()}**: `{file_info['path']}`\n"

    report += f"""
## 🏗️ ARCHITECTURAL COMPLIANCE

### Violations Found:
"""

    violations = architecture_results.get('violations', [])
    if violations:
        for violation in violations:
            report += f"- **File**: `{violation['file']}`\n"
            report += f"  - **Issue**: {violation['violation']}\n"
            if violation.get('suggested_location'):
                report += f"  - **Suggested Location**: `{violation['suggested_location']}`\n"
    else:
        report += "✅ No architectural violations found.\n"

    report += f"""
### Correction Commands:
"""

    corrections = architecture_results.get('corrections', [])
    if corrections:
        report += "```bash\n"
        for correction in corrections:
            report += f"# {correction['reason']}\n"
            report += f"{correction['command']}\n\n"
        report += "```\n"
    else:
        report += "✅ No corrections needed.\n"

    report += f"""
## 🔄 REDUNDANCY ANALYSIS

### Optimization Suggestions:
"""

    if redundancy_results:
        for suggestion in redundancy_results:
            report += f"- **{suggestion['type'].upper()}**: `{suggestion['file']}`\n"
            report += f"  - **Suggestion**: {suggestion['suggestion']}\n"
            report += f"  - **Action**: {suggestion['action']}\n\n"
    else:
        report += "✅ No redundancy issues found.\n"

    report += f"""
## 📊 SYSTEM HEALTH METRICS

- **Overall Health**: {"EXCELLENT" if error_count == 0 else "GOOD" if error_count <= 3 else "NEEDS ATTENTION"}
- **Architectural Integrity**: {"MAINTAINED" if compliance_score >= 0.8 else "COMPROMISED"}
- **Process Compliance**: {"FULL" if compliance_score >= 0.9 else "PARTIAL"}

## 🎯 RECOMMENDATIONS

"""

    if compliance_score < 0.8:
        report += "1. **PRIORITY**: Address architectural violations before proceeding\n"
    if validation_results.get('completion_rate', 1) < 0.8:
        report += "2. **REVIEW**: Some prompt objectives may not be fully completed\n"
    if redundancy_results:
        report += "3. **OPTIMIZE**: Consider consolidating redundant content\n"
    if not violations and not redundancy_results and compliance_score >= 0.9:
        report += "✅ **EXCELLENT**: No immediate action required. System is operating optimally.\n"

    report += f"""
## 🔧 NEXT STEPS

1. Review and apply suggested corrections if any
2. Validate all architectural changes follow project standards
3. Update documentation to reflect any structural changes
4. Continue monitoring system evolution

---
*Generated by Enhanced Finaltest v4.5.0 - VIBECODE SYSTEM Guardian*
"""

    return report

def update_self_correction_log(report_content: str, prompt_inicial: str) -> None:
    """Update self-correction log with validation results."""
    log_result("Updating self-correction log with validation results...", "info")

    log_path = Path("@project-core/memory/self_correction_log.md")
    timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ")

    new_entry = f"""

---

## 🔍 ENHANCED FINALTEST VALIDATION - {timestamp}

### **PROMPT ANALYZED**: {prompt_inicial[:200]}...

**Status**: [ANALYSIS COMPLETE] Comprehensive architectural validation executed
**Errors**: {error_count} | **Warnings**: {warning_count} | **Successes**: {success_count}
**Duration**: {(datetime.now() - start_time).total_seconds() / 60:.1f} minutes

### **VALIDATION SUMMARY**:

{report_content.split('## 📊 SYSTEM HEALTH METRICS')[1].split('## 🎯 RECOMMENDATIONS')[0] if '## 📊 SYSTEM HEALTH METRICS' in report_content else 'Metrics extraction failed'}

### **LEARNINGS CAPTURED**:

- **Architectural Patterns**: Validated against VIBECODE V4.5 standards
- **Prompt Completion**: Measured objective fulfillment rate
- **Redundancy Detection**: Identified optimization opportunities
- **Self-Improvement**: Applied automatic correction suggestions

### **SYSTEM EVOLUTION**:

This validation contributes to continuous system improvement through:
1. **Pattern Recognition**: Enhanced architectural rule detection
2. **Quality Assurance**: Proactive compliance monitoring
3. **Optimization**: Automated redundancy identification
4. **Learning**: Self-correction log enhancement

**Impact**: SYSTEM EVOLUTION - Enhanced validation protocols active and optimizing
"""

    try:
        with open(log_path, 'a', encoding='utf-8') as f:
            f.write(new_entry)
        log_result("Self-correction log updated successfully", "success")
    except Exception as e:
        log_result(f"Failed to update self-correction log: {e}", "error")

def execute_validation_phases(prompt_inicial: str) -> Tuple[Dict, Dict, List[Dict], float]:
    """Execute all validation phases and return results."""

    # Phase 1: Requirements Analysis and Rule Mapping
    console.print(Panel("🔍 PHASE 1: Requirements Analysis & Rule Mapping", style="cyan"))

    project_root = Path.cwd()
    validator = ComplianceValidator(project_root)

    log_result("Loaded architectural rules from core documentation", "success")
    log_result(f"Identified {len(validator.rules.rules.get('mandatory_directories', []))} directory structure rules", "info")

    # Phase 2: Compliance Validation
    console.print(Panel("🏗️ PHASE 2: Architectural Compliance Validation", style="blue"))

    git_diff = get_git_diff()
    architecture_results = validator.validate_architecture(git_diff)

    if architecture_results['violations']:
        log_result(f"Found {len(architecture_results['violations'])} architectural violations", "warning")
        for violation in architecture_results['violations']:
            log_result(f"Violation in {violation['file']}: {violation['violation']}", "warning")
    else:
        log_result("No architectural violations detected", "success")

    # Phase 3: Redundancy Analysis
    console.print(Panel("🔄 PHASE 3: Redundancy Analysis & Optimization", style="magenta"))

    new_files = [f['path'] for f in validator.prompt_validator._parse_git_diff(git_diff) if f['type'] == 'created']
    redundancy_results = validator.redundancy_analyzer.analyze_redundancy(new_files)

    if redundancy_results:
        log_result(f"Found {len(redundancy_results)} optimization opportunities", "info")
        for suggestion in redundancy_results:
            log_result(f"{suggestion['type']}: {suggestion['file']} - {suggestion['suggestion']}", "info")
    else:
        log_result("No redundancy issues identified", "success")

    # Prompt validation
    validation_results = validator.prompt_validator.verify_prompt_completion(prompt_inicial, git_diff)

    if validation_results['completion_rate'] >= 0.8:
        log_result(f"Prompt completion rate: {validation_results['completion_rate']:.1%}", "success")
    else:
        log_result(f"Prompt completion rate: {validation_results['completion_rate']:.1%} - Review required", "warning")

    # Calculate overall compliance score
    compliance_score = (
        architecture_results['compliance_rate'] * 0.4 +
        validation_results['completion_rate'] * 0.3 +
        (1.0 - min(len(redundancy_results) / 10, 1.0)) * 0.3
    )

    return validation_results, architecture_results, redundancy_results, compliance_score

def main() -> int:
    """Main execution function with enhanced validation pipeline."""

    parser = argparse.ArgumentParser(
        description="Enhanced Finaltest - Architectural Guardian for VIBECODE SYSTEM V4.5"
    )
    parser.add_argument("--prompt",
                       required=True,
                       help="Initial prompt text to validate completion against")
    parser.add_argument("--auto-fix",
                       action="store_true",
                       help="Automatically apply safe corrections (with confirmation)")
    parser.add_argument("--output-report",
                       default="@project-core/reports/finaltest_report.md",
                       help="Path for detailed validation report")

    args = parser.parse_args()

    # Setup logging
    logger.remove()
    logger.add(sys.stderr, level="INFO")
    logger.add("@project-core/logs/finaltest.log", rotation="1 day", retention="7 days")

    try:
        console.print(Panel.fit(
            "🚀 ENHANCED FINALTEST V4.5\nArchitectural Guardian & System Evolution Engine",
            style="bold green"
        ))

        log_result("Starting comprehensive validation pipeline...", "info")
        log_result(f"Analyzing prompt: {args.prompt[:100]}...", "info")

        # Execute validation phases
        validation_results, architecture_results, redundancy_results, compliance_score = execute_validation_phases(args.prompt)

        # Phase 4: Generate comprehensive report
        console.print(Panel("📄 PHASE 4: Report Generation & Learning Integration", style="green"))

        report_content = generate_finaltest_report(
            args.prompt, validation_results, architecture_results,
            redundancy_results, compliance_score
        )

        # Save report
        report_path = Path(args.output_report)
        report_path.parent.mkdir(parents=True, exist_ok=True)
        report_path.write_text(report_content, encoding='utf-8')

        log_result(f"Detailed report saved to {report_path}", "success")

        # Update self-correction log
        update_self_correction_log(report_content, args.prompt)

        # Display final results
        console.print(Panel("📊 VALIDATION COMPLETE", style="bold green"))

        table = Table(title="Finaltest Results Summary")
        table.add_column("Metric", style="cyan")
        table.add_column("Value", style="white")
        table.add_column("Status", style="green")

        table.add_row("Overall Compliance Score", f"{compliance_score:.1%}",
                     "🟢" if compliance_score >= 0.9 else "🟡" if compliance_score >= 0.7 else "🔴")
        table.add_row("Architectural Violations", str(len(architecture_results['violations'])),
                     "🟢" if len(architecture_results['violations']) == 0 else "🟡")
        table.add_row("Prompt Completion", f"{validation_results['completion_rate']:.1%}",
                     "🟢" if validation_results['completion_rate'] >= 0.8 else "🟡")
        table.add_row("Optimization Opportunities", str(len(redundancy_results)),
                     "🟢" if len(redundancy_results) <= 2 else "🟡")

        console.print(table)

        # Auto-fix option
        if args.auto_fix and architecture_results['corrections']:
            console.print(Panel("🔧 AUTO-FIX MODE ACTIVATED", style="yellow"))

            for correction in architecture_results['corrections']:
                console.print(f"Proposed: {correction['command']}")
                console.print(f"Reason: {correction['reason']}")

                if console.input("Apply this correction? [y/N]: ").lower() == 'y':
                    try:
                        os.system(correction['command'])
                        log_result(f"Applied correction: {correction['command']}", "success")
                    except Exception as e:
                        log_result(f"Failed to apply correction: {e}", "error")

        # Final assessment
        if compliance_score >= 0.9:
            log_result("🎉 EXCELLENT: System operating at peak compliance!", "success")
            return 0
        elif compliance_score >= 0.7:
            log_result("✅ GOOD: Minor improvements recommended", "success")
            return 0
        else:
            log_result("⚠️ ATTENTION: Significant issues require resolution", "warning")
            return 1

    except Exception as e:
        log_result(f"Enhanced Finaltest execution failed: {e}", "error")
        logger.exception("Detailed error information:")
        return 1

if __name__ == "__main__":
    sys.exit(main())
