import { FieldValue } from "firebase-admin/firestore";

import { ALERT_EVENT_FIELD, COLLECTION } from "../constants/firestore";
import { db } from "../firebase";
import { runBatchedWrites } from "../utils/firestore-batch";
import { alertRuleLabel } from "./rule-evaluators";
import { AlertTrigger } from "./types";

type AlertEventWrite = {
  ref: FirebaseFirestore.DocumentReference;
  data: FirebaseFirestore.DocumentData;
};

/**
 * Persists triggered alert events for user-visible alert history.
 * @param {AlertTrigger[]} triggers Triggered alert events.
 */
export async function persistAlertEvents(
  triggers: AlertTrigger[],
): Promise<void> {
  const eventWrites = triggers.map((trigger): AlertEventWrite => {
    const rule = trigger.rule;
    const ref = db
      .collection(COLLECTION.USERS)
      .doc(rule.userId)
      .collection(COLLECTION.ALERT_EVENTS)
      .doc();

    return {
      ref,
      data: {
        [ALERT_EVENT_FIELD.USER_ID]: rule.userId,
        [ALERT_EVENT_FIELD.RULE_ID]: rule.id,
        [ALERT_EVENT_FIELD.SERVER_ID]: rule.serverId,
        [ALERT_EVENT_FIELD.SERVER_NAME]: rule.serverName,
        [ALERT_EVENT_FIELD.MAP_NAME]: rule.mapName,
        [ALERT_EVENT_FIELD.RULE_TYPE]: rule.ruleType,
        [ALERT_EVENT_FIELD.PREVIOUS_PLAYERS]: trigger.previousPlayers,
        [ALERT_EVENT_FIELD.CURRENT_PLAYERS]: trigger.currentPlayers,
        [ALERT_EVENT_FIELD.TITLE]: alertRuleLabel(rule.ruleType),
        [ALERT_EVENT_FIELD.TRIGGERED_AT]: FieldValue.serverTimestamp(),
        [ALERT_EVENT_FIELD.CREATED_AT]: FieldValue.serverTimestamp(),
        [ALERT_EVENT_FIELD.READ_AT]: null,
      },
    };
  });

  await runBatchedWrites(eventWrites, (batch, eventWrite) => {
    batch.set(eventWrite.ref, eventWrite.data);
  });
}
