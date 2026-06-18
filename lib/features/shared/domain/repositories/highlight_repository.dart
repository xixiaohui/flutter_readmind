// highlight_repository.dart
// Highlight Repository 接口（domain 层）

/// 高亮数据模型
class HighlightData {
  final int id;
  final String uuid;
  final int bookId;
  final String selectedText;
  final String? highlightColor;
  final int startOffset;
  final int endOffset;
  final int? pageNumber;

  const HighlightData({
    required this.id,
    required this.uuid,
    required this.bookId,
    required this.selectedText,
    this.highlightColor,
    required this.startOffset,
    required this.endOffset,
    this.pageNumber,
  });
}

/// Highlight Repository 抽象接口
abstract class HighlightRepository {
  /// 获取所有高亮
  Future<List<HighlightData>> getAllHighlights();

  /// 根据 ID 获取高亮
  Future<HighlightData?> getHighlightById(int id);

  /// 根据书籍 ID 获取高亮
  Future<List<HighlightData>> getHighlightsByBookId(int bookId);

  /// 插入高亮
  Future<int> insertHighlight(HighlightData highlight);

  /// 删除高亮
  Future<int> deleteHighlight(int id);

  /// 监听所有高亮变化
  Stream<List<HighlightData>> watchAllHighlights();

  /// 监听书籍的高亮变化
  Stream<List<HighlightData>> watchHighlightsByBookId(int bookId);
}
