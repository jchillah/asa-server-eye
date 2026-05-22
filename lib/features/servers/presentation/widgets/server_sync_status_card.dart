// features/servers/presentation/widgets/server_sync_status_card.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../presentation/state/server_sync_state.dart';

class ServerSyncStatusCard extends StatelessWidget {
  const ServerSyncStatusCard({super.key, required this.syncState});

  final ServerSyncState syncState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final lastUpdatedText = _buildLastUpdatedText(context, syncState);
    final sourceText = syncState.isFromCache
        ? context.l10n.serverSyncSourceCache
        : context.l10n.serverSyncSourceLive;

    final showCacheBanner = syncState.isFromCache;
    final showStaleHint = syncState.isFromCache && syncState.isStale;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showCacheBanner
              ? colorScheme.outline
              : colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCacheBanner)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                context.l10n.serverSyncCacheBanner,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Text(lastUpdatedText, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(sourceText, style: theme.textTheme.bodySmall),
          if (showStaleHint) ...[
            const SizedBox(height: 6),
            Text(
              context.l10n.serverSyncCacheStale,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildLastUpdatedText(
    BuildContext context,
    ServerSyncState syncState,
  ) {
    final lastUpdatedAt = syncState.lastUpdatedAt;

    if (lastUpdatedAt == null) {
      return context.l10n.serverSyncUnknownUpdateTime;
    }

    final localTime = lastUpdatedAt.toLocal();
    final localizations = MaterialLocalizations.of(context);

    final date = localizations.formatShortDate(localTime);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(localTime),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

    return context.l10n.serverSyncLastUpdated(date, time);
  }
}
