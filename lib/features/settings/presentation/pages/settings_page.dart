// settings_page.dart
// 设置页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme_mode.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/theme/locale_controller.dart';
import '../../../../l10n/app_localizations.dart';

/// 设置页面
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeControllerProvider);
    final currentLocale = ref.watch(localeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListView(
        children: [
          // 主题设置
          _ThemeSection(currentTheme: themeMode),
          const Divider(),

          // 语言设置
          _LanguageSection(currentLocale: currentLocale),
          const Divider(),

          // 购买设置
          ListTile(
            leading: const Icon(Icons.shopping_cart_outlined),
            title: Text(l10n.purchase),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/purchase'),
          ),
        ],
      ),
    );
  }
}

/// 主题设置区域
class _ThemeSection extends ConsumerWidget {
  final AppThemeMode currentTheme;

  const _ThemeSection({required this.currentTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.theme,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListTile(
          leading: Icon(
            currentTheme == AppThemeMode.light
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
          ),
          title: Text(l10n.lightMode),
          onTap: () {
            ref
                .read(themeControllerProvider.notifier)
                .setTheme(AppThemeMode.light);
          },
        ),
        ListTile(
          leading: Icon(
            currentTheme == AppThemeMode.dark
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
          ),
          title: Text(l10n.darkMode),
          onTap: () {
            ref
                .read(themeControllerProvider.notifier)
                .setTheme(AppThemeMode.dark);
          },
        ),
        ListTile(
          leading: Icon(
            currentTheme == AppThemeMode.sepia
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
          ),
          title: Text(l10n.sepiaMode),
          onTap: () {
            ref
                .read(themeControllerProvider.notifier)
                .setTheme(AppThemeMode.sepia);
          },
        ),
      ],
    );
  }
}

/// 语言设置区域
class _LanguageSection extends ConsumerWidget {
  final Locale currentLocale;

  const _LanguageSection({required this.currentLocale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListTile(
          leading: Icon(
            currentLocale.languageCode == 'en'
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
          ),
          title: Text(l10n.english),
          onTap: () {
            ref
                .read(localeControllerProvider.notifier)
                .setLocale(const Locale('en'));
          },
        ),
        ListTile(
          leading: Icon(
            currentLocale.languageCode == 'zh'
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
          ),
          title: Text(l10n.chinese),
          onTap: () {
            ref
                .read(localeControllerProvider.notifier)
                .setLocale(const Locale('zh'));
          },
        ),
        ListTile(
          leading: Icon(
            currentLocale.languageCode == 'ja'
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
          ),
          title: Text(l10n.japanese),
          onTap: () {
            ref
                .read(localeControllerProvider.notifier)
                .setLocale(const Locale('ja'));
          },
        ),
      ],
    );
  }
}
