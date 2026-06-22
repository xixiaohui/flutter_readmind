// reader_page.dart
// 阅读器页面 — 支持高亮创建、高亮显示、海报生成

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/reader_settings_controller.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';
import '../../../../features/posters/presentation/controllers/poster_controller.dart';
import '../../../../features/posters/presentation/pages/poster_editor_page.dart';
import '../../domain/entities/book_content.dart';
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

  // 翻页模式控制器
  PageController? _pageController;
  int _lastChapter = -1;

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
    final globalSettings = ref.watch(readerSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bookTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.searchBook,
            onPressed: () => _showSearchPanel(context, readerState),
          ),
          IconButton(
            icon: const Icon(Icons.format_paint_outlined),
            tooltip: l10n.highlights,
            onPressed: () => _showHighlightsPanel(),
          ),
        ],
      ),
      body: _buildBody(readerState, globalSettings),
      floatingActionButton: _buildNavigationButtons(readerState),
    );
  }

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

  /// 构建主体内容
  Widget _buildBody(ReaderState state, ReaderSettingsState settings) {
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
          child: settings.readingMode == ReadingMode.pagination
              ? _buildPaginationView(chapter, chapters, settings)
              : _buildScrollView(chapter, settings),
        ),
      ),
    );
  }

  /// 构建滚动模式
  Widget _buildScrollView(Chapter chapter, ReaderSettingsState settings) {
    final rs = ref.read(readerControllerProvider);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: _buildHighlightedText(
          chapter.content, settings.fontSize, settings.fontFamily, settings.lineHeight, rs.currentChapter),
    );
  }

  /// 构建翻页模式
  Widget _buildPaginationView(
      Chapter chapter, List<Chapter> chapters, ReaderSettingsState settings) {
    final rs = ref.read(readerControllerProvider);
    final pages = _calculatePages(chapter.content);
    final chapterIndex = rs.currentChapter.clamp(0, chapters.length - 1);

    if (chapterIndex != _lastChapter) {
      _lastChapter = chapterIndex;
      _pageController?.dispose();
      _pageController = PageController(initialPage: 0);
    }

    if (pages.isEmpty) {
      return Center(
        child: Text(chapter.content.isEmpty ? '' : chapter.content,
            style: _buildTextStyle(settings.fontSize, settings.fontFamily, settings.lineHeight)),
      );
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (_) {
              ref.read(readerControllerProvider.notifier).savePosition();
            },
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildPageText(
                    pages[index], settings.fontSize, settings.fontFamily,
                    settings.lineHeight, rs.currentChapter),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '${_pageController?.hasClients == true && _pageController!.page != null ? (_pageController!.page!.round() + 1) : 1} / ${pages.length}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100)),
          ),
        ),
      ],
    );
  }

  /// 翻页模式专用文本渲染（Text.rich，不支持选择，避免与 PageView 手势冲突）
  Widget _buildPageText(
      String content, double fontSize, ReaderFontFamily fontFamily,
      double lineHeight, int chapterIndex) {
    final highlightState = ref.watch(readerHighlightControllerProvider);
    final highlights = highlightState.highlights;

    if (highlights.isEmpty) {
      return Text(content, style: _buildTextStyle(fontSize, fontFamily, lineHeight));
    }

    final textSpan = _buildHighlightedTextSpan(
        content, highlights, fontSize, fontFamily, lineHeight, chapterIndex);
    return Text.rich(textSpan);
  }

  /// 分页计算
  List<String> _calculatePages(String content) {
    if (content.isEmpty) return [];
    const charsPerPage = 1500;
    final pages = <String>[];
    int start = 0;
    while (start < content.length) {
      int end = (start + charsPerPage).clamp(0, content.length);
      // 尝试在段落边界处断页
      if (end < content.length) {
        final breakPoint = content.lastIndexOf('\n\n', end);
        if (breakPoint > start + charsPerPage ~/ 2) {
          end = breakPoint;
        }
      }
      pages.add(content.substring(start, end));
      start = end;
    }
    return pages;
  }

  @override
  void dispose() {
    ref.read(readerControllerProvider.notifier).savePosition();
    _pageController?.dispose();
    super.dispose();
  }

  /// 构建文本样式
  TextStyle? _buildTextStyle(double fontSize, ReaderFontFamily fontFamily, double lineHeight) {
    String? fontFamilyStr;
    switch (fontFamily) {
      case ReaderFontFamily.serif:
        fontFamilyStr = 'Serif';
        break;
      case ReaderFontFamily.monospace:
        fontFamilyStr = 'monospace';
        break;
      case ReaderFontFamily.wenkai:
        fontFamilyStr = 'LXGWWenKai';
        break;
      case ReaderFontFamily.sansSerif:
        break; // null = 系统默认无衬线字体
    }
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: fontSize,
          height: lineHeight,
          fontFamily: fontFamilyStr,
        );
  }

  /// 构建带高亮显示的文本
  Widget _buildHighlightedText(
      String chapterContent, double fontSize, ReaderFontFamily fontFamily,
      double lineHeight, int chapterIndex) {
    final highlightState = ref.watch(readerHighlightControllerProvider);
    final highlights = highlightState.highlights;

    if (highlights.isEmpty) {
      return SelectableText(
        chapterContent,
        contextMenuBuilder: (context, editableTextState) =>
            _buildSelectionToolbar(context, editableTextState, chapterContent),
        style: _buildTextStyle(fontSize, fontFamily, lineHeight),
      );
    }

    final textSpan =
        _buildHighlightedTextSpan(chapterContent, highlights, fontSize, fontFamily, lineHeight, chapterIndex);
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
    ReaderFontFamily fontFamily,
    double lineHeight,
    int chapterIndex,
  ) {
    final style = _buildTextStyle(fontSize, fontFamily, lineHeight);

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
  /// 从选中文本生成海报 → 清洗换行 → 打开编辑页面
  void _createPosterFromSelection(String selectedText) {
    final cleaned = _cleanQuoteText(selectedText);
    final settings = ref.read(readerSettingsControllerProvider);
    final fontFamily = _fontFamilyToString(settings.fontFamily);
    ref.read(posterControllerProvider.notifier).createPoster(
          highlightId: 0,
          quoteText: cleaned,
          bookTitle: widget.bookTitle,
        );
    ref.read(posterControllerProvider.notifier).setFontFamily(fontFamily);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => const PosterEditorPage()));
  }

  /// 清洗引用文字：保留段落间距（双换行），去除行内换行
  String _cleanQuoteText(String text) {
    // 1. 规范化：\r\n → \n
    var cleaned = text.replaceAll('\r\n', '\n');
    // 2. 多个连续 \n → 占位符（保护段落分隔）
    cleaned = cleaned.replaceAll(RegExp(r'\n{2,}'), '');
    // 3. 单换行 → 空格
    cleaned = cleaned.replaceAll('\n', ' ');
    // 4. 恢复段落分隔
    cleaned = cleaned.replaceAll('', '\n\n');
    return cleaned.trim();
  }

  /// 将 ReaderFontFamily 映射为实际的 fontFamily 字符串
  String _fontFamilyToString(ReaderFontFamily family) {
    switch (family) {
      case ReaderFontFamily.wenkai:
        return 'LXGWWenKai';
      case ReaderFontFamily.serif:
        return 'Serif';
      case ReaderFontFamily.monospace:
        return 'monospace';
      case ReaderFontFamily.sansSerif:
        return '';
    }
  }

  /// 显示全文搜索面板
  void _showSearchPanel(BuildContext context, ReaderState state) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (ctx, scrollController) =>
              _SearchSheet(l10n: l10n, scrollController: scrollController),
        );
      },
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

