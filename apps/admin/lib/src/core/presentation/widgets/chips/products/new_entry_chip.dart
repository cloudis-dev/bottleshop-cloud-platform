import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class NewEntryChip extends StatelessWidget {
  const NewEntryChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: AppTheme.newEntryColor,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: RichText(
          text: TextSpan(
            text: 'Novinka',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
