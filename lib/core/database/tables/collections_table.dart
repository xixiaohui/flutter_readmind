// collections_table.dart
// collections 表定义（自定义摘录集合）

import 'package:drift/drift.dart';

/// collections 表
class Collections extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 集合名称
  TextColumn get name => text().withLength(min: 1, max: 200)();

  /// 集合描述
  TextColumn get description => text().nullable()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
