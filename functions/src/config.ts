import * as logger from "firebase-functions/logger";

export const DEFAULT_REGION = "europe-west3";
export const DEFAULT_PACKAGE_NAME = "com.jchillah.asaservereye";
export const OFFICIAL_SERVER_LIST_URL =
  "https://cdn2.arkdedicated.com/servers/asa/officialserverlist.json";
export const SERVER_ALERT_SNAPSHOTS_COLLECTION = "server_alert_snapshots";
export const DEFAULT_ALERT_COOLDOWN_MINUTES = 5;
export const FIRESTORE_WRITE_BATCH_LIMIT = 400;
export const FIRESTORE_GETALL_LIMIT = 400;
export const FCM_MULTICAST_LIMIT = 500;
export const ALERT_RULES_QUERY_LIMIT = 5000;
export const NOTIFICATION_USER_CONCURRENCY = 10;

export const REGION = process.env.FUNCTION_REGION || DEFAULT_REGION;
export const PACKAGE_NAME =
  process.env.PLAY_PACKAGE_NAME || DEFAULT_PACKAGE_NAME;

function readAlertCooldownMinutes(): number {
  const rawValue = process.env.ALERT_COOLDOWN_MINUTES;
  if (!rawValue) {
    return DEFAULT_ALERT_COOLDOWN_MINUTES;
  }

  const parsed = Number(rawValue);
  if (Number.isFinite(parsed) && parsed > 0) {
    return parsed;
  }

  logger.warn("Invalid ALERT_COOLDOWN_MINUTES. Falling back to default.", {
    rawValue,
    defaultMinutes: DEFAULT_ALERT_COOLDOWN_MINUTES,
  });

  return DEFAULT_ALERT_COOLDOWN_MINUTES;
}

export const ALERT_COOLDOWN_MINUTES = readAlertCooldownMinutes();
export const ALERT_COOLDOWN_MS = ALERT_COOLDOWN_MINUTES * 60 * 1000;
