// features/profile/presentation/providers/profile_form_controller_provider.dart
import 'package:asa_server_eye/features/profile/presentation/providers/profile_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_form_controller.dart';

final profileFormControllerProvider =
    ChangeNotifierProvider.autoDispose<ProfileFormController>((ref) {
      final repository = ref.watch(profileRepositoryProvider);
      return ProfileFormController(repository);
    });
