import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class FlashSaleChip extends StatelessWidget {
  const FlashSaleChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: AppTheme.flashSaleColor,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label:
            Text('Flash Sale', style: TextStyle(fontWeight: FontWeight.bold)),
      );
}
