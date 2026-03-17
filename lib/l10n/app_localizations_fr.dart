// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ASA Server Eye';

  @override
  String get servers => 'Serveurs';

  @override
  String get favorites => 'Favoris';

  @override
  String get settings => 'Paramètres';

  @override
  String get searchServersOrMaps => 'Rechercher des serveurs ou des cartes';

  @override
  String get noServersFound => 'Aucun serveur trouvé';

  @override
  String get noServersMatchSearch => 'Aucun serveur ne correspond à votre recherche';

  @override
  String get serverDetails => 'Détails du serveur';

  @override
  String get serverNotFound => 'Serveur introuvable';

  @override
  String get map => 'Carte';

  @override
  String get population => 'Population';

  @override
  String get type => 'Type';

  @override
  String get official => 'Officiel';

  @override
  String get unofficial => 'Non officiel';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get addedToFavorites => 'Ajouté aux favoris';

  @override
  String get removedFromFavorites => 'Retiré des favoris';

  @override
  String get noFavoritesYet => 'Aucun favori pour le moment';

  @override
  String get removeFavorite => 'Retirer le favori';

  @override
  String get cancel => 'Annuler';

  @override
  String get remove => 'Retirer';

  @override
  String get apply => 'Appliquer';

  @override
  String removeFavoriteQuestion(String serverName) {
    return 'Voulez-vous retirer « $serverName » des favoris ?';
  }

  @override
  String removedServerFromFavorites(String serverName) {
    return '$serverName a été retiré des favoris';
  }

  @override
  String get general => 'Général';

  @override
  String get language => 'Langue';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String get german => 'Allemand';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get chinese => 'Chinois';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get about => 'À propos';

  @override
  String get appInformation => 'Informations sur l\'application';

  @override
  String get legal => 'Mentions légales';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get howDataIsHandled => 'Comment les données sont traitées';

  @override
  String get imprint => 'Mentions légales';

  @override
  String get legalInformation => 'Informations légales';

  @override
  String get support => 'Support';

  @override
  String get getHelpAndContactSupport => 'Obtenir de l\'aide et contacter le support';

  @override
  String comingSoon(String title) {
    return '$title arrive bientôt';
  }

  @override
  String get french => 'Français';

  @override
  String get genericError => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get loading => 'Chargement';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInToContinue => 'Connectez-vous pour continuer avec vos données enregistrées.';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createYourAccount => 'Créez votre compte';

  @override
  String get signUpToSaveFavorites => 'Inscrivez-vous pour enregistrer vos favoris sur tous vos appareils.';

  @override
  String get account => 'Compte';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signOutDescription => 'Se déconnecter du compte actuel';

  @override
  String get authMissingEmailOrPassword => 'Veuillez saisir votre e-mail et votre mot de passe.';

  @override
  String get authInvalidEmailFormat => 'Veuillez saisir une adresse e-mail valide.';

  @override
  String get authUserDisabled => 'Ce compte a été désactivé.';

  @override
  String get authInvalidCredentials => 'E-mail ou mot de passe invalide.';

  @override
  String get networkError => 'Erreur réseau. Veuillez réessayer.';

  @override
  String get authWeakPassword => 'Le mot de passe doit contenir au moins 6 caractères.';

  @override
  String get authEmailAlreadyInUse => 'Cet e-mail est déjà utilisé.';

  @override
  String get aboutBody => 'ASA Server Eye is a companion app for ARK: Survival Ascended. The app shows server information, supports favorites, and provides the foundation for future features such as watchlists, notifications, and premium features.\n\nDeveloped and operated by:\nMichael Winkler\nEmail: michael.winkler.developer@gmail.com';

  @override
  String get privacyBody => 'Privacy Policy\n\nController responsible for data processing:\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\nEmail: michael.winkler.developer@gmail.com\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve ads.\n\nDepending on how the app is used, technical data may be processed, including account data, device information, app interactions, identifiers, diagnostics, and advertising-related data. Favorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nProcessing is carried out to provide app functionality, authenticate users, store user-related settings, and finance the app through advertising.\n\nIt cannot be ruled out that integrated third-party services process data outside the European Union. In this respect, the privacy information of the respective services applies, especially Google Firebase and Google AdMob.\n\nFor privacy-related questions or deletion requests, please contact:\nmichael.winkler.developer@gmail.com\n\nNote: Before a final public release, this privacy policy should be reviewed and expanded with full details on legal bases, retention periods, user rights, and all integrated services.';

  @override
  String get imprintBody => 'Imprint / Legal Notice\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\n\nEmail:\nmichael.winkler.developer@gmail.com\n\nResponsible for content:\nMichael Winkler';

  @override
  String get supportBody => 'Support\n\nFor questions, issues, or feedback about the app, please contact:\n\nMichael Winkler\nEmail: michael.winkler.developer@gmail.com\n\nPlease describe your issue as precisely as possible and include your device and app version if available.';
}
