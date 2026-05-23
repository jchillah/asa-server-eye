import { ALERT_COOLDOWN_MS } from "../config";
import {
  AlertRule,
  AlertRuleType,
  AlertTrigger,
  RuleEvaluator,
  ServerSnapshot,
} from "./types";

export const RULE_EVALUATORS: Record<AlertRuleType, RuleEvaluator> = {
  population_increased: (_rule, previous, current) =>
    previous?.exists === true &&
    current?.exists === true &&
    current.players > previous.players,
  population_decreased: (_rule, previous, current) =>
    previous?.exists === true &&
    current?.exists === true &&
    current.players < previous.players,
  crossed_above_threshold: (rule, previous, current) =>
    rule.threshold !== null &&
    previous?.exists === true &&
    current?.exists === true &&
    previous.players <= rule.threshold &&
    current.players > rule.threshold,
  crossed_below_threshold: (rule, previous, current) =>
    rule.threshold !== null &&
    previous?.exists === true &&
    current?.exists === true &&
    previous.players >= rule.threshold &&
    current.players < rule.threshold,
  server_online: (_rule, previous, current) => {
    const wasOffline = previous == null || previous.exists === false;
    return wasOffline && current?.exists === true;
  },
  server_offline: (_rule, previous, current) =>
    previous?.exists === true && current === null,
};

export const RULE_LABELS: Record<AlertRuleType, string> = {
  population_increased: "Population increased",
  population_decreased: "Population decreased",
  crossed_above_threshold: "Population crossed above threshold",
  crossed_below_threshold: "Population crossed below threshold",
  server_online: "Server online",
  server_offline: "Server offline",
};

/**
 * Checks whether the rule type is supported by the backend evaluator.
 * @param {string} value Raw rule type.
 * @return {value is AlertRuleType} True for known alert rule types.
 */
export function isAlertRuleType(value: string): value is AlertRuleType {
  return (
    typeof value === "string" &&
    value.length > 0 &&
    Object.prototype.hasOwnProperty.call(RULE_EVALUATORS, value)
  );
}

/**
 * Decides whether a rule should trigger for the current refresh.
 * @param {AlertRule} rule Alert rule.
 * @param {ServerSnapshot | null} previous Previous server state.
 * @param {ServerSnapshot | null} current Current server state.
 * @return {boolean} True when the rule should trigger.
 */
export function shouldTriggerRule(
  rule: AlertRule,
  previous: ServerSnapshot | null,
  current: ServerSnapshot | null,
): boolean {
  return RULE_EVALUATORS[rule.ruleType](rule, previous, current);
}

/**
 * Checks whether a rule was triggered within the cooldown window.
 * @param {AlertRule} rule Alert rule.
 * @param {Date} now Current time.
 * @return {boolean} True if the rule is still in cooldown.
 */
export function isWithinCooldown(rule: AlertRule, now: Date): boolean {
  const lastTriggeredAt = rule.lastTriggeredAt;
  if (!lastTriggeredAt) {
    return false;
  }

  return now.getTime() - lastTriggeredAt.toDate().getTime() < ALERT_COOLDOWN_MS;
}

/**
 * Maps alert rule types to compact notification labels.
 * @param {AlertRuleType} ruleType Alert rule type.
 * @return {string} Label for notifications.
 */
export function alertRuleLabel(ruleType: AlertRuleType): string {
  return RULE_LABELS[ruleType];
}

/**
 * Builds the user-visible FCM body text.
 * @param {AlertTrigger} trigger Triggered alert event.
 * @return {string} Notification body text.
 */
export function buildAlertBody(trigger: AlertTrigger): string {
  let change = "";

  if (trigger.previousPlayers != null && trigger.currentPlayers != null) {
    change = ` (${trigger.previousPlayers} → ${trigger.currentPlayers})`;
  } else if (trigger.currentPlayers != null) {
    change = ` (${trigger.currentPlayers})`;
  }

  return `${alertRuleLabel(trigger.rule.ruleType)}: ` +
    `${trigger.rule.serverName} • ${trigger.rule.mapName}${change}`;
}

/**
 * Builds a notification body for one or more triggers for the same user.
 * @param {AlertTrigger[]} triggers Triggered alert events.
 * @return {string} Notification body text.
 */
export function buildAggregatedAlertBody(triggers: AlertTrigger[]): string {
  if (triggers.length === 1) {
    return buildAlertBody(triggers[0]);
  }

  const lines = triggers.slice(0, 3).map((trigger) => {
    const label = alertRuleLabel(trigger.rule.ruleType);
    return `${trigger.rule.serverName}: ${label}`;
  });
  const remaining = triggers.length - lines.length;
  const suffix = remaining > 0 ? ` (+${remaining} more)` : "";

  return `${triggers.length} alerts: ${lines.join("; ")}${suffix}`;
}
