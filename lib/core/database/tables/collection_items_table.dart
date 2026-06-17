// collection_items_table.dart
// collection_items 表定义（集合和高亮的多对多关系）

import 'package:drift/drift.dart';

/// collection_items 表
class CollectionItems extends Table {
  /// 集合 ID（外键）
  IntColumn get collectionId => integer().named('collection_id')();

  /// 高亮 ID（外键）
  IntColumn get highlightId => integer().named('highlight_id')();

  /// 复合主键
  @override
  Set<Column> get primaryKey => {collectionId, highlightId};
}
