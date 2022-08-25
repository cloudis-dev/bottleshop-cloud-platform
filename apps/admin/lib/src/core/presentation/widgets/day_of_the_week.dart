import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayOfTheWeek extends StatelessWidget {
  DayOfTheWeek({
    Key? key,
    required this.day,
    required this.hours,
  }) : super(key: key);

  String day = '';
  List<dynamic> hours = [];

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final today = DateFormat('EEEE').format(date);

    return Center(
      child: Text(
        (hours[0] == '0' || hours[1] == '0')
            ? '$day: Closed'
            : '$day:  ${hours[0]} - ${hours[1]}',
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
