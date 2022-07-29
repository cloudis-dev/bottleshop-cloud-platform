import 'package:bottleshop_admin/action_result.dart';
import 'package:bottleshop_admin/constants/app_strings.dart';
import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/features/orders/presentation/providers.dart';
import 'package:bottleshop_admin/models/order_model.dart';
import 'package:bottleshop_admin/providers/auth_providers.dart';
import 'package:bottleshop_admin/ui/shared_widgets/processing_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OrderTakeOverResult {
  OrderTakeOverResult(this.result, this.message);

  final String message;
  final ActionResult result;
}

class ConfirmOrderTakeOverDialog extends ProcessingAlertDialog {
  ConfirmOrderTakeOverDialog({
    Key? key,
    required OrderModel order,
  }) : super(
          key: key,
          actionButtonColor: AppTheme.primaryColor,
          negativeButtonOptionBuilder: (_) => Text(
            'NIE',
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.grey),
          ),
          positiveButtonOptionBuilder: (_) => Row(
            children: [
              Icon(Icons.lock_open, color: Colors.white),
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
              .takeOverTheOrder(order, context.read(loggedUserProvider).state!)
              .then((_) => Navigator.pop(
                  context,
                  OrderTakeOverResult(
                      ActionResult.success, AppStrings.orderTakenOverMsg)))
              .catchError((err) => Navigator.pop(
                  context,
                  OrderTakeOverResult(
                      ActionResult.failed, AppStrings.unknownErrorMsg))),
          onNegativeOption: Navigator.pop,
        );

  @override
  Widget content(BuildContext context) => Text(
        'Prebrať objednávku ako @${context.read(loggedUserProvider).state!.nick}?',
        style: AppTheme.alertDialogContentTextStyle,
      );
}
