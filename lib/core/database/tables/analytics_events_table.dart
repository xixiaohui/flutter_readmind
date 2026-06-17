// analytics_events_table.dart
// analytics_events 表定义（本地分析缓存）

import 'package:drift/drift.dart';

/// analytics_events 表
class AnalyticsEvents extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 事件名称
  TextColumn get eventName => text().named('event_name').withLength(min: 1, max: 200)();

  /// 事件数据（JSON 字符串）
  TextColumn get payload => text().nullable()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
