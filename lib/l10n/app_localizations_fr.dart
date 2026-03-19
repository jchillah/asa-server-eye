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
  String get aboutBody => 'ASA Server Eye est une application compagnon pour ARK: Survival Ascended. L’application affiche des informations sur les serveurs, prend en charge les favoris et constitue la base de futures fonctionnalités telles que les listes de surveillance, les notifications et les fonctionnalités premium.\n\nDéveloppé et exploité par :\nMichael Winkler\nE-mail : michael.winkler.developer@gmail.com';

  @override
  String get privacyBody => 'Politique de confidentialité\n\nResponsable du traitement des données :\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nAllemagne\nE-mail : michael.winkler.developer@gmail.com\n\nCette application utilise Firebase Authentication pour la connexion aux comptes, Cloud Firestore pour stocker les favoris personnels et Google AdMob pour diffuser des publicités.\n\nSelon l’utilisation de l’application, des données techniques peuvent être traitées, notamment les données de compte, les informations sur l’appareil, les interactions avec l’application, les identifiants, les données de diagnostic et les données liées à la publicité. Les favoris sont stockés par utilisateur afin qu’ils restent disponibles après le redémarrage de l’application et sur plusieurs appareils.\n\nLe traitement est effectué afin de fournir les fonctionnalités de l’application, d’authentifier les utilisateurs, d’enregistrer les paramètres liés à l’utilisateur et de financer l’application par la publicité.\n\nIl ne peut être exclu que des services tiers intégrés traitent des données en dehors de l’Union européenne. À cet égard, les informations de confidentialité des services utilisés s’appliquent également, notamment Google Firebase et Google AdMob.\n\nPour toute question relative à la confidentialité ou pour demander la suppression de données, veuillez contacter :\nmichael.winkler.developer@gmail.com\n\nRemarque : avant une publication publique définitive, cette politique de confidentialité devrait être relue et complétée avec des informations complètes sur les bases légales, les durées de conservation, les droits des utilisateurs et tous les services intégrés.';

  @override
  String get imprintBody => 'Mentions légales\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nAllemagne\n\nE-mail :\nmichael.winkler.developer@gmail.com\n\nResponsable du contenu :\nMichael Winkler';

  @override
  String get supportBody => 'Support\n\nPour toute question, problème ou retour concernant l’application, veuillez contacter :\n\nMichael Winkler\nE-mail : michael.winkler.developer@gmail.com\n\nVeuillez décrire votre problème aussi précisément que possible et inclure si possible votre appareil ainsi que la version de l’application.';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get emailAppCouldNotBeOpened => 'Impossible d’ouvrir l’application e-mail.';

  @override
  String get supportEmailSubject => 'Support ASA Server Eye';

  @override
  String get supportEmailBodyTemplate => 'Bonjour Michael,\n\nj’ai le problème suivant :\n\n\n---\nVersion de l’application :\nAppareil :\n';
}
