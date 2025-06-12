# 🔐 **SECURITY PROTOCOLS - VIBECODE SYSTEM V4.0**

## 📋 **SECURITY FRAMEWORK OVERVIEW**

### **1. SECURITY BY DESIGN**
- **Zero Trust Architecture**: Never trust, always verify
- **Defense in Depth**: Multiple layers of security controls
- **Principle of Least Privilege**: Minimum access required
- **Secure by Default**: Secure configurations out of the box

### **2. THREAT MODEL**
- **Data Exposure**: API keys, tokens, sensitive configuration
- **Code Injection**: Malicious code in dependencies or user input
- **Privilege Escalation**: Unauthorized access to system resources
- **Supply Chain**: Compromised dependencies or tools

---

## 🔑 **API KEY AND SECRET MANAGEMENT**

### **MANDATORY ENVIRONMENT VARIABLE USAGE**
```bash
# .env file structure (NEVER commit to repository)
# API Keys
ANTHROPIC_API_KEY=your_anthropic_key_here
OPENROUTER_API_KEY=your_openrouter_key_here
FIGMA_ACCESS_TOKEN=your_figma_token_here
TAVILY_API_KEY=your_tavily_key_here
UPSTASH_EMAIL=your_upstash_email_here
UPSTASH_API_KEY=your_upstash_key_here

# GitHub Integration (optional)
GITHUB_TOKEN=your_github_token_here

# System Configuration
NODE_ENV=development
LOG_LEVEL=info
ENABLE_DEBUG_MODE=false
```

### **CONFIGURATION SECURITY PATTERNS**
```json
{
  "env": {
    "ANTHROPIC_API_KEY": "${ANTHROPIC_API_KEY}",
    "OPENROUTER_API_KEY": "${OPENROUTER_API_KEY}",
    "FIGMA_ACCESS_TOKEN": "${FIGMA_ACCESS_TOKEN}"
  }
}
```

### **HARDCODED SECRET DETECTION**
```python
def detect_hardcoded_secrets(content):
    """Detect potentially hardcoded secrets in configuration."""
    
    secret_patterns = [
        r'["\']?[A-Za-z0-9+/=]{32,}["\']?',  # Base64-like strings
        r'sk-[A-Za-z0-9]{32,}',              # OpenAI-style keys
        r'xoxb-[A-Za-z0-9-]{32,}',           # Slack tokens
        r'ghp_[A-Za-z0-9]{36}',              # GitHub tokens
        r'AIza[A-Za-z0-9_-]{35}',            # Google API keys
    ]
    
    violations = []
    
    for pattern in secret_patterns:
        matches = re.findall(pattern, content)
        for match in matches:
            # Exclude environment variable references
            if not (match.startswith('${') and match.endswith('}')):
                violations.append({
                    "pattern": pattern,
                    "match": match[:10] + "...",  # Truncate for logging
                    "severity": "CRITICAL"
                })
    
    return violations
```

---

## 🛡️ **ACCESS CONTROL AND AUTHENTICATION**

### **FILE SYSTEM PERMISSIONS**
```python
SECURE_FILE_PERMISSIONS = {
    "config_files": 0o600,      # rw-------
    "script_files": 0o755,      # rwxr-xr-x
    "log_files": 0o644,         # rw-r--r--
    "backup_files": 0o600,      # rw-------
    "env_files": 0o600          # rw-------
}

def set_secure_permissions(file_path, file_type):
    """Set secure file permissions based on file type."""
    
    permission = SECURE_FILE_PERMISSIONS.get(file_type, 0o644)
    os.chmod(file_path, permission)
    
    # Verify permissions were set correctly
    actual_permissions = oct(os.stat(file_path).st_mode)[-3:]
    expected_permissions = oct(permission)[-3:]
    
    if actual_permissions != expected_permissions:
        raise SecurityError(f"Failed to set secure permissions on {file_path}")
```

### **PROCESS ISOLATION**
```python
def run_isolated_process(command, working_dir, env_vars=None):
    """Run process with security isolation."""
    
    # Sanitize environment variables
    safe_env = os.environ.copy()
    if env_vars:
        for key, value in env_vars.items():
            if validate_env_var(key, value):
                safe_env[key] = value
    
    # Run with restricted permissions
    try:
        result = subprocess.run(
            command,
            cwd=working_dir,
            env=safe_env,
            capture_output=True,
            text=True,
            timeout=300,  # 5 minute timeout
            check=False
        )
        
        return result
    except subprocess.TimeoutExpired:
        raise SecurityError("Process execution timeout - potential security issue")
```

---

## 🔍 **INPUT VALIDATION AND SANITIZATION**

