import assert from "node:assert/strict";
import { describe, it } from "node:test";

import {
  isRecentAuthentication,
  runAccountDeletion,
} from "./deletion-service";

describe("isRecentAuthentication", () => {
  it("accepts authentication inside the configured window", () => {
    assert.equal(isRecentAuthentication(900, 1000, 300), true);
  });

  it("rejects missing, old, and future authentication timestamps", () => {
    assert.equal(isRecentAuthentication(undefined, 1000, 300), false);
    assert.equal(isRecentAuthentication(699, 1000, 300), false);
    assert.equal(isRecentAuthentication(1001, 1000, 300), false);
  });
});

describe("runAccountDeletion", () => {
  it("removes authentication only after all user data", async () => {
    const calls: string[] = [];

    await runAccountDeletion("user-1", {
      collectUserOwnedData: async (uid) => {
        calls.push(`collect:${uid}`);
        return ["data"];
      },
      deleteUserProfile: async (uid) => {
        calls.push(`profile:${uid}`);
      },
      deleteUserOwnedData: async (data) => {
        calls.push(`owned:${data.join(",")}`);
      },
      deleteProfileImage: async (uid) => {
        calls.push(`image:${uid}`);
      },
      deleteAuthenticationUser: async (uid) => {
        calls.push(`auth:${uid}`);
      },
    });

    assert.deepEqual(calls, [
      "collect:user-1",
      "profile:user-1",
      "owned:data",
      "image:user-1",
      "auth:user-1",
    ]);
  });

  it("keeps authentication retryable when data cleanup fails", async () => {
    let authenticationDeleted = false;

    await assert.rejects(() => runAccountDeletion("user-1", {
      collectUserOwnedData: async () => [],
      deleteUserProfile: async () => {},
      deleteUserOwnedData: async () => {
        throw new Error("transient cleanup error");
      },
      deleteProfileImage: async () => {},
      deleteAuthenticationUser: async () => {
        authenticationDeleted = true;
      },
    }));

    assert.equal(authenticationDeleted, false);
  });
});
