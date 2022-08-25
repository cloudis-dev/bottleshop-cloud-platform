import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:bottleshop_admin/src/features/orders/data/repositories/orders_repository.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/view_models/orders_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ordersRepositoryProvider = Provider((ref) => OrdersRepository(ref));

final ordersStateProvider = ChangeNotifierProvider.autoDispose
    .family<OrdersPaginationViewModel, OrderStep>(
  (ref, orderStep) {
    final sortDescending = orderStep == OrderStep.completed;
    return OrdersPaginationViewModel(
      sortDescending,
      (lastDoc) => ref.read(ordersRepositoryProvider).getAllPagedOrdersStream(
            lastDoc,
            orderStep,
            sortDescending,
          ),
    )..requestData();
  },
);
