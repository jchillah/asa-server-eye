// features/notifications/presentation/controllers/fcm_token_registration_controller.dart
import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../providers/fcm_token_repository_provider.dart';

final fcmTokenRegistrationControllerProvider =
    Provider.autoDispose<FcmTokenRegistrationController>((ref) {
      final controller = FcmTokenRegistrationController(ref);
      unawaited(controller.start());
      ref.onDispose(controller.dispose);
      return controller;
    });

class FcmTokenRegistrationController {
  FcmTokenRegistrationController(this._ref);

  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSubscription;
  String? _registeredUserId;
  String? _registeredToken;
  bool _hasNotificationPermission = false;
  bool _isStarted = false;

  Future<void> start() async {
    if (_isStarted) {
      return;
    }

    _isStarted = true;

    try {
      await _configureForegroundPresentation();
      _hasNotificationPermission = await _requestPermission();

      if (!_hasNotificationPermission) {
        developer.log(
          'Notification permission not granted. Skipping FCM token registration.',
          name: 'FcmTokenRegistrationController',
        );
        return;
      }

      _listenToAuthChanges();
      await _registerCurrentTokenForUser(_ref.read(authStateProvider).valueOrNull);
      _listenToTokenRefresh();
    } catch (error, stackTrace) {
      developer.log(
        'Failed to start FCM token registration.',
        name: 'FcmTokenRegistrationController',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _listenToAuthChanges() {
    _ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      unawaited(_handleAuthChange(next.valueOrNull));
    });
  }

  void _listenToTokenRefresh() {
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (token) => _registerTokenForCurrentUser(token),
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

  Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> _handleAuthChange(User? user) async {
    if (!_hasNotificationPermission) {
      return;
    }

    final previousUserId = _registeredUserId;
    final previousToken = _registeredToken;

    if (previousUserId != null &&
        previousToken != null &&
        previousUserId != user?.uid) {
      await _removeRegisteredToken(
        userId: previousUserId,
        token: previousToken,
      );
      _registeredUserId = null;
      _registeredToken = null;
    }

    await _registerCurrentTokenForUser(user);
  }

  Future<void> _registerCurrentTokenForUser(User? user) async {
    if (user == null) {
      return;
    }

    final token = await _messaging.getToken();
    if (token == null) {
      return;
    }

    await _saveToken(userId: user.uid, token: token);
  }

  Future<void> _registerTokenForCurrentUser(String token) async {
    if (!_hasNotificationPermission) {
      return;
    }

    final user = _ref.read(authStateProvider).valueOrNull;
    if (user == null) {
      return;
    }

    if (_registeredUserId == user.uid && _registeredToken != null) {
      await _removeRegisteredToken(
        userId: user.uid,
        token: _registeredToken!,
      );
    }

    await _saveToken(userId: user.uid, token: token);
  }

  Future<void> _saveToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _ref
          .read(fcmTokenRepositoryProvider)
          .saveToken(userId: userId, token: token);
      _registeredUserId = userId;
      _registeredToken = token;
    } catch (error, stackTrace) {
      developer.log(
        'Failed to save FCM token.',
        name: 'FcmTokenRegistrationController',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _removeRegisteredToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _ref
          .read(fcmTokenRepositoryProvider)
          .removeToken(userId: userId, token: token);
    } catch (error, stackTrace) {
      developer.log(
        'Failed to remove FCM token.',
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
