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

import 'package:delivery/src/core/data/services/streamed_items_state_management/data/items_handler.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/data/items_state_stream_batch.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/presentation/view_models/implementations/paged_streams_items_state_notifier.dart';
import 'package:delivery/src/core/data/services/streamed_items_state_management/presentation/view_models/implementations/single_stream_items_state_notifier.dart';
import 'package:delivery/src/core/utils/sorting_util.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/sorting/data/models/sort_model.dart';
import 'package:logging/logging.dart';

final _logger = Logger((ProductsStateNotifierl10n.toString());

class ProductsStateNotifier extends SingleStreamItemsStateNotifier<ProductModel, String?> {
  ProductsStateNotifier(
    Stream<ItemsStateStreamBatch<ProductModel>> Function() requestItems,
    SortModel sortModel,
  ) : super(
          requestItems,
          ProductItemsHandler(sortModel),
          (err, stack) async => loggy.error('ProductsStateNotifier error', err, stack),
        );
}

/// The generic [T] parameter is the paging key.
/// It is used to know from which point to request more items.
/// E.g. When using Firestore it will be `DocumentSnapshot`.
class PagedProductsStateNotifier<T> extends PagedStreamsItemsStateNotifier<ProductModel, T, String?> {
  PagedProductsStateNotifier(
    Stream<PagedItemsStateStreamBatch<ProductModel, T>> Function(T? lastPageKey) requestMoreItemsStream,
    SortModel sortModel,
  ) : super(
          requestMoreItemsStream,
          ProductItemsHandler(sortModel),
          (err, stack) async => loggy.error('PagedProductsStateNotifier error', err, stack),
        );
}

class ProductItemsHandler extends ItemsHandler<ProductModel, String?> {
  ProductItemsHandler(SortModel sortModel)
      : super(
          (a, b) {
            return () {
              switch (sortModel.sortField) {
                case SortField.name:
                  return SortingUtil.stringSortCompare(
                    a.name,
                    b.name,
                    ascending: sortModel.ascending,
                  );
                case SortField.price:
                  return SortingUtil.numbersSortCompare(
                    a.finalPrice,
                    b.finalPrice,
                    ascending: sortModel.ascending,
                  );
              }
            }();
          },
          (a) => a.uniqueId,
        );
}
