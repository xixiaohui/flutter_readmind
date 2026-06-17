// database_io.dart
// Native 平台数据库连接（sqlite3 FFI 后端）

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

LazyDatabase createConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'readmeet_quotes.db');

    return NativeDatabase(File(dbPath));
  });
}
