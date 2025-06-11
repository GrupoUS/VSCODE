# 🛡️ AEGISWALLET - UNATTENDED EXECUTION PROTOCOL V1.0.0
## PROJECT: AEGISWALLET | PRIORITY: CRITICAL | STATUS: ACTIVE

---

## 📋 PROJECT-SPECIFIC PROTOCOL CONFIGURATION

This file implements the **Unattended Execution Protocol V1.0.0** specifically for the **AEGISWALLET** project within the GRUPO US VIBECODE SYSTEM V2.0 ecosystem. This protocol enables full autonomous operation for cryptocurrency wallet development while maintaining enhanced security measures and Vite + React best practices.

**Base Protocol**: References `@project-core/rules/01-unattended-execution-protocol.md`
**Project Type**: Vite + React + TypeScript + Tailwind CSS + Supabase
**Security Level**: ENHANCED (Cryptocurrency Application)
**Deployment**: Vercel + Supabase + Blockchain Integration

---

## 🚨 AEGISWALLET ACTIVATION CRITERIA

### **Autonomous Activation Triggers (AEGISWALLET-Specific):**

The Unattended Execution Protocol **AUTOMATICALLY ACTIVATES** for AEGISWALLET when:

1. **Initial Plan Approval Received**: User confirms project plan with approved phrases:
   - "YARRR!" (confidence ≥ 8/10 confirmation)
   - "sim" / "yes" / "prossiga" / "proceed" / "ok" / "execute" / "go ahead"

2. **AEGISWALLET Project Scope Defined**: Clear boundaries for cryptocurrency wallet development

3. **Security Clearance**: Tasks verified as non-security-sensitive operations

4. **Tech Stack Compatibility**: Tasks compatible with AEGISWALLET's Vite + React stack

---

## ⚡ AEGISWALLET AUTONOMOUS EXECUTION RULES

### **1. CRYPTOCURRENCY WALLET SPECIFIC OPERATIONS**

#### **Frontend Development:**
- ✅ React component creation and modification (non-security)
- ✅ TypeScript interface and type definitions
- ✅ Tailwind CSS styling and responsive design
- ✅ UI/UX components for wallet interface
- ✅ Dashboard and portfolio components

#### **Blockchain Integration (LIMITED):**
- ✅ Read-only blockchain data display components
- ✅ Transaction history UI components
- ✅ Wallet balance display components
- ❌ **RESTRICTED**: Private key handling, transaction signing, wallet creation

#### **Development Tools:**
- ✅ Vite configuration optimization
- ✅ Build process improvements
- ✅ Testing framework setup and execution
- ✅ Development server configuration
- ✅ Code quality tools (ESLint, Prettier)

### **2. AEGISWALLET NON-INTERACTIVE COMMANDS**

#### **Vite + React Specific Commands:**
```bash
# Package Management (AEGISWALLET)
npm install --silent
npm run build --silent
npm run dev --silent
npm run preview --silent
npm run lint --fix --silent

# Vite Operations
npx vite build --silent
npx vite preview --silent
npx vite optimize --silent

# Testing Commands
npm run test --silent
npm run test:ui --silent
npm run test:coverage --silent
```

#### **Security-Aware Development:**
```bash
# Code Quality (Enhanced Security)
npm run lint:security --silent
npm run audit --silent
npm run type-check --silent
npx tsc --noEmit --silent

# Build Verification
npm run build:verify --silent
npm run security-scan --silent
```

### **3. AEGISWALLET FILE OPERATIONS**

#### **Automatic File Handling (AEGISWALLET-Specific):**
- **UI Components**: Auto-approve non-security UI component modifications
- **Styling Files**: Auto-approve CSS/Tailwind styling updates
- **Configuration Files**: Auto-approve vite.config.ts, tailwind.config.ts updates
- **Test Files**: Auto-approve test file creation and modification
- **Documentation**: Auto-approve documentation updates

#### **RESTRICTED FILES (Manual Approval Required):**
- **Security Components**: Wallet creation, private key handling
- **Blockchain Integration**: Transaction signing, wallet import/export
- **Environment Files**: .env files containing API keys or secrets
- **Security Configurations**: Authentication and encryption settings
- **Production Configs**: Production deployment configurations

---

