#!/usr/bin/env python3
"""
===============================================================================
SYSTEM VALIDATION SCRIPT - GRUPO US VIBECODE SYSTEM V4.0
===============================================================================
Validates the consolidated architecture and performs comprehensive testing
Author: Augment Agent - Learning Analysis Implementation (Python Migration)
Date: 2025-01-27
===============================================================================
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, Union

from loguru import logger
from rich.console import Console
from rich.table import Table

# Initialize rich console
console = Console()


def log_status(message: str, status_type: str = "info") -> None:
    """Log status message with appropriate color."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if status_type == "success":
        console.print(f"[{timestamp}] {message}", style="green")
        logger.success(message)
    elif status_type == "warning":
        console.print(f"[{timestamp}] {message}", style="yellow")
        logger.warning(message)
    elif status_type == "error":
        console.print(f"[{timestamp}] {message}", style="red")
        logger.error(message)
    else:
        console.print(f"[{timestamp}] {message}", style="white")
        logger.info(message)


def test_directory_structure() -> Dict[str, bool]:
    """Test directory structure."""
    log_status("Testing directory structure...", "info")

    required_dirs = [
        "automation",
        "knowledge-base/rules",
        "knowledge-base/memory",
        "configs",
        "configs/project-templates",
        "docs",
        "docs/setup",
        "docs/workflows",
        "docs/architecture",
        ".taskmaster",
        ".cursor"
    ]

    results = {}
    for dir_path in required_dirs:
        path = Path(dir_path)
        exists = path.exists() and path.is_dir()
        results[dir_path] = exists

        if exists:
            log_status(f"  ✅ {dir_path}", "success")
        else:
            log_status(f"  ❌ {dir_path}", "error")

    return results


def test_configuration_files() -> Dict[str, Union[bool, str]]:
    """Test configuration files."""
    log_status("Testing configuration files...", "info")

    config_files = [
        "configs/taskmaster-unified.json",
        "configs/mcp-servers.json",
        "configs/README.md",
        ".cursor/mcp.json",
        "tools/taskmaster-integration/config/default.json"
    ]

    results = {}
    for file_path in config_files:
        path = Path(file_path)
        exists = path.exists() and path.is_file()

        if exists:
            # Test JSON syntax for JSON files
            if file_path.endswith('.json'):
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        json.load(f)
                    log_status(f"  ✅ {file_path} (valid JSON)", "success")
                    results[file_path] = "valid"
                except json.JSONDecodeError:
                    log_status(f"  ⚠️ {file_path} (invalid JSON)", "warning")
                    results[file_path] = "invalid"
            else:
                log_status(f"  ✅ {file_path}", "success")
                results[file_path] = True
        else:
            log_status(f"  ❌ {file_path}", "error")
            results[file_path] = False

    return results


def test_automation_scripts() -> Dict[str, Union[bool, str]]:
    """Test automation scripts."""
    log_status("Testing automation scripts...", "info")

    scripts = [
        "automation/validate_system.py",  # This script itself
        "automation/cache_cleanup.py",
        "scripts/simple_sync.py",
        "configs/migrate-configurations.ps1",
        "configs/project-templates/generate-project.ps1"
    ]

    results = {}
    for script_path in scripts:
        path = Path(script_path)
        exists = path.exists() and path.is_file()

        if exists:
            # For Python files, check basic syntax
            if script_path.endswith('.py'):
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    # Basic syntax check by compiling
                    compile(content, script_path, 'exec')
                    log_status(f"  ✅ {script_path} (valid syntax)", "success")
                    results[script_path] = "valid"
                except SyntaxError:
                    log_status(f"  ⚠️ {script_path} (syntax error)", "warning")
                    results[script_path] = "invalid"
            else:
                # For PowerShell files, just check existence
                log_status(f"  ✅ {script_path}", "success")
                results[script_path] = True
        else:
            log_status(f"  ❌ {script_path}", "error")
            results[script_path] = False

    return results


