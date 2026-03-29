// features/auth/presentation/providers/sign_up_form_controller_provider.dart
import 'package:asa_server_eye/features/auth/presentation/controllers/sign_up_form_controller.dart';
import 'package:asa_server_eye/features/auth/presentation/providers/sign_up_controller_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signUpFormControllerProvider =
    ChangeNotifierProvider.autoDispose<SignUpFormController>((ref) {
      final authController = ref.watch(signUpControllerProvider);
      return SignUpFormController(authController);
    });
