// features/alerts/presentation/extensions/alert_settings_l10n.dart
import '../../../../l10n/app_localizations.dart';

extension AlertSettingsL10n on AppLocalizations {
  String get _languageCode => localeName.split('_').first;

  String get alertsNavLabel {
    switch (_languageCode) {
      case 'de':
        return 'Alerts';
      case 'es':
        return 'Alertas';
      case 'fr':
        return 'Alertes';
      case 'zh':
        return '提醒';
      case 'en':
      default:
        return 'Alerts';
    }
  }

  String get alertsOverviewTitle {
    switch (_languageCode) {
      case 'de':
        return 'Meine Alerts';
      case 'es':
        return 'Mis alertas';
      case 'fr':
        return 'Mes alertes';
      case 'zh':
        return '我的提醒';
      case 'en':
      default:
        return 'My Alerts';
    }
  }

  String get alertRulesTabLabel {
    switch (_languageCode) {
      case 'de':
        return 'Regeln';
      case 'es':
        return 'Reglas';
      case 'fr':
        return 'Règles';
      case 'zh':
        return '规则';
      case 'en':
      default:
        return 'Rules';
    }
  }

  String get alertHistoryTabLabel {
    switch (_languageCode) {
      case 'de':
        return 'History';
      case 'es':
        return 'Historial';
      case 'fr':
        return 'Historique';
      case 'zh':
        return '历史';
      case 'en':
      default:
        return 'History';
    }
  }

  String get noUserAlertRulesYet {
    switch (_languageCode) {
      case 'de':
        return 'Du hast noch keine Alert-Regeln erstellt.';
      case 'es':
        return 'Aún no has creado reglas de alerta.';
      case 'fr':
        return 'Vous n’avez pas encore créé de règles d’alerte.';
      case 'zh':
        return '你还没有创建提醒规则。';
      case 'en':
      default:
        return 'You have not created any alert rules yet.';
    }
  }

  String get noAlertEventsYet {
    switch (_languageCode) {
      case 'de':
        return 'Noch keine Alert-Benachrichtigungen vorhanden.';
      case 'es':
        return 'Aún no hay notificaciones de alerta.';
      case 'fr':
        return 'Aucune notification d’alerte pour le moment.';
      case 'zh':
        return '还没有提醒通知。';
      case 'en':
      default:
        return 'No alert notifications yet.';
    }
  }

  String get alertEventsLoadError {
    switch (_languageCode) {
      case 'de':
        return 'Alert-Benachrichtigungen konnten nicht geladen werden.';
      case 'es':
        return 'No se pudieron cargar las notificaciones de alerta.';
      case 'fr':
        return 'Impossible de charger les notifications d’alerte.';
      case 'zh':
        return '无法加载提醒通知。';
      case 'en':
      default:
        return 'Alert notifications could not be loaded.';
    }
  }

  String get alertEventDeleted {
    switch (_languageCode) {
      case 'de':
        return 'Alert-Benachrichtigung gelöscht.';
      case 'es':
        return 'Notificación de alerta eliminada.';
      case 'fr':
        return 'Notification d’alerte supprimée.';
      case 'zh':
        return '提醒通知已删除。';
      case 'en':
      default:
        return 'Alert notification deleted.';
    }
  }

  String get deleteServerAlertEvents {
    switch (_languageCode) {
      case 'de':
        return 'Server-History löschen';
      case 'es':
        return 'Eliminar historial del servidor';
      case 'fr':
        return 'Supprimer l’historique du serveur';
      case 'zh':
        return '删除服务器历史';
      case 'en':
      default:
        return 'Delete server history';
    }
  }

  String get deleteServerAlertEventsQuestion {
    switch (_languageCode) {
      case 'de':
        return 'Möchtest du alle Alert-Benachrichtigungen für diesen Server löschen?';
      case 'es':
        return '¿Quieres eliminar todas las notificaciones de alerta de este servidor?';
      case 'fr':
        return 'Voulez-vous supprimer toutes les notifications d’alerte pour ce serveur ?';
      case 'zh':
        return '要删除此服务器的所有提醒通知吗？';
      case 'en':
      default:
        return 'Do you want to delete all alert notifications for this server?';
    }
  }

  String get serverAlertEventsDeleted {
    switch (_languageCode) {
      case 'de':
        return 'Server-History gelöscht.';
      case 'es':
        return 'Historial del servidor eliminado.';
      case 'fr':
        return 'Historique du serveur supprimé.';
      case 'zh':
        return '服务器历史已删除。';
      case 'en':
      default:
        return 'Server history deleted.';
    }
  }

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
