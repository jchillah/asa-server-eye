import { FieldValue, Timestamp } from "firebase-admin/firestore";
import * as logger from "firebase-functions/logger";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

import { ACCESS_LEVEL } from "../constants/access-levels";
import { COLLECTION, USER_FIELD } from "../constants/firestore";
import { REGION } from "../config";
import { db } from "../firebase";
import { VerificationRequestData } from "./types";
import { verifyPurchaseWithStore } from "./verification";

export const processSubscriptionVerificationRequest = onDocumentCreated(
  {
    document: `${COLLECTION.SUBSCRIPTION_VERIFICATION_REQUESTS}/{requestId}`,
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
      .collection(COLLECTION.SUBSCRIPTION_VERIFICATION_REQUESTS)
      .doc(requestId);

    const userRef = db.collection(COLLECTION.USERS).doc(data.userId);
    const entitlementRef = db
      .collection(COLLECTION.USER_SUBSCRIPTIONS)
      .doc(data.userId);

    await requestRef.update({
      status: "processing",
      [USER_FIELD.UPDATED_AT]: FieldValue.serverTimestamp(),
    });

    try {
      const verification = await verifyPurchaseWithStore(data);

      const userSnap = await userRef.get();
      const userData = userSnap.data();

      let currentAccessLevel: string = ACCESS_LEVEL.FREE;
      if (typeof userData?.[USER_FIELD.SIGHTINGS_ACCESS_LEVEL] === "string") {
        currentAccessLevel = userData[USER_FIELD.SIGHTINGS_ACCESS_LEVEL];
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
          [USER_FIELD.UPDATED_AT]: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      await userRef.set(
        {
          [USER_FIELD.SIGHTINGS_ACCESS_LEVEL]: nextAccessLevel,
          [USER_FIELD.UPDATED_AT]: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

      await requestRef.update({
        status: verification.purchaseStatus,
        processedAt: FieldValue.serverTimestamp(),
        [USER_FIELD.UPDATED_AT]: FieldValue.serverTimestamp(),
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
        [USER_FIELD.UPDATED_AT]: FieldValue.serverTimestamp(),
        errorMessage: error instanceof Error ? error.message : String(error),
      });

      throw error;
    }
  },
);
