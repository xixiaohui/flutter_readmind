// reader_highlight_controller.dart
// Reader Highlight Controller (Riverpod)
//
// Manages highlights for the currently open book in the reader.
// Handles: loading existing highlights, creating new ones from selected text,
// deleting highlights, and tracking selection state.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/injection.dart';
import '../../../../features/shared/domain/repositories/highlight_repository.dart';

/// 高亮颜色选项
enum HighlightColorOption {
  yellow('FFFF00'),
  green('90EE90'),
  blue('87CEEB'),
  pink('FFB6C1'),
  orange('FFA500');

  final String hex;
  const HighlightColorOption(this.hex);
}

/// 阅读器高亮状态
class ReaderHighlightState {
  final bool isLoading;
  final List<HighlightData> highlights;
  final HighlightColorOption selectedColor;
  final String? errorMessage;

  const ReaderHighlightState({
    this.isLoading = false,
    this.highlights = const [],
    this.selectedColor = HighlightColorOption.yellow,
    this.errorMessage,
  });

  ReaderHighlightState copyWith({
    bool? isLoading,
    List<HighlightData>? highlights,
    HighlightColorOption? selectedColor,
    String? errorMessage,
  }) {
    return ReaderHighlightState(
      isLoading: isLoading ?? this.isLoading,
      highlights: highlights ?? this.highlights,
      selectedColor: selectedColor ?? this.selectedColor,
      errorMessage: errorMessage,
    );
  }
}

/// 阅读器高亮控制器
class ReaderHighlightController extends StateNotifier<ReaderHighlightState> {
  final HighlightRepository _repository;

  ReaderHighlightController(this._repository)
      : super(const ReaderHighlightState());

  /// 加载指定书籍的所有高亮
  Future<void> loadHighlights(int bookId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final highlights = await _repository.getHighlightsByBookId(bookId);
      state = state.copyWith(isLoading: false, highlights: highlights);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 设置高亮颜色
  void setColor(HighlightColorOption color) {
    state = state.copyWith(selectedColor: color);
  }

  /// 创建高亮（参数直接传入，避免在 build 阶段修改 provider）
  Future<void> createHighlight({
    required int bookId,
    required String selectedText,
    required int startOffset,
    required int endOffset,
    required int pageNumber,
  }) async {
    if (selectedText.isEmpty) return;

    final highlight = HighlightData(
      id: 0,
      uuid: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      selectedText: selectedText,
      highlightColor: state.selectedColor.hex,
      startOffset: startOffset,
      endOffset: endOffset,
      pageNumber: pageNumber,
    );

    try {
      await _repository.insertHighlight(highlight);
      await loadHighlights(bookId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 删除高亮
  Future<void> deleteHighlight(int highlightId, int bookId) async {
    try {
      await _repository.deleteHighlight(highlightId);
      await loadHighlights(bookId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}

/// 阅读器高亮控制器 Provider
final readerHighlightControllerProvider = StateNotifierProvider<
    ReaderHighlightController, ReaderHighlightState>((ref) {
  final repository = ref.watch(highlightRepositoryProvider);
  return ReaderHighlightController(repository);
});
