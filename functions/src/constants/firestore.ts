export const COLLECTION = {
  ALERT_EVENTS: "alert_events",
  ALERT_RULES: "alert_rules",
  FCM_TOKENS: "fcm_tokens",
  SUBSCRIPTION_VERIFICATION_REQUESTS: "subscription_verification_requests",
  USERS: "users",
  USER_SUBSCRIPTIONS: "user_subscriptions",
} as const;

export const USER_FIELD = {
  SIGHTINGS_ACCESS_LEVEL: "sightingsAccessLevel",
  UPDATED_AT: "updatedAt",
} as const;

export const ALERT_RULE_FIELD = {
  IS_ENABLED: "isEnabled",
  LAST_TRIGGERED_AT: "lastTriggeredAt",
  MAP_NAME: "mapName",
  RULE_TYPE: "ruleType",
  SERVER_ID: "serverId",
  SERVER_NAME: "serverName",
  THRESHOLD: "threshold",
  UPDATED_AT: "updatedAt",
  USER_ID: "userId",
} as const;

export const ALERT_EVENT_FIELD = {
  CREATED_AT: "createdAt",
  CURRENT_PLAYERS: "currentPlayers",
  MAP_NAME: "mapName",
  PREVIOUS_PLAYERS: "previousPlayers",
  READ_AT: "readAt",
  RULE_ID: "ruleId",
  RULE_TYPE: "ruleType",
  SERVER_ID: "serverId",
  SERVER_NAME: "serverName",
  TITLE: "title",
  TRIGGERED_AT: "triggeredAt",
  USER_ID: "userId",
} as const;
