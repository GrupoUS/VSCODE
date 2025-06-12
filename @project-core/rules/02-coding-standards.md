# 💻 **CODING STANDARDS - VIBECODE SYSTEM V4.0**

## 📋 **PADRÕES DE CODIFICAÇÃO**

### **1. GENERAL PRINCIPLES**
- **Clean Code**: Código limpo, legível e autoexplicativo
- **SOLID Principles**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
- **DRY (Don't Repeat Yourself)**: Evitar duplicação de código
- **KISS (Keep It Simple, Stupid)**: Simplicidade sobre complexidade desnecessária

### **2. CODE QUALITY GATES**
- **Zero Warnings**: Código deve compilar sem warnings
- **100% Test Coverage**: Cobertura completa de testes unitários
- **Linting Compliance**: Conformidade com regras de linting
- **Security Validation**: Validação de segurança obrigatória

---

## 🐍 **PYTHON STANDARDS**

### **NAMING CONVENTIONS**
```python
# Variables and functions: snake_case
user_name = "john_doe"
def calculate_total_price():
    pass

# Classes: PascalCase
class UserManager:
    pass

# Constants: UPPER_SNAKE_CASE
MAX_RETRY_ATTEMPTS = 3
API_BASE_URL = "https://api.example.com"

# Private methods: leading underscore
def _internal_helper():
    pass
```

### **FILE STRUCTURE**
```python
#!/usr/bin/env python3
"""
Module docstring describing purpose and usage.
"""

import argparse
import json
import logging
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class ExampleClass:
    """Class docstring."""
    
    def __init__(self, config: Dict):
        self.config = config
    
    def public_method(self, param: str) -> bool:
        """Method docstring with type hints."""
        try:
            # Implementation
            return True
        except Exception as e:
            logger.error(f"Error in public_method: {e}")
            return False

def main():
    """Main entry point."""
    pass

if __name__ == "__main__":
    main()
```

### **ERROR HANDLING**
```python
# Specific exception handling
try:
    result = risky_operation()
except FileNotFoundError:
    logger.error("Configuration file not found")
    return False
except json.JSONDecodeError as e:
    logger.error(f"Invalid JSON format: {e}")
    return False
except Exception as e:
    logger.error(f"Unexpected error: {e}")
    return False
```

### **TYPE HINTS (MANDATORY)**
```python
from typing import Dict, List, Any, Optional, Union

def process_data(
    input_data: List[Dict[str, Any]], 
    config: Optional[Dict] = None
) -> Union[Dict, None]:
    """Process input data with optional configuration."""
    if not input_data:
        return None
    
    # Implementation
    return {"processed": True}
```

---

## 🟨 **JAVASCRIPT/TYPESCRIPT STANDARDS**

### **NAMING CONVENTIONS**
```javascript
// Variables and functions: camelCase
const userName = 'johnDoe';
function calculateTotalPrice() {}

// Classes: PascalCase
class UserManager {}

// Constants: UPPER_SNAKE_CASE
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.example.com';

// Private methods: leading underscore
function _internalHelper() {}
```

### **FILE STRUCTURE**
```typescript
/**
 * Module description
 */

import { Logger } from './utils/logger';
import { Config } from './types/config';

interface UserData {
  id: string;
  name: string;
  email: string;
}

class UserManager {
  private config: Config;
  private logger: Logger;

  constructor(config: Config) {
    this.config = config;
    this.logger = new Logger('UserManager');
  }

  public async createUser(userData: UserData): Promise<boolean> {
    try {
      // Implementation
      this.logger.info('User created successfully');
      return true;
    } catch (error) {
      this.logger.error('Failed to create user', error);
      return false;
    }
  }
}

export { UserManager, UserData };
```

### **ASYNC/AWAIT PATTERNS**
```typescript
// Preferred: async/await
async function fetchUserData(userId: string): Promise<UserData | null> {
  try {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    logger.error('Failed to fetch user data', error);
    return null;
  }
}

// Error handling with multiple operations
async function processUserWorkflow(userId: string): Promise<boolean> {
  try {
    const user = await fetchUserData(userId);
    if (!user) return false;
    
    const processed = await processUser(user);
    if (!processed) return false;
    
    await notifyUser(user);
    return true;
  } catch (error) {
    logger.error('Workflow failed', error);
    return false;
  }
}
```

---

## 🔧 **CONFIGURATION STANDARDS**

### **JSON CONFIGURATION**
```json
{
  "metadata": {
    "name": "Configuration Name",
    "version": "1.0.0",
    "description": "Configuration description",
    "lastUpdated": "2025-01-27T12:00:00Z"
  },
  "settings": {
    "enabled": true,
    "timeout": 30000,
    "retryAttempts": 3
  },
  "environment": {
    "apiKey": "${API_KEY}",
    "baseUrl": "${BASE_URL}"
  }
}
```

### **ENVIRONMENT VARIABLES**
```bash
# .env file structure
# API Keys (never hardcode)
ANTHROPIC_API_KEY=your_key_here
OPENROUTER_API_KEY=your_key_here

# Configuration
NODE_ENV=development
LOG_LEVEL=info
PORT=3000

# Feature flags
ENABLE_EXPERIMENTAL_FEATURES=false
ENABLE_DEBUG_MODE=true
```

---

## 📝 **DOCUMENTATION STANDARDS**

### **FUNCTION DOCUMENTATION**
```python
def process_user_data(
    user_data: Dict[str, Any], 
    validation_rules: List[str],
    strict_mode: bool = False
) -> Dict[str, Any]:
    """
    Process user data according to validation rules.
    
    Args:
        user_data: Dictionary containing user information
        validation_rules: List of validation rule names to apply
        strict_mode: If True, fail on any validation error
        
    Returns:
        Dictionary with processed data and validation results
        
    Raises:
        ValueError: If user_data is empty or invalid
        ValidationError: If strict_mode is True and validation fails
        
    Example:
        >>> user_data = {"name": "John", "email": "john@example.com"}
        >>> rules = ["email_format", "name_length"]
        >>> result = process_user_data(user_data, rules)
        >>> print(result["valid"])
        True
    """
    if not user_data:
        raise ValueError("user_data cannot be empty")
    
    # Implementation
    return {"valid": True, "processed_data": user_data}
```

### **CLASS DOCUMENTATION**
```python
class TaskManager:
    """
    Manages task execution and coordination.
    
    This class provides functionality for creating, scheduling, and monitoring
    tasks within the VIBECODE system. It integrates with MCP servers for
    advanced task coordination.
    
    Attributes:
        config (Dict): Configuration dictionary
        active_tasks (List[Task]): Currently active tasks
        
    Example:
        >>> manager = TaskManager(config)
        >>> task_id = manager.create_task("process_data", {"input": "data"})
        >>> manager.execute_task(task_id)
    """
    
    def __init__(self, config: Dict):
        """Initialize TaskManager with configuration."""
        self.config = config
        self.active_tasks = []
```

---

## 🧪 **TESTING STANDARDS**

### **UNIT TESTS**
```python
import unittest
from unittest.mock import Mock, patch
from your_module import UserManager

class TestUserManager(unittest.TestCase):
    """Test cases for UserManager class."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.config = {"api_url": "http://test.com"}
        self.manager = UserManager(self.config)
    
    def test_create_user_success(self):
        """Test successful user creation."""
        user_data = {"name": "John", "email": "john@test.com"}
        
        with patch('your_module.api_call') as mock_api:
            mock_api.return_value = {"success": True, "id": "123"}
            
            result = self.manager.create_user(user_data)
            
            self.assertTrue(result)
            mock_api.assert_called_once()
    
    def test_create_user_failure(self):
        """Test user creation failure handling."""
        user_data = {"name": "", "email": "invalid"}
        
        result = self.manager.create_user(user_data)
        
        self.assertFalse(result)
    
    def tearDown(self):
        """Clean up after tests."""
        pass

if __name__ == '__main__':
    unittest.main()
```

### **INTEGRATION TESTS**
```python
import pytest
from your_module import SystemManager

@pytest.fixture
def system_manager():
    """Fixture for SystemManager instance."""
    config = load_test_config()
    return SystemManager(config)

def test_full_workflow_integration(system_manager):
    """Test complete workflow integration."""
    # Setup
    task_data = {"type": "process", "input": "test_data"}
    
    # Execute
    task_id = system_manager.create_task(task_data)
    result = system_manager.execute_workflow(task_id)
    
    # Verify
    assert result["success"] is True
    assert result["task_id"] == task_id
    assert "output" in result
```

---

## 🔍 **CODE REVIEW STANDARDS**

### **REVIEW CHECKLIST**
- [ ] ✅ Code follows naming conventions
- [ ] ✅ Functions have proper type hints
- [ ] ✅ Error handling is comprehensive
- [ ] ✅ Documentation is complete and accurate
- [ ] ✅ Tests cover all code paths
- [ ] ✅ No hardcoded secrets or configuration
- [ ] ✅ Performance considerations addressed
- [ ] ✅ Security implications reviewed

### **REVIEW CRITERIA**
- **Functionality**: Code works as intended
- **Readability**: Code is clear and understandable
- **Maintainability**: Code is easy to modify and extend
- **Performance**: Code is optimized for performance
- **Security**: Code follows security best practices
- **Testing**: Code has adequate test coverage

---

## 🚀 **PERFORMANCE STANDARDS**

### **OPTIMIZATION GUIDELINES**
- **Algorithm Efficiency**: Use appropriate algorithms and data structures
- **Memory Management**: Avoid memory leaks and excessive memory usage
- **I/O Optimization**: Minimize file and network I/O operations
- **Caching**: Implement caching where appropriate
- **Lazy Loading**: Load resources only when needed

### **PERFORMANCE TARGETS**
- **Function Execution**: < 100ms for common operations
- **API Response**: < 200ms for API calls
- **File Operations**: < 500ms for file I/O
- **Memory Usage**: < 100MB for typical operations

---

## 🔐 **SECURITY STANDARDS**

### **SECURE CODING PRACTICES**
- **Input Validation**: Validate all user inputs
- **Output Encoding**: Encode outputs to prevent injection
- **Authentication**: Implement proper authentication
- **Authorization**: Check permissions before operations
- **Encryption**: Use encryption for sensitive data

### **SECURITY CHECKLIST**
- [ ] ✅ No hardcoded credentials
- [ ] ✅ Input validation implemented
- [ ] ✅ Error messages don't leak information
- [ ] ✅ Logging doesn't include sensitive data
- [ ] ✅ Dependencies are up to date
- [ ] ✅ Security headers are set

---

**💻 VIBECODE SYSTEM V4.0 - CODING EXCELLENCE THROUGH STANDARDS**

*"Código de qualidade é a base de sistemas confiáveis."*
