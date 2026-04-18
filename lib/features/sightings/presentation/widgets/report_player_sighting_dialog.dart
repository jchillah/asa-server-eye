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
  final _inGameNameController = TextEditingController();
  final _playerPlatformIdController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _inGameNameController.dispose();
    _playerPlatformIdController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      _ReportPlayerSightingResult(
        inGameName: _inGameNameController.text.trim(),
        playerPlatformId: _playerPlatformIdController.text.trim(),
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
                controller: _inGameNameController,
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
                controller: _playerPlatformIdController,
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
    required this.inGameName,
    required this.playerPlatformId,
    required this.note,
  });

  final String inGameName;
  final String playerPlatformId;
  final String? note;
}

Future<(String inGameName, String playerPlatformId, String? note)?>
showReportPlayerSightingDialog(BuildContext context) async {
  final result = await showDialog<_ReportPlayerSightingResult>(
    context: context,
    builder: (_) => const ReportPlayerSightingDialog(),
  );

  if (result == null) {
    return null;
  }

  return (result.inGameName, result.playerPlatformId, result.note);
}
