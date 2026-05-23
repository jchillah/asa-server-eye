import { readBool, readInt, readString } from "../utils/parsing";
import { ServerSnapshot } from "./types";

/**
 * Builds the same fallback id shape used by the Flutter client.
 * @param {string} name Server name.
 * @param {string} mapName Map name.
 * @param {string} ip Server IP.
 * @param {string} port Server port.
 * @return {string} Fallback stable server id.
 */
export function buildFallbackServerId(
  name: string,
  mapName: string,
  ip: string,
  port: string,
): string {
  const endpoint = [ip, port].filter((value) => value.length > 0).join(":");

  return [name.trim(), mapName.trim(), endpoint.trim()]
    .filter((value) => value.length > 0)
    .join("|");
}

/**
 * Parses a raw ASA server list item into the backend snapshot format.
 * @param {Record<string, unknown>} json Raw server JSON.
 * @return {ServerSnapshot} Normalized server snapshot.
 */
export function parseServerSnapshot(
  json: Record<string, unknown>,
): ServerSnapshot {
  const name = readString(json, ["Name"], "Unknown Server");
  const mapName = readString(json, ["MapName"], "Unknown Map");
  const sessionId = readString(json, [
    "SessionID",
    "SessionId",
    "SessionID64",
  ]);
  const ip = readString(json, ["IP", "Ip"]);
  const port = readString(json, ["Port"]);
  const fallbackId = buildFallbackServerId(name, mapName, ip, port);

  return {
    id: sessionId.length > 0 ? sessionId : fallbackId,
    name,
    mapName,
    players: readInt(json, ["NumPlayers"]),
    maxPlayers: readInt(json, ["MaxPlayers"]),
    official: readBool(json, ["IsOfficial", "Official"]),
    exists: true,
  };
}

/**
 * Parses a stored server snapshot document.
 * @param {FirebaseFirestore.DocumentData} data Firestore document data.
 * @return {ServerSnapshot | null} Parsed snapshot or null.
 */
export function parseStoredServerSnapshot(
  data: FirebaseFirestore.DocumentData,
): ServerSnapshot | null {
  const id = readString(data, ["id"]);
  if (!id) {
    return null;
  }

  return {
    id,
    name: readString(data, ["name"], "Unknown Server"),
    mapName: readString(data, ["mapName"], "Unknown Map"),
    players: readInt(data, ["players"]),
    maxPlayers: readInt(data, ["maxPlayers"]),
    official: readBool(data, ["official"]),
    exists: readBool(data, ["exists"]),
  };
}
