// features/settings/presentation/widgets/language_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_l10n.dart';
import '../../../../core/presentation/l10n/app_language.dart';
import '../../../../core/presentation/l10n/locale_controller.dart';

Future<void> showLanguageDialog(BuildContext context, WidgetRef ref) async {
  final controller = ref.read(localeControllerProvider.notifier);
  final currentLocale = ref.read(localeControllerProvider);

  final currentOption = optionFromLocale(currentLocale);

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(context.l10n.selectLanguage),
        content: RadioGroup<AppLanguageOption>(
          groupValue: currentOption,
          onChanged: (value) {
            if (value == null) return;

            controller.setLocale(localeFromOption(value));
            Navigator.of(dialogContext).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppLanguageOption>(
                value: AppLanguageOption.system,
                title: Text(context.l10n.systemLanguage),
              ),
              RadioListTile<AppLanguageOption>(
                value: AppLanguageOption.german,
                title: Text(context.l10n.german),
              ),
              RadioListTile<AppLanguageOption>(
                value: AppLanguageOption.english,
                title: Text(context.l10n.english),
              ),
              RadioListTile<AppLanguageOption>(
                value: AppLanguageOption.spanish,
                title: Text(context.l10n.spanish),
              ),
              RadioListTile<AppLanguageOption>(
                value: AppLanguageOption.french,
                title: Text(context.l10n.french),
              ),
              RadioListTile<AppLanguageOption>(
                value: AppLanguageOption.chinese,
                title: Text(context.l10n.chinese),
              ),
            ],
          ),
        ),
      );
    },
  );
}
