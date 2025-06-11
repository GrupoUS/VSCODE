# Simple Sync Script for Testing
Write-Host "🚀 VIBECODE SYSTEM V4.0 - Simple Sync Test" -ForegroundColor Cyan

# Test if master rule exists
if (Test-Path "@project-core/memory/master_rule.md") {
    Write-Host "✅ Master Rule Found" -ForegroundColor Green
} else {
    Write-Host "❌ Master Rule Missing" -ForegroundColor Red
    exit 1
}

# Test if constitution exists
if (Test-Path "@project-core/rules/00-vibecode-system-v4-master.md") {
    Write-Host "✅ Constitution Found" -ForegroundColor Green
} else {
    Write-Host "❌ Constitution Missing" -ForegroundColor Red
    exit 1
}

# Test if VS Code config exists
if (Test-Path "@project-core/configs/ide/vscode/settings.json") {
    Write-Host "✅ VS Code Config Found" -ForegroundColor Green
} else {
    Write-Host "❌ VS Code Config Missing" -ForegroundColor Red
    exit 1
}

# Test if Cursor config exists
if (Test-Path "@project-core/configs/ide/cursor/.cursorrules") {
    Write-Host "✅ Cursor Config Found" -ForegroundColor Green
} else {
    Write-Host "❌ Cursor Config Missing" -ForegroundColor Red
    exit 1
}

# Create directories if they don't exist
if (!(Test-Path ".vscode")) {
    New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null
    Write-Host "📁 Created .vscode directory" -ForegroundColor Yellow
}

if (!(Test-Path ".cursor")) {
    New-Item -ItemType Directory -Path ".cursor" -Force | Out-Null
    Write-Host "📁 Created .cursor directory" -ForegroundColor Yellow
}

# Copy configurations
try {
    Copy-Item "@project-core/configs/ide/vscode/settings.json" ".vscode/settings.json" -Force
    Write-Host "✅ VS Code settings synchronized" -ForegroundColor Green

    # Copy VS Code MCP configuration if it exists
    if (Test-Path "@project-core/configs/ide/vscode/mcp.json") {
        Copy-Item "@project-core/configs/ide/vscode/mcp.json" ".vscode/mcp.json" -Force
        Write-Host "✅ VS Code MCP configuration synchronized" -ForegroundColor Green
    } else {
        Write-Host "⚠️ VS Code MCP configuration not found" -ForegroundColor Yellow
    }

    Copy-Item "@project-core/configs/ide/cursor/.cursorrules" ".cursorrules" -Force
    Write-Host "✅ Cursor rules synchronized" -ForegroundColor Green

    Copy-Item "@project-core/configs/ide/cursor/mcp.json" ".cursor/mcp.json" -Force
    Write-Host "✅ Cursor MCP synchronized" -ForegroundColor Green

    Write-Host "🎉 UNIFIED ENVIRONMENT SYNCHRONIZED SUCCESSFULLY" -ForegroundColor Green
    Write-Host "📋 MCP Configuration Status:" -ForegroundColor Cyan
    Write-Host "   - Master Config: @project-core/configs/mcp-master-unified.json" -ForegroundColor White
    Write-Host "   - VS Code MCP: .vscode/mcp.json" -ForegroundColor White
    Write-Host "   - Cursor MCP: .cursor/mcp.json" -ForegroundColor White
    exit 0
}
catch {
    Write-Host "❌ Synchronization failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
