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
  String get profileDeleteError => 'No se pudo eliminar la cuenta.';

  @override
  String get deleteAccountHint => 'Eliminar tu cuenta quitará tu perfil. Los sightings existentes permanecerán.';

  @override
  String savedFavoritesCount(int count) {
    return '$count guardados';
  }

  @override
  String get usernameEmpty => 'Introduce un nombre de usuario.';

  @override
  String get usernameTooShort => 'El nombre de usuario debe tener al menos 3 caracteres.';

  @override
  String get usernameTooLong => 'El nombre de usuario puede tener como máximo 20 caracteres.';

  @override
  String get usernameInvalidCharacters => 'El nombre de usuario solo puede contener letras, números, puntos, guiones bajos y guiones.';

  @override
  String get deleteAccountDialogTitle => 'Eliminar cuenta';

  @override
  String deleteAccountDialogDescription(String email) {
    return 'Introduce tu contraseña para $email para eliminar tu cuenta.';
  }

  @override
  String get signUpUsernameHint => 'Este será tu nombre de usuario público visible para otros usuarios.';

  @override
  String get emailHint => 'nombre@email.com';

  @override
  String get sightings => 'Avistamientos';

  @override
  String get playerSightingReport => 'Reportar avistamiento de jugador';

  @override
  String get editSighting => 'Editar avistamiento';

  @override
  String get deleteSighting => 'Eliminar avistamiento';

  @override
  String get sightingHistory => 'Historial de cambios';

  @override
  String get platformId => 'ID de plataforma';

  @override
  String get platformIdHint => 'ID de Steam / Xbox / PSN';

  @override
  String get inGameName => 'Nombre dentro del juego';

  @override
  String get tribeName => 'Nombre de la tribu';

  @override
  String get tribeNameHint => 'Nombre de la tribu';

  @override
  String get platform => 'Plataforma';

  @override
  String get note => 'Nota';

  @override
  String get optional => 'Opcional';

  @override
  String get visibleToPremiumUsers => 'Visible para usuarios premium';

  @override
  String get saveSighting => 'Guardar avistamiento';

  @override
  String get updateSighting => 'Guardar cambios';

  @override
  String get hideSighting => 'Ocultar avistamiento';

  @override
  String get saving => 'Guardando...';

  @override
  String get sightingSaved => 'Avistamiento guardado.';

  @override
  String get sightingUpdated => 'Avistamiento actualizado.';

  @override
  String get sightingHidden => 'Avistamiento ocultado.';

  @override
  String get sightingSaveError => 'No se pudo guardar el avistamiento.';

  @override
  String get sightingUpdateError => 'No se pudo actualizar el avistamiento.';

  @override
  String get sightingHideError => 'No se pudo ocultar el avistamiento.';

  @override
  String get sightingRequiresLogin => 'Debes iniciar sesión para reportar un avistamiento.';

  @override
  String get sightingDeleteNotAllowed => 'No tienes permiso para eliminar este avistamiento.';

  @override
  String get sightingEditNotAllowed => 'No tienes permiso para editar este avistamiento.';

  @override
  String get sightingInGameNameRequired => 'Introduce un nombre de jugador.';

  @override
  String get sightingPlatformIdRequired => 'Introduce un ID de plataforma.';

  @override
  String get sightingTribeNameRequired => 'Introduce un nombre de tribu.';

  @override
  String get sightingReasonRequired => 'Introduce un motivo.';

  @override
  String get sightingDeleteHint => 'Este avistamiento no se eliminará de forma permanente. Solo se ocultará para los usuarios normales y seguirá siendo rastreable para los administradores.';

  @override
  String get reason => 'Motivo';

  @override
  String get reasonHint => 'Introduce un motivo';

  @override
  String get noVisibleSightings => 'Todavía no hay sightings visibles.';

  @override
  String get sightingsLoadError => 'No se pudieron cargar los sightings.';

  @override
  String get sightingHistoryLoadError => 'No se pudo cargar el historial.';

  @override
  String get noSightingHistory => 'Todavía no hay historial disponible.';

  @override
  String get accessLevelLoadError => 'No se pudo cargar el nivel de acceso.';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get viewHistory => 'Ver historial';

  @override
  String get platformSteam => 'Steam';

  @override
  String get platformXbox => 'Xbox';

  @override
  String get platformPsn => 'PSN';

  @override
  String get platformUnknown => 'Desconocido';

  @override
  String get sightingUserProfileLoadError => 'No se pudo cargar el perfil del usuario.';

  @override
  String get playerSightings => 'Avistamientos de jugadores';

  @override
  String platformLabel(String value) {
    return 'Plataforma: $value';
  }

  @override
  String visibilityLabel(String value) {
    return 'Visibilidad: $value';
  }

  @override
  String sharingLabel(String value) {
    return 'Compartición: $value';
  }

  @override
  String editedAtLabel(String value) {
    return 'Editado: $value';
  }

  @override
  String get softDeleted => 'Eliminado lógicamente';

  @override
  String reasonLabel(String value) {
    return 'Motivo: $value';
  }

  @override
  String changedByLabel(String value) {
    return 'Cambiado por: $value';
  }

  @override
  String get sightingCreatorLevelFree => 'Free';

  @override
  String get sightingCreatorLevelPremium => 'Premium';

  @override
  String get sightingCreatorLevelAdmin => 'Admin';

  @override
  String get sightingSharingOwnerOnly => 'Solo propietario';

  @override
  String get sightingSharingPremiumShared => 'Compartido con premium';

  @override
  String get sightingSharingAdminOnly => 'Solo administradores';

  @override
  String get sightingActionCreated => 'Creado';

  @override
  String get sightingActionUpdated => 'Actualizado';

  @override
  String get sightingActionSoftDeleted => 'Ocultado';

  @override
  String get viewPlayerSightings => 'Ver avistamientos';

  @override
  String get reportPlayerSighting => 'Reportar avistamiento de jugador';

  @override
  String get accountCreated => 'Cuenta creada exitosamente';

  @override
  String get accountCreationFailed => 'No se pudo crear la cuenta. Por favor, intenta de nuevo.';

  @override
  String get accountDeleted => 'Cuenta eliminada exitosamente';

  @override
  String get accountDeletionFailed => 'No se pudo eliminar la cuenta. Por favor, intenta de nuevo.';

  @override
  String get deletePermanently => 'Eliminar permanentemente';

  @override
  String get deletePermanentlyConfirmation => 'Esta observación y su historial serán eliminados permanentemente. Esta acción no puede ser deshecha.';

  @override
  String get sightingDeletedPermanently => 'Avistamiento eliminado permanentemente';

  @override
  String get premiumRequiredForMoreFavorites => 'Necesitas Premium para guardar más de un favorito.';

  @override
  String get serversNavLabel => 'Servidores';

  @override
  String get favoritesNavLabel => 'Favoritos';

  @override
  String get sightingsNavLabel => 'Avistam.';

  @override
  String get settingsNavLabel => 'Ajustes';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumSettingsSubtitle => 'Funciones premium y sus beneficios';

  @override
  String get premiumHeadline => 'Mejora tu experiencia con Premium';

  @override
  String get premiumDescription => 'Obtén acceso a funciones exclusivas, mejora tu experiencia y apoya el desarrollo continuo de la aplicación con una suscripción premium.';

  @override
  String get premiumBenefitSightingsTitle => 'Avistamientos de jugadores';

  @override
  String get premiumBenefitSightingsDescription => 'Reporta avistamientos de jugadores en servidores específicos y hazlos visibles para otros usuarios premium.';

  @override
  String get premiumBenefitFavoritesTitle => 'Más favoritos';

  @override
  String get premiumBenefitFavoritesDescription => 'Guarda significativamente más servidores en tus favoritos.';

  @override
  String get premiumBenefitAlertsTitle => 'Alertas y seguimiento';

  @override
  String get premiumBenefitAlertsDescription => 'Prepárate para funciones premium futuras como el seguimiento mejorado y las alertas.';

  @override
  String get premiumMonthlyPlan => 'Mensual';

  @override
  String get premiumMonthlyPlanDescription => 'Cancellation flexible';

  @override
  String get premiumYearlyPlan => 'Anual';

  @override
  String get premiumYearlyPlanDescription => 'Ahorro con suscripción anual';

  @override
  String get premiumStartMonthly => 'Comenzar mensual';

  @override
  String get premiumStartYearly => 'Comenzar anual';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get premiumPurchaseComingSoon => 'Compra de premium próximamente';

  @override
  String get premiumUpgradeTitle => 'Mejora a Premium';

  @override
  String get premiumUpgradeDescription => 'Actualiza a Premium para desbloquear funciones exclusivas y mejorar tu experiencia en ASA Server Eye.';

  @override
  String get premiumActiveTitle => 'Premium activo';

  @override
  String get premiumActiveDescription => 'Tu suscripción Premium está activa. Gracias por apoyar el desarrollo de la aplicación. Disfruta de tus funciones exclusivas y mantente atento a futuras mejoras.';

  @override
  String get unlockPremium => 'Desbloquear Premium';

  @override
  String get managePremium => 'Gestionar Premium';

  @override
  String get premiumStoreUnavailable => 'Tienda de premium no disponible';

  @override
  String get premiumProductsUnavailable => 'Actualmente no se pueden cargar productos premium.';

  @override
  String get premiumPurchaseError => 'Error al comprar premium. Por favor, intenta de nuevo.';

  @override
  String get premiumRestoreSuccess => 'Compras restauradas exitosamente';

  @override
  String get premiumRestoreError => 'Error al restaurar compras. Por favor, intenta de nuevo.';

  @override
  String get premiumPurchasePending => 'Tu compra está siendo procesada. Premium se desbloqueará después de la verificación exitosa.';

  @override
  String get premiumExpiredDescription => 'Tu acceso premium ha expirado. Puedes desbloquear Premium nuevamente en cualquier momento.';

  @override
  String get premiumVerificationQueued => 'Tu compra fue enviada y ahora está siendo verificada.';
}
