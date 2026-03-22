// features/servers/presentation/widgets/server_list_item.dart
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/server.dart';
import 'server_info_chip.dart';

class ServerListItem extends StatelessWidget {
  const ServerListItem({
    super.key,
    required this.server,
    required this.officialLabel,
    required this.unofficialLabel,
    required this.onTap,
  });

  final Server server;
  final String officialLabel;
  final String unofficialLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: AppColors.neonGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.public_rounded, color: AppColors.neonGreen),
        ),
        title: Text(server.name, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
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
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
