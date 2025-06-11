#!/usr/bin/env python3
"""
Simple Sync Script for Testing - GRUPO US VIBECODE SYSTEM V4.0
Python Migration from PowerShell
Author: Augment Agent - Performance Optimization System
Date: 2025-01-27
"""

import shutil
import sys
from pathlib import Path

from loguru import logger
from rich.console import Console

# Initialize rich console
console = Console()


def log_status(message: str, status_type: str = "info") -> None:
    """Log status message with appropriate color."""
    if status_type == "success":
        console.print(message, style="green")
        logger.success(message.replace("✅ ", "").replace("🎉 ", ""))
    elif status_type == "warning":
        console.print(message, style="yellow")
        logger.warning(message.replace("⚠️ ", "").replace("📁 ", ""))
    elif status_type == "error":
        console.print(message, style="red")
        logger.error(message.replace("❌ ", ""))
    else:
        console.print(message, style="cyan")
        logger.info(message.replace("🚀 ", "").replace("📋 ", ""))


def check_file_exists(file_path: Path, description: str) -> bool:
    """Check if a file exists and log the result."""
    if file_path.exists():
        log_status(f"✅ {description} Found", "success")
        return True
    else:
        log_status(f"❌ {description} Missing", "error")
        return False


def create_directory_if_not_exists(dir_path: Path, description: str) -> None:
    """Create directory if it doesn't exist."""
    if not dir_path.exists():
        dir_path.mkdir(parents=True, exist_ok=True)
        log_status(f"📁 Created {description} directory", "warning")


def copy_file_safely(source: Path, destination: Path, description: str) -> bool:
    """Copy file safely with error handling."""
    try:
        # Ensure destination directory exists
        destination.parent.mkdir(parents=True, exist_ok=True)
        
        # Copy the file
        shutil.copy2(source, destination)
        log_status(f"✅ {description} synchronized", "success")
        return True
    except Exception as e:
        log_status(f"❌ Failed to synchronize {description}: {e}", "error")
        return False


def main() -> int:
    """Main execution function."""
    try:
        log_status("🚀 VIBECODE SYSTEM V4.0 - Simple Sync Test", "info")
        
        # Define paths
        master_rule_path = Path("@project-core/memory/master_rule.md")
        constitution_path = Path("@project-core/rules/00-vibecode-system-v4-master.md")
        vscode_config_path = Path("@project-core/configs/ide/vscode/settings.json")
        cursor_config_path = Path("@project-core/configs/ide/cursor/.cursorrules")
        
        # Test if critical files exist
        all_files_exist = True
        
        if not check_file_exists(master_rule_path, "Master Rule"):
            all_files_exist = False
        
        if not check_file_exists(constitution_path, "Constitution"):
            all_files_exist = False
        
        if not check_file_exists(vscode_config_path, "VS Code Config"):
            all_files_exist = False
        
        if not check_file_exists(cursor_config_path, "Cursor Config"):
            all_files_exist = False
        
        if not all_files_exist:
            log_status("❌ Critical files missing. Cannot proceed with synchronization.", "error")
            return 1
        
        # Create directories if they don't exist
        vscode_dir = Path(".vscode")
        cursor_dir = Path(".cursor")
        
        create_directory_if_not_exists(vscode_dir, ".vscode")
        create_directory_if_not_exists(cursor_dir, ".cursor")
        
        # Copy configurations
        sync_success = True
        
        # VS Code settings
        if not copy_file_safely(
            vscode_config_path,
            vscode_dir / "settings.json",
            "VS Code settings"
        ):
            sync_success = False
        
        # VS Code MCP configuration (optional)
        vscode_mcp_path = Path("@project-core/configs/ide/vscode/mcp.json")
        if vscode_mcp_path.exists():
            if not copy_file_safely(
                vscode_mcp_path,
                vscode_dir / "mcp.json",
                "VS Code MCP configuration"
            ):
                sync_success = False
        else:
            log_status("⚠️ VS Code MCP configuration not found", "warning")
        
        # Cursor rules
        if not copy_file_safely(
            cursor_config_path,
            Path(".cursorrules"),
            "Cursor rules"
        ):
            sync_success = False
        
        # Cursor MCP configuration
        cursor_mcp_path = Path("@project-core/configs/ide/cursor/mcp.json")
        if cursor_mcp_path.exists():
            if not copy_file_safely(
                cursor_mcp_path,
                cursor_dir / "mcp.json",
                "Cursor MCP"
            ):
                sync_success = False
        else:
            log_status("⚠️ Cursor MCP configuration not found", "warning")
        
        if sync_success:
            log_status("🎉 UNIFIED ENVIRONMENT SYNCHRONIZED SUCCESSFULLY", "success")
            log_status("📋 MCP Configuration Status:", "info")
            console.print("   - Master Config: @project-core/configs/mcp-master-unified.json", style="white")
            console.print("   - VS Code MCP: .vscode/mcp.json", style="white")
            console.print("   - Cursor MCP: .cursor/mcp.json", style="white")
            return 0
        else:
            log_status("❌ Some synchronization operations failed", "error")
            return 1
            
    except Exception as e:
        log_status(f"❌ Synchronization failed: {e}", "error")
        logger.exception("Detailed error information:")
        return 1


if __name__ == "__main__":
    # Setup basic logging
    logger.remove()
    logger.add(sys.stderr, level="INFO")
    
    sys.exit(main())
