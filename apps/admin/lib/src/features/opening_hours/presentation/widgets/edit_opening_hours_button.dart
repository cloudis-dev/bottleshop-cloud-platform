import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/opening_hours/utils/opening_hours_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditOpeningHoursButton extends HookWidget {
  const EditOpeningHoursButton({
    Key? key,
    required this.rowIndex,
  }) : super(key: key);

  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    useProvider(hasChangedProvider).state;

    final currentTime = TimeOfDay.now();
    final openingHoursMap = useProvider(editedHoursProvider).state;
    final todayOpening = openingHoursMap!.today(rowIndex);

    Future<void> pickNewTime(
            OpeningHoursEntryModel Function(String) entryUpdate) =>
        showTimePicker(context: context, initialTime: currentTime).then(
          (newTime) {
            if (newTime != null) {
              final updatedEntry =
                  entryUpdate(OpeningHoursUtils.timeToString(newTime));

              context.read(hasChangedProvider).state = true;
              context.read(editedHoursProvider).state =
                  openingHoursMap.setDay(rowIndex, updatedEntry);
            }
          },
        );

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          TextButton(
            onPressed: todayOpening.isOpened()
                ? null
                : () =>
                    pickNewTime((val) => todayOpening.copyWith(opening: val)),
            child: Text(todayOpening.opening),
          ),
          TextButton(
            onPressed: todayOpening.isOpened()
                ? null
                : () =>
                    pickNewTime((val) => todayOpening.copyWith(closing: val)),
            child: Text(todayOpening.closing),
          ),
        ],
      ),
    );
  }
}
