# 🎭 PLAYWRIGHT AUTOMATION PROTOCOL - GRUPO US VIBECODE SYSTEM V2.0

## 📋 OVERVIEW

Comprehensive protocol for Playwright automation integration, providing robust end-to-end testing, visual testing, and automated user interaction workflows for web applications.

## 🚀 PLAYWRIGHT SETUP & CONFIGURATION

### **Installation & Initialization**
```bash
# Install Playwright and dependencies
npm run playwright:install

# Setup automation environment
npm run setup:automation

# Start MCP server
npm run mcp:start

# Test basic functionality
npm run automation:basic
```

### **Environment Configuration**
```bash
# .env.playwright configuration
PLAYWRIGHT_HEADLESS=false
PLAYWRIGHT_SLOW_MO=100
PLAYWRIGHT_VIEWPORT_WIDTH=1280
PLAYWRIGHT_VIEWPORT_HEIGHT=720
PLAYWRIGHT_TIMEOUT=30000
PLAYWRIGHT_SCREENSHOTS_PATH=./screenshots
PLAYWRIGHT_REPORTS_PATH=./reports
```

## 🎯 AUTOMATION ACTIVATION CRITERIA

### **Mandatory Automation Scenarios:**
- **E2E Testing**: Complete user workflow validation
- **Visual Regression Testing**: UI consistency verification
- **Form Automation**: Complex form filling and validation
- **Multi-Browser Testing**: Cross-browser compatibility
- **Performance Testing**: Load time and interaction speed

### **Integration Scenarios:**
- **Figma-to-Code Validation**: Verify implemented designs match Figma
- **TaskMaster Workflows**: Automated task execution validation
- **Supabase Integration Testing**: Database interaction validation
- **Authentication Flows**: Login/logout and permission testing

## 🏗️ PLAYWRIGHT AUTOMATION ARCHITECTURE

### **Core Automation Class**
```javascript
// Basic Playwright automation setup
const { chromium, firefox, webkit } = require('playwright');

class PlaywrightAutomation {
    constructor(options = {}) {
        this.browser = null;
        this.page = null;
        this.options = {
            headless: process.env.PLAYWRIGHT_HEADLESS === 'true',
            slowMo: parseInt(process.env.PLAYWRIGHT_SLOW_MO) || 100,
            viewport: {
                width: parseInt(process.env.PLAYWRIGHT_VIEWPORT_WIDTH) || 1280,
                height: parseInt(process.env.PLAYWRIGHT_VIEWPORT_HEIGHT) || 720
            },
            timeout: parseInt(process.env.PLAYWRIGHT_TIMEOUT) || 30000,
            ...options
        };
    }

    async initialize(browserType = 'chromium') {
        const browsers = { chromium, firefox, webkit };
        this.browser = await browsers[browserType].launch({
            headless: this.options.headless,
            slowMo: this.options.slowMo
        });
        
        this.page = await this.browser.newPage({
            viewport: this.options.viewport
        });
        
        this.page.setDefaultTimeout(this.options.timeout);
        return this.page;
    }

    async cleanup() {
        if (this.page) await this.page.close();
        if (this.browser) await this.browser.close();
    }
}
```

### **Advanced Automation Patterns**
```javascript
// Form automation with validation
async automateForm(formData, validationRules = {}) {
    try {
        // Fill form fields
        for (const [field, value] of Object.entries(formData)) {
            await this.page.fill(`[name="${field}"]`, value);
            await this.page.waitForTimeout(100); // Prevent race conditions
        }
        
        // Validate form state
        if (validationRules.required) {
            for (const field of validationRules.required) {
                const value = await this.page.inputValue(`[name="${field}"]`);
                if (!value) throw new Error(`Required field ${field} is empty`);
            }
        }
        
        // Submit form
        await this.page.click('button[type="submit"]');
        
        // Wait for response
        await this.page.waitForLoadState('networkidle');
        
        return { success: true, message: 'Form submitted successfully' };
    } catch (error) {
        await this.captureScreenshot('form-error');
        return { success: false, error: error.message };
    }
}

// Visual testing with comparison
async performVisualTest(testName, selector = 'body') {
    const screenshot = await this.page.screenshot({
        path: `./screenshots/${testName}-current.png`,
        fullPage: true
    });
    
    // Compare with baseline (if exists)
    const baselinePath = `./screenshots/${testName}-baseline.png`;
    if (fs.existsSync(baselinePath)) {
        const comparison = await this.compareImages(
            baselinePath,
            `./screenshots/${testName}-current.png`
        );
        
        if (comparison.difference > 0.1) { // 10% threshold
            await this.page.screenshot({
                path: `./screenshots/${testName}-diff.png`
            });
            return { 
                passed: false, 
                difference: comparison.difference,
                message: 'Visual regression detected'
            };
        }
    }
    
    return { passed: true, message: 'Visual test passed' };
}
```

