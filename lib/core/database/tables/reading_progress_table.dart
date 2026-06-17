// reading_progress_table.dart
// reading_progress 表定义（阅读进度）

import 'package:drift/drift.dart';

/// reading_progress 表
class ReadingProgress extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 书籍 ID（外键）
  IntColumn get bookId => integer().named('book_id')();

  /// 章节索引
  IntColumn get chapterIndex => integer().named('chapter_index').nullable()();

  /// 页码
  IntColumn get pageNumber => integer().named('page_number').nullable()();

  /// 滚动位置
  RealColumn get scrollPosition => real().named('scroll_position').nullable()();

  /// 阅读进度百分比
  RealColumn get progressPercent => real().named('progress_percent').nullable()();

  /// 阅读分钟数
  IntColumn get readingMinutes => integer().named('reading_minutes').withDefault(const Constant(0))();

  /// 更新时间
  IntColumn get updatedAt => integer().named('updated_at').withDefault(const Constant(0))();
}
