/**
 * Returns unique values while preserving insertion order.
 * @param {T[]} values Input values.
 * @return {T[]} Unique values.
 */
export function uniqueValues<T>(values: T[]): T[] {
  return Array.from(new Set(values));
}

/**
 * Splits an array into fixed-size chunks.
 * @param {T[]} values Input values.
 * @param {number} size Max chunk size.
 * @return {T[][]} Chunked values.
 */
export function chunkArray<T>(values: T[], size: number): T[][] {
  if (!Number.isFinite(size) || size <= 0) {
    throw new Error("chunkArray size must be a positive finite number.");
  }

  const chunks: T[][] = [];
  for (let index = 0; index < values.length; index += size) {
    chunks.push(values.slice(index, index + size));
  }
  return chunks;
}
