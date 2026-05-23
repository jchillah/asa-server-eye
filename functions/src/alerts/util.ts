import { createHash } from "crypto";

export function hashValue(value: string): string {
  return createHash("sha256").update(value).digest("hex");
}

export function uniqueValues<T>(values: T[]): T[] {
  return Array.from(new Set(values));
}

export function chunkArray<T>(values: T[], size: number): T[][] {
  const chunks: T[][] = [];
  for (let index = 0; index < values.length; index += size) {
    chunks.push(values.slice(index, index + size));
  }
  return chunks;
}

export function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

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

export function readInt(data: Record<string, unknown>, keys: string[]): number {
  for (const key of keys) {
    const parsed = readNullableInt(data[key]);
    if (parsed !== null) {
      return parsed;
    }
  }

  return 0;
}

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
