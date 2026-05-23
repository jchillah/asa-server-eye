import { ALERT_COOLDOWN_MS } from "./config";
import { AlertRule, AlertTrigger, ServerSnapshot } from "./types";

export function evaluateAlertTriggers(input: {
  rules: AlertRule[];
  currentServers: Map<string, ServerSnapshot>;
  previousSnapshots: Map<string, ServerSnapshot>;
  now: Date;
}): AlertTrigger[] {
  const triggers: AlertTrigger[] = [];

  for (const rule of input.rules) {
    if (isWithinCooldown(rule, input.now)) {
      continue;
    }

    const previous = input.previousSnapshots.get(rule.serverId) ?? null;
    const current = input.currentServers.get(rule.serverId) ?? null;

    if (!shouldTriggerRule(rule, previous, current)) {
      continue;
    }

    triggers.push({
      rule,
      previousPlayers: previous?.players ?? null,
      currentPlayers: current?.players ?? null,
    });
  }

  return triggers;
}

export function buildAlertBody(trigger: AlertTrigger): string {
  const change = trigger.previousPlayers === null ||
    trigger.currentPlayers === null ?
    "" :
    ` (${trigger.previousPlayers} -> ${trigger.currentPlayers})`;

  return `${alertRuleLabel(trigger.rule.ruleType)}: ` +
    `${trigger.rule.serverName} - ${trigger.rule.mapName}${change}`;
}

function isWithinCooldown(rule: AlertRule, now: Date): boolean {
  const lastTriggeredAt = rule.lastTriggeredAt;
  if (!lastTriggeredAt) {
    return false;
  }

  return now.getTime() - lastTriggeredAt.toDate().getTime() <
    ALERT_COOLDOWN_MS;
}

function shouldTriggerRule(
  rule: AlertRule,
  previous: ServerSnapshot | null,
  current: ServerSnapshot | null,
): boolean {
  switch (rule.ruleType) {
  case "population_increased":
    return previous?.exists === true &&
      current?.exists === true &&
      current.players > previous.players;
  case "population_decreased":
    return previous?.exists === true &&
      current?.exists === true &&
      current.players < previous.players;
  case "crossed_above_threshold":
    return rule.threshold !== null &&
      previous?.exists === true &&
      current?.exists === true &&
      previous.players <= rule.threshold &&
      current.players > rule.threshold;
  case "crossed_below_threshold":
    return rule.threshold !== null &&
      previous?.exists === true &&
      current?.exists === true &&
      previous.players >= rule.threshold &&
      current.players < rule.threshold;
  case "server_online":
    return previous?.exists === false && current?.exists === true;
  case "server_offline":
    return previous?.exists === true && current === null;
  }
}

function alertRuleLabel(ruleType: AlertRule["ruleType"]): string {
  switch (ruleType) {
  case "population_increased":
    return "Population increased";
  case "population_decreased":
    return "Population decreased";
  case "crossed_above_threshold":
    return "Population crossed above threshold";
  case "crossed_below_threshold":
    return "Population crossed below threshold";
  case "server_online":
    return "Server online";
  case "server_offline":
    return "Server offline";
  }
}
