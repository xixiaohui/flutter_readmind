// app_constants.dart
// 应用常量定义

/// 应用名称
const String appName = 'ReadMeet Quotes';

/// 应用版本
const String appVersion = '1.0.0';

/// 数据库名称
const String databaseName = 'readmeet_quotes.db';

/// 路由路径
class RoutePaths {
  static const String splash = '/';
  static const String library = '/library';
  static const String reader = '/reader/:bookId';
  static const String highlights = '/highlights';
  static const String posters = '/posters';
  static const String settings = '/settings';
  static const String purchase = '/purchase';
  static const String import = '/import';

  // 私有构造函数防止实例化
  RoutePaths._();
}

/// 存储键
class StorageKeys {
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String onboardingComplete = 'onboarding_complete';
  static const String proStatus = 'pro_status';

  // 私有构造函数防止实例化
  StorageKeys._();
}

/// 文件类型
class FileTypes {
  static const String epub = 'epub';
  static const String pdf = 'pdf';
  static const String txt = 'txt';

  // 私有构造函数防止实例化
  FileTypes._();
}

/// 主题模式
class ThemeModeKeys {
  static const String light = 'light';
  static const String dark = 'dark';
  static const String sepia = 'sepia';

  // 私有构造函数防止实例化
  ThemeModeKeys._();
}

/// 高亮颜色
class HighlightColors {
  static const int yellow = 0xFFFFE28A;
  static const int green = 0xFFA7E6A2;
  static const int blue = 0xFFA7D8FF;
  static const int pink = 0xFFFFC8DD;

  // 私有构造函数防止实例化
  HighlightColors._();
}

/// 海报模板
class PosterTemplates {
  static const String minimal = 'minimal';
  static const String dark = 'dark';
  static const String paper = 'paper';
  static const String cover = 'cover';

  // 私有构造函数防止实例化
  PosterTemplates._();
}

/// 时间常量
class Timeouts {
  /// 导入超时（毫秒）
  static const int importTimeout = 30000;

  /// 海报生成超时（毫秒）
  static const int posterGenerationTimeout = 5000;

  // 私有构造函数防止实例化
  Timeouts._();
}
