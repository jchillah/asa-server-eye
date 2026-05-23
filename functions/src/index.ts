import { createHash } from "crypto";

import { initializeApp } from "firebase-admin/app";
import {
  FieldValue,
  Timestamp,
  getFirestore,
} from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import * as logger from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { google } from "googleapis";

initializeApp();

const db = getFirestore();

const DEFAULT_REGION = "europe-west3";
const DEFAULT_PACKAGE_NAME = "com.jchillah.asaservereye";
const OFFICIAL_SERVER_LIST_URL =
  "https://cdn2.arkdedicated.com/servers/asa/officialserverlist.json";
const SERVER_ALERT_SNAPSHOTS_COLLECTION = "server_alert_snapshots";
const DEFAULT_ALERT_COOLDOWN_MINUTES = 5;
const FIRESTORE_WRITE_BATCH_LIMIT = 400;
const FIRESTORE_GETALL_LIMIT = 400;
const FCM_MULTICAST_LIMIT = 500;
const ALERT_RULES_QUERY_LIMIT = 5000;
const NOTIFICATION_USER_CONCURRENCY = 10;

const REGION = process.env.FUNCTION_REGION || DEFAULT_REGION;
const PACKAGE_NAME = process.env.PLAY_PACKAGE_NAME || DEFAULT_PACKAGE_NAME;
const ALERT_COOLDOWN_MINUTES = readAlertCooldownMinutes();
const ALERT_COOLDOWN_MS = ALERT_COOLDOWN_MINUTES * 60 * 1000;

type VerificationRequestData = {
  userId: string;
  platform: "android" | "ios";
  productId: string;
  purchaseId: string;
  purchaseToken: string;
  status: string;
  createdAt?: FirebaseFirestore.Timestamp;
  updatedAt?: FirebaseFirestore.Timestamp;
};

type VerificationResult = {
  purchaseStatus: "active" | "expired" | "invalid" | "pending";
  expiresAt: Date | null;
  reason?: string | null;
  storePayload?: Record<string, unknown> | null;
};

type GoogleApiErrorLike = {
  code?: number;
  message?: string;
  response?: {
    status?: number;
    data?: unknown;
  };
};

type AlertRuleType =
  | "population_increased"
  | "population_decreased"
  | "crossed_above_threshold"
  | "crossed_below_threshold"
  | "server_online"
  | "server_offline";

type ServerSnapshot = {
  id: string;
  name: string;
  mapName: string;
  players: number;
  maxPlayers: number;
  official: boolean;
  exists: boolean;
};

type AlertRule = {
  id: string;
  ref: FirebaseFirestore.DocumentReference;
  userId: string;
  serverId: string;
  serverName: string;
  mapName: string;
  ruleType: AlertRuleType;
  isEnabled: boolean;
  threshold: number | null;
  lastTriggeredAt: Timestamp | null;
};

type AlertTrigger = {
  rule: AlertRule;
  previousPlayers: number | null;
  currentPlayers: number | null;
};

type FcmTokenRecord = {
  token: string;
  ref: FirebaseFirestore.DocumentReference;
};

export const evaluateAlertRulesAndSendNotifications = onSchedule(
  {
    schedule: "every 5 minutes",
    region: REGION,
    timeZone: "Europe/Berlin",
    maxInstances: 1,
  },
  async () => {
    const now = new Date();
    const currentServers = await fetchOfficialServerList();
    const activeRules = await fetchActiveAlertRules();

    if (activeRules.length === 0) {
      logger.info("No active alert rules found.");
      return;
    }

    const serverIds = uniqueValues(activeRules.map((rule) => rule.serverId));
    const previousSnapshots = await fetchPreviousServerSnapshots(serverIds);
    const triggers = evaluateAlertTriggers({
      rules: activeRules,
      currentServers,
      previousSnapshots,
      now,
    });

    await persistServerSnapshots(serverIds, currentServers);

    if (triggers.length === 0) {
      logger.info("No alert rules triggered.", {
        activeRules: activeRules.length,
        trackedServers: serverIds.length,
      });
      return;
    }

    await sendAlertNotifications(triggers);
    await markTriggeredRules(triggers);

    logger.info("Alert rule evaluation finished.", {
      activeRules: activeRules.length,
      triggeredRules: triggers.length,
      trackedServers: serverIds.length,
    });
  },
);

