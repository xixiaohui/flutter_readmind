// reader_controller.dart
// Reader Controller (Riverpod)
// 显示设置（字体、行距、阅读模式）已移至全局 ReaderSettingsController

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/book_content.dart';
import '../../domain/entities/reading_position.dart';
import '../../domain/repositories/reader_repository.dart';

/// 阅读器状态（仅书籍内容和阅读位置，不含显示设置）
class ReaderState {
  final bool isLoading;
  final BookContent? content;
  final ReadingPosition? position;
  final int currentChapter;
  final int currentPage;
  final String? searchQuery;
  final List<SearchMatch> searchResults;
  final int? scrollToOffset;
  final String? errorMessage;

  const ReaderState({
    this.isLoading = false,
    this.content,
    this.position,
    this.currentChapter = 0,
    this.currentPage = 0,
    this.searchQuery,
    this.searchResults = const [],
    this.scrollToOffset,
    this.errorMessage,
  });

  ReaderState copyWith({
    bool? isLoading,
    BookContent? content,
    ReadingPosition? position,
    int? currentChapter,
    int? currentPage,
    String? searchQuery,
    List<SearchMatch>? searchResults,
    int? scrollToOffset,
    String? errorMessage,
    bool clearSearch = false,
    bool clearScrollTo = false,
  }) {
    return ReaderState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
      position: position ?? this.position,
      currentChapter: currentChapter ?? this.currentChapter,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      searchResults: clearSearch ? [] : (searchResults ?? this.searchResults),
      scrollToOffset: clearScrollTo ? null : (scrollToOffset ?? this.scrollToOffset),
      errorMessage: errorMessage,
    );
  }
}

/// Reader Controller
class ReaderController extends StateNotifier<ReaderState> {
  final ReaderRepository _repository;

  ReaderController(this._repository) : super(const ReaderState());

  /// 加载书籍内容
  Future<void> loadBook(String filePath, String fileType, int bookId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final content = await _repository.getBookContent(filePath, fileType, bookId);

      ReadingPosition position;
      try {
        position = await _repository.getReadingPosition(content.bookId);
      } catch (_) {
        position = ReadingPosition.initial(content.bookId);
      }

      state = state.copyWith(
        isLoading: false,
        content: content,
        position: position,
        currentChapter: position.chapterIndex,
        currentPage: position.pageNumber,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 设置当前章节（自动保存进度）
  void setChapter(int chapterIndex) {
    state = state.copyWith(currentChapter: chapterIndex, clearScrollTo: true);
    savePosition();
  }

  /// 设置当前页码
  void setPage(int pageNumber) {
    state = state.copyWith(currentPage: pageNumber);
  }

  /// 全文搜索
  void search(String query) {
    if (query.isEmpty || state.content == null) {
      state = state.copyWith(clearSearch: true);
      return;
    }

    final results = <SearchMatch>[];
    final chapters = state.content!.chapters;
    final lowerQuery = query.toLowerCase();

    for (final chapter in chapters) {
      final lowerContent = chapter.content.toLowerCase();
      int searchFrom = 0;
      while (true) {
        final index = lowerContent.indexOf(lowerQuery, searchFrom);
        if (index == -1) break;

        final contextStart = (index - 30).clamp(0, chapter.content.length);
        final contextEnd = (index + query.length + 30).clamp(0, chapter.content.length);
        final contextText = chapter.content.substring(contextStart, contextEnd);

        results.add(SearchMatch(
          chapterIndex: chapter.index,
          chapterTitle: chapter.title,
          startOffset: index,
          contextText: (contextStart > 0 ? '...' : '') +
              contextText +
              (contextEnd < chapter.content.length ? '...' : ''),
        ));

        searchFrom = index + query.length;
        if (results.length >= 50) break;
      }
      if (results.length >= 50) break;
    }

    state = state.copyWith(
      searchQuery: query,
      searchResults: results,
    );
  }

  /// 清空搜索
  void clearSearch() {
    state = state.copyWith(clearSearch: true);
  }

  /// 跳转到搜索结果
  void navigateToSearchResult(SearchMatch match) {
    state = state.copyWith(
      currentChapter: match.chapterIndex,
      scrollToOffset: match.startOffset,
    );
  }

  /// 清除滚动偏移
  void clearScrollToOffset() {
    state = state.copyWith(clearScrollTo: true);
  }

  /// 保存阅读位置
  Future<void> savePosition() async {
    if (state.content == null) return;

    final position = ReadingPosition(
      bookId: state.content!.bookId,
      chapterIndex: state.currentChapter,
      pageNumber: state.currentPage,
      progressPercent: _calculateProgress(),
      lastReadAt: DateTime.now(),
    );

    await _repository.saveReadingPosition(position);
    state = state.copyWith(position: position);
  }

  /// 计算阅读进度
  double _calculateProgress() {
    if (state.content == null || state.content!.chapters.isEmpty) return 0.0;

    final totalChapters = state.content!.chapters.length;
    if (totalChapters == 0) return 0.0;

    return state.currentChapter / totalChapters;
  }
}

/// Reader Controller Provider
final readerControllerProvider =
    StateNotifierProvider<ReaderController, ReaderState>((ref) {
  final repository = ref.watch(readerRepositoryProvider);
  return ReaderController(repository);
});
