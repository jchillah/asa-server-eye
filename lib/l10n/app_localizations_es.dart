// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ASA Server Eye';

  @override
  String get servers => 'Servidores';

  @override
  String get favorites => 'Favoritos';

  @override
  String get settings => 'Ajustes';

  @override
  String get searchServersOrMaps => 'Buscar servidores o mapas';

  @override
  String get noServersFound => 'No se encontraron servidores';

  @override
  String get noServersMatchSearch => 'Ningún servidor coincide con tu búsqueda';

  @override
  String get serverDetails => 'Detalles del servidor';

  @override
  String get serverNotFound => 'Servidor no encontrado';

  @override
  String get map => 'Mapa';

  @override
  String get population => 'Población';

  @override
  String get type => 'Tipo';

  @override
  String get official => 'Oficial';

  @override
  String get unofficial => 'No oficial';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Quitar de favoritos';

  @override
  String get addedToFavorites => 'Añadido a favoritos';

  @override
  String get removedFromFavorites => 'Eliminado de favoritos';

  @override
  String get noFavoritesYet => 'Todavía no hay favoritos';

  @override
  String get removeFavorite => 'Eliminar favorito';

  @override
  String get cancel => 'Cancelar';

  @override
  String get remove => 'Eliminar';

  @override
  String get apply => 'Aplicar';

  @override
  String removeFavoriteQuestion(String serverName) {
    return '¿Quieres eliminar \"$serverName\" de favoritos?';
  }

  @override
  String removedServerFromFavorites(String serverName) {
    return '$serverName eliminado de favoritos';
  }

  @override
  String get general => 'General';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get german => 'Alemán';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get chinese => 'Chino';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get about => 'Acerca de';

  @override
  String get appInformation => 'Información de la aplicación';

  @override
  String get legal => 'Legal';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get howDataIsHandled => 'Cómo se gestionan los datos';

  @override
  String get imprint => 'Aviso legal';

  @override
  String get legalInformation => 'Información legal';

  @override
  String get support => 'Soporte';

  @override
  String get getHelpAndContactSupport => 'Obtener ayuda y contactar con soporte';

  @override
  String comingSoon(String title) {
    return '$title próximamente';
  }

  @override
  String get french => 'Francés';

  @override
  String get genericError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get loading => 'Cargando';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signInToContinue => 'Inicia sesión para seguir usando tus datos guardados.';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get createYourAccount => 'Crea tu cuenta';

  @override
  String get signUpToSaveFavorites => 'Regístrate para guardar tus favoritos en todos tus dispositivos.';

  @override
  String get account => 'Cuenta';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signOutDescription => 'Cerrar sesión de tu cuenta actual';

  @override
  String get authMissingEmailOrPassword => 'Introduce tu correo electrónico y contraseña.';

  @override
  String get authInvalidEmailFormat => 'Introduce una dirección de correo válida.';

  @override
  String get authUserDisabled => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get authInvalidCredentials => 'Correo o contraseña no válidos.';

  @override
  String get networkError => 'Error de red. Inténtalo de nuevo.';

  @override
  String get authWeakPassword => 'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get authEmailAlreadyInUse => 'Este correo electrónico ya está en uso.';

  @override
  String get aboutBody => 'ASA Server Eye is a companion app for ARK: Survival Ascended. The app displays server information, supports favorites, and provides the foundation for future features like watchlists, notifications, and premium features.';

  @override
  String get privacyBody => 'Privacy Notice\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve advertising.\n\nDepending on how the app is used, technical data such as device information, app interactions, approximate location, identifiers, or diagnostic data may be processed. Some of this data may be processed by integrated third-party SDKs.\n\nFavorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nBefore release, replace this text with a complete privacy policy containing your real legal details, controller information, legal bases, third-party services, retention periods, and user rights.';

  @override
  String get imprintBody => 'Imprint / Legal Notice\n\nInformation according to applicable legal requirements\n\nName / Company:\n[YOUR NAME OR COMPANY NAME]\n\nAddress:\n[YOUR FULL ADDRESS]\n\nEmail:\n[YOUR CONTACT EMAIL]\n\nResponsible for content:\n[YOUR NAME]\n\nNote: Before release, replace all placeholders with your real legal information.';

  @override
  String get supportBody => 'Support\n\nFor questions, issues, or feedback, please contact us at:\n[YOUR SUPPORT EMAIL]\n\nLater, you can also add a support website, FAQ, or community links here.';
}
