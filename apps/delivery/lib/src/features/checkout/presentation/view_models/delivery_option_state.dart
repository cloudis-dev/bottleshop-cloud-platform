import 'package:delivery/src/features/cart/data/models/cart_model.dart';
import 'package:delivery/src/features/checkout/presentation/widgets/views/shipping_details_view.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeliveryOptionState extends StateNotifier<DeliveryOption?>
    with DeliveryAvailableForUserCheck {
  DeliveryOptionState() : super(null);

  void selectDeliveryOption(DeliveryOption newOption) {
    if (newOption != state) {
      state = newOption;
    }
  }

  String? get label {
    return ChargeShipping.fromDeliveryOption(state).shipping;
  }

  bool get paymentRequired {
    return state != DeliveryOption.cashOnDelivery;
  }
}
