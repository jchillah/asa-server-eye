// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ASA Server Eye';

  @override
  String get servers => 'Servers';

  @override
  String get favorites => 'Favorites';

  @override
  String get settings => 'Settings';

  @override
  String get searchServersOrMaps => 'Search servers or maps';

  @override
  String get noServersFound => 'No servers found';

  @override
  String get noServersMatchSearch => 'No servers match your search';

  @override
  String get serverDetails => 'Server Details';

  @override
  String get serverNotFound => 'Server not found';

  @override
  String get map => 'Map';

  @override
  String get population => 'Population';

  @override
  String get type => 'Type';

  @override
  String get official => 'Official';

  @override
  String get unofficial => 'Unofficial';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get removeFavorite => 'Remove favorite';

  @override
  String get cancel => 'Cancel';

  @override
  String get remove => 'Remove';

  @override
  String get apply => 'Apply';

  @override
  String removeFavoriteQuestion(String serverName) {
    return 'Do you want to remove \"$serverName\" from favorites?';
  }

  @override
  String removedServerFromFavorites(String serverName) {
    return '$serverName removed from favorites';
  }

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get systemLanguage => 'System language';

  @override
  String get german => 'German';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get chinese => 'Chinese';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get about => 'About';

  @override
  String get appInformation => 'App information';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get howDataIsHandled => 'How data is handled';

  @override
  String get imprint => 'Imprint';

  @override
  String get legalInformation => 'Legal information';

  @override
  String get support => 'Support';

  @override
  String get getHelpAndContactSupport => 'Get help and contact support';

  @override
  String comingSoon(String title) {
    return '$title coming soon';
  }

  @override
  String get french => 'French';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get loading => 'Loading';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get repeatPassword => 'Repeat password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInToContinue => 'Sign in to continue using your saved data.';

  @override
  String get createAccount => 'Create account';

  @override
  String get createYourAccount => 'Create your account';

  @override
  String get signUpToSaveFavorites => 'Sign up to save your favorites across devices.';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutDescription => 'Log out of your current account';

  @override
  String get authMissingEmailOrPassword => 'Please enter your email and password.';

  @override
  String get authInvalidEmailFormat => 'Please enter a valid email address.';

  @override
  String get authUserDisabled => 'This account has been disabled.';

  @override
  String get authInvalidCredentials => 'Invalid email or password.';

  @override
  String get networkError => 'Network error. Please try again.';

  @override
  String get authWeakPassword => 'Password must be at least 6 characters long.';

  @override
  String get authEmailAlreadyInUse => 'This email is already in use.';

  @override
  String get aboutBody => 'ASA Server Eye is a companion app for ARK: Survival Ascended. The app shows server information, supports favorites, and provides the foundation for future features such as watchlists, notifications, and premium features.\n\nDeveloped and operated by:\nMichael Winkler\nEmail: Jchillah@gmail.com';

  @override
  String get privacyBody => 'Privacy Policy\n\nController responsible for data processing:\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\nEmail: Jchillah@gmail.com\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve ads.\n\nDepending on how the app is used, technical data may be processed, including account data, device information, app interactions, identifiers, diagnostics, and advertising-related data. Favorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nProcessing is carried out to provide app functionality, authenticate users, store user-related settings, and finance the app through advertising.\n\nIt cannot be ruled out that integrated third-party services process data outside the European Union. In this respect, the privacy information of the respective services applies, especially Google Firebase and Google AdMob.\n\nFor privacy-related questions or deletion requests, please contact:\nJchillah@gmail.com\n\nNote: Before a final public release, this privacy policy should be reviewed and expanded with full details on legal bases, retention periods, user rights, and all integrated services.';

  @override
  String get imprintBody => 'Imprint / Legal Notice\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\n\nEmail:\nJchillah@gmail.com\n\nResponsible for content:\nMichael Winkler';

  @override
  String get supportBody => 'Support\n\nFor questions, issues, or feedback about the app, please contact:\n\nMichael Winkler\nEmail: Jchillah@gmail.com\n\nPlease describe your issue as precisely as possible and include your device and app version if available.';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get emailAppCouldNotBeOpened => 'Email app could not be opened.';

  @override
  String get supportEmailSubject => 'ASA Server Eye Support';

  @override
  String get supportEmailBodyTemplate => 'Hello Michael,\n\nI have the following issue:\n\n\n---\nApp version:\nDevice:\n';

  @override
  String get fullPrivacyPolicy => 'Full Privacy Policy';

  @override
  String get deleteAccount => 'Delete Account';
}
