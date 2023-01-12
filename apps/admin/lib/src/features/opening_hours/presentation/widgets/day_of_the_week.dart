import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/utils/opening_hours_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayOfTheWeek extends StatelessWidget {
  const DayOfTheWeek({
    Key? key,
    required this.day,
    required this.hours,
  }) : super(key: key);

  final String day;
  final OpeningHoursEntryModel? hours;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final today = DateFormat('EEEE').format(date);

    return Center(
      child: Text(
        OpeningHoursUtils.showClosingTime(day, hours!),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          height: 2,
          fontSize: day == today ? 16.5 : 15,
          color: day == today ? Colors.black : null,
        ),
      ),
    );
  }
}
