// features/favorites/presentation/widgets/favorites_remove_background.dart
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class FavoritesRemoveBackground extends StatelessWidget {
  const FavoritesRemoveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.delete_outline_rounded, color: AppColors.white),
    );
  }
}
