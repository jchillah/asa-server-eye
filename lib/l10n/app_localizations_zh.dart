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
  String get aboutBody => 'ASA Server Eye is a companion app for ARK: Survival Ascended. The app displays server information, supports favorites, and provides the foundation for future features like watchlists, notifications, and premium features.';

  @override
  String get privacyBody => 'Privacy Notice\n\nThis app uses Firebase Authentication for account sign-in, Cloud Firestore to store personal favorites, and Google AdMob to serve advertising.\n\nDepending on how the app is used, technical data such as device information, app interactions, approximate location, identifiers, or diagnostic data may be processed. Some of this data may be processed by integrated third-party SDKs.\n\nFavorites are stored per user so they remain available after restarting the app and across multiple devices.\n\nBefore release, replace this text with a complete privacy policy containing your real legal details, controller information, legal bases, third-party services, retention periods, and user rights.';

  @override
  String get imprintBody => 'Imprint / Legal Notice\n\nInformation according to applicable legal requirements\n\nName / Company:\n[YOUR NAME OR COMPANY NAME]\n\nAddress:\n[YOUR FULL ADDRESS]\n\nEmail:\n[YOUR CONTACT EMAIL]\n\nResponsible for content:\n[YOUR NAME]\n\nNote: Before release, replace all placeholders with your real legal information.';

  @override
  String get supportBody => 'Support\n\nFor questions, issues, or feedback, please contact us at:\n[YOUR SUPPORT EMAIL]\n\nLater, you can also add a support website, FAQ, or community links here.';
}
