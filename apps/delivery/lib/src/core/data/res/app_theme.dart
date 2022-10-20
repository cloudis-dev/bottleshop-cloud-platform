// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kBottleshopPrimaryColor = Color(0xffe3ecec);
const _kBottleshopPrimaryVariantColor = Color(0xFF344955);
const _kBottleshopOnPrimaryColor = Colors.black;
const _kBottleshopSecondaryColor = Color(0xFFF9AA33);
const kBottleshopSecondaryVariantColor = Color(0xFFBC770A);
const _kBottleshopOnSecondaryColor = Color(0xFF262626);
const _kBottleshopBackGroundColor = Colors.white;
const _kBottleshopOnBackGroundColor = Colors.black;
const _kBottleshopErrorColor = Color(0xFFDD201D);

const _kBottleshopPrimaryDarkColor = Color(0xFFBC770A);
const _kBottleshopPrimaryVariantDarkColor = Color(0xff3700B3);
const _kBottleshopSecondaryDarkColor = Color(0xFFF9AA33);
const _kBottleshopSecondaryVariantDarkColor = Color(0xD8ECA63C);
const _kBottleshopSurfaceDarkColor = Color(0xff121212);
const _kBottleshopBackGroundDarkColor = Color(0xff121212);
const _kBottleshopErrorDarkColor = Color(0xffcf6679);
const _kBottleshopOnPrimaryDark = Colors.black;
const _kBottleshopOnSecondaryDark = Colors.black;
const _kBottleshopOnSurfaceDark = Colors.white;
const _kBottleshopOnBackgroundDark = Colors.white;

