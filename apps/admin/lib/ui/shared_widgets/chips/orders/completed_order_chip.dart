import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/ui/activities/app_activity/tabs_views/orders_view/orders_view.dart';
import 'package:flutter/material.dart';

class CompletedOrderChip extends StatelessWidget {
  const CompletedOrderChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: AppTheme.completedOrderColor,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(
          OrdersView.orderStepsNames.last,
          style: AppTheme.subtitle1TextStyle.copyWith(color: Colors.black),
        ),
      );
}
