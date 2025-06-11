# 🧪 FIGMA CONTEXT MCP VALIDATION SCRIPT
# GRUPO US VIBECODE SYSTEM V4.0
# Validates Figma API key and MCP integration

param(
    [switch]$Detailed,
    [switch]$TestConnection,
    [switch]$CheckMCP
)

$ErrorActionPreference = "Continue"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Host "FIGMA CONTEXT MCP VALIDATION" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "Timestamp: $timestamp" -ForegroundColor Gray
Write-Host ""

# Test 1: Check if environment file exists
Write-Host "Checking environment configuration..." -ForegroundColor Yellow

$envFile = "@project-core/configs/figma-context-mcp.env"
if (Test-Path $envFile) {
    Write-Host "  ✅ Environment file found: $envFile" -ForegroundColor Green

    # Load environment variables
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
        }
    }

    # Check if API key is configured
    $apiKey = $env:FIGMA_API_KEY
    if ($apiKey -and $apiKey -ne "your_figma_api_key_here") {
        Write-Host "  ✅ Figma API key is configured" -ForegroundColor Green
        Write-Host "  🔑 Key format: $($apiKey.Substring(0,8))..." -ForegroundColor Gray
    } else {
        Write-Host "  ❌ Figma API key not configured or using placeholder" -ForegroundColor Red
        Write-Host "  💡 Edit $envFile and set your real API key" -ForegroundColor Yellow
        return
    }
} else {
    Write-Host "  ❌ Environment file not found: $envFile" -ForegroundColor Red
    return
}

# Test 2: Check MCP package availability
if ($CheckMCP) {
    Write-Host ""
    Write-Host "📦 Checking Figma MCP package..." -ForegroundColor Yellow

    try {
        $mcpVersion = npx -y figma-developer-mcp --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✅ Figma MCP package available: $mcpVersion" -ForegroundColor Green
        } else {
            Write-Host "  ❌ Figma MCP package not available" -ForegroundColor Red
            Write-Host "  💡 Run: npx -y figma-developer-mcp --version" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  ❌ Error checking MCP package: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 3: Test API connection
if ($TestConnection -and $apiKey) {
    Write-Host ""
    Write-Host "🌐 Testing Figma API connection..." -ForegroundColor Yellow

    try {
        $headers = @{
            "X-Figma-Token" = $apiKey
        }

        $response = Invoke-RestMethod -Uri "https://api.figma.com/v1/me" -Headers $headers -Method GET

        if ($response) {
            Write-Host "  ✅ API connection successful" -ForegroundColor Green
            Write-Host "  👤 User: $($response.name)" -ForegroundColor Gray
            Write-Host "  📧 Email: $($response.email)" -ForegroundColor Gray
        }
    } catch {
        Write-Host "  ❌ API connection failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "  💡 Check your API key and network connection" -ForegroundColor Yellow
    }
}

# Test 4: Check Cursor MCP configuration
Write-Host ""
Write-Host "⚙️ Checking Cursor MCP configuration..." -ForegroundColor Yellow

$cursorMcp = ".cursor/mcp.json"
if (Test-Path $cursorMcp) {
    $mcpConfig = Get-Content $cursorMcp | ConvertFrom-Json

    if ($mcpConfig.mcpServers."figma-context-mcp") {
        Write-Host "  ✅ Figma Context MCP configured in Cursor" -ForegroundColor Green

        $figmaMcp = $mcpConfig.mcpServers."figma-context-mcp"
        Write-Host "  📋 Command: $($figmaMcp.command)" -ForegroundColor Gray
        Write-Host "  🔧 Args: $($figmaMcp.args -join ' ')" -ForegroundColor Gray
        Write-Host "  ⚡ Enabled: $($figmaMcp.enabled)" -ForegroundColor Gray
    } else {
        Write-Host "  ❌ Figma Context MCP not found in Cursor configuration" -ForegroundColor Red
    }
} else {
    Write-Host "  ❌ Cursor MCP configuration not found: $cursorMcp" -ForegroundColor Red
}

# Test 5: Security check
Write-Host ""
Write-Host "Security validation..." -ForegroundColor Yellow

$gitignoreFile = ".gitignore"
if (Test-Path $gitignoreFile) {
    $gitignoreContent = Get-Content $gitignoreFile -Raw

    if ($gitignoreContent -match "figma-context-mcp\.env") {
        Write-Host "  ✅ Environment file protected in .gitignore" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ Environment file may not be protected in .gitignore" -ForegroundColor Yellow
    }

    if ($gitignoreContent -match "\*\*\/\*api-key\*") {
        Write-Host "  ✅ API key patterns protected in .gitignore" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️ API key patterns may not be protected in .gitignore" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ❌ .gitignore file not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "🎯 VALIDATION COMPLETE" -ForegroundColor Cyan
Write-Host "=====================" -ForegroundColor Cyan

if ($Detailed) {
    Write-Host ""
    Write-Host "📋 Next Steps:" -ForegroundColor Yellow
    Write-Host "1. Restart Cursor to reload MCP configuration" -ForegroundColor White
    Write-Host "2. Test with a Figma URL in Cursor Agent Mode" -ForegroundColor White
    Write-Host "3. Run full test plan: @project-core/tests/figma-context-mcp-test-plan.md" -ForegroundColor White
}

Write-Host ""
Write-Host "🚀 GRUPO US VIBECODE SYSTEM V4.0 - Figma Integration Ready!" -ForegroundColor Green
