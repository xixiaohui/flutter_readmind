// locale_controller.dart
// 语言控制器

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// 支持的语言列表
const supportedLocales = [
  Locale('en'),
  Locale('zh'),
  Locale('ja'),
];

/// 语言名称映射
const localeNames = {
  'en': 'English',
  'zh': '中文',
  'ja': '日本語',
};

/// 语言控制器
class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(StorageKeys.locale) ?? 'en';
    state = Locale(langCode);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.locale, locale.languageCode);
  }
}

/// Locale Provider
final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>(
  (ref) => LocaleController(),
);