### **CONFIGURATION VALIDATION**
```python
def validate_configuration(config_data):
    """Validate configuration data for security issues."""
    
    validation_rules = {
        "no_hardcoded_secrets": lambda x: not detect_hardcoded_secrets(str(x)),
        "valid_urls": lambda x: validate_urls_in_config(x),
        "safe_commands": lambda x: validate_commands_in_config(x),
        "environment_vars": lambda x: validate_env_var_references(x)
    }
    
    violations = []
    
    for rule_name, rule_func in validation_rules.items():
        try:
            if not rule_func(config_data):
                violations.append(f"Security rule violated: {rule_name}")
        except Exception as e:
            violations.append(f"Security validation error in {rule_name}: {e}")
    
    return len(violations) == 0, violations
```

### **PATH TRAVERSAL PREVENTION**
```python
def safe_path_join(base_path, user_path):
    """Safely join paths to prevent directory traversal."""
    
    # Normalize and resolve paths
    base_path = os.path.abspath(base_path)
    full_path = os.path.abspath(os.path.join(base_path, user_path))
    
    # Ensure the result is within the base directory
    if not full_path.startswith(base_path):
        raise SecurityError(f"Path traversal attempt detected: {user_path}")
    
    return full_path
```

### **COMMAND INJECTION PREVENTION**
```python
def safe_command_execution(command_template, user_inputs):
    """Execute commands safely with input validation."""
    
    # Whitelist of allowed commands
    ALLOWED_COMMANDS = {
        "python", "node", "npm", "npx", "git", "curl"
    }
    
    # Validate command
    base_command = command_template.split()[0]
    if base_command not in ALLOWED_COMMANDS:
        raise SecurityError(f"Command not allowed: {base_command}")
    
    # Sanitize inputs
    sanitized_inputs = []
    for user_input in user_inputs:
        # Remove dangerous characters
        sanitized = re.sub(r'[;&|`$(){}[\]<>]', '', str(user_input))
        sanitized_inputs.append(sanitized)
    
    # Build safe command
    safe_command = command_template.format(*sanitized_inputs)
    
    return safe_command
```

---

## 📊 **SECURITY MONITORING AND LOGGING**

### **SECURITY EVENT LOGGING**
```python
def log_security_event(event_type, details, severity="INFO"):
    """Log security-related events."""
    
    security_log_entry = {
        "timestamp": datetime.now().isoformat(),
        "event_type": event_type,
        "severity": severity,
        "details": details,
        "source": "vibecode_security_monitor",
        "user": os.getenv("USER", "unknown"),
        "process_id": os.getpid()
    }
    
    # Log to security-specific log file
    security_logger = logging.getLogger("security")
    security_logger.info(json.dumps(security_log_entry))
    
    # Alert on critical events
    if severity == "CRITICAL":
        send_security_alert(security_log_entry)
```

### **ANOMALY DETECTION**
```python
def detect_security_anomalies():
    """Detect potential security anomalies in system behavior."""
    
    anomalies = []
    
    # Check for unusual file access patterns
    recent_file_access = get_recent_file_access()
    if detect_unusual_access_patterns(recent_file_access):
        anomalies.append("Unusual file access pattern detected")
    
    # Check for unexpected network connections
    network_connections = get_active_connections()
    if detect_suspicious_connections(network_connections):
        anomalies.append("Suspicious network connections detected")
    
    # Check for configuration drift
    config_changes = get_recent_config_changes()
    if detect_unauthorized_changes(config_changes):
        anomalies.append("Unauthorized configuration changes detected")
    
    return anomalies
```

---

## 🔒 **DATA PROTECTION AND ENCRYPTION**

### **SENSITIVE DATA HANDLING**
```python
def handle_sensitive_data(data, operation):
    """Handle sensitive data with appropriate protection."""
    
    if operation == "store":
        # Encrypt before storing
        encrypted_data = encrypt_data(data)
        return store_encrypted(encrypted_data)
    
    elif operation == "transmit":
        # Use secure transmission
        return transmit_securely(data)
    
    elif operation == "log":
        # Redact sensitive information
        return redact_sensitive_info(data)
    
    else:
        raise SecurityError(f"Unknown sensitive data operation: {operation}")
```

### **BACKUP SECURITY**
```python
def create_secure_backup(data, backup_path):
    """Create encrypted backup with integrity verification."""
    
    # Generate backup metadata
    backup_metadata = {
        "timestamp": datetime.now().isoformat(),
        "checksum": calculate_checksum(data),
        "encryption": "AES-256-GCM"
    }
    
    # Encrypt data
    encrypted_data = encrypt_data(data)
    
    # Create secure backup file
    secure_backup = {
        "metadata": backup_metadata,
        "data": encrypted_data
    }
    
    # Write with secure permissions
    with open(backup_path, 'w') as f:
        json.dump(secure_backup, f)
    
    set_secure_permissions(backup_path, "backup_files")
    
    return backup_metadata
