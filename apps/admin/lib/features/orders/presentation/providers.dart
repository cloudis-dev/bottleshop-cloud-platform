import 'package:bottleshop_admin/core/pagination_toolbox/orders/orders_pagination_state_notifier.dart';
import 'package:bottleshop_admin/features/orders/data/orders_repository.dart';
import 'package:bottleshop_admin/orders_step.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final ordersRepositoryProvider = Provider((ref) => OrdersRepository(ref));

final ordersStateProvider = ChangeNotifierProvider.autoDispose
    .family<OrdersPaginationStateNotifier, OrderStep>(
  (ref, orderStep) {
    final sortDescending = orderStep == OrderStep.completed;
    return OrdersPaginationStateNotifier(
      sortDescending,
      (lastDoc) => ref.read(ordersRepositoryProvider).getAllPagedOrdersStream(
            lastDoc,
            orderStep,
            sortDescending,
          ),
    )..requestData();
  },
);
