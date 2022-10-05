import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:flutter/material.dart';

class EditOpeningHoursDayText extends StatelessWidget {
  const EditOpeningHoursDayText({Key? key, required this.rowIndex})
      : super(key: key);

  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.14,
      child: Text(
        '${sortedWeekDays[rowIndex].substring(0, 3)}.: ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
