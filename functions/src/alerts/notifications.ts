import * as logger from "firebase-functions/logger";

import { isAlertAccessLevel } from "../constants/access-levels";
import { COLLECTION, USER_FIELD } from "../constants/firestore";
import {
  FCM_MULTICAST_CHUNK_CONCURRENCY,
  FCM_MULTICAST_LIMIT,
  NOTIFICATION_USER_CONCURRENCY,
} from "../config";
import { db, messaging } from "../firebase";
import { chunkArray } from "../utils/arrays";
import { removeInvalidTokens } from "../utils/firestore-batch";
import { readString } from "../utils/parsing";
import { buildAggregatedAlertBody } from "./rule-evaluators";
import { AlertTrigger, FcmTokenRecord } from "./types";

/**
 * Sends FCM notifications for all triggered rules.
 * @param {AlertTrigger[]} triggers Triggered alert events.
 */
export async function sendAlertNotifications(
  triggers: AlertTrigger[],
): Promise<void> {
  const tokenCache = new Map<string, FcmTokenRecord[]>();
  const accessCache = new Map<string, boolean>();
  const triggersByUser = groupTriggersByUser(triggers);
  const userIds = Array.from(triggersByUser.keys());

  for (
    const userIdChunk of chunkArray(userIds, NOTIFICATION_USER_CONCURRENCY)
  ) {
    await Promise.all(
      userIdChunk.map(async (userId) => {
        const userTriggers = triggersByUser.get(userId) ?? [];
        const hasAccess = await getCachedAlertAccess(userId, accessCache);

        if (!hasAccess) {
          logger.info("Skipping alerts for user without access.", {
            userId,
            triggerCount: userTriggers.length,
          });
          return;
        }

        const tokens = await getCachedUserTokens(userId, tokenCache);
        if (tokens.length === 0) {
          logger.info("Skipping alerts because user has no FCM tokens.", {
            userId,
            triggerCount: userTriggers.length,
          });
          return;
        }

        const aggregatedInvalidTokenRefs:
          FirebaseFirestore.DocumentReference[] = [];

        await sendAggregatedNotificationsToTokens(
          userTriggers,
          tokens,
          aggregatedInvalidTokenRefs,
        );

        if (aggregatedInvalidTokenRefs.length > 0) {
          await removeInvalidTokens(aggregatedInvalidTokenRefs);
        }
      }),
    );
  }
}

function groupTriggersByUser(
  triggers: AlertTrigger[],
): Map<string, AlertTrigger[]> {
  const grouped = new Map<string, AlertTrigger[]>();

  for (const trigger of triggers) {
    const userId = trigger.rule.userId;
    const userTriggers = grouped.get(userId) ?? [];
    userTriggers.push(trigger);
    grouped.set(userId, userTriggers);
  }

  return grouped;
}

/**
 * Sends one aggregated notification per user for all triggered rules.
 * @param {AlertTrigger[]} triggers Triggered alert events for one user.
 * @param {FcmTokenRecord[]} tokenRecords User token records.
 * @param {FirebaseFirestore.DocumentReference[]} aggregatedInvalidTokenRefs
 *   Shared invalid-token accumulator for this user.
 */
async function sendAggregatedNotificationsToTokens(
  triggers: AlertTrigger[],
  tokenRecords: FcmTokenRecord[],
  aggregatedInvalidTokenRefs: FirebaseFirestore.DocumentReference[],
): Promise<void> {
  if (triggers.length === 0) {
    return;
  }

  const primaryTrigger = triggers[0];
  const body = buildAggregatedAlertBody(triggers);
  const tokenChunks = chunkArray(tokenRecords, FCM_MULTICAST_LIMIT);

  for (const parallelChunks of chunkArray(
    tokenChunks,
    FCM_MULTICAST_CHUNK_CONCURRENCY,
  )) {
    await Promise.all(
      parallelChunks.map((chunk) => sendMulticastChunk(
        triggers,
        primaryTrigger,
        body,
        chunk,
        aggregatedInvalidTokenRefs,
      )),
    );
  }
}

