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
    return 'Bitte gib dein Passwort für $email ein, um dein Konto zu löschen.';
  }

  @override
  String get signUpUsernameHint => 'Dein Name im ASA Server Eye';

  @override
  String get emailHint => 'name@email.com';

  @override
  String get sightings => 'Sichtungen';

  @override
  String get playerSightingReport => 'Spielersichtung melden';

  @override
  String get editSighting => 'Sichtung bearbeiten';

  @override
  String get deleteSighting => 'Sichtung löschen';

  @override
  String get sightingHistory => 'Änderungsverlauf';

  @override
  String get platformId => 'Plattform-ID';

  @override
  String get platformIdHint => 'Steam / Xbox / PSN ID';

  @override
  String get inGameName => 'Ingame-Name';

  @override
  String get tribeName => 'Tribe-Name';

  @override
  String get tribeNameHint => 'Name des Tribes';

  @override
  String get platform => 'Plattform';

  @override
  String get note => 'Notiz';

  @override
  String get optional => 'Optional';

  @override
  String get visibleToPremiumUsers => 'Für andere Premium-User sichtbar';

  @override
  String get saveSighting => 'Sichtung speichern';

  @override
  String get updateSighting => 'Änderungen speichern';

  @override
  String get hideSighting => 'Sichtung ausblenden';

  @override
  String get saving => 'Speichert...';

  @override
  String get sightingSaved => 'Sichtung gespeichert.';

  @override
  String get sightingUpdated => 'Sichtung aktualisiert.';

  @override
  String get sightingHidden => 'Sichtung ausgeblendet.';

  @override
  String get sightingSaveError => 'Sichtung konnte nicht gespeichert werden.';

  @override
  String get sightingUpdateError => 'Sichtung konnte nicht aktualisiert werden.';

  @override
  String get sightingHideError => 'Sichtung konnte nicht ausgeblendet werden.';

  @override
  String get sightingRequiresLogin => 'Du musst eingeloggt sein, um eine Sichtung zu melden.';

  @override
  String get sightingDeleteNotAllowed => 'Du darfst diese Sichtung nicht löschen.';

  @override
  String get sightingEditNotAllowed => 'Du darfst diese Sichtung nicht bearbeiten.';

  @override
  String get sightingInGameNameRequired => 'Bitte Spielernamen eingeben.';

  @override
  String get sightingPlatformIdRequired => 'Bitte Plattform-ID eingeben.';

  @override
  String get sightingTribeNameRequired => 'Bitte Tribe-Namen eingeben.';

  @override
  String get sightingReasonRequired => 'Bitte Grund angeben.';

  @override
  String get sightingDeleteHint => 'Die Sichtung wird nicht endgültig gelöscht. Sie wird nur für normale Nutzer ausgeblendet und bleibt für Admins nachvollziehbar.';

  @override
  String get reason => 'Grund';

  @override
  String get reasonHint => 'Bitte Grund angeben';

  @override
  String get noVisibleSightings => 'Noch keine sichtbaren Sightings vorhanden.';

  @override
  String get sightingsLoadError => 'Sightings konnten nicht geladen werden.';

  @override
  String get sightingHistoryLoadError => 'Verlauf konnte nicht geladen werden.';

  @override
  String get noSightingHistory => 'Noch kein Verlauf vorhanden.';

  @override
  String get accessLevelLoadError => 'Zugriffslevel konnte nicht geladen werden.';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get viewHistory => 'Verlauf ansehen';

  @override
  String get platformSteam => 'Steam';

  @override
  String get platformXbox => 'Xbox';

  @override
  String get platformPsn => 'PSN';

  @override
  String get platformUnknown => 'Unbekannt';

  @override
  String get sightingUserProfileLoadError => 'Benutzerprofil konnte nicht geladen werden.';

  @override
  String get playerSightings => 'Spielersichtungen';

  @override
  String platformLabel(String value) {
    return 'Plattform: $value';
  }

  @override
  String visibilityLabel(String value) {
    return 'Sichtbarkeit: $value';
  }

  @override
  String sharingLabel(String value) {
    return 'Freigabe: $value';
  }

  @override
  String editedAtLabel(String value) {
    return 'Bearbeitet: $value';
  }

  @override
  String get softDeleted => 'Soft gelöscht';

  @override
  String reasonLabel(String value) {
    return 'Grund: $value';
  }

  @override
  String changedByLabel(String value) {
    return 'Geändert von: $value';
  }

  @override
  String get sightingCreatorLevelFree => 'Free';

  @override
  String get sightingCreatorLevelPremium => 'Premium';

  @override
  String get sightingCreatorLevelAdmin => 'Admin';

  @override
  String get sightingSharingOwnerOnly => 'Nur Ersteller';

  @override
  String get sightingSharingPremiumShared => 'Mit Premium geteilt';

  @override
  String get sightingSharingAdminOnly => 'Nur Admins';

  @override
  String get sightingActionCreated => 'Erstellt';

  @override
  String get sightingActionUpdated => 'Bearbeitet';

  @override
  String get sightingActionSoftDeleted => 'Ausgeblendet';

  @override
  String get viewPlayerSightings => 'Spielersichtungen ansehen';

  @override
  String get reportPlayerSighting => 'Spielersichtung melden';

  @override
  String get accountCreated => 'Konto erfolgreich erstellt';

  @override
  String get accountCreationFailed => 'Konto konnte nicht erstellt werden. Bitte versuche es erneut.';

  @override
  String get accountDeleted => 'Konto erfolgreich gelöscht';

  @override
  String get accountDeletionFailed => 'Konto konnte nicht gelöscht werden. Bitte versuche es erneut.';

  @override
  String get deletePermanently => 'Endgültig löschen';

  @override
  String get deletePermanentlyConfirmation => 'Diese Sichtung und ihre Historie werden dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get sightingDeletedPermanently => 'Sichtung dauerhaft gelöscht';

  @override
  String get premiumRequiredForMoreFavorites => 'Für mehr als einen Favoriten benötigst du Premium.';

  @override
  String get serversNavLabel => 'Server';

  @override
  String get favoritesNavLabel => 'Favoriten';

  @override
  String get sightingsNavLabel => 'Sichtungen';

  @override
  String get settingsNavLabel => 'Settings';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumSettingsSubtitle => 'Premium freischalten und verwalten';

  @override
  String get premiumHeadline => 'Schalte Premium frei';

  @override
  String get premiumDescription => 'Mit Premium erhältst du Zugriff auf Spielersichtungen, mehr Favoriten und zukünftige Premium-Funktionen.';

  @override
  String get premiumBenefitSightingsTitle => 'Spielersichtungen';

  @override
  String get premiumBenefitSightingsDescription => 'Greife direkt über die Navigation auf Sichtungen zu und nutze Premium-Zugriff im gesamten Bereich.';

  @override
  String get premiumBenefitFavoritesTitle => 'Mehr Favoriten';

  @override
  String get premiumBenefitFavoritesDescription => 'Speichere deutlich mehr Server in deinen Favoriten.';

  @override
  String get premiumBenefitAlertsTitle => 'Zukünftige Extras';

  @override
  String get premiumBenefitAlertsDescription => 'Bereite dich auf kommende Premium-Funktionen wie erweiterte Beobachtung und Alarme vor.';

  @override
  String get premiumMonthlyPlan => 'Monatlich';

  @override
  String get premiumMonthlyPlanDescription => 'Flexibel kündbar';

  @override
  String get premiumYearlyPlan => 'Jährlich';

  @override
  String get premiumYearlyPlanDescription => 'Bester Wert für langfristige Nutzung';

  @override
  String get premiumStartMonthly => 'Monatlich starten';

  @override
  String get premiumStartYearly => 'Jährlich starten';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get premiumPurchaseComingSoon => 'Der Kauf-Flow wird als Nächstes angebunden.';

  @override
  String get premiumUpgradeTitle => 'Upgrade auf Premium';

  @override
  String get premiumUpgradeDescription => 'Schalte den Sightings-Tab und weitere Premium-Vorteile frei.';

  @override
  String get premiumActiveTitle => 'Premium aktiv';

  @override
  String get premiumActiveDescription => 'Dein Konto hat bereits Zugriff auf Premium-Funktionen.';

  @override
  String get unlockPremium => 'Premium freischalten';

  @override
  String get managePremium => 'Premium verwalten';

  @override
  String get premiumStoreUnavailable => 'Der Store ist aktuell nicht verfügbar.';

  @override
  String get premiumProductsUnavailable => 'Aktuell konnten keine Premium-Produkte geladen werden.';

  @override
  String get premiumPurchaseError => 'Beim Kauf ist ein Fehler aufgetreten. Bitte versuche es erneut.';

  @override
  String get premiumRestoreSuccess => 'Käufe erfolgreich wiederhergestellt.';

  @override
  String get premiumRestoreError => 'Beim Wiederherstellen der Käufe ist ein Fehler aufgetreten. Bitte versuche es erneut.';

  @override
  String get premiumPurchasePending => 'Dein Kauf wird verarbeitet. Premium wird nach erfolgreicher Verifikation freigeschaltet.';

  @override
  String get premiumExpiredDescription => 'Dein Premium-Zugang ist abgelaufen. Du kannst jederzeit erneut Premium freischalten.';
}
