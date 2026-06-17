// app_shell.dart
// 应用外壳（带底部导航）

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

/// 应用外壳
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.book_outlined),
            selectedIcon: const Icon(Icons.book),
            label: l10n.library,
          ),
          NavigationDestination(
            icon: const Icon(Icons.highlight_outlined),
            selectedIcon: const Icon(Icons.highlight),
            label: l10n.highlights,
          ),
          NavigationDestination(
            icon: const Icon(Icons.image_outlined),
            selectedIcon: const Icon(Icons.image),
            label: l10n.posters,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
      ),
    );
  }

  /// 计算当前选中的导航索引
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/library')) return 0;
    if (location.startsWith('/highlights')) return 1;
    if (location.startsWith('/posters')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  /// 处理导航项点击
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/library');
        break;
      case 1:
        GoRouter.of(context).go('/highlights');
        break;
      case 2:
        GoRouter.of(context).go('/posters');
        break;
      case 3:
        GoRouter.of(context).go('/settings');
        break;
    }
  }
}
