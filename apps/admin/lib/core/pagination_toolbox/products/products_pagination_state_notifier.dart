import 'package:bottleshop_admin/models/product_model.dart';
import 'package:bottleshop_admin/utils/sorting_util.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class ProductsStateNotifier
    extends SingleStreamItemsStateNotifier<ProductModel, String?> {
  ProductsStateNotifier(
    Stream<ItemsStateStreamBatch<ProductModel>> Function() requestStream,
  ) : super(
          requestStream,
          ProductItemsHandler(),
          (err, stack) => FirebaseCrashlytics.instance.recordError(err, stack),
        );
}

/// The generic [T] parameter is the paging key.
/// It is used to know from which point to request more items.
/// E.g. When using Firestore it will be `DocumentSnapshot`.
class PagedProductsStateNotifier<T>
    extends PagedStreamsItemsStateNotifier<ProductModel, T, String?> {
  PagedProductsStateNotifier(
    Stream<PagedItemsStateStreamBatch<ProductModel, T>> Function(T? lastPageKey)
        requestMoreItemsStream,
  ) : super(
          requestMoreItemsStream,
          ProductItemsHandler(),
          (err, stack) => FirebaseCrashlytics.instance.recordError(err, stack),
        );
}

class ProductItemsHandler extends ItemsHandler<ProductModel, String?> {
  ProductItemsHandler()
      : super(
          (a, b) => SortingUtil.stringSortCompare(a.name, b.name),
          (a) => a.uniqueId,
        );
}
