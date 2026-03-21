// features/favorites/presentation/widgets/favorite_server_list_item.dart
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../servers/domain/server.dart';

class FavoriteServerListItem extends StatelessWidget {
  const FavoriteServerListItem({
    super.key,
    required this.server,
    required this.onTap,
  });

  final Server server;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: AppColors.neonGreen.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.star_rounded, color: AppColors.neonGreen),
        ),
        title: Text(server.name, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${server.map} • ${server.players}/${server.maxPlayers}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
