import {
  OFFICIAL_SERVER_LIST_URL,
  SERVER_LIST_FETCH_TIMEOUT_MS,
} from "../config";
import { isRecord } from "../utils/parsing";
import { parseServerSnapshot } from "./server-parsing";
import { ServerSnapshot } from "./types";

/**
 * Downloads and normalizes the official ARK ASA server list.
 * @return {Promise<Map<string, ServerSnapshot>>} Servers keyed by stable id.
 */
export async function fetchOfficialServerList(): Promise<Map<
  string,
  ServerSnapshot
>> {
  const controller = new AbortController();
  const timeoutId = setTimeout(
    () => controller.abort(),
    SERVER_LIST_FETCH_TIMEOUT_MS,
  );

  let response: Response;
  try {
    response = await fetch(OFFICIAL_SERVER_LIST_URL, {
      signal: controller.signal,
    });
  } catch (error) {
    if (error instanceof Error && error.name === "AbortError") {
      throw new Error("ASA server list request timed out.");
    }
    throw error;
  } finally {
    clearTimeout(timeoutId);
  }

  if (!response.ok) {
    throw new Error(`ASA server list request failed: ${response.status}`);
  }

  const rawData = await response.json() as unknown;
  if (!Array.isArray(rawData)) {
    throw new Error("ASA server list response was not an array.");
  }

  const servers = new Map<string, ServerSnapshot>();
  for (const item of rawData) {
    if (!isRecord(item)) {
      continue;
    }

    const server = parseServerSnapshot(item);
    if (server.id.length === 0) {
      continue;
    }

    servers.set(server.id, server);
  }

  return servers;
}
