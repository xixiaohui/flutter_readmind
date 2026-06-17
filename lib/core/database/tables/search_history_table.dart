// search_history_table.dart
// search_history 表定义（搜索历史）

import 'package:drift/drift.dart';

/// search_history 表
class SearchHistory extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 搜索关键词
  TextColumn get keyword => text().withLength(min: 1, max: 500)();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
