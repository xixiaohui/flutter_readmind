// highlight.dart
// 高亮实体

/// 高亮实体
class Highlight {
  final int id;
  final String uuid;
  final int bookId;
  final String selectedText;
  final String? highlightColor;
  final int startOffset;
  final int endOffset;
  final int? pageNumber;
  final DateTime createdAt;

  const Highlight({
    required this.id,
    required this.uuid,
    required this.bookId,
    required this.selectedText,
    this.highlightColor,
    required this.startOffset,
    required this.endOffset,
    this.pageNumber,
    required this.createdAt,
  });

  /// 创建新高的高亮
  factory Highlight.create({
    required int bookId,
    required String selectedText,
    String? highlightColor,
    required int startOffset,
    required int endOffset,
    int? pageNumber,
  }) {
    return Highlight(
      id: 0,
      uuid: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      selectedText: selectedText,
      highlightColor: highlightColor,
      startOffset: startOffset,
      endOffset: endOffset,
      pageNumber: pageNumber,
      createdAt: DateTime.now(),
    );
  }
}
