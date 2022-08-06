import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class OrdersList extends HookWidget {
  const OrdersList({
    Key? key,
    required this.orderStep,
  }) : super(key: key);

  final OrderStep orderStep;

  @override
  Widget build(BuildContext context) {
    final ordersState = useProvider(
      ordersStateProvider(orderStep).select((value) => value.itemsState),
    );

    if (ordersState.isDoneAndEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'Žiadne objednávky v tomto kroku.',
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            sliver: SliverPagedList<OrderModel>(
              itemsState: ordersState,
              itemBuilder: (context, item, index) => OrderCard(
                id: index,
                order: item,
              ),
              requestData: () =>
                  context.read(ordersStateProvider(orderStep)).requestData(),
            ),
          )
        ],
      );
    }
  }
}
