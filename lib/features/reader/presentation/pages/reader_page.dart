// reader_page.dart
// 阅读器页面 — 支持高亮创建、高亮显示、海报生成

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';
import '../../../../features/posters/presentation/controllers/poster_controller.dart';
import '../../../../features/posters/presentation/pages/poster_editor_page.dart';
import '../controllers/reader_controller.dart';
import '../controllers/reader_highlight_controller.dart';
import 'widgets/highlights_panel.dart';

/// 阅读器页面
class ReaderPage extends ConsumerStatefulWidget {
  final String filePath;
  final String fileType;
  final String bookTitle;
  final int bookId;

  const ReaderPage({
    super.key,
    required this.filePath,
    required this.fileType,
    required this.bookTitle,
    required this.bookId,
  });

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  // 当前选中文本（本地状态，不在 build 中修改 provider）
  String _selectedText = '';
  int _selectionStart = 0;
  int _selectionEnd = 0;

  @override
  void initState() {
    super.initState();
    Future(() => _loadBook());
  }

  Future<void> _loadBook() async {
    await ref.read(readerControllerProvider.notifier).loadBook(
          widget.filePath,
          widget.fileType,
          widget.bookId,
        );
    ref
        .read(readerHighlightControllerProvider.notifier)
        .loadHighlights(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerState = ref.watch(readerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bookTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_paint_outlined),
            tooltip: l10n.highlights,
            onPressed: () => _showHighlightsPanel(),
          ),
          IconButton(
            icon: const Icon(Icons.text_decrease),
            tooltip: l10n.decreaseFontSize,
            onPressed: () {
              ref
                  .read(readerControllerProvider.notifier)
                  .setFontSize(readerState.fontSize - 2);
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_increase),
            tooltip: l10n.increaseFontSize,
            onPressed: () {
              ref
                  .read(readerControllerProvider.notifier)
                  .setFontSize(readerState.fontSize + 2);
            },
          ),
        ],
      ),
      body: _buildBody(readerState),
      floatingActionButton: _buildNavigationButtons(readerState),
    );
  }

  /// 构建主体内容
  Widget _buildBody(ReaderState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null) {
      return _ErrorView(message: state.errorMessage!);
    }
    if (state.content == null) {
      return Center(child: Text(l10n.noContent));
    }

    final chapters = state.content!.chapters;
    if (chapters.isEmpty) {
      return Center(child: Text(l10n.noContentAvailable));
    }

    final chapterIndex = state.currentChapter.clamp(0, chapters.length - 1);
    final chapter = chapters[chapterIndex];

    return GestureDetector(
      onTap: () {
        ref.read(readerControllerProvider.notifier).savePosition();
        _selectedText = '';
        _selectionStart = 0;
        _selectionEnd = 0;
      },
      child: RepaintBoundary(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: _buildHighlightedText(
              chapter.content, state.fontSize, state.currentChapter),
          ),
        ),
      ),
    );
  }

  /// 构建带高亮显示的文本
  Widget _buildHighlightedText(
      String chapterContent, double fontSize, int chapterIndex) {
    final highlightState = ref.watch(readerHighlightControllerProvider);
    final highlights = highlightState.highlights;

    if (highlights.isEmpty) {
      return SelectableText(
        chapterContent,
        contextMenuBuilder: (context, editableTextState) =>
            _buildSelectionToolbar(context, editableTextState, chapterContent),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: fontSize,
              height: 1.7,
            ),
      );
    }

    final textSpan =
        _buildHighlightedTextSpan(chapterContent, highlights, fontSize, chapterIndex);
    return SelectableText.rich(
      textSpan,
      contextMenuBuilder: (context, editableTextState) =>
          _buildSelectionToolbar(context, editableTextState, chapterContent),
    );
  }

  /// 构建带高亮的 TextSpan（仅显示当前章节的高亮）
  TextSpan _buildHighlightedTextSpan(
    String content,
    List<HighlightData> highlights,
    double fontSize,
    int chapterIndex,
  ) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: fontSize,
          height: 1.7,
        );

    // 仅显示当前章节的高亮（pageNumber 为章节索引）
    final chapterHighlights = highlights.where((h) {
      // 属于当前章节，或 pageNumber 为 null（旧数据兼容）
      if (h.pageNumber == null) return true;
      return h.pageNumber == chapterIndex;
    });

    final relevantHighlights = chapterHighlights
        .where((h) =>
            h.startOffset >= 0 &&
            h.endOffset <= content.length &&
            h.startOffset < h.endOffset)
        .toList()
      ..sort((a, b) => a.startOffset.compareTo(b.startOffset));

    if (relevantHighlights.isEmpty) {
      return TextSpan(text: content, style: style);
    }

    final children = <InlineSpan>[];
    int currentPos = 0;

    for (final highlight in relevantHighlights) {
      if (highlight.startOffset > currentPos) {
        children.add(TextSpan(
          text: content.substring(currentPos, highlight.startOffset),
          style: style,
        ));
      }
      final color = _parseHighlightColor(highlight.highlightColor);
      children.add(TextSpan(
        text: content.substring(highlight.startOffset, highlight.endOffset),
        style: style?.copyWith(backgroundColor: color.withAlpha(80)),
      ));
      currentPos = highlight.endOffset;
    }

    if (currentPos < content.length) {
      children.add(TextSpan(text: content.substring(currentPos), style: style));
    }

    return TextSpan(children: children, style: style);
  }

  /// 构建选择工具栏
  Widget _buildSelectionToolbar(
    BuildContext context,
    EditableTextState editableTextState,
    String chapterContent,
  ) {
    final selection = editableTextState.textEditingValue.selection;
    final selectedText = selection.textInside(chapterContent);

    if (!selection.isValid || selectedText.isEmpty) {
      return AdaptiveTextSelectionToolbar.editableText(
        editableTextState: editableTextState,
      );
    }

    final start = selection.start.clamp(0, chapterContent.length);
    final end = selection.end.clamp(0, chapterContent.length);
    // 存储在本地字段，避免在 build 阶段修改 provider 状态
    _selectedText = selectedText;
    _selectionStart = start;
    _selectionEnd = end;

    final l10n = AppLocalizations.of(context)!;
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editableTextState.contextMenuAnchors,
      buttonItems: [
        ContextMenuButtonItem(
          label: l10n.highlight,
          onPressed: () {
            // 延迟到下一帧，避免在 build 阶段修改 provider
            Future(() => _showHighlightColorPicker(selectedText));
          },
        ),
        ContextMenuButtonItem(
          label: l10n.createPoster,
          onPressed: () {
            Future(() => _createPosterFromSelection(selectedText));
          },
        ),
        ContextMenuButtonItem(
          label: l10n.copy,
          onPressed: () =>
              editableTextState.copySelection(SelectionChangedCause.toolbar),
        ),
      ],
    );
  }

  /// 显示高亮颜色选择器
  void _showHighlightColorPicker(String selectedText) {
    final initialColor = ref.read(readerHighlightControllerProvider).selectedColor;

    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        // 使用 StatefulBuilder 管理底部面板内的本地 UI 状态
        // ref.watch 在 showModalBottomSheet 的独立 widget 树中无法触发重建
        HighlightColorOption selectedSheetColor = initialColor;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.chooseHighlightColor,
                      style: Theme.of(ctx).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(ctx)
                          .colorScheme
                          .surfaceContainerHighest
                          .withAlpha(60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '"$selectedText"',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(ctx).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: HighlightColorOption.values.map((colorOption) {
                      final color = _parseHighlightColor(colorOption.hex);
                      final isSelected = selectedSheetColor == colorOption;
                      return GestureDetector(
                        onTap: () {
                          // 同时更新 provider 状态和本地 UI 状态
                          ref
                              .read(readerHighlightControllerProvider.notifier)
                              .setColor(colorOption);
                          setSheetState(() {
                            selectedSheetColor = colorOption;
                          });
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: color,
                          child: isSelected
                              ? const Icon(Icons.check,
                                  color: Colors.black87, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.format_paint),
                      label: Text(l10n.createHighlight),
                      onPressed: () {
                    final content = ref.read(readerControllerProvider).content;
                    final readerState = ref.read(readerControllerProvider);
                    if (content != null && _selectedText.isNotEmpty) {
                      ref
                          .read(readerHighlightControllerProvider.notifier)
                          .createHighlight(
                            bookId: content.bookId,
                            selectedText: _selectedText,
                            startOffset: _selectionStart,
                            endOffset: _selectionEnd,
                            pageNumber: readerState.currentChapter,
                          );
                    }
                    Navigator.pop(ctx);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  },
);
}

  /// 从选中文本生成海报 → 打开编辑页面
  void _createPosterFromSelection(String selectedText) {
    ref.read(posterControllerProvider.notifier).createPoster(
          highlightId: 0,
          quoteText: selectedText,
          bookTitle: widget.bookTitle,
        );
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const PosterEditorPage()));
  }

  /// 显示高亮列表面板
  void _showHighlightsPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) =>
            HighlightsPanel(scrollController: scrollController),
      ),
    );
  }

  /// 构建导航按钮
  Widget? _buildNavigationButtons(ReaderState state) {
    if (state.content == null || state.content!.chapters.isEmpty) return null;

    final chapters = state.content!.chapters;
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.small(
          heroTag: 'prev',
          tooltip: l10n.prevChapter,
          onPressed: state.currentChapter > 0
              ? () => ref
                  .read(readerControllerProvider.notifier)
                  .setChapter(state.currentChapter - 1)
              : null,
          child: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 16),
        Text('${state.currentChapter + 1}/${chapters.length}',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 16),
        FloatingActionButton.small(
          heroTag: 'next',
          tooltip: l10n.nextChapter,
          onPressed: state.currentChapter < chapters.length - 1
              ? () => ref
                  .read(readerControllerProvider.notifier)
                  .setChapter(state.currentChapter + 1)
              : null,
          child: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }

  /// 解析高亮颜色
  Color _parseHighlightColor(String? colorHex) {
    if (colorHex == null) return Colors.yellow;
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.yellow;
    }
  }
}

/// 错误视图
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
