// generated_posters_table.dart
// generated_posters 表定义（生成的海报历史）

import 'package:drift/drift.dart';

/// generated_posters 表
class GeneratedPosters extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 高亮 ID（外键）
  IntColumn get highlightId => integer().named('highlight_id')();

  /// 引用文本
  TextColumn get quoteText => text().named('quote_text')();

  /// 书名
  TextColumn get bookTitle => text().named('book_title').nullable()();

  /// 作者
  TextColumn get author => text().named('author').nullable()();

  /// 模板键
  TextColumn get templateKey => text().named('template_key').nullable()();

  /// 比例 (1:1, 4:5, 9:16)
  TextColumn get ratio => text().nullable()();

  /// 图片路径
  TextColumn get imagePath => text().named('image_path').nullable()();

  /// 创建时间
  IntColumn get createdAt => integer().named('created_at').withDefault(const Constant(0))();
}
