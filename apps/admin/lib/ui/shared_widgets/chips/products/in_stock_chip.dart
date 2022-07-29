import 'package:flutter/material.dart';

class InStockChip extends StatelessWidget {
  const InStockChip(
    this.count, {
    Key? key,
  }) : super(key: key);

  final int? count;

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: count! > 0 ? Colors.green : Colors.redAccent,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: RichText(
          text: TextSpan(
              text: '$count ks ',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: 'na sklade',
                    style: TextStyle(fontWeight: FontWeight.normal))
              ]),
        ),
      );
}
