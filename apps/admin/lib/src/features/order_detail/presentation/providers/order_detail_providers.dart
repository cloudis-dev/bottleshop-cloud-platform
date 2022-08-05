import 'package:bottleshop_admin/src/core/presentation/view_models/async_param_page_view_model.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final orderDetailPageOrderStreamProvider = StateNotifierProvider.autoDispose<
    AsyncParamPageViewModel<OrderModel>, AsyncValue<OrderModel>>(
  (ref) => AsyncParamPageViewModel<OrderModel>(),
);
