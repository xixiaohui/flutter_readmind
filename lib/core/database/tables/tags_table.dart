// tags_table.dart
// tags 表定义（用户定义的标签）

import 'package:drift/drift.dart';

/// tags 表
class Tags extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 标签名称（唯一）
  TextColumn get name => text().unique()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
