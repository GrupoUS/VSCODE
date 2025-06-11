const { replace_in_file } = require('./tool_access'); // Assumindo que você tem um módulo para acessar as ferramentas
const { validateSearchBlock } = require('./validate_replace');
const { fallbackCore } = require('./fallback_core');

/**
 * Tenta aplicar replace_in_file com um bloco SEARCH completo.
 * Se falhar, tenta com um bloco SEARCH mínimo.
 * Se ambos falharem, executa o fallback para write_to_file.
 * @param {string} filePath O caminho do arquivo a ser modificado.
 * @param {string} fullSearchBlock O bloco SEARCH completo.
 * @param {string} minimalSearchBlock O bloco SEARCH mínimo (1-3 linhas).
 * @param {string} replaceBlock O conteúdo para substituir.
 * @param {string} expectedFinalContent O conteúdo final esperado do arquivo após a modificação.
 * @returns {Promise<boolean>} True se a operação for bem-sucedida, false caso contrário.
 */
async function smartReplaceInFile(filePath, fullSearchBlock, minimalSearchBlock, replaceBlock, expectedFinalContent) {
  let success = false;
  let attempts = 0;

  // Extrair o diff completo para o fallback
  const fullDiff = `------- SEARCH\n${fullSearchBlock}\n=======\n${replaceBlock}\n+++++++ REPLACE`;
  const minimalDiff = `------- SEARCH\n${minimalSearchBlock}\n=======\n${replaceBlock}\n+++++++ REPLACE`;

  while (attempts < 2 && !success) {
    attempts++;
    let currentSearchBlock = (attempts === 1) ? fullSearchBlock : minimalSearchBlock;
    let currentDiff = (attempts === 1) ? fullDiff : minimalDiff;

    console.log(`Tentativa ${attempts}: Usando bloco SEARCH ${attempts === 1 ? 'completo' : 'mínimo'}.`);

    try {
      // 1. Validar se o bloco SEARCH existe no arquivo
      const isValid = await validateSearchBlock(filePath, currentSearchBlock);

      if (isValid) {
        console.log(`Bloco SEARCH encontrado. Tentando replace_in_file para ${filePath}.`);
        // Em um ambiente real, você chamaria a ferramenta replace_in_file aqui.
        // Como não podemos simular o sucesso/falha da ferramenta diretamente,
        // vamos assumir que ela sempre falha para testar o fallback.
        // await replace_in_file(filePath, currentDiff);
        // success = true; // Se a chamada real fosse bem-sucedida
        console.warn(`Simulando falha de replace_in_file para testar fallback.`);
        success = false; // Força a falha para testar o fallback
      } else {
        console.warn(`Bloco SEARCH não encontrado para a tentativa ${attempts}.`);
        success = false;
      }
    } catch (error) {
      console.error(`Erro na tentativa ${attempts} de replace_in_file para ${filePath}:`, error);
      success = false;
    }

    if (success) {
      console.log(`replace_in_file bem-sucedido na tentativa ${attempts}.`);
      return true;
    }
  }

  // Se as tentativas de replace_in_file falharem, execute o fallback
  console.warn(`Todas as tentativas de replace_in_file falharam. Executando fallback para write_to_file para ${filePath}.`);
  try {
    await fallbackCore(filePath, fullDiff); // Usar o diff completo para o fallback
    // Após o fallback, validar se o conteúdo final é o esperado
    const { validateFallback } = require('./fallback_validation'); // Importar aqui para evitar dependência circular
    success = await validateFallback(filePath, expectedFinalContent);
    if (success) {
      console.log(`Fallback para write_to_file bem-sucedido e validado para ${filePath}.`);
    } else {
      console.error(`Fallback para write_to_file falhou na validação para ${filePath}.`);
    }
  } catch (error) {
    console.error(`Erro durante o fallback para write_to_file para ${filePath}:`, error);
    success = false;
  }

  return success;
}

module.exports = {
  smartReplaceInFile,
};
