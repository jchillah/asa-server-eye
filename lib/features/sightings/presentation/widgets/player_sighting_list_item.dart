// features/sightings/presentation/widgets/player_sighting_list_item.dart
import 'package:flutter/material.dart';

import '../../domain/player_sighting.dart';

class PlayerSightingListItem extends StatelessWidget {
  const PlayerSightingListItem({
    super.key,
    required this.sighting,
    this.trailing,
  });

  final PlayerSighting sighting;
  final Widget? trailing;

  String get _platformLabel {
    switch (sighting.platform) {
      case GamingPlatform.steam:
        return 'Steam';
      case GamingPlatform.xbox:
        return 'Xbox';
      case GamingPlatform.psn:
        return 'PSN';
      case GamingPlatform.unknown:
        return 'Unknown';
    }
  }

  String get _visibilityLabel {
    switch (sighting.visibilityLevel) {
      case SightingVisibilityLevel.free:
        return 'Free';
      case SightingVisibilityLevel.premium:
        return 'Premium';
      case SightingVisibilityLevel.admin:
        return 'Admin';
    }
  }

  String get _sharingLabel {
    switch (sighting.sharingScope) {
      case SightingSharingScope.ownerOnly:
        return 'Owner only';
      case SightingSharingScope.premiumShared:
        return 'Shared with premium';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sighting.playerId, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(sighting.playerName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Platform: $_platformLabel',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Visibility: $_visibilityLabel',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sharing: $_sharingLabel',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(sighting.createdAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  if (sighting.updatedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Edited: ${_formatDateTime(sighting.updatedAt!)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  if (!sighting.isVisible) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Soft deleted',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    if (sighting.deleteReason != null &&
                        sighting.deleteReason!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Reason: ${sighting.deleteReason!}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                  if (sighting.note != null &&
                      sighting.note!.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(sighting.note!, style: theme.textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day.$month.$year  $hour:$minute';
  }
}
