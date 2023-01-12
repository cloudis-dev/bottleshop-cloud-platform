import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:flutter/material.dart';

class OpeningHoursUtils {
  static String timeToString(TimeOfDay newTime) {
    return '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';
  }

  static String showClosingTime(String day, OpeningHoursEntryModel hours) {
    return (hours.opening == '0' || hours.closing == '0')
        ? '$day: Closed'
        : '$day:  ${hours.opening} - ${hours.closing}';
  }
}
