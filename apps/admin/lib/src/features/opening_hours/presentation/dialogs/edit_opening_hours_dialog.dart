import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_button.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_checkbox.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_day_text.dart';

class EditOpeningHoursDialog extends StatelessWidget {
  const EditOpeningHoursDialog({Key? key}) : super(key: key);

  // final Map<String, dynamic> tempMap;

  @override
  Widget build(BuildContext context) {
    final openingHoursMap = context.read(editHoursProvider).state;
    final openingHoursDoc = FirebaseFirestore.instance
        .collection('opening_hours')
        .doc('USFRRzUNHuYt4mwmjsAM');

    return SimpleDialog(
      title: Text('Edit Opening Hours', textAlign: TextAlign.center),
      children: [
        SizedBox(
          width: double.minPositive,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: openingHoursMap!.length,
            itemBuilder: (context, rowIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  EditOpeningHoursDayText(rowIndex: rowIndex),
                  EditOpeningHoursButton(rowIndex: rowIndex),
                  EditOpeningHoursCheckbox(rowIndex: rowIndex),
                ],
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                return openingHoursDoc.update(openingHoursMap);
              },
              child: Text('Edit'),
            ),
          ],
        )
      ],
    );
  }
}
