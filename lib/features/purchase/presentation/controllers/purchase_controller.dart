// purchase_controller.dart
// Purchase Controller (Riverpod)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/purchase_status.dart';

/// 购买控制器
class PurchaseController extends StateNotifier<PurchaseState> {
  PurchaseController() : super(const PurchaseState()) {
    // 默认产品配置
    state = state.copyWith(
      products: const [
        ProductInfo(
          id: 'readmeet_quotes_pro',
          name: 'ReadMeet Quotes Pro',
          description:
              'Unlock unlimited books, highlights, and posters.',
          price: '4.99',
          currency: 'USD',
        ),
      ],
    );
  }

  /// 开始购买流程
  Future<void> purchaseProduct(String productId) async {
    state = state.copyWith(isLoading: true);

    try {
      // 模拟购买流程（实际实现将在集成 IAP 后完成）
      await Future.delayed(const Duration(seconds: 2));

      if (productId == 'readmeet_quotes_pro') {
        state = state.copyWith(
          isLoading: false,
          status: ProStatus.pro,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 恢复购买
  Future<void> restorePurchases() async {
    state = state.copyWith(isLoading: true);

    try {
      // 模拟恢复流程
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(
        isLoading: false,
        status: ProStatus.pro,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// 获取 Pro 状态
  ProStatus get proStatus => state.status;

  /// 是否为 Pro 用户
  bool get isPro => state.status == ProStatus.pro;
}

/// Purchase Controller Provider
final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, PurchaseState>((ref) {
  return PurchaseController();
});
