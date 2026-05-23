export type VerificationRequestData = {
  userId: string;
  platform: "android" | "ios";
  productId: string;
  purchaseId: string;
  purchaseToken: string;
  status: string;
  createdAt?: FirebaseFirestore.Timestamp;
  updatedAt?: FirebaseFirestore.Timestamp;
};

export type VerificationResult = {
  purchaseStatus: "active" | "expired" | "invalid" | "pending";
  expiresAt: Date | null;
  reason?: string | null;
  storePayload?: Record<string, unknown> | null;
};

export type GoogleApiErrorLike = {
  code?: number;
  message?: string;
  response?: {
    status?: number;
    data?: unknown;
  };
};
