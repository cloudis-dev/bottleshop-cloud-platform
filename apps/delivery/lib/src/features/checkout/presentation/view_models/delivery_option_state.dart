import 'package:delivery/src/features/checkout/presentation/widgets/views/shipping_details_view.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderTypeState extends StateNotifier<OrderTypeModel?>
    with DeliveryAvailableForUserCheck {
  OrderTypeState() : super(null);

  void selectOrderType(OrderTypeModel newOrderType) {
    if (newOrderType != state) {
      state = newOrderType;
    }
  }
}
