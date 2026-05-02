import { initializeApp } from "firebase-admin/app";
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { google } from "googleapis";

initializeApp();

const db = getFirestore();

const REGION = "europe-west3";
const PACKAGE_NAME = "com.jchillah.asaservereye";

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

  const response = await androidpublisher.purchases.subscriptionsv2.get({
    packageName: PACKAGE_NAME,
    token: request.purchaseToken,
  });

  const purchase = response.data;
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
