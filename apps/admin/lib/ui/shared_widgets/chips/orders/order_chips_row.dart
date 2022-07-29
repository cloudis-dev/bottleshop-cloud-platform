import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/ui/shared_widgets/chips/orders/admin_user_chip.dart';
import 'package:bottleshop_admin/ui/shared_widgets/chips/orders/completed_order_chip.dart';
import 'package:bottleshop_admin/ui/shared_widgets/chips/orders/order_type_chip.dart';
import 'package:flutter/material.dart';

class OrderChipsRow extends StatelessWidget {
  const OrderChipsRow({
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) => Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          OrderTypeChip(
            orderTypeModel: order.orderType,
          ),
          if (order.isTakenOverByAdmin)
            AdminUserChip(
              adminUser: order.preparingAdmin,
            ),
          if (order.isComplete) CompletedOrderChip(),
        ],
      );
}
