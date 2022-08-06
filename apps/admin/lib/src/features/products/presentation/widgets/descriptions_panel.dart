import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class DescriptionsPanel extends StatelessWidget {
  const DescriptionsPanel({
    Key? key,
    required this.descriptionSk,
    required this.descriptionEn,
  }) : super(key: key);

  final String? descriptionSk;
  final String? descriptionEn;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Popis Sk: ',
                  style: AppTheme.subtitle1TextStyle,
                ),
                Expanded(
                  child: Text(
                    descriptionSk ?? 'Produkt nemá žiaden popis.',
                    style: AppTheme.subtitle1TextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Popis En: ',
              style: AppTheme.subtitle1TextStyle,
            ),
            Expanded(
              child: Text(
                descriptionEn ?? 'Produkt nemá žiaden popis.',
                style: AppTheme.subtitle1TextStyle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        const Divider()
      ]);
}
