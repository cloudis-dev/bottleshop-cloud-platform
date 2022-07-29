import 'package:bottleshop_admin/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class OrdersPaginationStateNotifier extends PagedStreamsItemsStateNotifier<
    OrderModel, DocumentSnapshot, String> {
  OrdersPaginationStateNotifier(
    bool descending,
    Stream<PagedItemsStateStreamBatch<OrderModel, DocumentSnapshot>> Function(
            DocumentSnapshot?)
        createStream,
  ) : super(
          createStream,
          OrderItemsHandler(descending),
          (err, stack) => FirebaseCrashlytics.instance.recordError(err, stack),
        );
}

class OrderItemsHandler extends ItemsHandler<OrderModel, String> {
  OrderItemsHandler(bool descending)
      : super(
          (a, b) {
            if (descending) {
              final temp = b;
              b = a;
              a = temp;
            }
            return a.statusStepsDates.first.compareTo(b.statusStepsDates.first);
          },
          (a) => a.uniqueId,
        );
}
