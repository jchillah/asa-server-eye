import { Timestamp } from "firebase-admin/firestore";

export type AlertRuleType =
  | "population_increased"
  | "population_decreased"
  | "crossed_above_threshold"
  | "crossed_below_threshold"
  | "server_online"
  | "server_offline";

export type ServerSnapshot = {
  id: string;
  name: string;
  mapName: string;
  players: number;
  maxPlayers: number;
  official: boolean;
  exists: boolean;
};

export type AlertRule = {
  id: string;
  ref: FirebaseFirestore.DocumentReference;
  userId: string;
  serverId: string;
  serverName: string;
  mapName: string;
  ruleType: AlertRuleType;
  isEnabled: boolean;
  threshold: number | null;
  lastTriggeredAt: Timestamp | null;
};

export type AlertTrigger = {
  rule: AlertRule;
  previousPlayers: number | null;
  currentPlayers: number | null;
};

export type FcmTokenRecord = {
  token: string;
  ref: FirebaseFirestore.DocumentReference;
};

export type RuleEvaluator = (
  rule: AlertRule,
  previous: ServerSnapshot | null,
  current: ServerSnapshot | null,
) => boolean;

export type SnapshotWrite = {
  data: FirebaseFirestore.DocumentData;
  merge: boolean;
};
