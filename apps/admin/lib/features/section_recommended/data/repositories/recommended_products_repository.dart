import 'package:bottleshop_admin/core/data/services/database_service.dart';
import 'package:bottleshop_admin/core/utils/change_status_util.dart';
import 'package:bottleshop_admin/features/products/data/products_repository.dart';
import 'package:bottleshop_admin/features/products/data/services.dart';
import 'package:bottleshop_admin/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';
import 'package:tuple/tuple.dart';

class RecommendedProductsRepository {
  Stream<ItemsStateStreamBatch<ProductModel>> getRecommendedProductsStream() {
    return productsDbService.streamQueryListWithChangesAll(
      args: [QueryArgs(ProductModel.isRecommendedField, isEqualTo: true)],
      orderBy: ProductsRepository.getProductsOrderBy(),
    ).map(
      (event) => ItemsStateStreamBatch<ProductModel>(
        event
            .map((e) => Tuple2(
                ChangeStatusUtil.convertFromFirestoreChange(e.item1), e.item2))
            .toList(),
      ),
    );
  }

  Future<void> removeProductFromRecommended(ProductModel product) {
    return productsDbService.updateData(
      product.uniqueId,
      {
        ProductModel.isRecommendedField: FieldValue.delete(),
      },
    );
  }

  Future<void> addProductToRecommended(ProductModel product) {
    return productsDbService.updateData(
      product.uniqueId,
      {
        ProductModel.isRecommendedField: true,
      },
    );
  }
}
