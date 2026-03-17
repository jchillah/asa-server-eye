// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'ASA Server Eye';

  @override
  String get servers => '服务器';

  @override
  String get favorites => '收藏';

  @override
  String get settings => '设置';

  @override
  String get searchServersOrMaps => '搜索服务器或地图';

  @override
  String get noServersFound => '未找到服务器';

  @override
  String get noServersMatchSearch => '没有服务器符合你的搜索';

  @override
  String get serverDetails => '服务器详情';

  @override
  String get serverNotFound => '未找到服务器';

  @override
  String get map => '地图';

  @override
  String get population => '人数';

  @override
  String get type => '类型';

  @override
  String get official => '官方';

  @override
  String get unofficial => '非官方';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get addedToFavorites => '已添加到收藏';

  @override
  String get removedFromFavorites => '已从收藏中移除';

  @override
  String get noFavoritesYet => '还没有收藏';

  @override
  String get removeFavorite => '移除收藏';

  @override
  String get cancel => '取消';

  @override
  String get remove => '移除';

  @override
  String get apply => '应用';

  @override
  String removeFavoriteQuestion(String serverName) {
    return '要将“$serverName”从收藏中移除吗？';
  }

  @override
  String removedServerFromFavorites(String serverName) {
    return '$serverName 已从收藏中移除';
  }

  @override
  String get general => '通用';

  @override
  String get language => '语言';

  @override
  String get systemDefault => '系统默认';

  @override
  String get systemLanguage => '系统语言';

  @override
  String get german => '德语';

  @override
  String get english => '英语';

  @override
  String get spanish => '西班牙语';

  @override
  String get chinese => '中文';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get about => '关于';

  @override
  String get appInformation => '应用信息';

  @override
  String get legal => '法律信息';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get howDataIsHandled => '数据如何处理';

  @override
  String get imprint => '法律声明';

  @override
  String get legalInformation => '法律信息';

  @override
  String get support => '支持';

  @override
  String get getHelpAndContactSupport => '获取帮助并联系支持';

  @override
  String comingSoon(String title) {
    return '$title 即将推出';
  }

  @override
  String get french => '法语';

  @override
  String get genericError => '发生错误，请重试。';
}