TextTheme workSansTextTheme = TextTheme(
  headline1: GoogleFonts.workSans(
      fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.workSans(
      fontSize: 60,  fontWeight: FontWeight.w600, letterSpacing: -0.5),
  headline3: GoogleFonts.workSans(
      fontSize: 40, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  headline4: GoogleFonts.workSans(
      fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.workSans(fontSize: 24, fontWeight: FontWeight.w700),
  headline6: GoogleFonts.workSans(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.workSans(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.workSans(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.workSans(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.workSans(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.workSans(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.workSans(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.workSans(
      fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5),
);

final appTheme = buildAppTheme();

final appThemeDark = buildDarkAppTheme();


final textButtonLinkTheme = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all(Colors.white),
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    overlayColor: MaterialStateProperty.all(Colors.transparent),
    padding: MaterialStateProperty.all(EdgeInsets.zero),
    minimumSize: MaterialStateProperty.all(Size.zero),
    elevation: MaterialStateProperty.all(0),
    textStyle: MaterialStateProperty.resolveWith(
      (states) {
        final hovered = [
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
        ];

        if (states.any(hovered.contains)) {
          return workSansTextTheme.caption!.copyWith(
            decoration: TextDecoration.underline,
          );
        }

        return workSansTextTheme.caption;
      },
    ),
  ),
);

ThemeData buildAppTheme() {
  final base = ThemeData.from(
    colorScheme: const ColorScheme(
      primary: _kBottleshopPrimaryColor,
      primaryContainer: _kBottleshopPrimaryVariantColor,
      onPrimary: _kBottleshopOnPrimaryColor,
      secondary: _kBottleshopSecondaryColor,
      secondaryContainer: kBottleshopSecondaryVariantColor,
      onSecondary: _kBottleshopOnSecondaryColor,
      background: _kBottleshopBackGroundColor,
      onBackground: _kBottleshopOnBackGroundColor,
      surface: Colors.white,
      onSurface: Colors.black,
      error: _kBottleshopErrorColor,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    textTheme: workSansTextTheme,
  );
  return base.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: base.appBarTheme.copyWith(
      elevation: kIsWeb ? null : 0,
      backgroundColor: kIsWeb ? _kBottleshopSecondaryColor : Colors.transparent,
      foregroundColor: Colors.black,
      titleTextStyle: workSansTextTheme.headline6!
          .copyWith(color: _kBottleshopOnBackGroundColor),
      centerTitle:
          defaultTargetPlatform == TargetPlatform.android ? false : true,
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme
        .copyWith(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: _kBottleshopBackGroundColor,
    primaryTextTheme: base.primaryTextTheme.merge(workSansTextTheme),
    iconTheme: base.iconTheme.copyWith(color: _kBottleshopOnBackGroundColor),
    primaryIconTheme: base.primaryIconTheme.copyWith(color: Colors.black),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _kBottleshopSecondaryColor)),
      labelStyle: workSansTextTheme.caption!.copyWith(color: Colors.black),
      hintStyle: workSansTextTheme.caption!.copyWith(
        fontStyle: FontStyle.italic,
        color: Colors.grey,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.black,
        onSurface: _kBottleshopSecondaryColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: Colors.black,
        onSurface: _kBottleshopSecondaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _kBottleshopSecondaryColor,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(_kBottleshopSecondaryDarkColor),
      checkColor: MaterialStateProperty.all(_kBottleshopSurfaceDarkColor),
    ),
  );
}

ThemeData buildDarkAppTheme() {
  final base = ThemeData.from(
    colorScheme: const ColorScheme(
      primary: _kBottleshopPrimaryDarkColor,
      primaryContainer: _kBottleshopPrimaryVariantDarkColor,
      onPrimary: _kBottleshopOnPrimaryDark,
      secondary: _kBottleshopSecondaryDarkColor,
      secondaryContainer: _kBottleshopSecondaryVariantDarkColor,
      onSecondary: _kBottleshopOnSecondaryDark,
      background: _kBottleshopBackGroundDarkColor,
      onBackground: _kBottleshopOnBackgroundDark,
      surface: _kBottleshopSurfaceDarkColor,
      onSurface: _kBottleshopOnSurfaceDark,
      error: _kBottleshopErrorDarkColor,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
     textTheme: TextTheme(
      headline2: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFBF8A24),
              decoration: TextDecoration.none),
      headline3: GoogleFonts.publicSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFBF8A24),
              decoration: TextDecoration.none),
      headline4: GoogleFonts.publicSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
        color: Color(0xFFBF8A24),
      ),
      headline5: GoogleFonts.publicSans(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Colors.white,
      )
    ),
  );
  return base.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: base.appBarTheme.copyWith(
      elevation: kIsWeb ? null : 0,
      // foregroundColor: Colors.black,
      backgroundColor: kIsWeb ? Colors.transparent : Colors.transparent,
      titleTextStyle: workSansTextTheme.headline6!
          .copyWith(color: _kBottleshopOnBackgroundDark),
      centerTitle:
          defaultTargetPlatform == TargetPlatform.android ? false : true,
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme
        .copyWith(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: _kBottleshopBackGroundDarkColor,
    primaryTextTheme: base.primaryTextTheme.merge(workSansTextTheme),
    iconTheme: base.iconTheme.copyWith(color: _kBottleshopOnBackgroundDark),
    primaryIconTheme: base.primaryIconTheme.copyWith(color: Colors.white),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _kBottleshopSecondaryDarkColor)),
      labelStyle: workSansTextTheme.caption!.copyWith(color: Colors.white),
      hintStyle: workSansTextTheme.caption!.copyWith(
        fontStyle: FontStyle.italic,
        color: Colors.grey,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(_kBottleshopSecondaryDarkColor),
      checkColor: MaterialStateProperty.all(_kBottleshopSurfaceDarkColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: _kBottleshopSecondaryDarkColor,
        textStyle: workSansTextTheme.button!
            .copyWith(color: _kBottleshopSurfaceDarkColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.white,
        onSurface: _kBottleshopSecondaryDarkColor,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: Colors.white,
        onSurface: _kBottleshopSecondaryDarkColor,
      ),
    ),
  );
}
