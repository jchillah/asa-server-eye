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

  @override
  String get loading => '加载中';

  @override
  String get signIn => '登录';

  @override
  String get signUp => '注册';

  @override
  String get email => '电子邮件';

  @override
  String get password => '密码';

  @override
  String get repeatPassword => '重复输入密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get signInToContinue => '登录以继续使用你已保存的数据。';

  @override
  String get createAccount => '创建账户';

  @override
  String get createYourAccount => '创建你的账户';

  @override
  String get signUpToSaveFavorites => '注册后可在不同设备间保存你的收藏。';

  @override
  String get account => '账户';

  @override
  String get signOut => '退出登录';

  @override
  String get signOutDescription => '退出当前账户';

  @override
  String get authMissingEmailOrPassword => '请输入电子邮件和密码。';

  @override
  String get authInvalidEmailFormat => '请输入有效的电子邮件地址。';

  @override
  String get authUserDisabled => '此账户已被禁用。';

  @override
  String get authInvalidCredentials => '电子邮件或密码无效。';

  @override
  String get networkError => '网络错误，请重试。';

  @override
  String get authWeakPassword => '密码长度至少需要 6 个字符。';

  @override
  String get authEmailAlreadyInUse => '该电子邮件已被使用。';

  @override
  String get aboutBody => 'ASA Server Eye 是一款适用于 ARK: Survival Ascended 的伴侣应用。该应用可显示服务器信息、支持收藏功能，并为后续的关注列表、通知和高级功能奠定基础。\n\n开发和运营者：\nMichael Winkler\n电子邮件：asa.server.eye@gmail.com';

  @override
  String get privacyBody => '隐私政策\n\n数据处理负责人：\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\n德国\n电子邮件：asa.server.eye@gmail.com\n\n本应用使用 Firebase Authentication 进行账户登录，使用 Cloud Firestore 存储个人收藏，并使用 Google AdMob 提供广告。\n\n根据应用的使用方式，可能会处理技术数据，包括账户数据、设备信息、应用交互、标识符、诊断数据以及与广告相关的数据。收藏内容会按用户存储，以便在重新启动应用后以及在多个设备之间继续可用。\n\n这些数据处理用于提供应用功能、验证用户身份、保存与用户相关的设置以及通过广告为应用提供资金支持。\n\n不能排除集成的第三方服务会在欧盟以外处理数据。在这方面，也适用相关服务各自的隐私信息，尤其是 Google Firebase 和 Google AdMob。\n\n如有与隐私相关的问题或数据删除请求，请联系：\nasa.server.eye@gmail.com\n\n注意：在最终公开发布之前，应再次审查并补充本隐私政策，包括法律依据、保存期限、用户权利以及所有集成服务的完整信息。';

  @override
  String get imprintBody => '法律声明\n\nMichael Winkler\nAm Schülerheim 17\n14195 Berlin\n德国\n\n电子邮件：\nasa.server.eye@gmail.com\n\n内容负责人：\nMichael Winkler';

  @override
  String get supportBody => '支持\n\n如果你对本应用有任何问题、故障或反馈，请联系：\n\nMichael Winkler\n电子邮件：asa.server.eye@gmail.com\n\n请尽可能准确地描述你的问题，并尽量附上你的设备信息和应用版本。';

  @override
  String get contactSupport => '联系支持';

  @override
  String get emailAppCouldNotBeOpened => '无法打开电子邮件应用。';

  @override
  String get supportEmailSubject => 'ASA Server Eye 支持';

  @override
  String get supportEmailBodyTemplate => '你好 Michael，\n\n我遇到了以下问题：\n\n\n---\n应用版本：\n设备：\n';

  @override
  String get fullPrivacyPolicy => '完整隐私政策';

  @override
  String get deleteAccount => '删除账户';
}
