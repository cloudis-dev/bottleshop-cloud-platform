import 'package:bottleshop_admin/src/features/products/presentation/view_models/products_view_model.dart';
import 'package:bottleshop_admin/src/features/section_sale/data/repositories/sale_products_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final saleProductsRepositoryProvider =
    Provider((_) => SaleProductsRepository());

final saleProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductStateViewModel>(
  (ref) {
    return ProductStateViewModel(
      () => ref.watch(saleProductsRepositoryProvider).getSaleProductsStream(),
    )..requestData();
  },
);
