// features/auth/presentation/providers/sign_up_controller_provider.dart
import 'package:asa_server_eye/features/auth/presentation/controllers/sign_up_controller.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpControllerProvider = Provider<SignUpController>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpController(repository);
});
