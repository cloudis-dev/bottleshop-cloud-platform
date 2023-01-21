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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:delivery/src/features/orders/data/models/order_model.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:delivery/src/features/orders/data/repositories/order_repository.dart';
import 'package:delivery/src/features/orders/data/services/orders_service.dart';
import 'package:delivery/src/features/orders/presentation/view_models/orders_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderRepositoryProvider = Provider.autoDispose((_) => OrderRepository());

final ordersProvider = ChangeNotifierProvider.autoDispose<OrdersStateNotifier>(
  (ref) {
    final currentUser = ref.watch(currentUserProvider);
    final orderRepo = ref.watch(orderRepositoryProvider);

    return OrdersStateNotifier(
      (lastDoc) => orderRepo.getUserOrdersStream(lastDoc, currentUser),
    )..requestData();
  },
);

final activeOrdersCountProvider = StreamProvider.autoDispose<int>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return ref.watch(orderRepositoryProvider).activeOrdersCount(currentUser);
});

final orderStreamProvider =
    StreamProvider.autoDispose.family<OrderModel?, String>(
  (ref, orderUniqueId) => ordersDbService.streamSingle(orderUniqueId),
);

final orderTypesProvider = FutureProvider(
  (ref) async {
    final docs = await FirebaseFirestore.instance
        .collection(FirestoreCollections.orderTypesCollection)
        .orderBy('listing_order_id')
        .get();
    final docsMap =
        Map.fromEntries(docs.docs.map((e) => MapEntry(e.id, e.data())));
    return docsMap.entries
        .map((e) => OrderTypeModel.fromMap(e.key, e.value))
        .toList();
  },
);
