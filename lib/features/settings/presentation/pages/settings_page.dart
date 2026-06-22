// settings_page.dart
// 设置页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme_mode.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/theme/locale_controller.dart';
import '../../../../core/theme/reader_settings_controller.dart';
import '../../../../features/reader/domain/entities/book_content.dart';
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

          // 阅读设置
          const _ReadingSettingsSection(),
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

// ─── 阅读设置 ───

class _ReadingSettingsSection extends ConsumerWidget {
  const _ReadingSettingsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(readerSettingsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(l10n.readingSettings,
              style: Theme.of(context).textTheme.titleMedium),
        ),

        // ── 字体家族 ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.fontFamily,
              style: Theme.of(context).textTheme.labelLarge),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<ReaderFontFamily>(
            segments: [
              ButtonSegment(value: ReaderFontFamily.sansSerif, label: Text(l10n.sansSerif)),
              ButtonSegment(value: ReaderFontFamily.serif, label: Text(l10n.serif)),
              ButtonSegment(value: ReaderFontFamily.wenkai, label: Text(l10n.wenkai)),
              ButtonSegment(value: ReaderFontFamily.monospace, label: Text(l10n.monospace)),
            ],
            selected: {settings.fontFamily},
            onSelectionChanged: (f) {
              ref.read(readerSettingsControllerProvider.notifier).setFontFamily(f.first);
            },
          ),
        ),
        const SizedBox(height: 16),

        // ── 字体大小 ──
        ListTile(
          title: Text(l10n.fontSize),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => ref
                    .read(readerSettingsControllerProvider.notifier)
                    .setFontSize((settings.fontSize - 2).clamp(12, 36)),
              ),
              Text('${settings.fontSize.round()}',
                  style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => ref
                    .read(readerSettingsControllerProvider.notifier)
                    .setFontSize((settings.fontSize + 2).clamp(12, 36)),
              ),
            ],
          ),
        ),

        // ── 行间距 ──
        ListTile(
          title: Text(l10n.lineHeight),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => ref
                    .read(readerSettingsControllerProvider.notifier)
                    .setLineHeight(settings.lineHeight - 0.1),
              ),
              Text(settings.lineHeight.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => ref
                    .read(readerSettingsControllerProvider.notifier)
                    .setLineHeight(settings.lineHeight + 0.1),
              ),
            ],
          ),
        ),

        // ── 阅读模式 ──
        ListTile(
          title: Text(l10n.readingMode),
          trailing: SegmentedButton<ReadingMode>(
            segments: [
              ButtonSegment(value: ReadingMode.scroll, label: Text(l10n.scroll)),
              ButtonSegment(value: ReadingMode.pagination, label: Text(l10n.pagination)),
            ],
            selected: {settings.readingMode},
            onSelectionChanged: (m) {
              ref.read(readerSettingsControllerProvider.notifier).setReadingMode(m.first);
            },
          ),
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
