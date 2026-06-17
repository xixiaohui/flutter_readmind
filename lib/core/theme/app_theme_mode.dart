// app_theme_mode.dart
// 应用主题模式枚举

/// 应用主题模式
enum AppThemeMode {
  light,
  dark,
  sepia,
}

/// 主题模式扩展
extension AppThemeModeExtension on AppThemeMode {
  /// 转换为字符串
  String toStorageString() {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.sepia:
        return 'sepia';
    }
  }

  /// 从字符串转换
  static AppThemeMode fromStorageString(String? str) {
    switch (str) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'sepia':
        return AppThemeMode.sepia;
      default:
        return AppThemeMode.light;
    }
  }
}
