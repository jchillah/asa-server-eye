import * as logger from "firebase-functions/logger";
import { google } from "googleapis";

import { PACKAGE_NAME } from "../config";
import {
  GoogleApiErrorLike,
  VerificationRequestData,
  VerificationResult,
} from "./types";

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
 * Verifies a subscription purchase against the store backend.
 * @param {VerificationRequestData} request The verification request payload.
 * @return {Promise<VerificationResult>} The normalized verification result.
 */
export async function verifyPurchaseWithStore(
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
