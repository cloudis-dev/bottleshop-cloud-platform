import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/core/utils/change_status_util.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:bottleshop_admin/src/features/products/data/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';
import 'package:tuple/tuple.dart';

class ProductsRepository {
  static const int productsPerPagination = 5;

  static List<OrderBy> getProductsOrderBy() =>
      [OrderBy(ProductModel.nameSortField)];

  DocumentReference getDocRef(ProductModel product) {
    return FirebaseFirestore.instance
        .collection(productsDbService.collection)
        .doc(product.uniqueId);
  }

  Stream<PagedItemsStateStreamBatch<ProductModel, DocumentSnapshot>>
      getAllPagedProductsStream(
    DocumentSnapshot? lastDocument,
  ) {
    return productsDbService
        .streamQueryListWithChanges(
          orderBy: getProductsOrderBy(),
          limit: productsPerPagination,
          startAfterDocument: lastDocument,
        )
        .map(
          (snap) => PagedItemsStateStreamBatch(
            snap
                .map(
                  (e) => Tuple3(
                    ChangeStatusUtil.convertFromFirestoreChange(e.item1),
                    e.item2,
                    e.item3,
                  ),
                )
                .toList(),
          ),
        );
  }
}
