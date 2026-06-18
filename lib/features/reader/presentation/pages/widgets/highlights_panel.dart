// highlights_panel.dart
// 高亮列表面板 — 在阅读器中以底部面板形式展示所有高亮

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../features/shared/domain/repositories/highlight_repository.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../features/posters/presentation/controllers/poster_controller.dart';
import '../../../../../../features/posters/presentation/pages/poster_editor_page.dart';
import '../../controllers/reader_controller.dart';
import '../../controllers/reader_highlight_controller.dart';

/// 高亮列表面板
class HighlightsPanel extends ConsumerWidget {
  final ScrollController scrollController;

  const HighlightsPanel({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final highlightState = ref.watch(readerHighlightControllerProvider);
    final readerState = ref.watch(readerControllerProvider);
    final highlights = highlightState.highlights;

    return Column(
      children: [
        _DragHandle(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${l10n.highlights} (${highlights.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (highlights.isNotEmpty)
                TextButton.icon(
                  icon: const Icon(Icons.image_outlined, size: 18),
                  label: Text(l10n.posterAll),
                  onPressed: () async {
                    final controller =
                        ref.read(posterControllerProvider.notifier);
                    // 从数据库获取真实书名
                    String? bookTitle;
                    final content = readerState.content;
                    if (content != null) {
                      final bookRepo = ref.read(bookRepositoryProvider);
                      final book =
                          await bookRepo.getBookById(content.bookId);
                      bookTitle = book?.title;
                    }
                    for (final h in highlights) {
                      controller.createPoster(
                        highlightId: h.id,
                        quoteText: h.selectedText,
                        bookTitle: bookTitle,
                      );
                      await controller.savePoster();
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              l10n.postersCreatedCount(highlights.length)),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: highlightState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : highlights.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.format_paint_outlined,
                              size: 48,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(height: 12),
                          Text(
                            l10n.selectTextToHighlight,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: highlights.length,
                      itemBuilder: (context, index) {
                        final highlight = highlights[index];
                        return _HighlightListItem(highlight: highlight);
                      },
                    ),
        ),
      ],
    );
  }
}

/// 拖拽手柄
class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// 高亮列表项
class _HighlightListItem extends ConsumerWidget {
  final HighlightData highlight;

  const _HighlightListItem({required this.highlight});

  Color _parseColor(String? hex) {
    if (hex == null) return Colors.yellow;
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final color = _parseColor(highlight.highlightColor);
    final readerState = ref.watch(readerControllerProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                highlight.selectedText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined, size: 20),
                  tooltip: l10n.createPoster,
                  onPressed: () async {
                    // 从数据库获取真实书名
                    String? bookTitle;
                    final content = readerState.content;
                    if (content != null) {
                      final bookRepo =
                          ref.read(bookRepositoryProvider);
                      final book =
                          await bookRepo.getBookById(content.bookId);
                      bookTitle = book?.title;
                    }
                    ref.read(posterControllerProvider.notifier).createPoster(
                          highlightId: highlight.id,
                          quoteText: highlight.selectedText,
                          bookTitle: bookTitle,
                        );
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const PosterEditorPage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  tooltip: l10n.delete,
                  onPressed: () {
                    final content = readerState.content;
                    if (content != null) {
                      ref
                          .read(readerHighlightControllerProvider.notifier)
                          .deleteHighlight(highlight.id, content.bookId);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

