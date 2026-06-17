// generated_poster_dao.dart
// GeneratedPoster 数据访问对象

import '../app_database.dart';

/// GeneratedPoster DAO (数据访问对象)
class GeneratedPosterDao {
  final AppDatabase db;

  GeneratedPosterDao(this.db);

  /// 获取所有生成的海报
  Future<List<GeneratedPoster>> getAllPosters() =>
      db.select(db.generatedPosters).get();

  /// 根据 ID 获取海报
  Future<GeneratedPoster?> getPosterById(int id) async {
    final query = db.select(db.generatedPosters)
      ..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 根据高亮 ID 获取海报
  Future<List<GeneratedPoster>> getPostersByHighlightId(int highlightId) async {
    final query = db.select(db.generatedPosters)
      ..where((t) => t.highlightId.equals(highlightId));
    return query.get();
  }

  /// 插入海报
  Future<int> insertPoster(GeneratedPostersCompanion poster) =>
      db.into(db.generatedPosters).insert(poster);

  /// 删除海报
  Future<int> deletePoster(int id) =>
      (db.delete(db.generatedPosters)..where((t) => t.id.equals(id))).go();

  /// 监听所有海报变化
  Stream<List<GeneratedPoster>> watchAllPosters() =>
      db.select(db.generatedPosters).watch();
}
