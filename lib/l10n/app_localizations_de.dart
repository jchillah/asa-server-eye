// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ASA Server Eye';

  @override
  String get servers => 'Server';

  @override
  String get favorites => 'Favoriten';

  @override
  String get settings => 'Einstellungen';

  @override
  String get searchServersOrMaps => 'Server oder Karten suchen';

  @override
  String get noServersFound => 'Keine Server gefunden';

  @override
  String get noServersMatchSearch => 'Keine Server passen zu deiner Suche';

  @override
  String get serverDetails => 'Serverdetails';

  @override
  String get serverNotFound => 'Server nicht gefunden';

  @override
  String get map => 'Karte';

  @override
  String get population => 'Population';

  @override
  String get type => 'Typ';

  @override
  String get official => 'Offiziell';

  @override
  String get unofficial => 'Inoffiziell';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get addedToFavorites => 'Zu Favoriten hinzugefügt';

  @override
  String get removedFromFavorites => 'Aus Favoriten entfernt';

  @override
  String get noFavoritesYet => 'Noch keine Favoriten vorhanden';

  @override
  String get removeFavorite => 'Favorit entfernen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get remove => 'Entfernen';

  @override
  String removeFavoriteQuestion(String serverName) {
    return 'Möchtest du „$serverName“ aus den Favoriten entfernen?';
  }

  @override
  String removedServerFromFavorites(String serverName) {
    return '$serverName wurde aus den Favoriten entfernt';
  }

  @override
  String get general => 'Allgemein';

  @override
  String get language => 'Sprache';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get about => 'Über die App';

  @override
  String get appInformation => 'App-Informationen';

  @override
  String get legal => 'Rechtliches';

  @override
  String get privacyPolicy => 'Datenschutz';

  @override
  String get howDataIsHandled => 'Wie Daten verarbeitet werden';

  @override
  String get imprint => 'Impressum';

  @override
  String get legalInformation => 'Rechtliche Informationen';

  @override
  String get support => 'Support';

  @override
  String get getHelpAndContactSupport => 'Hilfe und Kontakt zum Support';

  @override
  String comingSoon(String title) {
    return '$title kommt bald';
  }

  @override
  String get systemLanguage => 'Systemsprache';

  @override
  String get german => 'Deutsch';

  @override
  String get english => 'Englisch';

  @override
  String get selectLanguage => 'Sprache auswählen';
}
