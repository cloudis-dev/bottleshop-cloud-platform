import 'package:flutter/material.dart';

class AppTheme {
  static const Color discountColor = Colors.amberAccent;
  static const Color primaryColor = Colors.purple;
  static const Color flashSaleColor = Colors.orange;
  static const Color newEntryColor = Colors.purpleAccent;
  static const Color recommendedColor = Colors.lime;
  static const Color saleColor = Colors.green;

  static const Color lightGreySolid = Color(0xffe6e6e6);
  static const Color mediumGreySolid = Color(0xff808080);
  static const Color lightOrangeSolid = Color(0xfffff0e6);

  static const Color completedOrderColor = Colors.green;

  static const TextStyle buttonTextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor);
  static const TextStyle subtitle1TextStyle = TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey);
  static const TextStyle headline1TextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black);
  static const TextStyle headline2TextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black);
  static const TextStyle headline3TextStyle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey);
  static const TextStyle overlineTextStyle =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey);

  static const TextStyle alertDialogTitleTextStyle =
      TextStyle(fontSize: 16, color: Colors.black);
  static const TextStyle alertDialogContentTextStyle = TextStyle(fontSize: 14);
  static const TextStyle popupMenuItemTextStyle =
      TextStyle(fontSize: 16, color: Colors.black);

  static final ThemeData theme = ThemeData(
    primarySwatch: primaryColor as MaterialColor?,
    canvasColor: Colors.white,
    textTheme: TextTheme(
      headline1: headline1TextStyle,
      headline2: headline2TextStyle,
      headline3: headline3TextStyle,
      subtitle1: subtitle1TextStyle,
      button: buttonTextStyle,
      overline: overlineTextStyle,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
