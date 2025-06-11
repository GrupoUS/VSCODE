#!/usr/bin/env python3
"""
===============================================================================
AUTO BACKUP SCRIPT - GRUPO US VIBECODE SYSTEM V4.0
===============================================================================
Creates incremental backups before critical changes
Author: Augment Agent - Data Protection System (Python Migration)
Date: 2025-01-27
===============================================================================
"""

import argparse
import json
import platform
import shutil
import subprocess
import sys
import zipfile
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from loguru import logger
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn

# Initialize rich console
console = Console()

# Global variables
backup_root = Path("@project-core/backups")
backup_timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
backup_path = backup_root / backup_timestamp


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
        console.print(f"[{timestamp}] {message}", style="cyan")
        logger.info(message)


def initialize_backup_environment() -> bool:
    """Initialize backup environment."""
    log_status("Initializing backup environment...", "info")
    
    try:
        # Create backup root directory if it doesn't exist
        if not backup_root.exists():
            backup_root.mkdir(parents=True, exist_ok=True)
            log_status(f"Created backup directory: {backup_root}", "success")
        
        # Create timestamped backup directory
        backup_path.mkdir(parents=True, exist_ok=True)
        log_status(f"Created backup path: {backup_path}", "success")
        
        return True
    except Exception as e:
        log_status(f"Failed to initialize backup environment: {e}", "error")
        return False


def get_critical_files() -> List[Path]:
    """Identify critical files for backup."""
    log_status("Identifying critical files for backup...", "info")
    
    critical_paths = [
        # Configuration files
        "@project-core/configs",
        "@project-core/memory",
        "@project-core/rules",
        
        # Scripts and automation
        "@project-core/automation",
        "@project-core/tools",
        "@project-core/scripts",
        
        # Documentation
        "@project-core/docs",
        
        # Project files
        "package.json",
        "package-lock.json",
        "yarn.lock",
        "tsconfig.json",
        "next.config.js",
        "tailwind.config.js",
        
        # Environment and config
        ".env.example",
        ".gitignore",
        "README.md",
        
        # Source code (if exists)
        "src",
        "pages",
        "app",
        "components",
        "lib",
        "utils",
        "styles",
        "public"
    ]
    
    existing_paths = []
    for path_str in critical_paths:
        path = Path(path_str)
        if path.exists():
            existing_paths.append(path)
            log_status(f"  ✅ Found: {path}", "success")
    
    log_status(f"Identified {len(existing_paths)} critical paths for backup", "info")
    return existing_paths


def create_incremental_backup(file_paths: List[Path], description: str) -> bool:
    """Create incremental backup."""
    log_status("Creating incremental backup...", "info")
    
    try:
        backup_manifest = {
            "timestamp": backup_timestamp,
            "type": "incremental",
            "description": description,
            "files": [],
            "total_size": 0
        }
        
        for path in file_paths:
            destination_path = backup_path / path
            
            # Create destination directory structure
            destination_path.parent.mkdir(parents=True, exist_ok=True)
            
            if path.is_dir():
                # Copy directory
                shutil.copytree(path, destination_path, dirs_exist_ok=True)
                size = sum(f.stat().st_size for f in path.rglob('*') if f.is_file())
            else:
                # Copy file
                shutil.copy2(path, destination_path)
                size = path.stat().st_size
            
            backup_manifest["files"].append({
                "path": str(path),
                "size": size,
                "last_modified": path.stat().st_mtime
            })
            
            backup_manifest["total_size"] += size
            log_status(f"  ✅ Backed up: {path}", "success")
        
        # Save backup manifest
        manifest_path = backup_path / "backup-manifest.json"
        with open(manifest_path, 'w', encoding='utf-8') as f:
            json.dump(backup_manifest, f, indent=2)
        
        size_mb = round(backup_manifest["total_size"] / (1024 * 1024), 2)
        log_status(f"Incremental backup completed: {size_mb} MB", "success")
        
        return True
    except Exception as e:
        log_status(f"Incremental backup failed: {e}", "error")
        return False


