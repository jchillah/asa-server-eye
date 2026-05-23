// features/notifications/presentation/services/local_alert_notification_service.dart
import 'dart:developer' as developer;

import 'package:flutter/services.dart';

class LocalAlertNotificationService {
  static const MethodChannel _channel = MethodChannel(
    'asa_server_eye/local_notifications',
  );

  Future<bool> showAlertNotification({
    required String title,
    required String body,
    required String serverId,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'showAlertNotification',
        {
          'title': title,
          'body': body,
          'serverId': serverId,
        },
      );

      return result ?? false;
    } on MissingPluginException {
      return false;
    } catch (error, stackTrace) {
      developer.log(
        'Failed to show local alert notification.',
        name: 'LocalAlertNotificationService',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
