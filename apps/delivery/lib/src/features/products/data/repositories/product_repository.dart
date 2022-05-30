// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/core/data/repositories/repository_base.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/services/database_service.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/data/change_status.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/data/items_state_stream_batch.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/presentation/view_models/implementations/paged_streams_items_state_notifier.dart';
import 'package:delivery/src/core/utils/change_status_util.dart';
import 'package:delivery/src/features/products/data/models/flash_sale_model.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/sorting/data/models/sort_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class ProductsRepository extends RepositoryBase<ProductModel> {
  static const defaultProductsLimit = 25;

  ProductsRepository(DatabaseService<ProductModel> db) : super(db);

  Stream<ProductModel?> streamProduct(String uid) {
    return db.streamSingle(uid);
  }

  Stream<ItemsStateStreamBatch<ProductModel>> getFlashSaleProductsStream() {
    final currentTimestamp = Timestamp.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);

    final flashSaleUntilPath = FieldPath(
      const [
        ProductModel.flashSaleModelField,
        FlashSaleModel.flashSaleUntilField,
      ],
    );

    var query = <QueryArgs>[
      QueryArgs(flashSaleUntilPath, isGreaterThanOrEqualTo: currentTimestamp)
    ];

    final orderBy = <OrderBy>[
      OrderBy(flashSaleUntilPath),
      OrderBy(ProductModel.unaccentedNameSortField),
    ];

    return db.streamQueryListWithChangesAll(args: query, orderBy: orderBy).map(
          (event) => ItemsStateStreamBatch<ProductModel>(
            event
                .map((e) => Tuple2(
                      ChangeStatusUtil.convertFromFirestoreChange(e.value1),
                      e.value2 as ProductModel,
                    ))
                .toList(),
          ),
        );
  }

  Stream<PagedItemsStateStreamBatch<ProductModel, DocumentSnapshot>>
      getAllProductsStream(
    DocumentSnapshot? lastDoc,
    SortModel sortModel,
  ) {
    return db
        .streamQueryListWithChanges(
          limit: defaultProductsLimit,
          orderBy: [_getOrderBy(sortModel)],
          startAfterDocument: lastDoc,
        )
        .map(
          (event) => PagedItemsStateStreamBatch(
            event
                .map(
                  (e) => Tuple3(
                    ChangeStatusUtil.convertFromFirestoreChange(e.value1),
                    e.value2,
                    e.value3,
                  ),
                )
                .toList(),
          ),
        );
  }

  Stream<ItemsStateStreamBatch<ProductModel>> getNewProductsStream() {
    final query = [
      QueryArgs(ProductModel.isNewEntryField, isEqualTo: true),
    ];

    final orderBy = <OrderBy>[
      OrderBy(ProductModel.unaccentedNameSortField),
    ];

    return db.streamQueryListWithChangesAll(args: query, orderBy: orderBy).map(
          (event) => ItemsStateStreamBatch<ProductModel>(
            event
                .map(
                  (e) => Tuple2(
                    ChangeStatusUtil.convertFromFirestoreChange(e.value1),
                    e.value2 as ProductModel,
                  ),
                )
                .toList(),
          ),
        );
  }

  Stream<ItemsStateStreamBatch<ProductModel>> getRecommendedProductsStream() {
    final query = <QueryArgs>[
      QueryArgs(ProductModel.isRecommendedField, isEqualTo: true),
    ];
    final orderBy = <OrderBy>[
      OrderBy(ProductModel.unaccentedNameSortField),
    ];

    return db.streamQueryListWithChangesAll(args: query, orderBy: orderBy).map(
          (event) => ItemsStateStreamBatch<ProductModel>(
            event
                .map(
                  (e) => Tuple2(
                    ChangeStatusUtil.convertFromFirestoreChange(e.value1),
                    e.value2 as ProductModel,
                  ),
                )
                .toList(),
          ),
        );
  }

  Stream<ItemsStateStreamBatch<ProductModel>> getSaleProductsStream() {
    final query = <QueryArgs>[
      QueryArgs(ProductModel.isSaleField, isEqualTo: true),
    ];
    final orderBy = <OrderBy>[
      OrderBy(ProductModel.unaccentedNameSortField),
    ];

    return db.streamQueryListWithChangesAll(args: query, orderBy: orderBy).map(
          (event) => ItemsStateStreamBatch<ProductModel>(
            event
                .map(
                  (e) => Tuple2<ChangeStatus, ProductModel>(
                    ChangeStatusUtil.convertFromFirestoreChange(e.value1),
                    e.value2 as ProductModel,
                  ),
                )
                .toList(),
          ),
        );
  }

  Stream<PagedItemsStateStreamBatch<ProductModel, DocumentSnapshot>>
      getProductsByCategoryStream(
    CategoryPlainModel category,
    DocumentSnapshot? lastDocument,
    SortModel sortModel,
  ) {
    final query = [
      QueryArgs(
        ProductModel.categoryRefsField,
        arrayContains: FirebaseFirestore.instance
            .collection(FirestoreCollections.categoriesCollection)
            .doc(category.id),
      )
    ];

    return db
        .streamQueryListWithChanges(
          args: query,
          orderBy: [_getOrderBy(sortModel)],
          limit: defaultProductsLimit,
          startAfterDocument: lastDocument,
        )
        .map(
          (event) => PagedItemsStateStreamBatch(
            event
                .map(
                  (e) => Tuple3(
                    ChangeStatusUtil.convertFromFirestoreChange(e.value1),
                    e.value2,
                    e.value3,
                  ),
                )
                .toList(),
          ),
        );
  }

  OrderBy _getOrderBy(SortModel sortModel) => OrderBy(
        () {
          switch (sortModel.sortField) {
            case SortField.name:
              return ProductModel.unaccentedNameSortField;
            case SortField.price:
              return ProductModel.finalPriceSortField;
          }
        }(),
        descending: !sortModel.ascending,
      );
}
