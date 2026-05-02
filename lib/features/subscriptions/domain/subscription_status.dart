// features/subscriptions/domain/subscription_status.dart
enum SubscriptionStatus {
  initial,
  loading,
  ready,
  purchasing,
  restoring,
  completed,
  unavailable,
  error,
}