// ─── 搜索面板 ───

class _SearchSheet extends ConsumerStatefulWidget {
  final AppLocalizations l10n;
  final ScrollController scrollController;
  const _SearchSheet({required this.l10n, required this.scrollController});

  @override
  ConsumerState<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends ConsumerState<_SearchSheet> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    // 关闭搜索面板时清空搜索
    ref.read(readerControllerProvider.notifier).clearSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(readerControllerProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          // 搜索输入框
          TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.l10n.searchHint,
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(readerControllerProvider.notifier).clearSearch();
                      },
                    )
                  : null,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() {}); // 更新 clear 按钮可见性
              ref.read(readerControllerProvider.notifier).search(value);
            },
          ),
          const SizedBox(height: 12),

          // 搜索结果
          Expanded(
            child: state.searchResults.isEmpty
                ? (state.searchQuery != null && state.searchQuery!.isNotEmpty
                    ? Center(
                        child: Text(widget.l10n.noSearchResults,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(128))))
                    : const SizedBox.shrink())
                : ListView.builder(
                    controller: widget.scrollController,
                    itemCount: state.searchResults.length,
                    itemBuilder: (_, i) {
                      final match = state.searchResults[i];
                      return _SearchResultTile(
                        match: match,
                        query: state.searchQuery ?? '',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends ConsumerWidget {
  final SearchMatch match;
  final String query;
  const _SearchResultTile({required this.match, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(60),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ref.read(readerControllerProvider.notifier).navigateToSearchResult(match);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(match.chapterTitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary)),
              const SizedBox(height: 4),
              Text.rich(
                _highlightQuery(match.contextText, query),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _highlightQuery(String text, String query) {
    final lower = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final index = lower.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: const TextStyle(backgroundColor: Color(0x40FFE28A), fontWeight: FontWeight.w600),
      ));
      start = index + query.length;
    }
    return TextSpan(children: spans);
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
