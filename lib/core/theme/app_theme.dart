// app_theme.dart
// 应用主题定义

import 'package:flutter/material.dart';

/// 应用主题配置
class AppTheme {
  // ---- 颜色方案 ----

  static const _lightColors = ColorScheme.light(
    primary: Color(0xFF007AFF),
    onPrimary: Color(0xFFFFFFFF),
    surface: Color(0xFFFAF8F5),
    onSurface: Color(0xFF1D1D1F),
    secondary: Color(0xFF6E6E73),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFFF3B30),
    onError: Color(0xFFFFFFFF),
  );

  static const _darkColors = ColorScheme.dark(
    primary: Color(0xFF0A84FF),
    onPrimary: Color(0xFFFFFFFF),
    surface: Color(0xFF111111),
    onSurface: Color(0xFFF5F5F7),
    secondary: Color(0xFF9A9AA0),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFFF453A),
    onError: Color(0xFFFFFFFF),
  );

  static const _sepiaColors = ColorScheme.light(
    primary: Color(0xFFA16B39),
    onPrimary: Color(0xFFFFFFFF),
    surface: Color(0xFFF4ECD8),
    onSurface: Color(0xFF3E2F1C),
    secondary: Color(0xFF6D5E4A),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFC0392B),
    onError: Color(0xFFFFFFFF),
  );

  // ---- 文本主题 ----

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  );

  // ---- 公共组件配置 ----

  static const _cardTheme = CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
  );

  static const _elevatedButtonStyle = ButtonStyle(
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
    minimumSize: WidgetStatePropertyAll(Size(0, 52)),
  );

  static const _outlinedButtonStyle = ButtonStyle(
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
    minimumSize: WidgetStatePropertyAll(Size(0, 52)),
  );

  static const _textButtonStyle = ButtonStyle(
    minimumSize: WidgetStatePropertyAll(Size(0, 44)),
  );

  // ---- 构建主题 ----

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color scaffoldBg,
    required Color cardColor,
    required Color dividerColor,
    required Color appBarBg,
    required Color appBarFg,
  }) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: AppBarTheme(backgroundColor: appBarBg, foregroundColor: appBarFg, elevation: 0),
      cardTheme: _cardTheme.copyWith(color: cardColor),
      dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),
      textTheme: _textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(style: _elevatedButtonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: _outlinedButtonStyle),
      textButtonTheme: TextButtonThemeData(style: _textButtonStyle),
    );
  }

  /// Light 主题
  static ThemeData get light => _buildTheme(
        colorScheme: _lightColors,
        scaffoldBg: const Color(0xFFFAF8F5),
        cardColor: const Color(0xFFFFFFFF),
        dividerColor: const Color(0xFFE5E5E7),
        appBarBg: const Color(0xFFFAF8F5),
        appBarFg: const Color(0xFF1D1D1F),
      );

  /// Dark 主题
  static ThemeData get dark => _buildTheme(
        colorScheme: _darkColors,
        scaffoldBg: const Color(0xFF111111),
        cardColor: const Color(0xFF1C1C1E),
        dividerColor: const Color(0xFF2C2C2E),
        appBarBg: const Color(0xFF111111),
        appBarFg: const Color(0xFFF5F5F7),
      );

  /// Sepia 主题
  static ThemeData get sepia => _buildTheme(
        colorScheme: _sepiaColors,
        scaffoldBg: const Color(0xFFF4ECD8),
        cardColor: const Color(0xFFFFFFFF),
        dividerColor: const Color(0xFFD4C4A8),
        appBarBg: const Color(0xFFF4ECD8),
        appBarFg: const Color(0xFF3E2F1C),
      );
}
