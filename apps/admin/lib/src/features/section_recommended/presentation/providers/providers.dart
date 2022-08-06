import 'package:bottleshop_admin/src/features/products/presentation/view_models/products_view_model.dart';
import 'package:bottleshop_admin/src/features/section_recommended/data/repositories/recommended_products_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final recommendedProductsRepositoryProvider =
    Provider((_) => RecommendedProductsRepository());

final recommendedProductsProvider =
    ChangeNotifierProvider.autoDispose<ProductStateViewModel>(
  (ref) {
    return ProductStateViewModel(
      () => ref
          .watch(recommendedProductsRepositoryProvider)
          .getRecommendedProductsStream(),
    )..requestData();
  },
);
