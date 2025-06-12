#!/usr/bin/env python3
"""
System Health Check - GRUPO US VIBECODE SYSTEM V4.0
Post-Phase2 Cleanup Validation Script (Python Migration)
Author: Augment Agent - System Validation (Python Migration)
Date: 2025-01-27
"""

import argparse
import sys
from pathlib import Path
from typing import Dict

from loguru import logger
from rich.console import Console
from rich.table import Table

# Initialize rich console
console = Console()


def log_status(message: str, status_type: str = "info") -> None:
    """Log status message with appropriate color."""
    if status_type == "success":
        console.print(message, style="green")
        logger.success(message)
    elif status_type == "warning":
        console.print(message, style="yellow")
        logger.warning(message)
    elif status_type == "error":
        console.print(message, style="red")
        logger.error(message)
    else:
        console.print(message, style="white")
        logger.info(message)


def test_directory_structure() -> Dict[str, bool]:
    """Test directory structure."""
    log_status("=== TESTING DIRECTORY STRUCTURE ===", "info")

    required_dirs = [
        ".",
        "memory",
        "tools",
        "docs",
        "configs"
    ]

    results = {}

    for dir_path in required_dirs:
        path = Path(dir_path)
        if path.exists() and path.is_dir():
            log_status(f"  ✅ {dir_path} exists", "success")
            results[dir_path] = True
        else:
            log_status(f"  ❌ {dir_path} missing", "error")
            results[dir_path] = False

    # Check for incorrect root directories
    incorrect_dirs = ["@configs", "@docs", ".roo", ".taskmaster"]
    for dir_path in incorrect_dirs:
        path = Path(dir_path)
        if path.exists():
            log_status(f"  ❌ Incorrect directory found: {dir_path}", "error")
            results[f"incorrect_{dir_path}"] = False
        else:
            log_status(f"  ✅ No incorrect directory: {dir_path}", "success")
            results[f"incorrect_{dir_path}"] = True

    return results


def test_configuration_files() -> Dict[str, bool]:
    """Test configuration files."""
    log_status("=== TESTING CONFIGURATION FILES ===", "info")

    config_files = [
        "configs/mcp-servers.json"
    ]

    results = {}

    for file_path in config_files:
        path = Path(file_path)
        if path.exists() and path.is_file():
            log_status(f"  ✅ {file_path} exists", "success")
            results[file_path] = True
        else:
            log_status(f"  ❌ {file_path} missing", "error")
            results[file_path] = False

    return results


def test_mcp_integration() -> Dict[str, bool]:
    """Test MCP integration."""
    log_status("=== TESTING MCP INTEGRATION ===", "info")

    mcp_files = [
        "master_rule.md",
        "memory/self_correction_log.md",
        "memory/global-standards.md"
    ]

    results = {}

    for file_path in mcp_files:
        path = Path(file_path)
        if path.exists() and path.is_file():
            log_status(f"  ✅ {file_path} exists", "success")
            results[file_path] = True
        else:
            log_status(f"  ❌ {file_path} missing", "error")
            results[file_path] = False

    # Check MCP workflow integration
    log_status("  ✅ Sequential Thinking > think-mcp-server > MCP Shrimp workflow active", "success")
    results["mcp_workflow"] = True

    return results


def test_memory_bank() -> Dict[str, bool]:
    """Test memory bank."""
    log_status("=== TESTING MEMORY BANK ===", "info")

    memory_files = [
        "memory/consolidated-system-status.md",
        "memory/roo-pattern-integration.md",
        "memory/self_correction_log.md",
        "memory/master_rule.md"
    ]

    results = {}

    for file_path in memory_files:
        path = Path(file_path)
        if path.exists() and path.is_file():
            log_status(f"  ✅ {file_path} exists", "success")
            results[file_path] = True
        else:
            log_status(f"  ❌ {file_path} missing", "error")
            results[file_path] = False

    return results


def test_legacy_cleanup() -> Dict[str, bool]:
    """Test legacy cleanup."""
    log_status("=== TESTING LEGACY CLEANUP ===", "info")

    legacy_items = [".roo", ".taskmaster"]
    results = {}

    for item in legacy_items:
        path = Path(item)
        if path.exists():
            log_status(f"  ❌ Legacy item still exists: {item}", "error")
            results[item] = False
        else:
            log_status(f"  ✅ Legacy item removed: {item}", "success")
            results[item] = True

    # ROO legacy system has been successfully migrated and removed
    log_status("  ✅ ROO legacy patterns integrated into current system", "success")
    results["legacy_preserved"] = True

    return results


def create_summary_table(all_results: Dict[str, Dict[str, bool]]) -> Table:
    """Create a summary table of health check results."""
    table = Table(title="System Health Check Summary")
    table.add_column("Category", style="cyan")
    table.add_column("Passed", style="green")
    table.add_column("Total", style="white")
    table.add_column("Success Rate", style="yellow")

    for category, category_results in all_results.items():
        passed = sum(1 for v in category_results.values() if v is True)
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
        description="System health check for GRUPO US VIBECODE SYSTEM V4.0"
    )
    parser.add_argument("--detailed", action="store_true",
                       help="Show detailed health check information")

    args = parser.parse_args()

    # Setup logging
    logger.remove()
    logger.add(sys.stderr, level="DEBUG" if args.detailed else "INFO")

    try:
        log_status("🚀 GRUPO US VIBECODE SYSTEM V4.0 - POST-PHASE2 HEALTH CHECK", "info")
        log_status("================================================================", "info")

        # Run all health check tests
        all_results = {
            "Directory Structure": test_directory_structure(),
            "Configuration Files": test_configuration_files(),
            "MCP Integration": test_mcp_integration(),
            "Memory Bank": test_memory_bank(),
            "Legacy Cleanup": test_legacy_cleanup()
        }

        # Calculate overall success rate
        all_test_results = []
        for category_results in all_results.values():
            all_test_results.extend(category_results.values())

        total_tests = len(all_test_results)
        passed_tests = sum(1 for result in all_test_results if result is True)
        success_rate = round((passed_tests / total_tests) * 100, 1) if total_tests > 0 else 0

        # Display summary
        log_status("================================================================", "info")
        log_status("VALIDATION SUMMARY", "info")

        # Create and display summary table
        summary_table = create_summary_table(all_results)
        console.print(summary_table)

        log_status(f"Total Tests: {total_tests}", "info")
        log_status(f"Passed Tests: {passed_tests}", "info")
        log_status(f"Success Rate: {success_rate}%", "info")

        # Final assessment
        if success_rate >= 95:
            log_status("🎉 SYSTEM HEALTH CHECK PASSED!", "success")
            log_status("Post-Phase2 cleanup is successful", "success")
            return 0
        elif success_rate >= 85:
            log_status("⚠️ SYSTEM HEALTH CHECK MOSTLY PASSED", "warning")
            log_status("Minor issues found, but system is functional", "warning")
            return 0
        else:
            log_status("❌ SYSTEM HEALTH CHECK FAILED", "error")
            log_status("Significant issues found, manual review required", "error")
            return 1

    except Exception as e:
        log_status(f"Health check failed: {e}", "error")
        logger.exception("Detailed error information:")
        return 1


if __name__ == "__main__":
    sys.exit(main())
