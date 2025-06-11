const { read_file, write_to_file } = require('./tool_access');
const { normalizeContent } = require('./text_normalization');

/**
 * Implementa o núcleo do mecanismo de fallback: lê o arquivo,
 * aplica as modificações em memória e sobrescreve o arquivo.
 * @param {string} filePath O caminho do arquivo a ser modificado.
 * @param {string} originalDiff O diff original que foi tentado com replace_in_file.
 * @returns {Promise<void>}
 */
async function fallbackCore(filePath, originalDiff) {
  try {
    // 1. Ler o conteúdo atual do arquivo
    const fileContentResult = await read_file(filePath);
    const currentContent = fileContentResult.content;

    // 2. Normalizar o conteúdo lido
    const normalizedContent = normalizeContent(currentContent);

    // 3. Aplicar as modificações em memória
    // Esta é a parte mais complexa e crucial. Precisamos extrair o SEARCH e REPLACE
    // do originalDiff e aplicar no normalizedContent.
    // A implementação aqui é uma simulação simplificada. Em um cenário real,
    // um parser de diff mais robusto seria necessário.

    const searchMatch = /------- SEARCH\n([\s\S]*?)\n=======\n([\s\S]*?)\n\+\+\+\+\+\+\+ REPLACE/g;
    let modifiedContent = normalizedContent;
    let match;

    // Iterar sobre todos os blocos SEARCH/REPLACE no diff original
    while ((match = searchMatch.exec(originalDiff)) !== null) {
      const searchBlock = normalizeContent(match[1]); // Normalizar o bloco de busca do diff
      const replaceBlock = match[2];

      // Encontrar a primeira ocorrência do searchBlock normalizado no conteúdo normalizado
      const index = modifiedContent.indexOf(searchBlock);
      if (index !== -1) {
        modifiedContent = modifiedContent.substring(0, index) + replaceBlock + modifiedContent.substring(index + searchBlock.length);
      } else {
        console.warn(`[FallbackCore] Bloco SEARCH não encontrado no arquivo normalizado para o caminho: ${filePath}. Tentando aplicar mesmo assim.`);
        // Se o bloco SEARCH não for encontrado, o fallback ainda tentará aplicar o REPLACE
        // Isso pode ser um comportamento desejável em alguns casos de fallback,
        // mas pode levar a resultados inesperados se o SEARCH block for crucial.
        // Uma estratégia mais robusta poderia decidir não aplicar se o SEARCH não for encontrado.
      }
    }

    // 4. Escrever o conteúdo modificado de volta no arquivo
    await write_to_file(filePath, modifiedContent);
    console.log(`[FallbackCore] Arquivo ${filePath} modificado com sucesso via fallback.`);

  } catch (error) {
    console.error(`[FallbackCore] Erro ao executar o fallback para ${filePath}:`, error);
    throw error;
  }
}

module.exports = {
  fallbackCore,
};
