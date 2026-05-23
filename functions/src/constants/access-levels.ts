export const ACCESS_LEVEL = {
  FREE: "free",
  PREMIUM: "premium",
  ADMIN: "admin",
} as const;

export type AccessLevel = typeof ACCESS_LEVEL[keyof typeof ACCESS_LEVEL];

/**
 * Access levels that may receive server alert push notifications.
 */
export const ALERT_ACCESS_LEVELS: ReadonlySet<AccessLevel> = new Set([
  ACCESS_LEVEL.PREMIUM,
  ACCESS_LEVEL.ADMIN,
]);

/**
 * Checks whether a sightings access level may receive alert pushes.
 * @param {string} value Raw access level from Firestore.
 * @return {value is AccessLevel} True for premium or admin.
 */
export function isAlertAccessLevel(value: string): value is AccessLevel {
  return (ALERT_ACCESS_LEVELS as ReadonlySet<string>).has(value);
}
