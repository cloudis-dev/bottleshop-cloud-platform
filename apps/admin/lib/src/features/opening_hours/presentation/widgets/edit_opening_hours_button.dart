import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_entry_model.dart';
import 'package:bottleshop_admin/src/features/opening_hours/presentation/providers/providers.dart';

class EditOpeningHoursButton extends HookWidget {
  const EditOpeningHoursButton({
    Key? key,
    required this.rowIndex,
  }) : super(key: key);

  final int rowIndex;

  @override
  Widget build(BuildContext context) {
    final openingHoursMap = useProvider(editedHoursProvider).state;
    final todayOpening = openingHoursMap!.today(rowIndex);
    final tempList = [todayOpening.opening, todayOpening.closing];
    final weAreOpen = todayOpening.isOpened();

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: tempList.length,
        itemBuilder: (context, index) {
          return TextButton(
            onPressed: !weAreOpen
                ? null
                : () async {
                    await OpeningHoursEntryModel.pickNewTime(
                      context,
                      tempList,
                      index,
                      rowIndex,
                    );
                  },
            child: Text(tempList[index]),
          );
        },
      ),
    );
  }
}
