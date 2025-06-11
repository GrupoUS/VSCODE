/**
 * Determina se replace_in_file ou write_to_file é a ferramenta apropriada
 * com base na natureza da modificação do arquivo.
 * @param {object} options Opções para a decisão.
 * @param {boolean} options.isNewFile Indica se a operação é para criar um novo arquivo.
 * @param {boolean} options.isFullOverwrite Indica se a operação é para sobrescrever completamente um arquivo existente.
 * @param {boolean} options.isLargeStructuralChange Indica se a operação envolve grandes mudanças estruturais.
 * @returns {string} 'write_to_file' ou 'replace_in_file'.
 */
function decideFileOperation(options) {
  const { isNewFile, isFullOverwrite, isLargeStructuralChange } = options;

  if (isNewFile || isFullOverwrite || isLargeStructuralChange) {
    console.log("Decisão: Usar write_to_file para a operação.");
    return 'write_to_file';
  } else {
    console.log("Decisão: Usar replace_in_file para a operação.");
    return 'replace_in_file';
  }
}

module.exports = {
  decideFileOperation,
};
