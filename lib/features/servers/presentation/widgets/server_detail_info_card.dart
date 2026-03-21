// features/servers/presentation/widgets/server_detail_info_card.dart
import 'package:flutter/material.dart';

import 'server_detail_row.dart';

class ServerDetailInfoCard extends StatelessWidget {
  const ServerDetailInfoCard({
    super.key,
    required this.mapLabel,
    required this.mapValue,
    required this.populationLabel,
    required this.populationValue,
    required this.typeLabel,
    required this.typeValue,
  });

  final String mapLabel;
  final String mapValue;
  final String populationLabel;
  final String populationValue;
  final String typeLabel;
  final String typeValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ServerDetailRow(label: mapLabel, value: mapValue),
          const Divider(height: 1),
          ServerDetailRow(label: populationLabel, value: populationValue),
          const Divider(height: 1),
          ServerDetailRow(label: typeLabel, value: typeValue),
        ],
      ),
    );
  }
}
