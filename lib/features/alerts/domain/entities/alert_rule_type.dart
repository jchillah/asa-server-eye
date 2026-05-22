// features/alerts/domain/entities/alert_rule_type.dart
enum AlertRuleType {
  populationIncreased,
  populationDecreased,
  crossedAboveThreshold,
  crossedBelowThreshold,
  serverOnline,
  serverOffline,
}

extension AlertRuleTypeX on AlertRuleType {
  String get firestoreValue {
    switch (this) {
      case AlertRuleType.populationIncreased:
        return 'population_increased';
      case AlertRuleType.populationDecreased:
        return 'population_decreased';
      case AlertRuleType.crossedAboveThreshold:
        return 'crossed_above_threshold';
      case AlertRuleType.crossedBelowThreshold:
        return 'crossed_below_threshold';
      case AlertRuleType.serverOnline:
        return 'server_online';
      case AlertRuleType.serverOffline:
        return 'server_offline';
    }
  }

  static AlertRuleType? tryFromFirestore(String? value) {
    switch (value) {
      case 'population_increased':
        return AlertRuleType.populationIncreased;
      case 'population_decreased':
        return AlertRuleType.populationDecreased;
      case 'crossed_above_threshold':
        return AlertRuleType.crossedAboveThreshold;
      case 'crossed_below_threshold':
        return AlertRuleType.crossedBelowThreshold;
      case 'server_online':
        return AlertRuleType.serverOnline;
      case 'server_offline':
        return AlertRuleType.serverOffline;
      default:
        return null;
    }
  }
}
