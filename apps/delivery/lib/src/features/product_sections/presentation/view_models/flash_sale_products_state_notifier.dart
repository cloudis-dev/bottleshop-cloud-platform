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

import 'package:delivery/src/core/utils/streamed_items_state_management/data/items_state_stream_batch.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/products/utils/products_sorting_util.dart';

class FlashSaleProductsStateNotifier extends SingleStreamItemsStateNotifier<ProductModel, String?> {
  FlashSaleProductsStateNotifier(
    Stream<ItemsStateStreamBatch<ProductModel>> Function() requestItems,
  ) : super(
          requestItems,
          FlashSaleProductItemsHandler(),
          (err, stack) async => loggy.error('FlashSaleProductsStateNotifier error', err, stack),
        );

  /// Check all the products' flash sales and remove the ones
  /// that have flash sale time in the past already.
  ///
  /// This will be called from some provider where the ticking is being done.
  /// This could be getting a server time, too.
  void checkFlashSaleItemsTime() async {
    itemsState = itemsState.copyWith(
      items: itemsState.items
          .where(
            (element) => element.flashSale != null && element.flashSale!.flashSaleUntil.compareTo(DateTime.now()) > 0,
          )
          .toList(),
      status: itemsState.status,
    );

    notifyListeners();
  }
}

class FlashSaleProductItemsHandler extends ItemsHandler<ProductModel, String?> {
  FlashSaleProductItemsHandler()
      : super(
          ProductsSortingUtil.flashSaleProductsCompare,
          (a) => a.uniqueId,
          // in case any products change,
          // check if all the flash sale products are in the right time
          itemFilterTest: (item) =>
              item.flashSale != null && item.flashSale!.flashSaleUntil.compareTo(DateTime.now()) > 0,
        );
}
