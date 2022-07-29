import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({
    Key? key,
    required this.title,
    required this.priceString,
    required this.textStyle,
  }) : super(key: key);

  final String title;
  final String priceString;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          Expanded(child: Text(title, style: textStyle)),
          Text(priceString, style: textStyle)
        ],
      );
}