## 🔄 INTEGRATION PROTOCOLS

### **TaskMaster + Playwright Integration**
```javascript
class TaskMasterPlaywrightIntegration {
    constructor(config = {}) {
        this.automation = new PlaywrightAutomation(config.playwright);
        this.taskmaster = config.taskmaster || {};
        this.testResults = [];
        this.metrics = {
            testsRun: 0,
            testsPassed: 0,
            testsFailed: 0,
            averageExecutionTime: 0
        };
    }

    async executeAutomationTask(taskDescription) {
        console.log(`🤖 Executing automation task: ${taskDescription}`);
        
        const startTime = Date.now();
        
        try {
            // Initialize browser
            await this.automation.initialize();
            
            // Parse task and execute
            const result = await this.parseAndExecuteTask(taskDescription);
            
            // Record metrics
            this.recordTestResult(result, Date.now() - startTime);
            
            return result;
        } catch (error) {
            this.recordTestResult({ success: false, error: error.message }, Date.now() - startTime);
            throw error;
        } finally {
            await this.automation.cleanup();
        }
    }

    async parseAndExecuteTask(description) {
        // AI-powered task parsing and execution
        const taskType = this.identifyTaskType(description);
        
        switch (taskType) {
            case 'navigation':
                return await this.executeNavigationTask(description);
            case 'form':
                return await this.executeFormTask(description);
            case 'visual':
                return await this.executeVisualTask(description);
            case 'interaction':
                return await this.executeInteractionTask(description);
            default:
                return await this.executeGenericTask(description);
        }
    }
}
```

### **Figma + Playwright Integration**
```javascript
class FigmaPlaywrightIntegration {
    constructor(config = {}) {
        this.figmaManager = new FigmaMCPManager(config.figma);
        this.automation = new PlaywrightAutomation(config.playwright);
        this.visualTesting = config.visualTesting || { enabled: true, threshold: 0.2 };
    }

    async validateDesignImplementation(figmaUrl, implementationUrl) {
        try {
            // Get Figma design data
            const figmaData = await this.figmaManager.getDesignData(figmaUrl);
            
            // Navigate to implementation
            await this.automation.initialize();
            await this.automation.page.goto(implementationUrl);
            
            // Perform visual comparison
            const visualTest = await this.automation.performVisualTest(
                `figma-implementation-${Date.now()}`
            );
            
            // Generate comparison report
            const report = await this.generateComparisonReport(
                figmaData,
                visualTest,
                implementationUrl
            );
            
            return report;
        } catch (error) {
            console.error('Design validation failed:', error);
            throw error;
        } finally {
            await this.automation.cleanup();
        }
    }

    async generateComponentFromFigma(figmaNodeId, outputPath) {
        // Extract component data from Figma
        const componentData = await this.figmaManager.getComponentData(figmaNodeId);
        
        // Generate React component code
        const componentCode = await this.figmaManager.generateComponentCode(
            componentData,
            'react'
        );
        
        // Write component file
        fs.writeFileSync(outputPath, componentCode);
        
        // Create automated test for component
        const testCode = this.generateComponentTest(componentData, outputPath);
        fs.writeFileSync(
            outputPath.replace('.tsx', '.test.tsx'),
            testCode
        );
        
        return { componentPath: outputPath, testPath: outputPath.replace('.tsx', '.test.tsx') };
    }
}
```

## 🧪 TESTING PATTERNS & BEST PRACTICES

### **E2E Testing Pattern**
```javascript
// Complete user workflow testing
async function testUserRegistrationFlow() {
    const automation = new PlaywrightAutomation();
    
    try {
        await automation.initialize();
        
        // Navigate to registration page
        await automation.page.goto('/register');
        
        // Fill registration form
        const registrationData = {
            name: 'Test User',
            email: 'test@example.com',
            password: 'SecurePassword123!',
            confirmPassword: 'SecurePassword123!'
        };
        
        const formResult = await automation.automateForm(registrationData, {
            required: ['name', 'email', 'password', 'confirmPassword']
        });
        
        if (!formResult.success) {
            throw new Error(`Form submission failed: ${formResult.error}`);
        }
        
        // Verify successful registration
        await automation.page.waitForSelector('.success-message');
        const successMessage = await automation.page.textContent('.success-message');
        
        // Verify email verification flow
        await automation.page.goto('/verify-email');
        // ... additional verification steps
        
        return { success: true, message: 'Registration flow completed successfully' };
    } catch (error) {
        await automation.captureScreenshot('registration-flow-error');
        return { success: false, error: error.message };
    } finally {
        await automation.cleanup();
    }
}
```

