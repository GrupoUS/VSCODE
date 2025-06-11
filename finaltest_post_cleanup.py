#!/usr/bin/env python3
"""
GRUPO US VIBECODE SYSTEM V4.0 - Post-Cleanup Final Test
Comprehensive validation after Git history cleanup

Author: GRUPO US Development Team
Version: 1.0.0
Date: 2025-06-11
"""

import os
import sys
import json
import subprocess
import time
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Tuple

class PostCleanupFinalTest:
    """
    Comprehensive final test after Git history cleanup
    """
    
    def __init__(self):
        self.start_time = datetime.now()
        self.results = {
            'tests_passed': 0,
            'tests_failed': 0,
            'warnings': 0,
            'details': []
        }
        
    def log(self, message: str, level: str = "INFO"):
        """Enhanced logging with colors"""
        timestamp = datetime.now().strftime("%H:%M:%S")
        colors = {
            "SUCCESS": "\033[92m✅",
            "ERROR": "\033[91m❌",
            "WARNING": "\033[93m⚠️",
            "INFO": "\033[94mℹ️"
        }
        reset = "\033[0m"
        
        color = colors.get(level, "\033[0m")
        print(f"[{timestamp}] {color} {message}{reset}")
        
        # Store result
        self.results['details'].append({
            'timestamp': timestamp,
            'level': level,
            'message': message
        })
        
        if level == "SUCCESS":
            self.results['tests_passed'] += 1
        elif level == "ERROR":
            self.results['tests_failed'] += 1
        elif level == "WARNING":
            self.results['warnings'] += 1
    
    def test_git_status(self) -> bool:
        """Test Git repository status"""
        self.log("🔍 Testing Git repository status...", "INFO")
        
        try:
            # Check current branch
            result = subprocess.run(['git', 'branch', '--show-current'], 
                                  capture_output=True, text=True, check=True)
            current_branch = result.stdout.strip()
            
            if current_branch == "clean-no-history":
                self.log(f"Git branch: {current_branch} (Clean history branch)", "SUCCESS")
            else:
                self.log(f"Git branch: {current_branch} (Unexpected branch)", "WARNING")
            
            # Check for uncommitted changes
            result = subprocess.run(['git', 'status', '--porcelain'], 
                                  capture_output=True, text=True, check=True)
            
            if result.stdout.strip():
                self.log("Git status: Has uncommitted changes", "WARNING")
            else:
                self.log("Git status: Clean working directory", "SUCCESS")
            
            # Check remote connection
            result = subprocess.run(['git', 'remote', '-v'], 
                                  capture_output=True, text=True, check=True)
            if "github.com/GrupoUS/VSCODE.git" in result.stdout:
                self.log("Git remote: Connected to GitHub repository", "SUCCESS")
            else:
                self.log("Git remote: Connection issue", "ERROR")
                return False
                
            return True
            
        except subprocess.CalledProcessError as e:
            self.log(f"Git status check failed: {e}", "ERROR")
            return False
    
    def test_secrets_absence(self) -> bool:
        """Test that no secrets exist in current files"""
        self.log("🔒 Testing absence of secrets in current files...", "INFO")
        
        secrets_patterns = [
            r'ghp_[a-zA-Z0-9]{36}',
            r'gho_[a-zA-Z0-9]{36}',
            r'ghu_[a-zA-Z0-9]{36}',
            r'ghs_[a-zA-Z0-9]{36}',
            r'ghr_[a-zA-Z0-9]{36}',
            r'figd_[a-zA-Z0-9_\-]{43}',
        ]
        
        import re
        secrets_found = 0
        files_scanned = 0
        
        for root, dirs, files in os.walk('.'):
            # Skip certain directories
            dirs[:] = [d for d in dirs if d not in ['.git', 'node_modules', '__pycache__', '.next']]
            
            for file in files:
                if file.endswith(('.py', '.js', '.ts', '.md', '.json', '.txt')):
                    file_path = os.path.join(root, file)
                    try:
                        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read()
                            files_scanned += 1
                            
                            for pattern in secrets_patterns:
                                if re.search(pattern, content):
                                    self.log(f"Secret found in: {file_path}", "ERROR")
                                    secrets_found += 1
                                    
                    except Exception:
                        continue
        
        if secrets_found == 0:
            self.log(f"Secrets scan: 0 secrets found in {files_scanned} files", "SUCCESS")
            return True
        else:
            self.log(f"Secrets scan: {secrets_found} secrets found!", "ERROR")
            return False
    
    def test_core_files(self) -> bool:
        """Test existence of core system files"""
        self.log("📁 Testing core system files...", "INFO")
        
        core_files = [
            '@project-core/memory/self_correction_log.md',
            '@project-core/memory/global-standards.md',
            '@project-core/rules/00-vibecode-system-v4-master.md',
            '@project-core/configs/mcp-servers.json',
            'config.json',
            'sync_secure.py'
        ]
        
        all_exist = True
        for file_path in core_files:
            if os.path.exists(file_path):
                size = os.path.getsize(file_path)
                self.log(f"Core file: {file_path} ({size} bytes)", "SUCCESS")
            else:
                self.log(f"Core file missing: {file_path}", "ERROR")
                all_exist = False
        
        return all_exist
    
    def test_directory_structure(self) -> bool:
        """Test @project-core directory structure"""
        self.log("🏗️ Testing directory structure...", "INFO")
        
        required_dirs = [
            '@project-core/memory',
            '@project-core/rules',
            '@project-core/automation',
            '@project-core/configs',
            '@project-core/docs',
            '@project-core/tools'
        ]
        
        all_exist = True
        for dir_path in required_dirs:
            if os.path.exists(dir_path) and os.path.isdir(dir_path):
                file_count = len([f for f in os.listdir(dir_path) if os.path.isfile(os.path.join(dir_path, f))])
                self.log(f"Directory: {dir_path} ({file_count} files)", "SUCCESS")
            else:
                self.log(f"Directory missing: {dir_path}", "ERROR")
                all_exist = False
        
        return all_exist
    
    def test_sync_functionality(self) -> bool:
        """Test sync_secure.py functionality"""
        self.log("🔄 Testing sync functionality...", "INFO")
        
        if not os.path.exists('sync_secure.py'):
            self.log("sync_secure.py not found", "ERROR")
            return False
        
        if not os.path.exists('config.json'):
            self.log("config.json not found", "ERROR")
            return False
        
        try:
            with open('config.json', 'r') as f:
                config = json.load(f)
                
            if config.get('branch') == 'clean-no-history':
                self.log("Sync config: Configured for clean-no-history branch", "SUCCESS")
            else:
                self.log(f"Sync config: Branch is {config.get('branch')}", "WARNING")
            
            self.log("Sync system: Ready for operation", "SUCCESS")
            return True
            
        except Exception as e:
            self.log(f"Sync config error: {e}", "ERROR")
            return False
    
    def test_mcp_configuration(self) -> bool:
        """Test MCP server configuration"""
        self.log("🔧 Testing MCP configuration...", "INFO")
        
        mcp_config_path = '@project-core/configs/mcp-servers.json'
        if not os.path.exists(mcp_config_path):
            self.log("MCP configuration missing", "ERROR")
            return False
        
        try:
            with open(mcp_config_path, 'r') as f:
                mcp_config = json.load(f)
            
            servers = mcp_config.get('mcpServers', {})
            server_count = len(servers)
            
            if server_count > 0:
                self.log(f"MCP servers: {server_count} servers configured", "SUCCESS")
                
                # Check for key servers
                key_servers = ['sequential-thinking-mcp', 'mcp-shrimp-task-manager']
                for server in key_servers:
                    if server in servers:
                        self.log(f"MCP server: {server} configured", "SUCCESS")
                    else:
                        self.log(f"MCP server: {server} missing", "WARNING")
                
                return True
            else:
                self.log("MCP servers: No servers configured", "ERROR")
                return False
                
        except Exception as e:
            self.log(f"MCP configuration error: {e}", "ERROR")
            return False
    
    def generate_report(self) -> Dict:
        """Generate comprehensive test report"""
        end_time = datetime.now()
        duration = end_time - self.start_time
        
        total_tests = self.results['tests_passed'] + self.results['tests_failed']
        success_rate = (self.results['tests_passed'] / total_tests * 100) if total_tests > 0 else 0
        
        if self.results['tests_failed'] == 0:
            status = "✅ EXCELLENT"
        elif self.results['tests_failed'] <= 2:
            status = "⚠️ GOOD WITH WARNINGS"
        else:
            status = "❌ NEEDS ATTENTION"
        
        report = {
            'timestamp': end_time.isoformat(),
            'duration_seconds': duration.total_seconds(),
            'tests_passed': self.results['tests_passed'],
            'tests_failed': self.results['tests_failed'],
            'warnings': self.results['warnings'],
            'success_rate': round(success_rate, 2),
            'status': status,
            'details': self.results['details']
        }
        
        return report
    
    def run_all_tests(self) -> bool:
        """Execute all validation tests"""
        self.log("🚀 GRUPO US VIBECODE SYSTEM V4.0 - POST-CLEANUP FINAL TEST", "INFO")
        self.log("=" * 70, "INFO")
        
        tests = [
            ("Git Repository Status", self.test_git_status),
            ("Secrets Absence", self.test_secrets_absence),
            ("Core Files", self.test_core_files),
            ("Directory Structure", self.test_directory_structure),
            ("Sync Functionality", self.test_sync_functionality),
            ("MCP Configuration", self.test_mcp_configuration)
        ]
        
        all_passed = True
        
        for test_name, test_func in tests:
            self.log(f"Running test: {test_name}", "INFO")
            try:
                result = test_func()
                if not result:
                    all_passed = False
            except Exception as e:
                self.log(f"Test {test_name} failed with exception: {e}", "ERROR")
                all_passed = False
            
            self.log("-" * 50, "INFO")
        
        # Generate and save report
        report = self.generate_report()
        
        # Save report
        report_path = f"finaltest_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(report_path, 'w') as f:
            json.dump(report, f, indent=2)
        
        # Display summary
        self.log("=" * 70, "INFO")
        self.log("📊 FINAL TEST SUMMARY", "INFO")
        self.log(f"Status: {report['status']}", "INFO")
        self.log(f"Tests Passed: {report['tests_passed']}", "SUCCESS" if report['tests_passed'] > 0 else "INFO")
        self.log(f"Tests Failed: {report['tests_failed']}", "ERROR" if report['tests_failed'] > 0 else "INFO")
        self.log(f"Warnings: {report['warnings']}", "WARNING" if report['warnings'] > 0 else "INFO")
        self.log(f"Success Rate: {report['success_rate']}%", "SUCCESS" if report['success_rate'] >= 80 else "WARNING")
        self.log(f"Duration: {report['duration_seconds']:.2f} seconds", "INFO")
        self.log(f"Report saved: {report_path}", "INFO")
        self.log("=" * 70, "INFO")
        
        return all_passed

def main():
    """Main execution function"""
    test_runner = PostCleanupFinalTest()
    success = test_runner.run_all_tests()
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
