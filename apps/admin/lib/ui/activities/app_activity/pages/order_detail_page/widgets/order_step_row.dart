import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/tabs_views/orders_view/orders_view.dart';
import 'package:bottleshop_admin/utils/formatting_util.dart';
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
            OrdersView.orderStepsIcons[orderStepId!],
            color: isLast ? AppTheme.completedOrderColor : Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              '${isLast ? OrdersView.orderStepsNames.last : OrdersView.orderStepsNames[orderStepId!]} ${FormattingUtil.getDateString(dateTime)} ${FormattingUtil.getTimeString(dateTime)}',
              style: AppTheme.subtitle1TextStyle.copyWith(
                  fontSize: 14,
                  color: isLast ? AppTheme.completedOrderColor : null),
            ),
          )
        ],
      );
}
