import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/utils/discount_util.dart';
import 'package:flutter/material.dart';

class DiscountChip extends StatelessWidget {
  const DiscountChip({
    Key? key,
    required this.discount,
  }) : super(key: key);

  final double? discount;

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: AppTheme.discountColor,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: RichText(
          text: TextSpan(
            text: 'Zľava ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: '${DiscountUtil.getPercentageFromDiscount(discount!)}%',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      );
}
