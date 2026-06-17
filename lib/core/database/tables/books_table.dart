// books_table.dart
// books 表定义

import 'package:drift/drift.dart';

/// books 表
class Books extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// UUID (唯一标识符)
  TextColumn get uuid => text().unique()();

  /// 书名
  TextColumn get title => text().withLength(min: 1, max: 500)();

  /// 作者
  TextColumn get author => text().nullable()();

  /// 描述
  TextColumn get description => text().nullable()();

  /// 语言
  TextColumn get language => text().nullable()();

  /// 出版商
  TextColumn get publisher => text().nullable()();

  /// ISBN
  TextColumn get isbn => text().nullable()();

  /// 封面路径
  TextColumn get coverPath => text().named('cover_path').nullable()();

  /// 文件路径
  TextColumn get filePath => text().named('file_path').withLength(min: 1)();

  /// 文件类型 (epub, pdf, txt)
  TextColumn get fileType => text().named('file_type').withLength(min: 1)();

  /// 文件大小 (字节)
  IntColumn get fileSize => integer().named('file_size').nullable()();

  /// 总页数
  IntColumn get totalPages => integer().named('total_pages').nullable()();

  /// 总章节数
  IntColumn get totalChapters => integer().named('total_chapters').nullable()();

  /// 最后打开时间 (时间戳)
  IntColumn get lastOpenedAt => integer().named('last_opened_at').nullable()();

  /// 创建时间 (时间戳)
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();

  /// 更新时间 (时间戳)
  IntColumn get updatedAt => integer().named('updated_at').withDefault(const Constant(0))();
}
