import * as logger from "firebase-functions/logger";

import {
  OFFICIAL_SERVER_LIST_URL,
  SERVER_LIST_FETCH_TIMEOUT_MS,
} from "../config";
import { isRecord } from "../utils/parsing";
import { parseServerSnapshot } from "./server-parsing";
import { ServerSnapshot } from "./types";

/**
 * Downloads and normalizes the official ARK ASA server list.
 * @return {Promise<Map<string, ServerSnapshot> | null>} Servers keyed by stable id.
 */
export async function fetchOfficialServerList(): Promise<Map<
  string,
  ServerSnapshot
> | null> {
  const controller = new AbortController();
  const timeoutId = setTimeout(
    () => controller.abort(),
    SERVER_LIST_FETCH_TIMEOUT_MS,
  );

  try {
    const response = await fetch(OFFICIAL_SERVER_LIST_URL, {
      signal: controller.signal,
    });

    if (!response.ok) {
      logger.warn("Server list request returned a non-success status.", {
        status: response.status,
      });
      return null;
    }

    const rawData = await response.json() as unknown;
    if (!Array.isArray(rawData)) {
      logger.warn("Server list response shape was unexpected.", {
        payloadType: typeof rawData,
      });
      return null;
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
  } catch (error) {
    logger.error("Server list fetch failed.", { error });
    return null;
  } finally {
    clearTimeout(timeoutId);
  }
}
