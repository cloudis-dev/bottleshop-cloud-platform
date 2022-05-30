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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class FormattingUtils {
  FormattingUtils._();

  /// When alcohol has decimal places, single decimal place string is returned.
  /// Otherwise no decimal place string is returned.
  static String getAlcoholNumberString(
    double? alcohol, {
    bool withPercentSign = true,
  }) {
    return getNumberStringWithPrecision(alcohol, 1)! +
        (withPercentSign ? '%' : '');
  }

  static String? getVolumeNumberString(double? volume) {
    return getNumberStringWithPrecision(volume, 2);
  }

  static String? getFilterVolumeNumberString(double volume) {
    return getNumberStringWithPrecision(volume, 1);
  }

  static String getPriceNumberString(
    double price, {
    bool withCurrency = false,
  }) {
    return getNumberStringWithPrecision(price, 2)! + (withCurrency ? ' €' : '');
  }

  static String? getNumberStringWithPrecision(
      double? value, int decimalPlaces) {
    if (value == null) return null;
    return value.toStringAsFixed(decimalPlaces);
  }

  static DateFormat getDateTimeFormatter(Locale locale) {
    return getDateFormatter(locale).add_Hms();
  }

  static DateFormat getDateFormatter(Locale locale) {
    return DateFormat.yMMMMd(locale.languageCode);
  }

  static DateFormat getTimeFormatter(Locale locale) {
    return DateFormat.Hms(locale.languageCode);
  }
}
