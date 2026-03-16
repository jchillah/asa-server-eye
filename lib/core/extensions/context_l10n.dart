// core/extensions/context_l10n.dart
import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

extension ContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
