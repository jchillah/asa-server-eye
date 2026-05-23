import { createHash } from "crypto";

/**
 * Builds a deterministic SHA-256 id for arbitrary path-unsafe values.
 * @param {string} value Raw value.
 * @return {string} SHA-256 hex digest.
 */
export function hashValue(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}
