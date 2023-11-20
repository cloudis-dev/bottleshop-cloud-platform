import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/config/bottleshop_icons.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/auth_providers.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderCardActionButton extends HookWidget {
  OrderCardActionButton({
    Key? key,
    required this.order,
    required this.onOrderStateChange,
    required this.onOrderTakeOver,
  })  : assert(!order.isComplete),
        super(key: key);

  final OrderModel order;
  final Future<void> Function(BuildContext) onOrderStateChange;
  final Future<void> Function(BuildContext) onOrderTakeOver;

  @override
  Widget build(BuildContext context) {
    Icon icon;
    if (!order.isTakenOverByAdmin) {
      icon = Icon(Icons.lock_open, color: Colors.white);
    } else if (order.isFollowingStatusIdComplete) {
      icon = Icon(
        Bottleshop.checkCircleOutline24px,
        color: Colors.white,
      );
    } else {
      icon = Icon(Icons.warning, color: Colors.white);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
        onPressed: order.isTakenOverByAdmin &&
                useProvider(loggedUserProvider).state != order.preparingAdmin
            ? null
            : () async => (order.isTakenOverByAdmin
                ? onOrderStateChange(context)
                : onOrderTakeOver(context)),
        child: Row(
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                  !order.isTakenOverByAdmin
                      ? 'PREBRAŤ'
                      : OrdersPage.orderStepsNames[order.getFollowingStatusId!]
                          .toUpperCase(),
                  style:
                      AppTheme.buttonTextStyle.copyWith(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
