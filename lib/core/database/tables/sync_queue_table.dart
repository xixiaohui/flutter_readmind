// sync_queue_table.dart
// sync_queue 表定义（未来云同步队列）

import 'package:drift/drift.dart';

/// sync_queue 表
class SyncQueue extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 实体类型
  TextColumn get entityType => text().named('entity_type').withLength(min: 1, max: 100)();

  /// 实体 ID
  IntColumn get entityId => integer().named('entity_id')();

  /// 操作类型（create, update, delete）
  TextColumn get action => text().withLength(min: 1, max: 50)();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