## 🔒 AEGISWALLET ENHANCED SECURITY MECHANISMS

### **1. CRYPTOCURRENCY SECURITY SCOPE LIMITATIONS**

**Autonomous execution applies ONLY to:**
- UI/UX development for wallet interface
- Read-only blockchain data display
- Development tooling and build optimization
- Testing and quality assurance (non-security)
- Documentation and user guides

**MANUAL APPROVAL REQUIRED for:**
- Private key generation, storage, or handling
- Transaction creation, signing, or broadcasting
- Wallet import/export functionality
- Cryptocurrency transfer operations
- Security-sensitive authentication changes
- Production deployment of security features

### **2. AEGISWALLET SECURITY ERROR HANDLING**

#### **Security-Aware Error Recovery:**
```markdown
### Security Error Recovery - [TIMESTAMP]
**Error**: Attempted to modify security-sensitive component
**Autonomous Action**: HALT execution, request manual approval
**Security Check**: Verify operation scope and security implications
**Result**: Operation suspended pending security review
```

#### **Blockchain Integration Error Recovery:**
```markdown
### Blockchain Error Recovery - [TIMESTAMP]
**Error**: Blockchain API connection failed
**Autonomous Action**: Use mock data for development, log error
**Fallback**: Switch to testnet or local blockchain simulation
**Result**: Development continues with safe fallback data
```

### **3. AEGISWALLET EMERGENCY OVERRIDE**

**Enhanced Override for Security**: Include this exact phrase in user prompt:
```
"EXECUTE WITH MANUAL SUPERVISION"
```

**AEGISWALLET Security Override Use Cases:**
- Security-sensitive feature development
- Blockchain integration debugging
- Cryptocurrency transaction testing
- Wallet security audit and review
- Production security deployment

---

## 📊 AEGISWALLET MONITORING INTEGRATION

### **1. Performance Metrics (AEGISWALLET-Specific)**

```javascript
// AEGISWALLET Performance Tracking
const aegiswalletMetrics = {
  buildTime: {
    target: 45000, // 45 seconds (Vite optimization)
    current: 0,
    autonomous: true
  },
  componentGeneration: {
    target: 3000, // 3 seconds per component
    current: 0,
    autonomous: true
  },
  securityScanTime: {
    target: 30000, // 30 seconds security scan
    current: 0,
    autonomous: true
  },
  testExecution: {
    target: 60000, // 1 minute test suite
    current: 0,
    autonomous: true
  }
};
```

### **2. Security Quality Assurance (AEGISWALLET)**

```javascript
// AEGISWALLET Security Standards
const aegiswalletSecurity = {
  securityScanCompliance: {
    target: 100, // No security vulnerabilities
    autonomous: true
  },
  typeScriptCompliance: {
    target: 100, // No TypeScript errors
    autonomous: true
  },
  testCoverage: {
    target: 95, // 95% test coverage
    autonomous: true
  },
  securityTestCoverage: {
    target: 100, // 100% security test coverage
    autonomous: true
  }
};
```

---

## 🔧 AEGISWALLET INTEGRATION EXAMPLES

### **1. Wallet UI Component (Autonomous)**

```typescript
// Autonomous wallet UI component for AEGISWALLET
interface WalletBalanceProps {
  balance: string;
  currency: string;
  isLoading?: boolean;
  className?: string;
}

const WalletBalance: React.FC<WalletBalanceProps> = ({
  balance,
  currency,
  isLoading = false,
  className = ''
}) => {
  // Autonomous implementation with AEGISWALLET design system
  const formatBalance = (value: string) => {
    // Safe formatting - no security implications
    return parseFloat(value).toLocaleString('en-US', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 8
    });
  };

  if (isLoading) {
    return (
      <div className={`animate-pulse ${className}`}>
        <div className="h-8 bg-gray-200 rounded-md w-32"></div>
      </div>
    );
  }

  return (
    <div className={`wallet-balance ${className}`}>
      <div className="text-2xl font-bold text-gray-900">
        {formatBalance(balance)} {currency}
      </div>
      <div className="text-sm text-gray-500">
        Available Balance
      </div>
    </div>
  );
};

export default WalletBalance;
```

### **2. Transaction History Component (Autonomous)**

