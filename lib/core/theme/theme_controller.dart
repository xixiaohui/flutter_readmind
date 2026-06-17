// theme_controller.dart
// 主题控制器

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme_mode.dart';
import '../../core/constants/app_constants.dart';

/// 主题控制器
class ThemeController extends StateNotifier<AppThemeMode> {
  ThemeController() : super(AppThemeMode.light) {
    _loadTheme();
  }

  /// 加载保存的主题
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(StorageKeys.themeMode);
    state = AppThemeModeExtension.fromStorageString(themeStr);
  }

  /// 设置主题
  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.themeMode, mode.toStorageString());
  }

  /// 切换主题（循环切换）
  Future<void> toggleTheme() async {
    switch (state) {
      case AppThemeMode.light:
        await setTheme(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        await setTheme(AppThemeMode.sepia);
        break;
      case AppThemeMode.sepia:
        await setTheme(AppThemeMode.light);
        break;
    }
  }
}

/// 主题控制器 Provider
final themeControllerProvider =
    StateNotifierProvider<ThemeController, AppThemeMode>(
  (ref) => ThemeController(),
);
