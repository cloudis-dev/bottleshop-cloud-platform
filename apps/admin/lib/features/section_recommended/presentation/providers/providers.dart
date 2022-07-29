import 'package:bottleshop_admin/core/pagination_toolbox/products/products_pagination_state_notifier.dart';
import 'package:bottleshop_admin/features/section_recommended/data/repositories/recommended_products_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final recommendedProductsRepositoryProvider =
    Provider((_) => RecommendedProductsRepository());

final recommendedProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductsStateNotifier>(
  (ref) {
    return ProductsStateNotifier(
      () => ref
          .watch(recommendedProductsRepositoryProvider)
          .getRecommendedProductsStream(),
    )..requestData();
  },
);
