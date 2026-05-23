import { FieldValue, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";

import { ALERT_RULES_QUERY_LIMIT } from "../config";
import { db } from "../firebase";
import {
  readBool,
  readNullableInt,
  readString,
} from "../utils/parsing";
import { runBatchedWrites } from "../utils/firestore-batch";
import { isAlertRuleType } from "../constants/alert-rule-types";
import { isWithinCooldown, shouldTriggerRule } from "./rule-evaluators";
import { AlertRule, AlertTrigger, ServerSnapshot } from "./types";

/**
 * Loads enabled alert rules from all user alert rule subcollections.
 * @return {Promise<AlertRule[]>} Enabled alert rules.
 */
export async function fetchActiveAlertRules(): Promise<AlertRule[]> {
  const rules: AlertRule[] = [];
  let lastDocument: FirebaseFirestore.QueryDocumentSnapshot | undefined;
  let pageCount = 0;
  let hasMorePages = true;

  while (hasMorePages) {
    let query: FirebaseFirestore.Query = db
      .collectionGroup("alert_rules")
      .where("isEnabled", "==", true)
      .limit(ALERT_RULES_QUERY_LIMIT);

    if (lastDocument) {
      query = query.startAfter(lastDocument);
    }

    const snapshot = await query.get();
    pageCount += 1;

    for (const doc of snapshot.docs) {
      const rule = parseAlertRule(doc);
      if (rule) {
        rules.push(rule);
      }
    }

    hasMorePages = snapshot.size >= ALERT_RULES_QUERY_LIMIT;
    if (!hasMorePages) {
      continue;
    }

    lastDocument = snapshot.docs[snapshot.docs.length - 1];
    logger.info("Fetched alert rule page; loading next page.", {
      page: pageCount,
      pageSize: snapshot.size,
      loadedSoFar: rules.length,
    });
  }

  if (pageCount > 1) {
    logger.info("Finished paginated alert rule fetch.", {
      pages: pageCount,
      totalRules: rules.length,
    });
  }

  return rules;
}

/**
 * Parses an alert rule document.
 * @param {FirebaseFirestore.QueryDocumentSnapshot} doc Alert rule document.
 * @return {AlertRule | null} Parsed alert rule or null if invalid.
 */
export function parseAlertRule(
  doc: FirebaseFirestore.QueryDocumentSnapshot,
): AlertRule | null {
  const data = doc.data();
  const ruleType = readString(data, ["ruleType"]);

  if (!isAlertRuleType(ruleType)) {
    logger.warn("Skipping alert rule with invalid type.", {
      ruleId: doc.id,
      ruleType,
    });
    return null;
  }

  const userId = readString(data, ["userId"]);
  const serverId = readString(data, ["serverId"]);

  if (!userId || !serverId) {
    logger.warn("Skipping alert rule with missing userId/serverId.", {
      ruleId: doc.id,
    });
    return null;
  }

  return {
    id: doc.id,
    ref: doc.ref,
    userId,
    serverId,
    serverName: readString(data, ["serverName"], "Unknown Server"),
    mapName: readString(data, ["mapName"], "Unknown Map"),
    ruleType,
    isEnabled: readBool(data, ["isEnabled"]),
    threshold: readNullableInt(data["threshold"]),
    lastTriggeredAt: data["lastTriggeredAt"] instanceof Timestamp ?
      data["lastTriggeredAt"] :
      null,
  };
}

/**
 * Evaluates all active alert rules against previous and current server state.
 * @param {object} input Evaluation input.
 * @return {AlertTrigger[]} Triggered alert events.
 */
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

/**
 * Marks all triggered rules with a server-side lastTriggeredAt timestamp.
 * @param {AlertTrigger[]} triggers Triggered alert events.
 */
export async function markTriggeredRules(
  triggers: AlertTrigger[],
): Promise<void> {
  await runBatchedWrites(
    triggers.map((trigger) => trigger.rule.ref),
    (batch, ref) => {
      batch.update(ref, {
        lastTriggeredAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
    },
  );
}
