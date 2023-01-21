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

import 'dart:ui';

import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/services/shared_preferences_service.dart';
import 'package:diacritic/diacritic.dart';

class SortingUtil {
  SortingUtil._();

  static int categoryCompare(
    CategoryPlainModel a,
    CategoryPlainModel b,
    LanguageMode lang,
  ) =>
      stringSortCompare(
        a.getName(lang),
        b.getName(lang),
      );

  static int countryCompare(
    CountryModel a,
    CountryModel b,
    LanguageMode lang,
  ) =>
      stringSortCompare(
        a.getName(lang),
        b.getName(lang),
      );

  static int stringSortCompare(String? a, String? b, {bool ascending = true}) {
    if (!ascending) {
      final temp = a;
      a = b;
      b = temp;
    }
    return removeDiacritics(a!.toLowerCase())
        .compareTo(removeDiacritics(b!.toLowerCase()));
  }

  static int numbersSortCompare(double a, double b, {bool ascending = true}) {
    if (!ascending) {
      final temp = a;
      a = b;
      b = temp;
    }
    return a.compareTo(b);
  }
}
