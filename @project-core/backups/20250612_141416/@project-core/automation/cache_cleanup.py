#!/usr/bin/env python3
"""
===============================================================================
CACHE CLEANUP SCRIPT - GRUPO US VIBECODE SYSTEM V4.0
===============================================================================
Cleans development caches and temporary files for optimal performance
Author: Augment Agent - Performance Optimization System (Python Migration)
Date: 2025-01-27
===============================================================================
"""

import argparse
import os
import shutil
import subprocess
import sys
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Optional

from loguru import logger
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn
from send2trash import send2trash

# Initialize rich console
console = Console()

# Global counters
total_space_saved = 0.0
files_removed = 0
directories_removed = 0


def setup_logging(verbose: bool = False) -> None:
    """Setup logging configuration."""
    log_level = "DEBUG" if verbose else "INFO"
    logger.remove()
    logger.add(
        sys.stderr,
        format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>",
        level=log_level,
    )


def log_status(message: str, status_type: str = "info") -> None:
    """Log status message with appropriate color and level."""
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


def get_directory_size(path: Path) -> float:
    """Get directory size in MB."""
    if not path.exists():
        return 0.0
    
    try:
        total_size = sum(f.stat().st_size for f in path.rglob('*') if f.is_file())
        return round(total_size / (1024 * 1024), 2)
    except (OSError, PermissionError):
        return 0.0


def remove_cache_directory(path: Path, description: str, is_dry_run: bool = False) -> None:
    """Remove cache directory with size tracking."""
    global total_space_saved, directories_removed
    
    if not path.exists():
        logger.debug(f"⏭️ {description} not found: {path}")
        return
    
    size_mb = get_directory_size(path)
    
    if is_dry_run:
        log_status(f"  🔍 Would remove {description} ({size_mb} MB): {path}", "warning")
        total_space_saved += size_mb
        return
    
    try:
        if path.is_dir():
            shutil.rmtree(path)
        else:
            path.unlink()
        log_status(f"  ✅ Removed {description} ({size_mb} MB): {path}", "success")
        total_space_saved += size_mb
        directories_removed += 1
    except (OSError, PermissionError) as e:
        log_status(f"  ❌ Failed to remove {description}: {e}", "error")


def remove_cache_files(pattern: str, description: str, is_dry_run: bool = False) -> None:
    """Remove cache files matching pattern."""
    global total_space_saved, files_removed
    
    try:
        current_dir = Path.cwd()
        files = list(current_dir.rglob(pattern))
        
        if not files:
            logger.debug(f"  ⏭️ No {description} files found")
            return
        
        total_size = sum(f.stat().st_size for f in files if f.is_file())
        size_mb = round(total_size / (1024 * 1024), 2)
        
        if is_dry_run:
            log_status(f"  🔍 Would remove {len(files)} {description} files ({size_mb} MB)", "warning")
            total_space_saved += size_mb
            return
        
        for file_path in files:
            try:
                if file_path.is_file():
                    file_path.unlink()
            except (OSError, PermissionError):
                continue
        
        log_status(f"  ✅ Removed {len(files)} {description} files ({size_mb} MB)", "success")
        total_space_saved += size_mb
        files_removed += len(files)
    except Exception as e:
        log_status(f"  ❌ Error removing {description} files: {e}", "error")


def clear_nodejs_cache(skip_node_modules: bool = False, is_dry_run: bool = False) -> None:
    """Clean Node.js cache and related files."""
    log_status("=== CLEANING NODE.JS CACHE ===", "info")
    
    # Node modules (if not skipped)
    if not skip_node_modules:
        current_dir = Path.cwd()
        node_modules_dirs = list(current_dir.rglob("node_modules"))
        for node_dir in node_modules_dirs:
            remove_cache_directory(node_dir, "Node modules", is_dry_run)
    else:
        log_status("  ⏭️ Skipping node_modules cleanup as requested", "info")
    
    # NPM cache
    try:
        if not is_dry_run:
            subprocess.run(["npm", "cache", "clean", "--force"], 
                         capture_output=True, check=False)
            log_status("  ✅ NPM cache cleaned", "success")
        else:
            log_status("  🔍 Would clean NPM cache", "warning")
    except FileNotFoundError:
        log_status("  ⚠️ NPM cache clean failed (npm may not be available)", "warning")
    
    # Yarn cache
    try:
        if not is_dry_run:
            subprocess.run(["yarn", "cache", "clean"], 
                         capture_output=True, check=False)
            log_status("  ✅ Yarn cache cleaned", "success")
        else:
            log_status("  🔍 Would clean Yarn cache", "warning")
    except FileNotFoundError:
        log_status("  ⚠️ Yarn cache clean failed (yarn may not be available)", "warning")


def clear_nextjs_cache(is_dry_run: bool = False) -> None:
    """Clean Next.js cache."""
    log_status("=== CLEANING NEXT.JS CACHE ===", "info")
    
    # .next directory
    remove_cache_directory(Path(".next"), "Next.js build cache", is_dry_run)
    
    # Next.js cache in node_modules
    remove_cache_directory(Path("node_modules/.cache"), "Next.js node cache", is_dry_run)
    
    # Vercel cache
    remove_cache_directory(Path(".vercel"), "Vercel cache", is_dry_run)


