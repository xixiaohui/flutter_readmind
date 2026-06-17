// highlights_page.dart
// 高亮页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/highlights_controller.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';

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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 高亮文本
            Container(
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
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  tooltip: 'Copy',
                  onPressed: () {
                    // Copy to clipboard
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  tooltip: 'Delete',
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