def create_git_backup(description: str, skip_git: bool = False) -> bool:
    """Create Git state backup."""
    if skip_git:
        log_status("Skipping Git backup as requested", "info")
        return True
    
    log_status("Creating Git state backup...", "info")
    
    try:
        # Check if we're in a Git repository
        result = subprocess.run(["git", "status"], 
                              capture_output=True, text=True, check=False)
        if result.returncode != 0:
            log_status("Not in a Git repository, skipping Git backup", "warning")
            return True
        
        # Get Git information
        branch_result = subprocess.run(["git", "branch", "--show-current"], 
                                     capture_output=True, text=True, check=False)
        current_branch = branch_result.stdout.strip() if branch_result.returncode == 0 else "unknown"
        
        log_result = subprocess.run(["git", "log", "--oneline", "-10"], 
                                  capture_output=True, text=True, check=False)
        recent_commits = log_result.stdout if log_result.returncode == 0 else "No commits found"
        
        status_result = subprocess.run(["git", "status", "--porcelain"], 
                                     capture_output=True, text=True, check=False)
        git_status = status_result.stdout if status_result.returncode == 0 else "Clean working directory"
        
        stash_result = subprocess.run(["git", "stash", "list"], 
                                    capture_output=True, text=True, check=False)
        stash_list = stash_result.stdout if stash_result.returncode == 0 else "No stashes"
        
        # Create Git info file
        git_info_path = backup_path / "git-info.txt"
        git_info = f"""Git Backup Information
Generated: {datetime.now()}
Description: {description}

Current Branch:
{current_branch}

Recent Commits:
{recent_commits}

Status:
{git_status}

Stash List:
{stash_list}
"""
        
        git_info_path.write_text(git_info, encoding='utf-8')
        
        # Create patch of uncommitted changes
        patch_result = subprocess.run(["git", "diff"], 
                                    capture_output=True, text=True, check=False)
        if patch_result.returncode == 0:
            patch_path = backup_path / "uncommitted-changes.patch"
            patch_path.write_text(patch_result.stdout, encoding='utf-8')
        
        # Create patch of staged changes
        staged_result = subprocess.run(["git", "diff", "--cached"], 
                                     capture_output=True, text=True, check=False)
        if staged_result.returncode == 0:
            staged_patch_path = backup_path / "staged-changes.patch"
            staged_patch_path.write_text(staged_result.stdout, encoding='utf-8')
        
        log_status("Git state backup completed", "success")
        return True
    except Exception as e:
        log_status(f"Git backup failed: {e}", "error")
        return False


