// main.dart
// 应用入口

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_mode.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/locale_controller.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ReadMeetApp()));
}

/// ReadMeet 主应用
class ReadMeetApp extends ConsumerWidget {
  const ReadMeetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'ReadMeet Quotes',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _mapToThemeMode(themeMode),
      locale: locale,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  /// 将 AppThemeMode 映射到 ThemeMode
  ThemeMode _mapToThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.sepia:
        return ThemeMode.light;
    }
  }
}
