// reader_controller.dart
// Reader Controller (Riverpod)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/book_content.dart';
import '../../domain/entities/reading_position.dart';
import '../../domain/repositories/reader_repository.dart';

/// 阅读器状态
class ReaderState {
  final bool isLoading;
  final BookContent? content;
  final ReadingPosition? position;
  final int currentChapter;
  final int currentPage;
  final double fontSize;
  final String? errorMessage;

  const ReaderState({
    this.isLoading = false,
    this.content,
    this.position,
    this.currentChapter = 0,
    this.currentPage = 0,
    this.fontSize = 18.0,
    this.errorMessage,
  });

  ReaderState copyWith({
    bool? isLoading,
    BookContent? content,
    ReadingPosition? position,
    int? currentChapter,
    int? currentPage,
    double? fontSize,
    String? errorMessage,
  }) {
    return ReaderState(
      isLoading: isLoading ?? this.isLoading,
      content: content ?? this.content,
      position: position ?? this.position,
      currentChapter: currentChapter ?? this.currentChapter,
      currentPage: currentPage ?? this.currentPage,
      fontSize: fontSize ?? this.fontSize,
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

      // 尝试加载阅读位置，失败则使用默认位置
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

  /// 设置当前章节
  void setChapter(int chapterIndex) {
    state = state.copyWith(currentChapter: chapterIndex);
  }

  /// 设置当前页码
  void setPage(int pageNumber) {
    state = state.copyWith(currentPage: pageNumber);
  }

  /// 调整字体大小
  void setFontSize(double fontSize) {
    state = state.copyWith(fontSize: fontSize);
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
