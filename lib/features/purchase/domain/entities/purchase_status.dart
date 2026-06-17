// purchase_status.dart
// 购买状态实体

/// 购买状态枚举
enum ProStatus {
  free,
  pro,
}

/// 产品信息
class ProductInfo {
  final String id;
  final String name;
  final String description;
  final String price;
  final String currency;

  const ProductInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
  });
}

/// 购买状态实体
class PurchaseState {
  final ProStatus status;
  final bool isLoading;
  final List<ProductInfo> products;

  const PurchaseState({
    this.status = ProStatus.free,
    this.isLoading = false,
    this.products = const [],
  });

  PurchaseState copyWith({
    ProStatus? status,
    bool? isLoading,
    List<ProductInfo>? products,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
    );
  }
}
