// src/utils/text_normalization.js

/**
 * Normaliza o conteúdo de texto, substituindo quebras de linha CRLF por LF
 * e removendo espaços em branco no final de cada linha.
 * @param {string} content O conteúdo de texto a ser normalizado.
 * @returns {string} O conteúdo de texto normalizado.
 */
function normalizeContent(content) {
  if (typeof content !== 'string') {
    throw new Error('O conteúdo deve ser uma string.');
  }
  // Substitui CRLF por LF
  let normalized = content.replace(/\r\n/g, '\n');
  // Remove espaços em branco no final de cada linha
  normalized = normalized.split('\n').map(line => line.trimEnd()).join('\n');
  return normalized;
}

module.exports = {
  normalizeContent,
};
