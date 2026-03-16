// core/presentation/l10n/locale_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale?>((ref) {
      return LocaleController();
    });

class LocaleController extends StateNotifier<Locale?> {
  LocaleController() : super(null);

  void useSystemLocale() {
    state = null;
  }

  void setGerman() {
    state = const Locale('de');
  }

  void setEnglish() {
    state = const Locale('en');
  }
}
