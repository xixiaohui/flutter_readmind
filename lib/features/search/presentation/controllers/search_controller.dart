// search_controller.dart
// Search Controller (Riverpod)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../features/shared/domain/repositories/book_repository.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';
import '../../../../features/shared/domain/repositories/note_repository.dart';
import '../../domain/entities/search_result.dart';

/// 搜索状态
class SearchState {
  final String query;
  final List<SearchResult> results;
  final List<String> history;
  final bool isLoading;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.history = const [],
    this.isLoading = false,
  });

  SearchState copyWith({
    String? query,
    List<SearchResult>? results,
    List<String>? history,
    bool? isLoading,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 搜索控制器
class SearchController extends StateNotifier<SearchState> {
  final BookRepository _bookRepo;
  final HighlightRepository _highlightRepo;
  final NoteRepository _noteRepo;

  SearchController(this._bookRepo, this._highlightRepo, this._noteRepo)
      : super(const SearchState());

  /// 执行搜索
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], query: '');
      return;
    }

    state = state.copyWith(isLoading: true, query: query);

    try {
      final results = <SearchResult>[];

      // 搜索书籍
      final books = await _bookRepo.getAllBooks();
      for (final book in books) {
        if (book.title.toLowerCase().contains(query.toLowerCase()) ||
            (book.author?.toLowerCase().contains(query.toLowerCase()) ??
                false)) {
          results.add(SearchResult(
            id: book.id.toString(),
            type: SearchResultType.book,
            title: book.title,
            snippet: book.author ?? '',
          ));
        }
      }

      // 搜索高亮
      final highlights = await _highlightRepo.getAllHighlights();
      for (final highlight in highlights) {
        if (highlight.selectedText
            .toLowerCase()
            .contains(query.toLowerCase())) {
          results.add(SearchResult(
            id: highlight.id.toString(),
            type: SearchResultType.highlight,
            title: highlight.selectedText,
            snippet: 'Highlight',
            subtitle: 'Book #${highlight.bookId}',
          ));
        }
      }

      // 搜索笔记
      final notes = await _noteRepo.getAllNotes();
      for (final note in notes) {
        if (note.content.toLowerCase().contains(query.toLowerCase())) {
          results.add(SearchResult(
            id: note.id.toString(),
            type: SearchResultType.note,
            title: note.content,
            snippet: 'Note',
          ));
        }
      }

      // 更新搜索历史
      final history = [query, ...state.history.where((h) => h != query)]
          .take(10)
          .toList();

      state = state.copyWith(
        isLoading: false,
        results: results,
        history: history,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 清除搜索
  void clear() {
    state = state.copyWith(query: '', results: []);
  }

  /// 从历史中删除
  void removeFromHistory(String query) {
    state = state.copyWith(
      history: state.history.where((h) => h != query).toList(),
    );
  }
}

/// Search Controller Provider
final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchState>((ref) {
  final bookRepo = ref.watch(bookRepositoryProvider);
  final highlightRepo = ref.watch(highlightRepositoryProvider);
  final noteRepo = ref.watch(noteRepositoryProvider);
  return SearchController(bookRepo, highlightRepo, noteRepo);
});
