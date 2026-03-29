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
  String get repeatPassword => 'Repetir contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

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
  String get aboutBody => 'ASA Server Eye es una aplicación complementaria para ARK: Survival Ascended. La aplicación muestra información de servidores, admite favoritos y constituye la base para futuras funciones como listas de seguimiento, notificaciones y funciones premium.\n\nDesarrollado y operado por:\nMichael Winkler\nCorreo electrónico: asa.server.eye@gmail.com';

  @override
  String get privacyBody => 'Política de privacidad\n\nResponsable del tratamiento de datos:\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nAlemania\nCorreo electrónico: asa.server.eye@gmail.com\n\nEsta aplicación utiliza Firebase Authentication para el inicio de sesión, Cloud Firestore para almacenar favoritos personales y Google AdMob para mostrar anuncios.\n\nDependiendo del uso de la aplicación, pueden procesarse datos técnicos, incluidos datos de cuenta, información del dispositivo, interacciones con la aplicación, identificadores, datos de diagnóstico y datos relacionados con la publicidad. Los favoritos se almacenan por usuario para que sigan disponibles después de reiniciar la aplicación y en varios dispositivos.\n\nEl tratamiento se realiza para proporcionar la funcionalidad de la aplicación, autenticar usuarios, guardar ajustes relacionados con el usuario y financiar la aplicación mediante publicidad.\n\nNo puede descartarse que los servicios de terceros integrados procesen datos fuera de la Unión Europea. En este sentido, también se aplican las políticas de privacidad de los servicios utilizados, en particular Google Firebase y Google AdMob.\n\nPara preguntas relacionadas con la privacidad o solicitudes de eliminación de datos, contacta con:\nasa.server.eye@gmail.com\n\nNota: Antes de una publicación pública definitiva, esta política de privacidad debería revisarse y ampliarse con información completa sobre bases legales, plazos de conservación, derechos de los usuarios y todos los servicios integrados.';

  @override
  String get imprintBody => 'Aviso legal\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\nAlemania\n\nCorreo electrónico:\nasa.server.eye@gmail.com\n\nResponsable del contenido:\nMichael Winkler';

  @override
  String get supportBody => 'Soporte\n\nPara preguntas, problemas o comentarios sobre la aplicación, contacta con:\n\nMichael Winkler\nCorreo electrónico: asa.server.eye@gmail.com\n\nDescribe tu problema lo más exactamente posible e incluye tu dispositivo y la versión de la aplicación si es posible.';

  @override
  String get contactSupport => 'Contactar con soporte';

  @override
  String get emailAppCouldNotBeOpened => 'No se pudo abrir la aplicación de correo.';

  @override
  String get supportEmailSubject => 'Soporte de ASA Server Eye';

  @override
  String get supportEmailBodyTemplate => 'Hola Michael,\n\ntengo el siguiente problema:\n\n\n---\nVersión de la app:\nDispositivo:\n';

  @override
  String get fullPrivacyPolicy => 'Política de privacidad completa';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get profile => 'Perfil';

  @override
  String get profileLoadError => 'No se pudo cargar el perfil.';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get accessLevel => 'Nivel de acceso';

  @override
  String get save => 'Guardar';

  @override
  String get profileSavedSuccessfully => 'Perfil guardado correctamente.';

  @override
  String get profileSaveError => 'No se pudo guardar el perfil.';

  @override
  String get profileDeleteError => 'No se pudo eliminar el cuenta.';

  @override
  String get deleteAccountHint => 'Eliminar tu cuenta eliminará todos tus datos guardados, incluidos tus favoritos. Esta acción no se puede deshacer.';

  @override
  String savedFavoritesCount(int count) {
    return '$count favoritos guardados';
  }

  @override
  String get usernameEmpty => 'Por favor, introduce un nombre de usuario.';

  @override
  String get usernameTooShort => 'El nombre de usuario debe tener al menos 3 caracteres.';

  @override
  String get usernameTooLong => 'El nombre de usuario no puede tener más de 20 caracteres.';

  @override
  String get usernameInvalidCharacters => 'El nombre de usuario solo puede contener letras, números, puntos, guiones bajos y guiones.';

  @override
  String get deleteAccountDialogTitle => 'Eliminar cuenta';

  @override
  String deleteAccountDialogDescription(String email) {
    return 'Por favor, introduce tu contraseña para $email para eliminar la cuenta.';
  }
}
