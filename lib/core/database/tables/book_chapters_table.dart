// book_chapters_table.dart
// book_chapters 表定义（EPUB/TXT 章节结构）

import 'package:drift/drift.dart';

/// book_chapters 表
class BookChapters extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 书籍 ID（外键）
  IntColumn get bookId => integer().named('book_id')();

  /// 章节索引
  IntColumn get chapterIndex => integer().named('chapter_index')();

  /// 章节标题
  TextColumn get title => text().nullable()();

  /// 内容路径（存储章节内容的文件路径）
  TextColumn get contentPath => text().named('content_path').nullable()();

  /// 字数
  IntColumn get wordCount => integer().named('word_count').nullable()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
