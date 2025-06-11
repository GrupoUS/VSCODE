const fs = require("fs");
const path = require("path");

// Caminhos dos arquivos
const MASTER_CONFIG_PATH = path.join(
  __dirname,
  "../configs/mcp-master-unified.json"
);
const CURSOR_CONFIG_PATH = path.join(__dirname, "../../.cursor/mcp.json");

// Função para ler e validar JSON
function readJsonFile(filePath) {
  try {
    const content = fs.readFileSync(filePath, "utf8");
    return JSON.parse(content);
  } catch (error) {
    console.error(`Erro ao ler arquivo ${filePath}:`, error);
    process.exit(1);
  }
}

// Função para escrever JSON
function writeJsonFile(filePath, data) {
  try {
    const content = JSON.stringify(data, null, 2);
    fs.writeFileSync(filePath, content, "utf8");
    console.log(`✅ Arquivo ${filePath} atualizado com sucesso!`);
  } catch (error) {
    console.error(`Erro ao escrever arquivo ${filePath}:`, error);
    process.exit(1);
  }
}

// Função para mesclar MCPs
function mergeMcpServers(masterMcp, cursorMcp) {
  // Começa com todos os MCPs do Cursor (para manter configs exclusivas)
  const merged = { ...cursorMcp };
  // Adiciona/atualiza todos os MCPs do master
  for (const [key, value] of Object.entries(masterMcp)) {
    merged[key] = value;
  }
  return merged;
}

// Função principal de sincronização
function syncCursorConfig() {
  console.log("🔄 Iniciando sincronização do MCP do Cursor...");

  // Lê as configurações
  const masterConfig = readJsonFile(MASTER_CONFIG_PATH);
  const cursorConfig = readJsonFile(CURSOR_CONFIG_PATH);

  // Atualiza a configuração do Cursor com os dados do master
  cursorConfig.metadata = {
    ...cursorConfig.metadata,
    version: masterConfig.metadata.version,
    lastUpdated: new Date().toISOString(),
    syncWith: "mcp-master-unified",
  };

  // Mescla os servidores MCP
  cursorConfig.mcpServers = mergeMcpServers(
    masterConfig.mcpServers,
    cursorConfig.mcpServers
  );

  // Atualiza as configurações específicas do Cursor
  cursorConfig.cursorSpecificConfig =
    masterConfig.unifiedSystemConfig?.crossEnvironmentSupport?.cursor
      ?.cursorSpecificConfig || cursorConfig.cursorSpecificConfig;

  // Atualiza a integração unificada
  cursorConfig.unifiedIntegration = {
    vsCodeSync:
      masterConfig.unifiedSystemConfig?.synchronization?.cursorSync ||
      cursorConfig.unifiedIntegration?.vsCodeSync,
    memoryBankIntegration:
      masterConfig.integration?.memory ||
      cursorConfig.unifiedIntegration?.memoryBankIntegration,
    complianceMonitoring:
      masterConfig.unifiedSystemConfig?.synchronization ||
      cursorConfig.unifiedIntegration?.complianceMonitoring,
  };

  // Atualiza os workflows
  cursorConfig.workflowIntegration =
    masterConfig.workflowIntegration || cursorConfig.workflowIntegration;

  // Salva as alterações
  writeJsonFile(CURSOR_CONFIG_PATH, cursorConfig);

  console.log("✅ Sincronização concluída com sucesso!");
}

// Executa a sincronização
syncCursorConfig();
