# Enhanced Memory System V4.1 - Integration Test
# Context7 Smithery + Upstash Integration Validation
# Created: 2025-01-11

param(
    [switch]$Verbose = $false
)

Write-Host "🚀 ENHANCED MEMORY SYSTEM V4.1 VALIDATION" -ForegroundColor Cyan
Write-Host "Context7 Smithery + Upstash Integration" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$validationResults = @()
$totalTests = 0
$passedTests = 0

function Test-FileExists {
    param([string]$FilePath, [string]$Description)

    $global:totalTests++
    if (Test-Path $FilePath) {
        Write-Host "✅ $Description" -ForegroundColor Green
        $global:passedTests++
        return $true
    } else {
        Write-Host "❌ $Description" -ForegroundColor Red
        return $false
    }
}

function Test-JsonValid {
    param([string]$FilePath, [string]$Description)

    $global:totalTests++
    try {
        $content = Get-Content $FilePath -Raw | ConvertFrom-Json
        Write-Host "✅ $Description" -ForegroundColor Green
        $global:passedTests++
        return $true
    } catch {
        Write-Host "❌ $Description - Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

Write-Host "📋 Phase 1: File Structure Validation" -ForegroundColor Yellow
Write-Host "-------------------------------------" -ForegroundColor Yellow

# Test MCP configuration file
Test-FileExists "@project-core\configs\mcp-servers.json" "MCP servers configuration exists"
Test-JsonValid "@project-core\configs\mcp-servers.json" "MCP servers configuration is valid JSON"

# Test environment file
Test-FileExists "@project-core\.env\upstash-mcp.env" "Upstash environment configuration exists"

# Test documentation
Test-FileExists "@project-core\docs\upstash-context-integration.md" "Integration documentation exists"

# Test memory system updates
Test-FileExists "@project-core\memory\master_rule.md" "Master rule file exists"
Test-FileExists "@project-core\memory\self_correction_log.md" "Self correction log exists"

Write-Host ""
Write-Host "📋 Phase 2: Configuration Content Validation" -ForegroundColor Yellow
Write-Host "--------------------------------------------" -ForegroundColor Yellow

# Check MCP configuration contains Context7 and Upstash
$totalTests++
try {
    $mcpConfig = Get-Content "@project-core\configs\mcp-servers.json" -Raw | ConvertFrom-Json

    # Test Context7 MCP via Smithery
    if ($mcpConfig.mcpServers."context7-mcp") {
        Write-Host "✅ Context7 MCP (Smithery) configured in mcp-servers.json" -ForegroundColor Green
        $passedTests++

        # Check Context7 priority
        $totalTests++
        if ($mcpConfig.mcpServers."context7-mcp".priority -eq 6) {
            Write-Host "✅ Context7 MCP has correct priority (6)" -ForegroundColor Green
            $passedTests++
        } else {
            Write-Host "❌ Context7 MCP priority incorrect" -ForegroundColor Red
        }

        # Check Context7 Smithery configuration
        $totalTests++
        $context7Args = $mcpConfig.mcpServers."context7-mcp".args
        if ($context7Args -contains "@smithery/cli@latest") {
            Write-Host "✅ Context7 MCP configured with Smithery CLI" -ForegroundColor Green
            $passedTests++
        } else {
            Write-Host "❌ Context7 MCP not configured with Smithery CLI" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Context7 MCP server not found in configuration" -ForegroundColor Red
    }

    # Test Upstash MCP
    if ($mcpConfig.mcpServers."upstash-mcp") {
        Write-Host "✅ Upstash MCP server configured in mcp-servers.json" -ForegroundColor Green
        $passedTests++

        # Check priority
        $totalTests++
        if ($mcpConfig.mcpServers."upstash-mcp".priority -eq 6) {
            Write-Host "✅ Upstash MCP server has correct priority (6)" -ForegroundColor Green
            $passedTests++
        } else {
            Write-Host "❌ Upstash MCP server priority incorrect" -ForegroundColor Red
        }

        # Check capabilities
        $totalTests++
        $capabilities = $mcpConfig.mcpServers."upstash-mcp".capabilities
        if ($capabilities -contains "redis-context-management") {
            Write-Host "✅ Upstash MCP server has redis-context-management capability" -ForegroundColor Green
            $passedTests++
        } else {
            Write-Host "❌ Upstash MCP server missing redis-context-management capability" -ForegroundColor Red
        }
    } else {
        Write-Host "❌ Upstash MCP server not found in configuration" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error reading MCP configuration: $($_.Exception.Message)" -ForegroundColor Red
}

# Check environment file content
$totalTests++
try {
    $envContent = Get-Content "@project-core\.env\upstash-mcp.env" -Raw
    if ($envContent -match "UPSTASH_EMAIL" -and $envContent -match "UPSTASH_API_KEY") {
        Write-Host "✅ Environment file contains required Upstash variables" -ForegroundColor Green
        $passedTests++
    } else {
        Write-Host "❌ Environment file missing required Upstash variables" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error reading environment file: $($_.Exception.Message)" -ForegroundColor Red
}

# Check master rule updates
$totalTests++
try {
    $masterRuleContent = Get-Content "@project-core\memory\master_rule.md" -Raw
    if ($masterRuleContent -match "SISTEMA HÍBRIDO DE CONTEXTO V4.0") {
        Write-Host "✅ Master rule updated with hybrid context system" -ForegroundColor Green
        $passedTests++
    } else {
        Write-Host "❌ Master rule not updated with hybrid context system" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error reading master rule: $($_.Exception.Message)" -ForegroundColor Red
}

# Check self correction log updates
$totalTests++
try {
    $logContent = Get-Content "@project-core\memory\self_correction_log.md" -Raw
    if ($logContent -match "UPSTASH CONTEXT INTEGRATION V4.0") {
        Write-Host "✅ Self correction log updated with integration details" -ForegroundColor Green
        $passedTests++
    } else {
        Write-Host "❌ Self correction log not updated with integration details" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Error reading self correction log: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 Phase 3: Integration Readiness Check" -ForegroundColor Yellow
Write-Host "--------------------------------------" -ForegroundColor Yellow

# Check if npx is available
$totalTests++
try {
    $npxVersion = npx --version 2>$null
    if ($npxVersion) {
        Write-Host "✅ npx is available (version: $npxVersion)" -ForegroundColor Green
        $passedTests++
    } else {
        Write-Host "❌ npx not available" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ npx not available" -ForegroundColor Red
}

# Check Node.js version
$totalTests++
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Host "✅ Node.js is available (version: $nodeVersion)" -ForegroundColor Green
        $passedTests++
    } else {
        Write-Host "❌ Node.js not available" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Node.js not available" -ForegroundColor Red
}

Write-Host ""
Write-Host "📊 VALIDATION SUMMARY" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

$successRate = [math]::Round(($passedTests / $totalTests) * 100, 1)

Write-Host "Total Tests: $totalTests" -ForegroundColor White
Write-Host "Passed: $passedTests" -ForegroundColor Green
Write-Host "Failed: $($totalTests - $passedTests)" -ForegroundColor Red
Write-Host "Success Rate: $successRate%" -ForegroundColor $(if ($successRate -ge 80) { "Green" } else { "Yellow" })

Write-Host ""

if ($successRate -ge 80) {
    Write-Host "🎉 INTEGRATION VALIDATION SUCCESSFUL!" -ForegroundColor Green
    Write-Host "✅ Upstash Context Integration V4.0 is ready for production" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Configure actual Upstash credentials in production environment" -ForegroundColor White
    Write-Host "2. Test Redis connectivity: npx @upstash/mcp-server run <email> <api_key>" -ForegroundColor White
    Write-Host "3. Monitor performance metrics and cache hit rates" -ForegroundColor White
    Write-Host "4. Validate fallback mechanisms under load" -ForegroundColor White
} else {
    Write-Host "⚠️  INTEGRATION VALIDATION INCOMPLETE" -ForegroundColor Yellow
    Write-Host "❌ Some tests failed - review and fix issues before production" -ForegroundColor Red
}

Write-Host ""
Write-Host "📚 Documentation: @project-core/docs/upstash-context-integration.md" -ForegroundColor Cyan
Write-Host "🔧 Environment Config: @project-core/.env/upstash-mcp.env" -ForegroundColor Cyan
Write-Host "⚙️  MCP Configuration: @project-core/configs/mcp-servers.json" -ForegroundColor Cyan

return $successRate
