// reading_progress_dao.dart
// ReadingProgress 数据访问对象

import '../app_database.dart';

/// ReadingProgress DAO (数据访问对象)
class ReadingProgressDao {
  final AppDatabase db;

  ReadingProgressDao(this.db);

  /// 获取所有阅读进度
  Future<List<ReadingProgressData>> getAllProgress() =>
      db.select(db.readingProgress).get();

  /// 根据 ID 获取进度
  Future<ReadingProgressData?> getProgressById(int id) async {
    final query = db.select(db.readingProgress)
      ..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 根据书籍 ID 获取进度
  Future<ReadingProgressData?> getProgressByBookId(int bookId) async {
    final query = db.select(db.readingProgress)
      ..where((t) => t.bookId.equals(bookId));
    return query.getSingleOrNull();
  }

  /// 插入进度
  Future<int> insertProgress(ReadingProgressCompanion progress) =>
      db.into(db.readingProgress).insert(progress);

  /// 更新进度
  Future<bool> updateProgress(ReadingProgressCompanion progress) =>
      db.update(db.readingProgress).replace(progress);

  /// 删除进度
  Future<int> deleteProgress(int id) =>
      (db.delete(db.readingProgress)..where((t) => t.id.equals(id))).go();

  /// 监听书籍进度变化
  Stream<ReadingProgressData?> watchProgressByBookId(int bookId) {
    final query = db.select(db.readingProgress)
      ..where((t) => t.bookId.equals(bookId));
    return query.watchSingleOrNull();
  }
}
