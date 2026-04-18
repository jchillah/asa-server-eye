// core/presentation/widgets/app_action_button.dart
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

enum AppActionButtonVariant { primary, secondary, danger }

class AppActionButton extends StatelessWidget {
  const AppActionButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
    this.variant = AppActionButtonVariant.primary,
    this.icon,
  });

  final String label;
  final bool isLoading;
  final Future<void> Function() onPressed;
  final AppActionButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();

    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_loadingColor),
            ),
          )
        : Text(label);

    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? FilledButton(
              style: style,
              onPressed: isLoading ? null : () async => onPressed(),
              child: child,
            )
          : FilledButton.icon(
              style: style,
              onPressed: isLoading ? null : () async => onPressed(),
              icon: isLoading ? const SizedBox.shrink() : Icon(icon),
              label: child,
            ),
    );
  }

  ButtonStyle _resolveStyle() {
    switch (variant) {
      case AppActionButtonVariant.primary:
        return FilledButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          foregroundColor: AppColors.black,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textSecondary,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        );

      case AppActionButtonVariant.secondary:
        return FilledButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.neonGreen,
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.textSecondary,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.neonGreen),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        );

      case AppActionButtonVariant.danger:
        return FilledButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.neonGreen,
          disabledBackgroundColor: AppColors.border,
          disabledForegroundColor: AppColors.textSecondary,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.neonGreen),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        );
    }
  }

  Color get _loadingColor {
    switch (variant) {
      case AppActionButtonVariant.primary:
        return AppColors.black;
      case AppActionButtonVariant.secondary:
      case AppActionButtonVariant.danger:
        return AppColors.neonGreen;
    }
  }
}
