// user_settings_table.dart
// user_settings 表定义（用户设置）

import 'package:drift/drift.dart';

/// user_settings 表
class UserSettings extends Table {
  /// 设置键（主键）
  TextColumn get key => text()();

  /// 设置值
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
