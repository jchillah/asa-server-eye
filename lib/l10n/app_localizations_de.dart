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
  String get apply => 'Anwenden';

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
  String get systemLanguage => 'Systemsprache';

  @override
  String get german => 'Deutsch';

  @override
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get chinese => 'Chinesisch';

  @override
  String get selectLanguage => 'Sprache auswählen';

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
  String get french => 'Französisch';

  @override
  String get genericError => 'Ein Fehler ist aufgetreten. Bitte versuche es erneut.';

  @override
  String get loading => 'Lädt';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signUp => 'Registrieren';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get signInToContinue => 'Melde dich an, um mit deinen gespeicherten Daten fortzufahren.';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get createYourAccount => 'Erstelle dein Konto';

  @override
  String get signUpToSaveFavorites => 'Registriere dich, um deine Favoriten geräteübergreifend zu speichern.';

  @override
  String get account => 'Konto';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutDescription => 'Von deinem aktuellen Konto abmelden';

  @override
  String get authMissingEmailOrPassword => 'Bitte gib E-Mail und Passwort ein.';

  @override
  String get authInvalidEmailFormat => 'Bitte gib eine gültige E-Mail-Adresse ein.';

  @override
  String get authUserDisabled => 'Dieses Konto wurde deaktiviert.';

  @override
  String get authInvalidCredentials => 'E-Mail oder Passwort ist ungültig.';

  @override
  String get networkError => 'Netzwerkfehler. Bitte versuche es erneut.';

  @override
  String get authWeakPassword => 'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get authEmailAlreadyInUse => 'Diese E-Mail wird bereits verwendet.';

  @override
  String get aboutBody => 'ASA Server Eye ist eine Companion-App für ARK: Survival Ascended. Die App zeigt Serverinformationen, unterstützt Favoriten und bildet die Grundlage für spätere Funktionen wie Watchlist, Benachrichtigungen und Premium-Features.';

  @override
  String get privacyBody => 'Datenschutzhinweis\n\nDiese App verwendet Firebase Authentication zur Anmeldung von Nutzerkonten, Cloud Firestore zum Speichern persönlicher Favoriten sowie Google AdMob zur Auslieferung von Werbung.\n\nJe nach Nutzung können dabei technische Daten wie Geräteinformationen, App-Interaktionen, ungefähre Standortdaten, Kennungen oder Diagnosedaten verarbeitet werden. Ein Teil dieser Daten kann durch integrierte Drittanbieter-SDKs verarbeitet werden.\n\nFavoriten werden nutzerbezogen gespeichert, damit sie nach dem erneuten Start der App und auf mehreren Geräten verfügbar bleiben.\n\nVor dem Release musst du diesen Text durch eine vollständige, rechtskonforme Datenschutzerklärung mit deinem Namen/Firmennamen, Kontaktadresse, Verantwortlichem, Rechtsgrundlagen, Drittanbieter-Auflistung, Löschfristen und Betroffenenrechten ersetzen.';

  @override
  String get imprintBody => 'Impressum\n\nAngaben gemäß § 5 TMG / § 18 MStV\n\nName / Firma:\n[DEIN NAME ODER FIRMENNAME]\n\nAnschrift:\n[DEINE VOLLSTÄNDIGE ANSCHRIFT]\n\nE-Mail:\n[DEINE KONTAKT-E-MAIL]\n\nVerantwortlich für den Inhalt:\n[DEIN NAME]\n\nHinweis: Vor dem Release musst du diese Platzhalter vollständig durch deine echten Pflichtangaben ersetzen.';

  @override
  String get supportBody => 'Support\n\nBei Fragen, Problemen oder Feedback kontaktiere uns bitte unter:\n[DEINE SUPPORT-E-MAIL]\n\nOptional kannst du hier später zusätzlich eine Support-Webseite, FAQ oder Discord-/Community-Links ergänzen.';
}
