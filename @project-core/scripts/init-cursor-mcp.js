const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");

// Função para verificar se o diretório .cursor existe
function ensureCursorDirectory() {
  const cursorDir = path.join(__dirname, "../../.cursor");
  if (!fs.existsSync(cursorDir)) {
    console.log("📁 Criando diretório .cursor...");
    fs.mkdirSync(cursorDir, { recursive: true });
  }
}

// Função para verificar se o arquivo mcp.json existe
function ensureCursorConfig() {
  const cursorConfigPath = path.join(__dirname, "../../.cursor/mcp.json");
  if (!fs.existsSync(cursorConfigPath)) {
    console.log("📄 Criando arquivo mcp.json inicial...");
    const initialConfig = {
      metadata: {
        name: "GRUPO US VIBECODE SYSTEM V4.0 - Cursor MCP Configuration",
        version: "4.0.1",
        description: "Unified MCP configuration for Cursor AI",
        lastUpdated: new Date().toISOString(),
        author: "GRUPO US - VIBECODE SYSTEM",
        environment: "cursor-frontend-specialist",
        syncWith: "mcp-master-unified",
        complianceLevel: "mandatory",
      },
      mcpServers: {},
      cursorSpecificConfig: {},
      unifiedIntegration: {},
      workflowIntegration: {},
    };
    fs.writeFileSync(cursorConfigPath, JSON.stringify(initialConfig, null, 2));
  }
}

// Função principal de inicialização
function initCursorMCP() {
  console.log("🚀 Iniciando configuração do MCP do Cursor...");

  try {
    // Garante que o diretório .cursor existe
    ensureCursorDirectory();

    // Garante que o arquivo mcp.json existe
    ensureCursorConfig();

    // Executa a sincronização
    console.log("🔄 Executando sincronização inicial...");
    execSync("node sync-cursor-mcp.js", {
      cwd: __dirname,
      stdio: "inherit",
    });

    console.log("✅ Configuração do MCP do Cursor concluída com sucesso!");
  } catch (error) {
    console.error("❌ Erro durante a inicialização:", error);
    process.exit(1);
  }
}

// Executa a inicialização
initCursorMCP();
