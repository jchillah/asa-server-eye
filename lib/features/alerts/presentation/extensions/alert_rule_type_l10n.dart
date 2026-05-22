// features/alerts/presentation/extensions/alert_rule_type_l10n.dart
import 'package:flutter/widgets.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/entities/alert_rule_type.dart';

extension AlertRuleTypeL10n on AlertRuleType {
  String localizedLabel(BuildContext context) {
    switch (this) {
      case AlertRuleType.populationIncreased:
        return context.l10n.alertTypePopulationIncreased;
      case AlertRuleType.populationDecreased:
        return context.l10n.alertTypePopulationDecreased;
      case AlertRuleType.crossedAboveThreshold:
        return context.l10n.alertTypeCrossedAboveThreshold;
      case AlertRuleType.crossedBelowThreshold:
        return context.l10n.alertTypeCrossedBelowThreshold;
      case AlertRuleType.serverOnline:
        return context.l10n.alertTypeServerOnline;
      case AlertRuleType.serverOffline:
        return context.l10n.alertTypeServerOffline;
    }
  }
}
