// highlights_table.dart
// highlights 表定义（高亮）

import 'package:drift/drift.dart';

/// highlights 表
class Highlights extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// UUID（唯一标识符）
  TextColumn get uuid => text().unique()();

  /// 书籍 ID（外键）
  IntColumn get bookId => integer().named('book_id')();

  /// 章节索引
  IntColumn get chapterIndex => integer().named('chapter_index').nullable()();

  /// 页码
  IntColumn get pageNumber => integer().named('page_number').nullable()();

  /// 选中文本
  TextColumn get selectedText => text().named('selected_text')();

  /// 起始偏移量
  IntColumn get startOffset => integer().named('start_offset')();

  /// 结束偏移量
  IntColumn get endOffset => integer().named('end_offset')();

  /// 高亮颜色
  TextColumn get highlightColor => text().named('highlight_color').nullable()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();

  /// 更新时间
  IntColumn get updatedAt => integer().named('updated_at').withDefault(const Constant(0))();
}
