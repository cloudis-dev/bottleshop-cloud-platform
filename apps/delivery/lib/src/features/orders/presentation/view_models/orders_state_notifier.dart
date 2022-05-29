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

import 'package:delivery/src/core/utils/streamed_items_state_management/data/items_handler.dart';
import 'package:delivery/src/core/utils/streamed_items_state_management/presentation/view_models/implementations/paged_streams_items_state_notifier.dart';
import 'package:delivery/src/features/orders/data/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loggy/loggy.dart';

class OrdersStateNotifier extends PagedStreamsItemsStateNotifier<OrderModel, DocumentSnapshot, String> {
  OrdersStateNotifier(
    Stream<PagedItemsStateStreamBatch<OrderModel, DocumentSnapshot>> Function(DocumentSnapshot? fromPageKey)
        createStream,
  ) : super(
          createStream,
          OrdersItemsHandler(),
          (err, stack) async => logError('OrdersStateNotifier error', err, stack),
        );
}

class OrdersItemsHandler extends ItemsHandler<OrderModel, String> {
  OrdersItemsHandler()
      : super(
          (a, b) => b.createdAt.compareTo(a.createdAt),
          (a) => a.uniqueId,
        );
}
