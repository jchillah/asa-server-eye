// features/profile/presentation/utils/profile_dialogs.dart
import 'package:flutter/material.dart';

import '../widgets/delete_account_dialog.dart';

abstract final class ProfileDialogs {
  static Future<String?> showDeleteAccountDialog({
    required BuildContext context,
    required String email,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => DeleteAccountDialog(email: email),
    );
  }
}
