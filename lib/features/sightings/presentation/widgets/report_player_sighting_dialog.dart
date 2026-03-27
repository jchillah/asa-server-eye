// features/sightings/presentation/widgets/report_player_sighting_dialog.dart
import 'package:flutter/material.dart';

class ReportPlayerSightingDialog extends StatefulWidget {
  const ReportPlayerSightingDialog({super.key});

  @override
  State<ReportPlayerSightingDialog> createState() =>
      _ReportPlayerSightingDialogState();
}

class _ReportPlayerSightingDialogState
    extends State<ReportPlayerSightingDialog> {
  final _playerNameController = TextEditingController();
  final _playerIdController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _playerNameController.dispose();
    _playerIdController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      _ReportPlayerSightingResult(
        playerName: _playerNameController.text.trim(),
        playerId: _playerIdController.text.trim(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report player sighting'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _playerNameController,
                decoration: const InputDecoration(
                  labelText: 'Player name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Please enter a player name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _playerIdController,
                decoration: const InputDecoration(
                  labelText: 'Platform ID (Steam / Xbox / PSN)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Please enter a platform ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noteController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}

class _ReportPlayerSightingResult {
  const _ReportPlayerSightingResult({
    required this.playerName,
    required this.playerId,
    required this.note,
  });

  final String playerName;
  final String playerId;
  final String? note;
}

Future<(String playerName, String playerId, String? note)?>
showReportPlayerSightingDialog(BuildContext context) async {
  final result = await showDialog<_ReportPlayerSightingResult>(
    context: context,
    builder: (_) => const ReportPlayerSightingDialog(),
  );

  if (result == null) {
    return null;
  }

  return (result.playerName, result.playerId, result.note);
}
