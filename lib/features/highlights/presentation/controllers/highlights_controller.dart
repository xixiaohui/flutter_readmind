// highlights_controller.dart
// Highlights Controller (Riverpod)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';

/// 高亮状态
class HighlightsState {
  final bool isLoading;
  final List<HighlightData> highlights;
  final String? errorMessage;

  const HighlightsState({
    this.isLoading = false,
    this.highlights = const [],
    this.errorMessage,
  });

  HighlightsState copyWith({
    bool? isLoading,
    List<HighlightData>? highlights,
    String? errorMessage,
  }) {
    return HighlightsState(
      isLoading: isLoading ?? this.isLoading,
      highlights: highlights ?? this.highlights,
      errorMessage: errorMessage,
    );
  }
}

/// 高亮控制器
class HighlightsController extends StateNotifier<HighlightsState> {
  final HighlightRepository _repository;

  HighlightsController(this._repository) : super(const HighlightsState());

  /// 加载所有高亮
  Future<void> loadAllHighlights() async {
    state = state.copyWith(isLoading: true);

    try {
      final highlights = await _repository.getAllHighlights();
      state = state.copyWith(isLoading: false, highlights: highlights);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.toString());
    }
  }

  /// 根据书籍加载高亮
  Future<void> loadHighlightsByBookId(int bookId) async {
    state = state.copyWith(isLoading: true);

    try {
      final highlights = await _repository.getHighlightsByBookId(bookId);
      state = state.copyWith(isLoading: false, highlights: highlights);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.toString());
    }
  }

  /// 创建高亮
  Future<void> createHighlight(HighlightData highlight) async {
    try {
      await _repository.insertHighlight(highlight);
      final highlights = await _repository.getAllHighlights();
      state = state.copyWith(highlights: highlights);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 删除高亮
  Future<void> deleteHighlight(int id) async {
    try {
      await _repository.deleteHighlight(id);
      final highlights = await _repository.getAllHighlights();
      state = state.copyWith(highlights: highlights);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

/// Highlights Controller Provider
final highlightsControllerProvider =
    StateNotifierProvider<HighlightsController, HighlightsState>((ref) {
  final repository = ref.watch(highlightRepositoryProvider);
  return HighlightsController(repository);
});

/// 所有高亮 Provider（使用 Stream 自动更新）
final allHighlightsProvider = StreamProvider<List<HighlightData>>((ref) {
  final repository = ref.watch(highlightRepositoryProvider);
  return repository.watchAllHighlights();
});
