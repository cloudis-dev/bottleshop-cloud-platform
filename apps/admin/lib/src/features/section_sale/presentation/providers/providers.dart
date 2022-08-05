import 'package:bottleshop_admin/src/core/pagination_toolbox/products/products_pagination_state_notifier.dart';
import 'package:bottleshop_admin/src/features/section_sale/data/repositories/sale_products_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final saleProductsRepositoryProvider =
    Provider((_) => SaleProductsRepository());

final saleProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductsStateNotifier>(
  (ref) {
    return ProductsStateNotifier(
      () => ref.watch(saleProductsRepositoryProvider).getSaleProductsStream(),
    )..requestData();
  },
);
