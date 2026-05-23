import { FIRESTORE_WRITE_BATCH_LIMIT } from "../config";
import { db } from "../firebase";
import { uniqueValues } from "./arrays";

/**
 * Commits Firestore writes in batches of FIRESTORE_WRITE_BATCH_LIMIT.
 * @param {T[]} items Items to write.
 * @param {Function} write Callback that enqueues one write on the batch.
 */
export async function runBatchedWrites<T>(
  items: T[],
  write: (batch: FirebaseFirestore.WriteBatch, item: T) => void,
): Promise<void> {
  let batch = db.batch();
  let operationCount = 0;
  const pendingCommits: Promise<FirebaseFirestore.WriteResult[]>[] = [];

  const enqueueCommit = () => {
    pendingCommits.push(batch.commit());
    batch = db.batch();
    operationCount = 0;
  };

  for (const item of items) {
    write(batch, item);
    operationCount += 1;

    if (operationCount >= FIRESTORE_WRITE_BATCH_LIMIT) {
      enqueueCommit();
    }
  }

  if (operationCount > 0) {
    pendingCommits.push(batch.commit());
  }

  await Promise.all(pendingCommits);
}

/**
 * Removes FCM tokens that Firebase reports as invalid.
 * @param {FirebaseFirestore.DocumentReference[]} refs Token document refs.
 */
export async function removeInvalidTokens(
  refs: FirebaseFirestore.DocumentReference[],
): Promise<void> {
  const uniqueRefs = uniqueValues(refs.map((ref) => ref.path)).map((path) => {
    return db.doc(path);
  });

  await runBatchedWrites(uniqueRefs, (batch, ref) => {
    batch.delete(ref);
  });
}
