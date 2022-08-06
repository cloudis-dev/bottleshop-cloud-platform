import 'package:flutter/material.dart';

class PromoCodeUsagesChip extends StatelessWidget {
  const PromoCodeUsagesChip({
    Key? key,
    required this.usagesCount,
  }) : super(key: key);

  final int? usagesCount;

  @override
  Widget build(BuildContext context) => Chip(
        backgroundColor: usagesCount! > 0 ? Colors.green : Colors.redAccent,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        label: usagesCount! > 0
            ? RichText(
                text: TextSpan(
                  text: 'Zvyšné použitia: ',
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: '$usagesCount',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              )
            : Text('Neplatný'),
      );
}
