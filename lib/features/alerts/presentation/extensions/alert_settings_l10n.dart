// features/alerts/presentation/extensions/alert_settings_l10n.dart
import '../../../../l10n/app_localizations.dart';

extension AlertSettingsL10n on AppLocalizations {
  String get _languageCode => localeName.split('_').first;

  String get deleteAllAlertRules {
    switch (_languageCode) {
      case 'de':
        return 'Alle löschen';
      case 'es':
        return 'Eliminar todo';
      case 'fr':
        return 'Tout supprimer';
      case 'zh':
        return '全部删除';
      case 'en':
      default:
        return 'Delete all';
    }
  }

  String get deleteAllAlertRulesQuestion {
    switch (_languageCode) {
      case 'de':
        return 'Möchtest du alle Alert-Regeln für diesen Server löschen?';
      case 'es':
        return '¿Quieres eliminar todas las reglas de alerta de este servidor?';
      case 'fr':
        return 'Voulez-vous supprimer toutes les règles d’alerte pour ce serveur ?';
      case 'zh':
        return '要删除此服务器的所有提醒规则吗？';
      case 'en':
      default:
        return 'Do you want to delete all alert rules for this server?';
    }
  }

  String get allAlertRulesDeleted {
    switch (_languageCode) {
      case 'de':
        return 'Alle Alert-Regeln gelöscht.';
      case 'es':
        return 'Todas las reglas de alerta se han eliminado.';
      case 'fr':
        return 'Toutes les règles d’alerte ont été supprimées.';
      case 'zh':
        return '已删除所有提醒规则。';
      case 'en':
      default:
        return 'All alert rules deleted.';
    }
  }
}
