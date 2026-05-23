// features/notifications/presentation/services/local_alert_notification_service.dart
import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localAlertNotificationServiceProvider = Provider<LocalAlertNotificationService>(
  (ref) => const LocalAlertNotificationService(),
);

class LocalAlertNotificationService {
  const LocalAlertNotificationService();

  static const String channelName = 'asa_server_eye/local_notifications';

  static const String _methodShowAlertNotification = 'showAlertNotification';

  static const String _argTitle = 'title';
  static const String _argBody = 'body';
  static const String _argServerId = 'serverId';
  static const String _argRuleType = 'ruleType';
  static const String _argAlertId = 'alertId';

  static const String _statusKey = 'status';
  static const String _statusShown = 'shown';
  static const String _statusPermissionDenied = 'permission_denied';
  static const String _statusMissingServerId = 'missing_server_id';

  static const MethodChannel _channel = MethodChannel(channelName);

  Future<LocalAlertNotificationResult> showAlertNotification({
    required String title,
    required String body,
    required String serverId,
    required String ruleType,
    required String alertId,
  }) async {
    if (serverId.trim().isEmpty) {
      return LocalAlertNotificationResult.missingServerId;
    }

    try {
      final result = await _channel.invokeMapMethod<String, String>(
        _methodShowAlertNotification,
        {
          _argTitle: title,
          _argBody: body,
          _argServerId: serverId,
          _argRuleType: ruleType,
          _argAlertId: alertId,
        },
      );

      return LocalAlertNotificationResultX.fromStatus(result?[_statusKey]);
    } on MissingPluginException {
      return LocalAlertNotificationResult.unsupportedPlatform;
    } catch (error, stackTrace) {
      developer.log(
        'Failed to show local alert notification.',
        name: 'LocalAlertNotificationService',
        error: error,
        stackTrace: stackTrace,
      );
      return LocalAlertNotificationResult.failed;
    }
  }
}

enum LocalAlertNotificationResult {
  shown,
  permissionDenied,
  missingServerId,
  unsupportedPlatform,
  failed,
}

extension LocalAlertNotificationResultX on LocalAlertNotificationResult {
  static LocalAlertNotificationResult fromStatus(String? status) {
    switch (status) {
      case LocalAlertNotificationService._statusShown:
        return LocalAlertNotificationResult.shown;
      case LocalAlertNotificationService._statusPermissionDenied:
        return LocalAlertNotificationResult.permissionDenied;
      case LocalAlertNotificationService._statusMissingServerId:
        return LocalAlertNotificationResult.missingServerId;
      default:
        return LocalAlertNotificationResult.failed;
    }
  }
}
