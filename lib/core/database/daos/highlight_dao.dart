// highlight_dao.dart
// Highlight 数据访问对象

import '../app_database.dart';

/// Highlight DAO (数据访问对象)
class HighlightDao {
  final AppDatabase db;

  HighlightDao(this.db);

  /// 获取所有高亮
  Future<List<Highlight>> getAllHighlights() =>
      db.select(db.highlights).get();

  /// 根据 ID 获取高亮
  Future<Highlight?> getHighlightById(int id) async {
    final query = db.select(db.highlights)
      ..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 根据书籍 ID 获取高亮
  Future<List<Highlight>> getHighlightsByBookId(int bookId) async {
    final query = db.select(db.highlights)
      ..where((t) => t.bookId.equals(bookId));
    return query.get();
  }

  /// 插入高亮
  Future<int> insertHighlight(HighlightsCompanion highlight) =>
      db.into(db.highlights).insert(highlight);

  /// 更新高亮
  Future<bool> updateHighlight(HighlightsCompanion highlight) =>
      db.update(db.highlights).replace(highlight);

  /// 删除高亮
  Future<int> deleteHighlight(int id) =>
      (db.delete(db.highlights)..where((t) => t.id.equals(id))).go();

  /// 监听所有高亮变化
  Stream<List<Highlight>> watchAllHighlights() =>
      db.select(db.highlights).watch();

  /// 监听书籍的高亮变化
  Stream<List<Highlight>> watchHighlightsByBookId(int bookId) {
    final query = db.select(db.highlights)
      ..where((t) => t.bookId.equals(bookId));
    return query.watch();
  }
}
