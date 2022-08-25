import 'package:bottleshop_admin/src/core/utils/math_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormattingUtil {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  FormattingUtil._();

  static String getPriceString(double price) =>
      '${price.toStringAsFixed(2).replaceFirst('.', ',')}€';

  static String getDateString(DateTime date) => _dateFormat.format(date);

  static String getTimeString(DateTime date) => _timeFormat.format(date);

  static String getTimeStringFromTimeOfDay(
          BuildContext context, TimeOfDay time) =>
      time.format(context);

  /// The format is in days:hours:minutes:seconds.
  static String getTimeDifferenceString(Duration duration) {
    final days = duration.inDays;
    final hours = _twoDigits(duration.inHours.remainder(24));
    final minutes = _twoDigits(duration.inMinutes.remainder(60));
    final seconds = _twoDigits(duration.inSeconds.remainder(60));

    return '$days:$hours:$minutes:$seconds';
  }

  static String _twoDigits(int value) {
    if (value >= 10) return '$value';
    return '0$value';
  }

  static String? _getRoundedNumber(double? value, int decimalPlaces) {
    if (value == null) return null;
    if (MathUtil.approximately(value, value.round().toDouble())) {
      return value.round().toString();
    } else {
      return value.toStringAsFixed(decimalPlaces);
    }
  }

  /// When alcohol has decimal places, single decimal place string is returned.
  /// Otherwise no decimal place string is returned.
  static String? getAlcoholNumberString(double? alcohol) {
    return _getRoundedNumber(alcohol, 1);
  }

  static String? getUnitValueString(double? unitValue) {
    return _getRoundedNumber(unitValue, 2);
  }
}