export const processSubscriptionVerificationRequest = onDocumentCreated(
  {
    document: "subscription_verification_requests/{requestId}",
    region: REGION,
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.warn("No snapshot data available for verification request.");
      return;
    }

    const requestId = event.params.requestId;
    const data = snapshot.data() as VerificationRequestData | undefined;

    if (!data) {
      logger.error("Verification request has no data.", { requestId });
      return;
    }

    if (data.status !== "pending") {
      logger.info("Skipping non-pending verification request.", {
        requestId,
        status: data.status,
      });
      return;
    }

    const requestRef = db
      .collection("subscription_verification_requests")
      .doc(requestId);

    const userRef = db.collection("users").doc(data.userId);
    const entitlementRef = db.collection("user_subscriptions").doc(data.userId);

    await requestRef.update({
      status: "processing",
      updatedAt: FieldValue.serverTimestamp(),
    });

    try {
      const verification = await verifyPurchaseWithStore(data);

      const userSnap = await userRef.get();
      const userData = userSnap.data();

      let currentAccessLevel = "free";
      if (typeof userData?.["sightingsAccessLevel"] === "string") {
        currentAccessLevel = userData["sightingsAccessLevel"];
      }

      let nextAccessLevel = "free";
      if (currentAccessLevel === "admin") {
        nextAccessLevel = "admin";
      } else if (verification.purchaseStatus === "active") {
        nextAccessLevel = "premium";
      }

      await entitlementRef.set(
        {
          userId: data.userId,
          platform: data.platform,
          productId: data.productId,
          purchaseStatus: verification.purchaseStatus,
          expiresAt: verification.expiresAt ?
            Timestamp.fromDate(verification.expiresAt) :
            null,
          lastRequestId: requestId,
          purchaseId: data.purchaseId,
          latestPurchaseToken: data.purchaseToken,
          verificationReason: verification.reason ?? null,
          storePayload: verification.storePayload ?? null,
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      await userRef.set(
        {
          sightingsAccessLevel: nextAccessLevel,
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      await requestRef.update({
        status: verification.purchaseStatus,
        processedAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
        resultReason: verification.reason ?? null,
      });

      logger.info("Subscription verification processed.", {
        requestId,
        userId: data.userId,
        purchaseStatus: verification.purchaseStatus,
        nextAccessLevel,
      });
    } catch (error) {
      logger.error("Subscription verification failed.", {
        requestId,
        userId: data.userId,
        error,
      });

      await requestRef.update({
        status: "error",
        updatedAt: FieldValue.serverTimestamp(),
        errorMessage: error instanceof Error ? error.message : String(error),
      });

      throw error;
    }
  },
);

/**
 * Downloads and normalizes the official ARK ASA server list.
 * @return {Promise<Map<string, ServerSnapshot>>} Servers keyed by stable id.
 */
async function fetchOfficialServerList(): Promise<Map<string, ServerSnapshot>> {
  const response = await fetch(OFFICIAL_SERVER_LIST_URL);

  if (!response.ok) {
    throw new Error(`ASA server list request failed: ${response.status}`);
  }

  const rawData = await response.json() as unknown;
  if (!Array.isArray(rawData)) {
    throw new Error("ASA server list response was not an array.");
  }

  const servers = new Map<string, ServerSnapshot>();
  for (const item of rawData) {
    if (!isRecord(item)) {
      continue;
    }

    const server = parseServerSnapshot(item);
    if (server.id.length === 0) {
      continue;
    }

    servers.set(server.id, server);
  }

  return servers;
}

/**
 * Loads enabled alert rules from all user alert rule subcollections.
 * @return {Promise<AlertRule[]>} Enabled alert rules.
 */
async function fetchActiveAlertRules(): Promise<AlertRule[]> {
  const snapshot = await db
    .collectionGroup("alert_rules")
    .where("isEnabled", "==", true)
    .limit(ALERT_RULES_QUERY_LIMIT)
    .get();

  if (snapshot.size >= ALERT_RULES_QUERY_LIMIT) {
    logger.warn("Alert rule query reached the configured limit.", {
      limit: ALERT_RULES_QUERY_LIMIT,
    });
  }

  const rules: AlertRule[] = [];
  for (const doc of snapshot.docs) {
    const rule = parseAlertRule(doc);
    if (rule) {
      rules.push(rule);
    }
  }

  return rules;
}

/**
 * Loads the previous known server snapshots for all tracked server ids.
 * @param {string[]} serverIds Stable server ids.
 * @return {Promise<Map<string, ServerSnapshot>>} Previous snapshots.
 */
async function fetchPreviousServerSnapshots(
  serverIds: string[],
): Promise<Map<string, ServerSnapshot>> {
  const result = new Map<string, ServerSnapshot>();

  for (const chunk of chunkArray(serverIds, FIRESTORE_GETALL_LIMIT)) {
    const refs = chunk.map((serverId) => serverSnapshotRef(serverId));
    const snapshots = await db.getAll(...refs);

    for (const snapshot of snapshots) {
      const data = snapshot.data();
      if (!data) {
        continue;
      }

      const server = parseStoredServerSnapshot(data);
      if (server) {
        result.set(server.id, server);
      }
    }
  }

  return result;
}

/**
 * Evaluates all active alert rules against previous and current server state.
 * @param {object} input Evaluation input.
 * @return {AlertTrigger[]} Triggered alert events.
 */
function evaluateAlertTriggers(input: {
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
 * Persists current snapshots for all servers that have alert rules.
 * @param {string[]} serverIds Stable server ids.
 * @param {Map<string, ServerSnapshot>} currentServers Current server state.
 */
async function persistServerSnapshots(
  serverIds: string[],
  currentServers: Map<string, ServerSnapshot>,
): Promise<void> {
  let batch = db.batch();
  let operationCount = 0;

  const commitIfNeeded = async () => {
    if (operationCount >= FIRESTORE_WRITE_BATCH_LIMIT) {
      await batch.commit();
      batch = db.batch();
      operationCount = 0;
    }
  };

  for (const serverId of serverIds) {
    const server = currentServers.get(serverId);
    const ref = serverSnapshotRef(serverId);

    if (server) {
      batch.set(ref, {
        ...server,
        updatedAt: FieldValue.serverTimestamp(),
      });
    } else {
      batch.set(
        ref,
        {
          id: serverId,
          exists: false,
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );
    }

    operationCount += 1;
    await commitIfNeeded();
  }

  if (operationCount > 0) {
    await batch.commit();
  }
}

/**
 * Sends FCM notifications for all triggered rules.
 * @param {AlertTrigger[]} triggers Triggered alert events.
 */
async function sendAlertNotifications(triggers: AlertTrigger[]): Promise<void> {
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

        for (const trigger of userTriggers) {
          await sendNotificationToTokens(trigger, tokens);
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
 * Marks all triggered rules with a server-side lastTriggeredAt timestamp.
 * @param {AlertTrigger[]} triggers Triggered alert events.
 */
async function markTriggeredRules(triggers: AlertTrigger[]): Promise<void> {
  let batch = db.batch();
  let operationCount = 0;

  const commitIfNeeded = async () => {
    if (operationCount >= FIRESTORE_WRITE_BATCH_LIMIT) {
      await batch.commit();
      batch = db.batch();
      operationCount = 0;
    }
  };

  for (const trigger of triggers) {
    batch.update(trigger.rule.ref, {
      lastTriggeredAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });

    operationCount += 1;
    await commitIfNeeded();
  }

  if (operationCount > 0) {
    await batch.commit();
  }
}

/**
 * Sends one notification to a user's available tokens.
 * @param {AlertTrigger} trigger Triggered alert event.
 * @param {FcmTokenRecord[]} tokenRecords User token records.
 */
async function sendNotificationToTokens(
  trigger: AlertTrigger,
  tokenRecords: FcmTokenRecord[],
): Promise<void> {
  const invalidTokenRefs: FirebaseFirestore.DocumentReference[] = [];

  for (const chunk of chunkArray(tokenRecords, FCM_MULTICAST_LIMIT)) {
    const response = await getMessaging().sendEachForMulticast({
      tokens: chunk.map((record) => record.token),
      notification: {
        title: "ASA Server Eye Alert",
        body: buildAlertBody(trigger),
      },
      data: {
        type: "server_alert",
        ruleId: trigger.rule.id,
        serverId: trigger.rule.serverId,
        ruleType: trigger.rule.ruleType,
        previousPlayers: String(trigger.previousPlayers ?? ""),
        currentPlayers: String(trigger.currentPlayers ?? ""),
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
          invalidTokenRefs.push(tokenRecord.ref);
        }
      }
    });

    logger.info("Alert notification send result.", {
      userId: trigger.rule.userId,
      ruleId: trigger.rule.id,
      successCount: response.successCount,
      failureCount: response.failureCount,
    });
  }

  if (invalidTokenRefs.length > 0) {
    await removeInvalidTokens(invalidTokenRefs);
  }
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
    .collection("users")
    .doc(userId)
    .collection("fcm_tokens")
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
  const userSnapshot = await db.collection("users").doc(userId).get();
  const accessLevel = readString(userSnapshot.data() ?? {}, [
    "sightingsAccessLevel",
  ]);

  return accessLevel === "premium" || accessLevel === "admin";
}

/**
 * Removes FCM tokens that Firebase reports as invalid.
 * @param {FirebaseFirestore.DocumentReference[]} refs Token document refs.
 */
async function removeInvalidTokens(
  refs: FirebaseFirestore.DocumentReference[],
): Promise<void> {
  const uniqueRefs = uniqueValues(refs.map((ref) => ref.path)).map((path) => {
    return db.doc(path);
  });

  let batch = db.batch();
  let operationCount = 0;

  const commitIfNeeded = async () => {
    if (operationCount >= FIRESTORE_WRITE_BATCH_LIMIT) {
      await batch.commit();
      batch = db.batch();
      operationCount = 0;
    }
  };

  for (const ref of uniqueRefs) {
    batch.delete(ref);
    operationCount += 1;
    await commitIfNeeded();
  }

  if (operationCount > 0) {
    await batch.commit();
  }
}

/**
 * Verifies a subscription purchase against the store backend.
 * @param {VerificationRequestData} request The verification request payload.
 * @return {Promise<VerificationResult>} The normalized verification result.
 */
async function verifyPurchaseWithStore(
  request: VerificationRequestData,
): Promise<VerificationResult> {
  if (request.platform !== "android") {
    return {
      purchaseStatus: "pending",
      expiresAt: null,
      reason: "ios_verification_not_implemented_yet",
    };
  }

  const auth = new google.auth.GoogleAuth({
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });

  const androidpublisher = google.androidpublisher({
    version: "v3",
    auth,
  });

  try {
    const response = await androidpublisher.purchases.subscriptionsv2.get({
      packageName: PACKAGE_NAME,
      token: request.purchaseToken,
    });

    const purchase = response.data;

    if (!purchase) {
      return {
        purchaseStatus: "invalid",
        expiresAt: null,
        reason: "empty_purchase_response",
      };
    }

    const subscriptionState = purchase.subscriptionState ?? "";
    const lineItems = purchase.lineItems ?? [];

    const matchingLineItem = lineItems.find(
      (item) => item.productId === request.productId,
    );

    if (!matchingLineItem) {
      return {
        purchaseStatus: "invalid",
        expiresAt: null,
        reason: "product_id_mismatch",
        storePayload: purchase as Record<string, unknown>,
      };
    }

    const expiresAt = parseRfc3339Date(matchingLineItem.expiryTime);

    if (
      subscriptionState === "SUBSCRIPTION_STATE_ACTIVE" ||
      subscriptionState === "SUBSCRIPTION_STATE_IN_GRACE_PERIOD" ||
      subscriptionState === "SUBSCRIPTION_STATE_CANCELED"
    ) {
      return {
        purchaseStatus: "active",
        expiresAt,
        reason: subscriptionState.toLowerCase(),
        storePayload: purchase as Record<string, unknown>,
      };
    }

    if (subscriptionState === "SUBSCRIPTION_STATE_PENDING") {
      return {
        purchaseStatus: "pending",
        expiresAt,
        reason: "awaiting_payment",
        storePayload: purchase as Record<string, unknown>,
      };
    }

    return {
      purchaseStatus: "expired",
      expiresAt,
      reason: subscriptionState.toLowerCase() || "unknown_state",
      storePayload: purchase as Record<string, unknown>,
    };
  } catch (error) {
    const apiError = error as GoogleApiErrorLike;
    const status = apiError.response?.status ?? apiError.code;

    if (status === 400 || status === 404) {
      return {
        purchaseStatus: "invalid",
        expiresAt: null,
        reason: "invalid_purchase_token",
      };
    }

    if (status === 401 || status === 403) {
      logger.error("Google Play verification permission error.", {
        packageName: PACKAGE_NAME,
        status,
        message: apiError.message ?? null,
        responseData: apiError.response?.data ?? null,
      });

      return {
        purchaseStatus: "pending",
        expiresAt: null,
        reason: "play_api_access_denied",
      };
    }

    logger.error("Unexpected Google Play verification error.", {
      packageName: PACKAGE_NAME,
      status: status ?? null,
      message: apiError.message ?? null,
      responseData: apiError.response?.data ?? null,
    });

    throw error;
  }
}

/**
 * Parses an RFC3339 timestamp string into a Date.
 * @param {string | null | undefined} value The timestamp string.
 * @return {Date | null} The parsed date or null.
 */
function parseRfc3339Date(value?: string | null): Date | null {
  if (!value) {
    return null;
  }

  const parsed = new Date(value);
  return Number.isNaN(parsed.getTime()) ? null : parsed;
}

/**
 * Parses a raw ASA server list item into the backend snapshot format.
 * @param {Record<string, unknown>} json Raw server JSON.
 * @return {ServerSnapshot} Normalized server snapshot.
 */
function parseServerSnapshot(json: Record<string, unknown>): ServerSnapshot {
  const name = readString(json, ["Name"], "Unknown Server");
  const mapName = readString(json, ["MapName"], "Unknown Map");
  const sessionId = readString(json, [
    "SessionID",
    "SessionId",
    "SessionID64",
  ]);
  const ip = readString(json, ["IP", "Ip"]);
  const port = readString(json, ["Port"]);
  const fallbackId = buildFallbackServerId(name, mapName, ip, port);

  return {
    id: sessionId.length > 0 ? sessionId : fallbackId,
    name,
    mapName,
    players: readInt(json, ["NumPlayers"]),
    maxPlayers: readInt(json, ["MaxPlayers"]),
    official: readBool(json, ["IsOfficial", "Official"]),
    exists: true,
  };
}

/**
 * Parses a stored server snapshot document.
 * @param {FirebaseFirestore.DocumentData} data Firestore document data.
 * @return {ServerSnapshot | null} Parsed snapshot or null.
 */
function parseStoredServerSnapshot(
  data: FirebaseFirestore.DocumentData,
): ServerSnapshot | null {
  const id = readString(data, ["id"]);
  if (!id) {
    return null;
  }

  return {
    id,
    name: readString(data, ["name"], "Unknown Server"),
    mapName: readString(data, ["mapName"], "Unknown Map"),
    players: readInt(data, ["players"]),
    maxPlayers: readInt(data, ["maxPlayers"]),
    official: readBool(data, ["official"]),
    exists: readBool(data, ["exists"]),
  };
}

/**
 * Parses an alert rule document.
 * @param {FirebaseFirestore.QueryDocumentSnapshot} doc Alert rule document.
 * @return {AlertRule | null} Parsed alert rule or null if invalid.
 */
function parseAlertRule(
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
 * Checks whether the rule type is supported by the backend evaluator.
 * @param {string} value Raw rule type.
 * @return {value is AlertRuleType} True for known alert rule types.
 */
function isAlertRuleType(value: string): value is AlertRuleType {
  return value === "population_increased" ||
    value === "population_decreased" ||
    value === "crossed_above_threshold" ||
    value === "crossed_below_threshold" ||
    value === "server_online" ||
    value === "server_offline";
}

/**
 * Decides whether a rule should trigger for the current refresh.
 * @param {AlertRule} rule Alert rule.
 * @param {ServerSnapshot | null} previous Previous server state.
 * @param {ServerSnapshot | null} current Current server state.
 * @return {boolean} True when the rule should trigger.
 */
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

/**
 * Checks whether a rule was triggered within the cooldown window.
 * @param {AlertRule} rule Alert rule.
 * @param {Date} now Current time.
 * @return {boolean} True if the rule is still in cooldown.
 */
function isWithinCooldown(rule: AlertRule, now: Date): boolean {
  const lastTriggeredAt = rule.lastTriggeredAt;
  if (!lastTriggeredAt) {
    return false;
  }

  return now.getTime() - lastTriggeredAt.toDate().getTime() <
    ALERT_COOLDOWN_MS;
}

/**
 * Builds the user-visible FCM body text.
 * @param {AlertTrigger} trigger Triggered alert event.
 * @return {string} Notification body text.
 */
function buildAlertBody(trigger: AlertTrigger): string {
  const change = trigger.previousPlayers === null ||
    trigger.currentPlayers === null ?
    "" :
    ` (${trigger.previousPlayers} → ${trigger.currentPlayers})`;

  return `${alertRuleLabel(trigger.rule.ruleType)}: ` +
    `${trigger.rule.serverName} • ${trigger.rule.mapName}${change}`;
}

/**
 * Maps alert rule types to compact notification labels.
 * @param {AlertRuleType} ruleType Alert rule type.
 * @return {string} Label for notifications.
 */
function alertRuleLabel(ruleType: AlertRuleType): string {
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

/**
 * Returns a deterministic Firestore document ref for a server snapshot.
 * @param {string} serverId Stable server id.
 * @return {FirebaseFirestore.DocumentReference} Snapshot document ref.
 */
function serverSnapshotRef(
  serverId: string,
): FirebaseFirestore.DocumentReference {
  return db
    .collection(SERVER_ALERT_SNAPSHOTS_COLLECTION)
    .doc(hashValue(serverId));
}

/**
 * Builds the same fallback id shape used by the Flutter client.
 * @param {string} name Server name.
 * @param {string} mapName Map name.
 * @param {string} ip Server IP.
 * @param {string} port Server port.
 * @return {string} Fallback stable server id.
 */
function buildFallbackServerId(
  name: string,
  mapName: string,
  ip: string,
  port: string,
): string {
  const endpoint = [ip, port].filter((value) => value.length > 0).join(":");

  return [name.trim(), mapName.trim(), endpoint.trim()]
    .filter((value) => value.length > 0)
    .join("|");
}

/**
 * Builds a deterministic SHA-256 id for arbitrary path-unsafe values.
 * @param {string} value Raw value.
 * @return {string} SHA-256 hex digest.
 */
function hashValue(value: string): string {
  return createHash("sha256").update(value).digest("hex");
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

/**
 * Reads a string from one of several possible keys.
 * @param {Record<string, unknown>} data Source data.
 * @param {string[]} keys Candidate keys.
 * @param {string} fallback Fallback value.
 * @return {string} Normalized string value.
 */
function readString(
  data: Record<string, unknown>,
  keys: string[],
  fallback = "",
): string {
  for (const key of keys) {
    const value = data[key];
    if (value === null || value === undefined) {
      continue;
    }

    const normalized = String(value).trim();
    if (normalized.length > 0) {
      return normalized;
    }
  }

  return fallback;
}

/**
 * Reads an integer from one of several possible keys.
 * @param {Record<string, unknown>} data Source data.
 * @param {string[]} keys Candidate keys.
 * @return {number} Parsed integer or zero.
 */
function readInt(data: Record<string, unknown>, keys: string[]): number {
  for (const key of keys) {
    const parsed = readNullableInt(data[key]);
    if (parsed !== null) {
      return parsed;
    }
  }

  return 0;
}

/**
 * Reads a nullable integer from unknown input.
 * @param {unknown} value Raw value.
 * @return {number | null} Parsed integer or null.
 */
function readNullableInt(value: unknown): number | null {
  if (typeof value === "number" && Number.isFinite(value)) {
    return Math.trunc(value);
  }

  if (typeof value === "string") {
    const parsed = Number.parseInt(value.trim(), 10);
    return Number.isNaN(parsed) ? null : parsed;
  }

  return null;
}

/**
 * Reads a boolean from one of several possible keys.
 * @param {Record<string, unknown>} data Source data.
 * @param {string[]} keys Candidate keys.
 * @return {boolean} Parsed boolean or false.
 */
function readBool(data: Record<string, unknown>, keys: string[]): boolean {
  for (const key of keys) {
    const value = data[key];

    if (typeof value === "boolean") {
      return value;
    }

    if (typeof value === "number") {
      return value === 1;
    }

    if (typeof value === "string") {
      const normalized = value.trim().toLowerCase();
      if (normalized === "true" || normalized === "1") {
        return true;
      }
      if (normalized === "false" || normalized === "0") {
        return false;
      }
    }
  }

  return false;
}

/**
 * Checks whether a value is a JSON-like object.
 * @param {unknown} value Raw value.
 * @return {value is Record<string, unknown>} True when object-like.
 */
function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

/**
 * Returns unique values while preserving insertion order.
 * @param {T[]} values Input values.
 * @return {T[]} Unique values.
 */
function uniqueValues<T>(values: T[]): T[] {
  return Array.from(new Set(values));
}

/**
 * Splits an array into fixed-size chunks.
 * @param {T[]} values Input values.
 * @param {number} size Max chunk size.
 * @return {T[][]} Chunked values.
 */
function chunkArray<T>(values: T[], size: number): T[][] {
  const chunks: T[][] = [];
  for (let index = 0; index < values.length; index += size) {
    chunks.push(values.slice(index, index + size));
  }
  return chunks;
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
