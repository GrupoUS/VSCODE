const { read_file } = require('./tool_access');
const { normalizeContent } = require('./text_normalization');

/**
 * Valida se as mudanças desejadas foram aplicadas corretamente após um fallback.
 * @param {string} filePath O caminho do arquivo a ser validado.
 * @param {string} expectedContent O conteúdo que se espera que o arquivo tenha após a modificação.
 * @returns {Promise<boolean>} True se o conteúdo do arquivo corresponder ao esperado, false caso contrário.
 */
async function validateFallback(filePath, expectedContent) {
  try {
    // 1. Ler o conteúdo atual do arquivo
    const fileContentResult = await read_file(filePath);
    const currentContent = fileContentResult.content;

    // 2. Normalizar o conteúdo do arquivo e o conteúdo esperado
    const normalizedFileContent = normalizeContent(currentContent);
    const normalizedExpectedContent = normalizeContent(expectedContent);

    // 3. Comparar o conteúdo normalizado
    if (normalizedFileContent === normalizedExpectedContent) {
      console.log(`[FallbackValidation] Validação bem-sucedida para ${filePath}.`);
      return true;
    } else {
      console.warn(`[FallbackValidation] Validação falhou para ${filePath}. Conteúdo atual difere do esperado.`);
      // Em um cenário real, você poderia logar os diffs para depuração.
      return false;
    }
  } catch (error) {
    console.error(`[FallbackValidation] Erro ao validar o fallback para ${filePath}:`, error);
    return false;
  }
}

module.exports = {
  validateFallback,
};
