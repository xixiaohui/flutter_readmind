// posters_page.dart
// 海报页面 — 海报历史列表
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/reader_settings_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../reader/domain/entities/book_content.dart';
import '../../domain/entities/poster.dart';
import '../controllers/poster_controller.dart';
import 'poster_editor_page.dart';
import 'widgets/poster_full_view.dart';

class PostersPage extends ConsumerWidget {
  const PostersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final postersAsync = ref.watch(allPostersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.posters,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: postersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error')),
        data: (posters) {
          if (posters.isEmpty) return _EmptyState(l10n: l10n);
          return _PosterList(posters: posters);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_outlined, size: 56,
                color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 24),
            Text(l10n.noPosters,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary)),
            const SizedBox(height: 12),
            Text(l10n.generatePoster,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(128))),
          ],
        ),
      ),
    );
  }
}

class _PosterList extends StatelessWidget {
  final List<Poster> posters;
  const _PosterList({required this.posters});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(
            children: [
              Text(l10n.posters,
                  style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              Text('${posters.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(128))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: posters.length,
            itemBuilder: (_, i) =>
                _PosterTile(poster: posters[i], l10n: l10n),
          ),
        ),
      ],
    );
  }
}

class _PosterTile extends ConsumerWidget {
  final Poster poster;
  final AppLocalizations l10n;
  const _PosterTile({required this.poster, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsControllerProvider);
    final fontFamily = _fontFamilyStr(settings.fontFamily);

    void confirmDelete(BuildContext context, WidgetRef ref) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.delete),
          content: Text('${l10n.confirm}?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel)),
            TextButton(
              onPressed: () {
                ref
                    .read(posterControllerProvider.notifier)
                    .removeFromHistory(poster.id);
                Navigator.pop(ctx);
              },
              child: Text(l10n.delete,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error)),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withAlpha(77),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                PosterFullView(poster: poster, l10n: l10n))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 完整引用文字展示 ──
              Text(poster.quoteText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500, fontFamily: fontFamily.isNotEmpty ? fontFamily : null)),
              const SizedBox(height: 4),
              Text(_label(l10n, poster.template),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(128))),
              const SizedBox(height: 4),
              // ── 按钮标签行 ──
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionLabel(
                    icon: Icons.edit,
                    label: 'Edit',
                    onTap: () {
                      ref
                          .read(posterControllerProvider.notifier)
                          .editPoster(poster);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const PosterEditorPage()));
                    },
                  ),
                  const SizedBox(width: 4),
                  _ActionLabel(
                    icon: Icons.share,
                    label: l10n.share,
                    onTap: () => ref
                        .read(posterControllerProvider.notifier)
                        .sharePoster(poster),
                  ),
                  const SizedBox(width: 4),
                  _ActionLabel(
                    icon: Icons.delete_outline,
                    label: l10n.delete,
                    color: Theme.of(context).colorScheme.error,
                    onTap: () => confirmDelete(context, ref),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _fontFamilyStr(ReaderFontFamily family) {
    switch (family) {
      case ReaderFontFamily.wenkai: return 'LXGWWenKai';
      case ReaderFontFamily.serif: return 'Serif';
      case ReaderFontFamily.monospace: return 'monospace';
      case ReaderFontFamily.sansSerif: return '';
    }
  }
}

/// 操作标签（图标 + 文字）
class _ActionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  const _ActionLabel({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: color ??
                        Theme.of(context).colorScheme.onSurface.withAlpha(179))),
          ],
        ),
      ),
    );
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