```

---

## 🚨 **INCIDENT RESPONSE PROTOCOLS**

### **SECURITY INCIDENT CLASSIFICATION**
```python
INCIDENT_SEVERITY = {
    "LOW": {
        "description": "Minor security policy violation",
        "response_time": "24 hours",
        "escalation": False
    },
    "MEDIUM": {
        "description": "Potential security vulnerability",
        "response_time": "4 hours", 
        "escalation": True
    },
    "HIGH": {
        "description": "Active security threat",
        "response_time": "1 hour",
        "escalation": True
    },
    "CRITICAL": {
        "description": "System compromise or data breach",
        "response_time": "Immediate",
        "escalation": True
    }
}
```

### **AUTOMATED INCIDENT RESPONSE**
```python
def handle_security_incident(incident_type, details, severity):
    """Automated security incident response."""
    
    incident_id = generate_incident_id()
    
    # Log incident
    log_security_event(incident_type, details, severity)
    
    # Immediate response based on severity
    if severity == "CRITICAL":
        # Immediate containment
        isolate_affected_systems()
        disable_compromised_accounts()
        create_emergency_backup()
    
    elif severity == "HIGH":
        # Rapid response
        increase_monitoring()
        validate_system_integrity()
        notify_security_team()
    
    # Create incident report
    incident_report = {
        "incident_id": incident_id,
        "timestamp": datetime.now().isoformat(),
        "type": incident_type,
        "severity": severity,
        "details": details,
        "response_actions": get_response_actions(severity),
        "status": "ACTIVE"
    }
    
    store_incident_report(incident_report)
    
    return incident_id
```

---

## 🔧 **SECURITY CONFIGURATION HARDENING**

### **SYSTEM HARDENING CHECKLIST**
```python
HARDENING_CHECKLIST = {
    "file_permissions": {
        "check": verify_file_permissions,
        "fix": fix_file_permissions,
        "critical": True
    },
    "environment_variables": {
        "check": verify_env_var_security,
        "fix": fix_env_var_issues,
        "critical": True
    },
    "configuration_security": {
        "check": verify_config_security,
        "fix": fix_config_security,
        "critical": True
    },
    "dependency_security": {
        "check": verify_dependency_security,
        "fix": update_vulnerable_dependencies,
        "critical": False
    }
}

def run_security_hardening():
    """Run complete security hardening process."""
    
    results = {}
    
    for check_name, check_config in HARDENING_CHECKLIST.items():
        try:
            # Run security check
            check_result = check_config["check"]()
            
            if not check_result["passed"]:
                # Attempt automatic fix
                fix_result = check_config["fix"]()
                
                results[check_name] = {
                    "initial_status": "FAILED",
                    "fix_attempted": True,
                    "fix_successful": fix_result["success"],
                    "critical": check_config["critical"]
                }
            else:
                results[check_name] = {
                    "initial_status": "PASSED",
                    "fix_attempted": False,
                    "critical": check_config["critical"]
                }
                
        except Exception as e:
            results[check_name] = {
                "initial_status": "ERROR",
                "error": str(e),
                "critical": check_config["critical"]
            }
    
    return results
```

---

## 📋 **SECURITY COMPLIANCE VERIFICATION**

### **COMPLIANCE CHECKLIST**
- [ ] ✅ No hardcoded API keys or secrets
- [ ] ✅ All sensitive data in environment variables
- [ ] ✅ Secure file permissions set
- [ ] ✅ Input validation implemented
- [ ] ✅ Command injection prevention active
- [ ] ✅ Path traversal protection enabled
- [ ] ✅ Security logging configured
- [ ] ✅ Incident response procedures defined
- [ ] ✅ Regular security audits scheduled
- [ ] ✅ Dependency security monitoring active

### **AUTOMATED COMPLIANCE VERIFICATION**
```python
def verify_security_compliance():
    """Verify complete security compliance."""
    
    compliance_checks = {
        "secret_management": verify_no_hardcoded_secrets(),
        "access_control": verify_access_controls(),
        "input_validation": verify_input_validation(),
        "logging": verify_security_logging(),
        "monitoring": verify_security_monitoring(),
        "incident_response": verify_incident_response_ready()
    }
    
    compliance_score = sum(1 for check in compliance_checks.values() if check)
    total_checks = len(compliance_checks)
    
    return {
        "compliant": compliance_score == total_checks,
        "score": (compliance_score / total_checks) * 100,
        "failed_checks": [name for name, result in compliance_checks.items() if not result],
        "details": compliance_checks
    }
```

---

**🔐 VIBECODE SYSTEM V4.0 - SECURITY PROTOCOLS FOR COMPREHENSIVE PROTECTION**

*"Segurança não é um produto, é um processo contínuo de proteção e vigilância."*
