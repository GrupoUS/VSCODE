#!/usr/bin/env python3
"""
MCP CONFIGURATION VALIDATOR ENHANCED
GRUPO US VIBECODE SYSTEM V4.0

Enhanced validation script for unified MCP configuration system.
Supports validation, sync verification, and automatic repair.

Usage:
    python validate_mcp_configuration_enhanced.py --comprehensive
    python validate_mcp_configuration_enhanced.py --quick-check
    python validate_mcp_configuration_enhanced.py --repair-mode
    python validate_mcp_configuration_enhanced.py --sync-check
"""

import argparse
import json
import logging
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('@project-core/logs/mcp_validation.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class MCPConfigValidator:
    """Enhanced MCP Configuration Validator"""
    
    def __init__(self):
        self.master_config_path = Path("@project-core/configs/mcp-master-unified.json")
        self.cursor_config_path = Path(".cursor/mcp.json")
        self.vscode_config_path = Path(".vscode/mcp.json")
        self.legacy_configs = [
            Path("@project-core/configs/mcp-servers.json"),
            Path("@project-core/configs/playwright-mcp-config.json")
        ]
        
        self.error_count = 0
        self.warning_count = 0
        self.repair_count = 0
        
        logger.info("MCP Configuration Validator Enhanced initialized")
    
    def log_error(self, message: str):
        """Log validation error"""
        logger.error(f"ERROR: {message}")
        self.error_count += 1
    
    def log_warning(self, message: str):
        """Log validation warning"""
        logger.warning(f"WARNING: {message}")
        self.warning_count += 1
    
    def log_success(self, message: str):
        """Log validation success"""
        logger.info(f"SUCCESS: {message}")
    
    def log_repair(self, message: str):
        """Log repair action"""
        logger.info(f"REPAIR: {message}")
        self.repair_count += 1
    
    def validate_master_config(self) -> bool:
        """Validate master MCP configuration"""
        logger.info("Validating Master Configuration...")
        
        if not self.master_config_path.exists():
            self.log_error(f"Master configuration file not found: {self.master_config_path}")
            return False
        
        try:
            with open(self.master_config_path, 'r', encoding='utf-8') as f:
                master_config = json.load(f)
            
            self.log_success("Master configuration file loaded successfully")
            
            # Validate required sections
            required_sections = [
                ("metadata", True),
                ("mcpServers", True),
                ("unifiedSystemConfig", True),
                ("security", False),
                ("performance", False),
                ("logging", False)
            ]
            
            for section_name, is_critical in required_sections:
                if section_name not in master_config:
                    if is_critical:
                        self.log_error(f"Missing critical section: {section_name}")
                    else:
                        self.log_warning(f"Missing optional section: {section_name}")
                else:
                    self.log_success(f"Section '{section_name}' found")
            
            # Validate metadata
            if "metadata" in master_config:
                metadata = master_config["metadata"]
                if "version" in metadata:
                    self.log_success(f"Configuration version: {metadata['version']}")
                else:
                    self.log_warning("Missing version in metadata")
            
            # Validate MCP servers
            if "mcpServers" in master_config:
                self._validate_mcp_servers(master_config["mcpServers"])
            
            # Validate unified system config
            if "unifiedSystemConfig" in master_config:
                self._validate_unified_system_config(master_config["unifiedSystemConfig"])
            
            return self.error_count == 0
            
        except json.JSONDecodeError as e:
            self.log_error(f"Failed to parse master configuration: {e}")
            return False
        except Exception as e:
            self.log_error(f"Unexpected error validating master config: {e}")
            return False
    
    def _validate_mcp_servers(self, mcp_servers: Dict):
        """Validate MCP servers configuration"""
        logger.info("Validating MCP Servers Configuration...")
        
        server_count = len(mcp_servers)
        logger.info(f"Found {server_count} MCP servers")
        
        for server_name, server_config in mcp_servers.items():
            logger.info(f"Validating server: {server_name}")
            
            # Check required fields
            required_fields = [
                ("command", True),
                ("args", True),
                ("enabled", True),
                ("priority", False),
                ("capabilities", False)
            ]
            
            for field_name, is_critical in required_fields:
                if field_name not in server_config:
                    if is_critical:
                        self.log_error(f"Server '{server_name}' missing critical field: {field_name}")
                    else:
                        self.log_warning(f"Server '{server_name}' missing optional field: {field_name}")
                else:
                    self.log_success(f"Server '{server_name}' has field: {field_name}")
            
            # Validate command
            if "command" in server_config:
                valid_commands = ["npx", "cmd", "python", "node"]
                command = server_config["command"]
                if command in valid_commands:
                    self.log_success(f"Server '{server_name}' uses valid command: {command}")
                else:
                    self.log_warning(f"Server '{server_name}' uses non-standard command: {command}")
            
            # Validate enabled status
            if "enabled" in server_config:
                enabled = server_config["enabled"]
                if enabled is True:
                    self.log_success(f"Server '{server_name}' is enabled")
                elif enabled is False:
                    self.log_warning(f"Server '{server_name}' is disabled")
                else:
                    self.log_error(f"Server '{server_name}' has invalid enabled status: {enabled}")
            
            # Check for hardcoded secrets
            if "env" in server_config:
                self._check_environment_variables(server_name, server_config["env"])
    
    def _check_environment_variables(self, server_name: str, env_vars: Dict):
        """Check environment variables for hardcoded secrets"""
        for env_var, env_value in env_vars.items():
            if isinstance(env_value, str):
                # Check if it looks like a hardcoded API key (not using ${} syntax)
                if (len(env_value) > 20 and 
                    env_value.replace('_', '').replace('-', '').isalnum() and 
                    not env_value.startswith('${') and 
                    not env_value.endswith('}')):
                    self.log_warning(f"Server '{server_name}' may have hardcoded secret in env var '{env_var}'")
    
    def _validate_unified_system_config(self, unified_config: Dict):
        """Validate unified system configuration"""
        logger.info("Validating Unified System Configuration...")
        
        if "crossEnvironmentSupport" in unified_config:
            cross_env = unified_config["crossEnvironmentSupport"]
            
            # Validate VSCode Augment config
            if "vsCodeAugment" in cross_env:
                self.log_success("VSCode Augment configuration found")
                vscode_config = cross_env["vsCodeAugment"]
                
                if "servers" in vscode_config:
                    servers = vscode_config["servers"]
                    self.log_success(f"VSCode server list defined: {', '.join(servers)}")
                else:
                    self.log_warning("No servers defined for VSCode Augment")
            else:
                self.log_error("Missing VSCode Augment configuration")
            
            # Validate Cursor config
            if "cursor" in cross_env:
                self.log_success("Cursor configuration found")
                cursor_config = cross_env["cursor"]
                
                if "servers" in cursor_config:
                    servers = cursor_config["servers"]
                    self.log_success(f"Cursor server list defined: {', '.join(servers)}")
                else:
                    self.log_warning("No servers defined for Cursor")
            else:
                self.log_error("Missing Cursor configuration")
        else:
            self.log_error("Missing cross-environment support configuration")
    
    def validate_sync_targets(self) -> bool:
        """Validate sync target configurations"""
        logger.info("Validating Sync Targets...")
        
        sync_targets = [
            (self.cursor_config_path, "Cursor"),
            (self.vscode_config_path, "VSCode")
        ]
        
        all_valid = True
        
        for config_path, name in sync_targets:
            if config_path.exists():
                try:
                    with open(config_path, 'r', encoding='utf-8') as f:
                        config = json.load(f)
                    
                    self.log_success(f"{name} configuration file exists and is valid JSON")
                    
                    # Check if it's auto-generated
                    if ("metadata" in config and 
                        "autoGenerated" in config["metadata"] and 
                        config["metadata"]["autoGenerated"]):
                        self.log_success(f"{name} configuration is auto-generated (synced)")
                    else:
                        self.log_warning(f"{name} configuration may not be synced")
                        
                except json.JSONDecodeError as e:
                    self.log_error(f"{name} configuration file has invalid JSON: {e}")
                    all_valid = False
            else:
                self.log_warning(f"{name} configuration file not found: {config_path}")
        
        return all_valid
    
    def check_legacy_configurations(self) -> bool:
        """Check for legacy configurations that should be removed"""
        logger.info("Checking for Legacy Configurations...")
        
        legacy_found = False
        
        for legacy_config in self.legacy_configs:
            if legacy_config.exists():
                self.log_warning(f"Legacy configuration found: {legacy_config} (should be removed)")
                legacy_found = True
            else:
                self.log_success(f"Legacy configuration removed: {legacy_config}")
        
        return not legacy_found
    
    def trigger_sync(self) -> bool:
        """Trigger MCP configuration sync"""
        logger.info("Triggering MCP configuration sync...")
        
        try:
            sync_script = Path("@project-core/automation/sync_mcp_configs.py")
            if sync_script.exists():
                import subprocess
                result = subprocess.run([
                    sys.executable, str(sync_script), "--sync-all"
                ], capture_output=True, text=True)
                
                if result.returncode == 0:
                    self.log_success("MCP configuration sync completed successfully")
                    self.repair_count += 1
                    return True
                else:
                    self.log_error(f"MCP configuration sync failed: {result.stderr}")
                    return False
            else:
                self.log_error(f"Sync script not found: {sync_script}")
                return False
                
        except Exception as e:
            self.log_error(f"Failed to execute sync: {e}")
            return False
    
    def comprehensive_validation(self, repair_mode: bool = False) -> bool:
        """Run comprehensive validation"""
        logger.info("Starting Comprehensive MCP Configuration Validation...")
        
        # Reset counters
        self.error_count = 0
        self.warning_count = 0
        self.repair_count = 0
        
        # Validate master config
        master_valid = self.validate_master_config()
        
        # Validate sync targets
        sync_valid = self.validate_sync_targets()
        
        # Check legacy configs
        legacy_clean = self.check_legacy_configurations()
        
        # Attempt repairs if in repair mode
        if repair_mode and (not sync_valid or not legacy_clean):
            logger.info("Attempting automatic repairs...")
            if not sync_valid:
                self.trigger_sync()
        
        # Final summary
        logger.info("VALIDATION SUMMARY")
        logger.info("=" * 30)
        logger.info(f"Errors: {self.error_count}")
        logger.info(f"Warnings: {self.warning_count}")
        if repair_mode:
            logger.info(f"Repairs: {self.repair_count}")
        
        success = self.error_count == 0
        
        if success:
            logger.info("MCP CONFIGURATION VALIDATION PASSED")
        else:
            logger.error("MCP CONFIGURATION VALIDATION FAILED")
        
        return success

def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(description="MCP Configuration Validator Enhanced")
    parser.add_argument("--comprehensive", action="store_true", help="Run comprehensive validation")
    parser.add_argument("--quick-check", action="store_true", help="Run quick validation check")
    parser.add_argument("--repair-mode", action="store_true", help="Attempt automatic repairs")
    parser.add_argument("--sync-check", action="store_true", help="Check sync target validity")
    parser.add_argument("--verbose", action="store_true", help="Verbose output")
    
    args = parser.parse_args()
    
    # Set logging level
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    # Initialize validator
    validator = MCPConfigValidator()
    
    try:
        if args.comprehensive or args.repair_mode:
            success = validator.comprehensive_validation(repair_mode=args.repair_mode)
        elif args.sync_check:
            success = validator.validate_sync_targets()
        elif args.quick_check:
            success = validator.validate_master_config()
        else:
            # Default: comprehensive validation
            success = validator.comprehensive_validation()
        
        sys.exit(0 if success else 1)
        
    except Exception as e:
        logger.error(f"Validation failed with exception: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
