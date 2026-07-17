// purchase_page.dart
// 购买页面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/purchase_status.dart';
import '../controllers/purchase_controller.dart';

/// 购买页面
class PurchasePage extends ConsumerWidget {
  const PurchasePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(purchaseControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.purchase,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: state.status == ProStatus.pro
          ? _ProContent(l10n: l10n)
          : _PurchaseContent(state: state),
    );
  }
}

/// 购买内容
class _PurchaseContent extends ConsumerWidget {
  final PurchaseState state;

  const _PurchaseContent({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // 标题
          const SizedBox(height: 32),
          Icon(
            Icons.workspace_premium_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.upgradeToPro,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // 功能列表
          _FeatureRow(icon: Icons.book, text: 'Unlimited books'),
          _FeatureRow(icon: Icons.highlight, text: 'Unlimited highlights'),
          _FeatureRow(icon: Icons.image, text: 'Unlimited posters'),

          const Spacer(),

          // 产品卡片
          ...state.products.map((product) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${product.price} ${product.currency}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  ref
                                      .read(purchaseControllerProvider.notifier)
                                      .purchaseProduct(product.id);
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : Text(
                                  '${l10n.purchase} - \$${product.price}'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),

          TextButton(
            onPressed: state.isLoading
                ? null
                : () {
                    ref
                        .read(purchaseControllerProvider.notifier)
                        .restorePurchases();
                  },
            child: Text(l10n.restorePurchase),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// 功能行
class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// Pro 用户内容
class _ProContent extends StatelessWidget {
  final AppLocalizations l10n;

  const _ProContent({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.proVersion,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'All Pro features unlocked',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
