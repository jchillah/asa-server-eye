// features/servers/presentation/widgets/server_sync_status_placeholder_card.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';

class ServerSyncStatusPlaceholderCard extends StatelessWidget {
  const ServerSyncStatusPlaceholderCard.loading({super.key})
    : _isLoading = true;

  const ServerSyncStatusPlaceholderCard.error({super.key}) : _isLoading = false;

  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isLoading
                ? context.l10n.serverSyncLoading
                : context.l10n.serverSyncUnavailable,
            style: theme.textTheme.bodyMedium,
          ),
          if (_isLoading) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(minHeight: 4),
          ],
        ],
      ),
    );
  }
}
