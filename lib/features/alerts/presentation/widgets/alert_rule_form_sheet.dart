// features/alerts/presentation/widgets/alert_rule_form_sheet.dart
import 'package:flutter/material.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../domain/entities/alert_rule.dart';
import '../../domain/entities/alert_rule_type.dart';
import '../extensions/alert_rule_type_l10n.dart';

class AlertRuleFormSheet extends StatefulWidget {
  const AlertRuleFormSheet({
    super.key,
    required this.userId,
    required this.serverId,
    required this.serverName,
    required this.mapName,
    this.existingRule,
  });

  final String userId;
  final String serverId;
  final String serverName;
  final String mapName;
  final AlertRule? existingRule;

  @override
  State<AlertRuleFormSheet> createState() => _AlertRuleFormSheetState();
}

class _AlertRuleFormSheetState extends State<AlertRuleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _thresholdController;
  late AlertRuleType _selectedType;
  late bool _isEnabled;

  bool get _requiresThreshold =>
      _selectedType == AlertRuleType.crossedAboveThreshold ||
      _selectedType == AlertRuleType.crossedBelowThreshold;

  bool get _isEditing => widget.existingRule != null;

  @override
  void initState() {
    super.initState();
    _selectedType =
        widget.existingRule?.ruleType ?? AlertRuleType.populationIncreased;
    _isEnabled = widget.existingRule?.isEnabled ?? true;
    _thresholdController = TextEditingController(
      text: widget.existingRule?.threshold?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEditing ? l10n.editAlertRule : l10n.addAlertRule,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<AlertRuleType>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: l10n.alertRuleType,
                    border: const OutlineInputBorder(),
                  ),
                  items: AlertRuleType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.localizedLabel(context)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedType = value;
                      if (!_requiresThreshold) {
                        _thresholdController.clear();
                      }
                    });
                  },
                ),
                if (_requiresThreshold) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _thresholdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.alertRuleThreshold,
                      hintText: l10n.alertRuleThresholdHint,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (!_requiresThreshold) return null;
                      if (value == null || value.trim().isEmpty) {
                        return l10n.alertRuleThresholdRequired;
                      }
                      final parsed = int.tryParse(value.trim());
                      if (parsed == null || parsed < 0) {
                        return l10n.alertRuleThresholdInvalid;
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.alertRuleEnabled),
                  value: _isEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isEnabled = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _submit,
                        child: Text(
                          _isEditing
                              ? l10n.updateAlertRule
                              : l10n.saveAlertRule,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final threshold = _requiresThreshold
        ? int.parse(_thresholdController.text.trim())
        : null;
    final existingRule = widget.existingRule;
    final now = DateTime.now();

    final rule = AlertRule(
      id: existingRule?.id ?? '',
      userId: widget.userId,
      serverId: widget.serverId,
      serverName: widget.serverName,
      mapName: widget.mapName,
      ruleType: _selectedType,
      isEnabled: _isEnabled,
      threshold: threshold,
      createdAt: existingRule?.createdAt ?? now,
      updatedAt: existingRule?.updatedAt ?? now,
      lastTriggeredAt: existingRule?.lastTriggeredAt,
    );

    Navigator.of(context).pop(rule);
  }
}
