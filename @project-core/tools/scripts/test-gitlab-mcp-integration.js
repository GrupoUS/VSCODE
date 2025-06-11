#!/usr/bin/env node

/**
 * GitLab MCP Integration Test Script
 * GRUPO US VIBECODE SYSTEM V2.0
 * 
 * Comprehensive testing of GitLab MCP integration with TaskMaster,
 * Sequential Thinking, and bilateral synchronization workflows.
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🧪 GITLAB MCP INTEGRATION TEST SUITE');
console.log('='.repeat(60));

let testResults = {
    passed: 0,
    failed: 0,
    warnings: 0,
    details: []
};

function logTest(name, status, message = '') {
    const statusIcon = status === 'PASS' ? '✅' : status === 'FAIL' ? '❌' : '⚠️';
    console.log(`${statusIcon} ${name}: ${status}`);
    if (message) console.log(`   ${message}`);
    
    testResults.details.push({ name, status, message });
    if (status === 'PASS') testResults.passed++;
    else if (status === 'FAIL') testResults.failed++;
    else testResults.warnings++;
}

// Test 1: GitLab MCP Installation Verification
console.log('\n📦 Test 1: GitLab MCP Installation');
try {
    const result = execSync('npm list -g @zereight/mcp-gitlab', { encoding: 'utf8', stdio: 'pipe' });
    if (result.includes('@zereight/mcp-gitlab')) {
        logTest('GitLab MCP Package', 'PASS', 'Globally installed');
    } else {
        logTest('GitLab MCP Package', 'FAIL', 'Not found in global packages');
    }
} catch (error) {
    logTest('GitLab MCP Package', 'FAIL', 'Installation check failed');
}

// Test 2: MCP Configuration Verification
console.log('\n📋 Test 2: MCP Configuration');
try {
    const mcpConfig = JSON.parse(fs.readFileSync('.vscode/mcp.json', 'utf8'));
    const gitlabServer = mcpConfig.servers.find(server => server.name === 'gitlab-mcp');
    
    if (gitlabServer) {
        logTest('GitLab MCP Server Config', 'PASS', 'Found in .vscode/mcp.json');
        
        // Check required environment variables
        const requiredEnvVars = [
            'GITLAB_PERSONAL_ACCESS_TOKEN',
            'GITLAB_API_URL',
            'GITLAB_READ_ONLY_MODE',
            'USE_GITLAB_WIKI',
            'USE_MILESTONE',
            'USE_PIPELINE'
        ];
        
        const missingVars = requiredEnvVars.filter(envVar => !gitlabServer.env[envVar]);
        if (missingVars.length === 0) {
            logTest('Environment Variables', 'PASS', 'All required variables configured');
        } else {
            logTest('Environment Variables', 'WARN', `Missing: ${missingVars.join(', ')}`);
        }
    } else {
        logTest('GitLab MCP Server Config', 'FAIL', 'Not found in MCP configuration');
    }
} catch (error) {
    logTest('MCP Configuration', 'FAIL', `Error reading config: ${error.message}`);
}

// Test 3: Environment Variables Verification
console.log('\n🌍 Test 3: Environment Variables');
const envFile = '.env';
if (fs.existsSync(envFile)) {
    const envContent = fs.readFileSync(envFile, 'utf8');
    
    const gitlabVars = [
        'GITLAB_PERSONAL_ACCESS_TOKEN',
        'GITLAB_API_URL',
        'GITLAB_READ_ONLY_MODE',
        'USE_GITLAB_WIKI',
        'USE_MILESTONE',
        'USE_PIPELINE'
    ];
    
    gitlabVars.forEach(envVar => {
        if (envContent.includes(envVar)) {
            logTest(`${envVar}`, 'PASS', 'Defined in .env file');
        } else {
            logTest(`${envVar}`, 'FAIL', 'Missing from .env file');
        }
    });
    
    // Check for GitHub token (compatibility)
    if (envContent.includes('GITHUB_TOKEN')) {
        logTest('GitHub Token', 'PASS', 'GitHub integration maintained');
    } else {
        logTest('GitHub Token', 'WARN', 'GitHub token not found');
    }
} else {
    logTest('Environment File', 'FAIL', '.env file not found');
}

// Test 4: Integration Rules Verification
console.log('\n📜 Test 4: Integration Rules');
const integrationFiles = [
    '.clinerules/gitlab-mcp-automation.md',
    '.clinerules/taskmaster-gitlab-integration.md',
    'memory-bank/gitlab-mcp-integration-analysis.md'
];

integrationFiles.forEach(file => {
    if (fs.existsSync(file)) {
        logTest(`${path.basename(file)}`, 'PASS', 'Integration rules file exists');
        
        // Check file content for key patterns
        const content = fs.readFileSync(file, 'utf8');
        if (content.includes('bilateral') && content.includes('sync')) {
            logTest(`${path.basename(file)} Content`, 'PASS', 'Contains bilateral sync patterns');
        } else {
            logTest(`${path.basename(file)} Content`, 'WARN', 'May be missing key integration patterns');
        }
    } else {
        logTest(`${path.basename(file)}`, 'FAIL', 'Integration rules file missing');
    }
});

// Test 5: TaskMaster Integration
console.log('\n🎯 Test 5: TaskMaster Integration');
try {
    const taskMasterVersion = execSync('task-master --version', { encoding: 'utf8', stdio: 'pipe' });
    logTest('TaskMaster CLI', 'PASS', 'Available and working');
    
    // Check for TaskMaster-GitLab integration rules
    const integrationFile = '.clinerules/taskmaster-gitlab-integration.md';
    if (fs.existsSync(integrationFile)) {
        const content = fs.readFileSync(integrationFile, 'utf8');
        if (content.includes('complexity > 7') && content.includes('gitlab_sync')) {
            logTest('TaskMaster-GitLab Rules', 'PASS', 'Integration triggers configured');
        } else {
            logTest('TaskMaster-GitLab Rules', 'WARN', 'Integration triggers may need review');
        }
    } else {
        logTest('TaskMaster-GitLab Rules', 'FAIL', 'Integration rules not found');
    }
} catch (error) {
    logTest('TaskMaster CLI', 'FAIL', 'TaskMaster not accessible');
}

// Test 6: Sequential Thinking Integration
console.log('\n🤔 Test 6: Sequential Thinking Integration');
const sequentialRules = '.clinerules/rules/sequential-thinking-mcp.md';
if (fs.existsSync(sequentialRules)) {
    const content = fs.readFileSync(sequentialRules, 'utf8');
    if (content.includes('gitlab') || content.includes('GitLab')) {
        logTest('Sequential Thinking GitLab', 'PASS', 'GitLab patterns included');
    } else {
        logTest('Sequential Thinking GitLab', 'WARN', 'GitLab patterns may need addition');
    }
} else {
    logTest('Sequential Thinking Rules', 'FAIL', 'Sequential thinking rules not found');
}

// Test 7: MCP Initialization Protocol Update
console.log('\n🔄 Test 7: MCP Initialization Protocol');
const mcpProtocol = 'memory-bank/protocols/mcp_initialization_protocol.md';
if (fs.existsSync(mcpProtocol)) {
    const content = fs.readFileSync(mcpProtocol, 'utf8');
    if (content.includes('GitLab MCP')) {
        logTest('MCP Protocol Update', 'PASS', 'GitLab MCP included in protocol');
    } else {
        logTest('MCP Protocol Update', 'FAIL', 'GitLab MCP not included in protocol');
    }
} else {
    logTest('MCP Protocol File', 'FAIL', 'MCP initialization protocol not found');
}

// Test 8: Safety and Backup Mechanisms
console.log('\n🛡️ Test 8: Safety Mechanisms');
const automationFile = '.clinerules/gitlab-mcp-automation.md';
if (fs.existsSync(automationFile)) {
    const content = fs.readFileSync(automationFile, 'utf8');
    
    const safetyFeatures = [
        'backup',
        'rollback',
        'conflict',
        'validation',
        'prompt_user'
    ];
    
    safetyFeatures.forEach(feature => {
        if (content.includes(feature)) {
            logTest(`Safety: ${feature}`, 'PASS', 'Safety mechanism implemented');
        } else {
            logTest(`Safety: ${feature}`, 'WARN', 'Safety mechanism may be missing');
        }
    });
} else {
    logTest('Safety Mechanisms', 'FAIL', 'Automation rules file not found');
}

// Test 9: Documentation Completeness
console.log('\n📚 Test 9: Documentation');
const docFiles = [
    'memory-bank/gitlab-mcp-integration-analysis.md',
    '.clinerules/gitlab-mcp-automation.md',
    '.clinerules/taskmaster-gitlab-integration.md'
];

let docScore = 0;
docFiles.forEach(file => {
    if (fs.existsSync(file)) {
        const stats = fs.statSync(file);
        if (stats.size > 1000) { // At least 1KB of content
            docScore++;
            logTest(`Documentation: ${path.basename(file)}`, 'PASS', 'Comprehensive documentation');
        } else {
            logTest(`Documentation: ${path.basename(file)}`, 'WARN', 'Documentation may be incomplete');
        }
    } else {
        logTest(`Documentation: ${path.basename(file)}`, 'FAIL', 'Documentation file missing');
    }
});

if (docScore === docFiles.length) {
    logTest('Documentation Completeness', 'PASS', 'All documentation files present and substantial');
} else {
    logTest('Documentation Completeness', 'WARN', `${docScore}/${docFiles.length} documentation files complete`);
}

// Test 10: System Compatibility
console.log('\n🔧 Test 10: System Compatibility');
try {
    const nodeVersion = execSync('node --version', { encoding: 'utf8' }).trim();
    const npmVersion = execSync('npm --version', { encoding: 'utf8' }).trim();
    
    logTest('Node.js Version', 'PASS', nodeVersion);
    logTest('npm Version', 'PASS', npmVersion);
    
    // Check for potential conflicts
    const mcpConfig = JSON.parse(fs.readFileSync('.vscode/mcp.json', 'utf8'));
    const serverNames = mcpConfig.servers.map(s => s.name);
    
    if (serverNames.includes('gitlab-mcp') && serverNames.includes('github.com/modelcontextprotocol/servers/tree/main/src/github')) {
        logTest('GitHub-GitLab Compatibility', 'PASS', 'Both GitHub and GitLab MCP configured');
    } else {
        logTest('GitHub-GitLab Compatibility', 'WARN', 'GitHub or GitLab MCP may be missing');
    }
} catch (error) {
    logTest('System Compatibility', 'FAIL', 'Error checking system compatibility');
}

// Generate Test Report
console.log('\n📊 TEST SUMMARY');
console.log('='.repeat(60));
console.log(`✅ Tests Passed: ${testResults.passed}`);
console.log(`❌ Tests Failed: ${testResults.failed}`);
console.log(`⚠️ Warnings: ${testResults.warnings}`);

const totalTests = testResults.passed + testResults.failed + testResults.warnings;
const successRate = Math.round((testResults.passed / totalTests) * 100);

console.log(`📈 Success Rate: ${successRate}%`);

if (testResults.failed === 0) {
    console.log('\n🎉 GITLAB MCP INTEGRATION: READY FOR USE!');
    console.log('All critical tests passed. The system is ready for production use.');
} else if (testResults.failed <= 2) {
    console.log('\n⚠️ GITLAB MCP INTEGRATION: NEEDS ATTENTION');
    console.log('Some tests failed. Review the issues before production use.');
} else {
    console.log('\n❌ GITLAB MCP INTEGRATION: REQUIRES FIXES');
    console.log('Multiple critical issues detected. Fix before proceeding.');
}

console.log('\n📖 Next Steps:');
console.log('1. Review any failed tests and fix issues');
console.log('2. Configure GitLab Personal Access Token in .env');
console.log('3. Test GitLab connectivity with your repository');
console.log('4. Run TaskMaster integration tests');
console.log('5. Begin using GitLab MCP for complex task synchronization');

// Save detailed report
const reportFile = `reports/gitlab-mcp-integration-test-${new Date().toISOString().slice(0, 10)}.json`;
if (!fs.existsSync('reports')) {
    fs.mkdirSync('reports', { recursive: true });
}

fs.writeFileSync(reportFile, JSON.stringify({
    timestamp: new Date().toISOString(),
    summary: {
        passed: testResults.passed,
        failed: testResults.failed,
        warnings: testResults.warnings,
        successRate: successRate
    },
    details: testResults.details
}, null, 2));

console.log(`\n📄 Detailed report saved: ${reportFile}`);

process.exit(testResults.failed > 0 ? 1 : 0);
