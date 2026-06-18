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
    final colors = _colors(poster.template);
    final bg = colors.$1;
    final fg = colors.$2;
    final sec = colors.$3;

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
              Container(width: 60, height: 1.5, color: sec.withAlpha(77)),
              const SizedBox(height: 20),
              if (poster.bookTitle != null)
                Text(poster.bookTitle!,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: sec)),
              if (poster.author != null) ...[
                const SizedBox(height: 8),
                Text(poster.author!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: sec.withAlpha(200))),
              ],
              const SizedBox(height: 24),
              Text(l10n.appTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: sec.withAlpha(153), letterSpacing: 2)),
              const SizedBox(height: 16),
              Text(_label(l10n, poster.template),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: sec.withAlpha(102))),
            ],
          ),
        ),
      ),
    );
  }

  static (Color, Color, Color) _colors(PosterTemplate t) {
    switch (t) {
      case PosterTemplate.minimal:
        return (Colors.white, const Color(0xFF1D1D1F), const Color(0xFF6E6E73));
      case PosterTemplate.paper:
        return (const Color(0xFFF4ECD8), const Color(0xFF3E2F1C), const Color(0xFF6D5E4A));
      case PosterTemplate.dark:
        return (const Color(0xFF1A1A2E), Colors.white, Colors.white70);
      case PosterTemplate.cover:
        return (const Color(0xFF2C3E50), const Color(0xFFECF0F1), const Color(0xFFBDC3C7));
    }
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
