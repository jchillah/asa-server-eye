// features/auth/presentation/providers/auth_repository_provider.dart
import 'package:asa_server_eye/features/auth/presentation/providers/firebase_auth_provider.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  return AuthRepository(firebaseAuth, firestore);
});
