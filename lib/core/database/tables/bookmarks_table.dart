// bookmarks_table.dart
// bookmarks 表定义（阅读书签）

import 'package:drift/drift.dart';

/// bookmarks 表
class Bookmarks extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 书籍 ID（外键）
  IntColumn get bookId => integer().named('book_id')();

  /// 章节索引
  IntColumn get chapterIndex => integer().named('chapter_index').nullable()();

  /// 页码
  IntColumn get pageNumber => integer().named('page_number').nullable()();

  /// 备注
  TextColumn get note => text().nullable()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
