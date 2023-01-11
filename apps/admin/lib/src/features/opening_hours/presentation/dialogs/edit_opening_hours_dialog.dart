import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/data/services/services.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_button.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_checkbox.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/widgets/edit_opening_hours_day_text.dart';

class EditOpeningHoursDialog extends HookWidget {
  const EditOpeningHoursDialog({
    Key? key,
    required this.newHours,
  }) : super(key: key);

  final OpeningHoursModel newHours;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        context.read(editedHoursProvider).state = newHours;
      });
      return () => {};
    }, const []);

    final openingHours = useProvider(editedHoursProvider).state;
    final newOpeningHours = context.read(hasChangedProvider).state;
    final openingHoursMap = openingHours?.toMap();

    return SimpleDialog(
      title: Text(
        'Edit Opening Hours',
        textAlign: TextAlign.center,
      ),
      children: [
        if (openingHoursMap != null)
          SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: openingHoursMap.length,
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
              onPressed: newOpeningHours == false
                  ? null
                  : () async {
                      Navigator.of(context).pop();
                      return openingHoursService.updateData(
                        entryModelDocId,
                        OpeningHoursEntryModel.toMap(openingHoursMap!),
                      );
                    },
              child: Text('Edit'),
            ),
          ],
        )
      ],
    );
  }
}
