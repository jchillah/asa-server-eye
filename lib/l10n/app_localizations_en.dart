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
}
