// highlight_tags_table.dart
// highlight_tags 表定义（高亮和标签的多对多关系）

import 'package:drift/drift.dart';

/// highlight_tags 表
class HighlightTags extends Table {
  /// 高亮 ID（外键）
  IntColumn get highlightId => integer().named('highlight_id')();

  /// 标签 ID（外键）
  IntColumn get tagId => integer().named('tag_id')();

  /// 复合主键
  @override
  Set<Column> get primaryKey => {highlightId, tagId};
}
