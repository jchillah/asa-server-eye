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
}
