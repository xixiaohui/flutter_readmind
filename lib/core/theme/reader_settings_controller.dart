// reader_settings_controller.dart
// 全局阅读设置控制器 — 所有页面共享的字体、行距、阅读模式

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/reader/domain/entities/book_content.dart';

/// 全局阅读设置状态
class ReaderSettingsState {
  final ReaderFontFamily fontFamily;
  final double fontSize;
  final double lineHeight;
  final ReadingMode readingMode;

  const ReaderSettingsState({
    this.fontFamily = ReaderFontFamily.wenkai,
    this.fontSize = 18.0,
    this.lineHeight = 1.7,
    this.readingMode = ReadingMode.scroll,
  });

  ReaderSettingsState copyWith({
    ReaderFontFamily? fontFamily,
    double? fontSize,
    double? lineHeight,
    ReadingMode? readingMode,
  }) {
    return ReaderSettingsState(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      readingMode: readingMode ?? this.readingMode,
    );
  }
}

/// 全局阅读设置控制器
class ReaderSettingsController extends StateNotifier<ReaderSettingsState> {
  SharedPreferences? _prefs;

  ReaderSettingsController() : super(const ReaderSettingsState());

  /// 从 SharedPreferences 加载设置
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    state = ReaderSettingsState(
      fontFamily: _parseFontFamily(_prefs!.getString(_kFontFamily) ?? ''),
      fontSize: _prefs!.getDouble(_kFontSize) ?? 18.0,
      lineHeight: _prefs!.getDouble(_kLineHeight) ?? 1.7,
      readingMode: _prefs!.getString(_kReadingMode) == 'pagination'
          ? ReadingMode.pagination
          : ReadingMode.scroll,
    );
  }

  void setFontFamily(ReaderFontFamily family) {
    state = state.copyWith(fontFamily: family);
    _prefs?.setString(_kFontFamily, family.name);
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size);
    _prefs?.setDouble(_kFontSize, size);
  }

  void setLineHeight(double height) {
    final clamped = height.clamp(1.4, 2.2);
    state = state.copyWith(lineHeight: clamped);
    _prefs?.setDouble(_kLineHeight, clamped);
  }

  void setReadingMode(ReadingMode mode) {
    state = state.copyWith(readingMode: mode);
    _prefs?.setString(_kReadingMode, mode.name);
  }

  ReaderFontFamily _parseFontFamily(String value) {
    switch (value) {
      case 'serif': return ReaderFontFamily.serif;
      case 'monospace': return ReaderFontFamily.monospace;
      case 'sansSerif': return ReaderFontFamily.sansSerif;
      case 'wenkai': return ReaderFontFamily.wenkai;
      default: return ReaderFontFamily.wenkai;
    }
  }

  static const _kFontFamily = 'reader_font_family';
  static const _kFontSize = 'reader_font_size';
  static const _kLineHeight = 'reader_line_height';
  static const _kReadingMode = 'reader_reading_mode';
}

/// 全局阅读设置 Provider
final readerSettingsControllerProvider =
    StateNotifierProvider<ReaderSettingsController, ReaderSettingsState>((ref) {
  final controller = ReaderSettingsController();
  // 异步初始化（加载 SharedPreferences）
  Future.microtask(() => controller.init());
  return controller;
});
