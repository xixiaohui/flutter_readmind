// poster_full_view.dart
// 海报全屏查看页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/poster.dart';
import '../../controllers/poster_controller.dart';

/// 全屏海报视图
class PosterFullView extends ConsumerWidget {
  final Poster poster;
  final AppLocalizations l10n;
  const PosterFullView({super.key, required this.poster, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = poster.template == PosterTemplate.dark;
    final bg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final fg = isDark ? Colors.white : const Color(0xFF1D1D1F);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: fg),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: fg),
            tooltip: l10n.share,
            onPressed: () =>
                ref.read(posterControllerProvider.notifier).sharePoster(poster),
          ),
          IconButton(
            icon: Icon(Icons.save_alt, color: fg),
            tooltip: 'Save to Gallery',
            onPressed: () async {
              await ref
                  .read(posterControllerProvider.notifier)
                  .saveToGallery(poster);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved to gallery')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('"${poster.quoteText}"',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontStyle: FontStyle.italic, color: fg, height: 1.6)),
              const SizedBox(height: 32),
              Container(width: 60, height: 1.5, color: fg.withAlpha(51)),
              const SizedBox(height: 20),
              if (poster.bookTitle != null)
                Text(poster.bookTitle!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: fg.withAlpha(200))),
              if (poster.author != null) ...[
                const SizedBox(height: 8),
                Text(poster.author!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: fg.withAlpha(153))),
              ],
              const SizedBox(height: 24),
              Text(l10n.appTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: fg.withAlpha(102), letterSpacing: 2)),
              const SizedBox(height: 16),
              Text(_label(l10n, poster.template),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: fg.withAlpha(77))),
            ],
          ),
        ),
      ),
    );
  }

  String _label(AppLocalizations l10n, PosterTemplate t) {
    switch (t) {
      case PosterTemplate.minimal: return l10n.templateMinimal;
      case PosterTemplate.paper: return l10n.templatePaper;
      case PosterTemplate.dark: return l10n.templateDark;
      case PosterTemplate.cover: return l10n.templateCover;
    }
  }
}
