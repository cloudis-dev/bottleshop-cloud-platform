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

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/utils/formatting_utils.dart';
import 'package:delivery/src/features/filter/presentation/viewmodels/filter_model.dart';
import 'package:flutter/material.dart';

class FilterFormattingUtils {
  FilterFormattingUtils._();

  static String getAlcoholRangeString(RangeValues alcoholRange) {
    return '${FormattingUtils.getAlcoholNumberString(alcoholRange.start)} - '
        '${FormattingUtils.getAlcoholNumberString(alcoholRange.end)}';
  }

  static String getQuantityRangeString(int minQuantity, BuildContext context) {
    return '$minQuantity - ${context.l10n.max}';
  }

  static String getFilterVolumeRangeString(RangeValues volumeRange, BuildContext context) {
    if (FilterConstants.isVolumeMax(volumeRange.end)) {
      return '${FormattingUtils.getFilterVolumeNumberString(volumeRange.start)} - ${context.l10n.max}';
    } else {
      return '${FormattingUtils.getFilterVolumeNumberString(volumeRange.start)} - '
          '${FormattingUtils.getFilterVolumeNumberString(volumeRange.end)} l';
    }
  }

  static String getPriceRangeString(RangeValues priceRange, BuildContext context) {
    if (FilterConstants.isPriceMax(priceRange.end)) {
      return '${FormattingUtils.getPriceNumberString(priceRange.start)} - ${context.l10n.max}';
    } else {
      return '${FormattingUtils.getPriceNumberString(priceRange.start)} - '
          '${FormattingUtils.getPriceNumberString(priceRange.end, withCurrency: true)}';
    }
  }

  static String getAgeRangeString(int minAge, int? maxAge) {
    return '$minAge - $maxAge';
  }

  static String getYearRangeString(int? minYear, int maxYear) {
    return '$minYear - $maxYear';
  }
}
