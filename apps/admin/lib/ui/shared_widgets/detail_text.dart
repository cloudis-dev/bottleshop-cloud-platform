import 'package:flutter/material.dart';

class DetailText extends StatelessWidget {
  final String title;
  final String? value;
  final TextStyle theme;
  final TextStyle? valueTheme;

  const DetailText({
    Key? key,
    required this.title,
    required this.value,
    required this.theme,
    this.valueTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: title,
          style: theme,
          children: <TextSpan>[
            TextSpan(
              text: value,
              style: valueTheme ?? TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