```typescript
// Autonomous transaction history component for AEGISWALLET
interface Transaction {
  id: string;
  type: 'send' | 'receive';
  amount: string;
  currency: string;
  timestamp: string;
  status: 'confirmed' | 'pending' | 'failed';
  hash?: string;
}

interface TransactionHistoryProps {
  transactions: Transaction[];
  isLoading?: boolean;
}

const TransactionHistory: React.FC<TransactionHistoryProps> = ({
  transactions,
  isLoading = false
}) => {
  // Autonomous implementation - read-only display only
  const getStatusColor = (status: Transaction['status']) => {
    switch (status) {
      case 'confirmed': return 'text-green-600';
      case 'pending': return 'text-yellow-600';
      case 'failed': return 'text-red-600';
      default: return 'text-gray-600';
    }
  };

  const getTypeIcon = (type: Transaction['type']) => {
    return type === 'send' ? '↗️' : '↙️';
  };

  if (isLoading) {
    return (
      <div className="space-y-4">
        {[...Array(5)].map((_, i) => (
          <div key={i} className="animate-pulse flex space-x-4">
            <div className="rounded-full bg-gray-200 h-10 w-10"></div>
            <div className="flex-1 space-y-2">
              <div className="h-4 bg-gray-200 rounded w-3/4"></div>
              <div className="h-4 bg-gray-200 rounded w-1/2"></div>
            </div>
          </div>
        ))}
      </div>
    );
  }

  return (
    <div className="transaction-history">
      <h3 className="text-lg font-semibold mb-4">Transaction History</h3>
      <div className="space-y-3">
        {transactions.map((tx) => (
          <div key={tx.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div className="flex items-center space-x-3">
              <span className="text-2xl">{getTypeIcon(tx.type)}</span>
              <div>
                <div className="font-medium">
                  {tx.type === 'send' ? 'Sent' : 'Received'} {tx.amount} {tx.currency}
                </div>
                <div className="text-sm text-gray-500">
                  {new Date(tx.timestamp).toLocaleDateString()}
                </div>
              </div>
            </div>
            <div className={`text-sm font-medium ${getStatusColor(tx.status)}`}>
              {tx.status.charAt(0).toUpperCase() + tx.status.slice(1)}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default TransactionHistory;
```

---

## ✅ AEGISWALLET IMPLEMENTATION CHECKLIST

Before activating autonomous execution for AEGISWALLET, verify:

- [ ] **Vite + React Environment**: Project running on Vite with React 18+
- [ ] **TypeScript Configuration**: Strict TypeScript with security linting
- [ ] **Security Scanning**: Security audit tools configured and functional
- [ ] **Tailwind CSS**: Tailwind CSS configured for wallet UI components
- [ ] **Testing Framework**: Comprehensive testing including security tests
- [ ] **Development Environment**: All dependencies installed and verified
- [ ] **Security Boundaries**: Clear separation of security-sensitive code
- [ ] **Blockchain Integration**: Read-only blockchain APIs configured safely

---

## 🎯 AEGISWALLET SUCCESS VALIDATION

**Autonomous Execution Successful for AEGISWALLET When:**
- All UI components created/modified without security implications
- Build process completes successfully with security scans passing
- All tests pass including security-specific test suites
- No security vulnerabilities introduced in autonomous changes
- Code quality standards maintained with enhanced security focus
- Documentation updated with security considerations noted

---

## 🔄 AEGISWALLET CONTINUOUS IMPROVEMENT

### **Security-Focused Learning:**
- Log all autonomous decisions with security impact assessment
- Track UI component patterns for cryptocurrency applications
- Monitor security scan results and optimization opportunities
- Analyze build performance with security tooling overhead
- Document AEGISWALLET-specific security-aware autonomous patterns

### **Performance Optimization:**
- Optimize component generation for cryptocurrency UI patterns
- Improve build process with security scanning integration
- Enhance testing automation for security-sensitive applications
- Streamline development workflow while maintaining security standards

---

**ENFORCEMENT**: This AEGISWALLET-specific protocol extends the base Unattended Execution Protocol V1.0.0 with enhanced security measures for cryptocurrency application development. All autonomous operations must comply with cryptocurrency security standards and GRUPO US quality requirements.

**VERSION**: 1.0.0 | **EFFECTIVE**: Immediately | **REVIEW**: Monthly security and performance optimization
