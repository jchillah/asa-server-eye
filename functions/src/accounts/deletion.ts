import * as logger from "firebase-functions/logger";
import { FieldPath } from "firebase-admin/firestore";
import {
  CallableRequest,
  HttpsError,
  onCall,
} from "firebase-functions/v2/https";

import { REGION } from "../config";
import { auth, db, storage } from "../firebase";
import {
  isRecentAuthentication,
  runAccountDeletion,
} from "./deletion-service";

const RECENT_AUTH_MAX_AGE_SECONDS = 5 * 60;
const QUERY_PAGE_SIZE = 400;
const IN_QUERY_LIMIT = 30;

type DocumentRef = FirebaseFirestore.DocumentReference;

function requireRecentlyAuthenticatedUser(
  request: CallableRequest<unknown>,
): string {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Authentication is required.");
  }

  const authTime = request.auth?.token.auth_time;
  const nowInSeconds = Math.floor(Date.now() / 1000);
  if (!isRecentAuthentication(
    authTime,
    nowInSeconds,
    RECENT_AUTH_MAX_AGE_SECONDS,
  )) {
    throw new HttpsError(
      "failed-precondition",
      "Recent authentication is required.",
    );
  }

  return uid;
}

async function queryDocumentRefs(
  query: FirebaseFirestore.Query,
): Promise<DocumentRef[]> {
  const refs: DocumentRef[] = [];
  let lastDocument: FirebaseFirestore.QueryDocumentSnapshot | undefined;
  let hasNextPage = true;

  while (hasNextPage) {
    let pageQuery = query
      .orderBy(FieldPath.documentId())
      .limit(QUERY_PAGE_SIZE);
    if (lastDocument) {
      pageQuery = pageQuery.startAfter(lastDocument);
    }

    const snapshot = await pageQuery.get();
    refs.push(...snapshot.docs.map((document) => document.ref));

    if (snapshot.size < QUERY_PAGE_SIZE) {
      hasNextPage = false;
    } else {
      lastDocument = snapshot.docs[snapshot.docs.length - 1];
    }
  }

  return refs;
}

function chunks<T>(values: T[], size: number): T[][] {
  const result: T[][] = [];
  for (let index = 0; index < values.length; index += size) {
    result.push(values.slice(index, index + size));
  }
  return result;
}

async function collectUserOwnedDocumentRefs(
  uid: string,
): Promise<DocumentRef[]> {
  const subscriptionRequests = await queryDocumentRefs(
    db.collection("subscription_verification_requests").where(
      "userId",
      "==",
      uid,
    ),
  );
  const ownedSightings = await queryDocumentRefs(
    db.collection("player_sightings").where("createdByUserId", "==", uid),
  );
  const changedHistory = await queryDocumentRefs(
    db.collection("player_sighting_history").where(
      "changedByUserId",
      "==",
      uid,
    ),
  );
  const usernameReservations = await queryDocumentRefs(
    db.collection("usernames").where("userId", "==", uid),
  );

  const ownedSightingIds = ownedSightings.map((ref) => ref.id);
  const ownedSightingHistory: DocumentRef[] = [];
  for (const sightingIds of chunks(ownedSightingIds, IN_QUERY_LIMIT)) {
    ownedSightingHistory.push(
      ...await queryDocumentRefs(
        db.collection("player_sighting_history").where(
          "sightingId",
          "in",
          sightingIds,
        ),
      ),
    );
  }

  const adminMeta = ownedSightingIds.map((sightingId) => {
    return db.collection("player_sighting_admin_meta").doc(sightingId);
  });

  return [
    ...subscriptionRequests,
    ...ownedSightings,
    ...changedHistory,
    ...ownedSightingHistory,
    ...usernameReservations,
    ...adminMeta,
    db.collection("user_subscriptions").doc(uid),
  ];
}

async function deleteDocumentRefs(refs: DocumentRef[]): Promise<void> {
  const writer = db.bulkWriter();
  const uniqueRefs = new Map(refs.map((ref) => [ref.path, ref]));

  for (const ref of uniqueRefs.values()) {
    writer.delete(ref);
  }
  await writer.close();
}

async function deleteProfileImage(uid: string): Promise<void> {
  try {
    await storage.bucket().file(`users/${uid}/profile.jpg`).delete();
  } catch (error) {
    const storageError = error as { code?: number };
    if (storageError.code !== 404) {
      throw error;
    }
  }
}

export const deleteAccount = onCall(
  {
    region: REGION,
    timeoutSeconds: 120,
    memory: "512MiB",
    maxInstances: 10,
  },
  async (request) => {
    const uid = requireRecentlyAuthenticatedUser(request);

    try {
      await runAccountDeletion(uid, {
        collectUserOwnedData: collectUserOwnedDocumentRefs,
        deleteUserProfile: async (userId) => {
          await db.recursiveDelete(db.collection("users").doc(userId));
        },
        deleteUserOwnedData: deleteDocumentRefs,
        deleteProfileImage,
        deleteAuthenticationUser: async (userId) => {
          await auth.deleteUser(userId);
        },
      });

      logger.info("Account deletion completed.");
      return { deleted: true };
    } catch (error) {
      logger.error("Account deletion failed.", {
        errorCode: error instanceof Error ? error.name : "unknown",
      });
      throw new HttpsError(
        "internal",
        "Account deletion could not be completed.",
      );
    }
  },
);
