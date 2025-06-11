const { read_file } = require('./tool_access');
const { normalizeContent } = require('./text_normalization');

/**
 * Valida se um bloco SEARCH existe no conteúdo de um arquivo.
 * @param {string} filePath O caminho do arquivo a ser validado.
 * @param {string} searchContent O conteúdo do bloco SEARCH a ser procurado.
 * @returns {Promise<boolean>} True se o bloco SEARCH for encontrado, false caso contrário.
 */
async function validateSearchBlock(filePath, searchContent) {
  try {
    // 1. Ler o conteúdo atual do arquivo
    const fileContentResult = await read_file(filePath);
    const currentContent = fileContentResult.content;

    // 2. Normalizar o conteúdo do arquivo e o bloco SEARCH
    const normalizedFileContent = normalizeContent(currentContent);
    const normalizedSearchContent = normalizeContent(searchContent);

    // 3. Verificar se o bloco SEARCH normalizado existe no conteúdo do arquivo normalizado
    return normalizedFileContent.includes(normalizedSearchContent);
  } catch (error) {
    console.error(`Erro ao validar o bloco SEARCH para ${filePath}:`, error);
    return false; // Em caso de erro, assumimos que o bloco não foi encontrado ou não pôde ser validado.
  }
}

module.exports = {
  validateSearchBlock,
};
