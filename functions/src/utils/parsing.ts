/**
 * Reads a string from one of several possible keys.
 * @param {Record<string, unknown>} data Source data.
 * @param {string[]} keys Candidate keys.
 * @param {string} fallback Fallback value.
 * @return {string} Normalized string value.
 */
export function readString(
  data: Record<string, unknown>,
  keys: string[],
  fallback = "",
): string {
  for (const key of keys) {
    const value = data[key];
    if (value === null || value === undefined) {
      continue;
    }

    const normalized = String(value).trim();
    if (normalized.length > 0) {
      return normalized;
    }
  }

  return fallback;
}

/**
 * Reads an integer from one of several possible keys.
 * @param {Record<string, unknown>} data Source data.
 * @param {string[]} keys Candidate keys.
 * @return {number} Parsed integer or zero.
 */
export function readInt(data: Record<string, unknown>, keys: string[]): number {
  for (const key of keys) {
    const parsed = readNullableInt(data[key]);
    if (parsed !== null) {
      return parsed;
    }
  }

  return 0;
}

/**
 * Reads a nullable integer from unknown input.
 * @param {unknown} value Raw value.
 * @return {number | null} Parsed integer or null.
 */
export function readNullableInt(value: unknown): number | null {
  if (typeof value === "number" && Number.isFinite(value)) {
    return Math.trunc(value);
  }

  if (typeof value === "string") {
    const parsed = Number.parseInt(value.trim(), 10);
    return Number.isNaN(parsed) ? null : parsed;
  }

  return null;
}

/**
 * Reads a boolean from one of several possible keys.
 * @param {Record<string, unknown>} data Source data.
 * @param {string[]} keys Candidate keys.
 * @return {boolean} Parsed boolean or false.
 */
export function readBool(
  data: Record<string, unknown>,
  keys: string[],
): boolean {
  for (const key of keys) {
    const value = data[key];

    if (typeof value === "boolean") {
      return value;
    }

    if (typeof value === "number") {
      return value === 1;
    }

    if (typeof value === "string") {
      const normalized = value.trim().toLowerCase();
      if (normalized === "true" || normalized === "1") {
        return true;
      }
      if (normalized === "false" || normalized === "0") {
        return false;
      }
    }
  }

  return false;
}

/**
 * Checks whether a value is a JSON-like object.
 * @param {unknown} value Raw value.
 * @return {value is Record<string, unknown>} True when object-like.
 */
export function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}
