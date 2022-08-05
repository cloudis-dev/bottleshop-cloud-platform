import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class RecommendedChip extends StatelessWidget {
  const RecommendedChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: AppTheme.recommendedColor,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: RichText(
          text: TextSpan(
            text: 'Odporúčané',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
