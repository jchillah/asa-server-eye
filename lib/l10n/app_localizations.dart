import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('zh')
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'ASA Server Eye'**
  String get appTitle;

  /// Bottom navigation and screen title for servers
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get servers;

  /// Bottom navigation and screen title for favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Bottom navigation and screen title for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Hint text for server search field
  ///
  /// In en, this message translates to:
  /// **'Search servers or maps'**
  String get searchServersOrMaps;

  /// Empty state when no servers are available
  ///
  /// In en, this message translates to:
  /// **'No servers found'**
  String get noServersFound;

  /// Empty state when search has no results
  ///
  /// In en, this message translates to:
  /// **'No servers match your search'**
  String get noServersMatchSearch;

  /// Title of the server details screen
  ///
  /// In en, this message translates to:
  /// **'Server Details'**
  String get serverDetails;

  /// Shown when a server id cannot be found
  ///
  /// In en, this message translates to:
  /// **'Server not found'**
  String get serverNotFound;

  /// Label for server map
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// Label for player population
  ///
  /// In en, this message translates to:
  /// **'Population'**
  String get population;

  /// Label for server type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Official server type
  ///
  /// In en, this message translates to:
  /// **'Official'**
  String get official;

  /// Unofficial server type
  ///
  /// In en, this message translates to:
  /// **'Unofficial'**
  String get unofficial;

  /// Button label to add server to favorites
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// Button label to remove server from favorites
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// Snackbar after adding favorite
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// Snackbar after removing favorite
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// Empty state for favorites screen
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// Dialog title for removing a favorite
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get removeFavorite;

  /// Cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Remove action
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Apply action
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Confirmation message before removing a favorite
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove \"{serverName}\" from favorites?'**
  String removeFavoriteQuestion(String serverName);

  /// Snackbar after swipe delete from favorites
  ///
  /// In en, this message translates to:
  /// **'{serverName} removed from favorites'**
  String removedServerFromFavorites(String serverName);

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Settings entry title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Settings entry subtitle
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// Language option for following the system language
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// Language option for German
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// Language option for English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Language option for Spanish
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Language option for Chinese
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// Dialog title for language selection
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// Settings entry title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Settings entry subtitle
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get appInformation;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// Settings entry title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Settings entry subtitle
  ///
  /// In en, this message translates to:
  /// **'How data is handled'**
  String get howDataIsHandled;

  /// Settings entry title
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get imprint;

  /// Settings entry subtitle
  ///
  /// In en, this message translates to:
  /// **'Legal information'**
  String get legalInformation;

  /// Settings entry title
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Settings entry subtitle
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get getHelpAndContactSupport;

  /// Snackbar for not yet implemented settings entries
  ///
  /// In en, this message translates to:
  /// **'{title} coming soon'**
  String comingSoon(String title);

  /// Language option for French
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// Generic error message shown to the user
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// Loading state label
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// Sign in action
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Sign up action
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Heading on sign in screen
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Subtitle on sign in screen
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue using your saved data.'**
  String get signInToContinue;

  /// Create account action
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Heading on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// Subtitle on sign up screen
  ///
  /// In en, this message translates to:
  /// **'Sign up to save your favorites across devices.'**
  String get signUpToSaveFavorites;

  /// Account section title in settings
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Sign out action
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Subtitle for sign out tile
  ///
  /// In en, this message translates to:
  /// **'Log out of your current account'**
  String get signOutDescription;

  /// Shown when email or password is missing
  ///
  /// In en, this message translates to:
  /// **'Please enter your email and password.'**
  String get authMissingEmailOrPassword;

  /// Shown when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get authInvalidEmailFormat;

  /// Shown when user account is disabled
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled.'**
  String get authUserDisabled;

  /// Shown when credentials are invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get authInvalidCredentials;

  /// Shown on network failure
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get networkError;

  /// Shown when password is too weak
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get authWeakPassword;

  /// Shown when email is already registered
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get authEmailAlreadyInUse;

  /// Body content for the About screen
  ///
  /// In en, this message translates to:
  /// **'ASA Server Eye is a companion app for ARK: Survival Ascended. The app shows server information, supports favorites, and provides the foundation for future features such as watchlists, notifications, and premium features.\n\nDeveloped and operated by:\nMichael Winkler\nEmail: michael.winkler.developer@gmail.com'**
  String get aboutBody;

  /// Body content for the Privacy screen
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy\n\nController responsible for data processing:\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\nEmail: michael.winkler.developer@gmail.com\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve ads.\n\nDepending on how the app is used, technical data may be processed, including account data, device information, app interactions, identifiers, diagnostics, and advertising-related data. Favorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nProcessing is carried out to provide app functionality, authenticate users, store user-related settings, and finance the app through advertising.\n\nIt cannot be ruled out that integrated third-party services process data outside the European Union. In this respect, the privacy information of the respective services applies, especially Google Firebase and Google AdMob.\n\nFor privacy-related questions or deletion requests, please contact:\nmichael.winkler.developer@gmail.com\n\nNote: Before a final public release, this privacy policy should be reviewed and expanded with full details on legal bases, retention periods, user rights, and all integrated services.'**
  String get privacyBody;

  /// Body content for the Imprint screen
  ///
  /// In en, this message translates to:
  /// **'Imprint / Legal Notice\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\n\nEmail:\nmichael.winkler.developer@gmail.com\n\nResponsible for content:\nMichael Winkler'**
  String get imprintBody;

  /// Body content for the Support screen
  ///
  /// In en, this message translates to:
  /// **'Support\n\nFor questions, issues, or feedback about the app, please contact:\n\nMichael Winkler\nEmail: michael.winkler.developer@gmail.com\n\nPlease describe your issue as precisely as possible and include your device and app version if available.'**
  String get supportBody;

  /// Button text to contact support
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contactSupport;

  /// Shown when no email app can be opened
  ///
  /// In en, this message translates to:
  /// **'Email app could not be opened.'**
  String get emailAppCouldNotBeOpened;

  /// Subject line for support email
  ///
  /// In en, this message translates to:
  /// **'ASA Server Eye Support'**
  String get supportEmailSubject;

  /// Prefilled support email body
  ///
  /// In en, this message translates to:
  /// **'Hello Michael,\n\nI have the following issue:\n\n\n---\nApp version:\nDevice:\n'**
  String get supportEmailBodyTemplate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
