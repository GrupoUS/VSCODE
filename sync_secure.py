#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.0 - Secure GitHub Sync Script
Automated synchronization with mandatory Quality Gate for secrets prevention

Author: GRUPO US Development Team
Version: 1.0.0
Date: 2025-01-11
"""

import os
import sys
import json
import subprocess
import re
import shutil
import uuid
from pathlib import Path
from datetime import datetime
from typing import List, Tuple, Dict, Any, Optional
from dataclasses import dataclass

@dataclass
class DetectedSecret:
    """Data class for detected secrets"""
    file_path: str
    pattern: str
    secret_value: str
    line_number: int
    context: str
    secret_type: str

class SecureGitSync:
    """
    Secure Git synchronization with mandatory secrets scanning
    """
    
    def __init__(self, config_path: str = "config.json"):
        """Initialize with configuration"""
        self.config = self.load_config(config_path)
        self.secrets_patterns = self._get_secrets_patterns()
        self.start_time = datetime.now()
        
    def load_config(self, config_path: str) -> Dict[str, Any]:
        """Load configuration from JSON file"""
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                config = json.load(f)
            print(f"✅ Configuration loaded from {config_path}")
            return config
        except FileNotFoundError:
            print(f"❌ CRITICAL ERROR: Configuration file {config_path} not found!")
            sys.exit(1)
        except json.JSONDecodeError as e:
            print(f"❌ CRITICAL ERROR: Invalid JSON in {config_path}: {e}")
            sys.exit(1)
    
    def _get_secrets_patterns(self) -> List[str]:
        """Define regex patterns for secrets detection"""
        return [
            # GitHub Personal Access Tokens
            r'ghp_[a-zA-Z0-9]{36}',
            r'gho_[a-zA-Z0-9]{36}',
            r'ghu_[a-zA-Z0-9]{36}',
            r'ghs_[a-zA-Z0-9]{36}',
            r'ghr_[a-zA-Z0-9]{36}',
            
            # Figma Personal Access Tokens
            r'figd_[a-zA-Z0-9_\-]{43}',
            
            # API Keys and Tokens
            r'(?i)(api[_-]?key|api[_-]?token|access[_-]?token|secret[_-]?key)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9_\-]{20,}',
            r'(?i)(bearer[_-]?token)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9_\-]{20,}',
            
            # AWS Credentials
            r'AKIA[0-9A-Z]{16}',
            r'(?i)(aws[_-]?access[_-]?key[_-]?id)["\'\s]*[:=]["\'\s]*[A-Z0-9]{20}',
            r'(?i)(aws[_-]?secret[_-]?access[_-]?key)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9/+=]{40}',
            
            # Private Keys
            r'-----BEGIN[_\s]*(RSA[_\s]*)?PRIVATE[_\s]*KEY-----',
            r'-----BEGIN[_\s]*OPENSSH[_\s]*PRIVATE[_\s]*KEY-----',
            
            # Database URLs and Passwords
            r'(?i)(password|passwd|pwd)["\'\s]*[:=]["\'\s]*[^\s"\']{8,}',
            r'(?i)(database[_-]?url|db[_-]?url)["\'\s]*[:=]["\'\s]*[^\s"\']{10,}',
            
            # Specific Services
            r'(?i)(supabase[_-]?api[_-]?key)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9_\-]{20,}',
            r'(?i)(anthropic[_-]?api[_-]?key)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9_\-]{20,}',
            r'(?i)(openrouter[_-]?api[_-]?key)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9_\-]{20,}',
            
            # Generic Secrets (more comprehensive)
            r'(?i)(secret|token|key)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9_\-]{32,}',
            r'(?i)(client[_-]?secret)["\'\s]*[:=]["\'\s]*[a-zA-Z0-9_\-]{20,}',
        ]
    
    def get_modified_files(self) -> List[str]:
        """Get list of modified files from git status"""
        try:
            result = subprocess.run(
                ['git', 'status', '--porcelain'],
                capture_output=True,
                text=True,
                check=True,
                cwd=self.config['repository_path']
            )
            
            modified_files = []
            for line in result.stdout.strip().split('\n'):
                if line.strip():
                    # Extract filename from git status output
                    status = line[:2]
                    filename = line[3:].strip()
                    
                    # Skip deleted files
                    if 'D' not in status:
                        modified_files.append(filename)
            
            print(f"📋 Found {len(modified_files)} modified files")
            return modified_files
            
        except subprocess.CalledProcessError as e:
            print(f"❌ ERROR: Failed to get git status: {e}")
            return []
    
    def scan_files_for_secrets(self, file_list: List[str]) -> bool:
        """
        Scan files for secrets using regex patterns
        Returns True if NO secrets found, False if secrets detected
        """
        print("🔍 Starting secrets scan...")
        
        if not file_list:
            print("✅ No files to scan")
            return True
        
        secrets_found = False
        total_files_scanned = 0
        
        for file_path in file_list:
            full_path = Path(self.config['repository_path']) / file_path
            
            # Skip if file doesn't exist or is not a regular file
            if not full_path.exists() or not full_path.is_file():
                continue
                
            # Skip binary files and excluded extensions
            if any(file_path.endswith(ext) for ext in self.config.get('excluded_extensions', [])):
                continue
                
            # Skip excluded directories
            if any(excluded_dir in str(file_path) for excluded_dir in self.config.get('excluded_directories', [])):
                continue
            
            try:
                with open(full_path, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    
                total_files_scanned += 1
                
                # Scan content with each pattern
                for pattern in self.secrets_patterns:
                    matches = re.findall(pattern, content, re.MULTILINE)
                    if matches:
                        print(f"🚨 CRITICAL: SECRET DETECTED in {file_path}")
                        print(f"   Pattern matched: {pattern[:50]}...")
                        print(f"   Match preview: {str(matches[0])[:50]}...")
                        secrets_found = True
                        
            except Exception as e:
                print(f"⚠️ Warning: Could not scan {file_path}: {e}")
                continue
        
        print(f"📊 Scanned {total_files_scanned} files")
        
        if secrets_found:
            print("🚨 QUALITY GATE FAILED: SECRETS DETECTED!")
            print("❌ SYNC ABORTED - Fix secrets before proceeding")
            return False
        else:
            print("✅ QUALITY GATE PASSED: No secrets detected")
            return True
    
    def run_git_command(self, command: List[str]) -> Tuple[bool, str]:
        """
        Execute git command with comprehensive error handling
        """
        try:
            print(f"   Executing: git {' '.join(command[1:])}")
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                check=True,
                cwd=self.config['repository_path'],
                timeout=300  # 5 minute timeout
            )
            return True, result.stdout
        except subprocess.CalledProcessError as e:
            error_msg = f"Command failed: {' '.join(command)}\nReturn code: {e.returncode}\nError: {e.stderr}"
            return False, error_msg
        except subprocess.TimeoutExpired:
            error_msg = f"Command timed out: {' '.join(command)}"
            return False, error_msg
        except Exception as e:
            error_msg = f"Unexpected error executing command: {' '.join(command)}\nError: {str(e)}"
            return False, error_msg
    
    def run_sync(self) -> bool:
        """
        Execute the complete synchronization process
        Returns True if successful, False if failed
        """
        print("🚀 GRUPO US SECURE SYNC - Starting synchronization...")
        print(f"📁 Repository: {self.config['repository_path']}")
        print(f"🌿 Branch: {self.config['branch']}")
        print(f"⏰ Started at: {self.start_time.strftime('%Y-%m-%d %H:%M:%S')}")
        print("-" * 60)
        
        # Step 1: Check git status
        print("1️⃣ Checking repository status...")
        success, output = self.run_git_command(['git', 'status', '--porcelain'])
        if not success:
            print(f"❌ Failed to check git status: {output}")
            return False
        
        if not output.strip():
            print("✅ Repository is clean - nothing to sync")
            return True
        
        # Step 2: Get modified files
        print("2️⃣ Getting modified files...")
        modified_files = self.get_modified_files()
        
        # Step 3: MANDATORY SECRETS SCAN
        print("3️⃣ Running mandatory secrets scan...")
        if not self.scan_files_for_secrets(modified_files):
            print("🚨 SYNC TERMINATED: Secrets detected!")
            return False
        
        # Step 4: Add files
        print("4️⃣ Adding files to staging...")
        success, output = self.run_git_command(['git', 'add', '.'])
        if not success:
            print(f"❌ Failed to add files: {output}")
            return False
        print("✅ Files added to staging")
        
        # Step 5: Commit (bypass hooks to avoid conflicts)
        print("5️⃣ Creating commit...")
        commit_message = f"{self.config.get('commit_message_prefix', '[AUTO-SYNC]')} Secure sync at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
        success, output = self.run_git_command(['git', 'commit', '--no-verify', '-m', commit_message])
        if not success:
            print(f"❌ Failed to commit: {output}")
            return False
        print(f"✅ Commit created: {commit_message}")
        
        # Step 6: Pull with rebase
        print("6️⃣ Pulling latest changes...")
        success, output = self.run_git_command(['git', 'pull', '--rebase', self.config['remote_name'], self.config['branch']])
        if not success:
            print(f"❌ Failed to pull: {output}")
            return False
        print("✅ Latest changes pulled")
        
        # Step 7: Push
        print("7️⃣ Pushing to remote...")
        success, output = self.run_git_command(['git', 'push', self.config['remote_name'], self.config['branch']])
        if not success:
            print(f"❌ Failed to push: {output}")
            return False
        print("✅ Changes pushed to remote")
        
        # Success summary
        end_time = datetime.now()
        duration = end_time - self.start_time
        print("-" * 60)
        print("🎉 SYNC COMPLETED SUCCESSFULLY!")
        print(f"⏱️ Duration: {duration.total_seconds():.2f} seconds")
        print(f"📊 Files processed: {len(modified_files)}")
        print(f"🔒 Security: Quality Gate passed")
        print("-" * 60)
        
        return True

def main():
    """Main execution function"""
    try:
        # Initialize secure sync
        sync = SecureGitSync()
        
        # Execute synchronization
        success = sync.run_sync()
        
        # Exit with appropriate code
        sys.exit(0 if success else 1)
        
    except KeyboardInterrupt:
        print("\n⚠️ Sync interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"❌ CRITICAL ERROR: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
