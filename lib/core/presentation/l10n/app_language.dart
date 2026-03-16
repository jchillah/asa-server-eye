// core/presentation/l10n/app_language.dart
import 'package:flutter/material.dart';

enum AppLanguageOption { system, german, english, spanish, chinese }

Locale? localeFromOption(AppLanguageOption option) {
  switch (option) {
    case AppLanguageOption.system:
      return null;
    case AppLanguageOption.german:
      return const Locale('de');
    case AppLanguageOption.english:
      return const Locale('en');
    case AppLanguageOption.spanish:
      return const Locale('es');
    case AppLanguageOption.chinese:
      return const Locale('zh');
  }
}

AppLanguageOption optionFromLocale(Locale? locale) {
  switch (locale?.languageCode) {
    case 'de':
      return AppLanguageOption.german;
    case 'en':
      return AppLanguageOption.english;
    case 'es':
      return AppLanguageOption.spanish;
    case 'zh':
      return AppLanguageOption.chinese;
    default:
      return AppLanguageOption.system;
  }
}
