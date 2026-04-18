// features/auth/presentation/widgets/auth_submit_button.dart
import 'package:flutter/material.dart';

enum AuthSubmitButtonVariant { primary, secondary }

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.isSubmitting,
    required this.onPressed,
    this.variant = AuthSubmitButtonVariant.primary,
  });

  final String label;
  final bool isSubmitting;
  final Future<void> Function() onPressed;
  final AuthSubmitButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ButtonStyle? style = switch (variant) {
      AuthSubmitButtonVariant.primary => null,
      AuthSubmitButtonVariant.secondary => FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.primary,
        disabledBackgroundColor: theme.colorScheme.surface,
        disabledForegroundColor: theme.disabledColor,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    };

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: style,
        onPressed: isSubmitting ? null : () async => onPressed(),
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }
}
