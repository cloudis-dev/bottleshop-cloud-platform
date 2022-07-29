import 'package:bottleshop_admin/action_result.dart';
import 'package:bottleshop_admin/constants/app_strings.dart';
import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/features/orders/presentation/providers.dart';
import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/tabs_views/orders_view/orders_view.dart';
import 'package:bottleshop_admin/ui/shared_widgets/processing_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderStateChangeResult {
  OrderStateChangeResult(this.result, this.message);

  final String message;
  final ActionResult result;
}

class ConfirmOrderStateChangeDialog extends ProcessingAlertDialog {
  ConfirmOrderStateChangeDialog({
    Key? key,
    required this.order,
  }) : super(
          key: key,
          actionButtonColor: AppTheme.primaryColor,
          negativeButtonOptionBuilder: (_) => Text(
            'NIE',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey),
          ),
          positiveButtonOptionBuilder: (_) => Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text('ÁNO',
                    style:
                        AppTheme.buttonTextStyle.copyWith(color: Colors.white)),
              )
            ],
          ),
          onPositiveOption: (context) => context
              .read(ordersRepositoryProvider)
              .changeOrderToFollowingState(order)
              .then((_) => Navigator.pop(
                  context,
                  OrderStateChangeResult(
                      ActionResult.success, AppStrings.orderStateChangedMsg)))
              .catchError((err) => Navigator.pop(
                  context,
                  OrderStateChangeResult(
                      ActionResult.failed, AppStrings.unknownErrorMsg))),
          onNegativeOption: Navigator.pop,
        );

  final OrderModel order;

  @override
  Widget content(BuildContext context) => Text(
        'Naozaj presunúť objednávku ID: ${order.orderId} do stavu ${OrdersView.orderStepsNames[order.getFollowingStatusId!].toUpperCase()}?',
        style: AppTheme.alertDialogContentTextStyle,
      );
}
