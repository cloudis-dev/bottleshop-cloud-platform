import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/chips/orders/order_chips_row.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/order_detail/presentation/pages/order_detail_page.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/dialogs/confirm_order_state_change_dialog.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/dialogs/confirm_order_take_over_dialog.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/pages/orders_page.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/orders/presentation/widgets/order_card_action_button.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.id,
    required this.order,
  });

  final int id;
  final OrderModel order;

  Future _onOrderTakeOver(
    BuildContext context,
  ) async {
    final res = await showDialog<OrderTakeOverResult>(
      context: context,
      builder: (_) => ConfirmOrderTakeOverDialog(
        order: order,
      ),
    );

    if (res != null) {
      SnackBarUtils.showSnackBar(
        OrdersPage.scaffoldMessengerKey.currentState!,
        SnackBarDuration.short,
        res.message,
      );
    }
  }

  Future _onOrderStateChange(
    BuildContext context,
  ) async {
    final res = await showDialog<OrderStateChangeResult>(
      context: context,
      builder: (_) => ConfirmOrderStateChangeDialog(
        order: order,
      ),
    );

    if (res != null) {
      SnackBarUtils.showSnackBar(
        OrdersPage.scaffoldMessengerKey.currentState!,
        SnackBarDuration.short,
        res.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        color: id % 2 == 0 ? AppTheme.lightOrangeSolid : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OrderChipsRow(order: order),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(OrdersPage.orderStepsIcons[order.statusStepId],
                                size: 40,
                                color: order.isComplete
                                    ? AppTheme.completedOrderColor
                                    : Colors.black54),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'ID: ',
                                        style: AppTheme.headline3TextStyle
                                            .copyWith(color: Colors.black),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: order.orderId.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Zákazník: ',
                                          style: AppTheme.subtitle1TextStyle,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: order.customer.name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Zaplatené: ',
                                          style: AppTheme.subtitle1TextStyle,
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: FormattingUtil
                                                    .getPriceString(
                                                        order.totalPaid),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  FormattingUtil.getTimeString(
                                      order.statusStepsDates.first),
                                  style: AppTheme.subtitle1TextStyle
                                      .copyWith(color: Colors.black),
                                ),
                                Text(
                                  FormattingUtil.getDateString(
                                      order.statusStepsDates.first),
                                  style: AppTheme.subtitle1TextStyle
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (!order.isComplete)
                  OrderCardActionButton(
                    order: order,
                    onOrderStateChange: _onOrderStateChange,
                    onOrderTakeOver: _onOrderTakeOver,
                  ),
                OutlinedButton(
                  onPressed: () => context
                      .read(navigationProvider.notifier)
                      .pushPage(OrderDetailPage(order: order)),
                  child: Text('DETAIL', style: AppTheme.buttonTextStyle),
                )
              ],
            ),
            if (order.isTakenOverByAdmin && order.isFirstOrderStatusStep)
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () => context
                    .read(ordersRepositoryProvider)
                    .cancelOrderTakeOver(order),
                child: Text('Zrušiť prebratie'),
              )
          ],
        ),
      );
}
