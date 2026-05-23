export const ALERT_RULE_TYPES = [
  "population_increased",
  "population_decreased",
  "crossed_above_threshold",
  "crossed_below_threshold",
  "server_online",
  "server_offline",
] as const;

export type AlertRuleType = typeof ALERT_RULE_TYPES[number];

const ALERT_RULE_TYPE_SET = new Set<string>(ALERT_RULE_TYPES);

/**
 * Checks whether a string is a supported alert rule type.
 * @param {string} value Raw rule type from Firestore.
 * @return {value is AlertRuleType} True for known alert rule types.
 */
export function isAlertRuleType(value: string): value is AlertRuleType {
  return value.length > 0 && ALERT_RULE_TYPE_SET.has(value);
}