def clear_figma_cache(is_dry_run: bool = False) -> None:
    """Clean Figma cache."""
    log_status("=== CLEANING FIGMA CACHE ===", "info")
    
    # Figma cache directories
    figma_cache_paths = [
        Path("@project-core/tools/figma-cache"),
        Path("@project-core/tools/figma-assets/cache"),
        Path("figma-cache"),
        Path(".figma-cache")
    ]
    
    for path in figma_cache_paths:
        remove_cache_directory(path, "Figma cache", is_dry_run)
    
    # Figma temporary files
    remove_cache_files("*.figma-temp", "Figma temporary", is_dry_run)
    remove_cache_files("figma-*.tmp", "Figma temp", is_dry_run)


def clear_development_cache(is_dry_run: bool = False) -> None:
    """Clean development cache files."""
    log_status("=== CLEANING DEVELOPMENT CACHE ===", "info")
    
    # TypeScript cache
    remove_cache_directory(Path(".tsbuildinfo"), "TypeScript build info", is_dry_run)
    remove_cache_files("*.tsbuildinfo", "TypeScript build info", is_dry_run)
    
    # ESLint cache
    remove_cache_files(".eslintcache", "ESLint cache", is_dry_run)
    
    # Jest cache
    remove_cache_directory(Path(".jest"), "Jest cache", is_dry_run)
    
    # Turbo cache
    remove_cache_directory(Path(".turbo"), "Turbo cache", is_dry_run)
    
    # SWC cache
    remove_cache_directory(Path(".swc"), "SWC cache", is_dry_run)


def clear_system_cache(is_dry_run: bool = False) -> None:
    """Clean system cache files."""
    log_status("=== CLEANING SYSTEM CACHE ===", "info")
    
    # Temporary files
    remove_cache_files("*.tmp", "temporary", is_dry_run)
    remove_cache_files("*.temp", "temp", is_dry_run)
    
    # Log files
    remove_cache_files("*.log", "log", is_dry_run)
    remove_cache_files("npm-debug.log*", "npm debug log", is_dry_run)
    remove_cache_files("yarn-error.log", "yarn error log", is_dry_run)
    
    # OS cache files
    remove_cache_files("Thumbs.db", "Windows thumbnail cache", is_dry_run)
    remove_cache_files(".DS_Store", "macOS system", is_dry_run)


def clear_backup_files(deep: bool = False, is_dry_run: bool = False) -> None:
    """Clean backup files."""
    log_status("=== CLEANING BACKUP FILES ===", "info")
    
    if deep:
        # Old backup directories (older than 7 days)
        current_dir = Path.cwd()
        cutoff_date = datetime.now() - timedelta(days=7)
        
        for backup_dir in current_dir.glob("backup-*"):
            if backup_dir.is_dir():
                creation_time = datetime.fromtimestamp(backup_dir.stat().st_ctime)
                if creation_time < cutoff_date:
                    remove_cache_directory(backup_dir, f"old backup ({backup_dir.name})", is_dry_run)
        
        # Backup files
        remove_cache_files("*.bak", "backup", is_dry_run)
        remove_cache_files("*~", "editor backup", is_dry_run)
    else:
        log_status("  ⏭️ Skipping backup cleanup (use --deep for backup cleanup)", "info")


def main() -> int:
    """Main execution function."""
    global total_space_saved, files_removed, directories_removed
    
    parser = argparse.ArgumentParser(
        description="Cache cleanup script for GRUPO US VIBECODE SYSTEM V4.0"
    )
    parser.add_argument("--deep", action="store_true", 
                       help="Perform deep cleanup including package locks and old backups")
    parser.add_argument("--dry-run", action="store_true",
                       help="Show what would be deleted without actually deleting")
    parser.add_argument("--verbose", action="store_true",
                       help="Show detailed information about cleanup process")
    parser.add_argument("--skip-node-modules", action="store_true",
                       help="Skip node_modules cleanup (useful for active development)")
    
    args = parser.parse_args()
    
    # Setup logging
    setup_logging(args.verbose)
    
    try:
        log_status("🧹 CACHE CLEANUP - GRUPO US VIBECODE SYSTEM V4.0", "info")
        log_status("================================================================", "info")
        
        if args.dry_run:
            log_status("🔍 DRY RUN MODE - No files will be deleted", "warning")
        
        if args.deep:
            log_status("🔥 DEEP CLEANUP MODE - Including package locks and backups", "warning")
        
        # Initialize counters
        total_space_saved = 0.0
        files_removed = 0
        directories_removed = 0
        
        # Run cleanup functions
        clear_nodejs_cache(args.skip_node_modules, args.dry_run)
        clear_nextjs_cache(args.dry_run)
        clear_figma_cache(args.dry_run)
        clear_development_cache(args.dry_run)
        clear_system_cache(args.dry_run)
        clear_backup_files(args.deep, args.dry_run)
        
        # Final summary
        log_status("================================================================", "info")
        log_status("🎉 CACHE CLEANUP COMPLETED!", "success")
        log_status("================================================================", "info")
        
        log_status("Summary:", "info")
        log_status(f"  📁 Directories removed: {directories_removed}", "info")
        log_status(f"  📄 Files removed: {files_removed}", "info")
        log_status(f"  💾 Space saved: {round(total_space_saved, 2)} MB", "success")
        
        if args.dry_run:
            log_status("  🔍 This was a dry run - no files were actually deleted", "warning")
            log_status("  ▶️ Run without --dry-run to perform actual cleanup", "info")
        
        log_status("Recommendations:", "info")
        log_status("  • Run this script weekly for optimal performance", "info")
        log_status("  • Use --deep monthly for thorough cleanup", "info")
        log_status("  • Monitor disk space regularly", "info")
        
        return 0
        
    except Exception as e:
        log_status(f"Cache cleanup failed: {e}", "error")
        logger.exception("Detailed error information:")
        return 1


if __name__ == "__main__":
    sys.exit(main())
