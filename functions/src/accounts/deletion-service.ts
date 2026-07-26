export type AccountDeletionDependencies<T> = {
  collectUserOwnedData: (uid: string) => Promise<T>;
  deleteUserProfile: (uid: string) => Promise<void>;
  deleteUserOwnedData: (data: T) => Promise<void>;
  deleteProfileImage: (uid: string) => Promise<void>;
  deleteAuthenticationUser: (uid: string) => Promise<void>;
};

export function isRecentAuthentication(
  authTime: unknown,
  nowInSeconds: number,
  maxAgeSeconds: number,
): boolean {
  return typeof authTime === "number" &&
    authTime <= nowInSeconds &&
    nowInSeconds - authTime <= maxAgeSeconds;
}

export async function runAccountDeletion<T>(
  uid: string,
  dependencies: AccountDeletionDependencies<T>,
): Promise<void> {
  const userOwnedData = await dependencies.collectUserOwnedData(uid);

  await dependencies.deleteUserProfile(uid);
  await dependencies.deleteUserOwnedData(userOwnedData);
  await dependencies.deleteProfileImage(uid);

  // Authentication is removed last so every preceding operation remains
  // retryable if a transient backend operation fails.
  await dependencies.deleteAuthenticationUser(uid);
}
