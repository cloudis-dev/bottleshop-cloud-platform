import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:flutter/material.dart';

class InactiveActionButton extends StatelessWidget {
  const InactiveActionButton({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(icon, color: Colors.black12),
              padding: EdgeInsets.all(8),
            ),
            Text(
              text,
              style: AppTheme.buttonTextStyle.copyWith(color: Colors.black12),
            )
          ],
        ),
      );
}