def compress_backup(compress: bool = False) -> bool:
    """Compress backup if requested."""
    if not compress:
        log_status("Skipping compression", "info")
        return True
    
    log_status("Compressing backup...", "info")
    
    try:
        archive_path = backup_path.with_suffix('.zip')
        
        with zipfile.ZipFile(archive_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for file_path in backup_path.rglob('*'):
                if file_path.is_file():
                    arcname = file_path.relative_to(backup_path)
                    zipf.write(file_path, arcname)
        
        # Remove uncompressed backup
        shutil.rmtree(backup_path)
        
        archive_size = round(archive_path.stat().st_size / (1024 * 1024), 2)
        log_status(f"Backup compressed: {archive_size} MB", "success")
        
        return True
    except Exception as e:
        log_status(f"Compression failed: {e}", "error")
        return False


def remove_old_backups(retention_days: int) -> bool:
    """Remove old backups based on retention policy."""
    log_status(f"Cleaning up old backups (retention: {retention_days} days)...", "info")
    
    try:
        cutoff_date = datetime.now() - timedelta(days=retention_days)
        removed_count = 0
        space_saved = 0
        
        for backup_item in backup_root.iterdir():
            if backup_item.is_dir() or backup_item.suffix == '.zip':
                creation_time = datetime.fromtimestamp(backup_item.stat().st_ctime)
                if creation_time < cutoff_date:
                    try:
                        if backup_item.is_dir():
                            size = sum(f.stat().st_size for f in backup_item.rglob('*') if f.is_file())
                            shutil.rmtree(backup_item)
                        else:
                            size = backup_item.stat().st_size
                            backup_item.unlink()
                        
                        space_saved += size
                        removed_count += 1
                        log_status(f"  🗑️ Removed old backup: {backup_item.name}", "info")
                    except Exception:
                        log_status(f"  ❌ Failed to remove: {backup_item.name}", "warning")
        
        if removed_count > 0:
            space_saved_mb = round(space_saved / (1024 * 1024), 2)
            log_status(f"Removed {removed_count} old backups, freed {space_saved_mb} MB", "success")
        else:
            log_status("No old backups to remove", "info")
        
        return True
    except Exception as e:
        log_status(f"Cleanup failed: {e}", "error")
        return False


def generate_backup_report(backup_type: str, description: str, compress: bool, retention_days: int) -> bool:
    """Generate backup report."""
    log_status("Generating backup report...", "info")
    
    try:
        report_path = backup_path / "backup-report.md"
        
        report_content = f"""# Backup Report
**Timestamp**: {backup_timestamp}
**Type**: {backup_type}
**Description**: {description}
**Compression**: {"Enabled" if compress else "Disabled"}

## Backup Details
- **Backup Path**: {backup_path}
- **Created**: {datetime.now()}
- **Retention**: {retention_days} days

## System Information
- **Python Version**: {sys.version}
- **OS**: {platform.system()} {platform.release()}
- **Machine**: {platform.node()}
- **Architecture**: {platform.architecture()[0]}

## Next Steps
1. Verify backup integrity if needed
2. Test restore procedure periodically
3. Monitor backup storage space
4. Update retention policy as needed

---
*Generated by Auto-Backup System - GRUPO US VIBECODE SYSTEM V4.0*
"""
        
        report_path.write_text(report_content, encoding='utf-8')
        log_status(f"Backup report generated: {report_path}", "success")
        
        return True
    except Exception as e:
        log_status(f"Report generation failed: {e}", "error")
        return False


def main() -> int:
    """Main execution function."""
    parser = argparse.ArgumentParser(
        description="Automated backup script for GRUPO US VIBECODE SYSTEM V4.0"
    )
    parser.add_argument("--backup-type", default="incremental",
                       help="Type of backup to create (incremental, full)")
    parser.add_argument("--description", default="Automated backup",
                       help="Description of the backup for documentation")
    parser.add_argument("--compress", action="store_true",
                       help="Compress the backup into a ZIP file")
    parser.add_argument("--retention-days", type=int, default=7,
                       help="Number of days to keep old backups (default: 7)")
    parser.add_argument("--skip-git", action="store_true",
                       help="Skip Git state backup")
    
    args = parser.parse_args()
    
    # Setup logging
    logger.remove()
    logger.add(sys.stderr, level="INFO")
    
    try:
        log_status("💾 AUTO BACKUP - GRUPO US VIBECODE SYSTEM V4.0", "info")
        log_status("================================================================", "info")
        log_status(f"Backup Type: {args.backup_type}", "info")
        log_status(f"Description: {args.description}", "info")
        log_status(f"Compression: {'Enabled' if args.compress else 'Disabled'}", "info")
        log_status(f"Retention: {args.retention_days} days", "info")
        
        # Initialize backup environment
        if not initialize_backup_environment():
            return 1
        
        # Get critical files
        critical_files = get_critical_files()
        if not critical_files:
            log_status("No critical files found for backup", "warning")
            return 1
        
        # Create incremental backup
        if not create_incremental_backup(critical_files, args.description):
            return 1
        
        # Create Git backup
        if not create_git_backup(args.description, args.skip_git):
            log_status("Git backup failed, but continuing...", "warning")
        
        # Generate report
        if not generate_backup_report(args.backup_type, args.description, args.compress, args.retention_days):
            log_status("Report generation failed, but continuing...", "warning")
        
        # Compress if requested
        if not compress_backup(args.compress):
            log_status("Compression failed, but backup is complete", "warning")
        
        # Clean up old backups
        if not remove_old_backups(args.retention_days):
            log_status("Cleanup failed, but backup is complete", "warning")
        
        # Final success message
        log_status("================================================================", "info")
        log_status("🎉 AUTO BACKUP COMPLETED SUCCESSFULLY!", "success")
        log_status("================================================================", "info")
        
        final_path = backup_path.with_suffix('.zip') if args.compress else backup_path
        log_status(f"Backup Location: {final_path}", "success")
        log_status(f"Files Backed Up: {len(critical_files)}", "info")
        
        return 0
        
    except Exception as e:
        log_status(f"Auto backup failed: {e}", "error")
        logger.exception("Detailed error information:")
        return 1


if __name__ == "__main__":
    sys.exit(main())
