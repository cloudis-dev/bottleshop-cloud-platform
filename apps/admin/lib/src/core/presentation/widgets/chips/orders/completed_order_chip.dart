import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/features/orders/presentation/pages/orders_view.dart';
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
