// features/notifications/presentation/controllers/fcm_token_registration_controller.dart
import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../providers/fcm_token_repository_provider.dart';

final fcmTokenRegistrationControllerProvider =
    Provider.autoDispose<FcmTokenRegistrationController>((ref) {
  final controller = FcmTokenRegistrationController(ref);
  controller.start();
  ref.onDispose(controller.dispose);
  return controller;
});

class FcmTokenRegistrationController {
  FcmTokenRegistrationController(this._ref);

  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _isStarted = false;

  Future<void> start() async {
    if (_isStarted) {
      return;
    }

    _isStarted = true;

    await _configureForegroundPresentation();
    await _requestPermission();
    await _saveCurrentTokenForSignedInUser();

    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (token) => _saveTokenForSignedInUser(token),
      onError: (Object error, StackTrace stackTrace) {
        developer.log(
          'FCM token refresh listener failed.',
          name: 'FcmTokenRegistrationController',
          error: error,
          stackTrace: stackTrace,
        );
      },
    );
  }

  Future<void> _configureForegroundPresentation() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> _saveCurrentTokenForSignedInUser() async {
    final token = await _messaging.getToken();
    if (token == null) {
      return;
    }

    await _saveTokenForSignedInUser(token);
  }

  Future<void> _saveTokenForSignedInUser(String token) async {
    final user = _ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      return;
    }

    try {
      await _ref.read(fcmTokenRepositoryProvider).saveToken(
            userId: user.uid,
            token: token,
          );
    } catch (error, stackTrace) {
      developer.log(
        'Failed to save FCM token.',
        name: 'FcmTokenRegistrationController',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void dispose() {
    unawaited(_tokenRefreshSubscription?.cancel());
    _tokenRefreshSubscription = null;
  }
}
