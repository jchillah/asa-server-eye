import { FieldValue, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

import { ACCESS_LEVEL } from "../constants/access-levels";
import { REGION } from "../config";
import { db } from "../firebase";
import { VerificationRequestData } from "./types";
import { verifyPurchaseWithStore } from "./verification";

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

      let currentAccessLevel: string = ACCESS_LEVEL.FREE;
      if (typeof userData?.["sightingsAccessLevel"] === "string") {
        currentAccessLevel = userData["sightingsAccessLevel"];
      }

      let nextAccessLevel: string = ACCESS_LEVEL.FREE;
      if (currentAccessLevel === ACCESS_LEVEL.ADMIN) {
        nextAccessLevel = ACCESS_LEVEL.ADMIN;
      } else if (verification.purchaseStatus === "active") {
        nextAccessLevel = ACCESS_LEVEL.PREMIUM;
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
