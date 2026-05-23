import { FieldValue } from "firebase-admin/firestore";

import {
  FIRESTORE_GETALL_LIMIT,
  SERVER_ALERT_SNAPSHOTS_COLLECTION,
} from "../config";
import { db } from "../firebase";
import { chunkArray } from "../utils/arrays";
import { runBatchedWrites } from "../utils/firestore-batch";
import { hashValue } from "../utils/hash";
import { parseStoredServerSnapshot } from "./server-parsing";
import { ServerSnapshot, SnapshotWrite } from "./types";

/**
 * Returns a deterministic Firestore document ref for a server snapshot.
 * @param {string} serverId Stable server id.
 * @return {FirebaseFirestore.DocumentReference} Snapshot document ref.
 */
export function serverSnapshotRef(
  serverId: string,
): FirebaseFirestore.DocumentReference {
  return db
    .collection(SERVER_ALERT_SNAPSHOTS_COLLECTION)
    .doc(hashValue(serverId));
}

/**
 * Loads the previous known server snapshots for all tracked server ids.
 * @param {string[]} serverIds Stable server ids.
 * @return {Promise<Map<string, ServerSnapshot>>} Previous snapshots.
 */
export async function fetchPreviousServerSnapshots(
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
 * Persists current snapshots for all servers that have alert rules.
 * @param {string[]} serverIds Stable server ids.
 * @param {Map<string, ServerSnapshot>} currentServers Current server state.
 */
export async function persistServerSnapshots(
  serverIds: string[],
  currentServers: Map<string, ServerSnapshot>,
): Promise<void> {
  const refs: FirebaseFirestore.DocumentReference[] = [];
  const writes = new Map<string, SnapshotWrite>();

  for (const serverId of serverIds) {
    const server = currentServers.get(serverId);
    const ref = serverSnapshotRef(serverId);

    refs.push(ref);
    writes.set(
      ref.path,
      server ?
        {
          data: {
            ...server,
            updatedAt: FieldValue.serverTimestamp(),
          },
          merge: false,
        } :
        {
          data: {
            id: serverId,
            exists: false,
            updatedAt: FieldValue.serverTimestamp(),
          },
          merge: true,
        },
    );
  }

  await runBatchedWrites(refs, (batch, ref) => {
    const write = writes.get(ref.path);
    if (!write) {
      return;
    }

    if (write.merge) {
      batch.set(ref, write.data, { merge: true });
      return;
    }

    batch.set(ref, write.data);
  });
}
