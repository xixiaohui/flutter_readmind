// highlights_page.dart
// 高亮页面

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/highlights_controller.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/shared/domain/repositories/book_repository.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';
import '../../../../features/posters/presentation/controllers/poster_controller.dart';
import '../../../../features/posters/presentation/pages/poster_editor_page.dart';

/// 高亮页面
class HighlightsPage extends ConsumerWidget {
  const HighlightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final highlightsAsync = ref.watch(allHighlightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.highlights,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: highlightsAsync.when(
        data: (highlights) {
          if (highlights.isEmpty) {
            return _EmptyHighlights(l10n: l10n);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              final highlight = highlights[index];
              return _HighlightCard(highlight: highlight);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off,
                size: 64,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.webDatabaseUnavailable,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 空高亮状态
class _EmptyHighlights extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyHighlights({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.highlight_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noHighlights,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.createHighlight,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// 高亮卡片
class _HighlightCard extends ConsumerWidget {
  final HighlightData highlight;

  const _HighlightCard({required this.highlight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 高亮文本
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getHighlightColor(highlight.highlightColor)
                    .withAlpha(60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                highlight.selectedText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 8),

            // 操作按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 生成海报
                TextButton.icon(
                  icon: const Icon(Icons.auto_awesome, size: 18),
                  label: Text(l10n.generatePoster,
                      style: const TextStyle(fontSize: 13)),
                  onPressed: () async {
                    // 查询书名
                    final bookRepo = ref.read(bookRepositoryProvider);
                    final book =
                        await bookRepo.getBookById(highlight.bookId);
                    ref.read(posterControllerProvider.notifier).createPoster(
                          highlightId: highlight.id,
                          quoteText: highlight.selectedText,
                          bookTitle: book?.title,
                          author: book?.author,
                        );
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const PosterEditorPage()));
                  },
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: l10n.copy,
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: highlight.selectedText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.copy),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  tooltip: l10n.delete,
                  onPressed: () {
                    ref
                        .read(highlightsControllerProvider.notifier)
                        .deleteHighlight(highlight.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 获取高亮颜色
  Color _getHighlightColor(String? colorHex) {
    if (colorHex == null) return Colors.yellow;
    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

