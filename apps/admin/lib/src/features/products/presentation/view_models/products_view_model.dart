import 'package:bottleshop_admin/src/core/utils/sorting_util.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class ProductStateViewModel
    extends SingleStreamItemsStateNotifier<ProductModel, String?> {
  ProductStateViewModel(
    Stream<ItemsStateStreamBatch<ProductModel>> Function() requestStream,
  ) : super(requestStream, _ProductItemsHandler(),
            (err, stack) => debugPrint(err.toString()));
}

/// The generic [T] parameter is the paging key.
/// It is used to know from which point to request more items.
/// E.g. When using Firestore it will be `DocumentSnapshot`.
class PagedProductsViewModel<T>
    extends PagedStreamsItemsStateNotifier<ProductModel, T, String?> {
  PagedProductsViewModel(
    Stream<PagedItemsStateStreamBatch<ProductModel, T>> Function(T? lastPageKey)
        requestMoreItemsStream,
  ) : super(requestMoreItemsStream, _ProductItemsHandler(),
            (err, stack) => debugPrint(err.toString()));
}

class _ProductItemsHandler extends ItemsHandler<ProductModel, String?> {
  _ProductItemsHandler()
      : super(
          (a, b) => SortingUtil.stringSortCompare(a.name, b.name),
          (a) => a.uniqueId,
        );
}
