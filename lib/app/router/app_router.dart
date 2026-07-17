// app_router.dart
// 应用路由配置

import 'package:go_router/go_router.dart';

import '../../features/library/presentation/pages/library_page.dart';
import '../../features/highlights/presentation/pages/highlights_page.dart';
import '../../features/posters/presentation/pages/posters_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/import/presentation/pages/import_page.dart';
import '../../features/reader/presentation/pages/reader_page.dart';
import '../../features/purchase/presentation/pages/purchase_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../app_shell.dart';

/// 应用路由配置
final GoRouter appRouter = GoRouter(
  initialLocation: '/library',
  routes: [
    /// 应用外壳（带底部导航）
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) => AppShell(child: child),
      branches: [
        /// 书架标签
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryPage(),
            ),
          ],
        ),

        /// 高亮标签
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/highlights',
              builder: (context, state) => const HighlightsPage(),
            ),
          ],
        ),

        /// 海报标签
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/posters',
              builder: (context, state) => const PostersPage(),
            ),
          ],
        ),

        /// 设置标签
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),

    /// 导入页面（独立路由）
    GoRoute(
      path: '/import',
      builder: (context, state) => const ImportPage(),
    ),

    /// 搜索页面（独立路由）
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),

    /// 购买页面（独立路由）
    GoRoute(
      path: '/purchase',
      builder: (context, state) => const PurchasePage(),
    ),

    /// 阅读器页面（独立路由）
    GoRoute(
      path: '/reader',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        return ReaderPage(
          filePath: extra['filePath']!,
          fileType: extra['fileType']!,
          bookTitle: extra['bookTitle']!,
          bookId: int.tryParse(extra['bookId'] ?? '0') ?? 0,
        );
      },
    ),
  ],
);
