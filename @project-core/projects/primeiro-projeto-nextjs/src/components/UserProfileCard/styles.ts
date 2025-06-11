import { twMerge } from "tailwind-merge";

/**
 * Função utilitária para mesclar classes Tailwind CSS
 * @param {string[]} classes - Array de classes CSS
 * @returns {string} Classes mescladas
 */
export const cn = (...classes: string[]) => {
  return twMerge(classes);
};
