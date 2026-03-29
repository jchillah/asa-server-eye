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
  String get repeatPassword => 'Passwort wiederholen';

  @override
  String get passwordsDoNotMatch => 'Die Passwörter stimmen nicht überein';

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
  String get aboutBody => 'ASA Server Eye ist eine Companion-App für ARK: Survival Ascended. Die App zeigt Serverinformationen, unterstützt Favoriten und bildet die Grundlage für spätere Funktionen wie Watchlist, Benachrichtigungen und Premium-Features.\n\nVerantwortlich für Entwicklung und Betrieb:\nMichael Winkler\nE-Mail: asa.server.eye@gmail.com';

  @override
  String get privacyBody => 'Datenschutzerklärung\n\nVerantwortlich für die Datenverarbeitung:\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nE-Mail: asa.server.eye@gmail.com\n\nDiese App verwendet Firebase Authentication zur Anmeldung von Nutzerkonten, Cloud Firestore zum Speichern persönlicher Favoriten sowie Google AdMob zur Auslieferung von Werbung.\n\nDabei können je nach Nutzung technische Daten verarbeitet werden, insbesondere Kontodaten, Geräteinformationen, App-Interaktionen, Kennungen, Diagnoseinformationen und werbebezogene Daten. Favoriten werden nutzerbezogen gespeichert, damit sie nach einem erneuten Start der App und auf mehreren Geräten verfügbar bleiben.\n\nDie Verarbeitung erfolgt zur Bereitstellung der App-Funktionen, zur Authentifizierung, zur Speicherung nutzerbezogener Einstellungen und zur Finanzierung der App über Werbung.\n\nEs kann nicht ausgeschlossen werden, dass eingesetzte Drittanbieter Daten außerhalb der Europäischen Union verarbeiten. Maßgeblich sind insoweit auch die Datenschutzinformationen der jeweils eingebundenen Dienste, insbesondere von Google Firebase und Google AdMob.\n\nBei Fragen zum Datenschutz oder zur Löschung deiner Daten kontaktiere bitte:\nasa.server.eye@gmail.com\n\nHinweis: Vor einem endgültigen öffentlichen Release sollte diese Datenschutzerklärung noch einmal rechtlich geprüft und um vollständige Angaben zu Rechtsgrundlagen, Speicherdauer, Betroffenenrechten und allen eingebundenen Diensten ergänzt werden.';

  @override
  String get imprintBody => 'Impressum\n\nAngaben gemäß § 5 TMG / § 18 MStV\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nDeutschland\n\nE-Mail:\nasa.server.eye@gmail.com\n\nVerantwortlich für den Inhalt:\nMichael Winkler';

  @override
  String get supportBody => 'Support\n\nBei Fragen, Problemen oder Feedback zur App kontaktiere bitte:\n\nMichael Winkler\nE-Mail: asa.server.eye@gmail.com\n\nBitte beschreibe dein Problem möglichst genau und nenne dabei möglichst auch dein Gerät sowie die verwendete App-Version.';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get emailAppCouldNotBeOpened => 'E-Mail-App konnte nicht geöffnet werden.';

  @override
  String get supportEmailSubject => 'ASA Server Eye Support';

  @override
  String get supportEmailBodyTemplate => 'Hallo Michael,\n\nich habe folgendes Problem:\n\n\n---\nApp-Version:\nGerät:\n';

  @override
  String get fullPrivacyPolicy => 'Vollständige Datenschutzerklärung';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get profile => 'Profil';

  @override
  String get profileLoadError => 'Profil konnte nicht geladen werden.';

  @override
  String get username => 'Benutzername';

  @override
  String get accessLevel => 'Zugriffslevel';

  @override
  String get save => 'Speichern';

  @override
  String get profileSavedSuccessfully => 'Profil erfolgreich gespeichert.';

  @override
  String get profileSaveError => 'Profil konnte nicht gespeichert werden.';

  @override
  String get profileDeleteError => 'Konto konnte nicht gelöscht werden.';

  @override
  String get deleteAccountHint => 'Beim Löschen wird das Profil entfernt. Bereits erstellte Sightings bleiben erhalten.';

  @override
  String savedFavoritesCount(int count) {
    return '$count gespeichert';
  }

  @override
  String get usernameEmpty => 'Bitte gib einen Benutzernamen ein.';

  @override
  String get usernameTooShort => 'Der Benutzername muss mindestens 3 Zeichen lang sein.';

  @override
  String get usernameTooLong => 'Der Benutzername darf maximal 20 Zeichen lang sein.';

  @override
  String get usernameInvalidCharacters => 'Der Benutzername darf nur Buchstaben, Zahlen, Punkt, Unterstrich und Bindestrich enthalten.';

  @override
  String get deleteAccountDialogTitle => 'Konto löschen';

  @override
  String deleteAccountDialogDescription(String email) {
    return 'Bitte gib dein Passwort für $email ein, um den Account zu löschen.';
  }
}
