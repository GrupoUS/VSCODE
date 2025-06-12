const fs = require("fs");
const path = require("path");

function checkJsonFiles(dir) {
  fs.readdirSync(dir).forEach((file) => {
    const fullPath = path.join(dir, file);
    if (fs.statSync(fullPath).isDirectory()) {
      checkJsonFiles(fullPath);
    } else if (file.endsWith(".json")) {
      try {
        const content = fs.readFileSync(fullPath, "utf8");
        if (!content.trim()) {
          console.error(`❌ JSON vazio: ${fullPath}`);
        } else {
          JSON.parse(content);
        }
      } catch (e) {
        console.error(`❌ JSON inválido: ${fullPath}\n${e.message}`);
      }
    }
  });
}

console.log("🔎 Verificando integridade dos arquivos JSON do projeto...");
checkJsonFiles(process.cwd());
console.log(
  "✅ Varredura concluída. Corrija os arquivos listados acima, se houver."
);
