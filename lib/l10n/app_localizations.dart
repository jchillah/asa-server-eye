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

  /// Label for repeat password field
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// Shown when password and repeated password are different
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

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
  /// **'ASA Server Eye is a companion app for ARK: Survival Ascended. The app shows server information, supports favorites, and provides the foundation for future features such as watchlists, notifications, and premium features.\n\nDeveloped and operated by:\nMichael Winkler\nEmail: asa.server.eye@gmail.com'**
  String get aboutBody;

  /// Body content for the Privacy screen
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy\n\nController responsible for data processing:\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\nEmail: asa.server.eye@gmail.com\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve ads.\n\nDepending on how the app is used, technical data may be processed, including account data, device information, app interactions, identifiers, diagnostics, and advertising-related data. Favorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nProcessing is carried out to provide app functionality, authenticate users, store user-related settings, and finance the app through advertising.\n\nIt cannot be ruled out that integrated third-party services process data outside the European Union. In this respect, the privacy information of the respective services applies, especially Google Firebase and Google AdMob.\n\nFor privacy-related questions or deletion requests, please contact:\nasa.server.eye@gmail.com\n\nNote: Before a final public release, this privacy policy should be reviewed and expanded with full details on legal bases, retention periods, user rights, and all integrated services.'**
  String get privacyBody;

  /// Body content for the Imprint screen
  ///
  /// In en, this message translates to:
  /// **'Imprint / Legal Notice\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\n\nEmail:\nasa.server.eye@gmail.com\n\nResponsible for content:\nMichael Winkler'**
  String get imprintBody;

  /// Body content for the Support screen
  ///
  /// In en, this message translates to:
  /// **'Support\n\nFor questions, issues, or feedback about the app, please contact:\n\nMichael Winkler\nEmail: asa.server.eye@gmail.com\n\nPlease describe your issue as precisely as possible and include your device and app version if available.'**
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

  /// Button to open full privacy policy
  ///
  /// In en, this message translates to:
  /// **'Full Privacy Policy'**
  String get fullPrivacyPolicy;

  /// Button to delete user account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Profile section title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Error when loading the profile fails
  ///
  /// In en, this message translates to:
  /// **'Profile could not be loaded.'**
  String get profileLoadError;

  /// Label for username field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Label for access level
  ///
  /// In en, this message translates to:
  /// **'Access level'**
  String get accessLevel;

  /// Save action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Snackbar after saving the profile
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully.'**
  String get profileSavedSuccessfully;

  /// Error when saving the profile fails
  ///
  /// In en, this message translates to:
  /// **'Profile could not be saved.'**
  String get profileSaveError;

  /// Error when deleting the account fails
  ///
  /// In en, this message translates to:
  /// **'Account could not be deleted.'**
  String get profileDeleteError;

  /// Hint below the delete account button
  ///
  /// In en, this message translates to:
  /// **'Deleting your account will remove your profile. Existing sightings will remain.'**
  String get deleteAccountHint;

  /// Number of saved favorites
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String savedFavoritesCount(int count);

  /// Validation when username is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a username.'**
  String get usernameEmpty;

  /// Validation when username is too short
  ///
  /// In en, this message translates to:
  /// **'The username must be at least 3 characters long.'**
  String get usernameTooShort;

  /// Validation when username is too long
  ///
  /// In en, this message translates to:
  /// **'The username may be at most 20 characters long.'**
  String get usernameTooLong;

  /// Validation when username contains invalid characters
  ///
  /// In en, this message translates to:
  /// **'The username may only contain letters, numbers, periods, underscores, and hyphens.'**
  String get usernameInvalidCharacters;

  /// Delete account dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountDialogTitle;

  /// Delete account dialog description
  ///
  /// In en, this message translates to:
  /// **'Please enter your password for {email} to delete your account.'**
  String deleteAccountDialogDescription(String email);

  /// Hint text for username on sign up
  ///
  /// In en, this message translates to:
  /// **'This will be your public username visible to other users.'**
  String get signUpUsernameHint;

  /// Hint text for email field
  ///
  /// In en, this message translates to:
  /// **'name@email.com'**
  String get emailHint;

  /// Title for sightings
  ///
  /// In en, this message translates to:
  /// **'Sightings'**
  String get sightings;

  /// Title of the report player sighting screen
  ///
  /// In en, this message translates to:
  /// **'Report player sighting'**
  String get playerSightingReport;

  /// Title of the edit sighting screen
  ///
  /// In en, this message translates to:
  /// **'Edit sighting'**
  String get editSighting;

  /// Title of the delete sighting screen
  ///
  /// In en, this message translates to:
  /// **'Delete sighting'**
  String get deleteSighting;

  /// Title of the sighting history screen
  ///
  /// In en, this message translates to:
  /// **'Change history'**
  String get sightingHistory;

  /// Label for platform ID
  ///
  /// In en, this message translates to:
  /// **'Platform ID'**
  String get platformId;

  /// Hint text for platform ID
  ///
  /// In en, this message translates to:
  /// **'Steam / Xbox / PSN ID'**
  String get platformIdHint;

  /// Label for in-game name
  ///
  /// In en, this message translates to:
  /// **'In-game name'**
  String get inGameName;

  /// Label for tribe name
  ///
  /// In en, this message translates to:
  /// **'Tribe name'**
  String get tribeName;

  /// Hint text for tribe name
  ///
  /// In en, this message translates to:
  /// **'Name of the tribe'**
  String get tribeNameHint;

  /// Label for platform
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// Label for note
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// Optional field hint
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Switch label for premium visibility
  ///
  /// In en, this message translates to:
  /// **'Visible to premium users'**
  String get visibleToPremiumUsers;

  /// Button text to save a sighting
  ///
  /// In en, this message translates to:
  /// **'Save sighting'**
  String get saveSighting;

  /// Button text to update a sighting
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get updateSighting;

  /// Button text to hide a sighting
  ///
  /// In en, this message translates to:
  /// **'Hide sighting'**
  String get hideSighting;

  /// Text shown while saving
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Snackbar after saving a sighting
  ///
  /// In en, this message translates to:
  /// **'Sighting saved.'**
  String get sightingSaved;

  /// Snackbar after updating a sighting
  ///
  /// In en, this message translates to:
  /// **'Sighting updated.'**
  String get sightingUpdated;

  /// Snackbar after hiding a sighting
  ///
  /// In en, this message translates to:
  /// **'Sighting hidden.'**
  String get sightingHidden;

  /// Error when saving a sighting fails
  ///
  /// In en, this message translates to:
  /// **'Sighting could not be saved.'**
  String get sightingSaveError;

  /// Error when updating a sighting fails
  ///
  /// In en, this message translates to:
  /// **'Sighting could not be updated.'**
  String get sightingUpdateError;

  /// Error when hiding a sighting fails
  ///
  /// In en, this message translates to:
  /// **'Sighting could not be hidden.'**
  String get sightingHideError;

  /// Error when user is not logged in
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to report a sighting.'**
  String get sightingRequiresLogin;

  /// Error when deleting is not allowed
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to delete this sighting.'**
  String get sightingDeleteNotAllowed;

  /// Error when editing is not allowed
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to edit this sighting.'**
  String get sightingEditNotAllowed;

  /// Validation for missing player name
  ///
  /// In en, this message translates to:
  /// **'Please enter a player name.'**
  String get sightingInGameNameRequired;

  /// Validation for missing platform ID
  ///
  /// In en, this message translates to:
  /// **'Please enter a platform ID.'**
  String get sightingPlatformIdRequired;

  /// Validation for missing tribe name
  ///
  /// In en, this message translates to:
  /// **'Please enter a tribe name.'**
  String get sightingTribeNameRequired;

  /// Validation for missing delete reason
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason.'**
  String get sightingReasonRequired;

  /// Hint text on the delete sighting screen
  ///
  /// In en, this message translates to:
  /// **'This sighting will not be permanently deleted. It will only be hidden from normal users and remain traceable for admins.'**
  String get sightingDeleteHint;

  /// Label for reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// Hint text for reason
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get reasonHint;

  /// Empty state for server sightings
  ///
  /// In en, this message translates to:
  /// **'No visible sightings yet.'**
  String get noVisibleSightings;

  /// Error when loading sightings fails
  ///
  /// In en, this message translates to:
  /// **'Sightings could not be loaded.'**
  String get sightingsLoadError;

  /// Error when loading history fails
  ///
  /// In en, this message translates to:
  /// **'History could not be loaded.'**
  String get sightingHistoryLoadError;

  /// Empty state for sighting history
  ///
  /// In en, this message translates to:
  /// **'No history available yet.'**
  String get noSightingHistory;

  /// Error when loading access level fails
  ///
  /// In en, this message translates to:
  /// **'Access level could not be loaded.'**
  String get accessLevelLoadError;

  /// Edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Action to view history
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// Label for Steam
  ///
  /// In en, this message translates to:
  /// **'Steam'**
  String get platformSteam;

  /// Label for Xbox
  ///
  /// In en, this message translates to:
  /// **'Xbox'**
  String get platformXbox;

  /// Label for PSN
  ///
  /// In en, this message translates to:
  /// **'PSN'**
  String get platformPsn;

  /// Label for unknown platform
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get platformUnknown;

  /// Error when the user profile for a sighting could not be loaded
  ///
  /// In en, this message translates to:
  /// **'User profile could not be loaded.'**
  String get sightingUserProfileLoadError;

  /// Title of the server sightings screen
  ///
  /// In en, this message translates to:
  /// **'Player Sightings'**
  String get playerSightings;

  /// Label for platform in a sighting
  ///
  /// In en, this message translates to:
  /// **'Platform: {value}'**
  String platformLabel(String value);

  /// Label for creator level in a sighting
  ///
  /// In en, this message translates to:
  /// **'Visibility: {value}'**
  String visibilityLabel(String value);

  /// Label for sharing scope in a sighting
  ///
  /// In en, this message translates to:
  /// **'Sharing: {value}'**
  String sharingLabel(String value);

  /// Label for edit timestamp
  ///
  /// In en, this message translates to:
  /// **'Edited: {value}'**
  String editedAtLabel(String value);

  /// Indicator that a sighting was soft deleted
  ///
  /// In en, this message translates to:
  /// **'Soft deleted'**
  String get softDeleted;

  /// Label for delete reason
  ///
  /// In en, this message translates to:
  /// **'Reason: {value}'**
  String reasonLabel(String value);

  /// Label for changed by user id in history
  ///
  /// In en, this message translates to:
  /// **'Changed by: {value}'**
  String changedByLabel(String value);

  /// Label for creator level free
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get sightingCreatorLevelFree;

  /// Label for creator level premium
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get sightingCreatorLevelPremium;

  /// Label for creator level admin
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get sightingCreatorLevelAdmin;

  /// Label for sharing scope ownerOnly
  ///
  /// In en, this message translates to:
  /// **'Owner only'**
  String get sightingSharingOwnerOnly;

  /// Label for sharing scope premiumShared
  ///
  /// In en, this message translates to:
  /// **'Shared with premium'**
  String get sightingSharingPremiumShared;

  /// Label for sharing scope adminOnly
  ///
  /// In en, this message translates to:
  /// **'Admins only'**
  String get sightingSharingAdminOnly;

  /// History action for created sighting
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get sightingActionCreated;

  /// History action for updated sighting
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get sightingActionUpdated;

  /// History action for soft deleted sighting
  ///
  /// In en, this message translates to:
  /// **'Soft deleted'**
  String get sightingActionSoftDeleted;

  /// Button label to open player sightings
  ///
  /// In en, this message translates to:
  /// **'View player sightings'**
  String get viewPlayerSightings;

  /// Button label to report a player sighting
  ///
  /// In en, this message translates to:
  /// **'Report player sighting'**
  String get reportPlayerSighting;

  /// Message displayed when an account is created successfully
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreated;

  /// Message displayed when account creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create account. Please try again.'**
  String get accountCreationFailed;

  /// Message displayed when an account is deleted successfully
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeleted;

  /// Message displayed when account deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get accountDeletionFailed;

  /// Admin action to permanently delete a sighting
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// Confirmation text before admin permanently deletes a sighting
  ///
  /// In en, this message translates to:
  /// **'This sighting and its history will be permanently deleted. This action cannot be undone.'**
  String get deletePermanentlyConfirmation;

  /// Shown after an admin permanently deleted a sighting
  ///
  /// In en, this message translates to:
  /// **'Sighting deleted permanently'**
  String get sightingDeletedPermanently;

  /// Shown when a free user tries to save more than one favorite
  ///
  /// In en, this message translates to:
  /// **'You need Premium to save more than one favorite.'**
  String get premiumRequiredForMoreFavorites;

  /// Short label for the servers tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get serversNavLabel;

  /// Short label for the favorites tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesNavLabel;

  /// Short label for the sightings tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Sightings'**
  String get sightingsNavLabel;

  /// Short label for the settings tab in the bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsNavLabel;

  /// Title for premium section
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// Subtitle for premium entry in settings
  ///
  /// In en, this message translates to:
  /// **'Unlock and manage premium'**
  String get premiumSettingsSubtitle;

  /// Headline on premium screen
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get premiumHeadline;

  /// Premium description
  ///
  /// In en, this message translates to:
  /// **'With Premium, you get access to player sightings, more favorites, and future premium features.'**
  String get premiumDescription;

  /// Title for sightings benefit
  ///
  /// In en, this message translates to:
  /// **'Player sightings'**
  String get premiumBenefitSightingsTitle;

  /// Description for sightings benefit
  ///
  /// In en, this message translates to:
  /// **'Access sightings directly from the navigation and use premium access across the sightings area.'**
  String get premiumBenefitSightingsDescription;

  /// Title for favorites benefit
  ///
  /// In en, this message translates to:
  /// **'More favorites'**
  String get premiumBenefitFavoritesTitle;

  /// Description for favorites benefit
  ///
  /// In en, this message translates to:
  /// **'Save significantly more servers to your favorites.'**
  String get premiumBenefitFavoritesDescription;

  /// Title for future premium extras
  ///
  /// In en, this message translates to:
  /// **'Future extras'**
  String get premiumBenefitAlertsTitle;

  /// Description for future premium extras
  ///
  /// In en, this message translates to:
  /// **'Get ready for future premium features like enhanced tracking and alerts.'**
  String get premiumBenefitAlertsDescription;

  /// Monthly plan
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get premiumMonthlyPlan;

  /// Description for monthly plan
  ///
  /// In en, this message translates to:
  /// **'Flexible cancellation'**
  String get premiumMonthlyPlanDescription;

  /// Yearly plan
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get premiumYearlyPlan;

  /// Description for yearly plan
  ///
  /// In en, this message translates to:
  /// **'Best value for long-term use'**
  String get premiumYearlyPlanDescription;

  /// CTA for monthly purchase
  ///
  /// In en, this message translates to:
  /// **'Start monthly'**
  String get premiumStartMonthly;

  /// CTA for yearly purchase
  ///
  /// In en, this message translates to:
  /// **'Start yearly'**
  String get premiumStartYearly;

  /// Button to restore purchases
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// Temporary info while purchase flow is not connected yet
  ///
  /// In en, this message translates to:
  /// **'The purchase flow will be connected next.'**
  String get premiumPurchaseComingSoon;

  /// Title for premium upgrade card in profile
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get premiumUpgradeTitle;

  /// Description for premium upgrade in profile
  ///
  /// In en, this message translates to:
  /// **'Unlock the sightings tab and additional premium benefits.'**
  String get premiumUpgradeDescription;

  /// Title for active premium in profile
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get premiumActiveTitle;

  /// Description for active premium in profile
  ///
  /// In en, this message translates to:
  /// **'Your account already has access to premium features.'**
  String get premiumActiveDescription;

  /// Button to unlock premium
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlockPremium;

  /// Button to manage premium
  ///
  /// In en, this message translates to:
  /// **'Manage Premium'**
  String get managePremium;

  /// Notification when the store is not available
  ///
  /// In en, this message translates to:
  /// **'The store is currently unavailable. Please try again later.'**
  String get premiumStoreUnavailable;

  /// Notification when no premium products can be loaded
  ///
  /// In en, this message translates to:
  /// **'Currently, no premium products could be loaded.'**
  String get premiumProductsUnavailable;

  /// Notification when an error occurs during purchase
  ///
  /// In en, this message translates to:
  /// **'An error occurred while purchasing. Please try again.'**
  String get premiumPurchaseError;

  /// Notification when purchases are restored successfully
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully.'**
  String get premiumRestoreSuccess;

  /// Notification when an error occurs while restoring purchases
  ///
  /// In en, this message translates to:
  /// **'An error occurred while restoring purchases. Please try again.'**
  String get premiumRestoreError;

  /// Message while a purchase is pending verification
  ///
  /// In en, this message translates to:
  /// **'Your purchase is being processed. Premium will unlock after successful verification.'**
  String get premiumPurchasePending;

  /// Message for expired premium access
  ///
  /// In en, this message translates to:
  /// **'Your premium access has expired. You can unlock Premium again at any time.'**
  String get premiumExpiredDescription;

  /// Message after purchase verification request was submitted
  ///
  /// In en, this message translates to:
  /// **'Your purchase was submitted and is now being verified.'**
  String get premiumVerificationQueued;
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
