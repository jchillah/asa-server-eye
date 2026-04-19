import { initializeApp } from "firebase-admin/app";
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

initializeApp();

const db = getFirestore();

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
};

export const processSubscriptionVerificationRequest = onDocumentCreated(
  {
    document: "subscription_verification_requests/{requestId}",
    region: "europe-west3",
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
      const currentAccessLevel =
        typeof userData?.["sightingsAccessLevel"] === "string" ?
          userData["sightingsAccessLevel"] :
          "free";

      const nextAccessLevel =
        currentAccessLevel === "admin" ? "admin" :
          verification.purchaseStatus === "active" ? "premium" :
            "free";

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
 * Verifies a subscription purchase with the app store backend.
 * Replace this stub with real Google Play / Apple verification.
 * @param {VerificationRequestData} request The verification request payload.
 * @return {Promise<VerificationResult>} The normalized verification result.
 */
async function verifyPurchaseWithStore(
  request: VerificationRequestData,
): Promise<VerificationResult> {
  logger.info("verifyPurchaseWithStore called.", {
    userId: request.userId,
    platform: request.platform,
    productId: request.productId,
    purchaseId: request.purchaseId,
  });

  return {
    purchaseStatus: "pending",
    expiresAt: null,
    reason: "Store verification not implemented yet.",
  };
}
