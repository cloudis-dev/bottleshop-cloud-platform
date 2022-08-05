import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_type_model.dart';
import 'package:flutter/material.dart';

class OrderTypeChip extends StatelessWidget {
  final OrderTypeModel? orderTypeModel;

  const OrderTypeChip({
    Key? key,
    required this.orderTypeModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: Colors.amberAccent,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: Text(orderTypeModel!.localizedName.local,
            style: AppTheme.subtitle1TextStyle.copyWith(color: Colors.black)),
      );
}
