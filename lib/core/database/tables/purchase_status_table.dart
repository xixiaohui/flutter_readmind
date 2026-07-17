// purchase_status_table.dart
// purchase_status 表定义（购买状态）

import 'package:drift/drift.dart';

/// purchase_status 表
class PurchaseStatus extends Table {
  /// 主键 ID
  IntColumn get id => integer().autoIncrement()();

  /// 产品 ID
  TextColumn get productId => text().named('product_id').nullable()();

  /// 购买令牌
  TextColumn get purchaseToken => text().named('purchase_token').nullable()();

  /// 是否激活
  IntColumn get isActive => integer().named('is_active').withDefault(const Constant(0))();

  /// 购买时间
  IntColumn get purchasedAt => integer().named('purchased_at').nullable()();

  /// 过期时间
  IntColumn get expiresAt => integer().named('expires_at').nullable()();
}
