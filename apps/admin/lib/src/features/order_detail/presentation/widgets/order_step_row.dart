import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/pages/orders_page.dart';
import 'package:flutter/material.dart';

class OrderStepRow extends StatelessWidget {
  const OrderStepRow({
    Key? key,
    required this.isLast,
    required this.dateTime,
    required this.orderStepId,
  }) : super(key: key);

  final bool isLast;
  final DateTime dateTime;
  final int? orderStepId;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(
            OrdersPage.orderStepsIcons[orderStepId!],
            color: isLast ? AppTheme.completedOrderColor : Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '${isLast ? OrdersPage.orderStepsNames.last : OrdersPage.orderStepsNames[orderStepId!]} ${FormattingUtil.getDateString(dateTime)} ${FormattingUtil.getTimeString(dateTime)}',
              style: AppTheme.subtitle1TextStyle.copyWith(
                  fontSize: 14,
                  color: isLast ? AppTheme.completedOrderColor : null),
            ),
          )
        ],
      );
}
