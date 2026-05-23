import * as logger from "firebase-functions/logger";
import { onSchedule } from "firebase-functions/v2/scheduler";

import {
  ALERT_SCHEDULE,
  ALERT_SCHEDULE_TIMEZONE,
  REGION,
} from "../config";
import { uniqueValues } from "../utils/arrays";
import { sendAlertNotifications } from "./notifications";
import {
  evaluateAlertTriggers,
  fetchActiveAlertRules,
  markTriggeredRules,
} from "./rules";
import { fetchOfficialServerList } from "./server-list";
import {
  fetchPreviousServerSnapshots,
  persistServerSnapshots,
} from "./snapshots";

export const evaluateAlertRulesAndSendNotifications = onSchedule(
  {
    schedule: ALERT_SCHEDULE,
    region: REGION,
    timeZone: ALERT_SCHEDULE_TIMEZONE,
    maxInstances: 1,
  },
  async () => {
    const now = new Date();
    const currentServers = await fetchOfficialServerList();

    if (currentServers === null) {
      logger.warn(
        "Skipping alert evaluation because server data is unavailable.",
      );
      return;
    }

    const activeRules = await fetchActiveAlertRules();

    if (activeRules.length === 0) {
      logger.info("No active alert rules found.");
      return;
    }

    const serverIds = uniqueValues(activeRules.map((rule) => rule.serverId));
    const previousSnapshots = await fetchPreviousServerSnapshots(serverIds);
    const triggers = evaluateAlertTriggers({
      rules: activeRules,
      currentServers,
      previousSnapshots,
      now,
    });

    await persistServerSnapshots(serverIds, currentServers, previousSnapshots);

    if (triggers.length === 0) {
      logger.info("No alert rules triggered.", {
        activeRules: activeRules.length,
        trackedServers: serverIds.length,
      });
      return;
    }

    await sendAlertNotifications(triggers);
    await markTriggeredRules(triggers);

    logger.info("Alert rule evaluation finished.", {
      activeRules: activeRules.length,
      triggeredRules: triggers.length,
      trackedServers: serverIds.length,
    });
  },
);
