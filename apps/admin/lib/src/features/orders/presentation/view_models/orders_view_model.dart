import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class OrdersPaginationViewModel extends PagedStreamsItemsStateNotifier<
    OrderModel, DocumentSnapshot, String> {
  OrdersPaginationViewModel(
    bool descending,
    Stream<PagedItemsStateStreamBatch<OrderModel, DocumentSnapshot>> Function(
            DocumentSnapshot?)
        createStream,
  ) : super(
          createStream,
          _OrderItemsHandler(descending),
          (err, stack) => FirebaseCrashlytics.instance.recordError(err, stack),
        );
}

class _OrderItemsHandler extends ItemsHandler<OrderModel, String> {
  _OrderItemsHandler(bool descending)
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
