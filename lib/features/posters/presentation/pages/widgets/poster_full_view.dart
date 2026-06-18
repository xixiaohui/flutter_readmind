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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 引用文本
              Text('"${poster.quoteText}"',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: fg,
                      height: 1.55,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 28),
              // 分隔线
              Container(width: 120, height: 3, color: sec.withAlpha(77)),
              const SizedBox(height: 24),
              // 引用来源横幅（与编辑器一致）
              Builder(builder: (_) {
                final title = poster.bookTitle;
                final author = poster.author;
                final text = <String>[
                  if (title != null && title.isNotEmpty) '《$title》',
                  if (author != null && author.isNotEmpty) author,
                ].join(' · ');
                if (text.isEmpty) return const SizedBox.shrink();
                return Text('— $text',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: sec,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic));
              }),
              const SizedBox(height: 32),
              // 品牌
              Text(l10n.appTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: sec.withAlpha(102),
                      letterSpacing: 4,
                      fontWeight: FontWeight.w400)),
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

}
