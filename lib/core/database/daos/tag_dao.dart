// tag_dao.dart
// Tag 数据访问对象

import '../app_database.dart';

/// Tag DAO (数据访问对象)
class TagDao {
  final AppDatabase db;

  TagDao(this.db);

  /// 获取所有标签
  Future<List<Tag>> getAllTags() => db.select(db.tags).get();

  /// 根据 ID 获取标签
  Future<Tag?> getTagById(int id) async {
    final query = db.select(db.tags)..where((t) => t.id.equals(id));
    return query.getSingleOrNull();
  }

  /// 根据名称获取标签
  Future<Tag?> getTagByName(String name) async {
    final query = db.select(db.tags)..where((t) => t.name.equals(name));
    return query.getSingleOrNull();
  }

  /// 插入标签
  Future<int> insertTag(TagsCompanion tag) =>
      db.into(db.tags).insert(tag);

  /// 删除标签
  Future<int> deleteTag(int id) =>
      (db.delete(db.tags)..where((t) => t.id.equals(id))).go();

  /// 监听所有标签变化
  Stream<List<Tag>> watchAllTags() => db.select(db.tags).watch();
}
