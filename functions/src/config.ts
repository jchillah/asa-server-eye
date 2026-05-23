import * as logger from "firebase-functions/logger";

export const DEFAULT_REGION = "europe-west3";
export const DEFAULT_PACKAGE_NAME = "com.jchillah.asaservereye";
export const DEFAULT_OFFICIAL_SERVER_LIST_URL =
  "https://cdn2.arkdedicated.com/servers/asa/officialserverlist.json";
export const OFFICIAL_SERVER_LIST_URL = readOfficialServerListUrl();
export const SERVER_ALERT_SNAPSHOTS_COLLECTION = "server_alert_snapshots";
export const DEFAULT_ALERT_COOLDOWN_MINUTES = 5;
export const DEFAULT_ALERT_SCHEDULE = "every 5 minutes";
export const DEFAULT_ALERT_SCHEDULE_TIMEZONE = "Europe/Berlin";
export const DEFAULT_SERVER_LIST_FETCH_TIMEOUT_MS = 10_000;
export const DEFAULT_FCM_MULTICAST_CHUNK_CONCURRENCY = 3;
export const FIRESTORE_WRITE_BATCH_LIMIT = 400;
/** Firestore getAll() supports at most 300 document refs per call. */
export const FIRESTORE_GETALL_DOCUMENT_LIMIT = 300;
export const FIRESTORE_GETALL_LIMIT = 400;
export const FIRESTORE_GETALL_CHUNK_SIZE = Math.min(
  FIRESTORE_GETALL_LIMIT,
  FIRESTORE_GETALL_DOCUMENT_LIMIT,
);
export const FCM_MULTICAST_LIMIT = 500;
export const ALERT_RULES_QUERY_LIMIT = 5000;
export const NOTIFICATION_USER_CONCURRENCY = 10;

export const REGION = process.env.FUNCTION_REGION || DEFAULT_REGION;
export const PACKAGE_NAME =
  process.env.PLAY_PACKAGE_NAME || DEFAULT_PACKAGE_NAME;
export const ALERT_SCHEDULE = readAlertSchedule();
export const ALERT_SCHEDULE_TIMEZONE = readAlertScheduleTimeZone();
export const SERVER_LIST_FETCH_TIMEOUT_MS = readServerListFetchTimeoutMs();
export const FCM_MULTICAST_CHUNK_CONCURRENCY =
  readFcmMulticastChunkConcurrency();
export const ALERT_COOLDOWN_MINUTES = readAlertCooldownMinutes();
export const ALERT_COOLDOWN_MS = ALERT_COOLDOWN_MINUTES * 60 * 1000;

function readOfficialServerListUrl(): string {
  const fromEnv = process.env.ASA_SERVER_LIST_URL?.trim() ||
    process.env.OFFICIAL_SERVER_LIST_URL?.trim();

  if (fromEnv && fromEnv.length > 0) {
    return fromEnv;
  }

  return DEFAULT_OFFICIAL_SERVER_LIST_URL;
}

function readAlertSchedule(): string {
  const fromEnv = process.env.ALERT_SCHEDULE?.trim();
  return fromEnv && fromEnv.length > 0 ? fromEnv : DEFAULT_ALERT_SCHEDULE;
}

function readAlertScheduleTimeZone(): string {
  const fromEnv = process.env.ALERT_SCHEDULE_TIMEZONE?.trim();
  return fromEnv && fromEnv.length > 0 ?
    fromEnv :
    DEFAULT_ALERT_SCHEDULE_TIMEZONE;
}

function readServerListFetchTimeoutMs(): number {
  const rawValue = process.env.SERVER_LIST_FETCH_TIMEOUT_MS?.trim();
  if (!rawValue) {
    return DEFAULT_SERVER_LIST_FETCH_TIMEOUT_MS;
  }

  const parsed = Number(rawValue);
  if (Number.isFinite(parsed) && parsed > 0) {
    return parsed;
  }

  logger.warn(
    "Invalid SERVER_LIST_FETCH_TIMEOUT_MS. Falling back to default.",
    {
      rawValue,
      defaultMs: DEFAULT_SERVER_LIST_FETCH_TIMEOUT_MS,
    },
  );

  return DEFAULT_SERVER_LIST_FETCH_TIMEOUT_MS;
}

function readFcmMulticastChunkConcurrency(): number {
  const rawValue = process.env.FCM_MULTICAST_CHUNK_CONCURRENCY?.trim();
  if (!rawValue) {
    return DEFAULT_FCM_MULTICAST_CHUNK_CONCURRENCY;
  }

  const parsed = Number.parseInt(rawValue, 10);
  if (Number.isFinite(parsed) && parsed > 0) {
    return parsed;
  }

  logger.warn(
    "Invalid FCM_MULTICAST_CHUNK_CONCURRENCY. Falling back to default.",
    {
      rawValue,
      defaultConcurrency: DEFAULT_FCM_MULTICAST_CHUNK_CONCURRENCY,
    },
  );

  return DEFAULT_FCM_MULTICAST_CHUNK_CONCURRENCY;
}

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
