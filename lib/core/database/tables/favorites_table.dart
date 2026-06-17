// favorites_table.dart
// favorites 表定义（收藏的高亮）

import 'package:drift/drift.dart';

/// favorites 表
class Favorites extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 高亮 ID（外键，唯一）
  IntColumn get highlightId => integer().named('highlight_id').unique()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
