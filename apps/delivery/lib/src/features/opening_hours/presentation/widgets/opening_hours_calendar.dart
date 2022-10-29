import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_today.dart';

class OpeningHoursCalendar extends StatelessWidget {
  const OpeningHoursCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateTime.now();
    final dateFormated = DateFormat('d.MMM.yyyy').format(date);

    return Container(
      color: null,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormated,
              ),
              const OpeningHoursToday(),
            ],
          ),
        ],
      ),
    );
  }
}
