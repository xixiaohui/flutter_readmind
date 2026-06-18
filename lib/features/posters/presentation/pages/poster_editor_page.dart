// poster_editor_page.dart
// 海报编辑页面 — 固定画布渲染，RepaintBoundary 截图

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/poster.dart';
import '../controllers/poster_controller.dart';

/// 固定画布宽度（像素）
const _canvasWidth = 1080.0;

class PosterEditorPage extends ConsumerStatefulWidget {
  const PosterEditorPage({super.key});

  @override
  ConsumerState<PosterEditorPage> createState() => _PosterEditorPageState();
}

class _PosterEditorPageState extends ConsumerState<PosterEditorPage> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _saving = false;

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      // 等待一帧确保 RepaintBoundary 已完成布局
      await WidgetsBinding.instance.endOfFrame;
      await ref
          .read(posterControllerProvider.notifier)
          .savePoster(repaintKey: _repaintKey);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(posterControllerProvider);
    final poster = state.currentPoster;
    if (poster == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.noPosterToPreview)),
      );
    }

    final colors = _templateColors(poster.template);
    final bg = colors.$1;
    final fg = colors.$2;
    final sec = colors.$3;
    final ratio = _ar(poster.ratio);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: fg),
        title: Text(l10n.generatePoster, style: TextStyle(color: fg)),
        actions: [
          TextButton(
            onPressed: _saving
                ? null
                : () {
                    ref.read(posterControllerProvider.notifier).clearEditor();
                    Navigator.of(context).pop();
                  },
            child: Text(l10n.cancel, style: TextStyle(color: fg)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── 海报预览区 ──
            Expanded(
              flex: 7,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FittedBox(
                    child: SizedBox(
                      width: _canvasWidth,
                      height: _canvasWidth / ratio,
                      child: RepaintBoundary(
                        key: _repaintKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 100),
                          child: Column(
                            children: [
                              // 引用文本
                              Expanded(
                                flex: 6,
                                child: Center(
                                  child: Text('"${poster.quoteText}"',
                                      textAlign: TextAlign.center,
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: fg,
                                        fontSize: 48,
                                        height: 1.55,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ),
                              const SizedBox(height: 40),
                              // 分隔线
                              Container(
                                  width: 120,
                                  height: 3,
                                  color: sec.withAlpha(77)),
                              const SizedBox(height: 28),
                              // ── 引用来源横幅 ──
                              if (poster.bookTitle != null ||
                                  poster.author != null)
                                Builder(builder: (_) {
                                  final title = poster.bookTitle;
                                  final author = poster.author;
                                  final text = <String>[
                                    if (title != null && title.isNotEmpty)
                                      '《$title》',
                                    if (author != null && author.isNotEmpty)
                                      author,
                                  ].join(' · ');
                                  if (text.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text('— $text',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 32,
                                          color: sec,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic));
                                }),
                              const SizedBox(height: 36),
                              // 品牌
                              Text(l10n.appTitle,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: sec.withAlpha(102),
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 控制面板 ──
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Selector(
                    label: l10n.template,
                    children: PosterTemplate.values
                        .map((t) => _Chip(
                              label: _tpl(l10n, t),
                              selected: t == state.selectedTemplate,
                              onTap: () => ref
                                  .read(posterControllerProvider.notifier)
                                  .setTemplate(t),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  _Selector(
                    label: l10n.ratio,
                    children: PosterRatio.values
                        .map((r) => _Chip(
                              label: _ratioLabel(r),
                              selected: r == state.selectedRatio,
                              onTap: () => ref
                                  .read(posterControllerProvider.notifier)
                                  .setRatio(r),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.save_alt, size: 20),
                      label: Text(l10n.save),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 模板颜色：(背景, 主文字, 辅助文字)
  static (Color, Color, Color) _templateColors(PosterTemplate t) {
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

  static double _ar(PosterRatio r) {
    switch (r) {
      case PosterRatio.square: return 1.0;
      case PosterRatio.portrait: return 4.0 / 5.0;
      case PosterRatio.story: return 9.0 / 16.0;
    }
  }

  static String _ratioLabel(PosterRatio r) {
    switch (r) {
      case PosterRatio.square: return '1:1';
      case PosterRatio.portrait: return '4:5';
      case PosterRatio.story: return '9:16';
    }
  }
}

// ─── 通用组件 ───

class _Selector extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const _Selector({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(153))),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 4, children: children),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}

String _tpl(AppLocalizations l10n, PosterTemplate t) {
  switch (t) {
    case PosterTemplate.minimal: return l10n.templateMinimal;
    case PosterTemplate.paper: return l10n.templatePaper;
    case PosterTemplate.dark: return l10n.templateDark;
    case PosterTemplate.cover: return l10n.templateCover;
  }
}
