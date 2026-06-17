// notes_table.dart
// notes 表定义（笔记）

import 'package:drift/drift.dart';

/// notes 表
class Notes extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 高亮 ID（外键）
  IntColumn get highlightId => integer().named('highlight_id')();

  /// 笔记内容
  TextColumn get content => text()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();

  /// 更新时间
  IntColumn get updatedAt => integer().named('updated_at').withDefault(const Constant(0))();
}
