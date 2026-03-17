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
  String get aboutBody => 'ASA Server Eye is a companion app for ARK: Survival Ascended. The app displays server information, supports favorites, and provides the foundation for future features like watchlists, notifications, and premium features.';

  @override
  String get privacyBody => 'Privacy Notice\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve advertising.\n\nDepending on how the app is used, technical data such as device information, app interactions, approximate location, identifiers, or diagnostic data may be processed. Some of this data may be processed by integrated third-party SDKs.\n\nFavorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nBefore release, replace this text with a complete privacy policy containing your real legal details, controller information, legal bases, third-party services, retention periods, and user rights.';

  @override
  String get imprintBody => 'Imprint / Legal Notice\n\nInformation according to applicable legal requirements\n\nName / Company:\n[YOUR NAME OR COMPANY NAME]\n\nAddress:\n[YOUR FULL ADDRESS]\n\nEmail:\n[YOUR CONTACT EMAIL]\n\nResponsible for content:\n[YOUR NAME]\n\nNote: Before release, replace all placeholders with your real legal information.';

  @override
  String get supportBody => 'Support\n\nFor questions, issues, or feedback, please contact us at:\n[YOUR SUPPORT EMAIL]\n\nLater, you can also add a support website, FAQ, or community links here.';
}
