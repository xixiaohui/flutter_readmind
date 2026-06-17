// app_metadata_table.dart
// app_metadata 表定义（应用内部信息）

import 'package:drift/drift.dart';

/// app_metadata 表
class AppMetadata extends Table {
  /// 元数据键（主键）
  TextColumn get metaKey => text().named('meta_key')();

  /// 元数据值
  TextColumn get metaValue => text().named('meta_value').nullable()();

  @override
  Set<Column> get primaryKey => {metaKey};
}
