// database_web.dart
// Web 平台 - 数据库不可用（需要 wasm/sql.js worker）
// 应用将优雅降级：UI 可正常显示，数据操作暂时不可用

import 'package:drift/drift.dart';

LazyDatabase createConnection() {
  return LazyDatabase(() async {
    throw UnsupportedError(
      'Database not available on web in debug mode. '
      'Please run on a native platform (Windows/Android/iOS) for full functionality.',
    );
  });
}
