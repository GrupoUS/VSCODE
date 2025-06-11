import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

/**
 * Função utilitária para mesclar classes Tailwind CSS
 * @param {ClassValue[]} inputs - Array de classes CSS
 * @returns {string} Classes mescladas
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
