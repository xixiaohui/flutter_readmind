// reading_position.dart
// 阅读位置实体

/// 阅读位置实体
class ReadingPosition {
  final int bookId;
  final int chapterIndex;
  final int pageNumber;
  final double scrollPosition;
  final double progressPercent;
  final DateTime lastReadAt;

  const ReadingPosition({
    required this.bookId,
    this.chapterIndex = 0,
    this.pageNumber = 0,
    this.scrollPosition = 0.0,
    this.progressPercent = 0.0,
    required this.lastReadAt,
  });

  /// 创建默认位置
  factory ReadingPosition.initial(int bookId) {
    return ReadingPosition(
      bookId: bookId,
      lastReadAt: DateTime.now(),
    );
  }

  /// 复制并更新
  ReadingPosition copyWith({
    int? chapterIndex,
    int? pageNumber,
    double? scrollPosition,
    double? progressPercent,
    DateTime? lastReadAt,
  }) {
    return ReadingPosition(
      bookId: bookId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      pageNumber: pageNumber ?? this.pageNumber,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      progressPercent: progressPercent ?? this.progressPercent,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }
}
