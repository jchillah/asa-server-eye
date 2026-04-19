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
  String get aboutBody => 'ASA Server Eye is a companion app for ARK: Survival Ascended. The app shows server information, supports favorites, and provides the foundation for future features such as watchlists, notifications, and premium features.\n\nDeveloped and operated by:\nMichael Winkler\nEmail: asa.server.eye@gmail.com';

  @override
  String get privacyBody => 'Privacy Policy\n\nController responsible for data processing:\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\nEmail: asa.server.eye@gmail.com\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve ads.\n\nDepending on how the app is used, technical data may be processed, including account data, device information, app interactions, identifiers, diagnostics, and advertising-related data. Favorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nProcessing is carried out to provide app functionality, authenticate users, store user-related settings, and finance the app through advertising.\n\nIt cannot be ruled out that integrated third-party services process data outside the European Union. In this respect, the privacy information of the respective services applies, especially Google Firebase and Google AdMob.\n\nFor privacy-related questions or deletion requests, please contact:\nasa.server.eye@gmail.com\n\nNote: Before a final public release, this privacy policy should be reviewed and expanded with full details on legal bases, retention periods, user rights, and all integrated services.';

  @override
  String get imprintBody => 'Imprint / Legal Notice\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nGermany\n\nEmail:\nasa.server.eye@gmail.com\n\nResponsible for content:\nMichael Winkler';

  @override
  String get supportBody => 'Support\n\nFor questions, issues, or feedback about the app, please contact:\n\nMichael Winkler\nEmail: asa.server.eye@gmail.com\n\nPlease describe your issue as precisely as possible and include your device and app version if available.';

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

  @override
  String get profile => 'Profile';

  @override
  String get profileLoadError => 'Profile could not be loaded.';

  @override
  String get username => 'Username';

  @override
  String get accessLevel => 'Access level';

  @override
  String get save => 'Save';

  @override
  String get profileSavedSuccessfully => 'Profile saved successfully.';

  @override
  String get profileSaveError => 'Profile could not be saved.';

  @override
  String get profileDeleteError => 'Account could not be deleted.';

  @override
  String get deleteAccountHint => 'Deleting your account will remove your profile. Existing sightings will remain.';

  @override
  String savedFavoritesCount(int count) {
    return '$count saved';
  }

  @override
  String get usernameEmpty => 'Please enter a username.';

  @override
  String get usernameTooShort => 'The username must be at least 3 characters long.';

  @override
  String get usernameTooLong => 'The username may be at most 20 characters long.';

  @override
  String get usernameInvalidCharacters => 'The username may only contain letters, numbers, periods, underscores, and hyphens.';

  @override
  String get deleteAccountDialogTitle => 'Delete account';

  @override
  String deleteAccountDialogDescription(String email) {
    return 'Please enter your password for $email to delete your account.';
  }

  @override
  String get signUpUsernameHint => 'This will be your public username visible to other users.';

  @override
  String get emailHint => 'name@email.com';

  @override
  String get sightings => 'Sightings';

  @override
  String get playerSightingReport => 'Report player sighting';

  @override
  String get editSighting => 'Edit sighting';

  @override
  String get deleteSighting => 'Delete sighting';

  @override
  String get sightingHistory => 'Change history';

  @override
  String get platformId => 'Platform ID';

  @override
  String get platformIdHint => 'Steam / Xbox / PSN ID';

  @override
  String get inGameName => 'In-game name';

  @override
  String get tribeName => 'Tribe name';

  @override
  String get tribeNameHint => 'Name of the tribe';

  @override
  String get platform => 'Platform';

  @override
  String get note => 'Note';

  @override
  String get optional => 'Optional';

  @override
  String get visibleToPremiumUsers => 'Visible to premium users';

  @override
  String get saveSighting => 'Save sighting';

  @override
  String get updateSighting => 'Save changes';

  @override
  String get hideSighting => 'Hide sighting';

  @override
  String get saving => 'Saving...';

  @override
  String get sightingSaved => 'Sighting saved.';

  @override
  String get sightingUpdated => 'Sighting updated.';

  @override
  String get sightingHidden => 'Sighting hidden.';

  @override
  String get sightingSaveError => 'Sighting could not be saved.';

  @override
  String get sightingUpdateError => 'Sighting could not be updated.';

  @override
  String get sightingHideError => 'Sighting could not be hidden.';

  @override
  String get sightingRequiresLogin => 'You must be logged in to report a sighting.';

  @override
  String get sightingDeleteNotAllowed => 'You are not allowed to delete this sighting.';

  @override
  String get sightingEditNotAllowed => 'You are not allowed to edit this sighting.';

  @override
  String get sightingInGameNameRequired => 'Please enter a player name.';

  @override
  String get sightingPlatformIdRequired => 'Please enter a platform ID.';

  @override
  String get sightingTribeNameRequired => 'Please enter a tribe name.';

  @override
  String get sightingReasonRequired => 'Please enter a reason.';

  @override
  String get sightingDeleteHint => 'This sighting will not be permanently deleted. It will only be hidden from normal users and remain traceable for admins.';

  @override
  String get reason => 'Reason';

  @override
  String get reasonHint => 'Please enter a reason';

  @override
  String get noVisibleSightings => 'No visible sightings yet.';

  @override
  String get sightingsLoadError => 'Sightings could not be loaded.';

  @override
  String get sightingHistoryLoadError => 'History could not be loaded.';

  @override
  String get noSightingHistory => 'No history available yet.';

  @override
  String get accessLevelLoadError => 'Access level could not be loaded.';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get viewHistory => 'View history';

  @override
  String get platformSteam => 'Steam';

  @override
  String get platformXbox => 'Xbox';

  @override
  String get platformPsn => 'PSN';

  @override
  String get platformUnknown => 'Unknown';

  @override
  String get sightingUserProfileLoadError => 'User profile could not be loaded.';

  @override
  String get playerSightings => 'Player Sightings';

  @override
  String platformLabel(String value) {
    return 'Platform: $value';
  }

  @override
  String visibilityLabel(String value) {
    return 'Visibility: $value';
  }

  @override
  String sharingLabel(String value) {
    return 'Sharing: $value';
  }

  @override
  String editedAtLabel(String value) {
    return 'Edited: $value';
  }

  @override
  String get softDeleted => 'Soft deleted';

  @override
  String reasonLabel(String value) {
    return 'Reason: $value';
  }

  @override
  String changedByLabel(String value) {
    return 'Changed by: $value';
  }

  @override
  String get sightingCreatorLevelFree => 'Free';

  @override
  String get sightingCreatorLevelPremium => 'Premium';

  @override
  String get sightingCreatorLevelAdmin => 'Admin';

  @override
  String get sightingSharingOwnerOnly => 'Owner only';

  @override
  String get sightingSharingPremiumShared => 'Shared with premium';

  @override
  String get sightingSharingAdminOnly => 'Admins only';

  @override
  String get sightingActionCreated => 'Created';

  @override
  String get sightingActionUpdated => 'Updated';

  @override
  String get sightingActionSoftDeleted => 'Soft deleted';

  @override
  String get viewPlayerSightings => 'View player sightings';

  @override
  String get reportPlayerSighting => 'Report player sighting';

  @override
  String get accountCreated => 'Account created successfully';

  @override
  String get accountCreationFailed => 'Failed to create account. Please try again.';

  @override
  String get accountDeleted => 'Account deleted successfully';

  @override
  String get accountDeletionFailed => 'Failed to delete account. Please try again.';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get deletePermanentlyConfirmation => 'This sighting and its history will be permanently deleted. This action cannot be undone.';

  @override
  String get sightingDeletedPermanently => 'Sighting deleted permanently';

  @override
  String get premiumRequiredForMoreFavorites => 'You need Premium to save more than one favorite.';

  @override
  String get serversNavLabel => 'Servers';

  @override
  String get favoritesNavLabel => 'Favorites';

  @override
  String get sightingsNavLabel => 'Sightings';

  @override
  String get settingsNavLabel => 'Settings';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumSettingsSubtitle => 'Unlock and manage premium';

  @override
  String get premiumHeadline => 'Unlock Premium';

  @override
  String get premiumDescription => 'With Premium, you get access to player sightings, more favorites, and future premium features.';

  @override
  String get premiumBenefitSightingsTitle => 'Player sightings';

  @override
  String get premiumBenefitSightingsDescription => 'Access sightings directly from the navigation and use premium access across the sightings area.';

  @override
  String get premiumBenefitFavoritesTitle => 'More favorites';

  @override
  String get premiumBenefitFavoritesDescription => 'Save significantly more servers to your favorites.';

  @override
  String get premiumBenefitAlertsTitle => 'Future extras';

  @override
  String get premiumBenefitAlertsDescription => 'Get ready for future premium features like enhanced tracking and alerts.';

  @override
  String get premiumMonthlyPlan => 'Monthly';

  @override
  String get premiumMonthlyPlanDescription => 'Flexible cancellation';

  @override
  String get premiumYearlyPlan => 'Yearly';

  @override
  String get premiumYearlyPlanDescription => 'Best value for long-term use';

  @override
  String get premiumStartMonthly => 'Start monthly';

  @override
  String get premiumStartYearly => 'Start yearly';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get premiumPurchaseComingSoon => 'The purchase flow will be connected next.';

  @override
  String get premiumUpgradeTitle => 'Upgrade to Premium';

  @override
  String get premiumUpgradeDescription => 'Unlock the sightings tab and additional premium benefits.';

  @override
  String get premiumActiveTitle => 'Premium active';

  @override
  String get premiumActiveDescription => 'Your account already has access to premium features.';

  @override
  String get unlockPremium => 'Unlock Premium';

  @override
  String get managePremium => 'Manage Premium';

  @override
  String get premiumStoreUnavailable => 'The store is currently unavailable. Please try again later.';

  @override
  String get premiumProductsUnavailable => 'Currently, no premium products could be loaded.';

  @override
  String get premiumPurchaseError => 'An error occurred while purchasing. Please try again.';

  @override
  String get premiumRestoreSuccess => 'Purchases restored successfully.';

  @override
  String get premiumRestoreError => 'An error occurred while restoring purchases. Please try again.';

  @override
  String get premiumPurchasePending => 'Your purchase is being processed. Premium will unlock after successful verification.';

  @override
  String get premiumExpiredDescription => 'Your premium access has expired. You can unlock Premium again at any time.';

  @override
  String get premiumVerificationQueued => 'Your purchase was submitted and is now being verified.';
}