/**
 * Sends one FCM multicast batch for a token chunk.
 * @param {AlertTrigger[]} triggers All triggers for the user.
 * @param {AlertTrigger} primaryTrigger First trigger used in payload metadata.
 * @param {string} body Notification body text.
 * @param {FcmTokenRecord[]} chunk Token records for this multicast.
 * @param {FirebaseFirestore.DocumentReference[]} aggregatedInvalidTokenRefs
 *   Shared invalid-token accumulator.
 */
async function sendMulticastChunk(
  triggers: AlertTrigger[],
  primaryTrigger: AlertTrigger,
  body: string,
  chunk: FcmTokenRecord[],
  aggregatedInvalidTokenRefs: FirebaseFirestore.DocumentReference[],
): Promise<void> {
  const response = await messaging.sendEachForMulticast({
    tokens: chunk.map((record) => record.token),
    notification: {
      title: "ASA Server Eye Alert",
      body,
    },
    data: {
      type: triggers.length > 1 ? "server_alert_batch" : "server_alert",
      triggerCount: String(triggers.length),
      ruleId: primaryTrigger.rule.id,
      serverId: primaryTrigger.rule.serverId,
      ruleType: primaryTrigger.rule.ruleType,
      previousPlayers: String(primaryTrigger.previousPlayers ?? ""),
      currentPlayers: String(primaryTrigger.currentPlayers ?? ""),
    },
    android: {
      priority: "high",
    },
    apns: {
      payload: {
        aps: {
          sound: "default",
        },
      },
    },
  });

  response.responses.forEach((sendResponse, index) => {
    if (sendResponse.success) {
      return;
    }

    const errorCode = sendResponse.error?.code ?? "";
    if (isInvalidFcmTokenError(errorCode)) {
      const tokenRecord = chunk[index];
      if (tokenRecord) {
        aggregatedInvalidTokenRefs.push(tokenRecord.ref);
      }
    }
  });

  logger.info("Alert notification send result.", {
    userId: primaryTrigger.rule.userId,
    triggerCount: triggers.length,
    successCount: response.successCount,
    failureCount: response.failureCount,
  });
}

/**
 * Fetches and caches FCM tokens for a user.
 * @param {string} userId User id.
 * @param {Map<string, FcmTokenRecord[]>} cache User token cache.
 * @return {Promise<FcmTokenRecord[]>} Token records.
 */
async function getCachedUserTokens(
  userId: string,
  cache: Map<string, FcmTokenRecord[]>,
): Promise<FcmTokenRecord[]> {
  const cached = cache.get(userId);
  if (cached) {
    return cached;
  }

  const snapshot = await db
    .collection(COLLECTION.USERS)
    .doc(userId)
    .collection(COLLECTION.FCM_TOKENS)
    .get();

  const tokens = snapshot.docs
    .map((doc) => {
      const token = readString(doc.data(), ["token"]);
      return token ? { token, ref: doc.ref } : null;
    })
    .filter((record): record is FcmTokenRecord => record !== null);

  cache.set(userId, tokens);
  return tokens;
}

async function getCachedAlertAccess(
  userId: string,
  cache: Map<string, boolean>,
): Promise<boolean> {
  const cached = cache.get(userId);
  if (cached !== undefined) {
    return cached;
  }

  const hasAccess = await hasAlertAccess(userId);
  cache.set(userId, hasAccess);
  return hasAccess;
}

/**
 * Checks if the user is still allowed to receive alert push notifications.
 * @param {string} userId User id.
 * @return {Promise<boolean>} Whether alert access is allowed.
 */
async function hasAlertAccess(userId: string): Promise<boolean> {
  const userSnapshot = await db.collection(COLLECTION.USERS).doc(userId).get();
  const accessLevel = readString(userSnapshot.data() ?? {}, [
    USER_FIELD.SIGHTINGS_ACCESS_LEVEL,
  ]);

  return isAlertAccessLevel(accessLevel);
}

/**
 * Checks whether an FCM error means that the token should be removed.
 * @param {string} code Firebase Admin error code.
 * @return {boolean} True when token is invalid.
 */
function isInvalidFcmTokenError(code: string): boolean {
  return code === "messaging/registration-token-not-registered" ||
    code === "messaging/invalid-registration-token";
}
