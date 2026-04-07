// features/sightings/presentation/widgets/player_sighting_list_item.dart
import 'package:asa_server_eye/core/extensions/context_l10n.dart';
import 'package:asa_server_eye/core/extensions/date_time_formatting_extension.dart';
import 'package:flutter/material.dart';

import '../../domain/player_sighting.dart';
import '../extensions/gaming_platform_l10n_extension.dart';
import '../extensions/sighting_creator_level_l10n_extension.dart';
import '../extensions/sighting_sharing_scope_l10n_extension.dart';

class PlayerSightingListItem extends StatelessWidget {
  const PlayerSightingListItem({
    super.key,
    required this.sighting,
    this.trailing,
  });

  final PlayerSighting sighting;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final createdAt = sighting.createdAt.toAppDateTime();
    final updatedAt = sighting.updatedAt?.toAppDateTime();

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
                  Text(
                    sighting.playerPlatformId,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(sighting.inGameName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(sighting.tribeName, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.platformLabel(
                      sighting.platform.label(context),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.visibilityLabel(
                      sighting.creatorLevel.label(context),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.sharingLabel(
                      sighting.sharingScope.label(context),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(createdAt, style: theme.textTheme.bodySmall),
                  if (updatedAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.editedAtLabel(updatedAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  if (!sighting.isVisible) ...[
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.softDeleted,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    if (sighting.deleteReason != null &&
                        sighting.deleteReason!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.reasonLabel(sighting.deleteReason!),
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
}
