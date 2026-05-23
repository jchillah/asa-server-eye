import * as logger from "firebase-functions/logger";

const DEFAULT_ALERT_COOLDOWN_MINUTES = 5;

export const REGION = process.env.FUNCTION_REGION || "europe-west3";
export const FIRESTORE_BATCH_LIMIT = 400;
export const FCM_MULTICAST_LIMIT = 500;
export const ALERT_COOLDOWN_MINUTES = readAlertCooldownMinutes();
export const ALERT_COOLDOWN_MS = ALERT_COOLDOWN_MINUTES * 60 * 1000;

function readAlertCooldownMinutes(): number {
  const rawValue = process.env.ALERT_COOLDOWN_MINUTES;
  if (!rawValue) {
    return DEFAULT_ALERT_COOLDOWN_MINUTES;
  }

  const parsed = Number(rawValue);
  if (Number.isFinite(parsed) && parsed > 0) {
    return parsed;
  }

  logger.warn("Invalid alert cooldown config. Using default value.", {
    rawValue,
    defaultMinutes: DEFAULT_ALERT_COOLDOWN_MINUTES,
  });

  return DEFAULT_ALERT_COOLDOWN_MINUTES;
}
