// features/servers/presentation/widgets/server_detail_header_card.dart
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/server.dart';
import 'server_info_chip.dart';

class ServerDetailHeaderCard extends StatelessWidget {
  const ServerDetailHeaderCard({
    super.key,
    required this.server,
    required this.officialLabel,
    required this.unofficialLabel,
  });

  final Server server;
  final String officialLabel;
  final String unofficialLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.dns_rounded,
                color: AppColors.neonGreen,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(server.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ServerInfoChip(label: server.map),
                ServerInfoChip(label: '${server.players}/${server.maxPlayers}'),
                ServerInfoChip(
                  label: server.official ? officialLabel : unofficialLabel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
