import 'package:flutter/material.dart';

class ActiveActionButton extends StatelessWidget {
  const ActiveActionButton({
    Key? key,
    required this.style,
    required this.icon,
    required this.text,
    required this.callback,
  }) : super(key: key);

  final TextStyle style;
  final IconData icon;
  final String text;
  final Function callback;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: callback as void Function()?,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(icon, color: style.color),
              padding: EdgeInsets.all(8),
            ),
            Text(text, style: style)
          ],
        ),
      );
}