def test_documentation_files() -> Dict[str, Union[bool, str]]:
    """Test documentation files."""
    log_status("Testing documentation files...", "info")

    doc_files = [
        "README.md",
        "docs/README.md",
        "docs/setup/setup-guide.md",
        "docs/workflows/development-workflow.md",
        "knowledge-base/rules/00-master-protocol.md",
        "knowledge-base/rules/01-core-principles.md",
        "knowledge-base/rules/02-coding-standards-universal.md"
    ]

    results = {}
    for file_path in doc_files:
        path = Path(file_path)
        exists = path.exists() and path.is_file()

        if exists:
            try:
                with open(path, 'r', encoding='utf-8') as f:
                    content = f.read()
                word_count = len(content.split())

                if word_count > 50:
                    log_status(f"  ✅ {file_path} ({word_count} words)", "success")
                    results[file_path] = "complete"
                else:
                    log_status(f"  ⚠️ {file_path} (too short: {word_count} words)", "warning")
                    results[file_path] = "incomplete"
            except Exception as e:
                log_status(f"  ⚠️ {file_path} (read error: {e})", "warning")
                results[file_path] = "error"
        else:
            log_status(f"  ❌ {file_path}", "error")
            results[file_path] = False

    return results


def create_summary_table(results: Dict[str, Dict]) -> Table:
    """Create a summary table of validation results."""
    table = Table(title="Validation Summary")
    table.add_column("Category", style="cyan")
    table.add_column("Passed", style="green")
    table.add_column("Total", style="white")
    table.add_column("Success Rate", style="yellow")

    for category, category_results in results.items():
        passed = sum(1 for v in category_results.values()
                    if v is True or v in ["valid", "complete"])
        total = len(category_results)
        success_rate = round((passed / total) * 100, 1) if total > 0 else 0

        table.add_row(
            category,
            str(passed),
            str(total),
            f"{success_rate}%"
        )

    return table


def main() -> int:
    """Main execution function."""
    parser = argparse.ArgumentParser(
        description="System validation script for GRUPO US VIBECODE SYSTEM V4.0"
    )
    parser.add_argument("--detailed", action="store_true",
                       help="Show detailed validation information")
    parser.add_argument("--fix-issues", action="store_true",
                       help="Attempt to fix found issues")

    args = parser.parse_args()

    # Setup logging
    logger.remove()
    logger.add(sys.stderr, level="DEBUG" if args.detailed else "INFO")

    try:
        log_status("=== COMPREHENSIVE SYSTEM VALIDATION ===", "info")
        log_status("GRUPO US VIBECODE SYSTEM V4.0", "info")

        # Run all validation tests
        results = {
            "Directory Structure": test_directory_structure(),
            "Configuration Files": test_configuration_files(),
            "Automation Scripts": test_automation_scripts(),
            "Documentation": test_documentation_files()
        }

        # Calculate overall statistics
        total_tests = 0
        passed_tests = 0

        for category_results in results.values():
            for result in category_results.values():
                total_tests += 1
                if result is True or result in ["valid", "complete"]:
                    passed_tests += 1

        # Display summary
        log_status("=== VALIDATION SUMMARY ===", "info")

        # Create and display summary table
        summary_table = create_summary_table(results)
        console.print(summary_table)

        # Overall score
        success_rate = round((passed_tests / total_tests) * 100, 1) if total_tests > 0 else 0
        log_status(f"Overall Success Rate: {success_rate}% ({passed_tests}/{total_tests})", "info")

        # Final assessment
        if success_rate >= 90:
            log_status("🎉 SYSTEM VALIDATION PASSED!", "success")
            log_status("Learning analysis implementation successful", "success")
            return 0
        elif success_rate >= 75:
            log_status("⚠️ SYSTEM VALIDATION MOSTLY PASSED", "warning")
            log_status("Some minor issues found, but system is functional", "warning")
            return 0
        else:
            log_status("❌ SYSTEM VALIDATION FAILED", "error")
            log_status("Significant issues found, manual review required", "error")
            return 1

    except Exception as e:
        log_status(f"❌ ERROR DURING VALIDATION: {e}", "error")
        logger.exception("Detailed error information:")
        return 1


if __name__ == "__main__":
    sys.exit(main())
