import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/core/utils/change_status_util.dart';
import 'package:bottleshop_admin/src/features/products/data/products_repository.dart';
import 'package:bottleshop_admin/src/features/products/data/services.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';
import 'package:tuple/tuple.dart';

class NewEntryProductsRepository {
  Stream<ItemsStateStreamBatch<ProductModel>> getNewEntriesProductsStream() {
    return productsDbService.streamQueryListWithChangesAll(
      args: [QueryArgs(ProductModel.isNewEntryField, isEqualTo: true)],
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

  Future<void> removeProductFromNewEntries(ProductModel product) {
    return productsDbService.updateData(
      product.uniqueId,
      {
        ProductModel.isNewEntryField: FieldValue.delete(),
      },
    );
  }

  Future<void> addProductToNewEntries(ProductModel product) {
    return productsDbService.updateData(
      product.uniqueId,
      {
        ProductModel.isNewEntryField: true,
      },
    );
  }
}
