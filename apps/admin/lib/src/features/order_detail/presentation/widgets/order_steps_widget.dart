import 'package:bottleshop_admin/src/core/utils/iterable_extension.dart';
import 'package:bottleshop_admin/src/features/order_detail/presentation/widgets/order_step_connector_divider.dart';
import 'package:bottleshop_admin/src/features/order_detail/presentation/widgets/order_step_row.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderStepsWidget extends StatelessWidget {
  const OrderStepsWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ...Iterable<int>.generate(order.statusStepsDates.length)
                .map(
                  (e) => OrderStepRow(
                    orderStepId: order.orderType.orderStepsIds[e],
                    dateTime: order.statusStepsDates[e],
                    isLast: order.isComplete &&
                        order.orderType.orderStepsIds.length - 1 == e,
                  ),
                )
                .cast<Widget>()
                .interleave(const OrderStepConnectorDivider()),
          ],
        ),
      );
}