### **Multi-Browser Testing**
```javascript
async function runMultiBrowserTest(testFunction, browsers = ['chromium', 'firefox', 'webkit']) {
    const results = {};
    
    for (const browser of browsers) {
        console.log(`🌐 Testing on ${browser}...`);
        
        try {
            const automation = new PlaywrightAutomation();
            await automation.initialize(browser);
            
            const result = await testFunction(automation);
            results[browser] = { success: true, ...result };
        } catch (error) {
            results[browser] = { success: false, error: error.message };
        }
    }
    
    return results;
}
```

## 📊 PERFORMANCE & METRICS

### **Performance Testing**
```javascript
async function performanceTest(url, metrics = ['FCP', 'LCP', 'CLS']) {
    const automation = new PlaywrightAutomation();
    
    try {
        await automation.initialize();
        
        // Start performance monitoring
        await automation.page.goto(url, { waitUntil: 'networkidle' });
        
        // Collect Core Web Vitals
        const webVitals = await automation.page.evaluate(() => {
            return new Promise((resolve) => {
                new PerformanceObserver((list) => {
                    const entries = list.getEntries();
                    const vitals = {};
                    
                    entries.forEach((entry) => {
                        if (entry.entryType === 'largest-contentful-paint') {
                            vitals.LCP = entry.startTime;
                        }
                        if (entry.entryType === 'first-contentful-paint') {
                            vitals.FCP = entry.startTime;
                        }
                        if (entry.entryType === 'layout-shift') {
                            vitals.CLS = entry.value;
                        }
                    });
                    
                    resolve(vitals);
                }).observe({ entryTypes: ['largest-contentful-paint', 'first-contentful-paint', 'layout-shift'] });
            });
        });
        
        return webVitals;
    } finally {
        await automation.cleanup();
    }
}
```

### **Metrics Collection**
```javascript
class AutomationMetrics {
    constructor() {
        this.metrics = {
            totalTests: 0,
            passedTests: 0,
            failedTests: 0,
            averageExecutionTime: 0,
            browserCompatibility: {},
            performanceMetrics: {}
        };
    }

    recordTest(result, executionTime, browser = 'chromium') {
        this.metrics.totalTests++;
        
        if (result.success) {
            this.metrics.passedTests++;
        } else {
            this.metrics.failedTests++;
        }
        
        // Update average execution time
        this.metrics.averageExecutionTime = 
            (this.metrics.averageExecutionTime * (this.metrics.totalTests - 1) + executionTime) / 
            this.metrics.totalTests;
        
        // Update browser compatibility
        if (!this.metrics.browserCompatibility[browser]) {
            this.metrics.browserCompatibility[browser] = { passed: 0, failed: 0 };
        }
        
        if (result.success) {
            this.metrics.browserCompatibility[browser].passed++;
        } else {
            this.metrics.browserCompatibility[browser].failed++;
        }
    }

    generateReport() {
        const successRate = (this.metrics.passedTests / this.metrics.totalTests) * 100;
        
        return {
            summary: {
                totalTests: this.metrics.totalTests,
                successRate: `${successRate.toFixed(2)}%`,
                averageExecutionTime: `${this.metrics.averageExecutionTime.toFixed(2)}ms`
            },
            browserCompatibility: this.metrics.browserCompatibility,
            performanceMetrics: this.metrics.performanceMetrics
        };
    }
}
```

## 🔧 TROUBLESHOOTING & DEBUGGING

### **Common Issues & Solutions**
1. **Timeout Errors**
   - Increase timeout values in configuration
   - Use `waitForLoadState('networkidle')` for dynamic content
   - Add explicit waits for specific elements

2. **Element Not Found**
   - Use more robust selectors (data-testid attributes)
   - Wait for elements to be visible before interaction
   - Check for dynamic content loading

3. **Visual Test Failures**
   - Adjust comparison threshold
   - Ensure consistent viewport sizes
   - Account for dynamic content (timestamps, etc.)

### **Debug Commands**
```bash
# Run tests in headed mode
npm run test:headed

# Debug specific test
npm run test:debug

# Generate test code
npm run playwright:codegen

# View test reports
npx playwright show-report
```

---

**This protocol ensures robust, reliable, and comprehensive Playwright automation integration for all testing and validation needs in the GRUPO US ecosystem.**
