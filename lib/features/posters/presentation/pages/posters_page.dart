// posters_page.dart
// 海报页面 — 生成、预览、管理海报
// 设计遵循 UI_DESIGN.md: Content First, Generous Space, Premium Feel

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/poster.dart';
import '../controllers/poster_controller.dart';
import 'widgets/poster_full_view.dart';

class PostersPage extends ConsumerWidget {
  const PostersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(posterControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.posters,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.history.isEmpty && state.currentPoster == null
              ? _EmptyState(l10n: l10n)
              : state.currentPoster != null
                  ? _CreateView(state: state)
                  : _HistoryView(state: state),
    );
  }
}

// ─── 空状态 ───

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

// ─── 创作视图（海报预览 + 模板选择 + 操作按钮） ───

class _CreateView extends ConsumerWidget {
  final PosterState state;
  const _CreateView({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(posterControllerProvider.notifier);
    final screenshotController = ScreenshotController();
    final poster = state.currentPoster!;

    return Column(
      children: [
        // ── 海报预览区（占据 70% 屏幕） ──
        Expanded(
          flex: 7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Screenshot(
                  key: ValueKey('${poster.template.name}_${poster.ratio.name}'),
                  controller: screenshotController,
                  child: _PosterCard(poster: poster, l10n: l10n),
                ),
              ),
            ),
          ),
        ),

        // ── 模板选择器（优雅 Chip 行） ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(l10n.template,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(153))),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: PosterTemplate.values.map((t) {
                      final selected = t == state.selectedTemplate;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(_templateLabel(l10n, t)),
                          selected: selected,
                          onSelected: (_) => controller.setTemplate(t),
                          showCheckmark: false,
                          selectedColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── 比例选择器 ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(l10n.ratio,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(153))),
              const SizedBox(width: 12),
              ...PosterRatio.values.map((r) {
                final selected = r == state.selectedRatio;
                final labels = {
                  PosterRatio.square: '1:1',
                  PosterRatio.portrait: '4:5',
                  PosterRatio.story: '9:16',
                };
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(labels[r]!),
                    selected: selected,
                    onSelected: (_) => controller.setRatio(r),
                    showCheckmark: false,
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── 操作按钮（填充主按钮 + 文字按钮） ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    await controller.savePoster(
                        screenshotController: screenshotController);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.posterSaved)),
                      );
                    }
                  },
                  icon: const Icon(Icons.save_alt, size: 20),
                  label: Text(l10n.save),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => controller.sharePoster(poster),
                icon: const Icon(Icons.share, size: 20),
                label: Text(l10n.share),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Divider(height: 1),
        const SizedBox(height: 8),

        // ── 历史标题 ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                l10n.posters,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text('${state.history.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(128))),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ── 历史列表 ──
        Expanded(
          flex: 3,
          child: state.history.isEmpty
              ? Center(
                  child: Text(l10n.noPosters,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(77))))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: state.history.length,
                  itemBuilder: (_, i) =>
                      _HistoryTile(poster: state.history[i], l10n: l10n),
                ),
        ),
      ],
    );
  }
}

// ─── 历史视图（仅已保存的海报） ───

class _HistoryView extends ConsumerWidget {
  final PosterState state;
  const _HistoryView({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (state.history.isEmpty) {
      return _EmptyState(l10n: l10n);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Row(
            children: [
              Text(l10n.posters,
                  style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              Text('${state.history.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(128))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: state.history.length,
            itemBuilder: (_, i) =>
                _HistoryTile(poster: state.history[i], l10n: l10n),
          ),
        ),
      ],
    );
  }
}

// ─── 海报预览卡片（遵循设计: radius 20, subtle shadow） ───

class _PosterCard extends StatelessWidget {
  final Poster poster;
  final AppLocalizations l10n;
  const _PosterCard({required this.poster, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final isDark = poster.template == PosterTemplate.dark;
    final bg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final fg = isDark ? Colors.white : const Color(0xFF1D1D1F);
    final secondaryFg =
        isDark ? Colors.white70 : const Color(0xFF6E6E73);

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('"${poster.quoteText}"',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic, color: fg, height: 1.6)),
          const SizedBox(height: 24),
          Container(width: 48, height: 1.5, color: secondaryFg.withAlpha(77)),
          const SizedBox(height: 16),
          if (poster.bookTitle != null)
            Text(poster.bookTitle!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: secondaryFg)),
          if (poster.author != null) ...[
            const SizedBox(height: 4),
            Text(poster.author!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: secondaryFg.withAlpha(179))),
          ],
          const SizedBox(height: 20),
          Text(l10n.appTitle,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: secondaryFg.withAlpha(102),
                  letterSpacing: 2)),
        ],
      ),
    );
  }
}

// ─── 历史列表项（card 风格，可点击查看全屏） ───

class _HistoryTile extends ConsumerWidget {
  final Poster poster;
  final AppLocalizations l10n;
  const _HistoryTile({required this.poster, required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(77),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PosterFullView(poster: poster, l10n: l10n))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(poster.quoteText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(_templateLabel(l10n, poster.template),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(128))),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share, size: 20),
                tooltip: l10n.share,
                onPressed: () =>
                    ref.read(posterControllerProvider.notifier).sharePoster(poster),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20,
                    color: Theme.of(context).colorScheme.error.withAlpha(179)),
                tooltip: l10n.delete,
                onPressed: () => ref
                    .read(posterControllerProvider.notifier)
                    .removeFromHistory(poster.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ───

String _templateLabel(AppLocalizations l10n, PosterTemplate t) {
  switch (t) {
    case PosterTemplate.minimal: return l10n.templateMinimal;
    case PosterTemplate.paper: return l10n.templatePaper;
    case PosterTemplate.dark: return l10n.templateDark;
    case PosterTemplate.cover: return l10n.templateCover;
  }
}
