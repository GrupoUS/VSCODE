const fs = require('fs');
const path = require('path');

const mcpConfigPath = path.resolve(__dirname, '../.vscode/mcp.json');
const envPath = path.resolve(__dirname, '../.env');

console.log('Iniciando script de configuração MCP...');

// 1. Fazer backup do .vscode/mcp.json existente
if (fs.existsSync(mcpConfigPath)) {
    const backupPath = `${mcpConfigPath}.bak`;
    fs.copyFileSync(mcpConfigPath, backupPath);
    console.log(`Backup de ${mcpConfigPath} criado em ${backupPath}`);
} else {
    console.log(`${mcpConfigPath} não encontrado. Será criado um novo.`);
}

// 2. Conteúdo atualizado para .vscode/mcp.json
const newMcpConfigContent = {
    "servers": [
        {
            "name": "github.com/modelcontextprotocol/servers/tree/main/src/github",
            "path": "npx -y @modelcontextprotocol/server-github",
            "env": {}
        },
        {
            "name": "github.com/upstash/context7-mcp",
            "path": "cmd /c npx -y @upstash/context7-mcp@latest",
            "env": {}
        },
        {
            "name": "github.com/pashpashpash/perplexity-mcp",
            "path": "node C:\\Users\\Admin\\Documents\\Claude\\MCP\\perplexity-mcp\\build\\index.js",
            "env": {
                "PERPLEXITY_API_KEY": "${env:PERPLEXITY_API_KEY}"
            }
        },
        {
            "name": "github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking",
            "path": "npx -y @modelcontextprotocol/server-sequential-thinking",
            "env": {}
        },
        {
            "name": "github.com/GLips/Figma-Context-MCP",
            "path": "cmd /c npx -y figma-developer-mcp --figma-api-key=YOUR_FIGMA_API_KEY_HERE --stdio",
            "env": {}
        },
        {
            "name": "github.com/executeautomation/mcp-playwright",
            "path": "npx -y @executeautomation/playwright-mcp-server",
            "env": {}
        },
        {
            "name": "github.com/supabase-community/supabase-mcp",
            "path": "cmd /c npx -y @supabase/mcp-server-supabase@latest --access-token YOUR_SUPABASE_ACCESS_TOKEN_HERE",
            "env": {}
        },
        {
            "name": "taskmaster-ai",
            "path": "npx -y @taskmaster-ai/cli@latest --server",
            "env": {
                "ANTHROPIC_API_KEY": "${env:ANTHROPIC_API_KEY}",
                "PERPLEXITY_API_KEY": "${env:PERPLEXITY_API_KEY}"
            }
        }
    ]
};

try {
    fs.writeFileSync(mcpConfigPath, JSON.stringify(newMcpConfigContent, null, 4));
    console.log(`Arquivo ${mcpConfigPath} atualizado com sucesso.`);
} catch (error) {
    console.error(`Erro ao escrever em ${mcpConfigPath}:`, error);
}

// 3. Verificar se .env existe e contém as chaves necessárias
if (!fs.existsSync(envPath)) {
    console.warn(`Arquivo .env não encontrado em ${envPath}. Certifique-se de que as API keys estão configuradas.`);
} else {
    const envContent = fs.readFileSync(envPath, 'utf8');
    if (!envContent.includes('ANTHROPIC_API_KEY') || !envContent.includes('PERPLEXITY_API_KEY')) {
        console.warn(`O arquivo .env não contém ANTHROPIC_API_KEY ou PERPLEXITY_API_KEY. Por favor, adicione-as.`);
    } else {
        console.log('API keys verificadas no .env.');
    }
}

console.log('Script de configuração MCP finalizado.');
