// features/auth/presentation/providers/current_user.provider.dart
import 'package:asa_server_eye/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
