import 'package:flutter/material.dart';

class EditOpeningHoursRow extends StatefulWidget {
  const EditOpeningHoursRow({Key? key}) : super(key: key);

  @override
  State<EditOpeningHoursRow> createState() => _EditOpeningHoursRowState();
}

class _EditOpeningHoursRowState extends State<EditOpeningHoursRow> {
  @override
  Widget build(BuildContext context) {
    return Center(
        // child: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       '${sortedWeekDays[index]}: ',
        //       style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     TextButton(
        //       onPressed: () async {
        //         final newTime = await showTimePicker(
        //             context: context, initialTime: currentTime);
        //         todayOpening =
        //             '${newTime?.hour.toString().padLeft(2, '0')}:${newTime?.minute.toString().padLeft(2, '0')}';
        //         timePicker;
        //       },
        //       child: Text(todayOpening[0]),
        //     ),
        //   ],
        // ),
        );
  }
}
