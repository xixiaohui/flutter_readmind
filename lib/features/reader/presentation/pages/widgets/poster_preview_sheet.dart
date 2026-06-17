// poster_preview_sheet.dart
// 海报预览面板 — 在阅读器中以底部面板预览和调整海报

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../features/posters/domain/entities/poster.dart';
import '../../../../../../features/posters/presentation/controllers/poster_controller.dart';

/// 海报预览面板
class PosterPreviewSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const PosterPreviewSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final posterState = ref.watch(posterControllerProvider);
    final poster = posterState.currentPoster;
    final screenshotController = ScreenshotController();

    if (poster == null) {
      return Center(child: Text(l10n.noPosterToPreview));
    }

    return Column(
      children: [
        _DragHandle(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(l10n.posterPreview,
                  style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.save_alt, size: 18),
                label: Text(l10n.save),
                onPressed: () async {
                  await ref.read(posterControllerProvider.notifier).savePoster(
                      screenshotController: screenshotController);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.posterSaved)),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Screenshot(
                controller: screenshotController,
                child: _PosterPreviewCard(poster: poster),
              ),
              const SizedBox(height: 20),
              Text(l10n.template,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: PosterTemplate.values.map((template) {
                  final isSelected = template == posterState.selectedTemplate;
                  return ChoiceChip(
                    label: Text(_templateDisplayName(l10n, template)),
                    selected: isSelected,
                    onSelected: (_) {
                      ref
                          .read(posterControllerProvider.notifier)
                          .setTemplate(template);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(l10n.ratio,
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Row(
                children: PosterRatio.values.map((ratio) {
                  final isSelected = ratio == posterState.selectedRatio;
                  final labels = {
                    PosterRatio.square: '1:1',
                    PosterRatio.portrait: '4:5',
                    PosterRatio.story: '9:16',
                  };
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(labels[ratio]!),
                      selected: isSelected,
                      onSelected: (_) {
                        ref
                            .read(posterControllerProvider.notifier)
                            .setRatio(ratio);
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 获取模板本地化显示名称
  String _templateDisplayName(AppLocalizations l10n, PosterTemplate template) {
    switch (template) {
      case PosterTemplate.minimal:
        return l10n.templateMinimal;
      case PosterTemplate.paper:
        return l10n.templatePaper;
      case PosterTemplate.dark:
        return l10n.templateDark;
      case PosterTemplate.cover:
        return l10n.templateCover;
    }
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

/// 海报预览卡片
class _PosterPreviewCard extends StatelessWidget {
  final Poster poster;

  const _PosterPreviewCard({required this.poster});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = poster.template == PosterTemplate.dark;
    final bgColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '"${poster.quoteText}"',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: textColor,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 40,
            height: 2,
            color: isDark ? Colors.white30 : Colors.grey[400],
          ),
          const SizedBox(height: 12),
          if (poster.bookTitle != null)
            Text(
              poster.bookTitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white70 : Colors.grey[700],
                  ),
            ),
          if (poster.author != null) ...[
            const SizedBox(height: 4),
            Text(
              poster.author!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            l10n.appTitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isDark ? Colors.white30 : Colors.grey[400],
                  letterSpacing: 2,
                ),
          ),
        ],
      ),
    );
  }
}
