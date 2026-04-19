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

  @override
  String get profile => '个人资料';

  @override
  String get profileLoadError => '无法加载个人资料。';

  @override
  String get username => '用户名';

  @override
  String get accessLevel => '访问级别';

  @override
  String get save => '保存';

  @override
  String get profileSavedSuccessfully => '个人资料已成功保存。';

  @override
  String get profileSaveError => '无法保存个人资料。';

  @override
  String get profileDeleteError => '无法删除账户。';

  @override
  String get deleteAccountHint => '删除账户将移除你的个人资料。已创建的 sightings 将会保留。';

  @override
  String savedFavoritesCount(int count) {
    return '已保存 $count 个';
  }

  @override
  String get usernameEmpty => '请输入用户名。';

  @override
  String get usernameTooShort => '用户名至少需要 3 个字符。';

  @override
  String get usernameTooLong => '用户名最多只能有 20 个字符。';

  @override
  String get usernameInvalidCharacters => '用户名只能包含字母、数字、句点、下划线和连字符。';

  @override
  String get deleteAccountDialogTitle => '删除账户';

  @override
  String deleteAccountDialogDescription(String email) {
    return '请输入 $email 的密码以删除你的账户。';
  }

  @override
  String get signUpUsernameHint => '这将是其他用户可见的公开用户名。';

  @override
  String get emailHint => 'name@email.com';

  @override
  String get sightings => '目击记录';

  @override
  String get playerSightingReport => '报告玩家目击记录';

  @override
  String get editSighting => '编辑目击记录';

  @override
  String get deleteSighting => '删除目击记录';

  @override
  String get sightingHistory => '变更历史';

  @override
  String get platformId => '平台 ID';

  @override
  String get platformIdHint => 'Steam / Xbox / PSN ID';

  @override
  String get inGameName => '游戏内名称';

  @override
  String get tribeName => '部落名称';

  @override
  String get tribeNameHint => '部落名称';

  @override
  String get platform => '平台';

  @override
  String get note => '备注';

  @override
  String get optional => '可选';

  @override
  String get visibleToPremiumUsers => '对高级用户可见';

  @override
  String get saveSighting => '保存目击记录';

  @override
  String get updateSighting => '保存更改';

  @override
  String get hideSighting => '隐藏目击记录';

  @override
  String get saving => '正在保存...';

  @override
  String get sightingSaved => '目击记录已保存。';

  @override
  String get sightingUpdated => '目击记录已更新。';

  @override
  String get sightingHidden => '目击记录已隐藏。';

  @override
  String get sightingSaveError => '无法保存目击记录。';

  @override
  String get sightingUpdateError => '无法更新目击记录。';

  @override
  String get sightingHideError => '无法隐藏目击记录。';

  @override
  String get sightingRequiresLogin => '你必须登录后才能报告目击记录。';

  @override
  String get sightingDeleteNotAllowed => '你无权删除此目击记录。';

  @override
  String get sightingEditNotAllowed => '你无权编辑此目击记录。';

  @override
  String get sightingInGameNameRequired => '请输入玩家名称。';

  @override
  String get sightingPlatformIdRequired => '请输入平台 ID。';

  @override
  String get sightingTribeNameRequired => '请输入部落名称。';

  @override
  String get sightingReasonRequired => '请输入原因。';

  @override
  String get sightingDeleteHint => '该目击记录不会被永久删除。它只会对普通用户隐藏，并仍可供管理员追踪。';

  @override
  String get reason => '原因';

  @override
  String get reasonHint => '请输入原因';

  @override
  String get noVisibleSightings => '目前还没有可见的 sightings。';

  @override
  String get sightingsLoadError => '无法加载 sightings。';

  @override
  String get sightingHistoryLoadError => '无法加载历史记录。';

  @override
  String get noSightingHistory => '暂无历史记录。';

  @override
  String get accessLevelLoadError => '无法加载访问级别。';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get viewHistory => '查看历史';

  @override
  String get platformSteam => 'Steam';

  @override
  String get platformXbox => 'Xbox';

  @override
  String get platformPsn => 'PSN';

  @override
  String get platformUnknown => '未知';

  @override
  String get sightingUserProfileLoadError => '无法加载用户资料。';

  @override
  String get playerSightings => '玩家目击记录';

  @override
  String platformLabel(String value) {
    return '平台：$value';
  }

  @override
  String visibilityLabel(String value) {
    return '可见性：$value';
  }

  @override
  String sharingLabel(String value) {
    return '共享：$value';
  }

  @override
  String editedAtLabel(String value) {
    return '编辑于：$value';
  }

  @override
  String get softDeleted => '软删除';

  @override
  String reasonLabel(String value) {
    return '原因：$value';
  }

  @override
  String changedByLabel(String value) {
    return '修改者：$value';
  }

  @override
  String get sightingCreatorLevelFree => 'Free';

  @override
  String get sightingCreatorLevelPremium => 'Premium';

  @override
  String get sightingCreatorLevelAdmin => 'Admin';

  @override
  String get sightingSharingOwnerOnly => '仅创建者';

  @override
  String get sightingSharingPremiumShared => '与 Premium 共享';

  @override
  String get sightingSharingAdminOnly => '仅管理员';

  @override
  String get sightingActionCreated => '创建';

  @override
  String get sightingActionUpdated => '更新';

  @override
  String get sightingActionSoftDeleted => '隐藏';

  @override
  String get viewPlayerSightings => '查看玩家目击记录';

  @override
  String get reportPlayerSighting => '举报玩家目击记录';

  @override
  String get accountCreated => '账户成功创建';

  @override
  String get accountCreationFailed => '账户创建失败。请重试。';

  @override
  String get accountDeleted => '账户删除成功';

  @override
  String get accountDeletionFailed => '账户删除失败。请重试。';

  @override
  String get deletePermanently => '永久删除';

  @override
  String get deletePermanentlyConfirmation => '你确定要永久删除这个目击记录吗？这将无法恢复。';

  @override
  String get sightingDeletedPermanently => '目击记录已永久删除';

  @override
  String get premiumRequiredForMoreFavorites => '需要 Premium 才能保存更多收藏';

  @override
  String get serversNavLabel => '服务器';

  @override
  String get favoritesNavLabel => '收藏';

  @override
  String get sightingsNavLabel => '目击';

  @override
  String get settingsNavLabel => '设置';

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
  String get premiumStoreUnavailable => '当前无法连接到商店。';

  @override
  String get premiumProductsUnavailable => '当前无法加载 Premium 产品。';

  @override
  String get premiumPurchaseError => '购买过程中发生错误。请重试。';

  @override
  String get premiumRestoreSuccess => '购买恢复成功。';

  @override
  String get premiumRestoreError => '购买恢复过程中发生错误。请重试。';
}
